CREATE OR REPLACE FUNCTION pre.f_rep_ejecucion_wf (
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

v_registros 		record;
v_nivel				integer;
v_presupuesto		record;
v_presupuesto_ant		record;




BEGIN

     v_nombre_funcion = 'pre.f_rep_programacion';
     v_parametros = pxp.f_get_record(p_tabla);


    /*********************************
     #TRANSACCION:    'PRE_PROGRA_WF'
     #DESCRIPCION:     reporte de programacion mensual
     #AUTOR:           MMV
     #FECHA:           31-07-2017
    ***********************************/

	IF(p_transaccion='PRE_PROGRA_WF')THEN
   begin
   		  CREATE TEMPORARY TABLE temp_prog ( id_partida integer,
                                        id_partida_fk integer,
                                        id_gestion integer,
                                        codigo_partida varchar,
                                        nombre_partida varchar,
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




select 	p.id_presupuesto,
		p.descripcion,
        c.id_gestion,
        p.id_proceso_wf
        into
        v_presupuesto
from pre.tpresupuesto p
inner join pre.tcategoria_programatica c on c.id_categoria_programatica = p.id_categoria_prog
where p.id_proceso_wf = v_parametros.id_proceso_wf;

select 	p.id_presupuesto,
		p.descripcion,
        c.id_gestion,
        p.id_proceso_wf
        into
        v_presupuesto_ant
from pre.tpresupuesto p
inner join pre.tcategoria_programatica c on c.id_categoria_programatica = p.id_categoria_prog
where c.id_gestion = v_presupuesto.id_gestion - 1  and p.descripcion = v_presupuesto.descripcion;


   FOR v_registros in(select 	par.id_partida,
   								par.id_partida_fk,
                                par.id_gestion,
   								par.codigo as codigo_partida,
                                par.nombre_partida,
   								g.gestion,
                                p.descripcion,
                                par.nivel_partida,
                                par.sw_transaccional,
                                pre.f_get_ejecutado_por_periodo(par.id_partida, p.id_presupuesto, 15, 1, 'ejecutado') as importe_enero,
                                pre.f_get_ejecutado_por_periodo(par.id_partida, p.id_presupuesto, 15, 2, 'ejecutado') as importe_febrero,
                                pre.f_get_ejecutado_por_periodo(par.id_partida, p.id_presupuesto, 15, 3, 'ejecutado') as importe_marzo,
                                pre.f_get_ejecutado_por_periodo(par.id_partida, p.id_presupuesto, 15, 4, 'ejecutado') as importe_abril,
                                pre.f_get_ejecutado_por_periodo(par.id_partida, p.id_presupuesto, 15, 5, 'ejecutado') as importe_mayo,
                                pre.f_get_ejecutado_por_periodo(par.id_partida, p.id_presupuesto, 15, 6, 'ejecutado') as importe_junio,
                                pre.f_get_ejecutado_por_periodo(par.id_partida, p.id_presupuesto, 15, 7, 'ejecutado') as importe_julio,
                                pre.f_get_ejecutado_por_periodo(par.id_partida, p.id_presupuesto, 15, 8, 'ejecutado') as importe_agosto,
                                pre.f_get_ejecutado_por_periodo(par.id_partida, p.id_presupuesto, 15, 9, 'ejecutado') as importe_septiembre,
                                pre.f_get_ejecutado_por_periodo(par.id_partida, p.id_presupuesto, 15, 10, 'ejecutado') as importe_octubre,
                                pre.f_get_ejecutado_por_periodo(par.id_partida, p.id_presupuesto, 15, 11, 'ejecutado') as importe_noviembre,
                                pre.f_get_ejecutado_por_periodo(par.id_partida, p.id_presupuesto, 15, 12, 'ejecutado') as importe_diciembre,
                                round( pre.f_get_presupuesto_aprobado_por_gestion(par.id_partida,p.id_presupuesto ,15) +  pre.f_presupuesto_ajuste_prueba(par.id_partida,p.id_presupuesto,15)+ pre.f_presupuesto_ajuste_de_por_gestion(par.id_partida,p.id_presupuesto,15) )as total_programado
                                from pre.tpresupuesto p
                                --inner join pre.vpartida_ejecutado_por_periodos me on me.id_proceso_wf = p.id_proceso_wf
                                inner join pre.tpresup_partida su on su.id_presupuesto = p.id_presupuesto
                                inner join pre.tpartida par on par.id_partida = su.id_partida
                                inner join param.tgestion g on g.id_gestion = par.id_gestion
                                where p.id_proceso_wf = v_presupuesto_ant.id_proceso_wf )


   					LOOP

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
    total,
    procesado
    )values(
    v_registros.id_partida,
    v_registros.id_partida_fk,
    v_registros.id_gestion,
    v_registros.codigo_partida,
    v_registros.nombre_partida,
    v_registros.descripcion,
    v_registros.gestion,
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
    v_registros.total_programado,
    'no');
   END LOOP;
    select max(nivel_partida) into v_nivel
        from temp_prog;

        IF 4!= 5 THEN

            PERFORM pre.f_rep_evaluacion_recursivo_wf(15,v_nivel -1);

        END IF;


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
                                  sum(c12) as c12,
                                  sum(total)as total
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
   /*********************************
     #TRANSACCION:    'PRE_MEMORIA_WF'
     #DESCRIPCION:     reporte de programacion mensual
     #AUTOR:           MMV
     #FECHA:           31-07-2017
    ***********************************/

	ELSIF(p_transaccion='PRE_MEMORIA_WF')THEN
    begin
   		  CREATE TEMPORARY TABLE temp_prog ( id_partida integer,
                                        id_partida_fk integer,
                                        id_gestion integer,
                                        codigo_partida varchar,
                                        nombre_partida varchar,
                                        descripcion varchar,
                                        gestion integer,
                                        nivel_partida integer,
                                        sw_transaccional varchar,
                                        m1	NUMERIC,
                                        m2 	NUMERIC,
                                        m3 	NUMERIC,
                                        m4 	NUMERIC,
                                        m5 	NUMERIC,
                                        m6 	NUMERIC,
                                        m7 	NUMERIC,
                                        m8 	NUMERIC,
                                        m9 	NUMERIC,
                                        m10 NUMERIC,
                                        m11 NUMERIC,
                                        m12 NUMERIC,
                                        procesado varchar) ON COMMIT DROP;
   select 	p.id_presupuesto,
		p.descripcion,
        c.id_gestion,
        p.id_proceso_wf
        into
        v_presupuesto
from pre.tpresupuesto p
inner join pre.tcategoria_programatica c on c.id_categoria_programatica = p.id_categoria_prog
where p.id_proceso_wf = v_parametros.id_proceso_wf;

select 	p.id_presupuesto,
		p.descripcion,
        c.id_gestion,
        p.id_proceso_wf
        into
        v_presupuesto_ant
from pre.tpresupuesto p
inner join pre.tcategoria_programatica c on c.id_categoria_programatica = p.id_categoria_prog
where c.id_gestion = v_presupuesto.id_gestion - 1  and p.descripcion = v_presupuesto.descripcion;





   FOR v_registros in(select 	par.id_partida,
   								par.id_partida_fk,
                                par.id_gestion,
   								par.codigo as codigo_partida,
                                par.nombre_partida,
   								g.gestion,
                                p.descripcion,
                                par.nivel_partida,
                                par.sw_transaccional,
                                me.importe_enero,
                                me.importe_febrero,
                                me.importe_marzo,
                                me.importe_abril,
                                me.importe_mayo,
                                me.importe_junio,
                                me.importe_julio,
                                me.importe_agosto,
                                me.importe_septiembre,
                                me.importe_octubre,
                                me.importe_noviembre,
                                me.importe_diciembre
                                from pre.tpresupuesto p
                                inner join pre.vformulacion_mensual me on me.id_proceso_wf = p.id_proceso_wf
                                inner join pre.tpartida par on par.id_partida = me.id_partida
                                inner join param.tgestion g on g.id_gestion = par.id_gestion
                                where p.id_proceso_wf = v_presupuesto_ant.id_proceso_wf )
   					LOOP

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
    )values(
    v_registros.id_partida,
    v_registros.id_partida_fk,
    v_registros.id_gestion,
    v_registros.codigo_partida,
    v_registros.nombre_partida,
    v_registros.descripcion,
    v_registros.gestion,
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
    'no');
   END LOOP;
    select max(nivel_partida) into v_nivel
        from temp_prog;



        IF 4!= 5 THEN

            PERFORM pre.f_rep_memoria_recursivo_wf(15,v_nivel -1);

        END IF;


        FOR v_registros in (
                              SELECT
       							  id_partida,
                                  codigo_partida,
                                  nombre_partida,
                                  nivel_partida,
                                  descripcion,
                                  gestion,
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
   ELSE

    	raise exception 'Transaccion inexistente: %',p_transaccion;

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