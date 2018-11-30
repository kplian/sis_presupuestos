--------------- SQL ---------------

CREATE OR REPLACE FUNCTION pre.f_migrar_homologacion_partidas (
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

BEGIN

     --listar todos los registros no migrados, que sea del tipo moviemitno
      FOR  v_registros in ( SELECT 
                                codigo_1,
                                desc_1,
                                tipo_1,
                                tipo_mov_1,
                                id_partida_1,
                                codigo_2,
                                desc_2,
                                tipo_2,
                                tipo_mov_2,
                                mov,
                                id_partida_2,
                                migrado,
                                obs,
                                gestion_ini
                              FROM 
                                pre.tpartida_temp  p
                              WHERE p.migrado = 'no'   ) LOOP
               --recuperar gestion
               select 
                 ges.id_gestion into v_id_gestion
               from param.tgestion ges
               where ges.gestion = v_registros.gestion_ini; 
                     
               
               if v_id_gestion  is null then 
                  raise exception 'no se encontro gestion inicial %', v_registros.gestion_ini;           
               end if;
               -- recuperar id_partida  1
               select 
                   par.id_partida into v_id_partida_1
               from pre.tpartida par
               where par.id_gestion = v_id_gestion
                     and par.codigo = v_registros.codigo_1;
                     
               
               select 
                 ges.id_gestion into v_id_gestion_2
               from param.tgestion ges
               where ges.gestion = v_registros.gestion_ini + 1;  
                     
                     
               if v_id_gestion_2  is null then 
                  raise exception 'no se encontro gestion destino %', v_registros.gestion_ini + 1;           
               end if;     
     
               --recuperar id_partida 2
                select 
                   par.id_partida into v_id_partida_2
               from pre.tpartida par
               where par.id_gestion = v_id_gestion_2 
                     and par.codigo = v_registros.codigo_2;
             
      
              if v_id_partida_1 is not null and  v_id_partida_2 is not null then
      
                    v_registros_per = NULL;
                    select  *  into v_registros_per 
                    from pre.tpartida_ids pi
                    where pi.id_partida_uno = v_id_partida_1;
                    
                    v_obs = '';
                    
                    if v_registros_per is null then
                        --crea nuevo regitro de relacion entre partidas origen y destino   
                       INSERT INTO 
                              pre.tpartida_ids
                            (
                              id_partida_uno,
                              id_partida_dos,
                              sw_cambio_gestion
                            )
                            VALUES (
                              v_id_partida_1,
                              v_id_partida_2,
                              'homologa'
                            );
                        
                    else
                        --nos preparamos para registrar una observacion
                        if v_id_partida_2 = v_registros_per.id_partida_dos then
                          v_obs = 'ya se encontraba registrado';
                        else
                          v_obs = 'vinculado con otra partida: '|| v_registros_per.id_partida_dos::varchar;
                        end if ;
                        
                        
                    end if;
                    
                    --actulizar regitro
                   UPDATE 
                      pre.tpartida_temp 
                    SET 
                      id_partida_1 = v_id_partida_1,
                      id_partida_2 = v_id_partida_2,
                      migrado = 'si',
                      obs = v_obs
                    WHERE       codigo_1 = v_registros.codigo_1 
                            and codigo_2 = v_registros.codigo_2 
                            and migrado = 'no' 
                            and desc_1 = v_registros.desc_1 
                            and desc_2 = v_registros.desc_2;
                     
               else
                   --actulizar regitro
                   UPDATE 
                      pre.tpartida_temp 
                    SET 
                      id_partida_1 = v_id_partida_1,
                      id_partida_2 = v_id_partida_2,
                      migrado = 'no',
                      obs = 'no se encontraron las partidas... 1: '||COALESCE(v_registros.codigo_1,'NULL')||'  2:'||COALESCE(v_registros.codigo_2,'NULL')
                    WHERE       codigo_1 = v_registros.codigo_1 
                            and codigo_2 = v_registros.codigo_2 
                            and migrado = 'no' 
                            and desc_1 = v_registros.desc_1 
                            and desc_2 = v_registros.desc_2;
               
               end if;                   
          
              
       END LOOP;
     
 
    -- raise exception 'terminó';
  return 'exito';
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;