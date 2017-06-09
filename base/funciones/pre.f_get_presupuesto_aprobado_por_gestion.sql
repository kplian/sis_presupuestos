CREATE OR REPLACE FUNCTION pre.f_get_presupuesto_aprobado_por_gestion (
  p_id_partida integer,
  p_id_presupuesto integer,
  p_id_gestion integer
)
RETURNS numeric AS
$body$
DECLARE
   v_resp							varchar;
     v_nombre_funcion   			varchar;
     v_total						numeric;
     v_ajuste						numeric;
BEGIN
 v_nombre_funcion:='pre.f_get_presupuesto_aprobado_por_gestion';


    select

     COALESCE( pr.importe_aprobado ,0)
    into
    v_total
from pre.tpresup_partida pr
inner join pre.tpartida pa on pa.id_partida = pr.id_partida

where 	pr.id_partida = p_id_partida
		and pr.id_presupuesto = p_id_presupuesto
 		and pa.id_gestion = p_id_gestion
        and pr.estado_reg = 'activo';

    return COALESCE(v_total,0);

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