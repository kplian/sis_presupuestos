CREATE OR REPLACE FUNCTION pre.ft_unidad_ejecutora_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Presupuesto
 FUNCION: 		pre.ft_unidad_ejecutora_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'pre.tunidad_ejecutora'
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

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_unidad_ejecutora	integer;
    v_id_gestion					integer;
    v_datos					record;
    v_valid					boolean;

BEGIN

    v_nombre_funcion = 'pre.ft_unidad_ejecutora_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'PRE_UND_EJE_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		21-07-2017 13:41:05
	***********************************/

	if(p_transaccion='PRE_UND_EJE_INS')then

        begin

        	SELECT g.id_gestion
            INTO v_id_gestion
            FROM param.tgestion g
            WHERE g.gestion = EXTRACT(YEAR FROM current_date);
        	--Sentencia de la insercion
        	insert into pre.tunidad_ejecutora(
			id_gestion,
			nombre,
			codigo,
			estado_reg,
			id_usuario_ai,
			fecha_reg,
			usuario_ai,
			id_usuario_reg,
			fecha_mod,
			id_usuario_mod
          	) values(
			v_parametros.id_gestion,
			v_parametros.nombre,
			v_parametros.codigo,
			'activo',
			v_parametros._id_usuario_ai,
			now(),
			v_parametros._nombre_usuario_ai,
			p_id_usuario,
			null,
			null



			)RETURNING id_unidad_ejecutora into v_id_unidad_ejecutora;

			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','UnidadEjecutora almacenado(a) con exito (id_unidad_ejecutora'||v_id_unidad_ejecutora||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_unidad_ejecutora',v_id_unidad_ejecutora::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'PRE_UND_EJE_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		21-07-2017 13:41:05
	***********************************/

	elsif(p_transaccion='PRE_UND_EJE_MOD')then

		begin
			--Sentencia de la modificacion
			update pre.tunidad_ejecutora set
			id_gestion = v_parametros.id_gestion,
			nombre = v_parametros.nombre,
			codigo = v_parametros.codigo,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario,
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_unidad_ejecutora=v_parametros.id_unidad_ejecutora;

			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','UnidadEjecutora modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_unidad_ejecutora',v_parametros.id_unidad_ejecutora::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'PRE_UND_EJE_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		21-07-2017 13:41:05
	***********************************/

	elsif(p_transaccion='PRE_UND_EJE_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from pre.tunidad_ejecutora
            where id_unidad_ejecutora=v_parametros.id_unidad_ejecutora;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','UnidadEjecutora eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_unidad_ejecutora',v_parametros.id_unidad_ejecutora::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;
    /*********************************
 	#TRANSACCION:  'PRE_UND_EJE_VAL'
 	#DESCRIPCION:  Validacion de codigo, nombre
 	#AUTOR:		franklin.espinoza
 	#FECHA:		21-07-2017 12:57:45
	***********************************/

	elsif(p_transaccion='PRE_UND_EJE_VAL')then

		begin
			--Sentencia de la eliminacion
			select count(tue.id_unidad_ejecutora) AS contador,
            CASE WHEN lower(tue.codigo) = lower(v_parametros.codigo) AND lower(tue.nombre) <> lower(v_parametros.nombre) THEN ('Codigo es Duplicado, ' || v_parametros.codigo)::varchar
            	 WHEN lower(tue.nombre) = lower(v_parametros.nombre) AND lower(tue.codigo) <> lower(v_parametros.codigo) THEN ('Nombre es Duplicado, ' || v_parametros.nombre)::varchar
                 WHEN lower(tue.codigo) = lower(v_parametros.codigo) AND lower( tue.nombre) = lower(v_parametros.nombre) THEN ('Codigo y Nombre son Duplicados, ' || v_parametros.codigo ||' , '|| v_parametros.nombre)::varchar
            END AS mensaje
            INTO v_datos
            from pre.tunidad_ejecutora tue
            where lower(tue.codigo) = lower(v_parametros.codigo) OR lower(tue.nombre) = lower(v_parametros.nombre)
            GROUP BY tue.codigo, tue.nombre;


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