CREATE OR REPLACE FUNCTION pre.ft_presupuesto_ids_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de presupuesto
 FUNCION: 		pre.ft_presupuesto_ids_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'pre.tpresupuesto_ids'
 AUTOR: 		 (miguel.mamani)
 FECHA:	        17-12-2018 19:20:26
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #2				 20/12/2018	Miguel Mamani			Replicación de partidas y presupuestos
 #
 ***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;

BEGIN

	v_nombre_funcion = 'pre.ft_presupuesto_ids_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'PRE_RPP_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		miguel.mamani
 	#FECHA:		17-12-2018 19:20:26
	***********************************/

	if(p_transaccion='PRE_RPP_SEL')then

    	begin
    		--Sentencia de la consulta
			v_consulta:='select 	pi.id_presupuesto_uno,
                                    pi.id_presupuesto_dos,
                                    pr1.id_categoria_prog,
                                    pr2.id_categoria_prog as id_categoria_prog_dos,
                                    pr1.nro_tramite,
                                    pr2.nro_tramite as nro_tramite_dos,
                                    pr1.descripcion,
                                    pr2.descripcion as descripcion_dos,
                                    co1.descripcion_tcc,
                                    co2.descripcion_tcc  as descripcion_tcc_dos,
                                    g1.gestion,
                                    g2.gestion as gestion_dos,
                                    tp1.nombre,
                                    tp2.nombre as nombre_dos,
                                    pi.estado_reg,
                                    pi.id_usuario_reg,
                                    pi.fecha_reg,
                                    usu1.cuenta as usr_reg,
                                    pi.insercion
                            from pre.tpresupuesto_ids pi
                            inner join pre.tpresupuesto pr1 on pr1.id_presupuesto = pi.id_presupuesto_uno
                            inner join param.vcentro_costo co1 on co1.id_centro_costo = pr1.id_centro_costo
                            inner join pre.tpresupuesto pr2 on pr2.id_presupuesto = pi.id_presupuesto_dos
                            inner join param.vcentro_costo co2 on co2.id_centro_costo = pr2.id_centro_costo
                            inner join param.tgestion g1 on g1.id_gestion = co1.id_gestion and g1.id_gestion = ' || v_parametros.id_gestion || '
                            inner join param.tgestion g2 on g2.id_gestion = co2.id_gestion and g2.id_gestion = ' || v_parametros.id_gestion + 1|| '
                            inner join pre.ttipo_presupuesto tp1 on tp1.codigo = pr1.tipo_pres
                            inner join pre.ttipo_presupuesto tp2 on tp2.codigo = pr2.tipo_pres
                            inner join segu.tusuario usu1 on usu1.id_usuario = pi.id_usuario_reg
				        	where  ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'PRE_RPP_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		miguel.mamani
 	#FECHA:		17-12-2018 19:20:26
	***********************************/

	elsif(p_transaccion='PRE_RPP_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select  count(pi.id_presupuesto_uno)
                                from pre.tpresupuesto_ids pi
                                inner join pre.tpresupuesto pr1 on pr1.id_presupuesto = pi.id_presupuesto_uno
                            inner join param.vcentro_costo co1 on co1.id_centro_costo = pr1.id_centro_costo
                            inner join pre.tpresupuesto pr2 on pr2.id_presupuesto = pi.id_presupuesto_dos
                            inner join param.vcentro_costo co2 on co2.id_centro_costo = pr2.id_centro_costo
                            inner join param.tgestion g1 on g1.id_gestion = co1.id_gestion and g1.id_gestion = '|| v_parametros.id_gestion || '
                            inner join param.tgestion g2 on g2.id_gestion = co2.id_gestion and g2.id_gestion = '|| v_parametros.id_gestion + 1|| '
                            inner join pre.ttipo_presupuesto tp1 on tp1.codigo = pr1.tipo_pres
                            inner join pre.ttipo_presupuesto tp2 on tp2.codigo = pr2.tipo_pres
                            inner join segu.tusuario usu1 on usu1.id_usuario = pi.id_usuario_reg
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