--------------- SQL ---------------

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
  p_nro_tramite varchar,
  p_id_int_comprobante integer = NULL::integer,
  p_conexion varchar = NULL::character varying
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
  v_nombre_funcion 				varchar;
  v_size 						integer;
  v_array_resp 					numeric[]; 
  v_str_id_presupuesto 			varchar;
  v_str_id_partida				varchar;
  v_pre_integrar_presupuestos	varchar;
  v_id_moneda_base				integer;
  v_monto_mb 					numeric;
  
BEGIN

  v_nombre_funcion = 'pre.f_gestionar_presupuesto';

  v_sincronizar = pxp.f_get_variable_global('sincronizar');
  v_pre_integrar_presupuestos = pxp.f_get_variable_global('pre_integrar_presupuestos');
  
  
  v_id_moneda_base = param.f_get_moneda_base();
  
  
 IF v_pre_integrar_presupuestos = 'true' THEN  
     IF(v_sincronizar='true')THEN

          /*
          PARAMETROS DE ENTRADA
        pr_id_presupuesto integer (Presupuesto a gestionar), 
        pr_id_partida integer(partida a gestionar),  
        pr_id_moneda integer (moneda de registro), 
        pr_monto_total numeric, 
        pr_fecha_compro date (fecha de historico), 
        pr_id_partida_ejecucion integer (es el que relaciona al estados anteriores)
        pr_sw_momento numeric (	1 Comprometido
                                2 Comprometido Revertido
                                3 Comprometido Ejecutado
                                4 Pagado
                                5 traspaso
                                6 reformulaciones
                                7 incremento
                                8 Comprometido Ejecuctado Revertido
                                9 Pagado Revertido), 
        pr_sw_verifica numeric (si se verificara el presupuesto), 
        pr_mensaje varchar (mensaje a retornar si es que ocurriena un error), 
        pr_id_item integer , 
        pr_id_servicio integer, 
        pr_id_concepto_ingas integer
        
        
        sw_momento numeric  momento de gestion del presupuesto
    significado del campo sw_momento en la tabla :{1=comprometer,2=ejecutar o devengar,3=revertir, 4=pagar 5=traspaso}
    significado del campo sw_momento en la funcion : {1=comprometer,2=revertir,
    3=ejecutar presupuesto de gasto o inversion o o recurso,
    4=pagar 5=devengar o ejecutar presupuesto de ingreso}  
        
          
          */
          
          
         v_str_id_presupuesto = array_to_string(p_id_presupuesto, ',');
         
         IF v_str_id_presupuesto !='' and v_str_id_presupuesto is not null THEN
           v_str_id_presupuesto ='array['|| v_str_id_presupuesto||']';
         
         ELSE
           v_str_id_presupuesto = 'NULL::integer[]';
         
         END IF;
         
         v_str_id_partida= array_to_string(p_id_partida, ',');
         
         IF v_str_id_partida !='' and v_str_id_partida is not null THEN
           v_str_id_partida ='array['|| v_str_id_partida||']';
         
         ELSE
           v_str_id_partida = 'NULL::integer[]';
         
         END IF;
         
         IF  p_conexion is NULL  THEN
           select * into v_conexion from migra.f_crear_conexion();
         ELSE
           v_conexion = p_conexion;
         END IF; 
          
          
       
           
          v_consulta:='select presto."f_i_pr_gestionarpresupuesto_array" ('||v_str_id_presupuesto ||',		
                                                                          '||v_str_id_partida||',   
                                                                              '||COALESCE(('array['|| array_to_string(p_id_moneda, ',')||']')::varchar,'NULL::integer[]')||',     
                                                                              '||COALESCE(('array['|| array_to_string(p_monto_total, ',')||']')::varchar,'NULL::numeric[]')||',   		
                                                                              '||COALESCE(('array['''|| array_to_string(p_fecha, ''',''')||''']::date[]')::varchar,'NULL::date[]')||',   
                                                                              '||COALESCE(('array['|| array_to_string(p_id_partida_ejecucion, ',')||']::integer[]')::varchar,'NULL::integer[]')||', 
                                                                              '||COALESCE(('array['|| array_to_string(p_sw_momento, ',')||']')::varchar,'NULL::numeric[]')||',  
                                                                              NULL::integer[],               				   					
                                                                              NULL::integer[],                  								
                                                                              NULL::integer[],               				   					
                                                                              '||COALESCE(('array['''|| array_to_string(p_columna_relacion, ''',''')||''']::varchar[]')::varchar,'NULL::varchar[]')||', 		
                                                                              '||COALESCE(('array['|| array_to_string(p_fk_llave, ',')||']')::varchar,'NULL::integer[]')||','||COALESCE(p_id_int_comprobante::varchar,'NULL') ||') ';	

             
           
              
            select * into resultado from dblink(v_conexion,v_consulta,true) as (res numeric[]);
            
            
              
            v_array_resp= resultado.res;
              
            IF  v_array_resp is NULL THEN
              raise exception 'Error al comprometer el presupuesto';
            END IF;
            
            
            --inserta resultados en partida ejecución
            FOR v_cont IN 1..array_length(v_array_resp, 1 ) LOOP
            
                     v_monto_mb =    param.f_convertir_moneda ( p_id_moneda[v_cont], 
                     											v_id_moneda_base,    
                                                                p_monto_total[v_cont],  
                                                                p_fecha[v_cont], 'CUS',50, p_tipo_cambio, 'no');
            
            
                      INSERT INTO  pre.tpartida_ejecucion
                                          (
                                            id_usuario_reg,
                                            fecha_reg,
                                            estado_reg,
                                            id_partida_ejecucion,
                                            nro_tramite,
                                            monto,
                                            monto_mb,
                                            id_moneda,
                                            id_presupuesto,
                                            id_partida,
                                            tipo_movimiento,
                                            tipo_cambio,
                                            fecha,
                                            id_int_comprobante
                                          )
                                          VALUES (
                                            p_id_usuario,
                                            now(),
                                            'activo',
                                            v_array_resp[v_cont],--:id_partida_ejecucion,
                                            p_nro_tramite,
                                            p_monto_total[v_cont],
                                            v_monto_mb,
                                            p_id_moneda[v_cont],
                                            p_id_presupuesto[v_cont],
                                            p_id_partida[v_cont],
                                            (p_sw_momento[v_cont])::varchar, --tipo_movimiento
                                            p_tipo_cambio,
                                            p_fecha[v_cont],
                                            p_id_int_comprobante
                                          );
                   
                      
          END LOOP;
            
              
              
      ELSE 
        --TO DO,   si la sincronizacion no esta activa busca en el sistema de presupeusto local en PXP
      
        raise exception 'Gestion  presupuestaria en PXP no implementada';
      
      
      END IF;
      
     
      
      if  p_conexion is  null then
          select * into v_resp from migra.f_cerrar_conexion(v_conexion,'exito'); 
      end if;
 ELSE

    raise notice 'no se integra con presupuestos';

 END IF;
    

  return v_array_resp;


 

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