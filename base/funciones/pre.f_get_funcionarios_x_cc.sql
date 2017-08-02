CREATE OR REPLACE FUNCTION pre.f_get_funcionarios_x_cc (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		ORGANIGRAMA
 FUNCION: 		pre.f_get_funcionarios_x_cc
 DESCRIPCION:   funcion que retorna los funcionarios de un centro de costo
 AUTOR: 		Gonzalo Sarmiento Sejas
 FECHA:	        15-05-2017
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:
 AUTOR:
 FECHA:
***************************************************************************/

DECLARE
  v_resp		            varchar;
  v_nombre_funcion        	text;
  v_mensaje_error         	text;
  v_parametros				record;
  v_id_uo_cc				integer;
  v_id_unidades				varchar;
  v_id_funcionarios			varchar;
  v_consulta				varchar;
  v_presupuesta				varchar;
BEGIN
  v_nombre_funcion = 'pre.f_get_funcionarios_x_cc';

  v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'PRE_FUNCCC_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		Gonzalo Sarmiento Sejas
 	#FECHA:		15-05-2017
	***********************************/

  if(p_transaccion='PRE_FUNCCC_SEL')then

  select pre.id_uo, uo.presupuesta into v_id_uo_cc, v_presupuesta
  from pre.vpresupuesto_cc pre
  inner join orga.tuo uo on uo.id_uo=pre.id_uo
  where pre.gestion=v_parametros.gestion
  and pre.id_centro_costo = v_parametros.id_cc
  order by pre.id_centro_costo;

  IF v_presupuesta = 'si' THEN
    --v_id_unidades = orga.f_get_uos_x_gerencia(v_id_uo_cc);
    v_id_unidades = orga.f_get_uos_x_presupuesto(v_id_uo_cc,'no');

    v_id_unidades = pxp.concat(v_id_uo_cc::text,v_id_unidades::text);

    select
       pxp.aggarray (asig.id_funcionario)
       into v_id_funcionarios
    from orga.tuo_funcionario asig
    where
           asig.fecha_asignacion <= current_date
       and coalesce(asig.fecha_finalizacion, current_date)>=current_date
       and asig.estado_reg = 'activo'
       and asig.tipo = 'oficial'
       and asig.id_uo = ANY(regexp_split_to_array(v_id_unidades,',')::integer[]);

    v_consulta = 'select id_funcionario
                  from orga.vfuncionario
                  where id_funcionario in ('||v_id_funcionarios||')';

    v_consulta = regexp_replace(v_consulta,'{','');

    v_consulta = regexp_replace(v_consulta,'}','');
  ELSE
  	v_consulta = 'select id_funcionario
                  from orga.vfuncionario
                  where id_funcionario=0';
  END IF;

  return v_consulta;

  /*********************************
 	#TRANSACCION:  'PRE_FUNCCC_CONT'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		Gonzalo Sarmiento Sejas
 	#FECHA:		15-05-2017
	***********************************/

  elsif(p_transaccion='PRE_FUNCCC_CONT')then

  select pre.id_uo, uo.presupuesta into v_id_uo_cc, v_presupuesta
  from pre.vpresupuesto_cc pre
  inner join orga.tuo uo on uo.id_uo=pre.id_uo
  where pre.gestion=v_parametros.gestion
  and pre.id_centro_costo = v_parametros.id_cc
  order by pre.id_centro_costo;

  IF v_presupuesta = 'si' THEN
    v_id_unidades = orga.f_get_uos_x_presupuesto(v_id_uo_cc,'no');

    v_id_unidades = pxp.concat(v_id_uo_cc::text,v_id_unidades::text);

    select
       pxp.aggarray (asig.id_funcionario)
       into v_id_funcionarios
    from orga.tuo_funcionario asig
    where
           asig.fecha_asignacion <= current_date
       and coalesce(asig.fecha_finalizacion, current_date)>=current_date
       and asig.estado_reg = 'activo'
       and asig.tipo = 'oficial'
       and asig.id_uo = ANY(regexp_split_to_array(v_id_unidades,',')::integer[]);

    v_consulta = 'select count(id_funcionario)
                  from orga.vfuncionario
                  where id_funcionario in ('||v_id_funcionarios||')';

    v_consulta = regexp_replace(v_consulta,'{','');

    v_consulta = regexp_replace(v_consulta,'}','');
  ELSE
  	v_consulta = 'select count(id_funcionario)
                  from orga.vfuncionario
                  where id_funcionario=0';
  END IF;

  return v_consulta;


  else

	raise exception 'Transaccion inexistente';

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
COST 100;