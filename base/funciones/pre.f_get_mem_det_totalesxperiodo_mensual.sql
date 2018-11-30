CREATE OR REPLACE FUNCTION pre.f_get_mem_det_totalesxperiodo_mensual (
  p_id_memoria_calculo integer,
  p_cantidad_mem integer,
  p_importe integer,
  p_id_partida integer,
  p_codigo_cc varchar,
  p_id_gestion integer
)
RETURNS varchar AS
$body$
/*************************************************************************
 SISTEMA:		Sistema Presupuestos
 FUNCION: 		pre.f_get_mem_det_totalesxperiodo
 DESCRIPCION:   Funcion que recupera los totales del detalle de una memoria de calculo.
 AUTOR: 		 (FEA)
 FECHA:	        03-08-2017
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:
 AUTOR:
 FECHA:
**************************************************************************/

DECLARE

	v_resp		            varchar;
	v_nombre_funcion        text;
	v_record 				record;
	v_array_importes		NUMERIC[];
    v_index					integer = 1;
    v_cont					integer = 1;

    v_record_imp			record;
BEGIN

    v_nombre_funcion = 'pre.f_get_mem_det_totalesxperiodo_mensual';

        FOR v_cont IN 1..12 LOOP

                SELECT sum( p.periodo) ,sum(tmd.importe::numeric) as importe , count(tmd.importe)::INTEGER as cantidad
                INTO v_record_imp
                FROM  pre.vmemoria_por_categoria m
                join pre.tmemoria_det tmd on tmd.id_memoria_calculo=m.id_memoria_calculo 
                join param.tperiodo p on p.id_periodo=tmd.id_periodo
                WHERE m.id_gestion=p_id_gestion::INTEGER and m.id_partida = p_id_partida and m.codigo_cc=p_codigo_cc AND p.periodo = v_cont;
                
               IF EXISTS(SELECT count(tmd.importe) as importe
                          FROM  pre.vmemoria_por_categoria m
                          join pre.tmemoria_det tmd on tmd.id_memoria_calculo=m.id_memoria_calculo 
                          join param.tperiodo p on p.id_periodo=tmd.id_periodo
                          WHERE m.id_gestion=p_id_gestion::INTEGER and m.id_partida = p_id_partida and m.codigo_cc=p_codigo_cc AND p.periodo = v_cont)THEN
                
                   v_array_importes[v_cont] = v_record_imp.importe::NUMERIC/v_record_imp.cantidad::INTEGER;
                   --v_array_importes[v_cont] = 12.6::NUMERIC/1::NUMERIC;
               ELSE
                   v_array_importes[v_cont] = 0;
               END IF;


           
        END LOOP;

        v_resp = array_to_string(v_array_importes, ',');

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