CREATE OR REPLACE FUNCTION pre.f_rep_evaluacion_de_partidas (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS SETOF record AS
$body$
DECLARE


v_parametros      record;
v_nombre_funcion    text;
v_resp        varchar;


v_consulta varchar;
v_registros  record;
v_inner     varchar;


va_id_presupuesto INTEGER[];
va_id_periodo   integer[];
v_nivel       integer;
v_per_eje     integer[];
v_fecha_fin     integer;





BEGIN

     v_nombre_funcion = 'pre.f_rep_evaluacion_de_partidas';
     v_parametros = pxp.f_get_record(p_tabla);


    /*********************************
  #TRANSACCION:  'REP_PAR_EJE'
  #DESCRIPCION: Reporte
  #AUTOR:   Miguel Alejandro Mamani Villegas
  #FECHA:   03-05-2017
  ***********************************/
   IF(p_transaccion='REP_PAR_EJE')then
   begin
   IF v_parametros.tipo_movimiento = 'comprometido' or v_parametros.tipo_movimiento = 'ejecutado' then
       CREATE TEMPORARY TABLE temp_prog (
                                id_gestion integer,
                                id_partida integer,
                                codigo_partida varchar,
                                nombre_partida varchar,
                                id_partida_fk integer,
                                nivel_partida integer,
                                sw_transaccional varchar,
                                cod_prg varchar,
                                c1  numeric,
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
                                --total numeric,
                                b1 numeric,
                                b2 NUMERIC,
                                b3 NUMERIC,
                                b4 NUMERIC,
                                b5 NUMERIC,
                                b6 NUMERIC,
                                b7 NUMERIC,
                                b8 NUMERIC,
                                b9 NUMERIC,
                                b10 NUMERIC,
                                b11 NUMERIC,
                                b12 NUMERIC,
                                total_programado numeric,
                                importe_aprobado numeric,
                                modificaciones numeric,
                                total_comp_ejec numeric

                                ) ON COMMIT DROP;



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
             ELSEIF v_parametros.tipo_reporte = 'tipo_cc' and v_parametros.id_tipo_cc is not null and v_parametros.id_tipo_cc != 0 THEN
                 --raise exception 'error provocado %',v_parametros.id_tipo_cc;
               
                             
             ELSE

                   SELECT
                       pxp.aggarray(p.id_presupuesto)
                   into
                      va_id_presupuesto
                   FROM pre.vpresupuesto p
                   where p.id_gestion = v_parametros.id_gestion
                   and p.tipo_pres  = ANY (string_to_array(v_parametros.tipo_pres::text,','));



             END IF;


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
   IF v_parametros.tipo_movimiento = 'comprometido' THEN
         FOR v_registros in (
                  select  pp.id_partida,
                            pp.codigo as codigo_partida,
                            pp.nombre_partida,
                            pp.id_partida_fk,
                            pp.nivel_partida,
                            pp.sw_transaccional,
                        (CASE
                             WHEN
                             v_parametros.tipo_reporte = 'programa' THEN
                             'PROGRAMA '|| ma.codigo::varchar
                             WHEN
                             v_parametros.tipo_reporte = 'categoria' THEN
                             cp.descripcion::varchar
                             WHEN v_parametros.tipo_reporte = 'presupuesto' THEN
                             e.descripcion::varchar
                             END::varchar )as cod_prg,

                            (md.importe_enero) as c1,
                            (md.importe_febrero) as c2,
                            (md.importe_marzo) as  c3,
                            (md.importe_abril) as  c4,
                            (md.importe_mayo) as  c5,
                            (md.importe_junio) as  c6,
                            (md.importe_julio) as  c7,
                            (md.importe_agosto) as  c8,
                            (md.importe_septiembre) as c9,
                            (md.importe_octubre) as c10,
                            (md.importe_noviembre) as c11,
                            (md.importe_diciembre) as c12,

                            (e.importe_enero) as b1,
                            (e.importe_febrero) as b2,
                            (e.importe_marzo) as  b3,
                            (e.importe_abril) as  b4,
                            (e.importe_mayo) as  b5,
                            (e.importe_junio) as  b6,
                            (e.importe_julio) as  b7,
                            (e.importe_agosto) as  b8,
                            (e.importe_septiembre) as  b9,
                            (e.importe_octubre) as  b10,
                            (e.importe_noviembre) as  b11,
                            (e.importe_diciembre) as  b12,
                            pre.f_get_ejecucion_programa_memoria_total(prp.id_partida, prp.id_presupuesto,v_parametros.id_gestion) as total_programado,
                            round( pre.f_get_presupuesto_aprobado_por_gestion(prp.id_partida,prp.id_presupuesto ,v_parametros.id_gestion) +  pre.f_presupuesto_ajuste_prueba(prp.id_partida,prp.id_presupuesto,v_parametros.id_gestion) )as importe_aprobado,
              pre.f_presupuesto_ajuste_de_por_gestion(prp.id_partida,prp.id_presupuesto,v_parametros.id_gestion) modificaciones,
                            pre.f_get_estado_presupuesto_mb_x_fechas(prp.id_presupuesto, prp.id_partida,v_parametros.tipo_movimiento,v_parametros.fecha_ini,v_parametros.fecha_fin) as total_comp_ejec
                            from pre.tpartida pp
                            inner join pre.tpresup_partida prp on prp.id_partida = pp.id_partida
                            inner join pre.vpartida_comprometido_por_periodos  e on e.id_presup_partida = prp.id_presup_partida
                            inner join pre.vprogramando_memoria_por_periodo md on md.id_presup_partida = prp.id_presup_partida  and md.id_presupuesto = ANY(va_id_presupuesto)
                            inner join pre.tcategoria_programatica cp on cp.id_categoria_programatica = e.id_categoria_programatica
                            inner join pre.tcp_programa ma on ma.id_cp_programa = e.id_cp_programa
                            where e.id_presupuesto = ANY(va_id_presupuesto)  and
                                                  CASE
                                                         WHEN COALESCE(v_parametros.id_partida,0) = 0  THEN   -- todos
                                                             0 = 0
                                                        ELSE
                                                            pp.id_partida = v_parametros.id_partida
                                                        END
                            ) LOOP

                           insert into temp_prog(
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
                                      v_parametros.id_gestion,
                                      v_registros.id_partida,
                                      v_registros.codigo_partida,
                                      v_registros.nombre_partida,
                                      v_registros.id_partida_fk,
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



         END LOOP;
          ELSIF v_parametros.tipo_movimiento = 'ejecutado'THEN
          FOR v_registros in (
                  select  pp.id_partida,
                            pp.codigo as codigo_partida,
                            pp.nombre_partida,
                            pp.id_partida_fk,
                            pp.nivel_partida,
                            pp.sw_transaccional,
                        (CASE
                             WHEN
                             v_parametros.tipo_reporte = 'programa' THEN
                             'PROGRAMA '|| ma.codigo::varchar
                             WHEN
                             v_parametros.tipo_reporte = 'categoria' THEN
                             cp.descripcion::varchar
                             WHEN v_parametros.tipo_reporte = 'presupuesto' THEN
                             e.descripcion::varchar
                             END::varchar )as cod_prg,

                            (md.importe_enero) as c1,
                            (md.importe_febrero) as c2,
                            (md.importe_marzo) as  c3,
                            (md.importe_abril) as  c4,
                            (md.importe_mayo) as  c5,
                            (md.importe_junio) as  c6,
                            (md.importe_julio) as  c7,
                            (md.importe_agosto) as  c8,
                            (md.importe_septiembre) as c9,
                            (md.importe_octubre) as c10,
                            (md.importe_noviembre) as c11,
                            (md.importe_diciembre) as c12,

                            (e.importe_enero) as b1,
                            (e.importe_febrero) as b2,
                            (e.importe_marzo) as  b3,
                            (e.importe_abril) as  b4,
                            (e.importe_mayo) as  b5,
                            (e.importe_junio) as  b6,
                            (e.importe_julio) as  b7,
                            (e.importe_agosto) as  b8,
                            (e.importe_septiembre) as  b9,
                            (e.importe_octubre) as  b10,
                            (e.importe_noviembre) as  b11,
                            (e.importe_diciembre) as  b12,
                            pre.f_get_ejecucion_programa_memoria_total(prp.id_partida, prp.id_presupuesto,v_parametros.id_gestion) as total_programado,
                            round( pre.f_get_presupuesto_aprobado_por_gestion(prp.id_partida,prp.id_presupuesto ,v_parametros.id_gestion) +  pre.f_presupuesto_ajuste_prueba(prp.id_partida,prp.id_presupuesto,v_parametros.id_gestion) )as importe_aprobado,
              pre.f_presupuesto_ajuste_de_por_gestion(prp.id_partida,prp.id_presupuesto,v_parametros.id_gestion) modificaciones,
                            pre.f_get_estado_presupuesto_mb_x_fechas(prp.id_presupuesto, prp.id_partida,v_parametros.tipo_movimiento,v_parametros.fecha_ini,v_parametros.fecha_fin) as total_comp_ejec
                            from pre.tpartida pp
                            inner join pre.tpresup_partida prp on prp.id_partida = pp.id_partida
                            inner join pre.vpartida_ejecutado_por_periodos e on e.id_presup_partida = prp.id_presup_partida
                            inner join pre.vprogramando_memoria_por_periodo md on md.id_presup_partida = prp.id_presup_partida  and md.id_presupuesto = ANY(va_id_presupuesto)
                            inner join pre.tcategoria_programatica cp on cp.id_categoria_programatica = e.id_categoria_programatica
                            inner join pre.tcp_programa ma on ma.id_cp_programa = e.id_cp_programa
                            where e.id_presupuesto = ANY(va_id_presupuesto)and
                                                  CASE
                                                         WHEN COALESCE(v_parametros.id_partida,0) = 0  THEN   -- todos
                                                             0 = 0
                                                        ELSE
                                                            pp.id_partida = v_parametros.id_partida
                                                        END
                            ) LOOP

                           insert into temp_prog(
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
                                      v_parametros.id_gestion,
                                      v_registros.id_partida,
                                      v_registros.codigo_partida,
                                      v_registros.nombre_partida,
                                      v_registros.id_partida_fk,
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



         END LOOP;

    END IF;
        select max(nivel_partida) into v_nivel
        from temp_prog;

        IF v_parametros.nivel != 5 THEN

            PERFORM pre.f_rep_evaluacion_recursivo(v_parametros.id_gestion,v_nivel -1);

        END IF;


        FOR v_registros in (
                              SELECT
                      id_partida,
                                  codigo_partida,
                                  nombre_partida,
                                  nivel_partida,
                                  cod_prg,
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
                                  round(sum(c1)-sum (b1) )::numeric as diferencia1,
                                  round(sum(c2)-sum (b2) )::numeric as diferencia2,
                                  round(sum(c3)-sum (b3) )::numeric as diferencia3,
                                  round(sum(c4)-sum (b4) )::numeric as diferencia4,
                                  round(sum(c5)-sum (b5) )::numeric as diferencia5,
                                  round(sum(c6)-sum (b6) )::numeric as diferencia6,
                                  round(sum(c7)-sum (b7) )::numeric as diferencia7,
                                  round(sum(c8)-sum (b8) )::numeric as diferencia8,
                                  round(sum(c9)-sum (b9) )::numeric as diferencia9,
                                  round(sum(c10)-sum (b10) )::numeric as diferencia10,
                                  round(sum(c11)-sum (b11) )::numeric as diferencia11,
                                  round(sum(c12)-sum (b12) )::numeric as diferencia12,
                                  sum(b1)::numeric as acumulado1,
                                  round(sum(b1) + sum(b2))::numeric as acumulado2,
                                  round(sum(b1)+sum(b2)+sum(b3))::numeric as acumulado3,
                                  round(sum(b1)+sum(b2)+sum(b3)+sum(b4))::numeric as acumulado4,
                                  round(sum(b1)+sum(b2)+sum(b3)+sum(b4)+sum(b5))::numeric as acumulado5,
                                  round(sum(b1)+sum(b2)+sum(b3)+sum(b4)+sum(b5)+sum(b6))::numeric as acumulado6,
                                  round(sum(b1)+sum(b2)+sum(b3)+sum(b4)+sum(b5)+sum(b6)+sum(b7))::numeric as acumulado7,
                                  round(sum(b1)+sum(b2)+sum(b3)+sum(b4)+sum(b5)+sum(b6)+sum(b7)+sum(b8))::numeric as acumulado8,
                                  round(sum(b1)+sum(b2)+sum(b3)+sum(b4)+sum(b5)+sum(b6)+sum(b7)+sum(b8)+sum(b9))::numeric as acumulado9,
                                  round(sum(b1)+sum(b2)+sum(b3)+sum(b4)+sum(b5)+sum(b6)+sum(b7)+sum(b8)+sum(b9)+sum(b10))::numeric as acumulado10,
                                  round(sum(b1)+sum(b2)+sum(b3)+sum(b4)+sum(b5)+sum(b6)+sum(b7)+sum(b8)+sum(b9)+sum(b10)+sum(b11))::numeric as acumulado11,
                                  round(sum(b1)+sum(b2)+sum(b3)+sum(b4)+sum(b5)+sum(b6)+sum(b7)+sum(b8)+sum(b9)+sum(b10)+sum(b11)+sum(b12) )::numeric as acumulado12,
                                  sum (total_programado) as total_programado,
                                  sum(importe_aprobado) as importe_aprobado,
                                  sum(modificaciones) as modificaciones,
                                  sum(total_comp_ejec) as total_comp_ejec

                                FROM temp_prog
                            WHERE CASE WHEN v_parametros.nivel = 4  THEN
                                    0=0
                                   WHEN v_parametros.nivel = 5  THEN
                                   0=0 and nivel_partida != 1 and nivel_partida != 2
                                  WHEN v_parametros.nivel = 0  THEN
                                   0=0 and nivel_partida != 2 and nivel_partida != 3
                                 ELSE
                                    nivel_partida <= v_parametros.nivel
                                 END
                         GROUP BY
                                  id_partida,
                                  codigo_partida,
                                  nombre_partida,
                                  nivel_partida,
                                  cod_prg

                         order by cod_prg,codigo_partida) LOOP

               RETURN NEXT v_registros;
       END LOOP;
       end if;
       end;


       ---Paritdas ejecucion comprometido las 2 columnas
    elsif(p_transaccion='REP_PAR_CE')then
    begin
     IF v_parametros.tipo_movimiento = 'todos' then
     CREATE TEMPORARY TABLE temp_prog (
                                id_gestion integer,
                                id_partida integer,
                                codigo_partida varchar,
                                nombre_partida varchar,
                                id_partida_fk integer,
                                nivel_partida integer,
                                sw_transaccional varchar,
                                cod_prg varchar,

                                c1  numeric,
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
                                --total numeric,
                                b1 numeric,
                                b2 NUMERIC,
                                b3 NUMERIC,
                                b4 NUMERIC,
                                b5 NUMERIC,
                                b6 NUMERIC,
                                b7 NUMERIC,
                                b8 NUMERIC,
                                b9 NUMERIC,
                                b10 NUMERIC,
                                b11 NUMERIC,
                                b12 NUMERIC,

                                f1 numeric,
                                f2 NUMERIC,
                                f3 NUMERIC,
                                f4 NUMERIC,
                                f5 NUMERIC,
                                f6 NUMERIC,
                                f7 NUMERIC,
                                f8 NUMERIC,
                                f9 NUMERIC,
                                f10 NUMERIC,
                                f11 NUMERIC,
                                f12 NUMERIC,
                                total_programado numeric,
                                importe_aprobado numeric,
                                modificaciones numeric,
                                total_comprometido numeric,
                                total_ejecutado numeric,
                                procesado varchar) ON COMMIT DROP;



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


         select
              pxp.aggarray(id_periodo)
         into
             va_id_periodo
         from  (   select
                      per.id_periodo
                    from param.tperiodo per
                    where per.id_gestion =  v_parametros.id_gestion
                    order by per.periodo asc) periodo;
   select   pxp.aggarray(date_part)
         INTO
            v_per_eje
    from ( select DISTINCT
      date_part('month', per.fecha)

    from pre.tpartida_ejecucion per
        where   per.tipo_movimiento = 'ejecutado'
            and  date_part('month',per.fecha) >= date_part('month',v_parametros.fecha_ini) and date_part('month',per.fecha)<=date_part('month',v_parametros.fecha_fin)
    order by date_part  asc)perd;

   -- lista las partida basicas de cada presupuesto
         FOR v_registros in (
         select pp.id_partida,
                            pp.codigo as codigo_partida,
                            pp.nombre_partida,
                            pp.id_partida_fk,
                            pp.nivel_partida,
                            pp.sw_transaccional,
                            (CASE
                             WHEN
                             v_parametros.tipo_reporte = 'programa' THEN
                             'PROGRAMA '|| ma.codigo::varchar
                             WHEN
                             v_parametros.tipo_reporte = 'categoria' THEN
                             cp.descripcion::varchar
                             WHEN v_parametros.tipo_reporte = 'presupuesto' THEN
                             e.descripcion::varchar
                             END::varchar )as cod_prg,

                             (md.importe_enero) as c1,
                            (md.importe_febrero) as c2,
                            (md.importe_marzo) as  c3,
                            (md.importe_abril) as  c4,
                            (md.importe_mayo) as  c5,
                            (md.importe_junio) as  c6,
                            (md.importe_julio) as  c7,
                            (md.importe_agosto) as  c8,
                            (md.importe_septiembre) as c9,
                            (md.importe_octubre) as c10,
                            (md.importe_noviembre) as c11,
                            (md.importe_diciembre) as c12,

                            (cm.importe_enero) as b1,
                            (cm.importe_febrero) as b2,
                            (cm.importe_marzo) as  b3,
                            (cm.importe_abril) as  b4,
                            (cm.importe_mayo) as  b5,
                            (cm.importe_junio) as  b6,
                            (cm.importe_julio) as  b7,
                            (cm.importe_agosto) as  b8,
                            (cm.importe_septiembre) as  b9,
                            (cm.importe_octubre) as  b10,
                            (cm.importe_noviembre) as  b11,
                            (cm.importe_diciembre) as  b12,

                            (e.importe_enero) as f1,
                            (e.importe_febrero) as f2,
                            (e.importe_marzo) as  f3,
                            (e.importe_abril) as  f4,
                            (e.importe_mayo) as  f5,
                            (e.importe_junio) as  f6,
                            (e.importe_julio) as  f7,
                            (e.importe_agosto) as  f8,
                            (e.importe_septiembre) as  f9,
                            (e.importe_octubre) as  f10,
                            (e.importe_noviembre) as  f11,
                            (e.importe_diciembre) as  f12,
                            pre.f_get_ejecucion_programa_memoria_total(prp.id_partida, prp.id_presupuesto,v_parametros.id_gestion) as total_programado,
                            round( pre.f_get_presupuesto_aprobado_por_gestion(prp.id_partida,prp.id_presupuesto ,v_parametros.id_gestion) +  pre.f_presupuesto_ajuste_prueba(prp.id_partida,prp.id_presupuesto,v_parametros.id_gestion) )as importe_aprobado,
              pre.f_presupuesto_ajuste_de_por_gestion(prp.id_partida,prp.id_presupuesto,v_parametros.id_gestion) modificaciones,
                            pre.f_get_estado_presupuesto_mb_x_fechas(prp.id_presupuesto, prp.id_partida,'comprometido',v_parametros.fecha_ini,v_parametros.fecha_fin) as total_comprometido,
                            pre.f_get_estado_presupuesto_mb_x_fechas(prp.id_presupuesto, prp.id_partida,'ejecutado',v_parametros.fecha_ini,v_parametros.fecha_fin) as total_ejecutado
                            from pre.tpartida pp
                            inner join pre.tpresup_partida prp on prp.id_partida = pp.id_partida
                            inner join pre.vpartida_ejecutado_por_periodos e on e.id_presup_partida = prp.id_presup_partida
                            inner join pre.vpartida_comprometido_por_periodos cm on cm.id_presup_partida = prp.id_presup_partida and cm.id_presupuesto = ANY(va_id_presupuesto)
                            inner join pre.vprogramando_memoria_por_periodo md on md.id_presup_partida = prp.id_presup_partida  and md.id_presupuesto = ANY(va_id_presupuesto)
                            inner join pre.tcategoria_programatica cp on cp.id_categoria_programatica = e.id_categoria_programatica
                            inner join pre.tcp_programa ma on ma.id_cp_programa = e.id_cp_programa
                            where e.id_presupuesto = ANY(va_id_presupuesto) and
                                                  CASE
                                                         WHEN COALESCE(v_parametros.id_partida,0) = 0  THEN   -- todos
                                                             0 = 0
                                                        ELSE
                                                            pp.id_partida = v_parametros.id_partida
                                                        END  ) LOOP

                           insert into temp_prog(
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

                                       f1,
                                       f2,
                                       f3,
                                       f4,
                                       f5,
                                       f6,
                                       f7,
                                       f8,
                                       f9,
                                       f10,
                                       f11,
                                       f12,
                                       total_programado,
                                      importe_aprobado,
                                      modificaciones,
                                      total_comprometido,
                                      total_ejecutado,

                                      procesado)

                                     values   (
                                    v_parametros.id_gestion,
                                      v_registros.id_partida,
                                      v_registros.codigo_partida,
                                      v_registros.nombre_partida,
                                      v_registros.id_partida_fk,
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

                                      v_registros.f1,
                                       v_registros.f2,
                                       v_registros.f3,
                                       v_registros.f4,
                                       v_registros.f5,
                                       v_registros.f6,
                                       v_registros.f7,
                                       v_registros.f8,
                                       v_registros.f9,
                                       v_registros.f10,
                                       v_registros.f11,
                                       v_registros.f12,
                                      v_registros.total_programado,
                                      v_registros.importe_aprobado,
                                      v_registros.modificaciones,
                                      v_registros.total_comprometido,
                                      v_registros.total_ejecutado,
                                      'no');



         END LOOP;

        select max(nivel_partida) into v_nivel
        from temp_prog;


         -- recursivamente busca los padres de las partida y consolida
        IF v_parametros.nivel != 5 THEN

            PERFORM pre.f_rep_evaluacion_recursivo_todo(v_parametros.id_gestion,v_nivel -1);


        END IF;
        --raise exception 'llega';
        --listado consolidado segun parametros


        FOR v_registros in (
                              SELECT
                      id_partida,
                                  codigo_partida,
                                  nombre_partida,
                                  nivel_partida,
                                  cod_prg,
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
                                  sum(f1) as f1,
                                  sum(f2) as f2,
                                  sum(f3) as f3,
                                  sum(f4) as f4,
                                  sum(f5) as f5,
                                  sum(f6) as f6,
                                  sum(f7) as f7,
                                  sum(f8) as f8,
                                  sum(f9) as f9,
                                  sum(f10) as f10,
                                  sum(f11) as f11,
                                  sum(f12) as f12,
                                  round(sum(c1)-sum (b1) )::numeric as diferencia_compremetido1,
                                  round(sum(c2)-sum (b2) )::numeric as diferencia_compremetido2,
                                  round(sum(c3)-sum (b3) )::numeric as diferencia_compremetido3,
                                  round(sum(c4)-sum (b4) )::numeric as diferencia_compremetido4,
                                  round(sum(c5)-sum (b5) )::numeric as diferencia_compremetido5,
                                  round(sum(c6)-sum (b6) )::numeric as diferencia_compremetido6,
                                  round(sum(c7)-sum (b7) )::numeric as diferencia_compremetido7,
                                  round(sum(c8)-sum (b8) )::numeric as diferencia_compremetido8,
                                  round(sum(c9)-sum (b9) )::numeric as diferencia_compremetido9,
                                  round(sum(c10)-sum (b10) )::numeric as diferencia_compremetido10,
                                  round(sum(c11)-sum (b11) )::numeric as diferencia_compremetido11,
                                  round(sum(c12)-sum (b12) )::numeric as diferencia_compremetido12,

                                  round(sum(c1)-sum (f1) )::numeric as diferencia_ejecutado1,
                                  round(sum(c2)-sum (f2) )::numeric as diferencia_ejecutado2,
                                  round(sum(c3)-sum (f3) )::numeric as diferencia_ejecutado3,
                                  round(sum(c4)-sum (f4) )::numeric as diferencia_ejecutado4,
                                  round(sum(c5)-sum (f5) )::numeric as diferencia_ejecutado5,
                                  round(sum(c6)-sum (f6) )::numeric as diferencia_ejecutado6,
                                  round(sum(c7)-sum (f7) )::numeric as diferencia_ejecutado7,
                                  round(sum(c8)-sum (f8) )::numeric as diferencia_ejecutado8,
                                  round(sum(c9)-sum (f9) )::numeric as diferencia_ejecutado9,
                                  round(sum(c10)-sum (f10) )::numeric as diferencia_ejecutado10,
                                  round(sum(c11)-sum (f11) )::numeric as diferencia_ejecutado11,
                                  round(sum(c12)-sum (f12) )::numeric as diferencia_ejecutado12,
                                  sum(b1)::numeric as acumulado_comprendido1,
                                  round(sum(b1) + sum(b2))::numeric as acumulado_comprendido2,
                                  round(sum(b1)+sum(b2)+sum(b3))::numeric as acumulado_comprendido3,
                                  round(sum(b1)+sum(b2)+sum(b3)+sum(b4))::numeric as acumulado_comprendido4,
                                  round(sum(b1)+sum(b2)+sum(b3)+sum(b4)+sum(b5))::numeric as acumulado_comprendido5,
                                  round(sum(b1)+sum(b2)+sum(b3)+sum(b4)+sum(b5)+sum(b6))::numeric as acumulado_comprendido6,
                                  round(sum(b1)+sum(b2)+sum(b3)+sum(b4)+sum(b5)+sum(b6)+sum(b7))::numeric as acumulado_comprendido7,
                                  round(sum(b1)+sum(b2)+sum(b3)+sum(b4)+sum(b5)+sum(b6)+sum(b7)+sum(b8))::numeric as acumulado_comprendido8,
                                  round(sum(b1)+sum(b2)+sum(b3)+sum(b4)+sum(b5)+sum(b6)+sum(b7)+sum(b8)+sum(b9))::numeric as acumulado_comprendido9,
                                  round(sum(b1)+sum(b2)+sum(b3)+sum(b4)+sum(b5)+sum(b6)+sum(b7)+sum(b8)+sum(b9)+sum(b10))::numeric as acumulado_comprendido10,
                                  round(sum(b1)+sum(b2)+sum(b3)+sum(b4)+sum(b5)+sum(b6)+sum(b7)+sum(b8)+sum(b9)+sum(b10)+sum(b11))::numeric as acumulado_comprendido11,
                                  round(sum(b1)+sum(b2)+sum(b3)+sum(b4)+sum(b5)+sum(b6)+sum(b7)+sum(b8)+sum(b9)+sum(b10)+sum(b11)+sum(b12) )::numeric as acumulado_comprendido12,
                              sum(f1)::numeric as acumulado_ejecutado1,
                                  round(sum(f1) + sum(f2))::numeric as acumulado_ejecutado2,
                                  round(sum(f1)+sum(f2)+sum(f3))::numeric as acumulado_ejecutado3,
                                  round(sum(f1)+sum(f2)+sum(f3)+sum(f4))::numeric as acumulado_ejecutado4,
                                  round(sum(f1)+sum(f2)+sum(f3)+sum(f4)+sum(f5))::numeric as acumulado_ejecutado5,
                                  round(sum(f1)+sum(f2)+sum(f3)+sum(f4)+sum(f5)+sum(f6))::numeric as acumulado_ejecutado6,
                                  round(sum(f1)+sum(f2)+sum(f3)+sum(f4)+sum(f5)+sum(f6)+sum(f7))::numeric as acumulado_ejecutado7,
                                  round(sum(f1)+sum(f2)+sum(f3)+sum(f4)+sum(f5)+sum(f6)+sum(f7)+sum(f8))::numeric as acumulado_ejecutado8,
                                  round(sum(f1)+sum(f2)+sum(f3)+sum(f4)+sum(f5)+sum(f6)+sum(f7)+sum(f8)+sum(f9))::numeric as acumulado_ejecutado9,
                                  round(sum(f1)+sum(f2)+sum(f3)+sum(f4)+sum(f5)+sum(f6)+sum(f7)+sum(f8)+sum(f9)+sum(f10))::numeric as acumulado_ejecutado10,
                                  round(sum(f1)+sum(f2)+sum(f3)+sum(f4)+sum(f5)+sum(f6)+sum(f7)+sum(f8)+sum(f9)+sum(f10)+sum(f11))::numeric as acumulado_ejecutado11,
                                  round(sum(f1)+sum(f2)+sum(f3)+sum(f4)+sum(f5)+sum(f6)+sum(f7)+sum(f8)+sum(f9)+sum(f10)+sum(f11)+sum(f12) )::numeric as acumulado_ejecutado12,
                                  sum (total_programado) as total_programado,
                                  sum(importe_aprobado) as importe_aprobado,
                                  sum(modificaciones) as modificaciones,
                      sum(total_comprometido) as total_comprometido,
                                  sum(total_ejecutado) as total_ejecutado
                          FROM temp_prog
                          WHERE

                              CASE WHEN v_parametros.nivel = 4  THEN
                                 0=0
                                   WHEN v_parametros.nivel = 5  THEN
                                   0=0 and nivel_partida != 1 and nivel_partida != 2
                                  WHEN v_parametros.nivel = 0  THEN
                                   0=0 and nivel_partida != 2 and nivel_partida != 3
                                 ELSE
                                    nivel_partida <= v_parametros.nivel
                                 END
                          group by
                             id_partida,
                             codigo_partida,
                             nombre_partida,
                             nivel_partida,
                             cod_prg
                         order by cod_prg,codigo_partida) LOOP

               RETURN NEXT v_registros;
       END LOOP;
       end if;
    end;
    ---institucional

      elsif(p_transaccion='REP_PAR_INST')then
    begin
    if v_parametros.id_cp_programa = 0 or v_parametros.id_categoria_programatica = 0 or  v_parametros.id_presupuesto = 0 THEN
     --raise EXCEPTION 'llega';
     CREATE TEMPORARY TABLE temp_prog (
                                id_gestion integer,
                                id_partida integer,
                                codigo_partida varchar,
                                nombre_partida varchar,
                                id_partida_fk integer,
                                nivel_partida integer,
                                sw_transaccional varchar,

                                c1  numeric,
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

                                b1 numeric,
                                b2 NUMERIC,
                                b3 NUMERIC,
                                b4 NUMERIC,
                                b5 NUMERIC,
                                b6 NUMERIC,
                                b7 NUMERIC,
                                b8 NUMERIC,
                                b9 NUMERIC,
                                b10 NUMERIC,
                                b11 NUMERIC,
                                b12 NUMERIC,

                                f1 numeric,
                                f2 NUMERIC,
                                f3 NUMERIC,
                                f4 NUMERIC,
                                f5 NUMERIC,
                                f6 NUMERIC,
                                f7 NUMERIC,
                                f8 NUMERIC,
                                f9 NUMERIC,
                                f10 NUMERIC,
                                f11 NUMERIC,
                                f12 NUMERIC,
                                total_programado numeric,
                                importe_aprobado numeric,
                                modificaciones numeric,
                                total_comprometido numeric,
                                total_ejecutado numeric,
                                procesado varchar) ON COMMIT DROP;


                   SELECT
                       pxp.aggarray(p.id_presupuesto)
                   into
                      va_id_presupuesto
                   FROM pre.vpresupuesto p
                   where p.id_gestion = v_parametros.id_gestion
                   and p.tipo_pres  = ANY (string_to_array(v_parametros.tipo_pres::text,','));

         FOR v_registros in (
         select pp.id_partida,
                            pp.codigo as codigo_partida,
                            pp.nombre_partida,
                            pp.id_partida_fk,
                            pp.nivel_partida,
                            pp.sw_transaccional,

                            (md.importe_enero) as c1,
                            (md.importe_febrero) as c2,
                            (md.importe_marzo) as  c3,
                            (md.importe_abril) as  c4,
                            (md.importe_mayo) as  c5,
                            (md.importe_junio) as  c6,
                            (md.importe_julio) as  c7,
                            (md.importe_agosto) as  c8,
                            (md.importe_septiembre) as c9,
                            (md.importe_octubre) as c10,
                            (md.importe_noviembre) as c11,
                            (md.importe_diciembre) as c12,

                            (cm.importe_enero) as b1,
                            (cm.importe_febrero) as b2,
                            (cm.importe_marzo) as  b3,
                            (cm.importe_abril) as  b4,
                            (cm.importe_mayo) as  b5,
                            (cm.importe_junio) as  b6,
                            (cm.importe_julio) as  b7,
                            (cm.importe_agosto) as  b8,
                            (cm.importe_septiembre) as  b9,
                            (cm.importe_octubre) as  b10,
                            (cm.importe_noviembre) as  b11,
                            (cm.importe_diciembre) as  b12,

                            (e.importe_enero) as f1,
                            (e.importe_febrero) as f2,
                            (e.importe_marzo) as  f3,
                            (e.importe_abril) as  f4,
                            (e.importe_mayo) as  f5,
                            (e.importe_junio) as  f6,
                            (e.importe_julio) as  f7,
                            (e.importe_agosto) as  f8,
                            (e.importe_septiembre) as  f9,
                            (e.importe_octubre) as  f10,
                            (e.importe_noviembre) as  f11,
                            (e.importe_diciembre) as  f12,
                            pre.f_get_ejecucion_programa_memoria_total(prp.id_partida, prp.id_presupuesto,v_parametros.id_gestion) as total_programado,
                            round( pre.f_get_presupuesto_aprobado_por_gestion(prp.id_partida,prp.id_presupuesto ,v_parametros.id_gestion) +  pre.f_presupuesto_ajuste_prueba(prp.id_partida,prp.id_presupuesto,v_parametros.id_gestion) )as importe_aprobado,
              pre.f_presupuesto_ajuste_de_por_gestion(prp.id_partida,prp.id_presupuesto,v_parametros.id_gestion) modificaciones,
                            pre.f_get_estado_presupuesto_mb_x_fechas(prp.id_presupuesto, prp.id_partida,'comprometido',v_parametros.fecha_ini,v_parametros.fecha_fin) as total_comprometido,
                            pre.f_get_estado_presupuesto_mb_x_fechas(prp.id_presupuesto, prp.id_partida,'ejecutado',v_parametros.fecha_ini,v_parametros.fecha_fin) as total_ejecutado
                            from pre.tpartida pp
                            inner join pre.tpresup_partida prp on prp.id_partida = pp.id_partida
                            inner join pre.vpartida_ejecutado_por_periodos e on e.id_presup_partida = prp.id_presup_partida
                            inner join pre.vpartida_comprometido_por_periodos cm on cm.id_presup_partida = prp.id_presup_partida and cm.id_presupuesto = ANY(va_id_presupuesto)
                            inner join pre.vprogramando_memoria_por_periodo md on md.id_presup_partida = prp.id_presup_partida  and md.id_presupuesto = ANY(va_id_presupuesto)
                            inner join pre.tcategoria_programatica cp on cp.id_categoria_programatica = e.id_categoria_programatica
                            inner join pre.tcp_programa ma on ma.id_cp_programa = e.id_cp_programa
                            where e.id_presupuesto = ANY(va_id_presupuesto) and
                                                  CASE
                                                         WHEN COALESCE(v_parametros.id_partida,0) = 0  THEN   -- todos
                                                             0 = 0
                                                        ELSE
                                                            pp.id_partida = v_parametros.id_partida
                                                        END  ) LOOP

                           insert into temp_prog(
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

                                       f1,
                                       f2,
                                       f3,
                                       f4,
                                       f5,
                                       f6,
                                       f7,
                                       f8,
                                       f9,
                                       f10,
                                       f11,
                                       f12,
                                       total_programado,
                                      importe_aprobado,
                                      modificaciones,
                                      total_comprometido,
                                      total_ejecutado,

                                      procesado)

                                     values   (
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

                                      v_registros.f1,
                                       v_registros.f2,
                                       v_registros.f3,
                                       v_registros.f4,
                                       v_registros.f5,
                                       v_registros.f6,
                                       v_registros.f7,
                                       v_registros.f8,
                                       v_registros.f9,
                                       v_registros.f10,
                                       v_registros.f11,
                                       v_registros.f12,
                                      v_registros.total_programado,
                                      v_registros.importe_aprobado,
                                      v_registros.modificaciones,
                                      v_registros.total_comprometido,
                                      v_registros.total_ejecutado,
                                      'no');



         END LOOP;

        select max(nivel_partida) into v_nivel
        from temp_prog;


         -- recursivamente busca los padres de las partida y consolida
        IF v_parametros.nivel != 5 THEN

            PERFORM pre.f_rep_evaluacion_recursivo_institucional(v_parametros.id_gestion,v_nivel -1);


        END IF;
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
                                  sum(f1) as f1,
                                  sum(f2) as f2,
                                  sum(f3) as f3,
                                  sum(f4) as f4,
                                  sum(f5) as f5,
                                  sum(f6) as f6,
                                  sum(f7) as f7,
                                  sum(f8) as f8,
                                  sum(f9) as f9,
                                  sum(f10) as f10,
                                  sum(f11) as f11,
                                  sum(f12) as f12,
                                  round(sum(c1)-sum (b1) )::numeric as diferencia_compremetido1,
                                  round(sum(c2)-sum (b2) )::numeric as diferencia_compremetido2,
                                  round(sum(c3)-sum (b3) )::numeric as diferencia_compremetido3,
                                  round(sum(c4)-sum (b4) )::numeric as diferencia_compremetido4,
                                  round(sum(c5)-sum (b5) )::numeric as diferencia_compremetido5,
                                  round(sum(c6)-sum (b6) )::numeric as diferencia_compremetido6,
                                  round(sum(c7)-sum (b7) )::numeric as diferencia_compremetido7,
                                  round(sum(c8)-sum (b8) )::numeric as diferencia_compremetido8,
                                  round(sum(c9)-sum (b9) )::numeric as diferencia_compremetido9,
                                  round(sum(c10)-sum (b10) )::numeric as diferencia_compremetido10,
                                  round(sum(c11)-sum (b11) )::numeric as diferencia_compremetido11,
                                  round(sum(c12)-sum (b12) )::numeric as diferencia_compremetido12,

                                  round(sum(c1)-sum (f1) )::numeric as diferencia_ejecutado1,
                                  round(sum(c2)-sum (f2) )::numeric as diferencia_ejecutado2,
                                  round(sum(c3)-sum (f3) )::numeric as diferencia_ejecutado3,
                                  round(sum(c4)-sum (f4) )::numeric as diferencia_ejecutado4,
                                  round(sum(c5)-sum (f5) )::numeric as diferencia_ejecutado5,
                                  round(sum(c6)-sum (f6) )::numeric as diferencia_ejecutado6,
                                  round(sum(c7)-sum (f7) )::numeric as diferencia_ejecutado7,
                                  round(sum(c8)-sum (f8) )::numeric as diferencia_ejecutado8,
                                  round(sum(c9)-sum (f9) )::numeric as diferencia_ejecutado9,
                                  round(sum(c10)-sum (f10) )::numeric as diferencia_ejecutado10,
                                  round(sum(c11)-sum (f11) )::numeric as diferencia_ejecutado11,
                                  round(sum(c12)-sum (f12) )::numeric as diferencia_ejecutado12,
                                  sum(b1)::numeric as acumulado_comprendido1,
                                  round(sum(b1) + sum(b2))::numeric as acumulado_comprendido2,
                                  round(sum(b1)+sum(b2)+sum(b3))::numeric as acumulado_comprendido3,
                                  round(sum(b1)+sum(b2)+sum(b3)+sum(b4))::numeric as acumulado_comprendido4,
                                  round(sum(b1)+sum(b2)+sum(b3)+sum(b4)+sum(b5))::numeric as acumulado_comprendido5,
                                  round(sum(b1)+sum(b2)+sum(b3)+sum(b4)+sum(b5)+sum(b6))::numeric as acumulado_comprendido6,
                                  round(sum(b1)+sum(b2)+sum(b3)+sum(b4)+sum(b5)+sum(b6)+sum(b7))::numeric as acumulado_comprendido7,
                                  round(sum(b1)+sum(b2)+sum(b3)+sum(b4)+sum(b5)+sum(b6)+sum(b7)+sum(b8))::numeric as acumulado_comprendido8,
                                  round(sum(b1)+sum(b2)+sum(b3)+sum(b4)+sum(b5)+sum(b6)+sum(b7)+sum(b8)+sum(b9))::numeric as acumulado_comprendido9,
                                  round(sum(b1)+sum(b2)+sum(b3)+sum(b4)+sum(b5)+sum(b6)+sum(b7)+sum(b8)+sum(b9)+sum(b10))::numeric as acumulado_comprendido10,
                                  round(sum(b1)+sum(b2)+sum(b3)+sum(b4)+sum(b5)+sum(b6)+sum(b7)+sum(b8)+sum(b9)+sum(b10)+sum(b11))::numeric as acumulado_comprendido11,
                                  round(sum(b1)+sum(b2)+sum(b3)+sum(b4)+sum(b5)+sum(b6)+sum(b7)+sum(b8)+sum(b9)+sum(b10)+sum(b11)+sum(b12) )::numeric as acumulado_comprendido12,
                              sum(f1)::numeric as acumulado_ejecutado1,
                                  round(sum(f1) + sum(f2))::numeric as acumulado_ejecutado2,
                                  round(sum(f1)+sum(f2)+sum(f3))::numeric as acumulado_ejecutado3,
                                  round(sum(f1)+sum(f2)+sum(f3)+sum(f4))::numeric as acumulado_ejecutado4,
                                  round(sum(f1)+sum(f2)+sum(f3)+sum(f4)+sum(f5))::numeric as acumulado_ejecutado5,
                                  round(sum(f1)+sum(f2)+sum(f3)+sum(f4)+sum(f5)+sum(f6))::numeric as acumulado_ejecutado6,
                                  round(sum(f1)+sum(f2)+sum(f3)+sum(f4)+sum(f5)+sum(f6)+sum(f7))::numeric as acumulado_ejecutado7,
                                  round(sum(f1)+sum(f2)+sum(f3)+sum(f4)+sum(f5)+sum(f6)+sum(f7)+sum(f8))::numeric as acumulado_ejecutado8,
                                  round(sum(f1)+sum(f2)+sum(f3)+sum(f4)+sum(f5)+sum(f6)+sum(f7)+sum(f8)+sum(f9))::numeric as acumulado_ejecutado9,
                                  round(sum(f1)+sum(f2)+sum(f3)+sum(f4)+sum(f5)+sum(f6)+sum(f7)+sum(f8)+sum(f9)+sum(f10))::numeric as acumulado_ejecutado10,
                                  round(sum(f1)+sum(f2)+sum(f3)+sum(f4)+sum(f5)+sum(f6)+sum(f7)+sum(f8)+sum(f9)+sum(f10)+sum(f11))::numeric as acumulado_ejecutado11,
                                  round(sum(f1)+sum(f2)+sum(f3)+sum(f4)+sum(f5)+sum(f6)+sum(f7)+sum(f8)+sum(f9)+sum(f10)+sum(f11)+sum(f12) )::numeric as acumulado_ejecutado12,
                                  sum (total_programado) as total_programado,
                                  sum(importe_aprobado) as importe_aprobado,
                                  sum(modificaciones) as modificaciones,
                      sum(total_comprometido) as total_comprometido,
                                  sum(total_ejecutado) as total_ejecutado
                          FROM temp_prog
                          WHERE

                              CASE WHEN v_parametros.nivel = 4  THEN
                                 0=0
                                   WHEN v_parametros.nivel = 5  THEN
                                   0=0 and nivel_partida != 1 and nivel_partida != 2
                                  WHEN v_parametros.nivel = 0  THEN
                                   0=0 and nivel_partida != 2 and nivel_partida != 3
                                 ELSE
                                    nivel_partida <= v_parametros.nivel
                                 END
                          group by
                             id_partida,
                             codigo_partida,
                             nombre_partida,
                             nivel_partida
                         order by codigo_partida) LOOP

               RETURN NEXT v_registros;
       END LOOP;
       end if ;
    end;


   else

      raise exception 'Transaccion inexistente: %',p_transaccion;

  end if;
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