--------------- SQL ---------------

CREATE OR REPLACE FUNCTION pre.ft_presupuesto_usuario_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Presupuesto
 FUNCION: 		pre.ft_presupuesto_usuario_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'pre.tpresupuesto_usuario'
 AUTOR: 		 (admin)
 FECHA:	        29-02-2016 03:25:38
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
	v_id_presupuesto_usuario	integer;
			    
BEGIN

    v_nombre_funcion = 'pre.ft_presupuesto_usuario_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PRE_PREUS_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		29-02-2016 03:25:38
	***********************************/

	if(p_transaccion='PRE_PREUS_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into pre.tpresupuesto_usuario(
              estado_reg,
              accion,
              id_usuario,
              id_presupuesto,
              id_usuario_reg,
              fecha_reg,
              usuario_ai,
              id_usuario_ai,
              id_usuario_mod,
              fecha_mod
          	) values(
			'activo',
			string_to_array(v_parametros.accion,','),
			v_parametros.id_usuario,
			v_parametros.id_presupuesto,
			p_id_usuario,
			now(),
			v_parametros._nombre_usuario_ai,
			v_parametros._id_usuario_ai,
			null,
			null
							
			
			
			)RETURNING id_presupuesto_usuario into v_id_presupuesto_usuario;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Usuario almacenado(a) con exito (id_presupuesto_usuario'||v_id_presupuesto_usuario||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_presupuesto_usuario',v_id_presupuesto_usuario::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'PRE_PREUS_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		29-02-2016 03:25:38
	***********************************/

	elsif(p_transaccion='PRE_PREUS_MOD')then

		begin
			--Sentencia de la modificacion
			update pre.tpresupuesto_usuario set
			accion = string_to_array(v_parametros.accion,','),
			id_usuario = v_parametros.id_usuario,
			id_presupuesto = v_parametros.id_presupuesto,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_presupuesto_usuario=v_parametros.id_presupuesto_usuario;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Usuario modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_presupuesto_usuario',v_parametros.id_presupuesto_usuario::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'PRE_PREUS_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		29-02-2016 03:25:38
	***********************************/

	elsif(p_transaccion='PRE_PREUS_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from pre.tpresupuesto_usuario
            where id_presupuesto_usuario=v_parametros.id_presupuesto_usuario;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Usuario eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_presupuesto_usuario',v_parametros.id_presupuesto_usuario::varchar);
              
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