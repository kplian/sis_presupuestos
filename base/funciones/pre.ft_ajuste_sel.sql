--------------- SQL ---------------

CREATE OR REPLACE FUNCTION pre.ft_ajuste_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Presupuesto
 FUNCION: 		pre.ft_ajuste_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'pre.tajuste'
 AUTOR: 		 (admin)
 FECHA:	        13-04-2016 13:21:12
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
    v_filtro			varchar;
			    
BEGIN

	v_nombre_funcion = 'pre.ft_ajuste_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PRE_AJU_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		13-04-2016 13:21:12
	***********************************/

	if(p_transaccion='PRE_AJU_SEL')then
     				
    	begin
        
            v_filtro = ' 0=0  and  ';
        
             IF  v_parametros.tipo_interfaz = 'AjusteInicio' THEN
                IF p_administrador !=1   THEN
                   v_filtro = 'aju.id_usuario_reg='||p_id_usuario||'   and ';
                END IF;
            
             ELSEIF  v_parametros.tipo_interfaz = 'AjusteVb' THEN
                IF p_administrador !=1 THEN
                   v_filtro = '(ew.id_funcionario = '||v_parametros.id_funcionario_usu::varchar||')  and  aju.estado not in (''borrador'', ''aprobado'') and ';
                ELSE
                    v_filtro = 'aju.estado not in (''borrador'', ''aprobado'') and ';
                END IF;
             ELSE
               raise exception 'Tipo de interface no reconocida %', v_parametros.tipo_interfaz;
             END IF;
             
             
            
            --  Sentencia de la consulta
			v_consulta:='select
                            aju.id_ajuste,
                            aju.id_estado_wf,
                            aju.estado_reg,
                            aju.estado,
                            aju.justificacion,
                            aju.id_proceso_wf,
                            aju.tipo_ajuste,
                            aju.nro_tramite,
                            aju.id_usuario_reg,
                            aju.fecha_reg,
                            aju.usuario_ai,
                            aju.id_usuario_ai,
                            aju.id_usuario_mod,
                            aju.fecha_mod,
                            usu1.cuenta as usr_reg,
                            usu2.cuenta as usr_mod,
                            aju.fecha,
                            aju.id_gestion	,
                            aju.importe_ajuste,
                            aju.movimiento,
                            aju.nro_tramite as nro_tramite_aux,
                            mon.codigo as desc_moneda,
                            mon.id_moneda
						from pre.tajuste aju
						inner join segu.tusuario usu1 on usu1.id_usuario = aju.id_usuario_reg
                        inner join wf.testado_wf ew on ew.id_estado_wf = aju.id_estado_wf
                        inner join param.tmoneda mon on mon.id_moneda = aju.id_moneda
						left join segu.tusuario usu2 on usu2.id_usuario = aju.id_usuario_mod
				        where  '||v_filtro;
                        
                   
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
            
            raise notice 'consulta: %  ...... %',v_consulta,v_parametros.filtro ;      
            
			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'PRE_AJU_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		13-04-2016 13:21:12
	***********************************/

	elsif(p_transaccion='PRE_AJU_CONT')then

		begin
            
            v_filtro = ' 0=0  and  ';
        
             IF  v_parametros.tipo_interfaz = 'AjusteInicio'  THEN
                IF p_administrador !=1   THEN
                   v_filtro = 'aju.id_usuario_reg='||p_id_usuario||'  and  aju.estado = ''borrador'' and ';
                ELSE
                   v_filtro = 'aju.estado = ''borrador'' and ';
                END IF;
            
             ELSEIF  v_parametros.tipo_interfaz = 'AjusteVb' THEN
                IF p_administrador !=1 THEN
                   v_filtro = '(ew.id_funcionario = '||v_parametros.id_funcionario_usu::varchar||')  and  aju.estado not in (''borrador'', ''aprobado'') and ';
                ELSE
                    v_filtro = 'aju.estado not in (''borrador'', ''aprobado'') and ';
                END IF;
             ELSE
               raise exception 'Tipo de interface no reconocida %', v_parametros.tipo_interfaz;
             END IF;
             
            --Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_ajuste)
					    from pre.tajuste aju
                          inner join segu.tusuario usu1 on usu1.id_usuario = aju.id_usuario_reg
                          inner join wf.testado_wf ew on ew.id_estado_wf = aju.id_estado_wf
                          inner join param.tmoneda mon on mon.id_moneda = aju.id_moneda
                          left join segu.tusuario usu2 on usu2.id_usuario = aju.id_usuario_mod
				        where  '||v_filtro;
			
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