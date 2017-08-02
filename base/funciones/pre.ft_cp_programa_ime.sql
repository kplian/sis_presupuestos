CREATE OR REPLACE FUNCTION "pre"."ft_cp_programa_ime" (	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:		Sistema de Presupuesto
 FUNCION: 		pre.ft_cp_programa_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'pre.tcp_programa'
 AUTOR: 		 (admin)
 FECHA:	        19-04-2016 14:04:56
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
	v_id_cp_programa	integer;
			    
BEGIN

    v_nombre_funcion = 'pre.ft_cp_programa_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PRE_CPPR_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		19-04-2016 14:04:56
	***********************************/

	if(p_transaccion='PRE_CPPR_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into pre.tcp_programa(
			codigo,
			estado_reg,
			descripcion,
			id_gestion,
			id_usuario_reg,
			usuario_ai,
			fecha_reg,
			id_usuario_ai,
			fecha_mod,
			id_usuario_mod
          	) values(
			v_parametros.codigo,
			'activo',
			v_parametros.descripcion,
			v_parametros.id_gestion,
			p_id_usuario,
			v_parametros._nombre_usuario_ai,
			now(),
			v_parametros._id_usuario_ai,
			null,
			null
							
			
			
			)RETURNING id_cp_programa into v_id_cp_programa;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','CP Programa almacenado(a) con exito (id_cp_programa'||v_id_cp_programa||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_cp_programa',v_id_cp_programa::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'PRE_CPPR_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		19-04-2016 14:04:56
	***********************************/

	elsif(p_transaccion='PRE_CPPR_MOD')then

		begin
			--Sentencia de la modificacion
			update pre.tcp_programa set
			codigo = v_parametros.codigo,
			descripcion = v_parametros.descripcion,
			id_gestion = v_parametros.id_gestion,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario,
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_cp_programa=v_parametros.id_cp_programa;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','CP Programa modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_cp_programa',v_parametros.id_cp_programa::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'PRE_CPPR_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		19-04-2016 14:04:56
	***********************************/

	elsif(p_transaccion='PRE_CPPR_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from pre.tcp_programa
            where id_cp_programa=v_parametros.id_cp_programa;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','CP Programa eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_cp_programa',v_parametros.id_cp_programa::varchar);
              
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
ALTER FUNCTION "pre"."ft_cp_programa_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
