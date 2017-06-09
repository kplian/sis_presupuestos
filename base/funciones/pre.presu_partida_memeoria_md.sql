CREATE OR REPLACE FUNCTION pre.presu_partida_memeoria_md (
)
RETURNS void AS
$body$
DECLARE

	v_id_funcionario	integer;
    v_record			record;
    v_md				numeric ;


BEGIN

FOR v_record in (select me.id_partida,
						me.id_presupuesto,
						sum(me.importe_total) as importe
						from pre.tmemoria_calculo me
                        inner join pre.tpartida p on p.id_partida = me.id_partida
                        where p.id_gestion = 15
                        group by me.id_partida,
                        me.id_presupuesto) loop
            /*
			UPDATE pre.tpresup_partida  set
                    importe = 0,
                    importe_aprobado = 0
            where id_partida = v_record.id_partida
            and id_presupuesto = v_record.id_presupuesto;*/

            /*UPDATE pre.tpresup_partida  set
                    importe = v_record.importe,
                    importe_aprobado = v_record.importe
            where id_partida = v_record.id_partida
            and id_presupuesto = v_record.id_presupuesto;*/

            UPDATE pre.tpartida_ejecucion  set
                    monto = v_record.importe,
                    monto_mb = v_record.importe
            where id_partida = v_record.id_partida
            and id_presupuesto = v_record.id_presupuesto
            and fecha = '01/01/2017'
            and tipo_movimiento =  'formulado';



end loop;


END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;