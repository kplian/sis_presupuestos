CREATE OR REPLACE FUNCTION pre.f_gestionar_presupuesto_v2 (
  p_id_usuario integer,
  p_tipo_cambio numeric,
  p_id_presupuesto integer,
  p_id_partida integer,
  p_id_moneda integer,
  p_monto_total numeric,
  p_monto_total_mb numeric,
  p_fecha date,
  p_sw_momento varchar,
  p_id_partida_ejecucion integer,
  p_columna_relacion varchar,
  p_fk_llave integer,
  p_nro_tramite varchar,
  p_id_int_comprobante integer = NULL::integer,
  p_sw_comprometer varchar = 'defecto'::character varying,
  p_sw_ejecutar varchar = 'defecto'::character varying,
  p_sw_pagar varchar = 'defecto'::character varying
)
RETURNS numeric [] AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Presupuestos
 FUNCION: 		pre.f_gestionar_presupuesto_v2
 DESCRIPCION:   ejecuta presupeusto directamente en pxp
 AUTOR: 		Rensi Arteaga Copari (kplian)
 FECHA:	        06-04-2016
 COMENTARIOS:
***************************************************************************/


DECLARE
  resultado 					record;
  v_consulta 					varchar;
  v_conexion 					varchar;
  v_resp						varchar;
  v_sincronizar 				varchar;
  v_function_name 				text;
  v_size 						integer;
  v_array_resp 					numeric[];
  v_str_id_presupuesto 			varchar;
  v_str_id_partida				varchar;
  v_pre_integrar_presupuestos	varchar;
  v_id_moneda_base				integer;
  v_monto_mb 					numeric;
  v_sw_momento					varchar;
  v_resultado_ges				numeric[];

BEGIN


 --raise exception 'zzzzzzzzzzzzz';
  v_function_name := 'pre.f_gestionar_presupuesto_v2';


  v_pre_integrar_presupuestos = pxp.f_get_variable_global('pre_integrar_presupuestos');


  v_id_moneda_base = param.f_get_moneda_base();
  --


 IF v_pre_integrar_presupuestos = 'true' THEN


           v_sw_momento = p_sw_momento;

          ------------------------------
          -- EJECUCIONES POSITIVAS
          ------------------------------

          IF    p_monto_total > 0 THEN


                --, si no tenemos comprometido, ...y queremos pagar directamente o ejecutar ????????
                IF  p_sw_comprometer = 'si' and v_sw_momento in ('ejecutado','pagado') THEN

                     --comprometemos
                     --ejecutamos por defecto solo lo solicitado
                     v_resultado_ges = pre.f_gestionar_presupuesto_individual(
                                              p_id_usuario,
                                              p_tipo_cambio,
                                              p_id_presupuesto,
                                              p_id_partida,
                                              p_id_moneda,
                                              p_monto_total,
                                              p_fecha,
                                              'comprometido'::varchar, --traducido a varchar
                                              p_id_partida_ejecucion::integer,
                                              p_columna_relacion,
                                              p_fk_llave,
                                              p_nro_tramite,
                                              p_id_int_comprobante,
                                              p_monto_total_mb);

                     --si tiene error retornamos
                     IF v_resultado_ges[1] = 0 THEN
                        return v_resultado_ges;
                     END IF;

                     --ejecutamos



                     v_resultado_ges = pre.f_gestionar_presupuesto_individual(
                                              p_id_usuario,
                                              p_tipo_cambio,
                                              p_id_presupuesto,
                                              p_id_partida,
                                              p_id_moneda,
                                              p_monto_total,
                                              p_fecha,
                                              'ejecutado'::varchar, --traducido a varchar
                                              v_resultado_ges[2]::integer,   --partida ejecucion
                                              p_columna_relacion,
                                              p_fk_llave,
                                              p_nro_tramite,
                                              p_id_int_comprobante,
                                              p_monto_total_mb);



                     IF  v_sw_momento = 'pagado' THEN

                         -- pagamos
                          v_resultado_ges = pre.f_gestionar_presupuesto_individual(
                                              p_id_usuario,
                                              p_tipo_cambio,
                                              p_id_presupuesto,
                                              p_id_partida,
                                              p_id_moneda,
                                              p_monto_total,
                                              p_fecha,
                                              'pagado'::varchar, --traducido a varchar
                                              v_resultado_ges[2]::integer,   --partida ejecucion
                                              p_columna_relacion,
                                              p_fk_llave,
                                              p_nro_tramite,
                                              p_id_int_comprobante,
                                              p_monto_total_mb);




                     END IF;




                ELSIF  p_sw_ejecutar = 'si' and v_sw_momento in ('ejecutado','pagado') THEN

                     --ejecutamos
                      v_resultado_ges = pre.f_gestionar_presupuesto_individual(
                                              p_id_usuario,
                                              p_tipo_cambio,
                                              p_id_presupuesto,
                                              p_id_partida,
                                              p_id_moneda,
                                              p_monto_total,
                                              p_fecha,
                                              'ejecutado'::varchar, --traducido a varchar
                                              p_id_partida_ejecucion::integer,   --partida ejecucion
                                              p_columna_relacion,
                                              p_fk_llave,
                                              p_nro_tramite,
                                              p_id_int_comprobante,
                                              p_monto_total_mb);

                      --si tiene error retornamos
                     IF v_resultado_ges[1] = 0 THEN
                        return v_resultado_ges;
                     END IF;


                     IF  v_sw_momento = 'pagado' THEN

                         -- pagamos
                         v_resultado_ges = pre.f_gestionar_presupuesto_individual(
                                              p_id_usuario,
                                              p_tipo_cambio,
                                              p_id_presupuesto,
                                              p_id_partida,
                                              p_id_moneda,
                                              p_monto_total,
                                              p_fecha,
                                              'pagado'::varchar, --traducido a varchar
                                              v_resultado_ges[2]::integer,   --partida ejecucion
                                              p_columna_relacion,
                                              p_fk_llave,
                                              p_nro_tramite,
                                              p_id_int_comprobante,
                                              p_monto_total_mb);



                      END IF;




                ELSE

                   --  ejecutamos por defecto solo lo solicitado
                   v_resultado_ges = pre.f_gestionar_presupuesto_individual(
                                            p_id_usuario,
                                            p_tipo_cambio,
                                            p_id_presupuesto,
                                            p_id_partida,
                                            p_id_moneda,
                                            p_monto_total,
                                            p_fecha,
                                            v_sw_momento, --traducido a varchar
                                            p_id_partida_ejecucion,
                                            p_columna_relacion,
                                            p_fk_llave,
                                            p_nro_tramite,
                                            p_id_int_comprobante,
                                            p_monto_total_mb);


                END IF;

        ELSEIF    p_monto_total < 0 THEN

            ----------------------------------
            --  SI SON REVERSIONES
            --
            ---------------------------------

            --  para revertirn es requerido el id partida ejeucion ????
            --  RESP 02/12/2016  no deberia ser necesario el id partida ejecucion por que en comprobantes manuales
            --  de serlo  no es posible identificarlo
            --  TODO ... hacerlo no obligatorio ...
            --   la reversion  funciona  sin partida ejecucion en el nuevo sistema de presupesutos
            --   aparentemente el id es requerido para trabajar con la primera  version de ENDESIS

            --  IF p_id_partida_ejecucion is null THEN
            --    raise exception 'para revertir es necesario indicar el id partida ejecucion original';
            -- END IF;


             IF  p_sw_ejecutar = 'si'  and v_sw_momento in ('ejecutado','pagado') THEN
                   -- revertir el pagado , ejecutado y comprometido

                   IF  v_sw_momento = 'pagado' THEN

                         v_resultado_ges = pre.f_gestionar_presupuesto_individual(
                                                p_id_usuario,
                                                p_tipo_cambio,
                                                p_id_presupuesto,
                                                p_id_partida,
                                                p_id_moneda,
                                                p_monto_total,
                                                p_fecha,
                                                'pagado'::varchar, --traducido a varchar
                                                p_id_partida_ejecucion::integer,
                                                p_columna_relacion,
                                                p_fk_llave,
                                                p_nro_tramite,
                                                p_id_int_comprobante,
                                                p_monto_total_mb);


                         --si tiene error retornamos
                         IF v_resultado_ges[1] = 0 THEN
                            return v_resultado_ges;
                         END IF;
                   END IF;

                   --revertimos el ejecutado
                   v_resultado_ges = pre.f_gestionar_presupuesto_individual(
                                            p_id_usuario,
                                            p_tipo_cambio,
                                            p_id_presupuesto,
                                            p_id_partida,
                                            p_id_moneda,
                                            p_monto_total,
                                            p_fecha,
                                            'ejecutado'::varchar, --traducido a varchar
                                            p_id_partida_ejecucion::integer,
                                            p_columna_relacion,
                                            p_fk_llave,
                                            p_nro_tramite,
                                            p_id_int_comprobante,
                                            p_monto_total_mb);

                   --si tiene error retornamos
                   IF v_resultado_ges[1] = 0 THEN
                      return v_resultado_ges;
                   END IF;

                   --ejecutado o pagado siempre revertimso el comprometido
                   v_resultado_ges = pre.f_gestionar_presupuesto_individual(
                                            p_id_usuario,
                                            p_tipo_cambio,
                                            p_id_presupuesto,
                                            p_id_partida,
                                            p_id_moneda,
                                            p_monto_total,
                                            p_fecha,
                                            'comprometido'::varchar, --traducido a varchar
                                            p_id_partida_ejecucion::integer,
                                            p_columna_relacion, 
                                            p_fk_llave, 
                                            p_nro_tramite, 
                                            p_id_int_comprobante,
                                            p_monto_total_mb);
             
              ELSE
                  
                  -- revertir solo el pagado, o solo el comprometido, o solo ele ejecutado
                      
                  v_resultado_ges = pre.f_gestionar_presupuesto_individual(
                                            p_id_usuario, 
                                            p_tipo_cambio, 
                                            p_id_presupuesto, 
                                            p_id_partida, 
                                            p_id_moneda, 
                                            p_monto_total, 
                                            p_fecha, 
                                            v_sw_momento, --traducido a varchar
                                            p_id_partida_ejecucion, 
                                            p_columna_relacion, 
                                            p_fk_llave, 
                                            p_nro_tramite, 
                                            p_id_int_comprobante,
                                            p_monto_total_mb);
                  
                  
             END IF ;
                          
       END IF;        
       
        v_array_resp = v_resultado_ges; --resultado de array
               
 ELSE

    raise notice 'no se integra con presupuestos';

 END IF;
 
  

  return v_array_resp;
  

EXCEPTION
					
	WHEN OTHERS THEN
			v_resp='';
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje',SQLERRM);
			v_resp = pxp.f_agrega_clave(v_resp,'codigo_error',SQLSTATE);
			v_resp = pxp.f_agrega_clave(v_resp,'procedimientos',v_function_name);
			raise exception '%',v_resp;
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;