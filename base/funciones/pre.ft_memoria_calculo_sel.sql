--------------- SQL ---------------

CREATE OR REPLACE FUNCTION pre.ft_memoria_calculo_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Presupuesto
 FUNCION: 		pre.ft_memoria_calculo_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'pre.tmemoria_calculo'
 AUTOR: 		 (admin)
 FECHA:	        01-03-2016 14:22:24
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

	v_nombre_funcion = 'pre.ft_memoria_calculo_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PRE_MCA_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		01-03-2016 14:22:24
	***********************************/

	if(p_transaccion='PRE_MCA_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
                            mca.id_memoria_calculo,
                            mca.id_concepto_ingas,
                            mca.importe_total,
                            mca.obs,
                            mca.id_presupuesto,
                            mca.estado_reg,
                            mca.id_usuario_ai,
                            mca.fecha_reg,
                            mca.usuario_ai,
                            mca.id_usuario_reg,
                            mca.fecha_mod,
                            mca.id_usuario_mod,
                            usu1.cuenta as usr_reg,
                            usu2.cuenta as usr_mod,
                            cig.desc_ingas::varchar as desc_ingas,
                            par.id_partida,
                            (par.codigo||'' - ''|| par.nombre_partida)::varchar as desc_partida,
                            ges.gestion::varchar as desc_gestion	
						from pre.tmemoria_calculo mca                        
                        inner join pre.tpresupuesto pre on pre.id_presupuesto = mca.id_presupuesto
                        inner join param.tcentro_costo cc on cc.id_centro_costo = pre.id_centro_costo
                        inner join param.tconcepto_ingas cig on cig.id_concepto_ingas = mca.id_concepto_ingas
                        inner join pre.tconcepto_partida cp on cp.id_concepto_ingas = mca.id_concepto_ingas
                        inner join param.tgestion ges on ges.id_gestion = cc.id_gestion
                        inner join pre.tpartida par on par.id_partida = cp.id_partida and par.id_gestion = cc.id_gestion
                        inner join segu.tusuario usu1 on usu1.id_usuario = mca.id_usuario_reg
                        left join segu.tusuario usu2 on usu2.id_usuario = mca.id_usuario_mod
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'PRE_MCA_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		01-03-2016 14:22:24
	***********************************/

	elsif(p_transaccion='PRE_MCA_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_memoria_calculo)
                        from pre.tmemoria_calculo mca                        
                        inner join pre.tpresupuesto pre on pre.id_presupuesto = mca.id_presupuesto
                        inner join param.tcentro_costo cc on cc.id_centro_costo = pre.id_centro_costo
                        inner join param.tconcepto_ingas cig on cig.id_concepto_ingas = mca.id_concepto_ingas
                        inner join pre.tconcepto_partida cp on cp.id_concepto_ingas = mca.id_concepto_ingas
                        inner join param.tgestion ges on ges.id_gestion = cc.id_gestion
                        inner join pre.tpartida par on par.id_partida = cp.id_partida and par.id_gestion = cc.id_gestion
                        inner join segu.tusuario usu1 on usu1.id_usuario = mca.id_usuario_reg
                        left join segu.tusuario usu2 on usu2.id_usuario = mca.id_usuario_mod 
                        where  ';
			
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