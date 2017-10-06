CREATE OR REPLACE FUNCTION pre.f_consulta_concepto_ingas (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Presupuestos
 FUNCION: 		pre.f_consulta_concepto_ingas
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'pre.f_consulta_concepto_ingas'
 AUTOR: 		 (f.e.a)
 FECHA:	        29-09-2017 19:49:23
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:
 AUTOR:
 FECHA:
***************************************************************************/

DECLARE

	v_consulta    			varchar;
	v_parametros  			record;
	v_nombre_funcion   		text;
	v_resp					varchar;
    v_filtro 				varchar;
    v_autorizacion_nulos	varchar;
BEGIN

	v_nombre_funcion = 'param.f_consulta_concepto_ingas';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'PRE_CON_INGAS_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:	    f.e.a
 	#FECHA:		29-09-2017 19:49:23
	***********************************/

	if(p_transaccion='PRE_CON_INGAS_SEL')then

    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						conig.id_concepto_ingas,
						conig.desc_ingas,
						conig.tipo,
						conig.movimiento,
                        conig.sw_tes,
						conig.id_oec,
						conig.estado_reg,
						conig.id_usuario_reg,
						conig.fecha_reg,
						conig.fecha_mod,
						conig.id_usuario_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
						conig.activo_fijo,
						conig.almacenable,
                        array_to_string( conig.id_grupo_ots,'','',''null'')::varchar,
                        conig.filtro_ot,
                        conig.requiere_ot,
                        array_to_string( conig.sw_autorizacion, '','',''null'')::varchar,
                        conig.id_entidad,
                        conig.descripcion_larga,
                        conig.id_unidad_medida,
                        um.codigo as  desc_unidad_medida,
                        conig.nandina,
                        COALESCE(conig.ruta_foto,'''')::Varchar as ruta_foto,
                        conig.id_cat_concepto,
                        (cc.codigo ||'' - ''||cc.nombre)::varchar as desc_cat_concepto,
						(tpar.codigo||''-''||tpar.nombre_partida)::varchar as desc_partida,
                        (case when ''caja_chica'' = ANY (conig.sw_autorizacion) then ''caja_chica'' else ''X'' end)::varchar as caja_chica,
                        (case when''adquisiciones'' = ANY (conig.sw_autorizacion) then ''adquisiciones'' else ''X'' end)::varchar as adquisiciones,
                        (case when''pago_directo'' = ANY (conig.sw_autorizacion) then ''pago_directo'' else ''X'' end)::varchar as pago_directo,
                        (case when''fondo_avance'' = ANY (conig.sw_autorizacion) then ''fondo_avance'' else ''X'' end)::varchar as fondo_avance,
                        (case when''pago_unico'' = ANY (conig.sw_autorizacion) then ''pago_unico'' else ''X'' end)::varchar as pago_unico,
                        (case when''contrato'' = ANY (conig.sw_autorizacion) then ''contrato'' else ''X'' end)::varchar as contrato,
                        (case when''especial'' = ANY (conig.sw_autorizacion) then ''especial'' else ''X'' end)::varchar as especial
                        from param.tconcepto_ingas conig
						inner join segu.tusuario usu1 on usu1.id_usuario = conig.id_usuario_reg
                        left join param.tunidad_medida um on um.id_unidad_medida = conig.id_unidad_medida
						left join segu.tusuario usu2 on usu2.id_usuario = conig.id_usuario_mod
                        left join param.tcat_concepto cc on cc.id_cat_concepto = conig.id_cat_concepto
                        left join pre.tconcepto_partida tcp on tcp.id_concepto_ingas = conig.id_concepto_ingas
                        left join pre.tpartida tpar on tpar.id_partida = tcp.id_partida
				        where conig.estado_reg = ''activo''  and ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
            RAISE NOTICE 'v_consulta: %', v_consulta;
			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'PRE_CON_INGAS_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		f.e.a
 	#FECHA:		29-09-2017 19:49:23
	***********************************/

	elsif(p_transaccion='PRE_CON_INGAS_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(conig.id_concepto_ingas)
					    from param.tconcepto_ingas conig
						inner join segu.tusuario usu1 on usu1.id_usuario = conig.id_usuario_reg
                        left join param.tunidad_medida um on um.id_unidad_medida = conig.id_unidad_medida
						left join segu.tusuario usu2 on usu2.id_usuario = conig.id_usuario_mod
                        left join param.tcat_concepto cc on cc.id_cat_concepto = conig.id_cat_concepto
                        left join pre.tconcepto_partida tcp on tcp.id_concepto_ingas = conig.id_concepto_ingas
                        left join pre.tpartida tpar on tpar.id_partida = tcp.id_partida
				        where conig.estado_reg = ''activo'' and ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;

			--Devuelve la respuesta
			return v_consulta;

		end;
    /*********************************
 	#TRANSACCION:  'PRE_CON_INGAS_REP'
 	#DESCRIPCION:   Reporte Concepto de Ingresos y Gastos.
 	#AUTOR:	    f.e.a
 	#FECHA:		29-09-2017 19:49:23
	***********************************/

	elsif(p_transaccion='PRE_CON_INGAS_REP')then

    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						conig.id_concepto_ingas,
						conig.desc_ingas,
						conig.tipo,
                        array_to_string( conig.sw_autorizacion, '','',''null'')::varchar,
                        (case when ''caja_chica'' = ANY (conig.sw_autorizacion) then ''caja_chica'' else ''X'' end)::varchar as caja_chica,
                        (case when''adquisiciones'' = ANY (conig.sw_autorizacion) then ''adquisiciones'' else ''X'' end)::varchar as adquisiciones,
                        (case when''pago_directo'' = ANY (conig.sw_autorizacion) then ''pago_directo'' else ''X'' end)::varchar as pago_directo,
                        (case when''fondo_avance'' = ANY (conig.sw_autorizacion) then ''fondo_avance'' else ''X'' end)::varchar as fondo_avance,
                        (case when''pago_unico'' = ANY (conig.sw_autorizacion) then ''pago_unico'' else ''X'' end)::varchar as pago_unico,
                        (case when''contrato'' = ANY (conig.sw_autorizacion) then ''contrato'' else ''X'' end)::varchar as contrato,
                        (case when''especial'' = ANY (conig.sw_autorizacion) then ''especial'' else ''X'' end)::varchar as especial,
						(tpar.codigo||''-''||tpar.nombre_partida)::varchar as desc_partida
                        from param.tconcepto_ingas conig
                        LEFT join pre.tconcepto_partida tcp on tcp.id_concepto_ingas = conig.id_concepto_ingas
                        LEFT join pre.tpartida tpar on tpar.id_partida = tcp.id_partida
				        where conig.estado_reg = ''activo'' and tpar.id_gestion = '||v_parametros.id_gestion||' order by conig.desc_ingas';

            RAISE NOTICE 'v_consulta: %', v_consulta;
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