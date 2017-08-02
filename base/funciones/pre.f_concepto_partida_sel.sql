--------------- SQL ---------------

CREATE OR REPLACE FUNCTION pre.f_concepto_partida_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de presupuesto
 FUNCION: 		pre.f_concepto_partida_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'pre.tconcepto_partida'
 AUTOR: 		 (admin)
 FECHA:	        25-02-2013 22:09:52
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

	v_nombre_funcion = 'pre.f_concepto_partida_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PRE_CONP_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		25-02-2013 22:09:52
	***********************************/

	if(p_transaccion='PRE_CONP_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						conp.id_concepto_partida,
						conp.id_partida,
						conp.id_concepto_ingas,
						conp.estado_reg,
						conp.id_usuario_reg,
						conp.fecha_reg,
						conp.fecha_mod,
						conp.id_usuario_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
						ges.gestion desc_gestion,
                        par.codigo as codigo_partida,
                        par.nombre_partida as nombre_parida,
                        par.codigo||''-''||ges.gestion as desc_partida	
						from pre.tconcepto_partida conp
						inner join segu.tusuario usu1 on usu1.id_usuario = conp.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = conp.id_usuario_mod
                        inner join pre.tpartida par on par.id_partida = conp.id_partida
                        inner join param.tgestion ges on ges.id_gestion = par.id_gestion
                        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'PRE_CONP_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		25-02-2013 22:09:52
	***********************************/

	elsif(p_transaccion='PRE_CONP_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_concepto_partida)
					    from pre.tconcepto_partida conp
						inner join segu.tusuario usu1 on usu1.id_usuario = conp.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = conp.id_usuario_mod
                        inner join pre.tpartida par on par.id_partida = conp.id_partida
                        inner join param.tgestion ges on ges.id_gestion = par.id_gestion
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