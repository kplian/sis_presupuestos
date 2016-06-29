--------------- SQL ---------------

CREATE OR REPLACE FUNCTION pre.ft_cp_proyecto_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Presupuesto
 FUNCION: 		pre.ft_cp_proyecto_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'pre.tcp_proyecto'
 AUTOR: 		 (admin)
 FECHA:	        19-04-2016 14:40:49
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
	v_id_cp_proyecto	integer;
			    
BEGIN

    v_nombre_funcion = 'pre.ft_cp_proyecto_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PRE_CPPROY_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		19-04-2016 14:40:49
	***********************************/

	if(p_transaccion='PRE_CPPROY_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into pre.tcp_proyecto(
			codigo,
			id_gestion,
			codigo_sisin,
			descripcion,
			estado_reg,
			id_usuario_ai,
			id_usuario_reg,
			fecha_reg,
			usuario_ai,
			fecha_mod,
			id_usuario_mod
          	) values(
			v_parametros.codigo,
			v_parametros.id_gestion,
			v_parametros.codigo_sisin,
			v_parametros.descripcion,
			'activo',
			v_parametros._id_usuario_ai,
			p_id_usuario,
			now(),
			v_parametros._nombre_usuario_ai,
			null,
			null
							
			
			
			)RETURNING id_cp_proyecto into v_id_cp_proyecto;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','CP Poryecto almacenado(a) con exito (id_cp_proyecto'||v_id_cp_proyecto||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_cp_proyecto',v_id_cp_proyecto::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'PRE_CPPROY_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		19-04-2016 14:40:49
	***********************************/

	elsif(p_transaccion='PRE_CPPROY_MOD')then

		begin
			--Sentencia de la modificacion
			update pre.tcp_proyecto set
			codigo = v_parametros.codigo,
			id_gestion = v_parametros.id_gestion,
			codigo_sisin = v_parametros.codigo_sisin,
			descripcion = v_parametros.descripcion,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario,
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_cp_proyecto=v_parametros.id_cp_proyecto;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','CP Poryecto modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_cp_proyecto',v_parametros.id_cp_proyecto::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'PRE_CPPROY_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		19-04-2016 14:40:49
	***********************************/

	elsif(p_transaccion='PRE_CPPROY_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from pre.tcp_proyecto
            where id_cp_proyecto=v_parametros.id_cp_proyecto;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','CP Poryecto eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_cp_proyecto',v_parametros.id_cp_proyecto::varchar);
              
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