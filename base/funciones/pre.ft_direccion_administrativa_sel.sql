CREATE OR REPLACE FUNCTION pre.ft_direccion_administrativa_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Presupuesto
 FUNCION: 		pre.ft_direccion_administrativa_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'pre.tdireccion_administrativa'
 AUTOR: 		 (franklin.espinoza)
 FECHA:	        21-07-2017 13:40:32
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

	v_nombre_funcion = 'pre.ft_direccion_administrativa_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'PRE_DIR_ADM_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		franklin.espinoza
 	#FECHA:		21-07-2017 13:40:32
	***********************************/

	if(p_transaccion='PRE_DIR_ADM_SEL')then

    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						dir_adm.id_direccion_administrativa,
						dir_adm.id_gestion,
						dir_adm.estado_reg,
						dir_adm.codigo,
						dir_adm.nombre,
						dir_adm.usuario_ai,
						dir_adm.fecha_reg,
						dir_adm.id_usuario_reg,
						dir_adm.id_usuario_ai,
						dir_adm.fecha_mod,
						dir_adm.id_usuario_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
                        tg.gestion::VARCHAR
						from pre.tdireccion_administrativa dir_adm
						inner join segu.tusuario usu1 on usu1.id_usuario = dir_adm.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = dir_adm.id_usuario_mod
                        INNER JOIN param.tgestion tg ON tg.id_gestion = dir_adm.id_gestion
				        where  ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'PRE_DIR_ADM_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		21-07-2017 13:40:32
	***********************************/

	elsif(p_transaccion='PRE_DIR_ADM_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_direccion_administrativa)
					    from pre.tdireccion_administrativa dir_adm
					    inner join segu.tusuario usu1 on usu1.id_usuario = dir_adm.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = dir_adm.id_usuario_mod
                        INNER JOIN param.tgestion tg ON tg.id_gestion = dir_adm.id_gestion
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