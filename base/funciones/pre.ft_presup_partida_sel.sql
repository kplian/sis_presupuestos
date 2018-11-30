CREATE OR REPLACE FUNCTION pre.ft_presup_partida_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Presupuesto
 FUNCION: 		pre.ft_presup_partida_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'pre.tpresup_partida'
 AUTOR: 		 (admin)
 FECHA:	        29-02-2016 19:40:34
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

	v_nombre_funcion = 'pre.ft_presup_partida_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PRE_PRPA_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		29-02-2016 19:40:34
	***********************************/

	if(p_transaccion='PRE_PRPA_SEL')then
     				
    	begin  
    		--Sentencia de la consulta
			v_consulta:='select
                            prpa.id_presup_partida,
                            prpa.tipo,
                            prpa.id_moneda,
                            prpa.id_partida,
                            prpa.id_centro_costo,
                            prpa.fecha_hora,
                            prpa.estado_reg,
                            prpa.id_presupuesto,
                            COALESCE(prpa.importe, 0) as importe,
                            prpa.id_usuario_ai,
                            prpa.usuario_ai,
                            prpa.fecha_reg,
                            prpa.id_usuario_reg,
                            prpa.id_usuario_mod,
                            prpa.fecha_mod,
                            usu1.cuenta as usr_reg,
                            usu2.cuenta as usr_mod,
                            (par.codigo||'' - ''|| par.nombre_partida)::varchar as desc_partida,
                            ges.gestion::varchar as desc_gestion,
                            importe_aprobado
						from pre.tpresup_partida prpa
                        inner join pre.tpartida par on par.id_partida = prpa.id_partida
                        inner join param.tgestion ges on ges.id_gestion = par.id_gestion
						inner join segu.tusuario usu1 on usu1.id_usuario = prpa.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = prpa.id_usuario_mod
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'PRE_PRPA_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		29-02-2016 19:40:34
	***********************************/

	elsif(p_transaccion='PRE_PRPA_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(prpa.id_presup_partida),
                         COALESCE(sum(prpa.importe),0)::numeric  as total_importe,
                         COALESCE(sum(prpa.importe_aprobado),0)::numeric  as total_importe_aprobado
					    from pre.tpresup_partida prpa
                        inner join pre.tpartida par on par.id_partida = prpa.id_partida
                        inner join param.tgestion ges on ges.id_gestion = par.id_gestion
						inner join segu.tusuario usu1 on usu1.id_usuario = prpa.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = prpa.id_usuario_mod
				        where';
			
			--Definicion de la respuesta		    
			v_consulta:=v_consulta||v_parametros.filtro;
            raise notice '%', v_consulta;
			--Devuelve la respuesta
			return v_consulta;

		end;
	
    /*********************************    
 	#TRANSACCION:  'PRE_PRPAEST_SEL'
 	#DESCRIPCION:	Listado de partidas por presupeusto con sus estados
 	#AUTOR:		admin	
 	#FECHA:		29-02-2016 19:40:34
	***********************************/

	elseif(p_transaccion='PRE_PRPAEST_SEL')then
     				
    	begin  
    		--Sentencia de la consulta
			v_consulta:='SELECT 
                          id_presup_partida,
                          tipo,
                          id_moneda,
                          id_partida,
                          id_centro_costo,
                          fecha_hora,
                          estado_reg,
                          id_presupuesto,
                          importe,
                          desc_partida,
                          desc_gestion,
                          importe_aprobado,
                          formulado,
                          comprometido,
                          ejecutado,
                          pagado,
                          (formulado - importe_aprobado) as ajustado, 
                          CASE 
                            WHEN formulado != 0 THEN
                           ((ejecutado/formulado)*100) 
                          ELSE
                            0::numeric 
                          END as porc_ejecucio
                        FROM 
                          pre.vpresup_partida prpa
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

            raise notice '%', v_consulta;
            
			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'PRE_PRPAEST_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		29-02-2016 19:40:34
	***********************************/

	elsif(p_transaccion='PRE_PRPAEST_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:=' select count(prpa.id_presup_partida),
                         COALESCE(sum(prpa.importe),0)::numeric  as total_importe,
                         COALESCE(sum(prpa.importe_aprobado),0)::numeric  as total_importe_aprobado,
                         COALESCE(sum(prpa.formulado),0)::numeric  as total_formulado,
                         COALESCE(sum(prpa.comprometido),0)::numeric  as total_comprometido,
                         COALESCE(sum(prpa.ejecutado),0)::numeric  as total_ejecutado,
                         COALESCE(sum(prpa.pagado),0)::numeric  as total_pagado
			            
                        FROM 
                          pre.vpresup_partida prpa
				        where   ';
			
			--Definicion de la respuesta		    
			v_consulta:=v_consulta||v_parametros.filtro;
            raise notice '%', v_consulta;
			--Devuelve la respuesta
			return v_consulta;

		end;
    
     /*********************************    
 	#TRANSACCION:  'PRE_ETPRENRO_SEL'
 	#DESCRIPCION:	Listado del estado de presupeusto segun nro de tramite
 	#AUTOR:		renso(kplian)	
 	#FECHA:		05-04-2016 19:40:34
	***********************************/

	elseif(p_transaccion='PRE_ETPRENRO_SEL')then
     				
    	begin  
    		--Sentencia de la consulta
			v_consulta:='SELECT
                            id_presup_partida, 
                            id_partida,
                            id_presupuesto,
                            desc_partida,
                            id_centro_costo,
                            codigo_cc,
                            id_gestion,
                            id_uo,
                            id_ep,
                            tipo_pres,
                            nro_tramite,
                            comprometido,
                            ejecutado,
                            pagado
                        FROM 
                          pre.vestado_presupuesto_por_tramite prpa
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

            raise notice '%', v_consulta;
            
			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'PRE_ETPRENRO_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		29-02-2016 19:40:34
	***********************************/

	elsif(p_transaccion='PRE_ETPRENRO_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:=' select count(prpa.id_presup_partida),
                         COALESCE(sum(prpa.comprometido),0)::numeric  as total_comprometido,
                         COALESCE(sum(prpa.ejecutado),0)::numeric  as total_ejecutado,
                         COALESCE(sum(prpa.pagado),0)::numeric  as total_pagado
			            
                        FROM 
                          pre.vestado_presupuesto_por_tramite prpa
				        where    ';
			
			--Definicion de la respuesta		    
			v_consulta:=v_consulta||v_parametros.filtro;
            raise notice '%', v_consulta;
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