--------------- SQL ---------------

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
                              pre.descripcion	,
                              tp.movimiento as movimiento_tipo_pres,
                              vcc.id_gestion,
                              ewf.obs::varchar as obs_wf,
                              pre.sw_consolidado,
                              pre.id_categoria_prog,
                              cp.codigo_categoria
						from pre.tpresupuesto pre
						inner join segu.tusuario usu1 on usu1.id_usuario = pre.id_usuario_reg
                        '||v_join_ewf||' join wf.testado_wf ewf on ewf.id_estado_wf = pre.id_estado_wf
                        '||v_join_responsables||'
                        left join pre.ttipo_presupuesto tp on tp.codigo = pre.tipo_pres
						left join segu.tusuario usu2 on usu2.id_usuario = pre.id_usuario_mod
				        left join param.vcentro_costo vcc on vcc.id_centro_costo=pre.id_centro_costo
                        left join pre.vcategoria_programatica cp on cp.id_categoria_programatica = pre.id_categoria_prog
                        where  ' ||v_filadd;
                       
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
             raise notice '%',v_consulta ;
             
           
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
						inner join segu.tusuario usu1 on usu1.id_usuario = pre.id_usuario_reg
                        '||v_join_ewf||' join wf.testado_wf ewf on ewf.id_estado_wf = pre.id_estado_wf
                        '||v_join_responsables||'
                        left join pre.ttipo_presupuesto tp on tp.codigo = pre.tipo_pres
						left join segu.tusuario usu2 on usu2.id_usuario = pre.id_usuario_mod
				        left join param.vcentro_costo vcc on vcc.id_centro_costo=pre.id_centro_costo
                        left join pre.vcategoria_programatica cp on cp.id_categoria_programatica = pre.id_categoria_prog
                        where  ' ||v_filadd;
			
			--Definicion de la respuesta		    
			v_consulta:=v_consulta||v_parametros.filtro;

			--Devuelve la respuesta
			return v_consulta;

		end;
        
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