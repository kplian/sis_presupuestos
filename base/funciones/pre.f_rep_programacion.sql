CREATE OR REPLACE FUNCTION pre.f_rep_programacion (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS SETOF record AS
$body$
DECLARE


v_parametros  		record;
v_nombre_funcion   	text;
v_resp				varchar;


v_sw integer;
v_sw2 integer;
v_count integer;
v_consulta varchar;
v_registros  record;  -- PARA ALMACENAR EL CONJUNTO DE DATOS RESULTADO DEL SELECT


v_i 				integer;
v_nivel_inicial		integer;
v_total 			numeric;
v_tipo_cuenta		varchar;
v_incluir_cierre	varchar;
va_id_presupuesto	INTEGER[];
va_id_periodo		integer[];
v_nivel				integer;
v_id_gestion		integer;


BEGIN

     v_nombre_funcion = 'pre.f_rep_programacion';
     v_parametros = pxp.f_get_record(p_tabla);


    /*********************************
     #TRANSACCION:    'PRE_PROGR_REP'
     #DESCRIPCION:     reporte de programacion mensual
     #AUTOR:           rensi arteaga copari  kplian
     #FECHA:           26-04-2016
    ***********************************/

	IF(p_transaccion='PRE_PROGR_REP')then

        --raise exception 'error';

        -- 1) Crea una tabla temporal con los datos que se utilizaran

        CREATE TEMPORARY TABLE temp_prog (
                                id_presupuesto integer,
                                id_categoria_programatica integer,
                                id_cp_programa integer,
                                id_gestion integer,
                                id_partida integer,
                                codigo_partida varchar,
                                nombre_partida varchar,
                                id_partida_fk integer,
                                nivel_partida integer,
                                sw_transaccional varchar,
                                c1	numeric,
                                c2 NUMERIC,
                                c3 NUMERIC,
                                c4 NUMERIC,
                                c5 NUMERIC,
                                c6 NUMERIC,
                                c7 NUMERIC,
                                c8 NUMERIC,
                                c9 NUMERIC,
                                c10 NUMERIC,
                                c11 NUMERIC,
                                c12 NUMERIC,
                                total	numeric,
                                procesado varchar) ON COMMIT DROP;





          --llenar tabla temporal con la estructura de datos solicitada


              -- array de presupuestos
             IF v_parametros.tipo_reporte = 'programa' and v_parametros.id_cp_programa is not null and v_parametros.id_cp_programa != 0 THEN

                     SELECT
                         pxp.aggarray(p.id_presupuesto)
                     into
                        va_id_presupuesto
                     FROM pre.tpresupuesto p
                     inner join pre.tcategoria_programatica cp on cp.id_categoria_programatica = p.id_categoria_prog
                     where cp.id_cp_programa = v_parametros.id_cp_programa
                            and p.tipo_pres::text = ANY (string_to_array(v_parametros.tipo_pres::text,','));




             ELSEIF v_parametros.tipo_reporte = 'categoria' and v_parametros.id_categoria_programatica is not null and v_parametros.id_categoria_programatica != 0 THEN

                     SELECT
                         pxp.aggarray(p.id_presupuesto)
                     into
                        va_id_presupuesto
                     FROM pre.tpresupuesto p
                     where p.id_categoria_prog = v_parametros.id_categoria_programatica
                     and p.tipo_pres  = ANY (string_to_array(v_parametros.tipo_pres::text,','));


             ELSEIF v_parametros.tipo_reporte = 'presupuesto' and v_parametros.id_presupuesto is not null and v_parametros.id_presupuesto != 0 THEN

                   va_id_presupuesto[1] = v_parametros.id_presupuesto;

             ELSE

                   SELECT
                       pxp.aggarray(p.id_presupuesto)
                   into
                      va_id_presupuesto
                   FROM pre.vpresupuesto p
                   where p.id_gestion = v_parametros.id_gestion
                   and p.tipo_pres  = ANY (string_to_array(v_parametros.tipo_pres::text,','));

             END IF;


        --  recuperar array de periodos de la gestion


         select
              pxp.aggarray(id_periodo)
         into
             va_id_periodo
         from  (   select
                      per.id_periodo
                    from param.tperiodo per
                    where per.id_gestion =  v_parametros.id_gestion
                    order by per.periodo asc) periodo;




        -- lista las partida basicas de cada presupuesto
         FOR v_registros in (
                 select
                                   pp.id_partida,
                                   par.id_partida_fk,
                                   par.codigo as codigo_partida,
                                   par.nombre_partida,
                                   pp.id_presupuesto,
                                   cp.id_categoria_programatica,
                                   cp.id_cp_programa,
                                   par.nivel_partida,
                                   par.sw_transaccional,
                                   pre.f_get_total_programado_memoria_x_periodo(pp.id_partida, pp.id_presupuesto, va_id_periodo[1]) as c1,
                                   pre.f_get_total_programado_memoria_x_periodo(pp.id_partida, pp.id_presupuesto, va_id_periodo[2]) as c2,
                                   pre.f_get_total_programado_memoria_x_periodo(pp.id_partida, pp.id_presupuesto, va_id_periodo[3]) as c3,
                                   pre.f_get_total_programado_memoria_x_periodo(pp.id_partida, pp.id_presupuesto, va_id_periodo[4]) as c4,
                                   pre.f_get_total_programado_memoria_x_periodo(pp.id_partida, pp.id_presupuesto, va_id_periodo[5]) as c5,
                                   pre.f_get_total_programado_memoria_x_periodo(pp.id_partida, pp.id_presupuesto, va_id_periodo[6]) as c6,
                                   pre.f_get_total_programado_memoria_x_periodo(pp.id_partida, pp.id_presupuesto, va_id_periodo[7]) as c7,
                                   pre.f_get_total_programado_memoria_x_periodo(pp.id_partida, pp.id_presupuesto, va_id_periodo[8]) as c8,
                                   pre.f_get_total_programado_memoria_x_periodo(pp.id_partida, pp.id_presupuesto, va_id_periodo[9]) as c9,
                                   pre.f_get_total_programado_memoria_x_periodo(pp.id_partida, pp.id_presupuesto, va_id_periodo[10]) as c10,
                                   pre.f_get_total_programado_memoria_x_periodo(pp.id_partida, pp.id_presupuesto, va_id_periodo[11]) as c11,
                                   pre.f_get_total_programado_memoria_x_periodo(pp.id_partida, pp.id_presupuesto, va_id_periodo[12]) as c12
                               from pre.tpresup_partida pp
                               inner join pre.tpartida par on par.id_partida = pp.id_partida
                               inner join pre.tpresupuesto p on p.id_presupuesto = pp.id_presupuesto
                               inner join pre.tcategoria_programatica cp on cp.id_categoria_programatica = p.id_categoria_prog
                               where pp.id_presupuesto = ANY(va_id_presupuesto)) LOOP




                  -- inserta en tabla temporal
                     /*IF v_registros.c1 > 0 and   v_registros.c2 > 0 and  v_registros.c3 >0 and v_registros.c4 > 0 and
                        v_registros.c5 > 0 and   v_registros.c6 > 0 and  v_registros.c7 >0 and v_registros.c8 > 0 and
                        v_registros.c9 > 0 and   v_registros.c10 > 0 and  v_registros.c11 >0 and v_registros.c12 > 0  THEN
                     */

                     IF (v_registros.c1 + v_registros.c2 + v_registros.c3 + v_registros.c4 +
                          v_registros.c5 + v_registros.c6 + v_registros.c7 + v_registros.c8 +
                          v_registros.c9 + v_registros.c10 + v_registros.c11 + v_registros.c12) > 0  THEN
                           insert into temp_prog(
                                      id_presupuesto,
                                      id_categoria_programatica,
                                      id_cp_programa,
                                      id_gestion,
                                      id_partida,
                                      codigo_partida,
                                      nombre_partida,
                                      id_partida_fk,
                                      nivel_partida,
                                      sw_transaccional,
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
                                      procesado)

                                     values   (
                                      v_registros.id_presupuesto,
                                      v_registros.id_categoria_programatica,
                                      v_registros.id_cp_programa,
                                      v_parametros.id_gestion,
                                      v_registros.id_partida,
                                      v_registros.codigo_partida,
                                      v_registros.nombre_partida,
                                      v_registros.id_partida_fk,
                                      v_registros.nivel_partida,
                                      v_registros.sw_transaccional,
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
                                      'no');
                          END IF;

         END LOOP;

        select max(nivel_partida) into v_nivel
        from temp_prog;


         -- recursivamente busca los padres de las partida y consolida
        IF v_parametros.nivel != 5 THEN

            PERFORM pre.f_rep_programacion_recursivo(v_parametros.id_gestion,v_nivel -1);

        END IF;
        --listado consolidado segun parametros

       --raise exception 'llega';
        FOR v_registros in (
                              SELECT
       							  id_partida,
                                  codigo_partida,
                                  nombre_partida,
                                  nivel_partida,
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
                                  sum(c12) as c12
                          FROM temp_prog
                          WHERE

                              CASE WHEN v_parametros.nivel >= 4  THEN  0=0
                                  ELSE
                                    nivel_partida <= v_parametros.nivel
                                  END
                          group by
                             id_partida,
                             codigo_partida,
                             nombre_partida,
                             nivel_partida
                         order by codigo_partida) LOOP

                 -- raise notice 'entra---';

               RETURN NEXT v_registros;

       END LOOP;
    /*********************************
     #TRANSACCION:    'PRE_PROGR_WF'
     #DESCRIPCION:     reporte de programacion mensual para wf
     #AUTOR:           MMV
     #FECHA:           27-07-2017
    ***********************************/

	ELSIF(p_transaccion='PRE_PROGR_WF')then
    BEGIN

    CREATE TEMPORARY TABLE temp_prog (id_partida integer,
                                      id_partida_fk integer,
                                      id_gestion integer,
                                      codigo_partida varchar,
                                      nombre_partida varchar,
                                      id_presupuesto integer,
                                      id_proceso_wf integer,
                                      descripcion varchar,
                                      gestion integer,
                                      nivel_partida integer,
                                      sw_transaccional varchar,
                                      c1	NUMERIC,
                                      c2 	NUMERIC,
                                      c3 	NUMERIC,
                                      c4 	NUMERIC,
                                      c5 	NUMERIC,
                                      c6 	NUMERIC,
                                      c7 	NUMERIC,
                                      c8 	NUMERIC,
                                      c9 	NUMERIC,
                                      c10 NUMERIC,
                                      c11 NUMERIC,
                                      c12 NUMERIC,
                                      total	numeric,
                                      procesado varchar) ON COMMIT DROP;
    	select a.id_gestion
        into
        v_id_gestion
        from pre.tpresup_partida p
        inner join pre.tpresupuesto pp on pp.id_presupuesto = p.id_presupuesto
        inner join pre.tpartida a on a.id_partida = p.id_partida
        where pp.id_proceso_wf = v_parametros.id_proceso_wf LIMIT 1;


         select
              pxp.aggarray(id_periodo)
         into
             va_id_periodo
         from  (   select
                      per.id_periodo
                    from param.tperiodo per
                    where per.id_gestion =  v_id_gestion
                    order by per.periodo asc) periodo;


    FOR v_registros in (select 	 fm.id_partida,
                                 fm.id_partida_fk,
                                 fm.id_gestion,
                                 fm.codigo_partida,
                                 fm.nombre_partida,
                                 fm.id_presupuesto,
                                 fm.id_proceso_wf,
                                 fm.descripcion,
                                 fm.gestion,
                                 fm.nivel_partida,
                                 fm.sw_transaccional,
                                 fm.importe_enero,
                                 fm.importe_febrero,
                                 fm.importe_marzo,
                                 fm.importe_abril,
                                 fm.importe_mayo,
                                 fm.importe_junio,
                                 fm.importe_julio,
                                 fm.importe_agosto,
                                 fm.importe_septiembre,
                                 fm.importe_octubre,
                                 fm.importe_noviembre,
                                 fm.importe_diciembre
                                 from pre.vformulacion_mensual fm
                                 where fm.id_proceso_wf  = v_parametros.id_proceso_wf) LOOP

                           insert into temp_prog(
                                      id_presupuesto,
                                      id_gestion,
                                      id_partida,
                                      codigo_partida,
                                      nombre_partida,
                                      id_partida_fk,
                                      nivel_partida,
                                      sw_transaccional,
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
                                      procesado,
                                      descripcion,
                                      gestion,
                                      id_proceso_wf)

                                     values   (
                                      v_registros.id_presupuesto,
                                      v_id_gestion,
                                      v_registros.id_partida,
                                      v_registros.codigo_partida,
                                      v_registros.nombre_partida,
                                      v_registros.id_partida_fk,
                                      v_registros.nivel_partida,
                                      v_registros.sw_transaccional,
                                      v_registros.importe_enero,
                                      v_registros.importe_febrero,
                                      v_registros.importe_marzo,
                                      v_registros.importe_abril,
                                      v_registros.importe_mayo,
                                      v_registros.importe_junio,
                                      v_registros.importe_julio,
                                      v_registros.importe_agosto,
                                      v_registros.importe_septiembre,
                                      v_registros.importe_octubre,
                                      v_registros.importe_noviembre,
                                      v_registros.importe_diciembre,
                                      'no',
                                      v_registros.descripcion,
                                      v_registros.gestion,
                                      v_registros.id_proceso_wf);
         END LOOP;

        select max(nivel_partida) into v_nivel
        from temp_prog;


         -- recursivamente busca los padres de las partida y consolida
        IF 4 != 5 THEN

            PERFORM pre.f_rep_programacion_recursivo_wf(v_id_gestion,v_nivel -1);

        END IF;
        --listado consolidado segun parametros

        FOR v_registros in (
                              SELECT
       							  id_partida,
                                  codigo_partida,
                                  nombre_partida,
                                  nivel_partida,
                                  descripcion,
                                  gestion,
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
                                  sum(c12) as c12
                          FROM temp_prog
                          WHERE 0=0
                          group by
                             id_partida,
                             codigo_partida,
                             nombre_partida,
                             nivel_partida,
                             descripcion,
                             gestion
                         order by codigo_partida) LOOP


               RETURN NEXT v_registros;


    END LOOP;
    END;


END IF;

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
COST 100 ROWS 1000;