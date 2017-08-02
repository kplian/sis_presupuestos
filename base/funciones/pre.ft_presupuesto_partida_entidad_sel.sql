CREATE OR REPLACE FUNCTION pre.ft_presupuesto_partida_entidad_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Presupuesto
 FUNCION: 		pre.ft_presupuesto_partida_entidad_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'pre.tpresupuesto_partida_entidad'
 AUTOR: 		 (franklin.espinoza)
 FECHA:	        21-07-2017 12:58:43
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:
 AUTOR:
 FECHA:
***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;

BEGIN

	v_nombre_funcion = 'pre.ft_presupuesto_partida_entidad_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'PRE_P_P_ENT_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		franklin.espinoza
 	#FECHA:		21-07-2017 12:58:43
	***********************************/

	if(p_transaccion='PRE_P_P_ENT_SEL')then

    	begin

    		--Sentencia de la consulta
			v_consulta:='select
						p_p_ent.id_presupuesto_partida_entidad,
						p_p_ent.id_partida,
						p_p_ent.id_gestion,
						p_p_ent.id_entidad_transferencia,
						p_p_ent.estado_reg,
						p_p_ent.id_presupuesto,
						p_p_ent.id_usuario_ai,
						p_p_ent.id_usuario_reg,
						p_p_ent.usuario_ai,
						p_p_ent.fecha_reg,
						p_p_ent.id_usuario_mod,
						p_p_ent.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
                        (''[''||tpar.codigo||''] - ''|| tpar.nombre_partida)::varchar as desc_partida,
                        ges.gestion::varchar as desc_gestion,
                        (''[''||te.codigo||''] - '' || te.nombre)::varchar AS desc_entidad_tranferencia,
                        tpre.descripcion AS desc_presupuesto
						from pre.tpresupuesto_partida_entidad p_p_ent
						inner join segu.tusuario usu1 on usu1.id_usuario = p_p_ent.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = p_p_ent.id_usuario_mod
                        INNER JOIN pre.tpartida tpar ON tpar.id_partida = p_p_ent.id_partida
                        inner join param.tgestion ges on ges.id_gestion = p_p_ent.id_gestion
                        INNER JOIN pre.tentidad_transferencia te ON te.id_entidad_transferencia	= p_p_ent.id_entidad_transferencia
                        INNER JOIN pre.tpresupuesto tpre ON tpre.id_presupuesto = p_p_ent.id_presupuesto
				        where  ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'PRE_P_P_ENT_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		21-07-2017 12:58:43
	***********************************/

	elsif(p_transaccion='PRE_P_P_ENT_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_presupuesto_partida_entidad)
					    from pre.tpresupuesto_partida_entidad p_p_ent
					    inner join segu.tusuario usu1 on usu1.id_usuario = p_p_ent.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = p_p_ent.id_usuario_mod
                        INNER JOIN pre.tpartida tpar ON tpar.id_partida = p_p_ent.id_partida
                        inner join param.tgestion ges on ges.id_gestion = p_p_ent.id_gestion
                        INNER JOIN pre.tentidad_transferencia te ON te.id_entidad_transferencia	= p_p_ent.id_entidad_transferencia
                        INNER JOIN pre.tpresupuesto tpre ON tpre.id_presupuesto = p_p_ent.id_presupuesto
					    where ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;

			--Devuelve la respuesta
			return v_consulta;

		end;

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