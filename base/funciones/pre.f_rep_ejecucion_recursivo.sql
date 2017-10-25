--------------- SQL ---------------

CREATE OR REPLACE FUNCTION pre.f_rep_ejecucion_recursivo (
  p_id_partida_padre integer,
  p_codigo_partida_padre varchar,
  p_nombre_partida_padre varchar,
  p_id_presupuesto integer [],
  p_fecha_ini date,
  p_fecha_fin date,
  p_sw_transaccional varchar,
  p_nivel_partida integer,
  out ps_importe_total numeric,
  out ps_importe_aprobado_total numeric,
  out ps_formulado_total numeric,
  out ps_comprometido_total numeric,
  out ps_ejecutado_total numeric,
  out ps_pagado_total numeric,
  out ps_ajustado_total numeric
)
RETURNS record AS
$body$
DECLARE

    v_parametros  			record;
    v_registros 			record;
    v_reg_resp				record;
    v_reg_mov				record;
    v_nombre_funcion   		text;
    v_resp					varchar;
    v_nivel					integer;
    v_suma					numeric;
    v_mayor					numeric;
    va_mayor				numeric[];
    v_id_gestion  			integer;
    va_tipo_cuenta			varchar[];
    v_gestion 				integer;
    v_sw_force				boolean;
    v_importe				numeric;
    v_importe_aprobado		numeric;
    v_formulado				numeric;
    v_comprometido			numeric;
    v_ejecutado				numeric;
    v_pagado				numeric;
    v_ajustado 				numeric;
    v_porc_ejecucion		numeric;


BEGIN

          v_nombre_funcion = 'pre.f_rep_ejecucion_recursivo';
          
          ps_importe_total = 0;
          ps_importe_aprobado_total = 0;
          ps_formulado_total = 0;
          ps_comprometido_total = 0;
          ps_ejecutado_total = 0;
          ps_pagado_total = 0;
          ps_ajustado_total = 0;      
          
          -- iniciamos miembros es cero           
          FOR v_registros in (
           			          SELECT 
                                   par.id_partida,
                                   par.codigo as codigo_partida,
                                   par.id_partida_fk,
                                   par.nombre_partida,
                                   par.sw_transaccional,
                                   par.nivel_partida
                              FROM pre.tpartida par
                              WHERE 
                              
                                  case 
                                   when p_sw_transaccional = 'movimiento' then
                                     par.id_partida = p_id_partida_padre
                                   else
                                      par.id_partida_fk = p_id_partida_padre
                                   end )LOOP
                       
                       
                       -- si es partida de movimiento
                       IF v_registros.sw_transaccional = 'movimiento' THEN
                       
                             v_importe = 0;
                             v_importe_aprobado = 0;
                             v_formulado = 0;
                             v_comprometido = 0;
                             v_ejecutado = 0;
                             v_pagado = 0;
                             v_ajustado = 0;
                       
                            -- calculamos ejecucion para partida de movimiento
                            SELECT 
                                      prpa.id_partida,
                                      sum(COALESCE(prpa.importe, 0::numeric)) AS importe,
                                      sum(prpa.importe_aprobado) as importe_aprobado,
                                      sum(pre.f_get_estado_presupuesto_mb_x_fechas(prpa.id_presupuesto, prpa.id_partida,'formulado',p_fecha_ini,p_fecha_fin)) AS formulado,
                                      sum(pre.f_get_estado_presupuesto_mb_x_fechas(prpa.id_presupuesto, prpa.id_partida,'comprometido',p_fecha_ini,p_fecha_fin)) AS comprometido,
                                      sum(pre.f_get_estado_presupuesto_mb_x_fechas(prpa.id_presupuesto, prpa.id_partida,'ejecutado',p_fecha_ini,p_fecha_fin)) AS ejecutado,
                                      sum(pre.f_get_estado_presupuesto_mb_x_fechas(prpa.id_presupuesto, prpa.id_partida, 'pagado',p_fecha_ini,p_fecha_fin)) AS pagado
                                                      
                            into
                               v_reg_mov
                            FROM pre.tpresup_partida prpa
                            WHERE  
                                 prpa.id_partida = v_registros.id_partida
                                 and (CASE WHEN p_id_presupuesto[1] != 0 THEN 
                                        prpa.id_presupuesto = ANY(p_id_presupuesto)
                                      ELSE
                                        0 = 0
                                      END)
                             GROUP BY prpa.id_partida;
                              
                             v_importe = COALESCE(v_reg_mov.importe,0);
                             v_importe_aprobado = COALESCE(v_reg_mov.importe_aprobado,0);
                             v_formulado = COALESCE(v_reg_mov.formulado,0);
                             v_comprometido = COALESCE(v_reg_mov.comprometido,0);
                             v_ejecutado = COALESCE(v_reg_mov.ejecutado,0);
                             v_pagado = COALESCE(v_reg_mov.pagado,0);
                             
                             v_ajustado =  COALESCE(v_formulado,0)  - COALESCE(v_importe_aprobado,0);
                             
                             IF  v_importe_aprobado != 0 THEN
                               v_porc_ejecucion = round((v_reg_mov.ejecutado/v_importe_aprobado)*100,2);
                             ELSE
                               v_porc_ejecucion = 0;
                             END IF;
                         
                             --  insertamos partida 
                          IF  v_importe != 0  or
                              v_importe_aprobado != 0  or
                              v_formulado != 0  or
                              v_comprometido != 0  or
                              v_ejecutado != 0  or
                              v_pagado != 0  or
                              v_ajustado != 0  THEN
                             
                             INSERT into temp_prog (
                                      id_partida,
                                      codigo_partida,
                                      nombre_partida,
                                      id_partida_fk,
                                      nivel_partida,
                                      sw_transaccional,
                                      importe,
                                      importe_aprobado,
                                      formulado,
                                      comprometido,
                                      ejecutado,
                                      pagado,
                                      ajustado ,
                                      porc_ejecucion)
                                values (
                                      v_registros.id_partida,
                                      v_registros.codigo_partida,
                                      v_registros.nombre_partida,
                                      v_registros.id_partida_fk,
                                      v_registros.nivel_partida,
                                      v_registros.sw_transaccional,
                                      v_importe,
                                      v_importe_aprobado,
                                      v_formulado,
                                      v_comprometido,
                                      v_ejecutado,
                                      v_pagado,
                                      v_ajustado ,
                                      v_porc_ejecucion);
                          
                           END IF;
                           -- sumamos miembros
                           
                            ps_importe_total = ps_importe_total + v_importe;
                            ps_importe_aprobado_total = ps_importe_aprobado_total + v_importe_aprobado;
                            ps_formulado_total = ps_formulado_total + v_formulado;
                            ps_comprometido_total = ps_comprometido_total + v_comprometido;
                            ps_ejecutado_total = ps_ejecutado_total + v_ejecutado;
                            ps_pagado_total = ps_pagado_total + v_pagado;
                            ps_ajustado_total = ps_ajustado_total + v_ajustado;
                            
                          
                           
                       
                       ELSE
                       
                          --llamada recursiva
                          SELECT  
                                  rec.ps_importe_total,
                                  rec.ps_importe_aprobado_total,
                                  rec.ps_formulado_total,
                                  rec.ps_comprometido_total,
                                  rec.ps_ejecutado_total,
                                  rec.ps_pagado_total,
                                  rec.ps_ajustado_total
                              INTO  
                                 v_reg_resp 
                           FROM  pre.f_rep_ejecucion_recursivo(
                                                               v_registros.id_partida, 
                                                               v_registros.codigo_partida, 
                                                               v_registros.nombre_partida, 
                                                               p_id_presupuesto, 
                                                               p_fecha_ini, 
                                                               p_fecha_fin, 
                                                               v_registros.sw_transaccional, 
                                                               v_registros.nivel_partida) rec;
                                                             
                       
                       
                        -- sumamos miembros
                         ps_importe_total = ps_importe_total + v_reg_resp.ps_importe_total;
                         ps_importe_aprobado_total = ps_importe_aprobado_total + v_reg_resp.ps_importe_aprobado_total;
                         ps_formulado_total = ps_formulado_total + v_reg_resp.ps_formulado_total;
                         ps_comprometido_total = ps_comprometido_total + v_reg_resp.ps_comprometido_total;
                         ps_ejecutado_total = ps_ejecutado_total + v_reg_resp.ps_ejecutado_total;
                         ps_pagado_total = ps_pagado_total + v_reg_resp.ps_pagado_total;
                         ps_ajustado_total = ps_ajustado_total + v_reg_resp.ps_ajustado_total;
                       
                       END IF;
                       
          END LOOP;
          
      
          
          -- insertamos datos para el padre (con la suma de miembros)
          IF  ps_importe_aprobado_total != 0 THEN
           v_porc_ejecucion = round((ps_ejecutado_total/ps_importe_aprobado_total)*100,2);
          ELSE
           v_porc_ejecucion = 0;
          END IF;          
          
          IF  (ps_importe_total != 0  or
              ps_importe_aprobado_total != 0  or
              ps_formulado_total != 0  or
              ps_comprometido_total != 0  or
              ps_ejecutado_total != 0  or
              ps_pagado_total != 0  or
              ps_ajustado_total != 0) and p_sw_transaccional != 'movimiento'  THEN
              
          INSERT into temp_prog (
                        id_partida,
                        codigo_partida,
                        nombre_partida,
                        nivel_partida,
                        sw_transaccional,
                        importe,
                        importe_aprobado,
                        formulado,
                        comprometido,
                        ejecutado,
                        pagado,
                        ajustado ,
                        porc_ejecucion)
                  values (
                        p_id_partida_padre,
                        p_codigo_partida_padre,
                        p_nombre_partida_padre,
                        p_nivel_partida,
                        p_sw_transaccional,
                        ps_importe_total,
                        ps_importe_aprobado_total,
                        ps_formulado_total,
                        ps_comprometido_total,
                        ps_ejecutado_total,
                        ps_pagado_total,
                        ps_ajustado_total ,
                        v_porc_ejecucion);
          
         END IF;

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