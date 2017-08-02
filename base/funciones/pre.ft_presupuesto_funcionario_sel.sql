--------------- SQL ---------------

CREATE OR REPLACE FUNCTION pre.ft_presupuesto_funcionario_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Presupuesto
 FUNCION: 		pre.ft_presupuesto_funcionario_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'pre.tpresupuesto_usuario'
 AUTOR: 		 (admin)
 FECHA:	        29-02-2016 03:25:38
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

	v_nombre_funcion = 'pre.ft_presupuesto_funcionario_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PRE_PREFUN_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		29-02-2016 03:25:38
	***********************************/

	if(p_transaccion='PRE_PREFUN_SEL')then
     				
    	begin
       
    		--Sentencia de la consulta
			v_consulta:='select
                          pf.id_presupuesto_funcionario,
                          pf.estado_reg,
                          pf.accion,
                          pf.id_funcionario,
                          pf.id_presupuesto,
                          pf.id_usuario_reg,
                          pf.fecha_reg,
                          pf.usuario_ai,
                          pf.id_usuario_ai,
                          pf.id_usuario_mod,
                          pf.fecha_mod,
                          usu1.cuenta as usr_reg,
                          usu2.cuenta as usr_mod,	
                          f.desc_funcionario1::varchar as desc_funcionario
						from pre.tpresupuesto_funcionario pf
                        inner join orga.vfuncionario f on f.id_funcionario = pf.id_funcionario
						inner join segu.tusuario usu1 on usu1.id_usuario = pf.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = pf.id_usuario_mod
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'PRE_PREFUN_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		rac (kplian)	
 	#FECHA:		29-02-2016 03:25:38
	***********************************/

	elsif(p_transaccion='PRE_PREFUN_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_presupuesto_funcionario)
					    from pre.tpresupuesto_funcionario pf
                        inner join orga.vfuncionario f on f.id_funcionario = pf.id_funcionario
						inner join segu.tusuario usu1 on usu1.id_usuario = pf.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = pf.id_usuario_mod
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