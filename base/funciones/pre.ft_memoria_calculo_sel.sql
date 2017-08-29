CREATE OR REPLACE FUNCTION pre.ft_memoria_calculo_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Presupuesto
 FUNCION: 		pre.ft_memoria_calculo_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'pre.tmemoria_calculo'
 AUTOR: 		 (admin)
 FECHA:	        01-03-2016 14:22:24
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
    v_filtro			varchar;
    v_ordenacion		varchar;
    v_titulares			varchar;
    v_grupos			varchar;

BEGIN

	v_nombre_funcion = 'pre.ft_memoria_calculo_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'PRE_MCA_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin
 	#FECHA:		01-03-2016 14:22:24
	***********************************/

	if(p_transaccion='PRE_MCA_SEL')then

    	begin
    		--Sentencia de la consulta
			v_consulta:='select
                            mca.id_memoria_calculo,
                            mca.id_concepto_ingas,
                            mca.importe_total,
                            mca.obs,
                            mca.id_presupuesto,
                            mca.estado_reg,
                            mca.id_usuario_ai,
                            mca.fecha_reg,
                            mca.usuario_ai,
                            mca.id_usuario_reg,
                            mca.fecha_mod,
                            mca.id_usuario_mod,
                            usu1.cuenta as usr_reg,
                            usu2.cuenta as usr_mod,
                            cig.desc_ingas::varchar as desc_ingas,
                            par.id_partida,
                            (par.codigo||'' - ''|| par.nombre_partida)::varchar as desc_partida,
                            ges.gestion::varchar as desc_gestion
						from pre.tmemoria_calculo mca
                        inner join pre.tpresupuesto pre on pre.id_presupuesto = mca.id_presupuesto
                        inner join param.tcentro_costo cc on cc.id_centro_costo = pre.id_centro_costo
                        inner join param.tconcepto_ingas cig on cig.id_concepto_ingas = mca.id_concepto_ingas
                        inner join pre.tconcepto_partida cp on cp.id_concepto_ingas = mca.id_concepto_ingas
                        inner join param.tgestion ges on ges.id_gestion = cc.id_gestion
                        inner join pre.tpartida par on par.id_partida = cp.id_partida and par.id_gestion = cc.id_gestion
                        inner join segu.tusuario usu1 on usu1.id_usuario = mca.id_usuario_reg
                        left join segu.tusuario usu2 on usu2.id_usuario = mca.id_usuario_mod
				        where  ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'PRE_MCA_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin
 	#FECHA:		01-03-2016 14:22:24
	***********************************/

	elsif(p_transaccion='PRE_MCA_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_memoria_calculo)
                        from pre.tmemoria_calculo mca
                        inner join pre.tpresupuesto pre on pre.id_presupuesto = mca.id_presupuesto
                        inner join param.tcentro_costo cc on cc.id_centro_costo = pre.id_centro_costo
                        inner join param.tconcepto_ingas cig on cig.id_concepto_ingas = mca.id_concepto_ingas
                        inner join pre.tconcepto_partida cp on cp.id_concepto_ingas = mca.id_concepto_ingas
                        inner join param.tgestion ges on ges.id_gestion = cc.id_gestion
                        inner join pre.tpartida par on par.id_partida = cp.id_partida and par.id_gestion = cc.id_gestion
                        inner join segu.tusuario usu1 on usu1.id_usuario = mca.id_usuario_reg
                        left join segu.tusuario usu2 on usu2.id_usuario = mca.id_usuario_mod
                        where  ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;

			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'PRE_MEMCAL_REP'
 	#DESCRIPCION:	Consulta de datos para reporte de memoria
 	#AUTOR:		RAC (KPLIAN)
 	#FECHA:		22-04-2016 14:22:24
	***********************************/

	elseif(p_transaccion='PRE_MEMCAL_REP')then

    	begin

           v_filtro = ' id_gestion =  '||v_parametros.id_gestion;
           v_ordenacion = '';
           v_titulares = '';
           v_grupos = '';

            IF v_parametros.id_partida != 0 and v_parametros.id_partida is not null THEN
                v_filtro = v_filtro||'  and id_partida = '||v_parametros.id_partida;
            END IF;

            --filtro de por tipo de presupeustos
            v_filtro = v_filtro||'  and codigo_tipo_pres::integer in ('||v_parametros.tipo_pres||')';



            IF v_parametros.tipo_reporte = 'presupuesto'  THEN

                 IF  v_parametros.id_presupuesto != 0 and v_parametros.id_presupuesto is not null THEN
                    v_filtro = v_filtro||' and id_presupuesto = '||v_parametros.id_presupuesto;
                 END IF;

                v_titulares = 'id_presupuesto as id_concepto,
                               codigo_cc::varchar as concepto,';

                v_grupos = 'id_presupuesto,
                               codigo_cc,';
                v_ordenacion = 'id_presupuesto asc,';


            ELSEIF v_parametros.tipo_reporte = 'categoria'  THEN

                IF  v_parametros.id_categoria_programatica != 0 and v_parametros.id_categoria_programatica is not null THEN
                    v_filtro = v_filtro||' and id_categoria_programatica = '||v_parametros.id_categoria_programatica;
                 END IF;

                v_titulares = 'id_categoria_programatica as id_concepto,
                               codigo_categoria::varchar as concepto,';
                v_grupos = 'id_categoria_programatica,
                					codigo_categoria,';
                v_ordenacion = 'id_categoria_programatica asc,';


            ELSEIF v_parametros.tipo_reporte = 'programa'  THEN

                 IF  v_parametros.id_cp_programa != 0 and v_parametros.id_cp_programa is not null THEN
                    v_filtro = v_filtro||' and id_cp_programa = '||v_parametros.id_cp_programa;
                 END IF;



                v_titulares = 'id_cp_programa as id_concepto,
                               desc_programa::varchar as concepto,';
                v_grupos = 'id_cp_programa,
                				desc_programa,';
                v_ordenacion = 'id_cp_programa asc,';

            END IF;


    		--Sentencia de la consulta
			v_consulta:='SELECT
                            '||v_titulares||'

                            id_concepto_ingas,
                            id_partida,
                            codigo_partida,
                            nombre_partida,
                            descripcion_pres,
                            desc_ingas,
                            justificacion,
                            unidad_medida,
                            importe_unitario,
                            cantidad_mem,
                            sum(importe) as importe
                          FROM
                            pre.vmemoria_por_categoria
                          WHERE '||v_filtro||'
                          group by

                              '||v_grupos||'

                              id_concepto_ingas,
                              id_partida,
                              codigo_partida,
                              nombre_partida,
                              descripcion_pres,
                              desc_ingas,
                              justificacion,
                              unidad_medida,
                              importe_unitario,
                              cantidad_mem,
                              importe

                          order by

                              '||v_ordenacion||'
                              codigo_partida asc ';

			raise notice '..... % ......', v_consulta;
			 --  Devuelve la respuesta
			return v_consulta;

		end;

    /*********************************
 	#TRANSACCION:  'PRE_MEWF_REP'
 	#DESCRIPCION:	Consulta de datos para reporte de memoria por wf
 	#AUTOR:		MMV
 	#FECHA:		26/7/2017
	***********************************/
    elseif(p_transaccion='PRE_MEWF_REP')then

    	begin
        v_consulta:='SELECT
                            m.id_presupuesto as id_concepto,
                            m.codigo_cc::varchar as concepto,
                            m.id_concepto_ingas,
                            m.id_partida,
                            m.codigo_partida,
                            m.nombre_partida,
                            m.descripcion_pres,
                            m.desc_ingas,
                            m.justificacion,
                            m.unidad_medida,
                            m.importe_unitario,
                            m.cantidad_mem,
                            sum(m.importe) as importe,
                            g.gestion
                          FROM pre.vmemoria_por_categoria m
						  INNER JOIN pre.vpresupuesto p on p.id_presupuesto = m.id_presupuesto
                          INNER JOIN param.tgestion g on g.id_gestion = m.id_gestion
                          WHERE p.id_proceso_wf  = '||v_parametros.id_proceso_wf||'
                          group by
                              m.id_presupuesto,
                              m.codigo_cc,
                              m.id_concepto_ingas,
                              m.id_partida,
                              m.codigo_partida,
                              m.nombre_partida,
                              m.descripcion_pres,
                              m.desc_ingas,
                              m.justificacion,
                              m.unidad_medida,
                              m.importe_unitario,
                              m.cantidad_mem,
                              m.importe,
                              g.gestion
                          order by
                              m.id_presupuesto asc,
                              m.codigo_partida asc ';

        raise notice '..... % ......', v_consulta;
		--  Devuelve la respuesta
		return v_consulta;
    end;
    /*********************************
 	#TRANSACCION:  'PRE_MECALMEN_REP'
 	#DESCRIPCION:	Consulta de datos para reporte de memoria calculo mensual
 	#AUTOR:		FRANKLIN ESPINOZA
 	#FECHA:		03/08/2017
	***********************************/
    elseif(p_transaccion='PRE_MECALMEN_REP')then

    	begin
    	IF(v_parametros.tipo_rep = 'periodos')THEN
        	v_filtro = ' id_gestion =  '||v_parametros.id_gestion;
           v_ordenacion = '';
           v_titulares = '';
           v_grupos = '';

            IF v_parametros.id_partida != 0 and v_parametros.id_partida is not null THEN
                v_filtro = v_filtro||'  and id_partida = '||v_parametros.id_partida;
            END IF;

            --filtro de por tipo de presupeustos
            v_filtro = v_filtro||'  and codigo_tipo_pres::integer in ('||v_parametros.tipo_pres||')';



            IF v_parametros.tipo_reporte = 'presupuesto'  THEN

                 IF  v_parametros.id_presupuesto != 0 and v_parametros.id_presupuesto is not null THEN
                    v_filtro = v_filtro||' and id_presupuesto = '||v_parametros.id_presupuesto;
                 END IF;

                v_titulares = 'id_presupuesto as id_concepto,
                               codigo_cc::varchar as concepto,';

                v_grupos = 'id_presupuesto,
                               codigo_cc,';
                v_ordenacion = 'id_presupuesto asc,';


            ELSEIF v_parametros.tipo_reporte = 'categoria'  THEN

                IF  v_parametros.id_categoria_programatica != 0 and v_parametros.id_categoria_programatica is not null THEN
                    v_filtro = v_filtro||' and id_categoria_programatica = '||v_parametros.id_categoria_programatica;
                 END IF;

                v_titulares = 'id_categoria_programatica as id_concepto,
                               codigo_categoria::varchar as concepto,';
                v_grupos = 'id_categoria_programatica,
                					codigo_categoria,';
                v_ordenacion = 'id_categoria_programatica asc,';


            ELSEIF v_parametros.tipo_reporte = 'programa'  THEN

                 IF  v_parametros.id_cp_programa != 0 and v_parametros.id_cp_programa is not null THEN
                    v_filtro = v_filtro||' and id_cp_programa = '||v_parametros.id_cp_programa;
                 END IF;



                v_titulares = 'id_cp_programa as id_concepto,
                               desc_programa::varchar as concepto,';
                v_grupos = 'id_cp_programa,
                				desc_programa,';
                v_ordenacion = 'id_cp_programa asc,';

            END IF;

    		--Sentencia de la consulta
			v_consulta:='SELECT
                            '||v_titulares||'

                            id_concepto_ingas,
                            id_partida,
                            codigo_partida,
                            nombre_partida,
                            descripcion_pres,
                            desc_ingas,
                            justificacion,
                            unidad_medida,
                            importe_unitario,
                            cantidad_mem,
                            sum(importe) as importe,
                            m.gestion,
                            pre.f_get_mem_det_totalesxperiodo(m.id_memoria_calculo, m.cantidad_mem::integer, m.importe_unitario::integer) AS importe_periodo
                          FROM
                            pre.vmemoria_por_categoria m
                          WHERE '||v_filtro||'
                          group by

                              '||v_grupos||'

                              id_concepto_ingas,
                              id_partida,
                              codigo_partida,
                              nombre_partida,
                              descripcion_pres,
                              desc_ingas,
                              justificacion,
                              unidad_medida,
                              importe_unitario,
                              cantidad_mem,
                              importe,
							  m.id_memoria_calculo,
                              m.gestion
                          order by

                              '||v_ordenacion||'
                              codigo_partida asc ';
        ELSE
        v_consulta:='SELECT
                            m.id_presupuesto as id_concepto,
                            m.codigo_cc::varchar as concepto,
                            m.id_concepto_ingas,
                            m.id_partida,
                            m.codigo_partida,
                            m.nombre_partida,
                            m.descripcion_pres,
                            m.desc_ingas,
                            m.justificacion,
                            m.unidad_medida,
                            m.importe_unitario,
                            m.cantidad_mem,
                            sum(m.importe) as importe,
                            g.gestion,
                            pre.f_get_mem_det_totalesxperiodo(m.id_memoria_calculo, (m.cantidad_mem)::integer, m.importe_unitario::integer) AS importe_periodo
                          FROM pre.vmemoria_por_categoria m
						  INNER JOIN pre.vpresupuesto p on p.id_presupuesto = m.id_presupuesto
                          INNER JOIN param.tgestion g on g.id_gestion = m.id_gestion
                          WHERE p.id_proceso_wf  = '||v_parametros.id_proceso_wf||'
                          group by
                          	  m.id_memoria_calculo,
                              m.id_presupuesto,
                              m.codigo_cc,
                              m.id_concepto_ingas,
                              m.id_partida,
                              m.codigo_partida,
                              m.nombre_partida,
                              m.descripcion_pres,
                              m.desc_ingas,
                              m.justificacion,
                              m.unidad_medida,
                              m.importe_unitario,
                              m.cantidad_mem,
                              m.importe,
                              g.gestion
                          order by
                              m.id_presupuesto asc,
                              m.codigo_partida asc ';
        END IF;
        raise notice 'consulta: %', v_consulta;
		--  Devuelve la respuesta
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