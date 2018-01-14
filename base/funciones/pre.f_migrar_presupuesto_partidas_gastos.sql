--------------- SQL ---------------

CREATE OR REPLACE FUNCTION pre.f_migrar_presupuesto_partidas_gastos (
)
RETURNS varchar AS
$body$
DECLARE
  v_resp varchar;
  v_id_presup_partida integer;

  v_rpre record;
  v_rpar record;

BEGIN

  --RELACIÓN PRESUPUESTO CON PARTIDAS
  raise notice 'RELACIÓN PRESUPUESTO CON PARTIDAS';
  for v_rpre in (
    select p.id_presupuesto, p.descripcion
    from pre.tpresupuesto p
    join param.tcentro_costo cc on cc.id_centro_costo=p.id_centro_costo
    where p.tipo_pres='2' and cc.id_gestion=2)
  LOOP
    raise notice 'presupuesto %', v_rpre.descripcion;
    for v_rpar in (
    select p.id_partida, p.codigo
    from pre.tpartida p
    where p.tipo = 'gasto' and p.id_gestion=2)
    LOOP
      IF not exists(
        select 1
        from pre.tpresup_partida pp
        where pp.id_partida = v_rpar.id_partida and
              pp.id_presupuesto = v_rpre.id_presupuesto and
              pp.estado_reg = 'activo') THEN
          --Sentencia de la insercion
          insert into pre.tpresup_partida(
              id_partida,
              id_centro_costo,
              id_presupuesto,
              id_usuario_ai,
              usuario_ai,
              estado_reg,
              fecha_reg,
              id_usuario_reg,
              id_usuario_mod,
              fecha_mod
          ) values(
              v_rpar.id_partida,
              v_rpre.id_presupuesto,
              v_rpre.id_presupuesto,
              null,
              null,
              'activo',
              now(),
              1,
              null,
              null
			  )RETURNING id_presup_partida into v_id_presup_partida;
        raise notice '     partida %', v_rpar.codigo;
      END IF;
    END LOOP;
  END LOOP;
--  raise exception 'terminó todo ok (comentar esta línea para correr en limpio)';
  return 'exito';
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;