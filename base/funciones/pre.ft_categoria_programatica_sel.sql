--------------- SQL ---------------

CREATE OR REPLACE FUNCTION pre.ft_categoria_programatica_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Presupuesto
 FUNCION: 		pre.ft_categoria_programatica_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'pre.tcategoria_programatica'
 AUTOR: 		 (admin)
 FECHA:	        19-04-2016 15:30:34
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

	v_nombre_funcion = 'pre.ft_categoria_programatica_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PRE_CPR_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		19-04-2016 15:30:34
	***********************************/

	if(p_transaccion='PRE_CPR_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='SELECT 
                          id_categoria_programatica,
                          id_cp_actividad,
                          id_gestion,
                          id_cp_organismo_fin,
                          descripcion,
                          id_cp_programa,
                          id_cp_fuente_fin,
                          estado_reg,
                          id_cp_proyecto,
                          id_usuario_ai,
                          fecha_reg,
                          usuario_ai,
                          id_usuario_reg,
                          fecha_mod,
                          id_usuario_mod,
                          usr_reg,
                          usr_mod,
                          codigo_programa,
                          codigo_proyecto,
                          codigo_actividad,
                          codigo_fuente_fin,
                          codigo_origen_fin,
                          desc_programa,
                          desc_proyecto,
                          desc_actividad,
                          desc_fuente_fin,
                          desc_origen_fin,
                          codigo_categoria,
                          gestion
                        FROM 
                          pre.vcategoria_programatica cpr 
                        WHERE ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;


            raise notice '-- % --', v_consulta;
			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'PRE_CPR_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		19-04-2016 15:30:34
	***********************************/

	elsif(p_transaccion='PRE_CPR_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(cpr.id_categoria_programatica)
					    FROM 
                          pre.vcategoria_programatica cpr
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