--------------- SQL ---------------

CREATE OR REPLACE FUNCTION pre.f_fun_inicio_presupuesto_wf (
  p_id_usuario integer,
  p_id_usuario_ai integer,
  p_usuario_ai varchar,
  p_id_estado_wf integer,
  p_id_proceso_wf integer,
  p_codigo_estado varchar
)
RETURNS boolean AS
$body$
/*
*
*  Autor:   RAC
*  DESC:    funcion que actualiza los estados despues del registro de un retroceso en el plan de pago
*  Fecha:   10/06/2013
*
*/

DECLARE

	v_nombre_funcion   	text;
    v_resp    			varchar;
    v_mensaje 			varchar;
    
    v_registros 		record;
    v_regitros_pp		record;
    v_monto_ejecutar_mo			numeric;
    v_id_uo						integer;
    v_id_usuario_excepcion		integer;
    v_resp_doc 					boolean;
    v_id_usuario_firma			integer;
    v_id_moneda_base			integer;
    v_fecha						date; 
    v_importe_aprobado_total	numeric;
    v_importe_total				numeric;
   
	
    
BEGIN

	 v_nombre_funcion = 'pre.f_fun_inicio_presupuesto_wf';
    
     
    -- actualiza estado en la solicitud
    update pre.tpresupuesto   set 
       id_estado_wf =  p_id_estado_wf,
       estado = p_codigo_estado,
       id_usuario_mod=p_id_usuario,
       id_usuario_ai = p_id_usuario_ai,
       usuario_ai = p_usuario_ai,
       fecha_mod=now()
                   
    where id_proceso_wf = p_id_proceso_wf;
   

   --SIN LA INTER FACE ES DE VOBOPRE,  insertamos el resultado aprobado en la tabla partida ejecución
   
   IF p_codigo_estado = 'aprobado' THEN
   
          --recupera datos del presupuesto
          select 
             pre.id_presupuesto,
             pre.estado,
             pre.tipo_pres,
             pre.nro_tramite,
             cc.id_gestion,
             ges.gestion,
             tp.sw_oficial,
             pre.tipo_pres
          into
            v_registros
          from pre.tpresupuesto pre
          inner join param.tcentro_costo cc on cc.id_centro_costo = pre.id_centro_costo
          inner join param.tgestion ges on ges.id_gestion = cc.id_gestion
          inner join pre.ttipo_presupuesto tp on tp.codigo = pre.tipo_pres
          where pre.id_proceso_wf = p_id_proceso_wf;
          
          IF v_registros.tipo_pres  is null  THEN
             raise exception 'No tiene un tipo de presupuesto asignado';
          END IF;
          -- 
          SELECT 
             sum(pp.importe),
             sum(pp.importe_aprobado)
          into
             v_importe_total,
             v_importe_aprobado_total
          FROM pre.tpresup_partida pp
          where  pp.id_presupuesto =  v_registros.id_presupuesto 
                 and pp.estado_reg = 'activo';
                 
                 
         
          
          IF v_registros.sw_oficial = 'si' THEN
               IF (v_importe_aprobado_total is null or  v_importe_aprobado_total = 0) THEN 
                  raise exception 'No tiene ningun monto aprobado mayor a cero';
               END IF; 
          ELSE
              IF (v_importe_total is null or  v_importe_total = 0) THEN 
                 raise exception 'No tiene ningun monto formulado % - %', v_importe_total, v_importe_aprobado_total ;
              END IF; 
          END IF;
          
          
          -- recupera la moneda base (el importe aprobado esta en moneda base)
          v_id_moneda_base =  param.f_get_moneda_base();
          
          -- fecha de formulacion
          
          v_fecha= ('01-01-'|| v_registros.gestion::varchar)::date;
          
         
          --solo se lleva a partida ejeucion los presupeustos oficiales
          IF v_registros.sw_oficial = 'si'  THEN
             
                 -- lista todas las partidas
                 FOR v_regitros_pp in ( 
                                      SELECT 
                                        pp.id_presup_partida,
                                        pp.id_presupuesto,
                                        pp.id_partida,
                                        pp.importe_aprobado
                                      FROM pre.tpresup_partida pp
                                      where  pp.id_presupuesto =  v_registros.id_presupuesto 
                                             and pp.estado_reg = 'activo' ) LOOP
                
                           
                         INSERT INTO  pre.tpartida_ejecucion
                                                    (
                                                      id_usuario_reg,
                                                      fecha_reg,
                                                      estado_reg,                                           
                                                      nro_tramite,
                                                      monto,
                                                      monto_mb,
                                                      id_moneda,
                                                      id_presupuesto,
                                                      id_partida,
                                                      tipo_movimiento,
                                                      tipo_cambio,
                                                      fecha
                                                    )
                                                    VALUES (
                                                      p_id_usuario,
                                                      now(),
                                                      'activo',                                         
                                                      v_registros.nro_tramite,
                                                      v_regitros_pp.importe_aprobado, --moneda de formualcion
                                                      v_regitros_pp.importe_aprobado,  --moneda base
                                                      v_id_moneda_base,
                                                      v_registros.id_presupuesto,
                                                      v_regitros_pp.id_partida,
                                                      'formulado', --tipo_movimiento
                                                      1,  --tipo de cambios, moneda formulacion y moneda base (es la misma)
                                                      v_fecha
                                                    );
                
                    
                    END LOOP;
         END IF; 
      
   
   END IF;
   
   
   

RETURN   TRUE;



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