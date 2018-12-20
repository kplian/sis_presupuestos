CREATE OR REPLACE FUNCTION pre.ft_partida_ids_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de presupuesto
 FUNCION: 		pre.ft_partida_ids_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'pre.tpartida_ids'
 AUTOR: 		 (miguel.mamani)
 FECHA:	        17-12-2018 19:20:23
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #2				 20/12/2018	Miguel Mamani			Replicación de partidas y presupuestos

 ***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_partida_uno		integer;
    v_registros_ges			record;
    v_id_gestion_destino	integer;
    v_reg_partida_ori		record;
    v_record				record;
    v_id_partida_fk_des		integer;
    v_id_partida			integer;
    v_id_partida_dos		integer;

BEGIN

    v_nombre_funcion = 'pre.ft_partida_ids_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'PRE_RPS_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		miguel.mamani
 	#FECHA:		17-12-2018 19:20:23
	***********************************/

	if(p_transaccion='PRE_RPS_INS')then

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

           if v_id_gestion_destino is null then
                     raise exception 'no se encontró una siguiente gestión preparada (primero cree la gestión)';
           end if;
        	select    pa.id_partida,
                      pa.id_partida_fk,
                      pa.id_gestion
                      into
                      v_record
            from pre.tpartida pa
            where pa.id_gestion = v_parametros.id_gestion_act and pa.estado_reg = 'activo'
            and pa.id_partida = v_parametros.id_partida_uno;
            --exists
            if not exists(select 1 from pre.tpartida_ids i where i.id_partida_uno =  v_record.id_partida) then
           -- raise exception 'entra';
             IF v_record.id_partida_fk is not null THEN
                        --  busca la cuenta del padre en cuetaids
                         v_id_partida_fk_des  = NULL;
                         select
                           cid.id_partida_dos
                         into
                           v_id_partida_fk_des
                         from pre.tpartida_ids cid
                         where  cid.id_partida_uno = v_record.id_partida_fk;
             END IF;
              v_reg_partida_ori = NULL;
               select * into v_reg_partida_ori from pre.tpartida p where p.id_partida = v_record.id_partida;
               --  inserta la cuenta para la nueva gestion

                 insert into pre.tpartida(  id_usuario_reg,
                                            fecha_reg,
                                            estado_reg,
                                            id_partida_fk,
                                            id_gestion,
                                            id_parametros,
                                            codigo,
                                            nombre_partida,
                                            descripcion,
                                            nivel_partida,
                                            sw_transaccional,
                                            tipo,
                                            sw_movimiento,
                                            cod_trans,
                                            cod_ascii,
                                            cod_excel,
                                            ent_trf
                                          )
                                          VALUES (
                                            p_id_usuario,
                                            now(),
                                            'activo',
                                            v_id_partida_fk_des,
                                            v_id_gestion_destino,
                                            v_reg_partida_ori.id_parametros,
                                            v_reg_partida_ori.codigo,
                                            v_reg_partida_ori.nombre_partida,
                                            v_reg_partida_ori.descripcion,
                                            v_reg_partida_ori.nivel_partida,
                                            v_reg_partida_ori.sw_transaccional,
                                            v_reg_partida_ori.tipo,
                                            v_reg_partida_ori.sw_movimiento,
                                            v_reg_partida_ori.cod_trans,
                                            v_reg_partida_ori.cod_ascii,
                                            v_reg_partida_ori.cod_excel,
                                            v_reg_partida_ori.ent_trf
                                          )RETURNING id_partida into v_id_partida;

              					INSERT INTO pre.tpartida_ids (id_partida_uno,
                                                              id_partida_dos,
                                                              sw_cambio_gestion,
                                                              insercion,
                                                              id_usuario_reg
                                                              ) VALUES (
                                                              v_record.id_partida,
                                                              v_id_partida,
                                                              'gestion',
                                                              'manual',
                                                              p_id_usuario
                                                              );
            else
            	raise exception 'Ya existe una replica de la partida';
            end if;

			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Replicacion Partidas almacenado(a) con exito (id_partida_uno'||v_id_partida||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_partida',v_id_partida::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;



	/*********************************
 	#TRANSACCION:  'PRE_RPS_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		miguel.mamani
 	#FECHA:		17-12-2018 19:20:23
	***********************************/

	elsif(p_transaccion='PRE_RPS_ELI')then

		begin
			--Sentencia de la eliminacion


            select p.id_partida_dos
            into
            v_id_partida_dos
            from pre.tpartida_ids p
            where p.id_partida_uno = v_parametros.id_partida_uno;

            delete from pre.tpartida
            where id_partida= v_id_partida_dos;


            delete from pre.tpartida_ids
            where id_partida_uno=v_parametros.id_partida_uno;


            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Replicacion Partidas eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_partida_uno',v_parametros.id_partida_uno::varchar);

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