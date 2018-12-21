--------------- SQL ---------------

CREATE OR REPLACE FUNCTION pre.f_migrar_partida_ejecucion_tmp (
)
RETURNS boolean AS
$body$
/************************************************************************** 
 SISTEMA:      Sistema de Presupuestos
 DESCRIPCION:   Migra partida ejecucion temporal a la tabla partida ejecucion
 AUTOR:         Rensi Arteaga (KPLIAN)  
 FECHA:         20-12-2018   
 COMENTARIOS:    
***************************************************************************

       
 ISSUE            FECHA:              AUTOR                                DESCRIPCION
 #3            20-12-2018          Rensi Arteaga (KPLIAN)            creación        
***************************************************************************/


DECLARE


  v_registros         record;
  v_id_gestion        integer;
  v_id_usuario        integer;
  v_id_partida        integer;
  v_fecha_ejecucion   date;
  v_resp_ges          numeric[];
  v_mensaje_error     varchar;

  
  
  

BEGIN

   v_id_usuario = 1;  --usuario solictante 
   v_fecha_ejecucion = '17/12/2018'::date;

   --listar los registros temporales
   FOR v_registros in (
   
            SELECT id,
                   tipo,
                   monto_mb,
                   monto_mo,
                   id_moneda,
                   id_presupuesto,
                   codigo_partida,
                   nro_tramite,
                   id_int_cbte,
                   glosa,
                   migrado,
                   obs
          FROM pre.tpartida_ejecucion_tmp where id_partida_ejecucion is null) LOOP
   
      --identificar gestion
      select  cc.id_gestion into v_id_gestion   
      from param.tcentro_costo cc where cc.id_centro_costo = v_registros.id_presupuesto;
      
      --identificar partida 
      select 
        par.id_partida into v_id_partida
      from pre.tpartida par 
      where  par.codigo = v_registros.codigo_partida 
           and par.id_gestion = v_id_gestion
           and par.estado_reg = 'activo';
           
                                         
                                            
         v_resp_ges = pre.f_gestionar_presupuesto_individual(
                                            v_id_usuario,
                                            NULL,
                                            v_registros.id_presupuesto,
                                            v_id_partida,
                                            v_registros.id_moneda,
                                            v_registros.monto_mo,
                                            v_fecha_ejecucion,
                                            v_registros.tipo::varchar, --traducido a varchar
                                            NULL,--p_id_partida_ejecucion::integer,
                                            'pre.tpartida_ejecucion_tmp',--p_columna_relacion,
                                            v_registros.id,
                                            v_registros.nro_tramite,
                                            v_registros.id_int_cbte,
                                            v_registros.monto_mb,
                                            v_registros.glosa);                                   
                                            
                                                
        IF v_resp_ges[1] = 0 THEN
                                           
               
               --  recuperamos datos del presupuesto
             
                                                             
                v_mensaje_error =  conta.f_armar_error_presupuesto(v_resp_ges, 
                                                                 v_registros.id_presupuesto, 
                                                                 v_registros.codigo_partida, 
                                                                 v_registros.id_moneda, 
                                                                 1, 
                                                                 v_registros.tipo, 
                                                                 v_registros.monto_mb);                                             
                                                        
               raise notice  'ERROR.....id %, ',v_registros.id;                                            
               raise exception '%', v_mensaje_error;
                                                 
        ELSE
                 -- sino se tiene error almacenamos el id de la aprtida ejecucion
               
                      update pre.tpartida_ejecucion_tmp it set
                         id_partida_ejecucion = v_resp_ges[2]
                      where it.id  =  v_registros.id;
                 
                
                      raise notice  'id %, PE: %..',v_registros.id, v_resp_ges[2];
                                                  
        END IF; 
        
   
   
   END LOOP; 
   
   
  
  
  
  --raise exception 'terminó todo ok (comentar esta línea para correr en limpio)';
  return true;
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;