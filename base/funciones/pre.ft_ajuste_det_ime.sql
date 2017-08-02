--------------- SQL ---------------

CREATE OR REPLACE FUNCTION pre.ft_ajuste_det_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Presupuesto
 FUNCION: 		pre.ft_ajuste_det_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'pre.tajuste_det'
 AUTOR: 		 (admin)
 FECHA:	        13-04-2016 13:51:41
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
	v_id_ajuste_det	integer;
			    
BEGIN

    v_nombre_funcion = 'pre.ft_ajuste_det_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PRE_AJD_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		13-04-2016 13:51:41
	***********************************/

	if(p_transaccion='PRE_AJD_INS')then
					
        begin
        
            IF v_parametros.tipo_ajuste = 'incremento' THEN
              IF v_parametros.importe <= 0 THEN
                   RAISE EXCEPTION 'en incrementos el importe tiene que ser mayor a cero';
              END IF;
            
            ELSE
              IF v_parametros.importe >= 0 THEN
                   RAISE EXCEPTION 'en decrementos el importe tiene que ser menor a cero';
              END IF;
            END IF;
            
            
        	--Sentencia de la insercion
        	insert into pre.tajuste_det(
                id_presupuesto,
    			importe,
                id_partida,
                estado_reg,
                tipo_ajuste,
                id_usuario_ai,
                fecha_reg,
                usuario_ai,
                id_usuario_reg,
                fecha_mod,
                id_usuario_mod,
                id_ajuste
          	) values(
                v_parametros.id_presupuesto,
                v_parametros.importe,
                v_parametros.id_partida,
                'activo',
                v_parametros.tipo_ajuste,
                v_parametros._id_usuario_ai,
                now(),
                v_parametros._nombre_usuario_ai,
                p_id_usuario,
                null,
                null,
                v_parametros.id_ajuste
		  )RETURNING id_ajuste_det into v_id_ajuste_det;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Detalle del Ajuste almacenado(a) con exito (id_ajuste_det'||v_id_ajuste_det||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_ajuste_det',v_id_ajuste_det::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'PRE_AJD_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		13-04-2016 13:51:41
	***********************************/

	elsif(p_transaccion='PRE_AJD_MOD')then

		begin
			--Sentencia de la modificacion
			update pre.tajuste_det set
			id_presupuesto = v_parametros.id_presupuesto,
			importe = v_parametros.importe,
			id_partida = v_parametros.id_partida,
			tipo_ajuste = v_parametros.tipo_ajuste,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario,
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
            where id_ajuste_det=v_parametros.id_ajuste_det;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Detalle del Ajuste modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_ajuste_det',v_parametros.id_ajuste_det::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'PRE_AJD_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		13-04-2016 13:51:41
	***********************************/

	elsif(p_transaccion='PRE_AJD_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from pre.tajuste_det
            where id_ajuste_det=v_parametros.id_ajuste_det;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Detalle del Ajuste eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_ajuste_det',v_parametros.id_ajuste_det::varchar);
              
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