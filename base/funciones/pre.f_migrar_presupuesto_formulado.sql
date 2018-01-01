--------------- SQL ---------------

CREATE OR REPLACE FUNCTION pre.f_migrar_presupuesto_formulado (
)
RETURNS varchar AS
$body$
DECLARE
  v_tabla varchar;
  v_params VARCHAR [ ];
  v_resp varchar;

  v_registros record;
  v_id_gestion integer;
  v_estado varchar;
  v_gestion integer;
  v_id_tipo_cc integer;
  v_id_presupuesto integer;
  v_id_partida integer;
  v_id_conceto_ingas integer;
  v_total_memoria numeric;
  v_id_memoria_calculo integer;
  v_registros_per record;
  v_aux numeric;
  v_contador integer;

BEGIN

  for v_registros in (
  select id as id_formulacion_tmp,
         '2018'::integer         as gestion,
         carga as codigo_presupuesto,
         case when tipo2 = 'Ingreso' then 1104 else 1103 end as id_partida,
         case when tipo2 = 'Ingreso' then 1 when tipo2 = 'Gasto' then 2 else 3 end as tipo_pres, --else inversión
         descripcion,
         m1 as m1,
         m2 as m2,
         m3 as m3,
         m4 as m4,
         m5 as m5,
         m6 as m6,
         m7 as m7,
         m8 as m8,
         m9 as m9,
         m10 as m10,
         m11 as m11,
         m12 as m12,
         (m1::numeric + m2::numeric + m3::numeric + m4::numeric + m5::numeric +
           m6::numeric + m7::numeric + m8::numeric + m9::numeric + m10::numeric
           + m11::numeric + m12::numeric) as total_memoria
  from pre.tformulacion_tmp fo
  where fo.migrado = 'no'
        and id not IN (464,760,668,761,645,746,662,669,667,724,670,660,700,653,672,757,683,654,671,463,673)--tipo cc de ingreso/egreso o orden estadística
        )
  LOOP

    --inician variables           
    v_id_gestion = NULL;
    v_id_tipo_cc = NULL;
    v_id_presupuesto = NULL;
    v_total_memoria = 0;
    
    --obtenermos la gestion
    select ges.id_gestion
    into v_id_gestion
    from param.tgestion ges
    where ges.gestion = v_registros.gestion;
    --obtenemos el tipo de centro de costo

    select tcc.id_tipo_cc
    into v_id_tipo_cc
    from param.ttipo_cc tcc
    where trim(upper(tcc.codigo)) = trim(upper(v_registros.codigo_presupuesto)) and tcc.movimiento = 'si';

    IF v_id_tipo_cc  is null THEN
      raise notice 'no se encontro TIPO_CC para el codigo %',trim(upper(v_registros.codigo_presupuesto));
    END IF;

    --obntemos el presupeusto correpondiente para la gestion
    v_params = ARRAY[v_id_tipo_cc::varchar,--id_tipo_cc
      '646'::varchar,--id_uo -> GG
      v_id_gestion::varchar,--id_gestion
      v_registros.tipo_pres::varchar,--tipo_pres
      v_registros.codigo_presupuesto || ' ' || v_registros.descripcion::varchar,--descripcion
      'no'::varchar,--sw_consolidado
      1::varchar,--id_categoria_prog
      '01/01/2018'::varchar,
      '31/12/2018'::varchar
      ];
    v_tabla = pxp.f_crear_parametro(ARRAY['id_tipo_cc','id_uo','id_gestion','tipo_pres','descripcion','sw_consolidado','id_categoria_prog','fecha_inicio_pres','fecha_fin_pres'],
      v_params,
      ARRAY['int4','int4','int4','varchar','varchar','varchar','int4','date','date']
    );
    --Insertamos el registro
    v_resp = pre.ft_presupuesto_ime(1, 1, v_tabla, 'PRE_PRE_INS');
    --Obtencion del ID generado
    v_id_presupuesto = pxp.f_obtiene_clave_valor(v_resp,'id_presupuesto','','','valor')::integer;
    /*--cap - el presupuesto se inserta, ya no se selecciona
    select pre.id_presupuesto, pre.estado
    into v_id_presupuesto, v_estado
    from pre.tpresupuesto pre
    inner join param.tcentro_costo cc on pre.id_presupuesto = cc.id_centro_costo
    where cc.id_gestion = v_id_gestion and cc.id_tipo_cc = v_id_tipo_cc;
    */
    IF v_id_presupuesto  is null THEN
      raise notice 'no se encontro PRESUPUESTO para el codigo % en la gestion %',trim(upper(v_registros.codigo_presupuesto)), v_registros.gestion;
      update pre.tformulacion_tmp
      set obs = COALESCE(obs, '') || '***no se encontro PRESUPUESTO para el codigo ' || trim(upper(COALESCE(v_registros.codigo_presupuesto, 'NULO')))
      where id = v_registros.id_formulacion_tmp;
    ELSE

      /*IF v_estado = 'aprobado' THEN
        -- raise exception 'No puede agregar conceptos a la memoria de calculo de un presupuesto aprobado';
      END IF;*/

      -- obtenemso la partida
      --cap - ya se sabe cuál es la partida
      v_id_partida = v_registros.id_partida;
      /*select par.id_partida
      into v_id_partida
      from pre.tpartida par
      where par.id_gestion = v_id_gestion and upper(trim(par.codigo)) = upper(trim(v_registros.partida));*/

      -- obtenemso el concepto  de gasto para el codigo de partida identificado
      select cp.id_concepto_ingas
      into v_id_conceto_ingas
      from pre.tconcepto_partida cp
      where cp.id_partida = v_id_partida;

      IF v_id_conceto_ingas  is null THEN
        raise notice 'no se encontro CONCEPTO  para la partida % ',trim(upper(v_id_partida));
        update pre.tformulacion_tmp
        set obs = COALESCE(obs, '') || '***no se encontro CONCEPTO  para la partida ' || trim(upper(COALESCE(v_id_partida, 'NULO')))
        where id = v_registros.id_formulacion_tmp;
      ELSE
        --preguntamos is no existe una partida para el presupeusto la agregamos
        IF NOT EXISTS (
          select 1
          from pre.tpresup_partida
          where id_partida = v_id_partida and id_presupuesto = v_id_presupuesto) THEN
          INSERT INTO pre.tpresup_partida(id_presupuesto, id_partida, id_centro_costo, id_usuario_reg)
          VALUES (v_id_presupuesto, v_id_partida, v_id_presupuesto, 1);
        END IF;

        v_total_memoria = v_registros.total_memoria;

        --insertamos memoria de calculo si no existe
        IF NOT EXISTS (
          select 1
          from pre.tmemoria_calculo m
          where m.id_partida = v_id_partida and
                m.id_concepto_ingas = v_id_conceto_ingas and
                m.id_presupuesto = v_id_presupuesto and
                m.estado_reg = 'activo') THEN

          insert into pre.tmemoria_calculo(id_concepto_ingas, importe_total, obs, id_presupuesto, estado_reg, fecha_reg, id_partida, id_usuario_reg)
          values (v_id_conceto_ingas, v_total_memoria, 'migrado', v_id_presupuesto, 'activo', now(), v_id_partida, 1)
          RETURNING id_memoria_calculo into v_id_memoria_calculo;
          
          update pre.tformulacion_tmp
          set id_memoria_calculo = v_id_memoria_calculo, migrado = 'si'
          where id = v_registros.id_formulacion_tmp;

          raise notice 'se inserto nueva memoria de calculo importe %, partida %, presupeusto %', v_total_memoria, v_id_partida, v_registros.codigo_presupuesto;

          v_contador = 1;
          -- inserta valores para todos los periodos de la gestion con valor 0
          FOR v_registros_per in (
          select per.id_periodo
          from param.tperiodo per
          where per.id_gestion = v_id_gestion and per.estado_reg = 'activo' order by per.fecha_ini)
          LOOP
            if v_contador = 1 then
              v_aux = v_registros.m1;
            elseif   v_contador = 2 then
              v_aux =  v_registros.m2;
            elseif   v_contador = 3 then
              v_aux =  v_registros.m3;
            elseif   v_contador = 4 then
              v_aux =  v_registros.m4;
            elseif   v_contador = 5 then
              v_aux =  v_registros.m5;
            elseif   v_contador = 6 then
              v_aux =  v_registros.m6;
            elseif   v_contador = 7 then
              v_aux =  v_registros.m7;
            elseif   v_contador = 8 then
              v_aux =  v_registros.m8;
            elseif   v_contador = 9 then
              v_aux =  v_registros.m9;
            elseif   v_contador = 10 then
              v_aux =  v_registros.m10;
            elseif   v_contador = 11 then
              v_aux =  v_registros.m11;
            else
              v_aux =  v_registros.m12;
            end if;
            insert into pre.tmemoria_det(importe, importe_unitario, estado_reg, id_periodo, id_memoria_calculo, fecha_reg, id_usuario_reg)
            values (v_aux, v_aux, 'activo', v_registros_per.id_periodo, v_id_memoria_calculo, now(), 1);

            v_contador = v_contador +1;
          END LOOP;

        ELSE
          raise exception 'en teoría no debería entrar aquí';
          --raise notice 'LA meoria ya existe y el presupeusto no fue migrado, importe %, partida %, presupeusto %',v_total_memoria, v_registros.partida, v_registros.codigo_presupuesto;
          --sumamos al presupuesto existente
          insert into pre.tmemoria_calculo(id_concepto_ingas, importe_total, obs, id_presupuesto, estado_reg, fecha_reg, id_partida, id_usuario_reg)
          values (v_id_conceto_ingas, v_total_memoria, 'migrado', v_id_presupuesto, 'activo', now(), v_id_partida, 1)
          RETURNING id_memoria_calculo into v_id_memoria_calculo;
          
          update pre.tformulacion_tmp
          set id_memoria_calculo = v_id_memoria_calculo, obs = 'ya esxistia una memoria para la misma partida y presupeusto', migrado = 'si'
          where id = v_registros.id_formulacion_tmp;

          raise notice 'se inserto nueva memoria de calculo importe %, partida %, presupeusto %', v_total_memoria, v_registros.partida, v_registros.codigo_presupuesto;

          v_contador = 1;
          -- inserta valores para todos los periodos de la gestion con valor 0
          FOR v_registros_per in (
          select per.id_periodo
          from param.tperiodo per
          where per.id_gestion = v_id_gestion and
                per.estado_reg = 'activo'
          order by per.fecha_ini)
          LOOP

            if v_contador = 1 then
              v_aux = v_registros.m1;
              elseif   v_contador = 2 then
              v_aux =  v_registros.m2;
              elseif   v_contador = 3 then
              v_aux =  v_registros.m3;
              elseif   v_contador = 4 then
              v_aux =  v_registros.m4;
              elseif   v_contador = 5 then
              v_aux =  v_registros.m5;
              elseif   v_contador = 6 then
              v_aux =  v_registros.m6;
              elseif   v_contador = 7 then
              v_aux =  v_registros.m7;
              elseif   v_contador = 8 then
              v_aux =  v_registros.m8;
              elseif   v_contador = 9 then
              v_aux =  v_registros.m9;
              elseif   v_contador = 10 then
              v_aux =  v_registros.m10;
              elseif   v_contador = 11 then
              v_aux =  v_registros.m11;
              else
              v_aux =  v_registros.m12;
            end if;
            insert into pre.tmemoria_det(importe, importe_unitario, estado_reg,
              id_periodo, id_memoria_calculo, fecha_reg, id_usuario_reg)
            values (v_aux, v_aux, 'activo', v_registros_per.id_periodo,
              v_id_memoria_calculo, now(), 1);

            v_contador = v_contador +1;

          END LOOP;

        END IF;

      END IF; --fin revision partida nula

    END IF;  --else de presupeustos


  END LOOP;
--  raise exception 'terminó';
  return 'exito';
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;