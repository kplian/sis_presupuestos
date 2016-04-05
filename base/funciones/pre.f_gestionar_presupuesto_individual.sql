--------------- SQL ---------------

CREATE OR REPLACE FUNCTION pre.f_gestionar_presupuesto_individual (
  p_id_usuario integer,
  p_tipo_cambio numeric,
  p_id_presupuesto integer,
  p_id_partida integer,
  p_id_moneda integer,
  p_monto_total numeric,
  p_fecha date,
  p_sw_momento varchar,
  p_id_partida_ejecucion integer,
  p_columna_relacion varchar,
  p_fk_llave integer,
  p_nro_tramite varchar,
  p_id_int_comprobante integer = NULL::integer
)
RETURNS numeric [] AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Presupuestos
 FUNCION: 		pre.f_gestionar_presupuesto_individual
 DESCRIPCION:   funcion que gestion el presupeusto uno por uno en PXP
 AUTOR: 		Rensi ARteaga (kplian)
 FECHA:	        23-03-2016
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
  v_monto	 					numeric;
  v_permitido					boolean;
  v_permitido_mt				boolean;
  v_verif_pres					varchar[];
  v_id_partida_ejecucion		integer;
  
BEGIN

  --momentos
  --formulado, comprometido, devengado, pagado, traspaso, modificacion (los revertidos son numeros negativos)

  v_function_name := 'pre.f_gestionar_presupuesto_individual';
  v_pre_integrar_presupuestos = pxp.f_get_variable_global('pre_integrar_presupuestos');
  v_id_moneda_base = param.f_get_moneda_base();
 


  
    IF v_pre_integrar_presupuestos = 'true' THEN  
     
          --  verificar que el presupuesto este  aprobado
          
          IF p_id_partida_ejecucion is not null THEN
          
             select 
                pe.id_presupuesto,
                pe.id_partida
             into
               p_id_presupuesto,
               p_id_partida
             from pre.tpartida_ejecucion pe
             where pe.id_partida_ejecucion = p_id_partida_ejecucion;
          
          END IF;
          
          
          IF not exists(select 
                          1
                        from pre.tpresupuesto pr
                        where pr.id_presupuesto = p_id_presupuesto
                              and  pr.estado = 'aprobado') THEN
                
               raise exception 'el presupuesto no se encuentra aprobado (id = %)', p_id_presupuesto; 
                
          END IF;
          
          
          --------------------------------------
          --  convertir el monto a moneda base
          --------------------------------------
          
            v_monto = p_monto_total;
          
            IF  v_id_moneda_base != p_id_moneda THEN
                  -- tenemos tipo de cambio
                  -- si el tipo de cambio es null utilza el cambio oficial para la fecha
                  v_monto_mb  =   param.f_convertir_moneda (
                             v_id_moneda_base, 
                             p_id_moneda,   
                             p_monto_total, 
                             p_fecha,
                             'CUS',50, 
                             p_tipo_cambio, 'no');
     
           ELSE
              v_monto_mb = p_monto_total;
           END IF;
           
           
           --TODO , ....  que ahcer cuando queremos pagar directamente ... pero no tenemos comprometido ni ejecutado?
            
           ----------------------------------------------------
           --  Validar que se cuente con el monto suficiente
           -----------------------------------------------------
           
           v_verif_pres  =  pre.f_verificar_presupuesto_individual(
                    p_nro_tramite, 
                    p_id_partida_ejecucion, 
                    p_id_presupuesto, 
                    p_id_partida, 
                    v_monto_mb, 
                    v_monto, 
                    p_sw_momento);
                    
            
            
              
                    
            IF v_verif_pres[1] = 'true' THEN
               v_permitido = true;
            ELSE
               v_permitido = false;
            END IF;
            
            IF v_verif_pres[3] = 'true' THEN
               v_permitido_mt = true;
            ELSE
               v_permitido_mt = false;
            END IF;
            
            --TODO ...   caso especial pagado permite sobregirar si por diferencia cambiaria 
            
            ---------------------------------
            -- Registor de partida ejecución
            ---------------------------------
            
             --  si esta permitido
             IF v_permitido = true THEN
                   --  registrar en la tabla partida ejecución
                 
                  INSERT INTO  pre.tpartida_ejecucion 
                                          (
                                            id_usuario_reg,
                                            fecha_reg,
                                            estado_reg,
                                            id_partida_ejecucion_fk,
                                            nro_tramite,
                                            monto,
                                            monto_mb,
                                            id_moneda,
                                            id_presupuesto,
                                            id_partida,
                                            tipo_movimiento,
                                            tipo_cambio,
                                            fecha,
                                            id_int_comprobante,
                                            columna_origen,
                                            valor_id_origen
                                         )
                                         VALUES (
                                            p_id_usuario,
                                            now(),
                                            'activo',
                                            p_id_partida_ejecucion,--:id_partida_ejecucion,
                                            p_nro_tramite,
                                            p_monto_total,
                                            v_monto_mb,
                                            p_id_moneda,
                                            p_id_presupuesto,
                                            p_id_partida,
                                            p_sw_momento, --tipo_movimiento
                                            p_tipo_cambio,
                                            p_fecha,
                                            p_id_int_comprobante,
                                            p_columna_relacion,
                                            p_fk_llave
                                            
                                          ) RETURNING id_partida_ejecucion into v_id_partida_ejecucion;
                 
                 
                 v_array_resp[1] = 1;      -- bandera de exito
                 v_array_resp[2] = v_id_partida_ejecucion;   -- id partida ejecucion 
                 v_array_resp[3] = v_verif_pres[2]::numeric - v_monto_mb;   -- saldo actulizado , - monto actual
                 
                  
              
              
              ELSE
                
                -- si no esta permitido devolver el monto faltante
               
                v_array_resp[1] = 0; --bandera de fallo
                v_array_resp[2] = NULL; --id partida ejecucion nulo
                v_array_resp[3] = v_verif_pres[2]::numeric; --saldo
                
                IF v_permitido_mt THEN
                  v_array_resp[4] = 1; -- si alcanza en moneda transaccion
                ELSE 
                  v_array_resp[4] = 0; -- si alcanza en moneda transaccion
                END IF;
                
                v_array_resp[5] = v_verif_pres[4]::numeric; --saldo en moneda trasaccion
                
             END IF;     
     ELSE
       raise notice 'no se integra con presupuestos';
       
       v_array_resp[1] = 1;
       v_array_resp[2] = NULL;
       v_array_resp[3] = NULL; 
       
     END IF;
    


    --  retorna respuesta  , posicion 0 (1, exito, 0 fallo), 1 (id partida ejecucion), 2( monto faltante)

   -- if v_monto_mb < 0  THEN
    --                   raise exception '% , %',v_verif_pres,  v_array_resp;
     -- END IF; 
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