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
#0				17-12-2018 19:20:26								Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'pre.tpresupuesto_ids'
#4				 03/01/2019	            Miguel Mamani			Relación por gestiones paridas y presupuesto e reporte de presupuesto que no figuran en gestión nueva

 ***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;
    v_record			record; --#4

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

    /*********************************
 	#TRANSACCION:  'PRE_RPM_SEL'  #4
 	#DESCRIPCION:	Reporte centro costo o presupesto con saldo
 	#AUTOR:		miguel.mamani
 	#FECHA:		17-12-2018 19:20:26
	***********************************/
    elsif(p_transaccion='PRE_RPM_SEL')then

        begin
             CREATE TEMPORARY TABLE tmp_pres (   id_centro_costo integer,
                                                 codigo_tcc varchar,
                                                 descripcion_tcc varchar,
                                                 saldo_mb numeric )ON COMMIT DROP;

        	FOR v_record in ( with centro_costo as (select 	t.id_centro_costo,
                                cc.codigo_tcc,
                                cc.descripcion_tcc,
                                t.importe_debe_mb,
                                t.importe_haber_mb
                              from conta.tint_transaccion t
                              inner join conta.tint_comprobante cb on cb.id_int_comprobante = t.id_int_comprobante
                              inner join param.vcentro_costo cc on cc.id_centro_costo = t.id_centro_costo
                              inner join param.tperiodo pe on pe.id_periodo = cb.id_periodo
                              and pe.id_gestion = v_parametros.id_gestion)
                     select  cc.id_centro_costo,
                             cc.codigo_tcc,
                             cc.descripcion_tcc,
                             sum(cc.importe_debe_mb) - sum(cc.importe_haber_mb) as saldo_mb
                       from  centro_costo cc
                       group by cc.id_centro_costo,
                                 cc.codigo_tcc,
                                 cc.descripcion_tcc)LOOP

             if(not exists (select 1
                            from pre.tpresupuesto_ids ipe
                            where ipe.id_presupuesto_uno = v_record.id_centro_costo) )then

                            insert into tmp_pres ( 	id_centro_costo,
                                                 	codigo_tcc,
                                                 	descripcion_tcc,
                                                 	saldo_mb)
                                                    values(
                                                    v_record.id_centro_costo,
                                                    v_record.codigo_tcc,
                                                    v_record.descripcion_tcc,
                                                    v_record.saldo_mb
                                                    );

             end if;
            END LOOP;
            v_consulta:='select s.id_centro_costo,
                                s.codigo_tcc,
                                s.descripcion_tcc,
                                s.saldo_mb
                         from tmp_pres s';
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