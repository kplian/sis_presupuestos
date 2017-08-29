--------------- SQL ---------------

CREATE OR REPLACE FUNCTION pre.f_balance_presupuesto (
  p_id_tipo_cc integer,
  p_id_periodo integer,
  p_desde date = NULL::date,
  p_hasta date = NULL::date,
  p_tipo_importe varchar = 'todos'::character varying,
  out ps_formulado numeric,
  out ps_comprometido numeric,
  out ps_ejecutado numeric
)
RETURNS SETOF record AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Presupuestos
 FUNCION: 		pre.f_balance_presupuesto
 DESCRIPCION:   Esta funcion obtiene el formulado, comprometido, ejecutado y pagado
                   
 AUTOR: 		Rensi Aarteaga Copari
 FECHA:	        05/07/2017
 COMENTARIOS:	
***************************************************************************/


DECLARE
  verificado  					record;
  v_consulta 					varchar;
  v_conexion 					varchar;
  v_resp						varchar;
  v_sincronizar 				varchar; 
  v_nombre_funcion  			varchar;
  v_pre_integrar_presupuestos 	varchar;  
  v_id_presupuesto				integer;
  v_id_partida					integer;  
  v_total_pagado_mb				numeric;
  v_total_pagado				numeric;
  v_total_comprometido_mb		numeric;
  v_total_comprometido			numeric;
  v_total_ejecutado_mb			numeric;
  v_total_ejecutado				numeric;
  v_nro_tramite					varchar;
  v_id_moneda					integer;
  id_partida_ejecucion_raiz		integer;
  v_registros					record;
  v_gestion						integer;
  
  
BEGIN

  v_nombre_funcion = 'pre.f_balance_presupuesto';

  
  	 v_pre_integrar_presupuestos = pxp.f_get_variable_global('pre_integrar_presupuestos');
     
     
      ps_comprometido = 0;
      ps_ejecutado = 0;
      ps_formulado = 0;
  
  
     IF v_pre_integrar_presupuestos = 'true' THEN 
      
         IF p_tipo_importe = 'todos' or p_tipo_importe = 'formulado' THEN
         
                IF p_id_periodo is not null THEN
                   select   
                        sum(pe.monto_mb)
                      into
                        ps_formulado
                   from  pre.tpartida_ejecucion pe, 
                         param.tperiodo per, 
                         param.tcentro_costo cc 
                
                   where      cc.id_tipo_cc = p_id_tipo_cc
                         and  pe.estado_reg = 'activo'
                         and  pe.tipo_movimiento = 'formulado'
                         and  cc.id_centro_costo = pe.id_presupuesto
                         and  pe.fecha BETWEEN per.fecha_ini and per.fecha_fin
                         and per.id_periodo = p_id_periodo;
                
        		ELSE 
               		 select   
                          sum(pe.monto_mb)
                        into
                          ps_formulado
                     from  pre.tpartida_ejecucion pe, 
                          param.tcentro_costo cc 
                  
                     where      cc.id_tipo_cc = p_id_tipo_cc
                           and  pe.estado_reg = 'activo'
                           and  pe.tipo_movimiento = 'formulado'
                           and  cc.id_centro_costo = pe.id_presupuesto
                           and  pe.fecha::Date BETWEEN p_desde and p_hasta;
        
           		END IF;
           
                 
        END IF;
        
        IF p_tipo_importe = 'todos' or p_tipo_importe = 'comprometido' THEN 
        
        		IF p_id_periodo is not null THEN
                
                      select   
                          sum(pe.monto_mb)
                        into
                          ps_comprometido
                    from  pre.tpartida_ejecucion pe, 
                           param.tperiodo per, 
                           param.tcentro_costo cc 
                    where      cc.id_tipo_cc = p_id_tipo_cc
                           and  pe.estado_reg = 'activo' 
                           and  pe.tipo_movimiento = 'comprometido'
                           and  cc.id_centro_costo = pe.id_presupuesto
                           and  pe.fecha BETWEEN per.fecha_ini and per.fecha_fin
                           and   per.id_periodo = p_id_periodo; 
                
        		ELSE 
                     select   
                          sum(pe.monto_mb)
                        into
                          ps_comprometido
                    from  pre.tpartida_ejecucion pe, 
                           param.tcentro_costo cc 
                    where      cc.id_tipo_cc = p_id_tipo_cc
                           and  pe.estado_reg = 'activo' 
                           and  pe.tipo_movimiento = 'comprometido'
                           and  cc.id_centro_costo = pe.id_presupuesto
                           and  pe.fecha::Date BETWEEN p_desde and p_hasta; 
        
           		END IF; 
           
                   
         
         END IF;
         
         IF p_tipo_importe = 'todos' or p_tipo_importe = 'ejecutado' THEN           
           
           
           		IF p_id_periodo is not null THEN
           
                   select   
                        sum(pe.monto_mb)
                      into
                        ps_ejecutado
                   from  pre.tpartida_ejecucion pe, 
                             param.tperiodo per, 
                             param.tcentro_costo cc 
                      where      cc.id_tipo_cc = p_id_tipo_cc
                             AND  pe.estado_reg = 'activo' 
                             and  pe.tipo_movimiento = 'ejecutado'
                             and  cc.id_centro_costo = pe.id_presupuesto
                             and pe.fecha BETWEEN per.fecha_ini and per.fecha_fin
                             and  per.id_periodo = p_id_periodo;
           
           		ELSE
                
                   select   
                        sum(pe.monto_mb)
                      into
                        ps_ejecutado
                   from  pre.tpartida_ejecucion pe, 
                             param.tcentro_costo cc 
                      where      cc.id_tipo_cc = p_id_tipo_cc
                             AND  pe.estado_reg = 'activo' 
                             and  pe.tipo_movimiento = 'ejecutado'
                             and  cc.id_centro_costo = pe.id_presupuesto
                             and  pe.fecha::Date BETWEEN p_desde and p_hasta;
           
           		END IF;
           
           
            
         END IF;   
     
      
      
     END IF;

       

      
      return NEXT;
      return;


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
COST 100 ROWS 1000;