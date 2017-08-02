--------------- SQL ---------------
 
CREATE OR REPLACE FUNCTION pre.f_balance_memoria (
  p_id_tipo_cc integer,
  p_id_periodo integer,
  p_desde date = NULL::date,
  p_hasta date = NULL::date
)
RETURNS numeric AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Presupuestos
 FUNCION: 		pre.f_balance_memoria
 DESCRIPCION:   Esta funcion obtiene el detalle de meoria de claculo por tipo de centro , partida y periodo
                   
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
  v_total						numeric;
  
  
BEGIN

  v_nombre_funcion = 'pre.f_balance_memoria';

  
  	 v_pre_integrar_presupuestos = pxp.f_get_variable_global('pre_integrar_presupuestos');
     
     v_total = 0;
    
  
     IF v_pre_integrar_presupuestos = 'true' THEN 
      
         
         select 
            sum(md.importe)
         into
            v_total
         from pre.tmemoria_det md
         inner join pre.tmemoria_calculo mc on mc.id_memoria_calculo = md.id_memoria_calculo
         inner join param.tcentro_costo cc on cc.id_centro_costo = mc.id_presupuesto
         inner join param.tperiodo pe on pe.id_periodo = md.id_periodo
         where     cc.id_tipo_cc = p_id_tipo_cc
               and mc.estado_reg = 'activo'
               and md.estado_reg = 'activo'
               and CASE
                  
                  WHEN p_id_periodo is not null then
                		md.id_periodo = p_id_periodo
                  ELSE
                        pe.fecha_ini BETWEEN p_desde and p_hasta
                        
                  END;
                 
           
     
      
      
     END IF;

     return v_total;


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