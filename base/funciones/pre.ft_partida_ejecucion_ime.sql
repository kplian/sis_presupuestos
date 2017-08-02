CREATE OR REPLACE FUNCTION "pre"."ft_partida_ejecucion_ime" (	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:		Sistema de Presupuesto
 FUNCION: 		pre.ft_partida_ejecucion_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'pre.tpartida_ejecucion'
 AUTOR: 		 (gvelasquez)
 FECHA:	        03-10-2016 15:47:23
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
	v_id_partida_ejecucion	integer;
			    
BEGIN

    v_nombre_funcion = 'pre.ft_partida_ejecucion_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PRE_PAREJE_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		gvelasquez	
 	#FECHA:		03-10-2016 15:47:23
	***********************************/

	if(p_transaccion='PRE_PAREJE_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into pre.tpartida_ejecucion(
			id_int_comprobante,
			id_moneda,
			id_presupuesto,
			id_partida,
			nro_tramite,
			tipo_cambio,
			columna_origen,
			tipo_movimiento,
			id_partida_ejecucion_fk,
			estado_reg,
			fecha,
			monto_mb,
			monto,
			valor_id_origen,
			id_usuario_reg,
			fecha_reg,
			usuario_ai,
			id_usuario_ai,
			fecha_mod,
			id_usuario_mod
          	) values(
			v_parametros.id_int_comprobante,
			v_parametros.id_moneda,
			v_parametros.id_presupuesto,
			v_parametros.id_partida,
			v_parametros.nro_tramite,
			v_parametros.tipo_cambio,
			v_parametros.columna_origen,
			v_parametros.tipo_movimiento,
			v_parametros.id_partida_ejecucion_fk,
			'activo',
			v_parametros.fecha,
			v_parametros.monto_mb,
			v_parametros.monto,
			v_parametros.valor_id_origen,
			p_id_usuario,
			now(),
			v_parametros._nombre_usuario_ai,
			v_parametros._id_usuario_ai,
			null,
			null
							
			
			
			)RETURNING id_partida_ejecucion into v_id_partida_ejecucion;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Partida Ejecucion almacenado(a) con exito (id_partida_ejecucion'||v_id_partida_ejecucion||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_partida_ejecucion',v_id_partida_ejecucion::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'PRE_PAREJE_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		gvelasquez	
 	#FECHA:		03-10-2016 15:47:23
	***********************************/

	elsif(p_transaccion='PRE_PAREJE_MOD')then

		begin
			--Sentencia de la modificacion
			update pre.tpartida_ejecucion set
			id_int_comprobante = v_parametros.id_int_comprobante,
			id_moneda = v_parametros.id_moneda,
			id_presupuesto = v_parametros.id_presupuesto,
			id_partida = v_parametros.id_partida,
			nro_tramite = v_parametros.nro_tramite,
			tipo_cambio = v_parametros.tipo_cambio,
			columna_origen = v_parametros.columna_origen,
			tipo_movimiento = v_parametros.tipo_movimiento,
			id_partida_ejecucion_fk = v_parametros.id_partida_ejecucion_fk,
			fecha = v_parametros.fecha,
			monto_mb = v_parametros.monto_mb,
			monto = v_parametros.monto,
			valor_id_origen = v_parametros.valor_id_origen,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario,
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_partida_ejecucion=v_parametros.id_partida_ejecucion;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Partida Ejecucion modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_partida_ejecucion',v_parametros.id_partida_ejecucion::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'PRE_PAREJE_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		gvelasquez	
 	#FECHA:		03-10-2016 15:47:23
	***********************************/

	elsif(p_transaccion='PRE_PAREJE_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from pre.tpartida_ejecucion
            where id_partida_ejecucion=v_parametros.id_partida_ejecucion;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Partida Ejecucion eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_partida_ejecucion',v_parametros.id_partida_ejecucion::varchar);
              
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
$BODY$
LANGUAGE 'plpgsql' VOLATILE
COST 100;
ALTER FUNCTION "pre"."ft_partida_ejecucion_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
