CREATE OR REPLACE FUNCTION pre.f_migrar_transferir_partidas_form (
)
RETURNS varchar AS
$body$
DECLARE
  v_tabla varchar;
  v_params VARCHAR [ ];
  v_resp varchar;

  v_registros record;
  v_id_gestion integer;
  v_estado varchar;
  v_gestion integer;
  v_id_tipo_cc integer;
  v_id_presupuesto integer;
  v_id_partida integer;
  v_id_conceto_ingas integer;
  v_total_memoria numeric;
  v_id_memoria_calculo integer;
  v_registros_per record;
  v_aux numeric;
  v_contador integer;
  v_obs varchar;
  v_id_gestion_2 integer;
  v_id_partida_1 integer;
  v_id_partida_2 integer;
  v_id_concepto_ingas_2 integer;

BEGIN

     -- listas todas las partidas
     
     FOR v_registros in (
                    SELECT 
                          cp.id,
                          cp.id_partida_origen,
                          cp.id_partida_destino,
                          cp.migrado,
                          cp.obs,
                          par.id_gestion as id_gestion_1,
                          par2.id_gestion as id_gestion_2
                        FROM 
                          pre.tcambio_partida cp
                          inner join pre.tpartida par ON par.id_partida = cp.id_partida_origen
                          inner join pre.tpartida par2 ON par2.id_partida = cp.id_partida_destino 
                         WHERE cp.migrado = 'no') LOOP
                         
              --verificar que sean de la misma gestion            
             IF v_registros.id_gestion_1 !=  v_registros.id_gestion_2  THEN
                raise exception ' existen partidas de diferentes gestion %,%', v_registros.id_partida_origen , v_registros.id_partida_destino;
             END IF;
             
            --creo que temporalemnte tendrias que quedarse 
            --TODO  verificar que  la partida destino sea de movimietno            
                         
            
            --recuperar concepto de gasto origen
               --TODO aparentemente no esnecesario 
            
           --recuperar concepto de gasto destino
            v_id_concepto_ingas_2 = NULL;
            select 
               cop.id_concepto_ingas into v_id_concepto_ingas_2
            from pre.tconcepto_partida cop 
            where cop.id_partida = v_registros.id_partida_destino;
            
            IF v_id_concepto_ingas_2 is null THEN
               raise exception 'no se econtro un conpceto ingas para la partida destino %',v_registros.id_partida_destino;
            END IF;
            
           -------------------------------------
           -- cambiar presupuesto partida
           ---------------------------------
           UPDATE 
            pre.tpresup_partida 
          SET 
                  
            fecha_mod = now(),
            id_partida =  v_registros.id_partida_destino,
            obs_dba = 'cambio partida id '||v_registros.id_partida_origen
          WHERE 
            id_partida  = v_registros.id_partida_origen;
            
           ------------------------------------
           -- cambiar memoria de calculo memoria  
           -- de calculo...tiene concepto y tiene partida .......
           -- asumimos que un partida solo tiene un concepto de gasto en troo caso hay que ajustar esto
           --------------------------------------------------------- 
           
           UPDATE 
            pre.tmemoria_calculo 
          SET 
                
            id_concepto_ingas = v_id_concepto_ingas_2,
            id_partida =  v_registros.id_partida_destino,
            obs_dba = 'cambio de partida id'||v_registros.id_partida_origen::varchar||'  conceto id '||id_concepto_ingas::varchar
          WHERE 
            id_partida = v_registros.id_partida_origen ;
          
          -----------------------------------------------  
          --cambiar partida ejecucion partida ejecucion
          -----------------------------------------------
            UPDATE 
              pre.tpartida_ejecucion 
            SET 
              id_partida = v_registros.id_partida_destino,
              obs_dba = ''
            WHERE 
              id_partida = v_registros.id_partida_origen;
              
            UPDATE 
                pre.tcambio_partida 
              SET 
                migrado = 'si',
                obs = 'cambio partida'
              WHERE 
                id = v_registros.id ;
              
    
    END LOOP;
    
     
     
     
 
     -- raise exception 'terminó  --recordar deshabilitar el triguer de memoria de calculo y habilitar al termianr';
      return 'exito';
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;