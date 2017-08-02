CREATE OR REPLACE FUNCTION "pre"."ft_cp_programa_sel"(	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$
/**************************************************************************
 SISTEMA:		Sistema de Presupuesto
 FUNCION: 		pre.ft_cp_programa_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'pre.tcp_programa'
 AUTOR: 		 (admin)
 FECHA:	        19-04-2016 14:04:56
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

	v_nombre_funcion = 'pre.ft_cp_programa_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PRE_CPPR_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		19-04-2016 14:04:56
	***********************************/

	if(p_transaccion='PRE_CPPR_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						cppr.id_cp_programa,
						cppr.codigo,
						cppr.estado_reg,
						cppr.descripcion,
						cppr.id_gestion,
						cppr.id_usuario_reg,
						cppr.usuario_ai,
						cppr.fecha_reg,
						cppr.id_usuario_ai,
						cppr.fecha_mod,
						cppr.id_usuario_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod	
						from pre.tcp_programa cppr
						inner join segu.tusuario usu1 on usu1.id_usuario = cppr.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = cppr.id_usuario_mod
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'PRE_CPPR_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		19-04-2016 14:04:56
	***********************************/

	elsif(p_transaccion='PRE_CPPR_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_cp_programa)
					    from pre.tcp_programa cppr
					    inner join segu.tusuario usu1 on usu1.id_usuario = cppr.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = cppr.id_usuario_mod
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
ALTER FUNCTION "pre"."ft_cp_programa_sel"(integer, integer, character varying, character varying) OWNER TO postgres;
