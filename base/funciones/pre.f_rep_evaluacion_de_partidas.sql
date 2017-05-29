CREATE OR REPLACE FUNCTION pre.f_rep_evaluacion_de_partidas (
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


v_consulta varchar;
v_registros  record;



va_id_presupuesto	INTEGER[];
va_id_periodo		integer[];
v_nivel				integer;
v_per_eje			integer[];
v_fecha_fin			integer;





BEGIN

     v_nombre_funcion = 'pre.f_rep_evaluacion_de_partidas';
     v_parametros = pxp.f_get_record(p_tabla);


    /*********************************
 	#TRANSACCION:  'REP_PAR_EJE'
 	#DESCRIPCION:	Reporte
 	#AUTOR:		Miguel Alejandro Mamani Villegas
 	#FECHA:		03-05-2017
	***********************************/
   IF(p_transaccion='REP_PAR_EJE')then
   begin
   IF v_parametros.tipo_movimiento = 'comprometido' or v_parametros.tipo_movimiento = 'ejecutado' then
    	 CREATE TEMPORARY TABLE temp_prog (
                                --id_presupuesto integer,
                                id_categoria_programatica integer,
                                id_cp_programa integer,
                                id_gestion integer,
                                id_partida integer,
                                codigo_partida varchar,
                                nombre_partida varchar,
                                id_partida_fk integer,
                                nivel_partida integer,
                                sw_transaccional varchar,
                                cod_prg varchar,
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
                                --total	numeric,
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
        where 	per.tipo_movimiento = v_parametros.tipo_movimiento
        		and  date_part('month',per.fecha) <= date_part('month',v_parametros.fecha_ini) and date_part('month',per.fecha)>=date_part('month',v_parametros.fecha_fin)
		order by date_part  asc)perd;

   -- lista las partida basicas de cada presupuesto
         FOR v_registros in (
                 select
                                   pp.id_partida,
                                   par.id_partida_fk,
                                   par.codigo as codigo_partida,
                                   par.nombre_partida,
                                  -- pp.id_presupuesto,
                                   cp.id_categoria_programatica,
                                   cp.id_cp_programa,
                                   par.nivel_partida,
                                   par.sw_transaccional,
                                   (CASE
                                   WHEN
                                   v_parametros.tipo_reporte = 'programa' THEN
                                   'PROGRAMA '|| ma.codigo::varchar
                                   WHEN
                                   v_parametros.tipo_reporte = 'categoria' THEN
                                   cp.descripcion::varchar
                                   WHEN v_parametros.tipo_reporte = 'presupuesto' THEN
                                   p.codigo||' - '||p.descripcion::varchar
                                   END::varchar )as cod_prg,
                                     (case
                                   when date_part('month',v_parametros.fecha_fin)>= 1 and date_part('month',v_parametros.fecha_ini)<= 1 then
                                   pre.f_get_total_programado_memoria_x_periodo(pp.id_partida, pp.id_presupuesto, va_id_periodo[1])
                                    end) as c1,
                                   (case
                                   when date_part('month',v_parametros.fecha_fin)>= 2 and date_part('month',v_parametros.fecha_ini)<= 2 then
                                   pre.f_get_total_programado_memoria_x_periodo(pp.id_partida, pp.id_presupuesto, va_id_periodo[2])
                                 	end) as c2,
                                   (case
                                   when date_part('month',v_parametros.fecha_fin)>= 3 and date_part('month',v_parametros.fecha_ini)<= 3 then
                                   pre.f_get_total_programado_memoria_x_periodo(pp.id_partida, pp.id_presupuesto, va_id_periodo[3])
                                   end) as c3,
                                   (case
                                   when date_part('month',v_parametros.fecha_fin)>= 4 and date_part('month',v_parametros.fecha_ini)<= 4 then
                                   pre.f_get_total_programado_memoria_x_periodo(pp.id_partida, pp.id_presupuesto, va_id_periodo[4])
                                   end) as c4,
                                   (case
                                   when date_part('month',v_parametros.fecha_fin)>= 5 and date_part('month',v_parametros.fecha_ini)<= 5 then
                                   pre.f_get_total_programado_memoria_x_periodo(pp.id_partida, pp.id_presupuesto, va_id_periodo[5])
                                   end) as c5,
                                   (case
                                   when date_part('month',v_parametros.fecha_fin)>= 6 and date_part('month',v_parametros.fecha_ini)<= 6 then
                                   pre.f_get_total_programado_memoria_x_periodo(pp.id_partida, pp.id_presupuesto, va_id_periodo[6])
                                   end) as c6,
                                   (case
                                   when date_part('month',v_parametros.fecha_fin)>= 7 and date_part('month',v_parametros.fecha_ini)<= 7 then
                                   pre.f_get_total_programado_memoria_x_periodo(pp.id_partida, pp.id_presupuesto, va_id_periodo[7])
                                   end) as c7,
                                   (case
                                   when date_part('month',v_parametros.fecha_fin)>= 8 and date_part('month',v_parametros.fecha_ini)<= 8 then
                                   pre.f_get_total_programado_memoria_x_periodo(pp.id_partida, pp.id_presupuesto, va_id_periodo[8])
                                   end) as c8,
                                   (case
                                   when date_part('month',v_parametros.fecha_fin)>= 9 and date_part('month',v_parametros.fecha_ini)<= 9 then
                                   pre.f_get_total_programado_memoria_x_periodo(pp.id_partida, pp.id_presupuesto, va_id_periodo[9])
                                   end) as c9,
                                   (case
                                   when date_part('month',v_parametros.fecha_fin)>= 10 and date_part('month',v_parametros.fecha_ini)<= 10 then
                                   pre.f_get_total_programado_memoria_x_periodo(pp.id_partida, pp.id_presupuesto, va_id_periodo[10])
                                   end) as c10,
                                   (case
                                   when date_part('month',v_parametros.fecha_fin)>= 11 and date_part('month',v_parametros.fecha_ini)<= 11 then
                                   pre.f_get_total_programado_memoria_x_periodo(pp.id_partida, pp.id_presupuesto, va_id_periodo[11])
                                   end) as c11,
                                   (case
                                   when date_part('month',v_parametros.fecha_fin)>= 12 and date_part('month',v_parametros.fecha_ini)<= 12 then
                                   pre.f_get_total_programado_memoria_x_periodo(pp.id_partida, pp.id_presupuesto, va_id_periodo[12])
                                   end) as c12,
                                  --Ejecucion compro
                                   (case
                                  when date_part('month',v_parametros.fecha_fin)>= 1 and date_part('month',v_parametros.fecha_ini)<= 1 then
                                   pre.f_get_ejecutado_por_periodo (pp.id_partida,pp.id_presupuesto, v_parametros.id_gestion,1,v_parametros.tipo_movimiento)
                                    end) as b1,
                                   (case
                                   when date_part('month',v_parametros.fecha_fin)>= 2 and date_part('month',v_parametros.fecha_ini)<= 2 then
                                   pre.f_get_ejecutado_por_periodo (pp.id_partida,pp.id_presupuesto, v_parametros.id_gestion,2,v_parametros.tipo_movimiento)
                                 end) as b2,
                                   (case
                                   when date_part('month',v_parametros.fecha_fin)>= 3 and date_part('month',v_parametros.fecha_ini)<= 3 then
                                   pre.f_get_ejecutado_por_periodo (pp.id_partida,pp.id_presupuesto, v_parametros.id_gestion,3,v_parametros.tipo_movimiento)
                                   end) as b3,
                                   (case
                                   when date_part('month',v_parametros.fecha_fin)>= 4 and date_part('month',v_parametros.fecha_ini)<= 4 then
                                   pre.f_get_ejecutado_por_periodo (pp.id_partida,pp.id_presupuesto, v_parametros.id_gestion,4,v_parametros.tipo_movimiento)
                                   end) as b4,
                                   (case
                                   when date_part('month',v_parametros.fecha_fin)>= 5 and date_part('month',v_parametros.fecha_ini)<= 5 then
                                   pre.f_get_ejecutado_por_periodo (pp.id_partida,pp.id_presupuesto, v_parametros.id_gestion,5,v_parametros.tipo_movimiento)
                                   end) as b5,
                                   (case
                                   when date_part('month',v_parametros.fecha_fin)>= 6 and date_part('month',v_parametros.fecha_ini)<= 6 then
                                   pre.f_get_ejecutado_por_periodo (pp.id_partida,pp.id_presupuesto, v_parametros.id_gestion,6,v_parametros.tipo_movimiento)
                                   end) as b6,
                                   (case
                                   when date_part('month',v_parametros.fecha_fin)>= 7 and date_part('month',v_parametros.fecha_ini)<= 7 then
                                   pre.f_get_ejecutado_por_periodo (pp.id_partida,pp.id_presupuesto, v_parametros.id_gestion,7,v_parametros.tipo_movimiento)
                                   end) as b7,
                                   (case
                                   when date_part('month',v_parametros.fecha_fin)>= 8 and date_part('month',v_parametros.fecha_ini)<= 8then
                                   pre.f_get_ejecutado_por_periodo (pp.id_partida,pp.id_presupuesto, v_parametros.id_gestion,8,v_parametros.tipo_movimiento)
                                   end) as b8,
                                   (case
                                   when date_part('month',v_parametros.fecha_fin)>= 9 and date_part('month',v_parametros.fecha_ini)<= 9 then
                                   pre.f_get_ejecutado_por_periodo (pp.id_partida,pp.id_presupuesto, v_parametros.id_gestion,9,v_parametros.tipo_movimiento)
                                   end) as b9,
                                   (case
                                   when date_part('month',v_parametros.fecha_fin)>= 10 and date_part('month',v_parametros.fecha_ini)<= 10 then
                                   pre.f_get_ejecutado_por_periodo (pp.id_partida,pp.id_presupuesto, v_parametros.id_gestion,10,v_parametros.tipo_movimiento)
                                   end) as b10,
                                   (case
                                   when date_part('month',v_parametros.fecha_fin)>= 11 and date_part('month',v_parametros.fecha_ini)<= 11 then
                                   pre.f_get_ejecutado_por_periodo (pp.id_partida,pp.id_presupuesto, v_parametros.id_gestion,11,v_parametros.tipo_movimiento)
                                   end) as b11,
                                   (case
                                   when date_part('month',v_parametros.fecha_fin)>= 12 and date_part('month',v_parametros.fecha_ini)<= 12 then
                                   pre.f_get_ejecutado_por_periodo (pp.id_partida,pp.id_presupuesto, v_parametros.id_gestion,12,v_parametros.tipo_movimiento)
                                   end) as b12,
                                   pre.f_get_ejecucion_programa_memoria_total(pp.id_partida, pp.id_presupuesto,v_parametros.id_gestion) as total_programado,
                                   round( pre.f_get_presupuesto_aprobado_por_gestion(pp.id_partida,pp.id_presupuesto ,v_parametros.id_gestion) +  pre.f_presupuesto_ajuste_prueba(pp.id_partida,pp.id_presupuesto,v_parametros.id_gestion) )as importe_aprobado,
                   				   pre.f_presupuesto_ajuste_de_por_gestion(pp.id_partida,pp.id_presupuesto,v_parametros.id_gestion) modificaciones,
                                   pre.f_get_estado_presupuesto_mb_x_fechas(pp.id_presupuesto, pp.id_partida,v_parametros.tipo_movimiento,v_parametros.fecha_ini,v_parametros.fecha_fin) as total_comp_ejec
  							      from pre.tpresup_partida pp
                                  inner join pre.tpartida par on par.id_partida = pp.id_partida
                                  inner join pre.tpresupuesto p on p.id_presupuesto = pp.id_presupuesto
                                  inner join pre.tcategoria_programatica cp on cp.id_categoria_programatica = p.id_categoria_prog
                                  inner join pre.tcp_programa ma on ma.id_cp_programa = cp.id_cp_programa
                                  where pp.id_presupuesto = ANY(va_id_presupuesto)) LOOP

                           insert into temp_prog(
                                      --id_presupuesto,
                                      id_categoria_programatica,
                                      id_cp_programa,
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
                                       total_comp_ejec)

                                     values   (
                                      --v_registros.id_presupuesto,
                                      v_registros.id_categoria_programatica,
                                      v_registros.id_cp_programa,
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
                                 sum (c1) as c1,
                                 sum (c2) as c2,
                                 sum (c3) as c3,
                                 sum (c4) as c4,
                                 sum (c5) as c5,
                                 sum (c6) as c6,
                                 sum (c7) as c7,
                                 sum (c8) as c8,
                                 sum (c9) as c9,
                                 sum (c10) as c10,
                                 sum (c11) as c11,
                                 sum (c12) as c12,
                                 sum (b1) as b1,
                                 sum (b2) as b2,
                                 sum (b3) as b3,
                                 sum (b4) as b4,
                                 sum (b5) as b5,
                                 sum (b6) as b6,
                                 sum (b7) as b7,
                                 sum (b8) as b8,
                                 sum (b9) as b9,
                                 sum (b10) as b10,
                                 sum (b11) as b11,
                                 sum (b12) as b12,
                                 sum (total_programado) as total_programado,
                                 sum (importe_aprobado) as importe_aprobado,
                                 sum (modificaciones) as modificaciones,
        						 sum (total_comp_ejec) as total_comp_ejec
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


       ---Paritdas ejecucion comprometido las 2 columnas
    elsif(p_transaccion='REP_PAR_CE')then
    begin
     IF v_parametros.tipo_movimiento = 'todos' then
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
                                cod_prg varchar,
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
                                --total	numeric,
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
        where 	per.tipo_movimiento = 'ejecutado'
        		and  date_part('month',per.fecha) >= date_part('month',v_parametros.fecha_ini) and date_part('month',per.fecha)<=date_part('month',v_parametros.fecha_fin)
		order by date_part  asc)perd;

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
                                   (CASE
                                   WHEN
                                   v_parametros.tipo_reporte = 'programa' THEN
                                   'PROGRAMA '|| ma.codigo::varchar
                                   WHEN
                                   v_parametros.tipo_reporte = 'categoria' THEN
                                   cp.descripcion::varchar
                                   WHEN v_parametros.tipo_reporte = 'presupuesto' THEN
                                   p.codigo||' - '||p.descripcion::varchar
                                   END::varchar )as cod_prg,
                                   (case
                                   when date_part('month',v_parametros.fecha_fin)>= 1then
                                   pre.f_get_total_programado_memoria_x_periodo(pp.id_partida, pp.id_presupuesto, va_id_periodo[1])
                              		  end) as c1,
                                   (case
                                   when date_part('month',v_parametros.fecha_fin)>= 2then
                                   pre.f_get_total_programado_memoria_x_periodo(pp.id_partida, pp.id_presupuesto, va_id_periodo[2])
                             	   end) as c2,
                                   (case
                                   when date_part('month',v_parametros.fecha_fin)>= 3then
                                   pre.f_get_total_programado_memoria_x_periodo(pp.id_partida, pp.id_presupuesto, va_id_periodo[3])
                                   end) as c3,
                                   (case
                                   when date_part('month',v_parametros.fecha_fin)>= 4then
                                   pre.f_get_total_programado_memoria_x_periodo(pp.id_partida, pp.id_presupuesto, va_id_periodo[4])
                                   end) as c4,
                                   (case
                                   when date_part('month',v_parametros.fecha_fin)>= 5then
                                   pre.f_get_total_programado_memoria_x_periodo(pp.id_partida, pp.id_presupuesto, va_id_periodo[5])
                                   end) as c5,
                                   (case
                                   when date_part('month',v_parametros.fecha_fin)>= 6then
                                   pre.f_get_total_programado_memoria_x_periodo(pp.id_partida, pp.id_presupuesto, va_id_periodo[6])
                                   end) as c6,
                                   (case
                                   when date_part('month',v_parametros.fecha_fin)>= 7then
                                   pre.f_get_total_programado_memoria_x_periodo(pp.id_partida, pp.id_presupuesto, va_id_periodo[7])
                                   end) as c7,
                                   (case
                                   when date_part('month',v_parametros.fecha_fin)>= 8then
                                   pre.f_get_total_programado_memoria_x_periodo(pp.id_partida, pp.id_presupuesto, va_id_periodo[8])
                                   end) as c8,
                                   (case
                                   when date_part('month',v_parametros.fecha_fin)>= 9then
                                   pre.f_get_total_programado_memoria_x_periodo(pp.id_partida, pp.id_presupuesto, va_id_periodo[9])
                                   end) as c9,
                                   (case
                                   when date_part('month',v_parametros.fecha_fin)>= 10then
                                   pre.f_get_total_programado_memoria_x_periodo(pp.id_partida, pp.id_presupuesto, va_id_periodo[10])
                                   end) as c10,
                                   (case
                                   when date_part('month',v_parametros.fecha_fin)>= 11then
                                   pre.f_get_total_programado_memoria_x_periodo(pp.id_partida, pp.id_presupuesto, va_id_periodo[11])
                                   end) as c11,
                                   (case
                                   when date_part('month',v_parametros.fecha_fin)= 12then
                                   pre.f_get_total_programado_memoria_x_periodo(pp.id_partida, pp.id_presupuesto, va_id_periodo[12])
                                   end) as c12,
                                  ---comp
                                   (case
                                   when date_part('month',v_parametros.fecha_fin)>= 1then
                                   pre.f_get_ejecutado_por_periodo (pp.id_partida,pp.id_presupuesto, v_parametros.id_gestion,1,'comprometido')
                              		  end) as b1,
                                   (case
                                   when date_part('month',v_parametros.fecha_fin)>= 2then
                                   pre.f_get_ejecutado_por_periodo (pp.id_partida,pp.id_presupuesto, v_parametros.id_gestion,2,'comprometido')
                             	   end) as b2,
                                   (case
                                   when date_part('month',v_parametros.fecha_fin)>= 3then
                                   pre.f_get_ejecutado_por_periodo (pp.id_partida,pp.id_presupuesto, v_parametros.id_gestion,3,'comprometido')
                                   end) as b3,
                                   (case
                                   when date_part('month',v_parametros.fecha_fin)>= 4then
                                   pre.f_get_ejecutado_por_periodo (pp.id_partida,pp.id_presupuesto, v_parametros.id_gestion,4,'comprometido')
                                   end) as b4,
                                   (case
                                   when date_part('month',v_parametros.fecha_fin)>= 5then
                                   pre.f_get_ejecutado_por_periodo (pp.id_partida,pp.id_presupuesto, v_parametros.id_gestion,5,'comprometido')
                                   end) as b5,
                                   (case
                                   when date_part('month',v_parametros.fecha_fin)>= 6then
                                   pre.f_get_ejecutado_por_periodo (pp.id_partida,pp.id_presupuesto, v_parametros.id_gestion,6,'comprometido')
                                   end) as b6,
                                   (case
                                   when date_part('month',v_parametros.fecha_fin)>= 7then
                                   pre.f_get_ejecutado_por_periodo (pp.id_partida,pp.id_presupuesto, v_parametros.id_gestion,7,'comprometido')
                                   end) as b7,
                                   (case
                                   when date_part('month',v_parametros.fecha_fin)>= 8then
                                   pre.f_get_ejecutado_por_periodo (pp.id_partida,pp.id_presupuesto, v_parametros.id_gestion,8,'comprometido')
                                   end) as b8,
                                   (case
                                   when date_part('month',v_parametros.fecha_fin)>= 9then
                                   pre.f_get_ejecutado_por_periodo (pp.id_partida,pp.id_presupuesto, v_parametros.id_gestion,9,'comprometido')
                                   end) as b9,
                                   (case
                                   when date_part('month',v_parametros.fecha_fin)>= 10then
                                   pre.f_get_ejecutado_por_periodo (pp.id_partida,pp.id_presupuesto, v_parametros.id_gestion,10,'comprometido')
                                   end) as b10,
                                   (case
                                   when date_part('month',v_parametros.fecha_fin)>= 11then
                                   pre.f_get_ejecutado_por_periodo (pp.id_partida,pp.id_presupuesto, v_parametros.id_gestion,11,'comprometido')
                                   end) as b11,
                                   (case
                                   when date_part('month',v_parametros.fecha_fin)= 12then
                                   pre.f_get_ejecutado_por_periodo (pp.id_partida,pp.id_presupuesto, v_parametros.id_gestion,12,'comprometido')
                                   end) as b12,
                                   ----
                                   (case
                                   when date_part('month',v_parametros.fecha_fin)>= 1then
                                   pre.f_get_ejecutado_por_periodo (pp.id_partida,pp.id_presupuesto, v_parametros.id_gestion,1,'ejecutado')
                              		  end) as f1,
                                   (case
                                   when date_part('month',v_parametros.fecha_fin)>= 2then
                                   pre.f_get_ejecutado_por_periodo (pp.id_partida,pp.id_presupuesto, v_parametros.id_gestion,2,'ejecutado')
                             	   end) as f2,
                                   (case
                                   when date_part('month',v_parametros.fecha_fin)>= 3then
                                   pre.f_get_ejecutado_por_periodo (pp.id_partida,pp.id_presupuesto, v_parametros.id_gestion,3,'ejecutado')
                                   end) as f3,
                                   (case
                                   when date_part('month',v_parametros.fecha_fin)>= 4then
                                   pre.f_get_ejecutado_por_periodo (pp.id_partida,pp.id_presupuesto, v_parametros.id_gestion,4,'ejecutado')
                                   end) as f4,
                                   (case
                                   when date_part('month',v_parametros.fecha_fin)>= 5then
                                   pre.f_get_ejecutado_por_periodo (pp.id_partida,pp.id_presupuesto, v_parametros.id_gestion,5,'ejecutado')
                                   end) as f5,
                                   (case
                                   when date_part('month',v_parametros.fecha_fin)>= 6then
                                   pre.f_get_ejecutado_por_periodo (pp.id_partida,pp.id_presupuesto, v_parametros.id_gestion,6,'ejecutado')
                                   end) as f6,
                                   (case
                                   when date_part('month',v_parametros.fecha_fin)>= 7then
                                   pre.f_get_ejecutado_por_periodo (pp.id_partida,pp.id_presupuesto, v_parametros.id_gestion,7,'ejecutado')
                                   end) as f7,
                                   (case
                                   when date_part('month',v_parametros.fecha_fin)>= 8then
                                   pre.f_get_ejecutado_por_periodo (pp.id_partida,pp.id_presupuesto, v_parametros.id_gestion,8,'ejecutado')
                                   end) as f8,
                                   (case
                                   when date_part('month',v_parametros.fecha_fin)>= 9then
                                   pre.f_get_ejecutado_por_periodo (pp.id_partida,pp.id_presupuesto, v_parametros.id_gestion,9,'ejecutado')
                                   end) as f9,
                                   (case
                                   when date_part('month',v_parametros.fecha_fin)>= 10then
                                   pre.f_get_ejecutado_por_periodo (pp.id_partida,pp.id_presupuesto, v_parametros.id_gestion,10,'ejecutado')
                                   end) as f10,
                                   (case
                                   when date_part('month',v_parametros.fecha_fin)>= 11then
                                   pre.f_get_ejecutado_por_periodo (pp.id_partida,pp.id_presupuesto, v_parametros.id_gestion,11,'ejecutado')
                                   end) as f11,
                                   (case
                                   when date_part('month',v_parametros.fecha_fin)= 12then
                                   pre.f_get_ejecutado_por_periodo (pp.id_partida,pp.id_presupuesto, v_parametros.id_gestion,12,'ejecutado')
                                   end) as f12,
                                   pre.f_get_ejecucion_programa_memoria_total(pp.id_partida, pp.id_presupuesto,v_parametros.id_gestion) as total_programado,
                                   round( pre.f_get_presupuesto_aprobado_por_gestion(pp.id_partida,pp.id_presupuesto ,v_parametros.id_gestion) +  pre.f_presupuesto_ajuste_prueba(pp.id_partida,pp.id_presupuesto,v_parametros.id_gestion) )as importe_aprobado,
								   pre.f_presupuesto_ajuste_de_por_gestion(pp.id_partida,pp.id_presupuesto,v_parametros.id_gestion) modificaciones,
                                   pre.f_get_estado_presupuesto_mb_x_fechas(pp.id_presupuesto, pp.id_partida,'comprometido',v_parametros.fecha_ini,v_parametros.fecha_fin) as total_comprometido,
                                    pre.f_get_estado_presupuesto_mb_x_fechas(pp.id_presupuesto, pp.id_partida,'ejecutado',v_parametros.fecha_ini,v_parametros.fecha_fin) as total_ejecutado


                               from pre.tpresup_partida pp
                               inner join pre.tpartida par on par.id_partida = pp.id_partida
                               inner join pre.tpresupuesto p on p.id_presupuesto = pp.id_presupuesto
                               inner join pre.tcategoria_programatica cp on cp.id_categoria_programatica = p.id_categoria_prog
                               inner join pre.tcp_programa ma on ma.id_cp_programa = cp.id_cp_programa
                               where pp.id_presupuesto = ANY(va_id_presupuesto)) LOOP

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