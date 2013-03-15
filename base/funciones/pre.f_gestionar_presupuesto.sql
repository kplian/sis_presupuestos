CREATE OR REPLACE FUNCTION pre.f_gestionar_presupuesto (
  p_id_presupuesto integer,
  p_id_partida integer,
  p_id_moneda integer,
  p_monto_total numeric,
  p_fecha date,
  p_sw_momento numeric
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Presupuestos
 FUNCION: 		pre.f_gestionar_presupuesto
 DESCRIPCION:   Funcion que llama a la funcion presto.f_i_pr_gestionarpresupuesto mediante dblink
 AUTOR: 		Gonzalo Sarmiento Sejas
 FECHA:	        15-03-2013
 COMENTARIOS:	
***************************************************************************/


DECLARE
  resultado record;
  v_consulta varchar;
  v_conexion varchar;
  v_resp	varchar;
BEGIN
v_conexion:=migra.f_obtener_cadena_conexion();
v_consulta:='select presto."f_i_pr_gestionarpresupuesto" ('||p_id_presupuesto||','||p_id_partida||','||p_id_moneda||','||p_monto_total||','''||p_fecha||''',NULL,'||p_sw_momento||',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ';
select * into resultado from dblink(v_conexion,v_consulta,false) as (res numeric[]);
if resultado is not null then
	v_resp='true';
else
	v_resp='false';
end if;
return v_resp;
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;