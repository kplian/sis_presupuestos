--------------- SQL ---------------

CREATE OR REPLACE FUNCTION pre.ft_clase_gasto_partida_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Presupuesto
 FUNCION: 		pre.ft_clase_gasto_partida_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'pre.tclase_gasto_partida'
 AUTOR: 		 (admin)
 FECHA:	        26-02-2016 02:33:23
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

	v_nombre_funcion = 'pre.ft_clase_gasto_partida_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PRE_CGP_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		26-02-2016 02:33:23
	***********************************/

	if(p_transaccion='PRE_CGP_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
                            cgp.id_clase_gasto_partida,
                            cgp.id_partida,
                            cgp.estado_reg,
                            cgp.id_clase_gasto,
                            cgp.id_usuario_ai,
                            cgp.usuario_ai,
                            cgp.fecha_reg,
                            cgp.id_usuario_reg,
                            cgp.id_usuario_mod,
                            cgp.fecha_mod,
                            usu1.cuenta as usr_reg,
                            usu2.cuenta as usr_mod,
                           ( p.codigo||'' ''||p.nombre_partida)::varchar as desc_partida,
                            p.id_gestion
						from pre.tclase_gasto_partida cgp
						inner join segu.tusuario usu1 on usu1.id_usuario = cgp.id_usuario_reg
                        inner join  pre.tpartida p on p.id_partida = cgp.id_partida 
                        left join segu.tusuario usu2 on usu2.id_usuario = cgp.id_usuario_mod
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'PRE_CGP_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		26-02-2016 02:33:23
	***********************************/

	elsif(p_transaccion='PRE_CGP_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_clase_gasto_partida)
					    from pre.tclase_gasto_partida cgp
						inner join segu.tusuario usu1 on usu1.id_usuario = cgp.id_usuario_reg
                        inner join  pre.tpartida p on p.id_partida = cgp.id_partida 
                        left join segu.tusuario usu2 on usu2.id_usuario = cgp.id_usuario_mod
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