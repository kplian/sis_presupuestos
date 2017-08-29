CREATE OR REPLACE FUNCTION pre.f_get_mem_det_totalesxperiodo (
  p_id_memoria_calculo integer,
  p_cantidad_mem integer,
  p_importe integer
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
	v_array_importes		integer[];
    v_index					integer = 1;
    v_cont					integer = 1;

    v_record_imp			record;
BEGIN

    v_nombre_funcion = 'pre.f_get_mem_det_totalesxperiodo';

        FOR v_cont IN 1..12 LOOP

                SELECT tp.periodo, tmd.importe
                INTO v_record_imp
                FROM pre.tmemoria_det tmd
                INNER JOIN param.tperiodo tp ON tp.id_periodo = tmd.id_periodo
                WHERE tmd.id_memoria_calculo = p_id_memoria_calculo AND tp.periodo = v_cont;

                IF(v_record_imp.importe::integer = p_importe)THEN
                	v_array_importes[v_cont] = v_record_imp.importe::integer;
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