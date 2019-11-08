--------------- SQL ---------------

CREATE OR REPLACE FUNCTION pre.f_verificar_com_eje_pag_tipo_cc (
  p_id_partida_ejecucion integer,
  p_id_moneda integer,
  p_conexion varchar = NULL::character varying,
  out ps_comprometido numeric,
  out ps_ejecutado numeric,
  out ps_pagado numeric
)
RETURNS SETOF record AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Presupuestos
 FUNCION: 		pre.f_verificar_com_eje_pag_tipo_cc
 DESCRIPCION:   Funcion que verifica:
                   el saldo comprometido,
                   monto ejecutado
                   monto pagado 
                   
 AUTOR: 		Rensi Aarteaga Copari
 FECHA:	       10/10/2019
 COMENTARIOS:	
 
 
  ISSUE            FECHA:		      AUTOR       DESCRIPCION
 #21   ETR        10/10/2019        RAC KPLIAN      creacion
 #22   ETR        22/10/2019        RAC KPLIAN      considerar moneda de retorno en f_verificar_com_eje_pag_tipo_cc
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
  v_id_tipo_cc_techo			integer;
  v_contro_partida              varchar;  
  v_id_moneda_base              integer; --#22  
  
  
BEGIN

  v_nombre_funcion = 'pre.f_verificar_com_eje_pag_tipo_cc';
  
  v_id_moneda_base = param.f_get_moneda_base(); --#22

  v_sincronizar=pxp.f_get_variable_global('sincronizar');
  v_pre_integrar_presupuestos = pxp.f_get_variable_global('pre_integrar_presupuestos');
  
  
  IF v_pre_integrar_presupuestos = 'true' THEN 
  
      
         select
           cc.gestion::integer
         into
           v_gestion           
         from pre.tpartida_ejecucion p
         inner join pre.vpresupuesto_cc cc on cc.id_presupuesto = p.id_presupuesto
         where p.id_partida_ejecucion = p_id_partida_ejecucion;
      
          select 
              pe.nro_tramite,
              pe.id_presupuesto,
              pe.id_partida,
              pe.id_moneda,
              tct.id_tipo_cc_techo,
              tct.control_partida
          into
              v_nro_tramite,
              v_id_presupuesto,
              v_id_partida,
              v_id_moneda,
              v_id_tipo_cc_techo,
              v_contro_partida
         from pre.tpartida_ejecucion pe
         inner join param.tcentro_costo cc on cc.id_centro_costo = pe.id_presupuesto
         inner join param.vtipo_cc_techo tct on tct.id_tipo_cc = cc.id_tipo_cc
         where pe.id_partida_ejecucion = p_id_partida_ejecucion; 
         
               
        IF v_id_moneda != p_id_moneda THEN
          raise exception 'La moneda indicada no se corresponde con la moneda de la transacción';
        END IF;
                
       --  listamos el monto comprometido 
                                  
       select
         sum(pe.monto_mb)
       into
         v_total_comprometido_mb
       from pre.tpartida_ejecucion pe
       inner join param.tcentro_costo cc on cc.id_centro_costo = pe.id_presupuesto
       inner join param.vtipo_cc_techo tct on tct.id_tipo_cc = cc.id_tipo_cc
       where pe.estado_reg = 'activo'
             and ( (v_contro_partida = 'si' and pe.id_partida = v_id_partida) or v_contro_partida = 'no')
             and tct.id_tipo_cc_techo = v_id_tipo_cc_techo
             and pe.nro_tramite = v_nro_tramite
             and pe.tipo_movimiento = 'comprometido';      
                                         
                                         
      --listamso el monto ejectuado
                                
       select
           sum(pe.monto_mb)
         into
           v_total_ejecutado_mb
         from pre.tpartida_ejecucion pe
         inner join param.tcentro_costo cc on cc.id_centro_costo = pe.id_presupuesto
         inner join param.vtipo_cc_techo tct on tct.id_tipo_cc = cc.id_tipo_cc
         where pe.estado_reg = 'activo'
               and ( (v_contro_partida = 'si' and pe.id_partida = v_id_partida) or v_contro_partida = 'no')
               and tct.id_tipo_cc_techo = v_id_tipo_cc_techo
               and pe.nro_tramite = v_nro_tramite
               and pe.tipo_movimiento = 'ejecutado';
                 
        --listamso el monto pagado
       select
           sum(pe.monto_mb)
         into
           v_total_pagado_mb
         from pre.tpartida_ejecucion pe
         inner join param.tcentro_costo cc on cc.id_centro_costo = pe.id_presupuesto
         inner join param.vtipo_cc_techo tct on tct.id_tipo_cc = cc.id_tipo_cc
         where pe.estado_reg = 'activo'
               and ( (v_contro_partida = 'si' and pe.id_partida = v_id_partida) or v_contro_partida = 'no')
               and tct.id_tipo_cc_techo = v_id_tipo_cc_techo
               and pe.nro_tramite = v_nro_tramite
               and pe.tipo_movimiento = 'pagado';
               
               
      --si la moenda de retorno no esbase hacemos la conversiones necesarias         
      IF v_id_moneda =  v_id_moneda_base  THEN
        ps_comprometido = v_total_comprometido_mb;
        ps_ejecutado = v_total_ejecutado_mb;
        ps_pagado = v_total_pagado_mb;
      
      ELSE
        
          
         ps_comprometido =  param.f_convertir_moneda(
                          v_id_moneda_base,
                          v_id_moneda,   
                          v_total_comprometido_mb,
                          now()::date,  --TODO revisar que fecha se podria usar, recibir como parametro
                          'O',-- tipo oficial, venta, compra
                          NULL);--defecto dos decimales
                          
         ps_ejecutado =  param.f_convertir_moneda(
                          v_id_moneda_base,
                          v_id_moneda,   
                          v_total_ejecutado_mb,
                          now()::date,  --TODO revisar que fecha se podria usar, recibir como parametro
                          'O',-- tipo oficial, venta, compra
                          NULL);--defecto dos decimales 
                                          
                           
          ps_pagado =  param.f_convertir_moneda(
                          v_id_moneda_base,
                          v_id_moneda,   
                          v_total_pagado_mb,
                          now()::date,  --TODO revisar que fecha se podria usar, recibir como parametro
                          'O',-- tipo oficial, venta, compra
                          NULL);--defecto dos decimales                   
      
      END IF;          
      
      
     
     
 ELSE
     ps_comprometido = 0;
     ps_ejecutado = 0;
     ps_pagado = 0;
  
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