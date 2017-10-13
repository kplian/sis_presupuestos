--------------- SQL ---------------

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
***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;
    v_pre_codigo_proc_macajsutable   varchar;
    v_id_gestion					 integer;

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
    		--Sentencia de la consulta
			v_consulta:='select
						pareje.id_partida_ejecucion,
						pareje.id_int_comprobante,
						pareje.id_moneda,
                        mon.moneda,
						pareje.id_presupuesto,
                        pre.descripcion as desc_pres,
                        cat.codigo_categoria,
						pareje.id_partida,
                        par.codigo,
                        par.nombre_partida,
						pareje.nro_tramite,
						pareje.tipo_cambio,
						pareje.columna_origen,
						pareje.tipo_movimiento,
						pareje.id_partida_ejecucion_fk,
						pareje.estado_reg,
						pareje.fecha,
						pareje.monto_mb,
						pareje.monto,
						pareje.valor_id_origen,
						pareje.id_usuario_reg,
						pareje.fecha_reg,
						pareje.usuario_ai,
						pareje.id_usuario_ai,
						pareje.fecha_mod,
						pareje.id_usuario_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod
						from pre.tpartida_ejecucion pareje
                        inner join pre.tpresupuesto pre on pre.id_presupuesto = pareje.id_presupuesto
                        inner join pre.vcategoria_programatica cat on cat.id_categoria_programatica = pre.id_categoria_prog
                        inner join pre.tpartida par on par.id_partida = pareje.id_partida
                        inner join param.tmoneda mon on mon.id_moneda = pareje.id_moneda
						inner join segu.tusuario usu1 on usu1.id_usuario = pareje.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = pareje.id_usuario_mod
				        where  ';

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
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_partida_ejecucion)
					    from pre.tpartida_ejecucion pareje
              inner join pre.tpresupuesto pre on pre.id_presupuesto = pareje.id_presupuesto
              inner join pre.vcategoria_programatica cat on cat.id_categoria_programatica = pre.id_categoria_prog
              inner join pre.tpartida par on par.id_partida = pareje.id_partida
              inner join param.tmoneda mon on mon.id_moneda = pareje.id_moneda
					    inner join segu.tusuario usu1 on usu1.id_usuario = pareje.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = pareje.id_usuario_mod
					    where ';

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