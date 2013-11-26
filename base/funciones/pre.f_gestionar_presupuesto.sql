--------------- SQL ---------------

CREATE OR REPLACE FUNCTION pre.f_gestionar_presupuesto (
  p_id_presupuesto integer [],
  p_id_partida integer [],
  p_id_moneda integer [],
  p_monto_total numeric [],
  p_fecha date [],
  p_sw_momento integer [],
  p_id_partida_ejecucion integer [],
  p_columna_relacion varchar [],
  p_fk_llave integer []
)
RETURNS numeric [] AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Presupuestos
 FUNCION: 		pre.f_gestionar_presupuesto
 DESCRIPCION:   Funcion que llama a la funcion presto.f_i_pr_gestionarpresupuesto mediante dblink
 AUTOR: 		Gonzalo Sarmiento Sejas
 FECHA:	        15-03-2013
 COMENTARIOS:	
***************************************************************************/


DECLARE
  resultado record;
  v_consulta varchar;
  v_conexion varchar;
  v_resp	varchar;
  v_sincronizar varchar;
  v_nombre_funcion varchar;
  

 
 v_size integer;
 v_array_resp numeric[];
 
 v_str_id_presupuesto varchar;
 v_str_id_partida varchar;
  
BEGIN

      v_nombre_funcion = 'pre.f_gestionar_presupuesto';

      v_sincronizar=pxp.f_get_variable_global('sincronizar');
     
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
          
          
          
         v_conexion:=migra.f_obtener_cadena_conexion();
         v_consulta:='select presto."f_i_pr_gestionarpresupuesto_array" ('||v_str_id_presupuesto ||',			--  pr_id_presupuesto integer
                                                                          '||v_str_id_partida||',   			--  pr_id_partida integer,
                                                                              '||COALESCE(('array['|| array_to_string(p_id_moneda, ',')||']')::varchar,'NULL::integer[]')||',     		--  pr_id_moneda integer,
                                                                              '||COALESCE(('array['|| array_to_string(p_monto_total, ',')||']')::varchar,'NULL::numeric[]')||',   		--  pr_monto_total numeric,
                                                                              '||COALESCE(('array['''|| array_to_string(p_fecha, ''',''')||''']::date[]')::varchar,'NULL::date[]')||',   				 --  pr_fecha date,
                                                                              '||COALESCE(('array['|| array_to_string(p_id_partida_ejecucion, ',')||']')::varchar,'NULL::integer[]')||', 	    --  pr_id_partida_ejecucion integer,
                                                                              '||COALESCE(('array['|| array_to_string(p_sw_momento, ',')||']')::varchar,'NULL::numeric[]')||',    		--  pr_sw_momento numeric,
                                                                              NULL::integer[],               				   					--  pr_id_item integer,
                                                                              NULL::integer[],                  									--  pr_id_servicio integer,
                                                                              NULL::integer[],               				   					--  pr_id_concepto_ingas integer,
                                                                              '||COALESCE(('array['''|| array_to_string(p_columna_relacion, ''',''')||''']::varchar[]')::varchar,'NULL::varchar[]')||', 		--  pr_columna_relacion varchar,
                                                                              '||COALESCE(('array['|| array_to_string(p_fk_llave, ',')||']')::varchar,'NULL::integer[]')||') ';	--  pr_fk_llave integer

             
              raise notice  '>>>>>>>>>>>>    CONSULTA DBLINK  %, %',v_consulta,v_conexion;
              
               
              select * into resultado from dblink(v_conexion,v_consulta,true) as (res numeric[]);
              
             raise notice '>>>  RESPUESTA %  >>    %',v_array_resp, resultado;
              
              v_array_resp= resultado.res;
              
              IF  v_array_resp is NULL THEN
              
                raise exception 'Error al comprometer el presupuesto';
              
              END IF;
              
              
      ELSE 
        --TO DO,   si la sincronizacion no esta activa busca en el sistema de presupeusto local en PXP
      
        raise exception 'Gestion  presupuestaria en PXP no implementada';
      
      
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