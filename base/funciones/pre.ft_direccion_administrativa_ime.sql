CREATE OR REPLACE FUNCTION pre.ft_direccion_administrativa_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Presupuesto
 FUNCION: 		pre.ft_direccion_administrativa_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'pre.tdireccion_administrativa'
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

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_direccion_administrativa	integer;
    v_id_gestion					integer;
    v_datos					record;
    v_valid					boolean;

BEGIN

    v_nombre_funcion = 'pre.ft_direccion_administrativa_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'PRE_DIR_ADM_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		21-07-2017 13:40:32
	***********************************/

	if(p_transaccion='PRE_DIR_ADM_INS')then

        begin

        	/*SELECT g.id_gestion
            INTO v_id_gestion
            FROM param.tgestion g
            WHERE g.gestion = EXTRACT(YEAR FROM current_date);*/
        	--Sentencia de la insercion
        	insert into pre.tdireccion_administrativa(
			id_gestion,
			estado_reg,
			codigo,
			nombre,
			usuario_ai,
			fecha_reg,
			id_usuario_reg,
			id_usuario_ai,
			fecha_mod,
			id_usuario_mod
          	) values(
			v_parametros.id_gestion,
			'activo',
			v_parametros.codigo,
			v_parametros.nombre,
			v_parametros._nombre_usuario_ai,
			now(),
			p_id_usuario,
			v_parametros._id_usuario_ai,
			null,
			null



			)RETURNING id_direccion_administrativa into v_id_direccion_administrativa;

			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','DireccionAdmin almacenado(a) con exito (id_direccion_administrativa'||v_id_direccion_administrativa||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_direccion_administrativa',v_id_direccion_administrativa::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'PRE_DIR_ADM_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		21-07-2017 13:40:32
	***********************************/

	elsif(p_transaccion='PRE_DIR_ADM_MOD')then

		begin
			--Sentencia de la modificacion
			update pre.tdireccion_administrativa set
			id_gestion = v_parametros.id_gestion,
			codigo = v_parametros.codigo,
			nombre = v_parametros.nombre,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario,
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_direccion_administrativa=v_parametros.id_direccion_administrativa;

			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','DireccionAdmin modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_direccion_administrativa',v_parametros.id_direccion_administrativa::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'PRE_DIR_ADM_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		21-07-2017 13:40:32
	***********************************/

	elsif(p_transaccion='PRE_DIR_ADM_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from pre.tdireccion_administrativa
            where id_direccion_administrativa=v_parametros.id_direccion_administrativa;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','DireccionAdmin eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_direccion_administrativa',v_parametros.id_direccion_administrativa::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;
    /*********************************
 	#TRANSACCION:  'PRE_DIR_ADM_VAL'
 	#DESCRIPCION:  Validacion de codigo, nombre
 	#AUTOR:		franklin.espinoza
 	#FECHA:		21-07-2017 12:57:45
	***********************************/

	elsif(p_transaccion='PRE_DIR_ADM_VAL')then

		begin
			--Sentencia de la eliminacion
			select count(tda.id_direccion_administrativa) AS contador,
            CASE WHEN lower(tda.codigo) = lower(v_parametros.codigo) AND lower(tda.nombre) <> lower(v_parametros.nombre) THEN ('Codigo es Duplicado, ' || v_parametros.codigo)::varchar
            	 WHEN lower(tda.nombre) = lower(v_parametros.nombre) AND lower(tda.codigo) <> lower(v_parametros.codigo) THEN ('Nombre es Duplicado, ' || v_parametros.nombre)::varchar
                 WHEN lower(tda.codigo) = lower(v_parametros.codigo) AND lower( tda.nombre) = lower(v_parametros.nombre) THEN ('Codigo y Nombre son Duplicados, ' || v_parametros.codigo ||' , '|| v_parametros.nombre)::varchar
            END AS mensaje
            INTO v_datos
            from pre.tdireccion_administrativa tda
            where lower(tda.codigo) = lower(v_parametros.codigo) OR lower(tda.nombre) = lower(v_parametros.nombre)
            GROUP BY tda.codigo, tda.nombre;


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