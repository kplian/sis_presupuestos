--------------- SQL ---------------

CREATE OR REPLACE FUNCTION pre.ft_memoria_det_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Presupuesto
 FUNCION: 		pre.ft_memoria_det_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'pre.tmemoria_det'
 AUTOR: 		 (admin)
 FECHA:	        01-03-2016 14:23:08
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

	v_nombre_funcion = 'pre.ft_memoria_det_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PRE_MDT_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		01-03-2016 14:23:08
	***********************************/

	if(p_transaccion='PRE_MDT_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
                              mdt.id_memoria_det,
                              mdt.importe,
                              mdt.estado_reg,
                              mdt.id_periodo,
                              mdt.id_memoria_calculo,
                              mdt.usuario_ai,
                              mdt.fecha_reg,
                              mdt.id_usuario_reg,
                              mdt.id_usuario_ai,
                              mdt.fecha_mod,
                              mdt.id_usuario_mod,
                              usu1.cuenta as usr_reg,
                              usu2.cuenta as usr_mod,
                              p.periodo as desc_periodo,
                              mdt.cantidad_mem,
                              mdt.unidad_medida,
                              mdt.importe_unitario	
						from pre.tmemoria_det mdt
                        inner join param.tperiodo p on p.id_periodo = mdt.id_periodo
						inner join segu.tusuario usu1 on usu1.id_usuario = mdt.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = mdt.id_usuario_mod
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'PRE_MDT_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		01-03-2016 14:23:08
	***********************************/

	elsif(p_transaccion='PRE_MDT_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_memoria_det)
					    from pre.tmemoria_det mdt
                        inner join param.tperiodo p on p.id_periodo = mdt.id_periodo
						inner join segu.tusuario usu1 on usu1.id_usuario = mdt.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = mdt.id_usuario_mod
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