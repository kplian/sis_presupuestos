--------------- SQL ---------------

CREATE OR REPLACE FUNCTION pre.f_fun_inicio_ajuste_wf (
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
*  DESC:    funcion que actualiza los estados de los ajsutes presupeustarios
*  Fecha:   10/06/2016
***************************************************************************
  HISTORIAL DE MODIFICACIONES:
  	
 ISSUE            FECHA:		      AUTOR       DESCRIPCION
 0				12/10/2017			RAC			Validacion para comprometer o revertir presupuesto
***************************************************************************/


DECLARE

	v_nombre_funcion   	text;
    v_resp    			varchar;
    v_mensaje 			varchar;
    
    v_registros 		record;
    v_registros_det		record;
    v_monto_ejecutar_mo			numeric;
    v_id_uo						integer;
    v_id_usuario_excepcion		integer;
    v_resp_doc 					boolean;
    v_id_usuario_firma			integer;
    v_id_moneda_base			integer;
    v_fecha						date;
    sw_incremento				boolean;
    sw_decremento				boolean;
    v_resultado_ges				numeric[]; 
    v_mensaje_error 			varchar;
    v_sw_error 					boolean;
    sw_revertir 				boolean;
    sw_comprometer				boolean;
   
	
    
BEGIN

	  v_nombre_funcion = 'pre.f_fun_inicio_ajuste_wf';
    
       ----------------------------------------
       -- actualiza estado en la solicitud
       ---------------------------------------
       
       update pre.tajuste   set 
           id_estado_wf =  p_id_estado_wf,
           estado = p_codigo_estado,
           id_usuario_mod=p_id_usuario,
           id_usuario_ai = p_id_usuario_ai,
           usuario_ai = p_usuario_ai,
           fecha_mod=now()
       where id_proceso_wf = p_id_proceso_wf;
   
      -------------------------------------------------------------------------
      --  si pasa al estado aprobado registramos el ajuste presupuestario
      ------------------------------------------------------------------------
       
      IF p_codigo_estado = 'aprobado' THEN
         
              select 
                 a.id_ajuste,
                 a.tipo_ajuste,
                 a.importe_ajuste,
                 a.nro_tramite,
                 a.fecha,
                 a.id_moneda
              into
                v_registros
              from pre.tajuste a
              where a.id_proceso_wf = p_id_proceso_wf;
          
            v_id_moneda_base = param.f_get_moneda_base();
            sw_incremento = false;
            sw_decremento = false;
            v_sw_error = false;
            v_mensaje_error = '';
             
             -- valida
             
            
             IF v_registros.tipo_ajuste in ('traspaso','reformulacion') THEN
                 sw_incremento = true;
                 sw_decremento = true;
                 sw_comprometer = false;
                 sw_revertir = false;
             ELSEIF  v_registros.tipo_ajuste = 'decremento' THEN
                 sw_incremento = false;
                 sw_decremento = true;
                 sw_comprometer = false;
                 sw_revertir = false;
             ELSEIF  v_registros.tipo_ajuste = 'incremento' THEN
                 sw_incremento = true;
                 sw_decremento = false; 
                 sw_comprometer = false;
                 sw_revertir = false;
             
             ELSEIF  v_registros.tipo_ajuste in ( 'inc_comprometido') THEN
                 sw_incremento = false;
                 sw_decremento = false;     
                 sw_comprometer = true;
                 sw_revertir = false;
            ELSEIF  v_registros.tipo_ajuste in ('rev_comprometido') THEN
                 sw_incremento = false;
                 sw_decremento = false;     
                 sw_comprometer = false;
                 sw_revertir = true;   
                 
             ELSE
                 raise exception 'no se reconoce el tipo de ajuste %', v_registros.tipo_ajuste;
             END IF;
             
             
             IF sw_decremento  THEN
                 -- listar decrementos
                 FOR v_registros_det in (
                                        select
                                          ad.id_ajuste_det,
                                          ad.id_presupuesto,
                                          ad.id_partida,
                                          ad.importe ,
                                          par.codigo as codigo_partida,
                                          pre.estado as estado_presupuesto
                                        from pre.tajuste_det ad
                                        inner join pre.tpresupuesto pre on pre.id_presupuesto = ad.id_presupuesto
                                        inner join pre.tpartida par on par.id_partida = ad.id_partida
                                        where ad.id_ajuste = v_registros.id_ajuste
                                              and ad.tipo_ajuste = 'decremento'
                                              and ad.estado_reg = 'activo'
                                       ) LOOP
                        
                        -- valida estado del presupuesto
                        IF v_registros_det.estado_presupuesto != 'aprobado'  THEN
                          raise exception 'el pesupuesto id %, no esta aprobado', v_registros_det.id_presupuesto;
                        END IF;
                 
                        -- registras decrementos
                        v_resultado_ges = pre.f_gestionar_presupuesto_individual(
                                                p_id_usuario, 
                                                NULL, 
                                                v_registros_det.id_presupuesto, 
                                                v_registros_det.id_partida, 
                                                v_id_moneda_base, 
                                                v_registros_det.importe, 
                                                v_registros.fecha,
                                                'formulado', --traducido a varchar
                                                NULL, --p_id_partida_ejecucion
                                                'id_ajuste_det', 
                                                v_registros_det.id_ajuste_det, 
                                                v_registros.nro_tramite, 
                                                NULL,
                                                v_registros_det.importe);
                                                
                                                
                                                
                         ------------------------
                         --  ACUMULAR ERRORES
                         -----------------------
                                         
                         --  analizamos respuesta y retornamos error
                         IF v_resultado_ges[1] = 0 THEN
                                           
                                 --  recuperamos datos del presupuesto
                                 v_mensaje_error = v_mensaje_error|| conta.f_armar_error_presupuesto(v_resultado_ges, 
                                                                               v_registros_det.id_presupuesto, 
                                                                               v_registros_det.codigo_partida, 
                                                                               v_id_moneda_base, 
                                                                               v_id_moneda_base, 
                                                                               'reformulado', 
                                                                               v_registros_det.importe);
                                 v_sw_error = true;
                                                 
                          ELSE
                                   -- sino se tiene error almacenamos el id de la aprtida ejecucion
                                   update pre.tajuste_det a set
                                           id_partida_ejecucion = v_resultado_ges[2],  
                                           fecha_mod = now(),
                                           id_usuario_mod = p_id_usuario
                                   where a.id_ajuste_det  =  v_registros_det.id_ajuste_det;
                                   
                                                  
                          END IF; --fin id de error                        
                     
                 END LOOP;
              
             END IF;
             
             IF sw_incremento  and (not v_sw_error) THEN  
                 
                 
                 --listar incrementos
                 FOR v_registros_det in (
                                        select
                                          ad.id_ajuste_det,
                                          ad.id_presupuesto,
                                          ad.id_partida,
                                          ad.importe ,
                                          par.codigo as codigo_partida,
                                          pre.estado as estado_presupuesto
                                        from pre.tajuste_det ad
                                        inner join pre.tpresupuesto pre on pre.id_presupuesto = ad.id_presupuesto
                                        inner join pre.tpartida par on par.id_partida = ad.id_partida
                                        where ad.id_ajuste = v_registros.id_ajuste
                                              and ad.tipo_ajuste = 'incremento'
                                              and ad.estado_reg = 'activo'
                                       ) LOOP
                                       
                       
                        
                        -- valida estado del presupuesto
                        IF v_registros_det.estado_presupuesto != 'aprobado'  THEN
                          raise exception 'el pesupuesto id %, no esta aprobado', v_registros_det.id_presupuesto;
                        END IF;
                 
                        -- registras decrementos
                        v_resultado_ges = pre.f_gestionar_presupuesto_individual(
                                                p_id_usuario, 
                                                NULL, 
                                                v_registros_det.id_presupuesto, 
                                                v_registros_det.id_partida, 
                                                v_id_moneda_base, 
                                                v_registros_det.importe, 
                                                v_registros.fecha,
                                                'formulado', --traducido a varchar
                                                NULL, --p_id_partida_ejecucion
                                                'id_ajuste_det', 
                                                v_registros_det.id_ajuste_det, 
                                                v_registros.nro_tramite, 
                                                NULL,
                                                v_registros_det.importe);
                                                
                                                
                                                
                         ------------------------
                         --  ACUMULAR ERRORES
                         -----------------------
                                         
                         --  analizamos respuesta y retornamos error
                         IF v_resultado_ges[1] = 0 THEN
                                           
                                 --  recuperamos datos del presupuesto
                                 v_mensaje_error = v_mensaje_error|| conta.f_armar_error_presupuesto(v_resultado_ges, 
                                                                               v_registros_det.id_presupuesto, 
                                                                               v_registros_det.codigo_partida, 
                                                                               v_registros.id_moneda, 
                                                                               v_id_moneda_base, 
                                                                               'reformulado', 
                                                                               v_registros_det.importe);
                                 v_sw_error = true;
                                                 
                          ELSE
                                   -- sino se tiene error almacenamos el id de la aprtida ejecucion
                                   update pre.tajuste_det a set
                                           id_partida_ejecucion = v_resultado_ges[2],  
                                           fecha_mod = now(),
                                           id_usuario_mod = p_id_usuario
                                   where a.id_ajuste_det  =  v_registros_det.id_ajuste_det;
                                   
                         END IF; --fin id de error                        
                     
                 END LOOP;
             
             END IF;
             
             ----------------------------------------
             -- Manejo de compromisos de presupuesto
             -----------------------------------------
                         
              IF sw_comprometer or sw_revertir  THEN
              
                 --listar incrementos
                 FOR v_registros_det in (
                                        select
                                          ad.id_ajuste_det,
                                          ad.id_presupuesto,
                                          ad.id_partida,
                                          ad.importe ,
                                          par.codigo as codigo_partida,
                                          pre.estado as estado_presupuesto
                                        from pre.tajuste_det ad
                                        inner join pre.tpresupuesto pre on pre.id_presupuesto = ad.id_presupuesto
                                        inner join pre.tpartida par on par.id_partida = ad.id_partida
                                        where ad.id_ajuste = v_registros.id_ajuste and 
                                              case when sw_revertir then
                                                       ad.tipo_ajuste = 'decremento'
                                                   else
                                                       ad.tipo_ajuste = 'incremento'
                                                   end
                                             
                                              and ad.estado_reg = 'activo'
                                       ) LOOP
                                       
                       
                        
                        -- valida estado del presupuesto
                        IF v_registros_det.estado_presupuesto != 'aprobado'  THEN
                          raise exception 'el pesupuesto id %, no esta aprobado', v_registros_det.id_presupuesto;
                        END IF;
                 
                        -- registras decrementos
                        v_resultado_ges = pre.f_gestionar_presupuesto_individual(
                                                p_id_usuario, 
                                                NULL, 
                                                v_registros_det.id_presupuesto, 
                                                v_registros_det.id_partida, 
                                                v_registros.id_moneda,  --> moneda del ajuste
                                                v_registros_det.importe, 
                                                v_registros.fecha,
                                                'comprometido', --traducido a varchar
                                                NULL, --p_id_partida_ejecucion
                                                'id_ajuste_det', 
                                                v_registros_det.id_ajuste_det, 
                                                v_registros.nro_tramite, 
                                                NULL,
                                                v_registros_det.importe);
                                                
                                                
                                                
                         ------------------------
                         --  ACUMULAR ERRORES
                         -----------------------
                                         
                         --  analizamos respuesta y retornamos error
                         IF v_resultado_ges[1] = 0 THEN
                                           
                                 --  recuperamos datos del presupuesto
                                 v_mensaje_error = v_mensaje_error|| conta.f_armar_error_presupuesto(v_resultado_ges, 
                                                                               v_registros_det.id_presupuesto, 
                                                                               v_registros_det.codigo_partida, 
                                                                               v_id_moneda_base, 
                                                                               v_id_moneda_base, 
                                                                               'Comprometer', 
                                                                               v_registros_det.importe);
                                 v_sw_error = true;
                                                 
                          ELSE
                                   -- sino se tiene error almacenamos el id de la aprtida ejecucion
                                   update pre.tajuste_det a set
                                           id_partida_ejecucion = v_resultado_ges[2],  
                                           fecha_mod = now(),
                                           id_usuario_mod = p_id_usuario
                                   where a.id_ajuste_det  =  v_registros_det.id_ajuste_det;
                                   
                         END IF; --fin id de error                        
                     
                 END LOOP;
                
              
             END IF;
             
            
                  
            IF v_sw_error THEN
               raise exception 'Error al reformular presupuesto: %', v_mensaje_error;
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