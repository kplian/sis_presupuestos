CREATE OR REPLACE FUNCTION "pre"."f_concepto_cta_ime" (	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:		Sistema de presupuesto
 FUNCION: 		pre.f_concepto_cta_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'pre.tconcepto_cta'
 AUTOR: 		Gonzalo Sarmiento Sejas
 FECHA:	        18-02-2013 22:57:58
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
	v_id_concepto_cta	integer;
			    
BEGIN

    v_nombre_funcion = 'pre.f_concepto_cta_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PRE_CCTA_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		Gonzalo Sarmiento Sejas	
 	#FECHA:		18-02-2013 22:57:58
	***********************************/

	if(p_transaccion='PRE_CCTA_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into pre.tconcepto_cta(
			estado_reg,
			id_auxiliar,
			id_cuenta,
			id_concepto_ingas,
			id_partida,
			id_centro_costo,
			fecha_reg,
			id_usuario_reg,
			fecha_mod,
			id_usuario_mod
          	) values(
			'activo',
			v_parametros.id_auxiliar,
			v_parametros.id_cuenta,
			v_parametros.id_concepto_ingas,
			v_parametros.id_partida,
			v_parametros.id_centro_costo,
			now(),
			p_id_usuario,
			null,
			null
							
			)RETURNING id_concepto_cta into v_id_concepto_cta;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Concepto cuenta almacenado(a) con exito (id_concepto_cta'||v_id_concepto_cta||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_concepto_cta',v_id_concepto_cta::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'PRE_CCTA_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		Gonzalo Sarmiento Sejas	
 	#FECHA:		18-02-2013 22:57:58
	***********************************/

	elsif(p_transaccion='PRE_CCTA_MOD')then

		begin
			--Sentencia de la modificacion
			update pre.tconcepto_cta set
			id_auxiliar = v_parametros.id_auxiliar,
			id_cuenta = v_parametros.id_cuenta,
			id_concepto_ingas = v_parametros.id_concepto_ingas,
			id_partida = v_parametros.id_partida,
			id_centro_costo = v_parametros.id_centro_costo,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario
			where id_concepto_cta=v_parametros.id_concepto_cta;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Concepto cuenta modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_concepto_cta',v_parametros.id_concepto_cta::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'PRE_CCTA_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		Gonzalo Sarmiento Sejas	
 	#FECHA:		18-02-2013 22:57:58
	***********************************/

	elsif(p_transaccion='PRE_CCTA_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from pre.tconcepto_cta
            where id_concepto_cta=v_parametros.id_concepto_cta;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Concepto cuenta eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_concepto_cta',v_parametros.id_concepto_cta::varchar);
              
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
ALTER FUNCTION "pre"."f_concepto_cta_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
