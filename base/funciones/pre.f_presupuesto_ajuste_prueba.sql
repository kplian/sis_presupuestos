CREATE OR REPLACE FUNCTION pre.f_presupuesto_ajuste_prueba (
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
BEGIN
 v_nombre_funcion:='pre.f_presupuesto_ajuste_prueba';

  select
            COALESCE(d.importe,0)
            into
            v_total
from pre.tajuste_det d
inner join pre.tpartida par on par.id_partida = d.id_partida
inner join pre.tajuste  a on a.id_ajuste = d.id_ajuste
where 	d.id_partida = p_id_partida
		and d.id_presupuesto = p_id_presupuesto
		and par.id_gestion = p_id_gestion
        and (a.tipo_ajuste = 'decremento_formulacion'or a.tipo_ajuste ='incremento_formulacion')
        and d.estado_reg = 'activo';



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