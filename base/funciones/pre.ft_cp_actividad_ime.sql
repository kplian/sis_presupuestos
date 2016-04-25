CREATE OR REPLACE FUNCTION "pre"."ft_cp_actividad_ime" (	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:		Sistema de Presupuesto
 FUNCION: 		pre.ft_cp_actividad_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'pre.tcp_actividad'
 AUTOR: 		 (admin)
 FECHA:	        19-04-2016 14:40:47
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
	v_id_cp_actividad	integer;
			    
BEGIN

    v_nombre_funcion = 'pre.ft_cp_actividad_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PRE_CPAC_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		19-04-2016 14:40:47
	***********************************/

	if(p_transaccion='PRE_CPAC_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into pre.tcp_actividad(
			codigo,
			estado_reg,
			id_gestion,
			descripcion,
			fecha_reg,
			usuario_ai,
			id_usuario_reg,
			id_usuario_ai,
			fecha_mod,
			id_usuario_mod
          	) values(
			v_parametros.codigo,
			'activo',
			v_parametros.id_gestion,
			v_parametros.descripcion,
			now(),
			v_parametros._nombre_usuario_ai,
			p_id_usuario,
			v_parametros._id_usuario_ai,
			null,
			null
							
			
			
			)RETURNING id_cp_actividad into v_id_cp_actividad;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','CP Actividad almacenado(a) con exito (id_cp_actividad'||v_id_cp_actividad||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_cp_actividad',v_id_cp_actividad::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'PRE_CPAC_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		19-04-2016 14:40:47
	***********************************/

	elsif(p_transaccion='PRE_CPAC_MOD')then

		begin
			--Sentencia de la modificacion
			update pre.tcp_actividad set
			codigo = v_parametros.codigo,
			id_gestion = v_parametros.id_gestion,
			descripcion = v_parametros.descripcion,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario,
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_cp_actividad=v_parametros.id_cp_actividad;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','CP Actividad modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_cp_actividad',v_parametros.id_cp_actividad::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'PRE_CPAC_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		19-04-2016 14:40:47
	***********************************/

	elsif(p_transaccion='PRE_CPAC_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from pre.tcp_actividad
            where id_cp_actividad=v_parametros.id_cp_actividad;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','CP Actividad eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_cp_actividad',v_parametros.id_cp_actividad::varchar);
              
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
ALTER FUNCTION "pre"."ft_cp_actividad_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
