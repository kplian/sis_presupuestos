--------------- SQL ---------------

CREATE OR REPLACE FUNCTION pre.f_verificar_com_eje_pag (
  p_id_partida_ejecucion integer,
  p_id_moneda integer,
  p_conexion varchar = NULL::character varying,
  p_tipo_control varchar = 'nro_tramite'::character varying,
  out ps_comprometido numeric,
  out ps_ejecutado numeric,
  out ps_pagado numeric
)
RETURNS SETOF record AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Presupuestos
 FUNCION: 		pre.f_verificar_com_eje_pag
 DESCRIPCION:   Funcion que verifica:
                   el saldo comprometido,
                   monto ejecutado
                   monto pagado 
                   
 AUTOR: 		Rensi Aarteaga Copari
 FECHA:	        04-07-2013
 COMENTARIOS:	
 
 
  ISSUE            FECHA:		      AUTOR       DESCRIPCION
 0	, ETR			13/11/2017			RAC			Sse activa la verficacion presupesutaria por nro de tramite, fueron relizadas pruebas en adqusicioens y obligaciones de pago (comprometer, ejecutar, revertir) , aparentemente todo se ve bien
 0,	  ETR			01/12/2017          RAC			Se agrega el parametro p_tipo_control, para definir si controlamso por nro de tramite o por partida ejecucion,  en rediciones de tesoria no se 
                                                    necesita el control por partida , ya al revertir presupuesto si dos facturas afectna la misma partida y presupuesto
                                                    se revertia todo en el primer regitro y daba error al revertir el segundo por que ya no tenia presupesuto para revertir 	 		
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

  v_nombre_funcion = 'pre.f_verificar_com_eje_pag';

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
     
   
      -- si la sincronizacion no esta activa busca en el sistema de presupeusto local en PXP
          IF  p_tipo_control = 'nro_tramite' THEN
             -- esta aprte funciona bien con nro de tramite 
             -- pero es necesario una similar a laversion de endesis
             --  que separa por partida ejeucion  por la necesida d de compatibilidad
               
             --13/11/2017, se habilitar la versifcion por nro de tramite en ETR
            
                  select 
                      pe.nro_tramite,
                      pe.id_presupuesto,
                      pe.id_partida,
                      pe.id_moneda
                  into
                      v_nro_tramite,
                      v_id_presupuesto,
                      v_id_partida,
                      v_id_moneda
                 from pre.tpartida_ejecucion pe
                 where pe.id_partida_ejecucion = p_id_partida_ejecucion; 
                       
              
                IF v_id_moneda != p_id_moneda THEN
                  raise exception 'La moneda indicada no se corresponde con la moneda de la transacción';
                END IF;
                
               --  listamos el monto comprometido 
                                  
               select
                 sum(pe.monto_mb),
                 sum(pe.monto)
               into
                 v_total_comprometido_mb,
                 v_total_comprometido
               from pre.tpartida_ejecucion pe
               where pe.estado_reg = 'activo'
                     and pe.id_partida = v_id_partida
                     and pe.id_presupuesto = v_id_presupuesto
                     and pe.nro_tramite = v_nro_tramite
                     and pe.tipo_movimiento = 'comprometido';      
                                         
                                         
              --listamso el monto ejectuado
                                
               select
                   sum(pe.monto_mb),
                   sum(pe.monto)
                 into
                   v_total_ejecutado_mb,
                   v_total_ejecutado
                 from pre.tpartida_ejecucion pe
                 where pe.estado_reg = 'activo'
                       and pe.id_partida = v_id_partida
                       and pe.id_presupuesto = v_id_presupuesto
                       and pe.nro_tramite = v_nro_tramite
                       and pe.tipo_movimiento = 'ejecutado';
                 
                --listamso el monto pagado
               select
                   sum(pe.monto_mb),
                   sum(pe.monto)
                 into
                   v_total_pagado_mb,
                   v_total_pagado
                 from pre.tpartida_ejecucion pe
                 where pe.estado_reg = 'activo'
                       and pe.id_partida = v_id_partida
                       and pe.id_presupuesto = v_id_presupuesto
                       and pe.nro_tramite = v_nro_tramite
                       and pe.tipo_movimiento = 'pagado';
               
                
              ps_comprometido = v_total_comprometido;
              ps_ejecutado = v_total_ejecutado;
              ps_pagado = v_total_pagado;
      
       ELSE
         
               --  recuperar la raiz
                WITH RECURSIVE path_rec(id_partida_ejecucion, id_partida_ejecucion_fk ) AS (
                    SELECT  
                      pe.id_partida_ejecucion,
                      pe.id_partida_ejecucion_fk
                    FROM pre.tpartida_ejecucion pe 
                    WHERE pe.id_partida_ejecucion = p_id_partida_ejecucion
              	
                    UNION
                    SELECT
                      pe2.id_partida_ejecucion,
                      pe2.id_partida_ejecucion_fk
                    FROM pre.tpartida_ejecucion pe2
                    inner join path_rec  pr on pe2.id_partida_ejecucion = pr.id_partida_ejecucion_fk
                      
              	     
                )
                SELECT 
                  id_partida_ejecucion 
                into
                  id_partida_ejecucion_raiz
                FROM path_rec order by id_partida_ejecucion limit 1 offset 0;
                  
                 
               --suma todos los miembro segun su tipo 
               FOR v_registros in ( 
                                  WITH RECURSIVE path_rec(
                                          id_partida_ejecucion, 
                                          id_partida_ejecucion_fk,
                                          monto,
                                          monto_mb,
                                          tipo_movimiento ) AS (
                                            
                                      SELECT  
                                        pe.id_partida_ejecucion,
                                        pe.id_partida_ejecucion_fk,
                                        pe.monto,
                                        pe.monto_mb,
                                        pe.tipo_movimiento
                                          
                                      FROM pre.tpartida_ejecucion pe 
                                      WHERE pe.id_partida_ejecucion = id_partida_ejecucion_raiz
                                	
                                      UNION
                                      SELECT
                                        pe2.id_partida_ejecucion,
                                        pe2.id_partida_ejecucion_fk,
                                        pe2.monto,
                                        pe2.monto_mb,
                                        pe2.tipo_movimiento
                                      FROM pre.tpartida_ejecucion pe2
                                      inner join path_rec  pr on pe2.id_partida_ejecucion_fk = pr.id_partida_ejecucion
                                  )
                                   SELECT  
                                            sum(monto) as total,
                                            sum(monto_mb) as total_mb,
                                            tipo_movimiento 
                                          FROM path_rec 
                                          group by  tipo_movimiento) LOOP
                 
                 
                 
                       IF v_registros.tipo_movimiento = 'comprometido' THEN
                           ps_comprometido = v_registros.total;
                       ELSIF v_registros.tipo_movimiento = 'ejecutado' THEN
                           ps_ejecutado = v_registros.total;
                       ELSIF v_registros.tipo_movimiento = 'pagado' THEN
                           ps_pagado = v_registros.total;
                       ELSE
                          raise exception 'momento no reconocido %' , v_registros.tipo_movimiento; 
                       END IF;
                 
               END LOOP;
              
         
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