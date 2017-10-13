CREATE OR REPLACE FUNCTION pre.ft_objetivo_partida_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Presupuesto
 FUNCION: 		pre.ft_objetivo_partida_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'pre.tobjetivo_partida'
 AUTOR: 		 (franklin.espinoza)
 FECHA:	        24-07-2017 13:34:28
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
    v_ids_objetivos     varchar;

BEGIN

	v_nombre_funcion = 'pre.ft_objetivo_partida_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'PRE_OBJ_PART_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		franklin.espinoza
 	#FECHA:		24-07-2017 13:34:28
	***********************************/

	if(p_transaccion='PRE_OBJ_PART_SEL')then

    	begin

    		--Sentencia de la consulta
			v_consulta:='select
						obj_part.id_objetivo_partida,
						obj_part.id_objetivo,
						obj_part.estado_reg,
						obj_part.id_partida,
						obj_part.id_usuario_reg,
						obj_part.usuario_ai,
						obj_part.fecha_reg,
						obj_part.id_usuario_ai,
						obj_part.fecha_mod,
						obj_part.id_usuario_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
            (''''(''''||tpar.codigo||'''') - ''''|| tpar.nombre_partida)::varchar as desc_partida,
            tg.gestion::varchar as desc_gestion	,
            obj_part.estado as tipo_reg
						from pre.tobjetivo_partida obj_part
						inner join segu.tusuario usu1 on usu1.id_usuario = obj_part.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = obj_part.id_usuario_mod
                        INNER JOIN pre.tpartida tpar ON tpar.id_partida = obj_part.id_partida
                        INNER JOIN param.tgestion tg ON tg.id_gestion = tpar.id_gestion
                        INNER JOIN pre.tobjetivo tobj ON tobj.id_objetivo = obj_part.id_objetivo
				        where  obj_part.id_objetivo='||v_parametros.id_objetivo||' AND ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'PRE_OBJ_PART_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		24-07-2017 13:34:28
	***********************************/

	elsif(p_transaccion='PRE_OBJ_PART_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_objetivo_partida)
					    from pre.tobjetivo_partida obj_part
					    inner join segu.tusuario usu1 on usu1.id_usuario = obj_part.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = obj_part.id_usuario_mod
                        INNER JOIN pre.tpartida tpar ON tpar.id_partida = obj_part.id_partida
                        INNER JOIN param.tgestion tg ON tg.id_gestion = tpar.id_gestion
                        INNER JOIN pre.tobjetivo tobj ON tobj.id_objetivo = obj_part.id_objetivo
					    where obj_part.id_objetivo='||v_parametros.id_objetivo||' AND ';

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