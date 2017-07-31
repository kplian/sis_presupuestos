CREATE OR REPLACE FUNCTION pre.f_rep_evaluacion_recursivo (
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

    v_nombre_funcion = 'pre.f_rep_evaluacion_recursivo';

    raise notice 'lamada recursiva.........................';
    v_sw_force = false;  --para criterio de parada

    FOR v_registros in (
      select
        tem.id_partida,
        --tem.id_presupuesto,
       -- tem.id_categoria_programatica,
        --tem.id_cp_programa,
        tem.id_gestion,
        tem.id_partida_fk,
        par.codigo as codigo_partida,
        par.nombre_partida,
        par.id_partida_fk as id_partida_abuelo,
        par.nivel_partida,
        par.sw_transaccional,
        tem.cod_prg,
        sum(c1) as c1,
        sum(c2) as c2,
        sum(c3) as c3,
        sum(c4) as c4,
        sum(c5) as c5,
        sum(c6) as c6,
        sum(c7) as c7,
        sum(c8) as c8,
        sum(c9) as c9,
        sum(c10) as c10,
        sum(c11) as c11,
        sum(c12) as c12,
        sum(b1) as b1,
        sum(b2) as b2,
        sum(b3) as b3,
        sum(b4) as b4,
        sum(b5) as b5,
        sum(b6) as b6,
        sum(b7) as b7,
        sum(b8) as b8,
        sum(b9) as b9,
        sum(b10) as b10,
        sum(b11) as b11,
        sum(b12) as b12,
        sum (total_programado) as total_programado,
        sum(importe_aprobado) as importe_aprobado,
        sum(modificaciones) as modificaciones,
        sum(total_comp_ejec) as total_comp_ejec

      FROM temp_prog tem
        inner join pre.tpartida par on par.id_partida = tem.id_partida_fk
      where par.nivel_partida = p_nivel
      group by
        --tem.id_presupuesto,
        --tem.id_categoria_programatica,
        --tem.id_cp_programa,
        tem.id_gestion,
        cod_prg,
        par.codigo,
        par.nombre_partida,
        par.nivel_partida,
        par.sw_transaccional,
        tem.id_partida_fk,
        par.id_partida_fk,
        tem.id_partida) LOOP


      insert into temp_prog(
        --id_presupuesto,
       -- id_categoria_programatica,
        --id_cp_programa,
        id_gestion,
        id_partida,
        codigo_partida,
        nombre_partida,
        id_partida_fk,
        nivel_partida,
        sw_transaccional,
        cod_prg,
        c1,
        c2,
        c3,
        c4,
        c5,
        c6,
        c7,
        c8,
        c9,
        c10,
        c11,
        c12,
        b1,
        b2,
        b3,
        b4,
        b5,
        b6,
        b7,
        b8,
        b9,
        b10,
        b11,
        b12,
       total_programado,
       importe_aprobado,
       modificaciones,
       total_comp_ejec
        )

      values   (
        --v_registros.id_presupuesto,
        --v_registros.id_categoria_programatica,
       -- v_registros.id_cp_programa,
        p_id_gestion,
        v_registros.id_partida_fk,
        v_registros.codigo_partida,
        v_registros.nombre_partida,
        v_registros.id_partida_abuelo,
        v_registros.nivel_partida,
        v_registros.sw_transaccional,
        v_registros.cod_prg,

        v_registros.c1,
        v_registros.c2,
        v_registros.c3,
        v_registros.c4,
        v_registros.c5,
        v_registros.c6,
        v_registros.c7,
        v_registros.c8,
        v_registros.c9,
        v_registros.c10,
        v_registros.c11,
        v_registros.c12,

        v_registros.b1,
        v_registros.b2,
        v_registros.b3,
        v_registros.b4,
        v_registros.b5,
        v_registros.b6,
        v_registros.b7,
        v_registros.b8,
        v_registros.b9,
        v_registros.b10,
        v_registros.b11,
        v_registros.b12,
        v_registros.total_programado,
        v_registros.importe_aprobado,
        v_registros.modificaciones,
        v_registros.total_comp_ejec
        );

		-- raise exception 'Esta llegando';
      v_sw_force = true;

    END LOOP;

    -- si tenemos mas datos para procesar hacemos la llamada recursiva
    IF v_sw_force THEN
      if p_nivel > 0 then
        PERFORM pre.f_rep_evaluacion_recursivo(p_id_gestion,p_nivel-1);
      end if;
    END IF;

    RETURN TRUE;
--raise exception 'llega';


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