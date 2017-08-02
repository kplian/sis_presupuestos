--------------- SQL ---------------

CREATE OR REPLACE FUNCTION pre.f_verificar_presupuesto_individual (
  p_nro_tramite varchar,
  p_id_partida_ejecucion integer,
  p_id_presupuesto integer,
  p_id_partida integer,
  p_monto_total_mb numeric,
  p_monto_total numeric,
  p_sw_momento varchar
)
RETURNS varchar [] AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Presupuestos
 FUNCION: 		pre.f_verificar_presupuesto_individual
 DESCRIPCION:   funcion que verifica si el monto puede procesarce
 
                se asume que la moneda no puede varia entre comprometido ejecutado y pagado
                para  hacer el calculo en moneda base y moneda de trasaccion            
 
  
 AUTOR: 		Rensi Arteaga Copari
 FECHA:	        24/03/2016
 COMENTARIOS:	
 -------------------------------
 MODIFICACIONES
 AUTOR: 		Rensi Arteaga Copari
 FECHA:	        29/06/2017
 COMENTARIOS:	SE agrega la opcion para permitir selecionar la logica de verifiaciones 
                es permitido  por presupeusto , por categoria programatica y se adiciona 
                la logica para arboles en tipo_cc  ,
                tambien opcionalmente la logica para controlar por partida o no
***************************************************************************/


DECLARE
  verificado numeric[];
  v_consulta varchar;
  v_conexion varchar;
  v_resp	varchar;
  v_sincronizar varchar;
 
  
  v_nombre_funcion  		varchar;
  
  v_total_formulado 		numeric;
  v_total_comprometido		numeric;
  v_total_ejecutado			numeric;
  v_total_pagado			numeric;
  v_total_revertido			numeric;
  v_saldo					numeric;
  
  v_total_formulado_mb 		numeric;
  v_total_comprometido_mb	numeric;
  v_total_ejecutado_mb		numeric;
  v_total_revertido_mb		numeric;
  v_saldo_mb				numeric;
  v_total_pagado_mb			numeric;
  
  
  v_respuesta						varchar[];
  v_pre_verificar_categoria			varchar;
  v_id_categoria_programatica		integer;
  v_pre_verificar_tipo_cc			varchar;
  v_id_tipo_cc_techo 				integer;
  v_control_partida					varchar;
  
BEGIN



            v_nombre_funcion = 'pre.f_verificar_presupuesto_individual';
            
            v_pre_verificar_categoria = pxp.f_get_variable_global('pre_verificar_categoria');
            v_pre_verificar_tipo_cc = pxp.f_get_variable_global('pre_verificar_tipo_cc');
            v_control_partida = 'si'; --por defeto controlamos los monstos por partidas
            
            IF v_pre_verificar_categoria = 'si' THEN
               -- obtener categoria a partir del presupuesto
               select 
                  p.id_categoria_prog
               into
                 v_id_categoria_programatica  
               from pre.tpresupuesto p
               where  p.id_presupuesto = p_id_presupuesto;
               
            ELSE
            
                IF v_pre_verificar_tipo_cc = 'si' THEN
                     -- obtener el tipo_cc techo  a partir del presupuesto
                     
                     select 
                        tcc.id_tipo_cc_techo,
                        tcc.control_partida
                     into
                       v_id_tipo_cc_techo ,
                       v_control_partida 
                     from pre.tpresupuesto p
                     inner join param.tcentro_costo cc on cc.id_centro_costo = p.id_centro_costo
                     inner join param.vtipo_cc_techo tcc on tcc.id_tipo_cc = cc.id_tipo_cc
                     where  p.id_presupuesto = p_id_presupuesto;
               
                 END IF;
            
            
            END IF;
     
           -- si tenemos partida ejecucion  obtener partida y presupuesto
            
           -- raise exception 'monto total.. %',p_monto_total_mb;
        
            IF p_monto_total_mb >= 0 THEN
                   -- si el monto es positivo
                   
                   
                         ----------------------
                         --  si es formulado
                         ----------------------
                         
                        IF p_sw_momento  = 'formulado' THEN 
                        
                             -- como es positivo no necesita verificaciones
                             
                             --  sumamos el formulado para esta partida y presupuesto
                             select 
                                sum(pe.monto_mb)
                             into 
                               v_total_formulado_mb
                             from pre.tpartida_ejecucion pe
                             inner join pre.tpresupuesto p on p.id_presupuesto = pe.id_presupuesto
                             inner join param.tcentro_costo cc on cc.id_centro_costo = p.id_centro_costo
                             inner join param.vtipo_cc_techo tcc on tcc.id_tipo_cc = cc.id_tipo_cc
                             where 
                                   
                                   ( CASE WHEN v_control_partida = 'si'  THEN 
                                         pe.id_partida = p_id_partida
                                     ELSE
                                         0=0
                                     END)
                                   
                                   and pe.estado_reg = 'activo'
                                   and pe.tipo_movimiento = 'formulado'
                                   and  (
                                            CASE WHEN v_pre_verificar_categoria = 'si'  THEN  
                                                  p.id_categoria_prog = v_id_categoria_programatica 
                                            WHEN v_pre_verificar_tipo_cc = 'si'  THEN
                                                  tcc.id_tipo_cc_techo = v_id_tipo_cc_techo       
                                            ELSE
                                                  pe.id_presupuesto = p_id_presupuesto 
                                            END);
                                   
                                   
                            
                             v_respuesta[1] = 'true';
                             v_respuesta[2] = COALESCE(v_total_formulado_mb,0);
                           
                        -------------------------
                        --  si es comprometer
                        -------------------------
                        
                        ELSEIF p_sw_momento  = 'comprometido' THEN 
                        
                               --  verificar que el monto formulado - comprometido sea suficiente
                               
                               IF p_id_partida is null or p_id_presupuesto is null THEN
                                  raise exception 'para verificar el comprometido tiene que indicar la partida y el presupeusto';
                               END IF;
                               
                               --  sumamos el formulado para esta partida y presupuesto
                               select 
                                  sum(pe.monto_mb)
                               into 
                                 v_total_formulado_mb
                               from pre.tpartida_ejecucion pe
                               inner join pre.tpresupuesto p on p.id_presupuesto = pe.id_presupuesto
                               inner join param.tcentro_costo cc on cc.id_centro_costo = p.id_centro_costo
                               inner join param.vtipo_cc_techo tcc on tcc.id_tipo_cc = cc.id_tipo_cc
                               where ( CASE WHEN v_control_partida = 'si'  THEN 
                                         pe.id_partida = p_id_partida
                                     ELSE
                                         0=0
                                     END)
                                     and pe.estado_reg = 'activo'
                                     and pe.tipo_movimiento = 'formulado'
                                     and  (
                                            CASE WHEN v_pre_verificar_categoria = 'si'  THEN  
                                                  p.id_categoria_prog = v_id_categoria_programatica
                                            WHEN v_pre_verificar_tipo_cc = 'si'  THEN  
                                                  tcc.id_tipo_cc_techo = v_id_tipo_cc_techo           
                                            ELSE
                                                  pe.id_presupuesto = p_id_presupuesto 
                                            END);
                                     
                              --sumamos el comprometido      
                              select 
                                  sum(pe.monto_mb)
                              into 
                                 v_total_comprometido_mb
                              from pre.tpartida_ejecucion pe
                              inner join pre.tpresupuesto p on p.id_presupuesto = pe.id_presupuesto
                              inner join param.tcentro_costo cc on cc.id_centro_costo = p.id_centro_costo
                              inner join param.vtipo_cc_techo tcc on tcc.id_tipo_cc = cc.id_tipo_cc
                              where ( CASE WHEN v_control_partida = 'si'  THEN 
                                         pe.id_partida = p_id_partida
                                     ELSE
                                         0=0
                                     END)
                                     and pe.estado_reg = 'activo'
                                     and pe.tipo_movimiento = 'comprometido'
                                     and  (
                                            CASE WHEN v_pre_verificar_categoria = 'si'  THEN  
                                                  p.id_categoria_prog = v_id_categoria_programatica
                                            WHEN v_pre_verificar_tipo_cc = 'si'  THEN  
                                                  tcc.id_tipo_cc_techo = v_id_tipo_cc_techo     
                                            ELSE
                                                  pe.id_presupuesto = p_id_presupuesto 
                                            END);       
                           
                              v_saldo_mb = COALESCE(v_total_formulado_mb,0) - COALESCE(v_total_comprometido_mb,0);
                              
                              IF p_monto_total_mb <= v_saldo_mb THEN
                                v_respuesta[1] = 'true';
                              ELSE  
                                v_respuesta[1] = 'false';
                              END IF;
                              
                             v_respuesta[2] = v_saldo_mb::varchar;
                           
                        
                        ------------------------
                        --  SI ES EJECUTAR
                        -----------------------
                        
                        ELSEIF  p_sw_momento  = 'ejecutado' THEN                  
                                 --verficar que el monto comprometido - ejecutado sea suficiente
                                 
                                 IF p_nro_tramite is null  THEN
                                        raise exception 'para ejecutar necesitamos el número de tramite';
                                 END IF;
                                
                                 --recuperar la partida y el presupuesto
                                 IF p_id_partida is null or p_id_presupuesto is null THEN
                                  
                                       IF  p_id_partida_ejecucion is NULL  THEN
                                           raise exception 'si no especifica la partida y presupuesto es necesario al menos la partida ejecución';
                                       END IF;
                                     
                                      select
                                        pe.id_partida,
                                        pe.id_presupuesto
                                      into
                                        p_id_partida,
                                        p_id_presupuesto
                                      from pre.tpartida_ejecucion pe
                                      where pe.id_partida_ejecucion = p_id_partida_ejecucion;
                                      
                                 END IF;
                      
                                --listamos el monto comprometido 
                                
                                 select
                                   sum(pe.monto_mb),
                                   sum(pe.monto)
                                 into
                                   v_total_comprometido_mb,
                                   v_total_comprometido
                                 from pre.tpartida_ejecucion pe
                                 where pe.estado_reg = 'activo'
                                       and pe.id_partida = p_id_partida            
                                       and pe.id_presupuesto = p_id_presupuesto
                                       and pe.nro_tramite = p_nro_tramite
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
                                       and pe.id_partida = p_id_partida
                                       and pe.id_presupuesto = p_id_presupuesto
                                       and pe.nro_tramite = p_nro_tramite
                                       and pe.tipo_movimiento = 'ejecutado';
                              
                              v_saldo =   COALESCE(v_total_comprometido,0) -  COALESCE(v_total_ejecutado,0);
                              v_saldo_mb =   COALESCE(v_total_comprometido_mb,0) -  COALESCE(v_total_ejecutado_mb,0);       
                                       
                              IF p_monto_total_mb <= v_saldo_mb THEN
                                v_respuesta[1] = 'true';
                                v_respuesta[2] = v_saldo_mb::varchar;
                              ELSE  
                                v_respuesta[1] = 'false';
                                v_respuesta[2] = v_saldo_mb::varchar;
                              END IF; 
                              
                              IF p_monto_total <= v_saldo THEN
                                v_respuesta[3] = 'true';
                                v_respuesta[4] = v_saldo::varchar;
                              ELSE  
                                v_respuesta[3] = 'false';
                                v_respuesta[4] = v_saldo::varchar;
                              END IF;        
                        
                        
                        -------------------
                        -- SI ES PAGADO
                        --------------------
                        
                        ELSEIF  p_sw_momento  = 'pagado' THEN
                                 
                                  -- si es pagar verificar que el monto ejecutado sea suficiente
                                    IF p_nro_tramite is null  THEN
                                        raise exception 'para pagar necesitamos el número de tramite';
                                     END IF;
                                    
                                     --recuperar la partida y el presupuesto
                                     IF p_id_partida is null or p_id_presupuesto is null THEN
                                      
                                           IF  p_id_partida_ejecucion is NULL  THEN
                                               raise exception 'si no especifica la partida y presupuesto es necesario al menos la partida ejecución';
                                           END IF;
                                         
                                          select
                                            pe.id_partida,
                                            pe.id_presupuesto
                                          into
                                            p_id_partida,
                                            p_id_presupuesto
                                          from pre.tpartida_ejecucion pe 
                                          
                                          where pe.id_partida_ejecucion = p_id_partida_ejecucion;
                                     END IF;
                          
                                    --listamos el monto comprometido 
                                    
                                     select
                                       sum(pe.monto_mb),
                                       sum(pe.monto)
                                     into
                                       v_total_ejecutado_mb,
                                       v_total_ejecutado
                                     from pre.tpartida_ejecucion pe
                                     where pe.estado_reg = 'activo'
                                           and pe.id_partida = p_id_partida
                                           and pe.id_presupuesto = p_id_presupuesto
                                           and pe.nro_tramite = p_nro_tramite
                                           and pe.tipo_movimiento = 'ejecutado';       
                                           
                                           
                                  --listamso el monto ejectuado
                                  
                                   select
                                       sum(pe.monto_mb),
                                       sum(pe.monto)
                                     into
                                       v_total_pagado_mb,
                                       v_total_pagado
                                     from pre.tpartida_ejecucion pe
                                     where pe.estado_reg = 'activo'
                                           and pe.id_partida = p_id_partida
                                           and pe.id_presupuesto = p_id_presupuesto
                                           and pe.nro_tramite = p_nro_tramite
                                           and pe.tipo_movimiento = 'pagado'; 
                                  
                                  v_saldo_mb =    COALESCE(v_total_ejecutado_mb,0) -   COALESCE(v_total_pagado_mb,0);
                                  v_saldo =    COALESCE(v_total_ejecutado,0) -   COALESCE(v_total_pagado,0);       
                                           
                                  IF p_monto_total_mb <= v_saldo_mb THEN
                                    v_respuesta[1] = 'true';
                                    v_respuesta[2] = v_saldo_mb::varchar;
                                  ELSE  
                                    v_respuesta[1] = 'false';
                                    v_respuesta[2] = v_saldo_mb::varchar;
                                  END IF; 
                                  
                                  IF p_monto_total <= v_saldo THEN
                                    v_respuesta[3] = 'true';
                                    v_respuesta[4] = v_saldo::varchar;
                                  ELSE  
                                    v_respuesta[3] = 'false';
                                    v_respuesta[4] = v_saldo::varchar;
                                  END IF;        
                        
                        ELSE
                           raise exception 'momento desconocido % ', p_sw_momento;
                        END IF;
              
                 
                 ---------------------------- 
                 -- si el monto es negativo 
                 -----------------------------
                  
                 ELSE
                 
                        -----------------------------------      
                        --  SI ES REVERSION DEL FORMULADO,
                        -----------------------------------
                        
                        IF p_sw_momento  = 'formulado' THEN 
                        
                               --  verifica que el monto sea menor que el formulado - el comprometido
                               IF p_id_partida is null or p_id_presupuesto is null THEN
                                  raise exception 'para verificar la reversion del formulado tiene que indicar la partida y el presupeusto';
                               END IF;
                               
                               --  sumamos el formulado para esta partida y presupuesto
                               select 
                                  sum(pe.monto_mb)
                               into 
                                 v_total_formulado_mb
                               from pre.tpartida_ejecucion pe
                               inner join pre.tpresupuesto p on p.id_presupuesto = pe.id_presupuesto
                               inner join param.tcentro_costo cc on cc.id_centro_costo = p.id_centro_costo
                               inner join param.vtipo_cc_techo tcc on tcc.id_tipo_cc = cc.id_tipo_cc
                               where ( CASE WHEN v_control_partida = 'si'  THEN 
                                         pe.id_partida = p_id_partida
                                     ELSE
                                         0=0
                                     END)
                                     and pe.estado_reg = 'activo'
                                     and pe.tipo_movimiento = 'formulado'
                                     and  (
                                            CASE WHEN v_pre_verificar_categoria = 'si'  THEN  
                                                  p.id_categoria_prog = v_id_categoria_programatica 
                                     		WHEN v_pre_verificar_tipo_cc = 'si'  THEN  
                                                  tcc.id_tipo_cc_techo = v_id_tipo_cc_techo  
                                            ELSE
                                                  pe.id_presupuesto = p_id_presupuesto 
                                            END);
                                     
                                     
                              --sumamos el comprometido      
                              select 
                                  sum(pe.monto_mb)
                              into 
                                 v_total_comprometido_mb
                              from pre.tpartida_ejecucion pe
                              inner join pre.tpresupuesto p on p.id_presupuesto = pe.id_presupuesto
                              inner join param.tcentro_costo cc on cc.id_centro_costo = p.id_centro_costo
                              inner join param.vtipo_cc_techo tcc on tcc.id_tipo_cc = cc.id_tipo_cc
                              where ( CASE WHEN v_control_partida = 'si'  THEN 
                                         pe.id_partida = p_id_partida
                                     ELSE
                                         0=0
                                     END)
                                     and pe.estado_reg = 'activo'
                                     and pe.tipo_movimiento = 'comprometido'
                                     and  (
                                            CASE WHEN v_pre_verificar_categoria = 'si'  THEN  
                                                  p.id_categoria_prog = v_id_categoria_programatica 
                                            WHEN v_pre_verificar_tipo_cc = 'si'  THEN  
                                                  tcc.id_tipo_cc_techo = v_id_tipo_cc_techo  
                                            ELSE
                                                  pe.id_presupuesto = p_id_presupuesto 
                                            END);       
                           
                              v_saldo_mb = COALESCE(v_total_formulado_mb,0) - COALESCE(v_total_comprometido_mb,0);
                              
                              IF (p_monto_total_mb*-1) <= v_saldo_mb THEN
                                v_respuesta[1] = 'true';
                              ELSE  
                                v_respuesta[1] = 'false';
                             END IF;
                              
                             v_respuesta[2] = v_saldo_mb::varchar;
                           
                          -------------------------------------
                          --  SI ES REVERSION DEL COMPROMETIDO 
                          -------------------------------------
                          
                         ELSEIF p_sw_momento  = 'comprometido' THEN 
                            -- verificar que el monto sea menor que el comprometido - el ejecutado
                           
                                      IF p_nro_tramite is null  THEN
                                           raise exception 'para revertir el comprometido necesitamos el número de tramite';
                                      END IF;
                                    
                                     --recuperar la partida y el presupuesto
                                     IF p_id_partida is null or p_id_presupuesto is null THEN
                                      
                                           IF  p_id_partida_ejecucion is NULL  THEN
                                               raise exception 'si no especifica la partida y presupuesto es necesario al menos la partida ejecución';
                                           END IF;
                                         
                                          select
                                            pe.id_partida,
                                            pe.id_presupuesto
                                          into
                                            p_id_partida,
                                            p_id_presupuesto
                                          from pre.tpartida_ejecucion pe 
                                          
                                          where pe.id_partida_ejecucion = p_id_partida_ejecucion;
                                     END IF;
                          
                                    --listamos el monto comprometido 
                                    
                                     select
                                       sum(pe.monto_mb),
                                       sum(pe.monto)
                                     into
                                       v_total_comprometido_mb,
                                       v_total_comprometido
                                     from pre.tpartida_ejecucion pe
                                     where pe.estado_reg = 'activo'
                                           and pe.id_partida = p_id_partida
                                           and pe.id_presupuesto = p_id_presupuesto
                                           and pe.nro_tramite = p_nro_tramite
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
                                           and pe.id_partida = p_id_partida
                                           and pe.id_presupuesto = p_id_presupuesto
                                           and pe.nro_tramite = p_nro_tramite
                                           and pe.tipo_movimiento = 'ejecutado';
                                  
                                  v_saldo =   COALESCE(v_total_comprometido,0) -  COALESCE(v_total_ejecutado,0);
                                  v_saldo_mb =   COALESCE(v_total_comprometido_mb,0) -  COALESCE(v_total_ejecutado_mb,0);       
                                           
                                  IF (p_monto_total_mb*-1) <= v_saldo_mb THEN
                                    v_respuesta[1] = 'true';
                                    v_respuesta[2] = v_saldo_mb::varchar;
                                  ELSE  
                                    v_respuesta[1] = 'false';
                                    v_respuesta[2] = v_saldo_mb::varchar;
                                  END IF; 
                                  
                                  IF (p_monto_total*-1) <= v_saldo THEN
                                    v_respuesta[3] = 'true';
                                    v_respuesta[4] = v_saldo::varchar;
                                  ELSE  
                                    v_respuesta[3] = 'false';
                                    v_respuesta[4] = v_saldo::varchar;
                                  END IF;        
                               
                         -----------------------------------
                         --  SI ES REVERSION DEL EJECUTADO
                         ------------------------------------ 
                         ELSEIF  p_sw_momento  = 'ejecutado' THEN
                                --verficar que el monto sea menor que  el ejecutado - pagado
                                
                                    IF p_nro_tramite is null  THEN
                                        raise exception 'para revertir el ejecutado necesitamos el número de tramite';
                                     END IF;
                                    
                                     --recuperar la partida y el presupuesto
                                     IF p_id_partida is null or p_id_presupuesto is null THEN
                                      
                                           IF  p_id_partida_ejecucion is NULL  THEN
                                               raise exception 'si no especifica la partida y presupuesto es necesario al menos la partida ejecución';
                                           END IF;
                                         
                                          select
                                            pe.id_partida,
                                            pe.id_presupuesto
                                          into
                                            p_id_partida,
                                            p_id_presupuesto
                                          from pre.tpartida_ejecucion pe 
                                          
                                          where pe.id_partida_ejecucion = p_id_partida_ejecucion;
                                     END IF;
                          
                                    --listamos el monto ejecutado 
                                    
                                     select
                                       sum(pe.monto_mb),
                                       sum(pe.monto)
                                     into
                                       v_total_ejecutado_mb,
                                       v_total_ejecutado
                                     from pre.tpartida_ejecucion pe
                                     where pe.estado_reg = 'activo'
                                           and pe.id_partida = p_id_partida
                                           and pe.id_presupuesto = p_id_presupuesto
                                           and pe.nro_tramite = p_nro_tramite
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
                                           and pe.id_partida = p_id_partida
                                           and pe.id_presupuesto = p_id_presupuesto
                                           and pe.nro_tramite = p_nro_tramite
                                           and pe.tipo_movimiento = 'pagado';
                                  
                                  v_saldo_mb =   COALESCE(v_total_ejecutado_mb,0) -  COALESCE(v_total_pagado_mb,0);
                                  v_saldo =   COALESCE(v_total_ejecutado,0) -  COALESCE(v_total_pagado,0);       
                                           
                                  IF (p_monto_total_mb*-1) <= v_saldo_mb THEN
                                    v_respuesta[1] = 'true';
                                    v_respuesta[2] = v_saldo_mb::varchar;
                                  ELSE  
                                    v_respuesta[1] = 'false';
                                    v_respuesta[2] = v_saldo_mb::varchar;
                                  END IF; 
                                  
                                  IF (p_monto_total*-1) <= v_saldo THEN
                                    v_respuesta[3] = 'true';
                                    v_respuesta[4] = v_saldo::varchar;
                                  ELSE  
                                    v_respuesta[3] = 'false';
                                    v_respuesta[4] = v_saldo::varchar;
                                  END IF; 
                        
                         ------------------------------------------
                         -- SI ES REVERSION DEL PAGO
                         ------------------------------------------
                         ELSEIF  p_sw_momento  = 'pagado' THEN
                              --verifica que el monto no sea menor que el pagado
                              
                              
                              IF p_nro_tramite is null  THEN
                                        raise exception 'para revertir el pagado  necesitamos el número de tramite';
                                     END IF;
                                    
                                     --recuperar la partida y el presupuesto
                                     IF p_id_partida is null or p_id_presupuesto is null THEN
                                      
                                           IF  p_id_partida_ejecucion is NULL  THEN
                                               raise exception 'si no especifica la partida y presupuesto es necesario al menos la partida ejecución';
                                           END IF;
                                         
                                          select
                                            pe.id_partida,
                                            pe.id_presupuesto
                                          into
                                            p_id_partida,
                                            p_id_presupuesto
                                          from pre.tpartida_ejecucion pe 
                                          
                                          where pe.id_partida_ejecucion = p_id_partida_ejecucion;
                                    END IF;
                          
                                  --listamso el monto pagado
                                  
                                  select
                                       sum(pe.monto_mb),
                                       sum(pe.monto)
                                     into
                                       v_total_pagado_mb,
                                       v_total_pagado
                                     from pre.tpartida_ejecucion pe
                                     where pe.estado_reg = 'activo'
                                           and pe.id_partida = p_id_partida
                                           and pe.id_presupuesto = p_id_presupuesto
                                           and pe.nro_tramite = p_nro_tramite
                                           and pe.tipo_movimiento = 'pagado';
                                  
                                 v_saldo_mb =  COALESCE(v_total_pagado_mb,0);
                                 v_saldo =   COALESCE(v_total_pagado,0);       
                                           
                                 IF (p_monto_total_mb*-1) <= v_saldo_mb THEN
                                    v_respuesta[1] = 'true';
                                    v_respuesta[2] = v_saldo_mb::varchar;
                                 ELSE  
                                    v_respuesta[1] = 'false';
                                    v_respuesta[2] = v_saldo_mb::varchar;
                                 END IF; 
                                  
                                 IF (p_monto_total*-1) <= v_saldo THEN
                                    v_respuesta[3] = 'true';
                                    v_respuesta[4] = v_saldo::varchar;
                                 ELSE  
                                    v_respuesta[3] = 'false';
                                    v_respuesta[4] = v_saldo::varchar;
                                 END IF; 
                              
                         
                         ELSE
                           raise exception 'momento desconocido % ', p_sw_momento;
                        END IF;
                 
                  END IF;
            
      

     return v_respuesta;


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