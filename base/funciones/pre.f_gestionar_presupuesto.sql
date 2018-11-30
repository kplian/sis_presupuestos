CREATE OR REPLACE FUNCTION pre.f_gestionar_presupuesto (
  p_id_usuario integer,
  p_tipo_cambio numeric,
  p_id_presupuesto integer [],
  p_id_partida integer [],
  p_id_moneda integer [],
  p_monto_total numeric [],
  p_fecha date [],
  p_sw_momento integer [],
  p_id_partida_ejecucion integer [],
  p_columna_relacion varchar [],
  p_fk_llave integer [],
  p_nro_tramite varchar [],
  p_id_int_comprobante integer = NULL::integer,
  p_conexion varchar = NULL::character varying,
  p_sw_comprometer varchar = 'defecto'::character varying,
  p_sw_ejecutar varchar = 'defecto'::character varying,
  p_sw_pagar varchar = 'defecto'::character varying
)
RETURNS numeric [] AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Presupuestos
 FUNCION: 		pre.f_gestionar_presupuesto
 DESCRIPCION:   Funcion que llama a la funcion presto.f_i_pr_gestionarpresupuesto mediante dblink
 AUTOR: 		Gonzalo Sarmiento Sejas (kplian)
 FECHA:	        15-03-2013
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
  v_function_name := 'pre.f_gestionar_presupuesto';
  
  v_sincronizar = pxp.f_get_variable_global('sincronizar');
  
  v_pre_integrar_presupuestos = pxp.f_get_variable_global('pre_integrar_presupuestos');
  
  
  v_id_moneda_base = param.f_get_moneda_base();
 
  
 IF v_pre_integrar_presupuestos = 'true' THEN  
     
    
             -- si la sincronizacion no esta activa busca en el sistema de presupeusto local en PXP
          
            IF p_nro_tramite is null THEN
               raise exception 'La gestion de presupeusto en KERP necesita un nro de tramite de forma obligatoria';
            END IF;
            
            
            --recorrer array y llamar a la funcion de ejecucion 
            FOR v_cont IN 1..array_length(p_monto_total, 1 ) LOOP
            
               
                -- traducir el momento numerico a varchar
                -- *** por herencia de ENDESIS
                IF p_sw_momento[v_cont] = 1 or p_sw_momento[v_cont] = 2 THEN
                    v_sw_momento = 'comprometido';
                END IF;
                
                IF p_sw_momento[v_cont] = 3  THEN
                    v_sw_momento = 'ejecutado';
                END IF;
                
                IF p_sw_momento[v_cont] = 4 THEN
                    v_sw_momento = 'pagado';
                END IF;
                
               
               --, si no tenemos comprometido, ...y queremos pagar directamente o ejecutar ????????
                IF  p_sw_comprometer = 'si' and v_sw_momento in ('ejecutado','pagado') THEN
                 
                     --comprometemos
                     --ejecutamos por defecto solo lo solicitado
                     v_resultado_ges = pre.f_gestionar_presupuesto_individual(
                                              p_id_usuario, 
                                              p_tipo_cambio, 
                                              p_id_presupuesto[v_cont], 
                                              p_id_partida[v_cont], 
                                              p_id_moneda[v_cont], 
                                              p_monto_total[v_cont], 
                                              p_fecha[v_cont], 
                                              'comprometido'::Varchar, --traducido a varchar
                                              p_id_partida_ejecucion[v_cont]::integer, 
                                              p_columna_relacion[v_cont], 
                                              p_fk_llave[v_cont], 
                                              p_nro_tramite[v_cont], 
                                              p_id_int_comprobante);
                                              
                                            
                     
                     
                     --ejecutamos
                     
                     v_resultado_ges = pre.f_gestionar_presupuesto_individual(
                                              p_id_usuario, 
                                              p_tipo_cambio, 
                                              p_id_presupuesto[v_cont], 
                                              p_id_partida[v_cont], 
                                              p_id_moneda[v_cont], 
                                              p_monto_total[v_cont], 
                                              p_fecha[v_cont], 
                                              'ejecutado'::varchar, --traducido a varchar
                                              v_resultado_ges[2]::integer,   --partida ejecucion
                                              p_columna_relacion[v_cont], 
                                              p_fk_llave[v_cont], 
                                              p_nro_tramite[v_cont], 
                                              p_id_int_comprobante);
                     
                  
                     
                     IF  v_sw_momento = 'pagado' THEN
                     
                         -- pagamos
                          v_resultado_ges = pre.f_gestionar_presupuesto_individual(
                                              p_id_usuario, 
                                              p_tipo_cambio, 
                                              p_id_presupuesto[v_cont], 
                                              p_id_partida[v_cont], 
                                              p_id_moneda[v_cont], 
                                              p_monto_total[v_cont], 
                                              p_fecha[v_cont], 
                                              'pagado'::varchar, --traducido a varchar
                                              v_resultado_ges[2]::integer,   --partida ejecucion
                                              p_columna_relacion[v_cont], 
                                              p_fk_llave[v_cont], 
                                              p_nro_tramite[v_cont], 
                                              p_id_int_comprobante);
                        
                                              
                                  
                         
                     END IF;
                   
                ELSIF  p_sw_ejecutar = 'si' and v_sw_momento in ('ejecutado','pagado') THEN 
               
                     --ejecutamos
                      v_resultado_ges = pre.f_gestionar_presupuesto_individual(
                                              p_id_usuario, 
                                              p_tipo_cambio, 
                                              p_id_presupuesto[v_cont], 
                                              p_id_partida[v_cont], 
                                              p_id_moneda[v_cont], 
                                              p_monto_total[v_cont], 
                                              p_fecha[v_cont], 
                                              'ejecutado', --traducido a varchar
                                              p_id_partida_ejecucion[v_cont],   --partida ejecucion
                                              p_columna_relacion[v_cont], 
                                              p_fk_llave[v_cont], 
                                              p_nro_tramite[v_cont], 
                                              p_id_int_comprobante);
                                              
                    
                                               
                          
                     IF  v_sw_momento = 'pagado' THEN
                                          
                    
                         -- pagamos
                         v_resultado_ges = pre.f_gestionar_presupuesto_individual(
                                              p_id_usuario, 
                                              p_tipo_cambio, 
                                              p_id_presupuesto[v_cont], 
                                              p_id_partida[v_cont], 
                                              p_id_moneda[v_cont], 
                                              p_monto_total[v_cont], 
                                              p_fecha[v_cont], 
                                              'pagado', --traducido a varchar
                                              v_resultado_ges[2],   --partida ejecucion
                                              p_columna_relacion[v_cont], 
                                              p_fk_llave[v_cont], 
                                              p_nro_tramite[v_cont], 
                                              p_id_int_comprobante);
                                              
                           
                         
                     END IF;
                    
                    
                ELSE
                   --raise exception 'llega % , %',v_sw_momento, p_monto_total[v_cont];
                   --  ejecutamos por defecto solo lo solicitado
                   v_resultado_ges = pre.f_gestionar_presupuesto_individual(
                                            p_id_usuario, 
                                            p_tipo_cambio, 
                                            p_id_presupuesto[v_cont], 
                                            p_id_partida[v_cont], 
                                            p_id_moneda[v_cont], 
                                            p_monto_total[v_cont], 
                                            p_fecha[v_cont], 
                                            v_sw_momento, --traducido a varchar
                                            p_id_partida_ejecucion[v_cont], 
                                            p_columna_relacion[v_cont], 
                                            p_fk_llave[v_cont], 
                                            p_nro_tramite[v_cont], 
                                            p_id_int_comprobante);
                                            
                      -- raise exception 'resultado ges %',v_resultado_ges;              
                END IF;
                
               
                          
                
               -- analizamos respuesta y retornamos error
               IF v_resultado_ges[1] = 0 THEN
               
                   /*
                     if p_monto_total[v_cont] < 0  THEN
                          raise exception 'estado: %  , %',  v_resultado_ges, p_monto_total[v_cont];
                     END IF; */
               
               
                   -- raise exception '- % , % , % , % -',v_sw_momento,  p_id_partida_ejecucion[v_cont], p_id_partida[v_cont],p_monto_total[v_cont];
                   --raise exception ' % ',v_resultado_ges;
                   
                   IF p_id_usuario = 429  THEN
                      --raise exception '%',v_resultado_ges;
                   
                   END  IF;
                  
                    IF v_resultado_ges[4] is not null and  v_resultado_ges[4] = 1  THEN
                        raise exception 'El presupuesto no es suficiente por diferencia cambiaria, en moneda base tenemos:  % saldo % PE %  momentos(%,%)',v_resultado_ges[3], v_resultado_ges[5], p_id_partida_ejecucion,p_sw_ejecutar, v_sw_momento;
                    ELSE
                        IF v_id_moneda_base = p_id_moneda[v_cont] THEN
                            raise exception 'Presupuesto insuficiente: se tiene disponible un monto en moneda base de:  %, # %, necesario: %', round(v_resultado_ges[3],2), p_nro_tramite[v_cont], round(p_monto_total[v_cont],2);   
                        ELSE
                            IF round(v_resultado_ges[5],2) > 0 THEN
                              raise exception 'Presupuesto insuficiente: se tiene disponible un monto de:  %, %', round(v_resultado_ges[5],2), p_nro_tramite[v_cont];
                            ELSE
                               raise exception 'Presupuesto insuficiente: se tiene disponible un monto en moneda BOB de:  %, # %, necesario: USD %', round(v_resultado_ges[3],2), p_nro_tramite[v_cont], round(p_monto_total[v_cont],2);   
                            END IF;
                            
                        END IF;
                      
                   END IF;
                   
               END IF;
               
               v_array_resp[v_cont] =  v_resultado_ges[2]; -- resultado de array
               
               
      
       END LOOP;
  
      
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