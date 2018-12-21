CREATE OR REPLACE FUNCTION pre.ft_presupuesto_ids_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de presupuesto
 FUNCION: 		pre.ft_presupuesto_ids_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'pre.tpresupuesto_ids'
 AUTOR: 		 (miguel.mamani)
 FECHA:	        17-12-2018 19:20:26
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #2			 20/12/2018	Miguel Mamani			Replicación de partidas y presupuestos
 #
 ***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_presupuesto_uno	integer;
    v_registros_ges  		record;
	v_id_gestion_destino	integer;
    v_registros				record;
    v_id_presupuesto_dos	integer;
    v_reg_cc_ori			record;
    v_id_centro_costo		integer;
    v_id_presupuesto		integer;

BEGIN

    v_nombre_funcion = 'pre.ft_presupuesto_ids_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'PRE_RPP_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		miguel.mamani
 	#FECHA:		17-12-2018 19:20:26
	***********************************/

	if(p_transaccion='PRE_RPP_INS')then

        begin
        select
              ges.id_gestion,
              ges.gestion,
              ges.id_empresa
           into
              v_registros_ges
           from
           param.tgestion ges
           where ges.id_gestion = v_parametros.id_gestion_act;

           select
              ges.id_gestion
           into
              v_id_gestion_destino
           from
           param.tgestion ges
           where       ges.gestion = v_registros_ges.gestion + 1
                   and ges.id_empresa = v_registros_ges.id_empresa
                   and ges.estado_reg = 'activo';

          IF v_id_gestion_destino is null THEN
                   raise exception 'no se encontró una siguiente gestión preparada (primero cree  gestión siguiente)';
          END IF;


           select  p.* ,
                   cc.id_tipo_cc,
                   ci.id_categoria_programatica_dos
                   into v_registros
                from pre.tpresupuesto p
                inner join param.tcentro_costo cc on cc.id_centro_costo = p.id_centro_costo
                left join pre.tcategoria_programatica_ids ci on ci.id_categoria_programatica_uno = p.id_categoria_prog
                where cc.id_gestion = v_parametros.id_gestion_act and p.id_presupuesto = v_parametros.id_presupuesto_uno and p.estado_reg = 'activo';
              --  raise exception 'v_registros.id_presupuesto %',v_registros.id_presupuesto;
           if not exists(select 1 from pre.tpresupuesto_ids i where i.id_presupuesto_uno = v_registros.id_presupuesto) then
              -- preguntamos si ya existe en la tabla de ids
                    v_id_presupuesto_dos = NULL;
                    select
                       i.id_presupuesto_dos
                     into
                       v_id_presupuesto_dos
                    from pre.tpresupuesto_ids i
                    where i.id_presupuesto_uno = v_registros.id_presupuesto;



                      IF v_id_presupuesto_dos is null  THEN

                         -- clonamos el centro de costos
                           select
                               *
                           into
                              v_reg_cc_ori
                           from param.tcentro_costo cc
                           where cc.id_centro_costo = v_registros.id_centro_costo;

                         --insertamos nuevo centro de costo
                           INSERT INTO  param.tcentro_costo
                                      (
                                        id_usuario_reg,
                                        fecha_reg,
                                        estado_reg,
                                        id_ep,
                                        id_uo,
                                        id_gestion,
                                        id_tipo_cc
                                      )
                                      VALUES (
                                        p_id_usuario,
                                        now(),
                                        'activo',
                                        v_reg_cc_ori.id_ep,
                                        v_reg_cc_ori.id_uo,
                                        v_id_gestion_destino,
                                        v_reg_cc_ori.id_tipo_cc
                                      ) RETURNING id_centro_costo into v_id_centro_costo;


                     --  insertamos nuevo presupuesto
                     INSERT INTO  pre.tpresupuesto
                                  (
                                    id_usuario_reg,
                                    fecha_reg,
                                    estado_reg,
                                    id_presupuesto,
                                    id_centro_costo,
                                    tipo_pres,
                                    estado_pres,
                                    id_categoria_prog,
                                    id_parametro,
                                    id_fuente_financiamiento,
                                    id_concepto_colectivo,
                                    cod_fin,
                                    cod_prg,
                                    cod_pry,
                                    cod_act,
                                    descripcion,
                                    sw_consolidado
                                  )
                                  VALUES (
                                    p_id_usuario,
                                    now(),
                                    'activo',
                                    v_id_centro_costo, --id_presupeusto tiene que ser igual al id centro de costo
                                    v_id_centro_costo,
                                    v_registros.tipo_pres,
                                    v_registros.estado_pres,
                                    v_registros.id_categoria_programatica_dos,
                                    v_registros.id_parametro,
                                    v_registros.id_fuente_financiamiento,
                                    v_registros.id_concepto_colectivo,
                                    v_registros.cod_fin,
                                    v_registros.cod_prg,
                                    v_registros.cod_pry,
                                    v_registros.cod_act,
                                    v_registros.descripcion,
                                    v_registros.sw_consolidado
                                  )RETURNING id_presupuesto into v_id_presupuesto;

                                  INSERT INTO pre.tpresupuesto_ids (id_presupuesto_uno,
                                                                    id_presupuesto_dos,
                                                                    sw_cambio_gestion,
                                                                    insercion,
                                                                    id_usuario_reg
                                                                    ) VALUES (
                                                                    v_registros.id_presupuesto,
                                                                    v_id_presupuesto,
                                                                    'gestion',
                                                                    'manual',
                                                                    p_id_usuario);


                     ELSE
                        --si el presupeusto ya existe modificarlo

                          update param.tcentro_costo set
                             id_tipo_cc = v_registros.id_tipo_cc
                          where id_centro_costo = v_id_presupuesto_dos;

                          update pre.tpresupuesto  c set
                             descripcion = v_registros.descripcion,
                             id_categoria_prog = v_registros.id_categoria_programatica_dos,
                             sw_consolidado = v_registros.sw_consolidado
                          where id_centro_costo = v_id_presupuesto_dos;

                     END IF;
           else
               raise exception'Ya existe una replica';
           end if;

			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Replicacion Presupuesto almacenado(a) con exito (id_presupuesto_uno'||v_id_presupuesto||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_presupuesto',v_id_presupuesto::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;



	/*********************************
 	#TRANSACCION:  'PRE_RPP_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		miguel.mamani
 	#FECHA:		17-12-2018 19:20:26
	***********************************/

	elsif(p_transaccion='PRE_RPP_ELI')then

		begin
			--Sentencia de la eliminacion


            select id.id_presupuesto_dos
            into
            v_id_presupuesto_dos
            from pre.tpresupuesto_ids id
            where id.id_presupuesto_uno = v_parametros.id_presupuesto_uno;


             select cc.id_centro_costo
             		into
                v_reg_cc_ori
             from param.tcentro_costo cc
             where cc.id_centro_costo = (select pr.id_centro_costo
                                         from pre.tpresupuesto pr
                                         where pr.id_presupuesto = v_id_presupuesto_dos);
            delete from pre.tpresupuesto pr
            where pr.id_presupuesto = v_id_presupuesto_dos;

            delete from pre.tpresupuesto_ids
            where id_presupuesto_uno=v_parametros.id_presupuesto_uno;



            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Replicacion Presupuesto eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_presupuesto_uno',v_parametros.id_presupuesto_uno::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	else

    	raise exception 'Transaccion inexistente: %',p_transaccion;

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