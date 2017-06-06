CREATE OR REPLACE FUNCTION pre.f_sum_padres_partidas (
p_id_partida INTEGER,
  p_id_presupuesto INTEGER,
  p_gestion INTEGER,
  p_periodo INTEGER,
  p_tipo_movimiento VARCHAR --ejecucion o prometido,
)
RETURNS NUMERIC AS
$body$
/**************************************************************************
 SISTEMA:		CONTA
 FUNCION: 		conta.f_bancarizacion_automatico
 DESCRIPCION:   Genera desde el plan de pago autumatico para ver que se bancariza
 AUTOR: 		 (ffigueroa)
 FECHA:	        16-03-2016 14:58:35
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:
 AUTOR:
 FECHA:
***************************************************************************/


DECLARE

    v_resp		            numeric;
v_nombre_funcion VARCHAR;


BEGIN
	v_nombre_funcion = 'pre.f_sum_padres_partidas';


	WITH RECURSIVE tabla_temporal(id_partida,codigo,nombre_partida,id_partida_fk,nivel_partida,id_gestion,f1) AS (
		SELECT

			par.id_partida,
			par.codigo,
			par.nombre_partida,
			par.id_partida_fk,
			par.nivel_partida,
			par.id_gestion,

			pre.f_get_ejecutado_por_periodo (pp.id_partida,'', 15,1,'ejecutado') as f1

		FROM pre.tpartida par
			inner join pre.tpresup_partida pp on pp.id_partida = par.id_partida
		WHERE
			par.id_partida_fk = 9650

			and pp.id_presupuesto in(831,832,833,834,835,836,837,838,839,840,841,843,844,830,842)

		UNION ALL

		SELECT
			pa.id_partida,
			pa.codigo,
			pa.nombre_partida,
			pa.id_partida_fk,
			pa.nivel_partida,
			pa.id_gestion,
			pre.f_get_ejecutado_por_periodo (pa.id_partida,'', 15,1,'ejecutado') as f1
		FROM pre.tpartida pa
			INNER JOIN tabla_temporal t ON t.id_partida = pa.id_partida_fk


		--where p
	)SELECT * INTO v_resp FROM tabla_temporal
	GROUP BY id_partida,codigo,nombre_partida,id_partida_fk,nivel_partida,id_gestion,f1;

	RETURN v_resp;




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