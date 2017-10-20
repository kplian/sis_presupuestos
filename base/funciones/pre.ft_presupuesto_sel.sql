CREATE OR REPLACE FUNCTION pre.ft_presupuesto_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de presupuesto
 FUNCION: 		pre.ft_presupuesto_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'pre.tpresupuesto'
 AUTOR: 		Gonzalo Sarmiento Sejas
 FECHA:	        26-11-2012 21:35:35
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:
 AUTOR:
 FECHA:
***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;
    v_sql				varchar;
    v_saldos			record;
    v_insertado			record;
    v_partidas			record;
    v_join_ewf			varchar;
    v_filadd			varchar;
    v_join_responsables				varchar;
    v_sw_distinc					varchar;
    --certificacion presupuestaria
    v_nombre_entidad				varchar;
	v_direccion_admin				varchar;
    v_record						record;
    v_index							integer = 0;
    v_record_funcionario			record;
    v_firmas						VARCHAR[];
    v_firma_fun						varchar;
    v_unidad_ejecutora				varchar;
    v_record_sol					record;
    --reporte po
    v_id_gestion					integer;
    v_fecha							varchar;
    v_nro_cite_dce_fin					varchar;
    v_nro_cite_dce_in					varchar;
    v_nro_tramite					varchar;
BEGIN

	v_nombre_funcion = 'pre.ft_presupuesto_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'PRE_PRE_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin
 	#FECHA:		26-11-2012 21:35:35
	***********************************/

	if(p_transaccion='PRE_PRE_SEL')then

    	begin


           v_filadd =  '0 = 0 AND ';
           v_join_responsables = '';
           v_sw_distinc = '';


           IF v_parametros.tipo_interfaz = 'PresupuestoInicio' THEN
             v_join_ewf = 'LEFT';
           ELSE
             v_join_ewf = 'INNER';
           END IF;


           --  si el usuario no es administrador y la interfaz no es PresupuestoInicio
           --  filtramos por el funcionario

           IF v_parametros.tipo_interfaz = 'PresupuestoFor' THEN
                  IF p_administrador !=1 THEN
                      --v_filadd = ' (ewf.id_funcionario='||v_parametros.id_funcionario_usu::varchar||' ) and  (lower(pre.estado)  in (''formulacion'')) and ';
                  	  v_join_responsables = ' INNER JOIN pre.tpresupuesto_funcionario pf  on (pf.id_presupuesto = pre.id_presupuesto  and pf.id_funcionario = '||v_parametros.id_funcionario_usu::varchar||')  ';
                      v_filadd = ' (pf.id_funcionario='||v_parametros.id_funcionario_usu::varchar||' ) and  (lower(pre.estado)  in (''formulacion'')) and ';
                  ELSE
                      v_filadd = ' (lower(pre.estado)  in (''formulacion'')) and ';
                  END IF;
            END IF;

            IF v_parametros.tipo_interfaz = 'PresupuestoVb' THEN
                 IF p_administrador !=1 THEN
                     -- v_filadd = ' (ewf.id_funcionario='||v_parametros.id_funcionario_usu::varchar||' ) and  (lower(pre.estado) not in (''borrador'',''aprobado'',''formulacion'',''vobopre'')) and ';
                  	v_filadd = ' (lower(pre.estado)  in (''vobopre'')) and ';
                  ELSE
                     -- v_filadd = ' (lower(pre.estado) not in (''borrador'',''aprobado'',''formulacion'',''vobopre'')) and ';
                  	v_filadd = ' (lower(pre.estado)  in (''vobopre'')) and ';
                  END IF;
            END IF;

            IF v_parametros.tipo_interfaz = 'PresupuestoAprobacion' THEN
                 IF p_administrador !=1 THEN
                    -- v_filadd = ' (ewf.id_funcionario='||v_parametros.id_funcionario_usu::varchar||' ) and  (lower(pre.estado)  in (''vobopre'')) and ';
                 v_filadd = ' (lower(pre.estado) not in (''borrador'',''aprobado'',''formulacion'',''vobopre'')) and ';
                 ELSE
                      --v_filadd = ' (lower(pre.estado)  in (''vobopre'')) and ';
                 v_filadd = ' (lower(pre.estado) not in (''borrador'',''aprobado'',''formulacion'',''vobopre'')) and ';
                 END IF;
            END IF;


            IF v_parametros.tipo_interfaz = 'PresupuestoReporte' THEN
                IF p_administrador !=1 THEN
                      v_sw_distinc = ' DISTINCT ';
                      -- si noes adminsitrador solo funcionarios autorizados pueden visualizar
                      v_join_responsables = ' INNER JOIN pre.tpresupuesto_funcionario pf  on (pf.id_presupuesto = pre.id_presupuesto  and pf.id_funcionario = '||v_parametros.id_funcionario_usu::varchar||')  ';

                  END IF;
                  v_filadd = ' (lower(pre.estado)  in (''aprobado'')) and ';
             END IF;

            --Sentencia de la consulta
			v_consulta:='select
                              '||v_sw_distinc||'
                              pre.id_presupuesto,
                              pre.id_centro_costo,
                              vcc.codigo_cc,
                              pre.tipo_pres,
                              pre.estado_pres,
                              pre.estado_reg,
                              pre.id_usuario_reg,
                              pre.fecha_reg,
                              pre.fecha_mod,
                              pre.id_usuario_mod,
                              usu1.cuenta as usr_reg,
                              usu2.cuenta as usr_mod,
                              pre.estado,
                              pre.id_estado_wf,
                              pre.nro_tramite,
                              pre.id_proceso_wf,
                              (''(''||tp.codigo||'') ''||tp.nombre||'' Ofc: ''|| upper(tp.sw_oficial))::varchar as desc_tipo_presupuesto,
                              pre.descripcion,
                              tp.movimiento as movimiento_tipo_pres,
                              vcc.id_gestion,
                              ewf.obs::varchar as obs_wf,
                              pre.sw_consolidado,
                              pre.id_categoria_prog,
                              cp.codigo_categoria,
                              array_to_string(vcc.mov_pres,'','')::varchar as mov_pres,
                              array_to_string(vcc.momento_pres,'','')::varchar as momento_pres,
                              vcc.id_uo,
                              vcc.codigo_uo,
                              vcc.nombre_uo,
                              vcc.id_tipo_cc,
                              (''(''||vcc.codigo_tcc ||'') '' ||vcc.descripcion_tcc)::varchar AS desc_tcc,
                              pre.fecha_inicio_pres,
                              pre.fecha_fin_pres
						from pre.tpresupuesto pre
                        inner join param.vcentro_costo vcc on vcc.id_centro_costo=pre.id_centro_costo
						inner join segu.tusuario usu1 on usu1.id_usuario = pre.id_usuario_reg
                        '||v_join_ewf||' join wf.testado_wf ewf on ewf.id_estado_wf = pre.id_estado_wf
                        '||v_join_responsables||'
                        left join pre.ttipo_presupuesto tp on tp.codigo = pre.tipo_pres
						left join segu.tusuario usu2 on usu2.id_usuario = pre.id_usuario_mod
				        left join pre.vcategoria_programatica cp on cp.id_categoria_programatica = pre.id_categoria_prog
                        where  ' ||v_filadd;


			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
             raise notice 'v_consulta %',v_consulta ;


			--Devuelve la respuesta
			return v_consulta;

		end;



	/*********************************
 	#TRANSACCION:  'PRE_PRE_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		Gonzalo Sarmiento Sejas
 	#FECHA:		26-11-2012 21:35:35
	***********************************/

	elsif(p_transaccion='PRE_PRE_CONT')then

		begin

           v_filadd =  '0 = 0 AND ';
           v_join_responsables = '';
           v_sw_distinc = '';


           IF v_parametros.tipo_interfaz = 'PresupuestoInicio' THEN
             v_join_ewf = 'LEFT';
           ELSE
             v_join_ewf = 'INNER';
           END IF;


            --  si el usuario no es administrador y la interfaz no es PresupuestoInicio
            --  filtramos por el funcionario

            IF v_parametros.tipo_interfaz = 'PresupuestoFor' THEN
                  IF p_administrador !=1 THEN
                      v_filadd = ' (ewf.id_funcionario='||v_parametros.id_funcionario_usu::varchar||' ) and  (lower(pre.estado)  in (''formulacion'')) and ';
                  ELSE
                      v_filadd = ' (lower(pre.estado)  in (''formulacion'')) and ';
                  END IF;
            END IF;

            IF v_parametros.tipo_interfaz = 'PresupuestoVb' THEN
                 IF p_administrador !=1 THEN
                      v_filadd = ' (ewf.id_funcionario='||v_parametros.id_funcionario_usu::varchar||' ) and  (lower(pre.estado) not in (''borrador'',''aprobado'',''formulacion'',''vobopre'')) and ';
                  ELSE
                      v_filadd = ' (lower(pre.estado) not in (''borrador'',''aprobado'',''formulacion'',''vobopre'')) and ';
                  END IF;
            END IF;

           IF v_parametros.tipo_interfaz = 'PresupuestoAprobacion' THEN
                 IF p_administrador !=1 THEN
                     v_filadd = ' (ewf.id_funcionario='||v_parametros.id_funcionario_usu::varchar||' ) and  (lower(pre.estado)  in (''vobopre'')) and ';
                 ELSE
                      v_filadd = ' (lower(pre.estado)  in (''vobopre'')) and ';
                 END IF;
            END IF;


            IF v_parametros.tipo_interfaz = 'PresupuestoReporte' THEN

                IF p_administrador !=1 THEN


                      v_sw_distinc = ' DISTINCT ';
                      -- si noes adminsitrador solo funcionarios autorizados pueden visualizar
                      v_join_responsables = ' INNER JOIN pre.tpresupuesto_funcionario pf  on (pf.id_presupuesto = pre.id_presupuesto  and pf.id_funcionario = '||v_parametros.id_funcionario_usu::varchar||')  ';

                  END IF;

                  v_filadd = ' (lower(pre.estado)  in (''aprobado'')) and ';

             END IF;




			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count('||v_sw_distinc||' pre.id_presupuesto)
					    from pre.tpresupuesto pre
				        inner join param.vcentro_costo vcc on vcc.id_centro_costo=pre.id_centro_costo
						inner join segu.tusuario usu1 on usu1.id_usuario = pre.id_usuario_reg
                        '||v_join_ewf||' join wf.testado_wf ewf on ewf.id_estado_wf = pre.id_estado_wf
                        '||v_join_responsables||'
                        left join pre.ttipo_presupuesto tp on tp.codigo = pre.tipo_pres
						left join segu.tusuario usu2 on usu2.id_usuario = pre.id_usuario_mod
                        left join pre.vcategoria_programatica cp on cp.id_categoria_programatica = pre.id_categoria_prog
                        where  ' ||v_filadd;



			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;

			--Devuelve la respuesta
			return v_consulta;

		end;
    /*********************************
 	#TRANSACCION:  'PRE_PREREST_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		Gonzalo Sarmiento
 	#FECHA:		11-05-2017
	***********************************/

	elsif(p_transaccion='PRE_PREREST_SEL')then

    	begin

        v_consulta := 'select DISTINCT pcc.id_centro_costo,
                     substring(pcc.descripcion from 6)
                     from pre.vpresupuesto_cc pcc
                     where pcc.gestion='||v_parametros.gestion||
                     ' and pcc.tipo_pres=''2''
                     and pcc.descripcion not in (''(894) PREVISIONES FINANCIERAS'', ''(845) FLOTA BOA AERONAVES'')
                     order by pcc.id_centro_costo';

        return v_consulta;
        end;

    /*********************************
 	#TRANSACCION:  'PRE_PREREST_CONT'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		Gonzalo Sarmiento
 	#FECHA:		11-05-2017
	***********************************/

	elsif(p_transaccion='PRE_PREREST_CONT')then

    	begin

        v_consulta := 'select DISTINCT count(pcc.id_centro_costo)
                     from pre.vpresupuesto_cc pcc
                     where pcc.gestion='||v_parametros.gestion||
                     ' and pcc.tipo_pres=''2''
                     and pcc.descripcion not in (''(894) PREVISIONES FINANCIERAS'', ''(845) FLOTA BOA AERONAVES'')';

        return v_consulta;
        end;

     /*********************************
 	#TRANSACCION:  'PRE_SALPRE_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		Gonzalo Sarmiento
 	#FECHA:		11-05-2017
	***********************************/


    elsif(p_transaccion='PRE_SALPRE_SEL')then

    	begin
        	if(v_parametros.id_partida='')then
            	v_consulta ='SELECT DISTINCT id_partida from pre.tpresup_partida presupar where presupar.id_presupuesto IN ('||v_parametros.id_presupuesto||')';
                FOR v_partidas IN EXECUTE (v_consulta)
                LOOP
                	v_parametros.id_partida=v_partidas.id_partida;
                END LOOP;
			end if;
        	--1. Crear tabla temporal
            v_sql = 'create temp table tt_pres_saldo(
            			id_presupuesto integer,
                        id_partida integer,
                        monto_presup numeric(18,2),
                        monto_ejec numeric(18,2),
                        mes numeric,
                        centro_costo varchar(20),
                        moneda varchar(30)
            		)
            	';
            execute (v_sql);
            --b. Crear tabla para presupuesto anual
            v_sql='create temp table tt_presup_anual(id_partida integer,id_presupuesto integer,
            centro_costo varchar(20), moneda varchar(30),
            presup_ene numeric, ejec_ene numeric, presup_feb numeric, ejec_feb numeric,
            presup_mar numeric, ejec_mar numeric, presup_abr numeric, ejec_abr numeric,
            presup_may numeric, ejec_may numeric, presup_jun numeric, ejec_jun numeric,
            presup_jul numeric, ejec_jul numeric, presup_ago numeric, ejec_ago numeric,
            presup_sep numeric, ejec_sep numeric, presup_oct numeric, ejec_oct numeric,
            presup_nov numeric, ejec_nov numeric, presup_dic numeric, ejec_dic numeric)';
			execute(v_sql);

            --2. Obtener los montos presupuestados
            v_sql = 'insert into tt_pres_saldo(id_presupuesto, id_partida, monto_presup, mes, centro_costo,moneda)
            		select
                    pre.id_presupuesto, presupart.id_partida, sum(presupart.importe),
                    date_part(''month'',presupart.fecha_hora) as mes,
                    cen.codigo as centro_costo,
                    par.moneda
                    from pre.tpresupuesto pre
                    inner join pre.tpresup_partida presupart on presupart.id_presupuesto=pre.id_presupuesto
                    left join gem.tcentro_costo cen on cen.id_centro_costo=presupart.id_centro_costo
                    inner join param.tmoneda par on par.id_moneda=presupart.id_moneda
                    where presupart.tipo = ''presupuestado'' and pre.id_presupuesto IN ('||v_parametros.id_presupuesto||')
                        and presupart.fecha_hora BETWEEN '''||v_parametros.fecha_ini||''' AND '''||v_parametros.fecha_fin||'''
                        and presupart.id_partida IN ('||v_parametros.id_partida||')
                    group by pre.id_presupuesto, presupart.id_partida, mes, centro_costo, par.moneda';
            execute(v_sql);

            --3. Obtener los montos ejecutados
            v_sql = 'update tt_pres_saldo set
                    monto_ejec = ff.ejecutado
                    from (select
                    pre.id_presupuesto, presupart.id_partida, sum(presupart.importe) as ejecutado,
                    date_part(''month'',presupart.fecha_hora) as mes
                    from pre.tpresupuesto pre
                    inner join pre.tpresup_partida presupart
                    on presupart.id_presupuesto=pre.id_presupuesto
                    where presupart.tipo = ''ejecutado'' and pre.id_presupuesto IN ('||v_parametros.id_presupuesto||')
                    and presupart.fecha_hora BETWEEN '''||v_parametros.fecha_ini||''' AND '''||v_parametros.fecha_fin||'''
                        and presupart.id_partida IN ('||v_parametros.id_partida||')
                    group by pre.id_presupuesto, presupart.id_partida,mes) ff
                    where tt_pres_saldo.id_presupuesto = ff.id_presupuesto
                    and tt_pres_saldo.id_partida = ff.id_partida and tt_pres_saldo.mes=ff.mes';
            execute (v_sql);

    		--Sentencia de la consulta
			v_consulta:='select * from tt_pres_saldo';

            FOR v_saldos IN EXECUTE (v_consulta)
            LOOP
                select * into v_insertado from tt_presup_anual where id_partida=v_saldos.id_partida and id_presupuesto=v_saldos.id_presupuesto;
                IF NOT FOUND THEN
                	insert into tt_presup_anual(id_partida,id_presupuesto,centro_costo,moneda)values(
                	v_saldos.id_partida,v_saldos.id_presupuesto,v_saldos.centro_costo,v_saldos.moneda);
                END IF;
                if(trunc(v_saldos.mes)=1)then
                  update tt_presup_anual set presup_ene=v_saldos.monto_presup, ejec_ene=v_saldos.monto_ejec
                   where id_partida=v_saldos.id_partida and id_presupuesto=v_saldos.id_presupuesto;
                elsif(trunc(v_saldos.mes)=2)then
				  update tt_presup_anual set presup_feb=v_saldos.monto_presup, ejec_feb=v_saldos.monto_ejec
                   where id_partida=v_saldos.id_partida and id_presupuesto=v_saldos.id_presupuesto;
                elsif(trunc(v_saldos.mes)=3)then
                  update tt_presup_anual set presup_mar=v_saldos.monto_presup, ejec_mar=v_saldos.monto_ejec
                   where id_partida=v_saldos.id_partida and id_presupuesto=v_saldos.id_presupuesto;
                elsif(trunc(v_saldos.mes)=4)then
                  update tt_presup_anual set presup_abr=v_saldos.monto_presup, ejec_abr=v_saldos.monto_ejec
                   where id_partida=v_saldos.id_partida and id_presupuesto=v_saldos.id_presupuesto;
                elsif(trunc(v_saldos.mes)=5)then
                  update tt_presup_anual set presup_may=v_saldos.monto_presup, ejec_may=v_saldos.monto_ejec
                   where id_partida=v_saldos.id_partida and id_presupuesto=v_saldos.id_presupuesto;
                elsif(trunc(v_saldos.mes)=6)then
                  update tt_presup_anual set presup_jun=v_saldos.monto_presup, ejec_jun=v_saldos.monto_ejec
                   where id_partida=v_saldos.id_partida and id_presupuesto=v_saldos.id_presupuesto;
                elsif(trunc(v_saldos.mes)=7)then
                  update tt_presup_anual set presup_jul=v_saldos.monto_presup, ejec_jul=v_saldos.monto_ejec
                   where id_partida=v_saldos.id_partida and id_presupuesto=v_saldos.id_presupuesto;
                elsif(trunc(v_saldos.mes)=8)then
                  update tt_presup_anual set presup_ago=v_saldos.monto_presup, ejec_ago=v_saldos.monto_ejec
                   where id_partida=v_saldos.id_partida and id_presupuesto=v_saldos.id_presupuesto;
                elsif(trunc(v_saldos.mes)=9)then
                  update tt_presup_anual set presup_sep=v_saldos.monto_presup, ejec_sep=v_saldos.monto_ejec
                   where id_partida=v_saldos.id_partida and id_presupuesto=v_saldos.id_presupuesto;
                elsif(trunc(v_saldos.mes)=10)then
                  update tt_presup_anual set presup_oct=v_saldos.monto_presup, ejec_oct=v_saldos.monto_ejec
                   where id_partida=v_saldos.id_partida and id_presupuesto=v_saldos.id_presupuesto;
                elsif(trunc(v_saldos.mes)=11)then
                  update tt_presup_anual set presup_nov=v_saldos.monto_presup, ejec_nov=v_saldos.monto_ejec
                   where id_partida=v_saldos.id_partida and id_presupuesto=v_saldos.id_presupuesto;
                else
                  update tt_presup_anual set presup_dic=v_saldos.monto_presup, ejec_dic=v_saldos.monto_ejec
                   where id_partida=v_saldos.id_partida and id_presupuesto=v_saldos.id_presupuesto;
                end if;
            END LOOP;
            v_consulta:='select presanu.id_partida, par.codigo as codigo_part,
             presanu.id_presupuesto, pre.codigo as codigo_pres,presanu.centro_costo,
             presanu.moneda, presup_ene, ejec_ene,
             presup_feb, ejec_feb, presup_mar, ejec_mar, presup_abr, ejec_abr,
             presup_may, ejec_may, presup_jun, ejec_jun, presup_jul, ejec_jul,
             presup_ago, ejec_ago, presup_sep, ejec_sep, presup_oct, ejec_oct,
             presup_nov, ejec_nov, presup_dic, ejec_dic from tt_presup_anual presanu
             inner join pre.tpartida par on par.id_partida=presanu.id_partida
             inner join pre.tpresupuesto pre on pre.id_presupuesto=presanu.id_presupuesto';

			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'PRE_CBMPRES_SEL'
 	#DESCRIPCION:  Consulta de presupeustos para combo rec
 	#AUTOR:		rac
 	#FECHA:		14-04-2016 22:53:59
	***********************************/
	elseif(p_transaccion='PRE_CBMPRES_SEL')then

    	begin
    		--Sentencia de la consulta
			v_consulta:='SELECT
                              id_centro_costo,
                              estado_reg,
                              id_ep,
                              id_gestion,
                              id_uo,
                              id_usuario_reg,
                              fecha_reg,
                              id_usuario_mod,
                              fecha_mod,
                              usr_reg,
                              usr_mod,
                              codigo_uo,
                              nombre_uo,
                              ep,
                              gestion,
                              codigo_cc,
                              nombre_programa,
                              nombre_proyecto,
                              nombre_actividad,
                              nombre_financiador,
                              nombre_regional,
                              tipo_pres,
                              cod_act,
                              cod_fin,
                              cod_prg,
                              cod_pry,
                              estado_pres,
                              estado,
                              id_presupuesto,
                              id_estado_wf,
                              nro_tramite,
                              id_proceso_wf,
                              movimiento_tipo_pres,
                              desc_tipo_presupuesto,
                              sw_oficial,
                              sw_consolidado
                            FROM
                              pre.vpresupuesto_cc
						 where  ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'PRE_CBMPRES_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		rac
 	#FECHA:		14-04-2016 22:53:59
	***********************************/

	elsif(p_transaccion='PRE_CBMPRES_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='SELECT count(id_presupuesto)
					     FROM pre.vpresupuesto_cc
						 WHERE ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;

			--Devuelve la respuesta
			return v_consulta;

        end;

    /*********************************
 	#TRANSACCION:  'PR_REPCERPRE_SEL'
 	#DESCRIPCION:	Reporte Certificación Presupuestaria
 	#AUTOR:		FEA
 	#FECHA:		14-07-2017 11:00
	***********************************/

	elsif(p_transaccion='PR_REPCERPRE_SEL')then

		begin

            SELECT ts.estado, ts.id_estado_wf, ts.justificacion
            INTO v_record_sol
            FROM adq.tsolicitud ts
            WHERE ts.id_proceso_wf = v_parametros.id_proceso_wf;

            IF(v_record_sol.estado='suppresu' OR v_record_sol.estado='vbrpc' OR v_record_sol.estado = 'aprobado' OR v_record_sol.estado = 'proceso' OR v_record_sol.estado = 'finalizado')THEN
              v_index = 1;
              FOR v_record IN (WITH RECURSIVE firmas(id_estado_fw, id_estado_anterior,fecha_reg, codigo, id_funcionario) AS (
                                SELECT tew.id_estado_wf, tew.id_estado_anterior , tew.fecha_reg, te.codigo, tew.id_funcionario
                                FROM wf.testado_wf tew
                                INNER JOIN wf.ttipo_estado te ON te.id_tipo_estado = tew.id_tipo_estado
                                WHERE tew.id_estado_wf = v_record_sol.id_estado_wf

                                UNION ALL

                                SELECT ter.id_estado_wf, ter.id_estado_anterior, ter.fecha_reg, te.codigo, ter.id_funcionario
                                FROM wf.testado_wf ter
                                INNER JOIN firmas f ON f.id_estado_anterior = ter.id_estado_wf
                                INNER JOIN wf.ttipo_estado te ON te.id_tipo_estado = ter.id_tipo_estado
                                WHERE f.id_estado_anterior IS NOT NULL
                            )SELECT distinct on (codigo) codigo, fecha_reg , id_estado_fw, id_estado_anterior, id_funcionario FROM firmas ORDER BY codigo, fecha_reg ASC) LOOP
                  IF(v_record.codigo = 'vbpoa' OR v_record.codigo = 'suppresu' OR v_record.codigo = 'vbpresupuestos' OR v_record.codigo = 'vbrpc')THEN
                    SELECT vf.desc_funcionario1, vf.nombre_cargo, vf.oficina_nombre
                    INTO v_record_funcionario
                    FROM orga.vfuncionario_cargo_lugar vf
                    WHERE vf.id_funcionario = v_record.id_funcionario;
                    v_firmas[v_index] = v_record.codigo::VARCHAR||','||v_record.fecha_reg::VARCHAR||','||v_record_funcionario.desc_funcionario1::VARCHAR||','||v_record_funcionario.nombre_cargo::VARCHAR||','||v_record_funcionario.oficina_nombre;
                    v_index = v_index + 1;
                  END IF;
              END LOOP;
            	v_firma_fun = array_to_string(v_firmas,';');
            ELSE
            	v_firma_fun = '';
        	END IF;
        		------
            SELECT (''||te.codigo||' '||te.nombre)::varchar
            INTO v_nombre_entidad
            FROM param.tempresa te;
            ------
            SELECT (''||tda.codigo||' '||tda.nombre)::varchar
            INTO v_direccion_admin
            FROM pre.tdireccion_administrativa tda;
			------
            SELECT (''||tue.codigo||' '||tue.nombre)::varchar
            INTO v_unidad_ejecutora
            FROM pre.tunidad_ejecutora tue;
            ---

			--Sentencia de la consulta de conteo de registros
			v_consulta:='
            SELECT vcp.id_categoria_programatica AS id_cp,  ttc.codigo AS centro_costo,
            vcp.codigo_programa , vcp.codigo_proyecto, vcp.codigo_actividad, vcp.codigo_fuente_fin, vcp.codigo_origen_fin,
            tpar.codigo AS codigo_partida, tpar.nombre_partida , tcg.codigo AS codigo_cg,  tcg.nombre AS nombre_cg,
            sum(tsd.precio_total) AS precio_total,tmo.codigo AS codigo_moneda, ts.num_tramite,
            '''||v_nombre_entidad||'''::varchar AS nombre_entidad,
            COALESCE('''||v_direccion_admin||'''::varchar, '''') AS direccion_admin,
            '''||v_unidad_ejecutora||'''::varchar AS unidad_ejecutora,
            COALESCE('''||v_firma_fun||'''::varchar, '''') AS firmas,
            COALESCE('''||v_record_sol.justificacion||'''::varchar,'''') AS justificacion,
            COALESCE(tet.codigo::varchar,''00''::varchar) AS codigo_transf,
            (uo.codigo||''-''||uo.nombre_unidad)::varchar as unidad_solicitante,
            fun.desc_funcionario1::varchar as funcionario_solicitante,
            COALESCE(ts.fecha_soli,null::date) AS fecha_soli,
            COALESCE(tg.gestion, (extract(year from now()::date))::integer) AS gestion,
            ts.codigo_poa,
            (select  pxp.list(distinct ob.codigo|| '' ''||ob.descripcion||'' '')
            from pre.tobjetivo ob
            where ob.codigo = ANY (string_to_array(ts.codigo_poa,'',''))

            )::varchar as codigo_descripcion
            FROM adq.tsolicitud ts
            INNER JOIN adq.tsolicitud_det tsd ON tsd.id_solicitud = ts.id_solicitud
            INNER JOIN pre.tpartida tpar ON tpar.id_partida = tsd.id_partida

            inner join param.tgestion tg on tg.id_gestion = ts.id_gestion

            INNER JOIN pre.tpresup_partida tpp ON tpp.id_partida = tpar.id_partida AND tpp.id_centro_costo = tsd.id_centro_costo

            INNER JOIN param.tcentro_costo tcc ON tcc.id_centro_costo = tsd.id_centro_costo
            INNER JOIN param.ttipo_cc ttc ON ttc.id_tipo_cc = tcc.id_tipo_cc

            INNER JOIN pre.tpresupuesto	tp ON tp.id_presupuesto = tpp.id_presupuesto
            INNER JOIN pre.vcategoria_programatica vcp ON vcp.id_categoria_programatica = tp.id_categoria_prog

            INNER JOIN pre.tclase_gasto_partida tcgp ON tcgp.id_partida = tpp.id_partida
            INNER JOIN pre.tclase_gasto tcg ON tcg.id_clase_gasto = tcgp.id_clase_gasto

            INNER JOIN param.tmoneda tmo ON tmo.id_moneda = ts.id_moneda

            inner join orga.vfuncionario fun on fun.id_funcionario = ts.id_funcionario
            inner join orga.tuo uo on uo.id_uo = ts.id_uo

            left JOIN pre.tpresupuesto_partida_entidad tppe ON tppe.id_partida = tpar.id_partida AND tppe.id_presupuesto = tp.id_presupuesto
            left JOIN pre.tentidad_transferencia tet ON tet.id_entidad_transferencia = tppe.id_entidad_transferencia

            WHERE tsd.estado_reg = ''activo'' AND ts.id_proceso_wf = '||v_parametros.id_proceso_wf;

			v_consulta =  v_consulta || ' GROUP BY vcp.id_categoria_programatica, tpar.codigo, ttc.codigo,vcp.codigo_programa,vcp.codigo_proyecto, vcp.codigo_actividad,
            vcp.codigo_fuente_fin, vcp.codigo_origen_fin, tpar.nombre_partida, tcg.codigo, tcg.nombre, tmo.codigo, ts.num_tramite, tet.codigo, unidad_solicitante, funcionario_solicitante,
            ts.fecha_soli, tg.gestion, ts.codigo_poa';
			v_consulta =  v_consulta || ' ORDER BY tpar.codigo, tcg.nombre, vcp.id_categoria_programatica, ttc.codigo asc ';
			--Devuelve la respuesta
            RAISE NOTICE 'v_consulta %',v_consulta;
			return v_consulta;

        end;
    /*********************************
 	#TRANSACCION:  'PR_REPPOA_SEL'
 	#DESCRIPCION:	REPORTE POA
 	#AUTOR:		F.E.A.
 	#FECHA:		31-07-2017 09:00:59
	***********************************/

	elsif(p_transaccion='PR_REPPOA_SEL')then

		begin
			--Sentencia de la consulta de conteo de registros

             --Obtenemos la gestion

            SELECT vcc.id_gestion
            INTO v_id_gestion
            FROM pre.tpresupuesto tp
        	INNER JOIN param.vcentro_costo vcc on vcc.id_centro_costo = tp.id_centro_costo
            WHERE tp.id_proceso_wf = v_parametros.id_proceso_wf;
			v_consulta:='select
            			obj.id_objetivo,
                        obj.id_objetivo_fk,
                        obj.codigo,
						obj.nivel_objetivo,
                        COALESCE(pre.f_get_arbol(obj.id_objetivo, ''CONT_HIJOS'')::integer,0::integer) AS hijos,
                        COALESCE(pre.f_get_arbol(obj.id_objetivo, ''CONT_NIETOS'')::integer,0::integer) AS nietos,
                        COALESCE(pre.f_get_arbol(obj.id_objetivo, ''CONT_HERMANOS'')::integer,0::integer) AS hermanos,
						obj.sw_transaccional,
						obj.cantidad_verificacion,
						obj.unidad_verificacion,
						obj.ponderacion,
						obj.fecha_inicio,
						obj.tipo_objetivo,
						obj.descripcion,
						obj.linea_base,
						obj.indicador_logro,

						obj.periodo_ejecucion,
						obj.producto,
						obj.fecha_fin,
                        tg.gestion::varchar
						from pre.tobjetivo obj
						inner join segu.tusuario usu1 on usu1.id_usuario = obj.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = obj.id_usuario_mod
                        INNER JOIN param.tgestion tg ON tg.id_gestion = obj.id_gestion
				        where  obj.estado_reg = ''activo'' AND obj.id_gestion = '||v_id_gestion;

			--Definicion de la respuesta
			v_consulta:=v_consulta||'  order by obj.codigo ASC ';
			raise notice 'v_consulta: %',v_consulta;
			--Devuelve la respuesta
			return v_consulta;

        end;
    /*********************************
 	#TRANSACCION:  'PR_NOTA_SEL'
 	#DESCRIPCION:	NOTA INTERNA
 	#AUTOR:		MMV
 	#FECHA:		3-08-2017 09:00:59
	***********************************/

	elsif(p_transaccion='PR_NOTA_SEL')then

        begin

          SELECT to_char(twf.fecha_reg,'DD/MM/YYYY')
          INTO
          v_fecha
          FROM wf.testado_wf twf
          INNER JOIN wf.ttipo_estado te ON te.id_tipo_estado = twf.id_tipo_estado
          WHERE twf.id_proceso_wf = v_parametros.id_proceso_wf  AND te.codigo = 'vobopre';

        select p.nro_tramite
        into
        v_nro_tramite
        from pre.tpresupuesto p
        WHERE p.id_proceso_wf = v_parametros.id_proceso_wf;
        v_nro_cite_dce_fin = 'OB.CP.NI.FP.'||ltrim(substr(v_nro_tramite,7,8),'0');
        v_nro_cite_dce_in = 'OB.CP.NI.IP.'||ltrim(substr(v_nro_tramite,7,8),'0');




			v_consulta:='select  initcap(fg.desc_funcionario1)::varchar as desc_funcionario1,
                                  fg.nombre_cargo,
                                  initcap(f.desc_funcionario1)::varchar as funcionario_gerencia,
                                  f.nombre_cargo as cargo_gerencia,
                                  COALESCE(p.nro_cite_inicio,'''||v_nro_cite_dce_fin||''')::varchar as nro_cite_inicio,
                                  COALESCE(p.nro_cite_fin,'''||v_nro_cite_dce_in||''')::varchar as nro_cite_fin,
                                  '''||COALESCE(v_fecha,'vobopre')||'''::varchar as fecha_nota,
                                  g.gestion
                                  from pre.tpresupuesto p
                                  inner join pre.tpresupuesto_funcionario pf on pf.id_presupuesto = p.id_presupuesto and pf.accion = ''responsable''
                                  inner join orga.vfuncionario_cargo f on f.id_funcionario = pf.id_funcionario and (f.fecha_finalizacion is null OR f.fecha_finalizacion >= now()::date)
                                  inner join orga.testructura_uo ou on ou.id_uo_hijo = f.id_uo
                                  inner join orga.vfuncionario_cargo fg on fg.id_uo = ou.id_uo_padre and (fg.fecha_finalizacion is null OR fg.fecha_finalizacion >= now()::date)
                                  inner join pre.tcategoria_programatica ca on ca.id_categoria_programatica = p.id_categoria_prog
                                  inner join param.tgestion g on g.id_gestion = ca.id_gestion
                                  where p.id_proceso_wf = '||v_parametros.id_proceso_wf;

			--Devuelve la respuesta
			return v_consulta;

        end;


    else

		raise exception 'Transaccion inexistente';

	end if;

EXCEPTION

	WHEN OTHERS THEN
			v_resp='';
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje',SQLERRM);
			v_resp = pxp.f_agrega_clave(v_resp,'codigo_error',SQLSTATE);
			v_resp = pxp.f_agrega_clave(v_resp,'procedimientos',v_nombre_funcion);
			raise exception '%',v_resp;
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;
