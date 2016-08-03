CREATE OR REPLACE FUNCTION pre.ft_objetivo_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Presupuesto
 FUNCION: 		pre.ft_objetivo_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'pre.tobjetivo'
 AUTOR: 		 (gvelasquez)
 FECHA:	        20-07-2016 20:37:41
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
    v_where				varchar;
			    
BEGIN

	v_nombre_funcion = 'pre.ft_objetivo_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PRE_OBJ_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		gvelasquez	
 	#FECHA:		20-07-2016 20:37:41
	***********************************/

	if(p_transaccion='PRE_OBJ_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						obj.id_objetivo,
						obj.id_objetivo_fk,
						obj.nivel_objetivo,
						obj.sw_transaccional,
						obj.cantidad_verificacion,
						obj.unidad_verificacion,
						obj.ponderacion,
						obj.fecha_inicio,
						obj.tipo_objetivo,
						obj.descripcion,
						obj.linea_base,
						obj.estado_reg,
						obj.id_parametros,
						obj.indicador_logro,
						obj.id_gestion,
						obj.codigo,
						obj.periodo_ejecucion,
						obj.producto,
						obj.fecha_fin,
						obj.fecha_reg,
						obj.usuario_ai,
						obj.id_usuario_reg,
						obj.id_usuario_ai,
						obj.fecha_mod,
						obj.id_usuario_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
                        (obj.codigo || ''-'' || obj.descripcion)::varchar as detalle_descripcion	
						from pre.tobjetivo obj
						inner join segu.tusuario usu1 on usu1.id_usuario = obj.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = obj.id_usuario_mod
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;
        
    /*********************************   
     #TRANSACCION:  'PRE_OBJ_ARB_SEL'
     #DESCRIPCION:    Consulta de datos
     #AUTOR:            Grover Velasquez
     #FECHA:            20-07-2016
    ***********************************/

    elseif(p_transaccion='PRE_OBJ_ARB_SEL')then
                    
        begin       
              if(v_parametros.id_padre = '%') then
                v_where := ' obj.id_objetivo_fk is NULL';   
                     
              else
                v_where := ' obj.id_objetivo_fk = '||v_parametros.id_padre;
              end if;
              
              
       
       
            --Sentencia de la consulta
            v_consulta:='select
                        obj.id_objetivo,
                        obj.id_objetivo_fk,
                        obj.codigo,
                        
                        obj.descripcion,
                         case
                          when (obj.id_objetivo_fk is null )then
                               ''raiz''::varchar
                          when (obj.sw_transaccional = ''titular'' )then
                               ''hijo''::varchar
                         when (obj.sw_transaccional = ''movimiento'' )then
                               ''hoja''::varchar
                          END as tipo_nodo,
                        
                        obj.sw_transaccional,
                        obj.id_gestion,
                        
                        obj.nivel_objetivo,
						
						obj.cantidad_verificacion,
						obj.unidad_verificacion,
						obj.ponderacion,
						obj.fecha_inicio,
						obj.tipo_objetivo,
						
						obj.linea_base,
						obj.estado_reg,
						obj.id_parametros,
						obj.indicador_logro,
						
						
						obj.periodo_ejecucion,
						obj.producto,
						obj.fecha_fin,
						obj.fecha_reg,
						obj.usuario_ai,
						obj.id_usuario_reg,
						obj.id_usuario_ai,
						obj.fecha_mod,
						obj.id_usuario_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod	
                        
                        from pre.tobjetivo obj
                        inner join segu.tusuario usu1 on usu1.id_usuario = obj.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = obj.id_usuario_mod
                        where  '||v_where|| '
                        and id_gestion =  '||COALESCE( v_parametros.id_gestion,0)|| '                         
                        ORDER BY obj.codigo';
            raise notice '%',v_consulta;
           
            --Devuelve la respuesta
            return v_consulta;
                       
        end;

	/*********************************    
 	#TRANSACCION:  'PRE_OBJ_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		gvelasquez	
 	#FECHA:		20-07-2016 20:37:41
	***********************************/

	elsif(p_transaccion='PRE_OBJ_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_objetivo)
					    from pre.tobjetivo obj
					    inner join segu.tusuario usu1 on usu1.id_usuario = obj.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = obj.id_usuario_mod
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