--------------- SQL ---------------

CREATE OR REPLACE FUNCTION pre.ft_ajuste_det_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Presupuesto
 FUNCION: 		pre.ft_ajuste_det_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'pre.tajuste_det'
 AUTOR: 		 (admin)
 FECHA:	        13-04-2016 13:51:41
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
			    
BEGIN

	v_nombre_funcion = 'pre.ft_ajuste_det_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PRE_AJD_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		13-04-2016 13:51:41
	***********************************/

	if(p_transaccion='PRE_AJD_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
                            ajd.id_ajuste_det,
                            ajd.id_presupuesto,
                            ajd.id_partida_ejecucion,
                            ajd.importe,
                            ajd.id_partida,
                            ajd.estado_reg,
                            ajd.tipo_ajuste,
                            ajd.id_usuario_ai,
                            ajd.fecha_reg,
                            ajd.usuario_ai,
                            ajd.id_usuario_reg,
                            ajd.fecha_mod,
                            ajd.id_usuario_mod,
                            usu1.cuenta as usr_reg,
                            usu2.cuenta as usr_mod,
                            pre.codigo_cc as desc_presupuesto,
                            (par.codigo||'' - '' ||par.nombre_partida)::varchar as desc_partida	,
                            id_ajuste
						from pre.tajuste_det ajd
                        inner join pre.vpresupuesto_cc pre on pre.id_presupuesto = ajd.id_presupuesto
                        inner join pre.tpartida par on par.id_partida = ajd.id_partida
						inner join segu.tusuario usu1 on usu1.id_usuario = ajd.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = ajd.id_usuario_mod
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'PRE_AJD_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		13-04-2016 13:51:41
	***********************************/

	elsif(p_transaccion='PRE_AJD_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select 
                            count(id_ajuste_det),
                            COALESCE(sum(ajd.importe),0)::numeric  as total_importe
					    from pre.tajuste_det ajd
                        inner join pre.vpresupuesto_cc pre on pre.id_presupuesto = ajd.id_presupuesto
                        inner join pre.tpartida par on par.id_partida = ajd.id_partida
						inner join segu.tusuario usu1 on usu1.id_usuario = ajd.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = ajd.id_usuario_mod
				        where ';
			
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