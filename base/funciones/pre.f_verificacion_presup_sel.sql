--------------- SQL ---------------

CREATE OR REPLACE FUNCTION pre.f_verificacion_presup_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS SETOF record AS
$body$
/**************************************************************************
PXP
***************************************************************************
 SCRIPT: 		pre.f_verificacion_presup_sel
 DESCRIPCIÓN: 	Verificación de disponibilidad presupuestaria sea en sistema de PXP o endesis si esta sincronizado para despliegue en ventana de consulta
 AUTOR: 		RCM
 FECHA:			19/12/2013
 COMENTARIOS:	
***************************************************************************
 HISTORIA DE MODIFICACIONES:

 DESCRIPCIÓN:
 AUTOR:       
 FECHA:      

***************************************************************************/
--------------------------
-- CUERPO DE LA FUNCIÓN --
--------------------------

-- PARÁMETROS FIJOS
/*
pm_id_usuario                               integer (si))
pm_ip_origen                                varchar(40) (si)
pm_mac_maquina                              macaddr (si)
pm_log_error                                varchar -- log -- error //variable interna (si)
pm_codigo_procedimiento                     varchar  // valor que identifica el tipo
                                                        de operacion a realizar
                                                        insert  (insertar)
                                                        delete  (eliminar)
                                                        update  (actualizar)
                                                        select  (visualizar)
pm_proc_almacenado                          varchar  // para colocar el nombre del procedimiento en caso de ser llamado
                                                        por otro procedimiento
*/

DECLARE

	v_parametros  		record;
    v_registros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;
    v_rec  				record;  -- PARA ALMACENAR EL CONJUNTO DE DATOS RESULTADO DEL SELECT
    pm_criterio_filtro 	varchar;
    v_sql				varchar;
    v_cadena_cnx		varchar;
    v_res_cone  		varchar;
    
    v_dat 				record;
    v_cont 				integer;
    va_id_centro_costo 	integer[];
    va_id_partida 		integer[];
    va_id_moneda 		integer[];
    va_importe 			numeric[];
    v_sincronizar 		varchar;
    v_id_moneda_base                integer;
    v_pre_verificar_categoria 		varchar;
    v_pre_verificar_tipo_cc 		varchar;
    v_control_partida 				varchar;

BEGIN


    v_nombre_funcion = 'pre.f_verificacion_presup_sel';
    v_parametros = pxp.f_get_record(p_tabla);
    
	/*********************************    
 	#TRANSACCION:  'PRE_VERPRE_SEL'
 	#DESCRIPCION:	Verifica la disponibilidad presupuestaria, consultando el saldo por comprometer
 	#AUTOR:			RCM	
 	#FECHA:			27/12/2013
	***********************************/

	if(p_transaccion='PRE_VERPRE_SEL')then
     				
    	begin
        
        	
            v_id_moneda_base =  param.f_get_moneda_base();        
            v_pre_verificar_categoria = pxp.f_get_variable_global('pre_verificar_categoria');
            v_pre_verificar_tipo_cc = pxp.f_get_variable_global('pre_verificar_tipo_cc');
            v_control_partida = 'si'; --por defeto controlamos los monstos por partidas 
            
           -- v_parametros.id
           
            
            --------------------------------------------
            --(1)PERSONALIZACION DE CONSULTA POR TABLA
             --------------------------------------------
                if v_parametros.tabla = 'tes.tobligacion_pago' then
                
                          FOR v_registros in (
                                      Select 
                                            ver.id_ver,
                                            ver.control_partida,
                                            ver.id_par,
                                            ver.id_agrupador,
                                            ver.monto_mo,
                                            ver.movimiento,
                                            ver.id_presupuestos[1] as id_presupuesto,
                                            ver.tipo_cambio,
                                            ver.monto_mb,
                                            ver.verificacion[1] as verificacion,
                                            ver.verificacion[2]::numeric as saldo,
                                            part.codigo as codigo_partida,
                                            part.nombre_partida,
                                            pcc.desc_tipo_presupuesto,
                                            pcc.descripcion,
                                            cp.descripcion::Varchar as desc_cp,
                                            cp.codigo_categoria::varchar,
                                            tc.codigo::varchar as  codigo_tcc,
                                            tc.descripcion::varchar as desc_tcc,
                                            v_pre_verificar_categoria  as pre_verificar_categoria,
                                            v_pre_verificar_tipo_cc as pre_verificar_tipo_cc
                                                             
                                        from ( 
                                                 Select
                                                  row_number() over() as id_ver, 
                                                  control_partida,
                                                  id_par,
                                                  id_agrupador,
                                                  id_presupuestos,
                                                  monto_pago_mo as monto_mo,
                                                  param.f_convertir_moneda (
                                                                                               
                                                                             id_moneda, 
                                                                             v_id_moneda_base,
                                                                             monto_pago_mo, 
                                                                             fecha,
                                                                             'CUS',50, 
                                                                             tipo_cambio, 'no') as monto_mb,
                                                  movimiento,
                                                  tipo_cambio,
                                                                    
                                                                    
                                                pre.f_verificar_presupuesto_individual(
                                                                    null, 
                                                                    null, 
                                                                    id_presupuestos[1], 
                                                                    id_par, 
                                                                    param.f_convertir_moneda (
                                                                             id_moneda, 
                                                                             v_id_moneda_base,
                                                                             monto_pago_mo, 
                                                                             fecha,
                                                                             'CUS',50, 
                                                                             tipo_cambio, 'no'), 
                                                                   monto_pago_mo, 
                                                                  'comprometido') as verificacion

                                                from ( SELECT tcc.control_partida,
                                                         CASE
                                                             WHEN v_pre_verificar_tipo_cc = 'si' and tcc.control_partida::text = 'no' THEN
                                                                0
                                                            ELSE 
                                                               od.id_partida
                                                         END AS id_par,
                                                         CASE
                                                           WHEN v_pre_verificar_categoria = 'si' THEN 
                                                               p.id_categoria_prog
                                                           WHEN v_pre_verificar_tipo_cc = 'si' THEN 
                                                              cc.id_tipo_cc
                                                           ELSE od.id_centro_costo 
                                                         END AS id_agrupador,
                                                         sum(od.monto_pago_mo) AS monto_pago_mo,
                                                                                                           
                                                         tp.movimiento,
                                                         pxp.aggarray(p.id_presupuesto) AS id_presupuestos,
                                                         avg(op.tipo_cambio_conv) as tipo_cambio,
                                                         op.fecha,
                                                         op.id_moneda
                                                                   
                                                   from tes.tobligacion_pago op
                                                        join tes.tobligacion_det od on od.id_obligacion_pago = op.id_obligacion_pago
                                                        JOIN pre.tpresupuesto p ON p.id_presupuesto = od.id_centro_costo
                                                        JOIN param.tcentro_costo cc ON cc.id_centro_costo =  od.id_centro_costo
                                                        JOIN pre.ttipo_presupuesto tp ON tp.codigo::text = p.tipo_pres::text
                                                        JOIN pre.tpartida par ON par.id_partida = od.id_partida
                                                        JOIN param.vtipo_cc_techo tcc ON tcc.id_tipo_cc = cc.id_tipo_cc
                                                   where op.id_obligacion_pago = v_parametros.id
                                                   group by  id_par, 
                                                              id_agrupador  ,    
                                                              tcc.control_partida,
                                                              tp.movimiento,
                                                              op.fecha,
                                                              op.id_moneda
                                                  ) xx)  ver
                                left join pre.tpartida part on  ver.id_par = part.id_partida
                                inner join pre.vpresupuesto_cc pcc on pcc.id_presupuesto = ver.id_presupuestos[1]
                                inner join pre.vcategoria_programatica cp on cp.id_categoria_programatica = pcc.id_categoria_prog
                                left join param.ttipo_cc tc on tc.id_tipo_cc = ver.id_agrupador)LOOP
                             
                             
                             RETURN NEXT v_registros;
                    
                    END LOOP;
             
             ELSEIF v_parametros.tabla = 'conta.tint_comprobante' then
            
                 FOR v_registros in (
                                       Select 
                                          ver.id_ver,
                                          ver.control_partida,
                                          ver.id_par,
                                          ver.id_agrupador,
                                          CASE  when ver.movimiento = 'gasto' then (ver.importe_debe-ver.importe_haber)
                                          ELSE  (ver.importe_haber - ver.importe_debe)
                                          END as monto_mo,
                                          ver.movimiento,
                                          ver.id_presupuestos[1] as id_presupuesto,
                                          ver.tipo_cambio,
                                          ver.monto_mb,
                                          ver.verificacion[1] as verificacion,
                                          ver.verificacion[2]::numeric as saldo,
                                          part.codigo as codigo_partida,
                                          part.nombre_partida,
                                          pcc.desc_tipo_presupuesto,
                                          pcc.descripcion,
                                          cp.descripcion::Varchar as desc_cp,
                                          cp.codigo_categoria::varchar,
                                          tc.codigo::varchar as  codigo_tcc,
                                          tc.descripcion::varchar as desc_tcc,
                                          v_pre_verificar_categoria  as pre_verificar_categoria,
                                          v_pre_verificar_tipo_cc as pre_verificar_tipo_cc
                                          
                                          

                                      from ( 
                                               Select
                                                row_number() over() as id_ver, 
                                                control_partida,
                                                id_par,
                                                id_agrupador,
                                                id_presupuestos,
                                                importe_debe,
                                                importe_haber,
                                                param.f_convertir_moneda (
                                                                           
                                                                           id_moneda, 
                                                                           v_id_moneda_base,
                                                                           CASE  when movimiento = 'gasto' then (importe_debe-importe_haber)
                                                                           ELSE  (importe_haber - importe_debe)
                                                                           END, 
                                                                           fecha,
                                                                           'CUS',50, 
                                                                           tipo_cambio, 'no') as monto_mb,
                                                movimiento,
                                                tipo_cambio,
                                                
                                                
                                              pre.f_verificar_presupuesto_individual(
                                                                  null, 
                                                                  null, 
                                                                  id_presupuestos[1], 
                                                                  id_par, 
                                                                  param.f_convertir_moneda (
                                                                           
                                                                           id_moneda, 
                                                                           v_id_moneda_base,
                                                                           CASE  when movimiento = 'gasto' then (importe_debe-importe_haber)
                                                                           ELSE  (importe_haber - importe_debe)
                                                                           END, 
                                                                           fecha,
                                                                           'CUS',50, 
                                                                           tipo_cambio, 'no'), 
                                                                   CASE  when movimiento = 'gasto' then (importe_debe-importe_haber)
                                                                   ELSE  (importe_haber - importe_debe)
                                                                   END, 
                                                                  'comprometido') as verificacion

                                              from ( SELECT tcc.control_partida,
                                                           CASE
                                                               WHEN v_pre_verificar_tipo_cc = 'si' and tcc.control_partida::text = 'no' THEN
                                                                  0
                                                              ELSE 
                                                                 it.id_partida
                                                           END AS id_par,
                                                           CASE
                                                             WHEN v_pre_verificar_categoria = 'si' THEN 
                                                                 p.id_categoria_prog
                                                             WHEN v_pre_verificar_tipo_cc = 'si' THEN 
                                                                cc.id_tipo_cc
                                                             ELSE it.id_centro_costo 
                                                           END AS id_agrupador,
                                                           sum(it.importe_debe) AS importe_debe,
                                                           sum(it.importe_haber) AS importe_haber,
                                                           
                                                           tp.movimiento,
                                                           pxp.aggarray(p.id_presupuesto) AS id_presupuestos,
                                                           avg(it.tipo_cambio) as tipo_cambio,
                                                           cbte.fecha,
                                                           cbte.id_moneda
                                                    FROM conta.tint_transaccion it
                                                         JOIN conta.tint_comprobante cbte ON cbte.id_int_comprobante = it.id_int_comprobante
                                                         JOIN pre.tpresupuesto p ON p.id_presupuesto = it.id_centro_costo
                                                         JOIN param.tcentro_costo cc ON cc.id_centro_costo = it.id_centro_costo
                                                         JOIN pre.ttipo_presupuesto tp ON tp.codigo::text = p.tipo_pres::text
                                                         JOIN pre.tpartida par ON par.id_partida = it.id_partida
                                                         JOIN param.vtipo_cc_techo tcc ON tcc.id_tipo_cc = cc.id_tipo_cc
                                                    WHERE     it.id_int_comprobante = v_parametros.id  
                                                          and tp.movimiento <> 'administrativo' 
                                                          and par.sw_movimiento = 'presupuestaria'
                                                          and it.id_partida_ejecucion  is null
                                                     group by  id_par, 
                                                              id_agrupador  ,    
                                                              tcc.control_partida,
                                                              tp.movimiento,
                                                              cbte.fecha,
                                                              cbte.id_moneda) xx)  ver
                              left join pre.tpartida part on  ver.id_par = part.id_partida
                              inner join pre.vpresupuesto_cc pcc on pcc.id_presupuesto = ver.id_presupuestos[1] 
                              left join pre.vcategoria_programatica cp on cp.id_categoria_programatica = pcc.id_categoria_prog
                			  left join param.ttipo_cc tc on tc.id_tipo_cc = ver.id_agrupador) LOOP
                               
                              
                               RETURN NEXT v_registros;
                     END LOOP;	
           
            else
            	
               
            raise exception 'Verificación presupuestaria para tabla % no implementada',v_parametros.tabla;
            	
           
           end if;
           
						
	
    end;
    
    
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
COST 100 ROWS 1000;