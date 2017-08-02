CREATE OR REPLACE FUNCTION "pre"."ft_agrupador_ime" (	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:		Sistema de Presupuesto
 FUNCION: 		pre.ft_agrupador_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'pre.tagrupador'
 AUTOR: 		 (gvelasquez)
 FECHA:	        25-10-2016 19:21:31
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
	v_id_agrupador	integer;
			    
BEGIN

    v_nombre_funcion = 'pre.ft_agrupador_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PRE_AGRUPA_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		gvelasquez	
 	#FECHA:		25-10-2016 19:21:31
	***********************************/

	if(p_transaccion='PRE_AGRUPA_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into pre.tagrupador(
			estado_reg,
			orden,
			tipo,
			nombre_agrupador,
			codigo,
			id_usuario_reg,
			fecha_reg,
			usuario_ai,
			id_usuario_ai,
			id_usuario_mod,
			fecha_mod
          	) values(
			'activo',
			v_parametros.orden,
			v_parametros.tipo,
			v_parametros.nombre_agrupador,
			v_parametros.codigo,
			p_id_usuario,
			now(),
			v_parametros._nombre_usuario_ai,
			v_parametros._id_usuario_ai,
			null,
			null
							
			
			
			)RETURNING id_agrupador into v_id_agrupador;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Agrupador almacenado(a) con exito (id_agrupador'||v_id_agrupador||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_agrupador',v_id_agrupador::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'PRE_AGRUPA_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		gvelasquez	
 	#FECHA:		25-10-2016 19:21:31
	***********************************/

	elsif(p_transaccion='PRE_AGRUPA_MOD')then

		begin
			--Sentencia de la modificacion
			update pre.tagrupador set
			orden = v_parametros.orden,
			tipo = v_parametros.tipo,
			nombre_agrupador = v_parametros.nombre_agrupador,
			codigo = v_parametros.codigo,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_agrupador=v_parametros.id_agrupador;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Agrupador modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_agrupador',v_parametros.id_agrupador::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'PRE_AGRUPA_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		gvelasquez	
 	#FECHA:		25-10-2016 19:21:31
	***********************************/

	elsif(p_transaccion='PRE_AGRUPA_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from pre.tagrupador
            where id_agrupador=v_parametros.id_agrupador;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Agrupador eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_agrupador',v_parametros.id_agrupador::varchar);
              
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
ALTER FUNCTION "pre"."ft_agrupador_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
