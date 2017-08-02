CREATE OR REPLACE FUNCTION "pre"."ft_agrupador_sel"(	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$
/**************************************************************************
 SISTEMA:		Sistema de Presupuesto
 FUNCION: 		pre.ft_agrupador_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'pre.tagrupador'
 AUTOR: 		 (gvelasquez)
 FECHA:	        25-10-2016 19:21:31
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

	v_nombre_funcion = 'pre.ft_agrupador_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PRE_AGRUPA_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		gvelasquez	
 	#FECHA:		25-10-2016 19:21:31
	***********************************/

	if(p_transaccion='PRE_AGRUPA_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						agrupa.id_agrupador,
						agrupa.estado_reg,
						agrupa.orden,
						agrupa.tipo,
						agrupa.nombre_agrupador,
						agrupa.codigo,
						agrupa.id_usuario_reg,
						agrupa.fecha_reg,
						agrupa.usuario_ai,
						agrupa.id_usuario_ai,
						agrupa.id_usuario_mod,
						agrupa.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod	
						from pre.tagrupador agrupa
						inner join segu.tusuario usu1 on usu1.id_usuario = agrupa.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = agrupa.id_usuario_mod
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'PRE_AGRUPA_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		gvelasquez	
 	#FECHA:		25-10-2016 19:21:31
	***********************************/

	elsif(p_transaccion='PRE_AGRUPA_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_agrupador)
					    from pre.tagrupador agrupa
					    inner join segu.tusuario usu1 on usu1.id_usuario = agrupa.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = agrupa.id_usuario_mod
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
$BODY$
LANGUAGE 'plpgsql' VOLATILE
COST 100;
ALTER FUNCTION "pre"."ft_agrupador_sel"(integer, integer, character varying, character varying) OWNER TO postgres;
