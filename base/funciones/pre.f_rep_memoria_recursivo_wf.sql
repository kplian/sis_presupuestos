CREATE OR REPLACE FUNCTION pre.f_rep_memoria_recursivo_wf (
  p_id_gestion integer,
  p_nivel integer
)
RETURNS boolean AS
$body$
  DECLARE


    v_parametros  		record;
    v_registros 		record;
    v_nombre_funcion   	text;
    v_resp				varchar;
    v_nivel				integer;
    v_suma				numeric;
    v_mayor				numeric;
    va_mayor			numeric[];
    v_id_gestion  		integer;
    va_tipo_cuenta		varchar[];
    v_gestion 			integer;
    v_sw_force			boolean;



  BEGIN

    v_nombre_funcion = 'pre.f_rep_evaluacion_recursivo_wf';
    v_sw_force = false;  --para criterio de parada


       FOR v_registros in (
      select
        tem.id_partida,
        tem.id_gestion,
        tem.id_partida_fk,
        par.codigo as codigo_partida,
        par.nombre_partida,
        par.id_partida_fk as id_partida_abuelo,
        par.nivel_partida,
        tem.descripcion,
    	tem.gestion,
        par.sw_transaccional,
        sum(m1) as m1,
        sum(m2) as m2,
        sum(m3) as m3,
        sum(m4) as m4,
        sum(m5) as m5,
        sum(m6) as m6,
        sum(m7) as m7,
        sum(m8) as m8,
        sum(m9) as m9,
        sum(m10) as m10,
        sum(m11) as m11,
        sum(m12) as m12

      FROM temp_prog tem
        inner join pre.tpartida par on par.id_partida = tem.id_partida_fk
      where par.nivel_partida = p_nivel
      group by
        tem.id_gestion,
        tem.descripcion,
    	tem.gestion,
        par.codigo,
        par.nombre_partida,
        par.nivel_partida,
        par.sw_transaccional,
        tem.id_partida_fk,
        par.id_partida_fk,
        tem.id_partida) LOOP


      insert into temp_prog(
            id_partida,
            id_partida_fk,
            id_gestion,
            codigo_partida,
            nombre_partida,
            descripcion,
            gestion,
            nivel_partida,
            sw_transaccional,
            m1,
            m2,
            m3,
            m4,
            m5,
            m6,
            m7,
            m8,
            m9,
            m10,
            m11,
            m12,
    		procesado
        )
      values   (
         	v_registros.id_partida_fk,
          v_registros.id_partida_abuelo,
          v_registros.id_gestion,
          v_registros.codigo_partida,
          v_registros.nombre_partida,
          v_registros.descripcion,
          p_id_gestion,
          v_registros.nivel_partida,
          v_registros.sw_transaccional,
          v_registros.m1,
          v_registros.m2,
          v_registros.m3,
          v_registros.m4,
          v_registros.m5,
          v_registros.m6,
          v_registros.m7,
          v_registros.m8,
          v_registros.m9,
          v_registros.m10,
          v_registros.m11,
          v_registros.m12,
          'si'
        );

		-- raise exception 'Esta llegando';
      v_sw_force = true;

    END LOOP;

    -- si tenemos mas datos para procesar hacemos la llamada recursiva
    IF v_sw_force THEN
      if p_nivel > 0 then
        PERFORM pre.f_rep_memoria_recursivo_wf(p_id_gestion,p_nivel-1);
      end if;

    END IF;
    RETURN TRUE;
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
RETURNS NULL ON NULL INPUT
SECURITY INVOKER
COST 100;