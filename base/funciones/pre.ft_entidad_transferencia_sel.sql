CREATE OR REPLACE FUNCTION pre.ft_entidad_transferencia_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Presupuesto
 FUNCION: 		pre.ft_entidad_transferencia_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'pre.tentidad_transferencia'
 AUTOR: 		 (franklin.espinoza)
 FECHA:	        21-07-2017 12:57:45
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

	v_nombre_funcion = 'pre.ft_entidad_transferencia_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'PRE_ENT_TRAN_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		franklin.espinoza
 	#FECHA:		21-07-2017 12:57:45
	***********************************/

	if(p_transaccion='PRE_ENT_TRAN_SEL')then

    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						ent_tran.id_entidad_transferencia,
						ent_tran.id_gestion,
						ent_tran.estado_reg,
						ent_tran.codigo,
						ent_tran.nombre,
						ent_tran.usuario_ai,
						ent_tran.fecha_reg,
						ent_tran.id_usuario_reg,
						ent_tran.id_usuario_ai,
						ent_tran.id_usuario_mod,
						ent_tran.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
                        tg.gestion::VARCHAR
						from pre.tentidad_transferencia ent_tran
						inner join segu.tusuario usu1 on usu1.id_usuario = ent_tran.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = ent_tran.id_usuario_mod
                        INNER JOIN param.tgestion tg ON tg.id_gestion = ent_tran.id_gestion
				        where  ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'PRE_ENT_TRAN_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		21-07-2017 12:57:45
	***********************************/

	elsif(p_transaccion='PRE_ENT_TRAN_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_entidad_transferencia)
					    from pre.tentidad_transferencia ent_tran
					    inner join segu.tusuario usu1 on usu1.id_usuario = ent_tran.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = ent_tran.id_usuario_mod
                        INNER JOIN param.tgestion tg ON tg.id_gestion = ent_tran.id_gestion
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