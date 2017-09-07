CREATE OR REPLACE FUNCTION pre.f_get_arbol (
  p_id_objetivo integer,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema Presupuestos
 FUNCION: 		pre.f_get_arbol
 DESCRIPCION:   Funcion que recupera los hijos o nietos de un arbol.
 AUTOR: 		 (FEA)
 FECHA:	        28-07-2017 15:15:26
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:
 AUTOR:
 FECHA:
***************************************************************************/

DECLARE

	v_resp		            varchar='';
	v_nombre_funcion        text;
	v_record 				record;
	v_cont					integer=1;
    v_general				integer=0;
    v_nivel					integer;
    v_id_gestion			integer;
    v_fkey					integer;

    v_record_ids			record;
    v_cadena_ids			varchar ='';
BEGIN

    v_nombre_funcion = 'pre.f_get_arbol';

    /*********************************
 	#TRANSACCION:  'DETALLE DEL ARBOL DE OBJETIVOS'
 	#DESCRIPCION:	Devuelve el numero de hijos, nietos, hermanos.
 	#AUTOR:		franklin.espinoza
 	#FECHA:		13-7-2017 13:21:12
	***********************************/
	SELECT g.id_gestion
    INTO v_id_gestion
    FROM param.tgestion g
    WHERE g.gestion = EXTRACT(YEAR FROM current_date);

	IF(p_transaccion = 'CONT_HIJOS')THEN

       SELECT count(tob.id_objetivo)
       INTO v_cont
       FROM pre.tobjetivo tob
       WHERE tob.id_objetivo_fk = p_id_objetivo;
       v_resp = v_cont::varchar;
    ELSIF(p_transaccion = 'CONT_NIETOS')THEN
    	FOR v_cont IN (SELECT pre.f_get_arbol(tob.id_objetivo, 'CONT_HIJOS')
       				   FROM pre.tobjetivo tob
       				   WHERE tob.id_objetivo_fk = p_id_objetivo)LOOP
        	v_general = v_general + v_cont;
        END LOOP;
        v_cont = v_general;
        v_resp = v_cont::varchar;
    ELSIF(p_transaccion = 'CONT_HERMANOS')THEN

     	  v_nivel = pre.f_get_arbol(p_id_objetivo, 'NIVEL')::INTEGER;

          IF(v_nivel = 1)THEN
              SELECT count(tob.id_objetivo)
              INTO v_cont
              FROM pre.tobjetivo tob
              WHERE tob.nivel_objetivo = v_nivel AND tob.id_gestion = v_id_gestion;
          ELSE
              SELECT tob.id_objetivo_fk
              INTO v_fkey
              FROM pre.tobjetivo tob
              WHERE tob.id_objetivo = p_id_objetivo;

              v_cont =  pre.f_get_arbol(v_fkey, 'CONT_HIJOS')::integer;
          END IF;
          v_resp = v_cont::varchar;
    ELSIF(p_transaccion = 'NIVEL')THEN
    	SELECT tob.nivel_objetivo
        INTO v_nivel
        FROM pre.tobjetivo tob
        WHERE tob.id_objetivo = p_id_objetivo;
        v_cont = v_nivel;
        v_resp = v_cont::varchar;
    ELSIF(p_transaccion = 'IDS_HIJOS')THEN
        IF(pre.f_get_arbol(p_id_objetivo, 'CONT_HIJOS') = '0')THEN
              v_cont =  p_id_objetivo;
    	END IF;
    	FOR v_record_ids IN (SELECT tob.id_objetivo
        					FROM pre.tobjetivo tob
        					WHERE tob.id_objetivo_fk = p_id_objetivo)LOOP

        	RAISE NOTICE 'id_objetivo: %',v_record_ids.id_objetivo;
            v_resp = v_resp || v_record_ids.id_objetivo||','|| pre.f_get_arbol(v_record_ids.id_objetivo, 'IDS_HIJOS');
        END LOOP;
    END IF;

	--v_resp = v_cont::varchar;

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