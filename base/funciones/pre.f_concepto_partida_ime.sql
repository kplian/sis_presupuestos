CREATE OR REPLACE FUNCTION "pre"."f_concepto_partida_ime" (	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:		Sistema de presupuesto
 FUNCION: 		pre.f_concepto_partida_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'pre.tconcepto_partida'
 AUTOR: 		 (admin)
 FECHA:	        25-02-2013 22:09:52
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
	v_id_concepto_partida	integer;
			    
BEGIN

    v_nombre_funcion = 'pre.f_concepto_partida_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PRE_CONP_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		25-02-2013 22:09:52
	***********************************/

	if(p_transaccion='PRE_CONP_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into pre.tconcepto_partida(
			id_partida,
			id_concepto_ingas,
			estado_reg,
			id_usuario_reg,
			fecha_reg,
			fecha_mod,
			id_usuario_mod
          	) values(
			v_parametros.id_partida,
			v_parametros.id_concepto_ingas,
			'activo',
			p_id_usuario,
			now(),
			null,
			null
							
			)RETURNING id_concepto_partida into v_id_concepto_partida;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Concepto-Partida almacenado(a) con exito (id_concepto_partida'||v_id_concepto_partida||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_concepto_partida',v_id_concepto_partida::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'PRE_CONP_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		25-02-2013 22:09:52
	***********************************/

	elsif(p_transaccion='PRE_CONP_MOD')then

		begin
			--Sentencia de la modificacion
			update pre.tconcepto_partida set
			id_partida = v_parametros.id_partida,
			id_concepto_ingas = v_parametros.id_concepto_ingas,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario
			where id_concepto_partida=v_parametros.id_concepto_partida;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Concepto-Partida modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_concepto_partida',v_parametros.id_concepto_partida::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'PRE_CONP_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		25-02-2013 22:09:52
	***********************************/

	elsif(p_transaccion='PRE_CONP_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from pre.tconcepto_partida
            where id_concepto_partida=v_parametros.id_concepto_partida;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Concepto-Partida eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_concepto_partida',v_parametros.id_concepto_partida::varchar);
              
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
ALTER FUNCTION "pre"."f_concepto_partida_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
