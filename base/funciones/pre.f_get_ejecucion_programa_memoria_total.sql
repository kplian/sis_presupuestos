CREATE OR REPLACE FUNCTION pre.f_get_ejecucion_programa_memoria_total (
  p_id_partida integer,
  p_id_presupuesto integer,
  p_id_gestion integer
)
RETURNS numeric AS
$body$
DECLARE
v_resp				varchar;
v_nombre_funcion	varchar;
v_importe			numeric;

BEGIN
 v_nombre_funcion = 'pre.f_get_ejecucion_programa_memoria_total';

  select sum (md.importe)
  into
  v_importe
        from pre.tmemoria_det md
        inner join pre.tmemoria_calculo m on m.id_memoria_calculo = md.id_memoria_calculo
        inner join pre.tpartida p on p.id_partida = m.id_partida
        where 	p.id_partida = p_id_partida
        		and m.id_presupuesto = p_id_presupuesto
        		and p.id_gestion = p_id_gestion
                and md.estado_reg = 'activo';
		return COALESCE(v_importe,0.0);
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