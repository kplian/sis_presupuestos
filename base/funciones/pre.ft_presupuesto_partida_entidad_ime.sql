CREATE OR REPLACE FUNCTION pre.ft_presupuesto_partida_entidad_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Presupuesto
 FUNCION: 		pre.ft_presupuesto_partida_entidad_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'pre.tpresupuesto_partida_entidad'
 AUTOR: 		 (franklin.espinoza)
 FECHA:	        21-07-2017 12:58:43
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:
 AUTOR:
 FECHA:
***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_presupuesto_partida_entidad	integer;
    v_id_gestion						integer;
    v_datos 				record;
    v_valid					boolean;

BEGIN

    v_nombre_funcion = 'pre.ft_presupuesto_partida_entidad_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'PRE_P_P_ENT_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		21-07-2017 12:58:43
	***********************************/

	if(p_transaccion='PRE_P_P_ENT_INS')then

        begin
        	--RAISE EXCEPTION 'V_PARAMETROS %',v_parametros;
        	--Sentencia de la insercion
        	insert into pre.tpresupuesto_partida_entidad(
			id_partida,
			id_gestion,
			id_entidad_transferencia,
			estado_reg,
			id_presupuesto,
			id_usuario_ai,
			id_usuario_reg,
			usuario_ai,
			fecha_reg,
			id_usuario_mod,
			fecha_mod
          	) values(
			v_parametros.id_partida,
			v_parametros.id_gestion,
			v_parametros.id_entidad_transferencia,
			'activo',
			v_parametros.id_presupuesto,
			v_parametros._id_usuario_ai,
			p_id_usuario,
			v_parametros._nombre_usuario_ai,
			now(),
			null,
			null



			)RETURNING id_presupuesto_partida_entidad into v_id_presupuesto_partida_entidad;

			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','PresuPartidaEntidad almacenado(a) con exito (id_presupuesto_partida_entidad'||v_id_presupuesto_partida_entidad||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_presupuesto_partida_entidad',v_id_presupuesto_partida_entidad::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'PRE_P_P_ENT_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		21-07-2017 12:58:43
	***********************************/

	elsif(p_transaccion='PRE_P_P_ENT_MOD')then

		begin
			--Sentencia de la modificacion
			update pre.tpresupuesto_partida_entidad set
			id_partida = v_parametros.id_partida,
			id_gestion = v_parametros.id_gestion,
			id_entidad_transferencia = v_parametros.id_entidad_transferencia,
			id_presupuesto = v_parametros.id_presupuesto,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_presupuesto_partida_entidad=v_parametros.id_presupuesto_partida_entidad;

			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','PresuPartidaEntidad modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_presupuesto_partida_entidad',v_parametros.id_presupuesto_partida_entidad::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'PRE_P_P_ENT_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		21-07-2017 12:58:43
	***********************************/

	elsif(p_transaccion='PRE_P_P_ENT_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from pre.tpresupuesto_partida_entidad
            where id_presupuesto_partida_entidad=v_parametros.id_presupuesto_partida_entidad;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','PresuPartidaEntidad eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_presupuesto_partida_entidad',v_parametros.id_presupuesto_partida_entidad::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;
	/*********************************
 	#TRANSACCION:  'PRE_P_P_ENT_VAL'
 	#DESCRIPCION:  Validacion de Relación de Entidades.
 	#AUTOR:		franklin.espinoza
 	#FECHA:		21-07-2017 12:57:45
	***********************************/

	elsif(p_transaccion='PRE_P_P_ENT_VAL')then

		begin
			--Sentencia de la eliminacion
			select count(tppe.id_presupuesto_partida_entidad) AS contador,
            'La relación de Entidades ya fue registrada.' AS mensaje
            INTO v_datos
            FROM pre.tpresupuesto_partida_entidad tppe
            WHERE tppe.id_partida = v_parametros.id_partida  AND tppe.id_entidad_transferencia = v_parametros.id_entidad_transferencia AND tppe.id_presupuesto =  v_parametros.id_presupuesto;


            IF(v_datos.contador>=1)THEN
        		v_valid = true;
            ELSE
            	v_valid = false;
			END IF;


            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Validacion Exitosa.');
            v_resp = pxp.f_agrega_clave(v_resp,'v_valid',v_valid::varchar);
            v_resp = pxp.f_agrega_clave(v_resp,'v_mensaje',v_datos.mensaje::varchar);

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