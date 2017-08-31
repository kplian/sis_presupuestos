CREATE OR REPLACE FUNCTION pre.ft_objetivo_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Presupuesto
 FUNCION: 		pre.ft_objetivo_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'pre.tobjetivo'
 AUTOR: 		 (gvelasquez)
 FECHA:	        20-07-2016 20:37:41
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
	v_id_objetivo			integer;
    v_id_objetivo_fk		integer;

BEGIN

    v_nombre_funcion = 'pre.ft_objetivo_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'PRE_OBJ_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		gvelasquez
 	#FECHA:		20-07-2016 20:37:41
	***********************************/

	if(p_transaccion='PRE_OBJ_INS')then

        begin
        	raise exception 'id_parametros: %',v_parametros;

           IF v_parametros.id_objetivo_fk != 'id' and v_parametros.id_objetivo_fk != '' THEN
                   v_id_objetivo_fk  = v_parametros.id_objetivo_fk::integer;
              END IF;

              -- buscamos que el codigo  no se repita

              IF exists(SELECT 1
                        from pre.tobjetivo c
                        where trim(c.codigo) = trim(v_parametros.codigo)
                        and c.estado_reg = 'activo'
                        and c.id_gestion = v_parametros.id_gestion) THEN

                  raise exception 'El código % ya existe', v_parametros.codigo;

              END IF;

        	--Sentencia de la insercion
        	insert into pre.tobjetivo(
			id_objetivo_fk,
			nivel_objetivo,
			sw_transaccional,
			cantidad_verificacion,
			unidad_verificacion,
			ponderacion,
			fecha_inicio,
			tipo_objetivo,
			descripcion,
			linea_base,
			estado_reg,
			--id_parametros,
			indicador_logro,
			id_gestion,
			codigo,
			periodo_ejecucion,
			producto,
			fecha_fin,
			fecha_reg,
			usuario_ai,
			id_usuario_reg,
			id_usuario_ai,
			fecha_mod,
			id_usuario_mod
          	) values(
			v_id_objetivo_fk,
			v_parametros.nivel_objetivo,
			v_parametros.sw_transaccional,
			v_parametros.cantidad_verificacion,
			v_parametros.unidad_verificacion,
			v_parametros.ponderacion,
			v_parametros.fecha_inicio,
			v_parametros.tipo_objetivo,
			v_parametros.descripcion,
			v_parametros.linea_base,
			'activo',
			--v_parametros.id_parametros,
			v_parametros.indicador_logro,
			v_parametros.id_gestion,
			v_parametros.codigo,
			v_parametros.periodo_ejecucion,
			v_parametros.producto,
			v_parametros.fecha_fin,
			now(),
			v_parametros._nombre_usuario_ai,
			p_id_usuario,
			v_parametros._id_usuario_ai,
			null,
			null



			)RETURNING id_objetivo into v_id_objetivo;

			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Objetivo almacenado(a) con exito (id_objetivo'||v_id_objetivo||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_objetivo',v_id_objetivo::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'PRE_OBJ_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		gvelasquez
 	#FECHA:		20-07-2016 20:37:41
	***********************************/

	elsif(p_transaccion='PRE_OBJ_MOD')then

		begin

              IF v_parametros.id_objetivo_fk != 'id' and v_parametros.id_objetivo_fk != '' THEN
                   v_id_objetivo_fk  = v_parametros.id_objetivo_fk::integer;
              END IF;

              -- buscamos que el codigo  no se repita
              --raise exception 'v_parametros.id_objetivo: %, %',v_parametros.id_objetivo, v_parametros.codigo;
              /*IF exists(SELECT 1
                        from pre.tobjetivo c
                        where trim(c.codigo) = trim(v_parametros.codigo)
                        and c.estado_reg = 'activo'
                        and c.id_objetivo != v_parametros.id_objetivo)  THEN

                  raise exception 'El código   % ya existe', v_parametros.codigo;

              END IF;*/
			--Sentencia de la modificacion
			update pre.tobjetivo set
                id_objetivo_fk = v_id_objetivo_fk,
                nivel_objetivo = v_parametros.nivel_objetivo,
                sw_transaccional = v_parametros.sw_transaccional,
                cantidad_verificacion = v_parametros.cantidad_verificacion,
                unidad_verificacion = v_parametros.unidad_verificacion,
                ponderacion = v_parametros.ponderacion,
                fecha_inicio = v_parametros.fecha_inicio,
                tipo_objetivo = v_parametros.tipo_objetivo,
                descripcion = v_parametros.descripcion,
                linea_base = v_parametros.linea_base,
                --id_parametros = v_parametros.id_parametros,
                indicador_logro = v_parametros.indicador_logro,
                id_gestion = v_parametros.id_gestion,
                codigo = v_parametros.codigo,
                periodo_ejecucion = v_parametros.periodo_ejecucion,
                producto = v_parametros.producto,
                fecha_fin = v_parametros.fecha_fin,
                fecha_mod = now(),
                id_usuario_mod = p_id_usuario,
                id_usuario_ai = v_parametros._id_usuario_ai,
                usuario_ai = v_parametros._nombre_usuario_ai
			where id_objetivo=v_parametros.id_objetivo;

			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Objetivo modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_objetivo',v_parametros.id_objetivo::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'PRE_OBJ_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		gvelasquez
 	#FECHA:		20-07-2016 20:37:41
	***********************************/

	elsif(p_transaccion='PRE_OBJ_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from pre.tobjetivo
            where id_objetivo=v_parametros.id_objetivo;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Objetivo eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_objetivo',v_parametros.id_objetivo::varchar);

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