--------------- SQL ---------------

CREATE OR REPLACE FUNCTION pre.ft_tipo_presupuesto_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Presupuesto
 FUNCION: 		pre.ft_tipo_presupuesto_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'pre.ttipo_presupuesto'
 AUTOR: 		 (admin)
 FECHA:	        29-02-2016 05:18:02
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
	v_id_tipo_presupuesto	integer;
			    
BEGIN

    v_nombre_funcion = 'pre.ft_tipo_presupuesto_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PRE_TIPR_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		29-02-2016 05:18:02
	***********************************/

	if(p_transaccion='PRE_TIPR_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into pre.ttipo_presupuesto(
			codigo,
			movimiento,
			nombre,
			descripcion,
			estado_reg,
			id_usuario_ai,
			usuario_ai,
			fecha_reg,
			id_usuario_reg,
			fecha_mod,
			id_usuario_mod,
            sw_oficial
          	) values(
			upper(trim(v_parametros.codigo)),
			v_parametros.movimiento,
			v_parametros.nombre,
			v_parametros.descripcion,
			'activo',
			v_parametros._id_usuario_ai,
			v_parametros._nombre_usuario_ai,
			now(),
			p_id_usuario,
			null,
			null,
            v_parametros.sw_oficial
							
			
			
			)RETURNING id_tipo_presupuesto into v_id_tipo_presupuesto;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','TIPO almacenado(a) con exito (id_tipo_presupuesto'||v_id_tipo_presupuesto||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_tipo_presupuesto',v_id_tipo_presupuesto::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'PRE_TIPR_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		29-02-2016 05:18:02
	***********************************/

	elsif(p_transaccion='PRE_TIPR_MOD')then

		begin
			--Sentencia de la modificacion
			update pre.ttipo_presupuesto set
              codigo = upper(trim(v_parametros.codigo)),
              movimiento = v_parametros.movimiento,
              nombre = v_parametros.nombre,
              descripcion = v_parametros.descripcion,
              fecha_mod = now(),
              id_usuario_mod = p_id_usuario,
              id_usuario_ai = v_parametros._id_usuario_ai,
              usuario_ai = v_parametros._nombre_usuario_ai,
              sw_oficial = v_parametros.sw_oficial
			where id_tipo_presupuesto=v_parametros.id_tipo_presupuesto;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','TIPO modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_tipo_presupuesto',v_parametros.id_tipo_presupuesto::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'PRE_TIPR_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		29-02-2016 05:18:02
	***********************************/

	elsif(p_transaccion='PRE_TIPR_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from pre.ttipo_presupuesto
            where id_tipo_presupuesto=v_parametros.id_tipo_presupuesto;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','TIPO eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_tipo_presupuesto',v_parametros.id_tipo_presupuesto::varchar);
              
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