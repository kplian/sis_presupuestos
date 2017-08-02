CREATE OR REPLACE FUNCTION "pre"."ft_clase_gasto_sel"(	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$
/**************************************************************************
 SISTEMA:		Sistema de Presupuesto
 FUNCION: 		pre.ft_clase_gasto_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'pre.tclase_gasto'
 AUTOR: 		 (admin)
 FECHA:	        26-02-2016 01:22:22
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

	v_nombre_funcion = 'pre.ft_clase_gasto_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PRE_CLG_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		26-02-2016 01:22:22
	***********************************/

	if(p_transaccion='PRE_CLG_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						clg.id_clase_gasto,
						clg.estado_reg,
						clg.nombre,
						clg.codigo,
						clg.id_usuario_reg,
						clg.usuario_ai,
						clg.fecha_reg,
						clg.id_usuario_ai,
						clg.id_usuario_mod,
						clg.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod	
						from pre.tclase_gasto clg
						inner join segu.tusuario usu1 on usu1.id_usuario = clg.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = clg.id_usuario_mod
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'PRE_CLG_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		26-02-2016 01:22:22
	***********************************/

	elsif(p_transaccion='PRE_CLG_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_clase_gasto)
					    from pre.tclase_gasto clg
					    inner join segu.tusuario usu1 on usu1.id_usuario = clg.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = clg.id_usuario_mod
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
ALTER FUNCTION "pre"."ft_clase_gasto_sel"(integer, integer, character varying, character varying) OWNER TO postgres;
