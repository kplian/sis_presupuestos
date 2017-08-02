--------------- SQL ---------------

CREATE OR REPLACE FUNCTION pre.ft_rel_pre_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Presupuesto
 FUNCION: 		pre.ft_rel_pre_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'pre.trel_pre'
 AUTOR: 		 (admin)
 FECHA:	        18-04-2016 13:18:06
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

	v_nombre_funcion = 'pre.ft_rel_pre_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PRE_RELP_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		18-04-2016 13:18:06
	***********************************/

	if(p_transaccion='PRE_RELP_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
                            relp.id_rel_pre,
                            relp.estado,
                            relp.id_presupuesto_hijo,
                            relp.fecha_union,
                            relp.estado_reg,
                            relp.id_presupuesto_padre,
                            relp.id_usuario_ai,
                            relp.fecha_reg,
                            relp.usuario_ai,
                            relp.id_usuario_reg,
                            relp.id_usuario_mod,
                            relp.fecha_mod,
                            usu1.cuenta as usr_reg,
                            usu2.cuenta as usr_mod,
                            (pre.codigo_cc)::varchar as desc_presupuesto_hijo
						from pre.trel_pre relp
                        inner join pre.vpresupuesto_cc pre on pre.id_presupuesto = relp.id_presupuesto_hijo 
						inner join segu.tusuario usu1 on usu1.id_usuario = relp.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = relp.id_usuario_mod
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'PRE_RELP_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		18-04-2016 13:18:06
	***********************************/

	elsif(p_transaccion='PRE_RELP_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_rel_pre)
					    from pre.trel_pre relp
                        inner join pre.vpresupuesto_cc pre on pre.id_presupuesto = relp.id_presupuesto_hijo 
						inner join segu.tusuario usu1 on usu1.id_usuario = relp.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = relp.id_usuario_mod
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