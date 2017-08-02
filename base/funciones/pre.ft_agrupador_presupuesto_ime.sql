CREATE OR REPLACE FUNCTION "pre"."ft_agrupador_presupuesto_ime" (	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:		Sistema de Presupuesto
 FUNCION: 		pre.ft_agrupador_presupuesto_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'pre.tagrupador_presupuesto'
 AUTOR: 		 (gvelasquez)
 FECHA:	        25-10-2016 19:21:34
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
	v_id_agrupador_presupuesto	integer;
			    
BEGIN

    v_nombre_funcion = 'pre.ft_agrupador_presupuesto_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PRE_AGRPRE_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		gvelasquez	
 	#FECHA:		25-10-2016 19:21:34
	***********************************/

	if(p_transaccion='PRE_AGRPRE_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into pre.tagrupador_presupuesto(
			id_presupuesto,
			estado_reg,
			id_agrupador,
			id_usuario_ai,
			id_usuario_reg,
			usuario_ai,
			fecha_reg,
			id_usuario_mod,
			fecha_mod
          	) values(
			v_parametros.id_presupuesto,
			'activo',
			v_parametros.id_agrupador,
			v_parametros._id_usuario_ai,
			p_id_usuario,
			v_parametros._nombre_usuario_ai,
			now(),
			null,
			null
							
			
			
			)RETURNING id_agrupador_presupuesto into v_id_agrupador_presupuesto;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Agrupador Presupuesto almacenado(a) con exito (id_agrupador_presupuesto'||v_id_agrupador_presupuesto||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_agrupador_presupuesto',v_id_agrupador_presupuesto::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'PRE_AGRPRE_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		gvelasquez	
 	#FECHA:		25-10-2016 19:21:34
	***********************************/

	elsif(p_transaccion='PRE_AGRPRE_MOD')then

		begin
			--Sentencia de la modificacion
			update pre.tagrupador_presupuesto set
			id_presupuesto = v_parametros.id_presupuesto,
			id_agrupador = v_parametros.id_agrupador,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_agrupador_presupuesto=v_parametros.id_agrupador_presupuesto;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Agrupador Presupuesto modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_agrupador_presupuesto',v_parametros.id_agrupador_presupuesto::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'PRE_AGRPRE_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		gvelasquez	
 	#FECHA:		25-10-2016 19:21:34
	***********************************/

	elsif(p_transaccion='PRE_AGRPRE_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from pre.tagrupador_presupuesto
            where id_agrupador_presupuesto=v_parametros.id_agrupador_presupuesto;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Agrupador Presupuesto eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_agrupador_presupuesto',v_parametros.id_agrupador_presupuesto::varchar);
              
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
ALTER FUNCTION "pre"."ft_agrupador_presupuesto_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
