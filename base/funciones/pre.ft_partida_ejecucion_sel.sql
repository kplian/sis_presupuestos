CREATE OR REPLACE FUNCTION pre.ft_partida_ejecucion_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Presupuesto
 FUNCION: 		pre.ft_partida_ejecucion_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'pre.tpartida_ejecucion'
 AUTOR: 		 (gvelasquez)
 FECHA:	        03-10-2016 15:47:23
 COMENTARIOS:
***************************************************************************
  HISTORIAL DE MODIFICACIONES:

   	
 ISSUE            FECHA:		      AUTOR       DESCRIPCION
 0                10/10/2017           RAC         Agrgar trasaccion para listado de nro de tramite
 #11 ETR		  12/02/2019		   MMV Kplian	Reporte Integridad presupuestaria
***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;
    v_pre_codigo_proc_macajsutable   varchar;
    v_id_gestion					 integer;
    v_filtro_tipo_cc  varchar;
    v_tipo_cc  varchar;

BEGIN

	v_nombre_funcion = 'pre.ft_partida_ejecucion_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'PRE_PAREJE_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		gvelasquez
 	#FECHA:		03-10-2016 15:47:23
	***********************************/

	if(p_transaccion='PRE_PAREJE_SEL')then

    	begin

             v_filtro_tipo_cc = ' 0=0  and ';


             IF  pxp.f_existe_parametro(p_tabla,'id_tipo_cc')  THEN

                      IF v_parametros.id_tipo_cc is not NULL THEN

                          WITH RECURSIVE tipo_cc_rec (id_tipo_cc, id_tipo_cc_fk) AS (
                            SELECT tcc.id_tipo_cc, tcc.id_tipo_cc_fk
                            FROM param.ttipo_cc tcc
                            WHERE tcc.id_tipo_cc = v_parametros.id_tipo_cc and tcc.estado_reg = 'activo'
                          UNION ALL
                            SELECT tcc2.id_tipo_cc, tcc2.id_tipo_cc_fk
                            FROM tipo_cc_rec lrec
                            INNER JOIN param.ttipo_cc tcc2 ON lrec.id_tipo_cc = tcc2.id_tipo_cc_fk
                            where tcc2.estado_reg = 'activo'
                          )
                        SELECT  pxp.list(id_tipo_cc::varchar)
                          into
                            v_tipo_cc
                        FROM tipo_cc_rec;



                        v_filtro_tipo_cc = ' id_tipo_cc in ('||v_tipo_cc||') and ';
                    END IF;
                 END IF;


    		--Sentencia de la consulta
			v_consulta:='select
                                  id_partida_ejecucion,
                                  id_int_comprobante,
                                  id_moneda,
                                  moneda,
                                  id_presupuesto,
                                  desc_pres,
                                  codigo_categoria,
                                  id_partida,
                                  codigo,
                                  nombre_partida,
                                  nro_tramite,
                                  tipo_cambio,
                                  columna_origen,
                                  tipo_movimiento,
                                  id_partida_ejecucion_fk,
                                  estado_reg,
                                  fecha,
                                  egreso_mb,
                                  ingreso_mb,
                                  monto_mb,
                                  monto,
                                  valor_id_origen,
                                  id_usuario_reg,
                                  fecha_reg,
                                  usuario_ai,
                                  id_usuario_ai,
                                  fecha_mod,
                                  id_usuario_mod,
                                  usr_reg,
                                  usr_mod,
                                  id_tipo_cc,
                                  desc_tipo_cc,
                                  nro_cbte,
                                  id_proceso_wf,
                                  monto_anticipo_mb,
                                  monto_desc_anticipo_mb,
                                  monto_iva_revertido_mb,
                                  glosa1,
                                  glosa,
                                  cantidad_descripcion
                          from pre.vpartida_ejecucion
                          where  '||v_filtro_tipo_cc;

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;

			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			raise notice 'La consulta es:  %', v_consulta;

			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'PRE_PAREJE_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		gvelasquez
 	#FECHA:		03-10-2016 15:47:23
	***********************************/

	elsif(p_transaccion='PRE_PAREJE_CONT')then

		begin

             v_filtro_tipo_cc = ' 0=0 and ';


             IF  pxp.f_existe_parametro(p_tabla,'id_tipo_cc')  THEN

                      IF v_parametros.id_tipo_cc is not NULL THEN

                          WITH RECURSIVE tipo_cc_rec (id_tipo_cc, id_tipo_cc_fk) AS (
                            SELECT tcc.id_tipo_cc, tcc.id_tipo_cc_fk
                            FROM param.ttipo_cc tcc
                            WHERE tcc.id_tipo_cc = v_parametros.id_tipo_cc and tcc.estado_reg = 'activo'
                          UNION ALL
                            SELECT tcc2.id_tipo_cc, tcc2.id_tipo_cc_fk
                            FROM tipo_cc_rec lrec
                            INNER JOIN param.ttipo_cc tcc2 ON lrec.id_tipo_cc = tcc2.id_tipo_cc_fk
                            where tcc2.estado_reg = 'activo'
                          )
                        SELECT  pxp.list(id_tipo_cc::varchar)
                          into
                            v_tipo_cc
                        FROM tipo_cc_rec;



                        v_filtro_tipo_cc = ' id_tipo_cc in ('||v_tipo_cc||')  and ';
                    END IF;
                 END IF;


			--Sentencia de la consulta de conteo de registros
			v_consulta:='select
                           count(id_partida_ejecucion),
                           sum(egreso_mb) as total_egreso_mb,
                           sum(ingreso_mb) as total_ingreso_mb,
                           sum(monto_anticipo_mb) as total_monto_anticipo_mb ,
                           sum(monto_desc_anticipo_mb) as  total_monto_desc_anticipo_mb,
                           sum( monto_iva_revertido_mb) as  total_monto_iva_revertido_mb
                        from pre.vpartida_ejecucion
					    where '||v_filtro_tipo_cc;

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;

			--Devuelve la respuesta
			return v_consulta;

		end;

    /*********************************
 	#TRANSACCION:  'PRE_LISTRAPE_SEL'
 	#DESCRIPCION:	Lista nro de tramite para interface de ajustes, icnremetosy compromisos presupesutario
 	#AUTOR:		rac
 	#FECHA:		11/10/2017
	***********************************/

	ELSEIF(p_transaccion='PRE_LISTRAPE_SEL')then

    	begin

            v_pre_codigo_proc_macajsutable =  pxp.f_get_variable_global('pre_codigo_proc_macajsutable');
            raise notice '-> fil :%',COALESCE(v_pre_codigo_proc_macajsutable,'''TEST''');

            --recueerar la gestion de la fecha

            select
               p.id_gestion
            into
              v_id_gestion
            from param.tperiodo p
            where  v_parametros.fecha_ajuste::Date BETWEEN p.fecha_ini::Date and p.fecha_fin::date;

            IF v_id_gestion is null  THEN
               raise exception 'no se encontro gestion para la fecha: %',v_parametros.fecha_ajuste;
            END IF;

            raise notice '-> ges :%',v_id_gestion;


    		--Sentencia de la consulta
			v_consulta:='select
                             DISTINCT ON (pe.nro_tramite)
                             pr.id_gestion,
                             pe.nro_tramite,
                             pm.codigo,
                             pe.id_moneda,
                             mon.codigo as desc_moneda
                          from pre.tpartida_ejecucion pe
                          inner join wf.tproceso_wf pwf on pwf.nro_tramite = pe.nro_tramite
                          inner join wf.ttipo_proceso tp on tp.id_tipo_proceso = pwf.id_tipo_proceso
                          inner join wf.tproceso_macro pm on pm.id_proceso_macro = tp.id_proceso_macro
                          inner join param.tperiodo pr on pe.fecha BETWEEN pr.fecha_ini and pr.fecha_fin
                          inner join param.tmoneda mon on mon.id_moneda = pe.id_moneda
                          where pm.codigo in ('||COALESCE(v_pre_codigo_proc_macajsutable,'''TEST''') ||')
                          and  pr.id_gestion = '||v_id_gestion::Varchar|| ' and ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			raise notice 'La consulta es:  %', v_consulta;

			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'PRE_LISTRAPE_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		rac
 	#FECHA:		11/10/2017
	***********************************/

	elsif(p_transaccion='PRE_LISTRAPE_CONT')then

		begin

            v_pre_codigo_proc_macajsutable =  pxp.f_get_variable_global('pre_codigo_proc_macajsutable');


            --recuperar  la gestion de la fecha
            select
               p.id_gestion
            into
              v_id_gestion
            from param.tperiodo p
            where  v_parametros.fecha_ajuste BETWEEN p.fecha_ini and p.fecha_fin;

            IF v_id_gestion is null  THEN
               raise exception 'no se encontro gestion para la fecha: %',v_parametros.fecha_ajuste;
            END IF;



			--Sentencia de la consulta de conteo de registros
			v_consulta:='select
                             count( DISTINCT pe.nro_tramite)
					    from pre.tpartida_ejecucion pe
                          inner join wf.tproceso_wf pwf on pwf.nro_tramite = pe.nro_tramite
                          inner join wf.ttipo_proceso tp on tp.id_tipo_proceso = pwf.id_tipo_proceso
                          inner join wf.tproceso_macro pm on pm.id_proceso_macro = tp.id_proceso_macro
                          inner join param.tperiodo pr on pe.fecha BETWEEN pr.fecha_ini and pr.fecha_fin
                          inner join param.tmoneda mon on mon.id_moneda = pe.id_moneda
                        where pm.codigo in ('||COALESCE(v_pre_codigo_proc_macajsutable,'''TEST''') ||')
                          and  pr.id_gestion = '||v_id_gestion::Varchar|| ' and ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;

			--Devuelve la respuesta
			return v_consulta;

		end;


    /*********************************
 	#TRANSACCION:  'PRE_INPRE_SEL' #11
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		MMV Kplian
 	#FECHA:		11/10/2017
	***********************************/

	elsif(p_transaccion='PRE_INPRE_SEL')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='with formulado as (select
                                                       cc.id_gestion,
                                                       tcc.id_tipo_cc_techo,
                                                       tcc.codigo_techo,
                                                       tcc.control_partida,
                                                       tcc.descripcion_techo,
                                                       tcc.movimiento,
                                                       sum(pe.monto_mb) total_formulado
                                                 from pre.tpartida_ejecucion pe
                                                 inner join pre.tpresupuesto p on p.id_presupuesto = pe.id_presupuesto
                                                 inner join param.tcentro_costo cc on cc.id_centro_costo = p.id_centro_costo
                                                 inner join param.vtipo_cc_techo tcc on tcc.id_tipo_cc = cc.id_tipo_cc
                                                 where  pe.estado_reg = ''activo''
                                                       and pe.tipo_movimiento = ''formulado''
                                                  group by
                                                       cc.id_gestion,
                                                       tcc.id_tipo_cc_techo,
                                                       tcc.codigo_techo,
                                                       tcc.control_partida,
                                                       tcc.descripcion_techo,
                                                       tcc.movimiento),
                                            comprometido as (
                                                 select
                                                       cc.id_gestion,
                                                       tcc.id_tipo_cc_techo,
                                                       tcc.codigo_techo,
                                                       tcc.control_partida,
                                                       tcc.descripcion_techo ,
                                                       tcc.movimiento,
                                                       sum(pe.monto_mb) as total_comprometido

                                                 from pre.tpartida_ejecucion pe
                                                 inner join pre.tpresupuesto p on p.id_presupuesto = pe.id_presupuesto
                                                 inner join param.tcentro_costo cc on cc.id_centro_costo = p.id_centro_costo
                                                 inner join param.vtipo_cc_techo tcc on tcc.id_tipo_cc = cc.id_tipo_cc
                                                 where  pe.estado_reg = ''activo''
                                                        and pe.tipo_movimiento = ''comprometido''

                                                  group by
                                                       cc.id_gestion,
                                                       tcc.id_tipo_cc_techo,
                                                       tcc.codigo_techo,
                                                       tcc.control_partida,
                                                       tcc.descripcion_techo,
                                                       tcc.movimiento) ,

                                             ejecutado  as (
                                                 select
                                                       cc.id_gestion,
                                                       tcc.id_tipo_cc_techo,
                                                       tcc.codigo_techo,
                                                       tcc.control_partida,
                                                       tcc.descripcion_techo ,
                                                       tcc.movimiento,
                                                       sum(pe.monto_mb) as total_ejecutado

                                                 from pre.tpartida_ejecucion pe
                                                 inner join pre.tpresupuesto p on p.id_presupuesto = pe.id_presupuesto
                                                 inner join param.tcentro_costo cc on cc.id_centro_costo = p.id_centro_costo
                                                 inner join param.vtipo_cc_techo tcc on tcc.id_tipo_cc = cc.id_tipo_cc
                                                 where  pe.estado_reg = ''activo''
                                                       and pe.tipo_movimiento = ''ejecutado''

                                                  group by
                                                       cc.id_gestion,
                                                       tcc.id_tipo_cc_techo,
                                                       tcc.codigo_techo,
                                                       tcc.control_partida,
                                                       tcc.descripcion_techo,
                                                       tcc.movimiento)

                                                  select

                                                   form.id_gestion,
                                                       form.id_tipo_cc_techo,
                                                       form.codigo_techo,
                                                       form.control_partida,
                                                       form.descripcion_techo ,
                                                       form.movimiento,
                                                       form.total_formulado,
                                                       com.total_comprometido,
                                                       (form.total_formulado - com.total_comprometido) saldo_por_comprometer,
                                                       eje.total_ejecutado,
                                                       (form.total_formulado - eje.total_ejecutado ) saldo_por_ejecutar

                                                  from   formulado form
                                                  left join comprometido com on com.id_tipo_cc_techo = form.id_tipo_cc_techo and form.id_gestion = com.id_gestion
                                                  left join ejecutado eje on eje.id_tipo_cc_techo = com.id_tipo_cc_techo and eje.id_gestion = com.id_gestion
                                                  where (form.total_formulado - total_comprometido) < 0
                                                  or (form.total_formulado - eje.total_ejecutado ) < 0';
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