--------------- SQL ---------------

CREATE OR REPLACE FUNCTION pre.f_obtener_partida_cuenta_cig (
  p_id_concepto_ingas integer,
  p_id_centro_costo integer,
  out ps_id_partida varchar,
  out ps_id_cuenta integer,
  out ps_id_auxiliar integer
)
RETURNS record AS
$body$
/**************************************************************************
 FUNCION: 		pre.f_obtener_partida_cuenta_cig
 DESCRIPCION: 	Devuelbe la parametrizacion correpondiente a un concepto de gasto
 AUTOR: 		KPLIAN(RAC)
 FECHA:			05/03/2013
 COMENTARIOS:	
***************************************************************************
 HISTORIA DE MODIFICACIONES:

 DESCRIPCION:	
 AUTOR:			
 FECHA:			

***************************************************************************/
DECLARE
  v_num_siguiente INTEGER;
  v_gestion varchar;
  v_id_gestion integer;
  v_cont_gestion integer;
  v_codigo_siguiente VARCHAR(30);
  v_codigo_proceso_macro varchar;
  v_id_proceso_macro integer;
  
  v_num_tramite varchar;
  v_id_tipo_proceso integer;
  v_id_tipo_estado integer;
  v_inicio varchar;
  v_desc_concepto varchar;
  
BEGIN


   select 
   cig.desc_ingas into v_desc_concepto
   from param.tconcepto_ingas  cig
   where cig.id_concepto_ingas = p_id_concepto_ingas;

    select
       cct.id_partida,
       cct.id_cuenta,
       cct.id_auxiliar 
      into
           ps_id_partida,
           ps_id_cuenta,
           ps_id_auxiliar   
    from pre.tconcepto_cta cct 
    where  cct.id_concepto_ingas = p_id_concepto_ingas
         and cct.id_centro_costo = p_id_centro_costo
         and cct.estado_reg ='activo'
    limit 1 offset 0;
         
    --si no hay partida buscamos la parametrizacion por defecto     
         
    IF ps_id_partida is NULL THEN
    
        select
           cct.id_partida,
           cct.id_cuenta,
           cct.id_auxiliar 
        into
           ps_id_partida,
           ps_id_cuenta,
           ps_id_auxiliar 
        from pre.tconcepto_cta cct 
        where  cct.id_concepto_ingas = p_id_concepto_ingas
             and cct.estado_reg ='activo'
             and cct.id_centro_costo is NULL
          limit 1 offset 0;
    
     END IF;         
      
      IF ps_id_partida is NULL THEN
      
        raise exception 'No existe parametrizacion en el Concepto Solicitado (%) para el centro de costos, Cominiquese con la personal encargada de clasificación en el área de presupuestos',v_desc_concepto ;
      
      END IF;    
 
 


END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY DEFINER
COST 100;