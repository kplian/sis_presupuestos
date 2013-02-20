CREATE OR REPLACE FUNCTION "pre"."f_concepto_ingas_sel"(	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$
/**************************************************************************
 SISTEMA:		Sistema de presupuesto
 FUNCION: 		pre.f_concepto_ingas_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'pre.tconcepto_ingas'
 AUTOR: 		Gonzalo Sarmiento Sejas
 FECHA:	        18-02-2013 21:30:07
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

	v_nombre_funcion = 'pre.f_concepto_ingas_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PRE_CINGAS_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		Gonzalo Sarmiento Sejas	
 	#FECHA:		18-02-2013 21:30:07
	***********************************/

	if(p_transaccion='PRE_CINGAS_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						cingas.id_concepto_ingas,
						cingas.estado_reg,
						cingas.id_servicio,
						cingas.id_oec,
						cingas.id_item,
						cingas.tipo,
						cingas.sw_tesoro,
						cingas.desc_ingas,
						cingas.fecha_reg,
						cingas.id_usuario_reg,
						cingas.fecha_mod,
						cingas.id_usuario_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod	
						from pre.tconcepto_ingas cingas
						inner join segu.tusuario usu1 on usu1.id_usuario = cingas.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = cingas.id_usuario_mod
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'PRE_CINGAS_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		Gonzalo Sarmiento Sejas	
 	#FECHA:		18-02-2013 21:30:07
	***********************************/

	elsif(p_transaccion='PRE_CINGAS_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_concepto_ingas)
					    from pre.tconcepto_ingas cingas
					    inner join segu.tusuario usu1 on usu1.id_usuario = cingas.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = cingas.id_usuario_mod
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
ALTER FUNCTION "pre"."f_concepto_ingas_sel"(integer, integer, character varying, character varying) OWNER TO postgres;
