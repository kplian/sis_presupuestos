CREATE OR REPLACE FUNCTION pre.f_migrar_presupuesto_iniciatra (
)
RETURNS boolean AS
$body$
DECLARE
  v_tabla varchar;
  v_params VARCHAR [ ];
  v_resp varchar;

  v_registros record;
  v_registros_par record;
  v_id_tipo_estado integer;
  v_id_estado_actual integer;
  v_id_proceso_wf integer;
  v_id_estado_wf integer;

BEGIN

  for v_registros in (
  select p.id_presupuesto
  from pre.tpresupuesto p
  join param.tcentro_costo cc on cc.id_centro_costo=p.id_centro_costo
  where p.estado = 'borrador' and cc.id_gestion=2 and nro_tramite is null)
  LOOP
  
    --obntemos el presupeusto correpondiente para la gestion
    v_tabla = pxp.f_crear_parametro(ARRAY['id_presupuesto','id_funcionario_usu','_id_usuario_ai','_nombre_usuario_ai'],
      ARRAY[v_registros.id_presupuesto::varchar,--id_presupuesto
      '301'::varchar,--id_funcionario_usu
      ''::varchar,
      ''::varchar
      ],
      ARRAY['int4','int4','int4','varchar']
    );
    --Insertamos el registro
    v_resp = pre.ft_presupuesto_ime(1, 1, v_tabla, 'PRE_INITRA_IME');
    select p.id_proceso_wf, p.id_estado_wf
    into v_id_proceso_wf, v_id_estado_wf
    from pre.tpresupuesto p
    where p.id_presupuesto=v_registros.id_presupuesto;
    
    --lista los presupeustos partidas
    FOR v_registros_par in   ( select
                               pp.id_presup_partida,
                               pp.importe,
                               pp.importe_aprobado
                            from pre.tpresup_partida pp
                            where pp.id_presupuesto = v_registros.id_presupuesto) LOOP
           update pre.tpresup_partida pp set
              importe_aprobado = importe
           where pp.id_presup_partida  = v_registros_par.id_presup_partida;
    END LOOP;
    
    
    
    select
      te.id_tipo_estado
    into
      v_id_tipo_estado
    from wf.tproceso_wf pw
    inner join wf.ttipo_proceso tp on pw.id_tipo_proceso =
      tp.id_tipo_proceso
    inner join wf.ttipo_estado te on te.id_tipo_proceso =
      tp.id_tipo_proceso and te.codigo = 'aprobado'
    where pw.id_proceso_wf = v_id_proceso_wf;
                     
   IF v_id_tipo_estado is NULL THEN
      raise exception
        'El estado vbcajero para la solicitud de efectivo no esta parametrizado en el workflow'
        ;
   END IF;
  
   v_id_estado_actual =  wf.f_registra_estado_wf(v_id_tipo_estado,
                                               301,
                                               v_id_estado_wf,
                                               v_id_proceso_wf,
                                               1,
                                               NULL,
                                               NULL,
                                               NULL,
                                               'MIGRADO'
                                                 );


       -- actualiza estado en solicitud de efectivo
    update pre.tpresupuesto
    set id_estado_wf = v_id_estado_actual,
        estado = 'aprobado',
        estado_reg = 'activo'
    where id_presupuesto = v_registros.id_presupuesto;
    
    

  END LOOP;
  raise exception 'terminó todo ok (comentar esta línea para correr en limpio)';
  return true;
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;