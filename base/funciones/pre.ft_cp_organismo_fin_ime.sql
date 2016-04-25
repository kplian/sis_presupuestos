CREATE OR REPLACE FUNCTION "pre"."ft_cp_organismo_fin_ime" (	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:		Sistema de Presupuesto
 FUNCION: 		pre.ft_cp_organismo_fin_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'pre.tcp_organismo_fin'
 AUTOR: 		 (admin)
 FECHA:	        19-04-2016 14:40:42
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
	v_id_cp_organismo_fin	integer;
			    
BEGIN

    v_nombre_funcion = 'pre.ft_cp_organismo_fin_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PRE_CPOF_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		19-04-2016 14:40:42
	***********************************/

	if(p_transaccion='PRE_CPOF_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into pre.tcp_organismo_fin(
			estado_reg,
			id_gestion,
			descripcion,
			codigo,
			fecha_reg,
			usuario_ai,
			id_usuario_reg,
			id_usuario_ai,
			id_usuario_mod,
			fecha_mod
          	) values(
			'activo',
			v_parametros.id_gestion,
			v_parametros.descripcion,
			v_parametros.codigo,
			now(),
			v_parametros._nombre_usuario_ai,
			p_id_usuario,
			v_parametros._id_usuario_ai,
			null,
			null
							
			
			
			)RETURNING id_cp_organismo_fin into v_id_cp_organismo_fin;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','CP Organismo de Financiamiento almacenado(a) con exito (id_cp_organismo_fin'||v_id_cp_organismo_fin||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_cp_organismo_fin',v_id_cp_organismo_fin::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'PRE_CPOF_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		19-04-2016 14:40:42
	***********************************/

	elsif(p_transaccion='PRE_CPOF_MOD')then

		begin
			--Sentencia de la modificacion
			update pre.tcp_organismo_fin set
			id_gestion = v_parametros.id_gestion,
			descripcion = v_parametros.descripcion,
			codigo = v_parametros.codigo,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_cp_organismo_fin=v_parametros.id_cp_organismo_fin;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','CP Organismo de Financiamiento modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_cp_organismo_fin',v_parametros.id_cp_organismo_fin::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'PRE_CPOF_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		19-04-2016 14:40:42
	***********************************/

	elsif(p_transaccion='PRE_CPOF_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from pre.tcp_organismo_fin
            where id_cp_organismo_fin=v_parametros.id_cp_organismo_fin;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','CP Organismo de Financiamiento eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_cp_organismo_fin',v_parametros.id_cp_organismo_fin::varchar);
              
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
ALTER FUNCTION "pre"."ft_cp_organismo_fin_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
