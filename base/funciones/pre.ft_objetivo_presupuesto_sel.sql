CREATE OR REPLACE FUNCTION pre.ft_objetivo_presupuesto_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Presupuesto
 FUNCION: 		pre.ft_objetivo_presupuesto_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'pre.tobjetivo_presupuesto'
 AUTOR: 		 (franklin.espinoza)
 FECHA:	        27-07-2017 16:10:48
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

	v_nombre_funcion = 'pre.ft_objetivo_presupuesto_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'PRE_OBJ_PRES_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		franklin.espinoza
 	#FECHA:		27-07-2017 16:10:48
	***********************************/

	if(p_transaccion='PRE_OBJ_PRES_SEL')then

    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						obj_pres.id_objetivo_presupuesto,
						obj_pres.id_objetivo,
						obj_pres.estado_reg,
						obj_pres.id_presupuesto,
						obj_pres.id_usuario_reg,
						obj_pres.fecha_reg,
						obj_pres.usuario_ai,
						obj_pres.id_usuario_ai,
						obj_pres.fecha_mod,
						obj_pres.id_usuario_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
                        tpre.descripcion AS desc_presupuesto,
                        obj_pres.estado as tipo_reg
						from pre.tobjetivo_presupuesto obj_pres
						inner join segu.tusuario usu1 on usu1.id_usuario = obj_pres.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = obj_pres.id_usuario_mod
                        INNER JOIN pre.tpresupuesto tpre ON tpre.id_presupuesto = obj_pres.id_presupuesto
                        INNER JOIN pre.tobjetivo tobj ON tobj.id_objetivo = obj_pres.id_objetivo
				        where  obj_pres.id_objetivo='||v_parametros.id_objetivo||' AND ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'PRE_OBJ_PRES_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		27-07-2017 16:10:48
	***********************************/

	elsif(p_transaccion='PRE_OBJ_PRES_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_objetivo_presupuesto)
					    from pre.tobjetivo_presupuesto obj_pres
					    inner join segu.tusuario usu1 on usu1.id_usuario = obj_pres.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = obj_pres.id_usuario_mod
                        INNER JOIN pre.tpresupuesto tpre ON tpre.id_presupuesto = obj_pres.id_presupuesto
                        INNER JOIN pre.tobjetivo tobj ON tobj.id_objetivo = obj_pres.id_objetivo
					    where obj_pres.id_objetivo='||v_parametros.id_objetivo||' AND ';

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