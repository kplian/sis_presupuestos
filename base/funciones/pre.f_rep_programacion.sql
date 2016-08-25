CREATE OR REPLACE FUNCTION pre.f_get_total_programado_memoria_x_periodo(p_id_partida integer, p_id_presupuesto integer, p_id_periodo numeric)
 RETURNS numeric
 LANGUAGE plpgsql
AS $function$
/*
Autor: RAC (KPIAN)
Fecha: 26/04/2016
Descripcion: funcion para recuperar el total programado

ingresa solo partida de movimiento de movimiento ...
*/

DECLARE

	 v_resp							varchar;
     v_nombre_funcion   			varchar;
     v_total						numeric;
   
 
BEGIN
  	   v_nombre_funcion:='pre.f_get_total_programado_memoria_x_periodo';
     
     
       select 
           sum(md.importe)
       into
           v_total
       from pre.tmemoria_calculo m
       inner join pre.tmemoria_det  md on md.id_memoria_calculo = m.id_memoria_calculo
       where  m.id_partida = p_id_partida and 
              m.id_presupuesto = p_id_presupuesto
              and md.estado_reg = 'activo'
              and md.id_periodo = p_id_periodo; 
              
    
        
       return COALESCE(v_total,0.0);
     
     
EXCEPTION
WHEN OTHERS THEN
	
			v_resp='';
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje',SQLERRM);
			v_resp = pxp.f_agrega_clave(v_resp,'codigo_error',SQLSTATE);
			v_resp = pxp.f_agrega_clave(v_resp,'procedimientos',v_nombre_funcion);
			raise exception '%',v_resp;
   
END;
$function$