CREATE OR REPLACE FUNCTION pre.ft_unidad_ejecutora_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Presupuesto
 FUNCION: 		pre.ft_unidad_ejecutora_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'pre.tunidad_ejecutora'
 AUTOR: 		 (franklin.espinoza)
 FECHA:	        21-07-2017 13:41:05
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

	v_nombre_funcion = 'pre.ft_unidad_ejecutora_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'PRE_UND_EJE_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		franklin.espinoza
 	#FECHA:		21-07-2017 13:41:05
	***********************************/

	if(p_transaccion='PRE_UND_EJE_SEL')then

    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						und_eje.id_unidad_ejecutora,
						und_eje.id_gestion,
						und_eje.nombre,
						und_eje.codigo,
						und_eje.estado_reg,
						und_eje.id_usuario_ai,
						und_eje.fecha_reg,
						und_eje.usuario_ai,
						und_eje.id_usuario_reg,
						und_eje.fecha_mod,
						und_eje.id_usuario_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
                        tg.gestion::VARCHAR
						from pre.tunidad_ejecutora und_eje
						inner join segu.tusuario usu1 on usu1.id_usuario = und_eje.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = und_eje.id_usuario_mod
                        INNER JOIN param.tgestion tg ON tg.id_gestion = und_eje.id_gestion
				        where  ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'PRE_UND_EJE_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		21-07-2017 13:41:05
	***********************************/

	elsif(p_transaccion='PRE_UND_EJE_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_unidad_ejecutora)
					    from pre.tunidad_ejecutora und_eje
					    inner join segu.tusuario usu1 on usu1.id_usuario = und_eje.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = und_eje.id_usuario_mod
                        INNER JOIN param.tgestion tg ON tg.id_gestion = und_eje.id_gestion
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