CREATE OR REPLACE FUNCTION pre.ft_partida_ids_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de presupuesto
 FUNCION: 		pre.ft_partida_ids_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'pre.tpartida_ids'
 AUTOR: 		 (miguel.mamani)
 FECHA:	        17-12-2018 19:20:23
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #2			 20/12/2018	Miguel Mamani			Replicación de partidas y presupuestos
 #
 ***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;

BEGIN

	v_nombre_funcion = 'pre.ft_partida_ids_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'PRE_RPS_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		miguel.mamani
 	#FECHA:		17-12-2018 19:20:23
	***********************************/

	if(p_transaccion='PRE_RPS_SEL')then

    	begin
    		--Sentencia de la consulta
			v_consulta:='with gestios_sig as (select  rps.id_partida_dos,
                              par1.codigo,
                              par1.nombre_partida,
                              ges1.gestion
                      from pre.tpartida_ids rps
                      inner join segu.tusuario usu1 on usu1.id_usuario = rps.id_usuario_reg
                      inner join pre.tpartida par1 on par1.id_partida = rps.id_partida_dos
                      inner join param.tgestion ges1 on ges1.id_gestion = par1.id_gestion
                      where ges1.id_gestion = ' || v_parametros.id_gestion + 1 || ' and rps.estado_reg = ''activo''),
                    gestios_act as (select  rps.id_partida_uno,
                                                  par1.codigo,
                                                  par1.nombre_partida,
                                                  ges1.gestion,
                                                  rps.sw_cambio_gestion,
                                                  rps.insercion,
                                                  rps.estado_reg,
                                                  rps.id_usuario_reg,
                                                  rps.fecha_reg,
                                                  usu1.cuenta as usr_reg
                                          from pre.tpartida_ids rps
                                          inner join segu.tusuario usu1 on usu1.id_usuario = rps.id_usuario_reg
                                          inner join pre.tpartida par1 on par1.id_partida = rps.id_partida_uno
                                          inner join param.tgestion ges1 on ges1.id_gestion = par1.id_gestion
                                          where ges1.id_gestion =' || v_parametros.id_gestion || ' and rps.estado_reg = ''activo'')
                                  select 	ga.id_partida_uno,
                                          gs.id_partida_dos,
                                          ga.codigo,
                                          ga.nombre_partida,
                                          ga.gestion,
                                          COALESCE(gs.codigo,''0'') as codigo_dos,
                                          gs.nombre_partida as nombre_partida_dos,
                                          gs.gestion as gestion_dos,
                                          ga.sw_cambio_gestion,
                                          ga.insercion,
                                          ga.estado_reg,
                                          ga.id_usuario_reg,
                                          ga.fecha_reg,
                                          ga.usr_reg,
                                          case
                                            when ga.nombre_partida != gs.nombre_partida then
                                            ''no coincide el nombre''
                                        	end::varchar as validar
                                  from gestios_act ga
                                  left join gestios_sig gs on gs.codigo = ga.codigo
                                  where  ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'PRE_RPS_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		miguel.mamani
 	#FECHA:		17-12-2018 19:20:23
	***********************************/

	elsif(p_transaccion='PRE_RPS_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='with gestios_sig as (select  rps.id_partida_dos,
                             					 par1.codigo,
                                              par1.nombre_partida,
                                              ges1.gestion
                                      from pre.tpartida_ids rps
                                      inner join segu.tusuario usu1 on usu1.id_usuario = rps.id_usuario_reg
                                      inner join pre.tpartida par1 on par1.id_partida = rps.id_partida_dos
                                      inner join param.tgestion ges1 on ges1.id_gestion = par1.id_gestion
                                      where ges1.id_gestion = ' || v_parametros.id_gestion + 1 || ' and rps.estado_reg = ''activo''),
                      gestios_act as (select  rps.id_partida_uno,
                                                    par1.codigo,
                                                    par1.nombre_partida,
                                                    ges1.gestion,
                                                    rps.sw_cambio_gestion,
                                                    rps.insercion,
                                                    rps.estado_reg,
                                                    rps.id_usuario_reg,
                                                    rps.fecha_reg,
                                                    usu1.cuenta as usr_reg
                                            from pre.tpartida_ids rps
                                            inner join segu.tusuario usu1 on usu1.id_usuario = rps.id_usuario_reg
                                            inner join pre.tpartida par1 on par1.id_partida = rps.id_partida_uno
                                            inner join param.tgestion ges1 on ges1.id_gestion = par1.id_gestion
                                            where ges1.id_gestion = ' || v_parametros.id_gestion || '  and rps.estado_reg = ''activo''),
                      countx as	(			select 	ga.id_partida_uno,
                                            gs.id_partida_dos,
                                            ga.codigo,
                                            ga.nombre_partida,
                                            ga.gestion,
                                            gs.codigo as codigo_dos,
                                            gs.nombre_partida as nombre_partida_dos,
                                            gs.gestion as gestion_dos,
                                            ga.sw_cambio_gestion,
                                            ga.insercion,
                                            ga.estado_reg,
                                            ga.id_usuario_reg,
                                            ga.fecha_reg,
                                            ga.usr_reg
                                    from gestios_act ga
                                    left join gestios_sig gs on gs.codigo = ga.codigo)
                                    select count(c.id_partida_uno)
                                    from countx c
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