--------------- SQL ---------------

CREATE OR REPLACE FUNCTION pre.f_migrar_presupuesto_partidas_proys (
)
RETURNS boolean AS
$body$
DECLARE
  v_resp varchar;
  v_id_presup_partida integer;

  v_rpre record;
  v_rpartidas record;
  v_rpar INTEGER[];
  v_l11 INTEGER[];
  v_l25 INTEGER[];
  v_s10 INTEGER[];
  v_s11 INTEGER[];
  v_s21 INTEGER[];
  v_a10 INTEGER[];
  v_a20 INTEGER[];
  v_a30 INTEGER[];
  v_a40 INTEGER[];
  v_a50 INTEGER[];
  

BEGIN

  --RELACIÓN PRESUPUESTO CON PARTIDAS
  
  v_l11 = array[84102,84103,84104,84105,84106,84107,84108];
  v_l25 = array[84110,84111];
  v_s10 = array[84200];
  v_s11 = array[84201,84202,84205,84206,84207,84208,84204,84203,84212,84213,84214,84215,84216,84301,84302,84303,84304,84305,84306,84209,84102,84107,84217,84218,84219,84210];
  v_s21 = array[84221,84222,84223,84224];
  v_a10 = array[61000,65500,62000,65100,65300,65400,65200,65600,65700,64000,65900,65800,65000,66000,67000];
  v_a20 = array[61000,65500,62000,65100,65300,65400,65200,65600,65700,64000,65900,65800,65000,66000,68000];
  v_a30 = array[61000,65500,62000,65100,65300,65400,65200,65600,65700,64000,65900,65800,65000,66000];
  v_a40 = array[61000,65500,62000,65100,65300,65400,65200,65600,65700,64000,65900,65800,65000,66000];
  v_a50 = array[84401,84402,84403,84406,84407,84409];
  
  raise notice 'RELACIÓN PRESUPUESTO CON PARTIDAS';
  for v_rpre in (
    select p.id_presupuesto, p.descripcion
    from pre.tpresupuesto p
    join param.tcentro_costo cc on cc.id_centro_costo=p.id_centro_costo
    where cc.id_gestion=2 and p.descripcion ~ 'P\d\d.*'
    order by p.descripcion)
  LOOP
    raise notice 'presupuesto %', v_rpre.descripcion;
    
    if upper(v_rpre.descripcion) ~ 'P\d\d\d?L11.+' then
      v_rpar = v_l11;
    elsif upper(v_rpre.descripcion) ~ 'P\d\d\d?L25.+' then
      v_rpar = v_l25;
    elsif upper(v_rpre.descripcion) ~ 'P\d\d\d?S10.+' then
      v_rpar = v_s10;
    elsif upper(v_rpre.descripcion) ~ 'P\d\d\d?S11.+' then
      v_rpar = v_s11;
    elsif upper(v_rpre.descripcion) ~ 'P\d\d\d?S21.+' then
      v_rpar = v_s21;
    elsif upper(v_rpre.descripcion) ~ 'P\d\d\d?A10.+' then
      v_rpar = v_a10;
    elsif upper(v_rpre.descripcion) ~ 'P\d\d\d?A20.+' then
      v_rpar = v_a20;
    elsif upper(v_rpre.descripcion) ~ 'P\d\d\d?A30.+' then
      v_rpar = v_a30;
    elsif upper(v_rpre.descripcion) ~ 'P\d\d\d?A40.+' then
      v_rpar = v_a40;
    elsif upper(v_rpre.descripcion) ~ 'P\d\d\d?A50.+' then
      v_rpar = v_a50;
    end if;
    
    for i in 1 .. array_upper(v_rpar, 1)
    LOOP
      select p.id_partida, p.codigo
      into v_rpartidas
      from pre.tpartida p
      where p.codigo = v_rpar[i]::varchar and p.id_gestion=2;
      IF not exists(
        select 1
        from pre.tpresup_partida pp
        where pp.id_partida = v_rpartidas.id_partida and
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
              v_rpartidas.id_partida,
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
        
      else
        raise notice '     no se insertó partida %', v_rpartidas.codigo;
      END IF;
    END LOOP;
  END LOOP;
  raise exception 'terminó todo ok (comentar esta línea para correr en limpio)';
  return 'exito';
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;