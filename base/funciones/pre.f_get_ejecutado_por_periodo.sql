CREATE OR REPLACE FUNCTION pre.f_get_ejecutado_por_periodo (
  p_id_partida integer,
  p_id_presupuesto integer,
  p_id_gestion integer,
  p_id_periodo integer,
  p_tipo_movimiento varchar
)
RETURNS numeric AS
$body$
DECLARE
  	v_resp				varchar;
	v_nombre_funcion	varchar;
	v_importe			numeric;
BEGIN
  v_nombre_funcion = 'pre.f_get_ejecutado_por_periodo';
		 select

                sum(COALESCE(pe.monto_mb,0))

                INTO
                v_importe
                from pre.tpartida_ejecucion pe
                inner join pre.tpartida  pa on pa.id_partida = pe.id_partida

                where 	pa.id_partida = p_id_partida
                		and pe.id_presupuesto = p_id_presupuesto
                        and pa.id_gestion = p_id_gestion
                        and date_part('month',pe.fecha)::integer = p_id_periodo
                      	and pe.tipo_movimiento = p_tipo_movimiento
                        and pe.estado_reg = 'activo';







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