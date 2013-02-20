CREATE OR REPLACE FUNCTION "pre"."f_concepto_ingas_ime" (	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:		Sistema de presupuesto
 FUNCION: 		pre.f_concepto_ingas_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'pre.tconcepto_ingas'
 AUTOR: 		Gonzalo Sarmiento Sejas
 FECHA:	        18-02-2013 21:30:07
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
	v_id_concepto_ingas	integer;
			    
BEGIN

    v_nombre_funcion = 'pre.f_concepto_ingas_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PRE_CINGAS_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		Gonzalo Sarmiento Sejas	
 	#FECHA:		18-02-2013 21:30:07
	***********************************/

	if(p_transaccion='PRE_CINGAS_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into pre.tconcepto_ingas(
			estado_reg,
			id_servicio,
			id_oec,
			id_item,
			tipo,
			sw_tesoro,
			desc_ingas,
			fecha_reg,
			id_usuario_reg,
			fecha_mod,
			id_usuario_mod
          	) values(
			'activo',
			v_parametros.id_servicio,
			v_parametros.id_oec,
			v_parametros.id_item,
			v_parametros.tipo,
			v_parametros.sw_tesoro,
			v_parametros.desc_ingas,
			now(),
			p_id_usuario,
			null,
			null
							
			)RETURNING id_concepto_ingas into v_id_concepto_ingas;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Concepto ingas almacenado(a) con exito (id_concepto_ingas'||v_id_concepto_ingas||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_concepto_ingas',v_id_concepto_ingas::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'PRE_CINGAS_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		Gonzalo Sarmiento Sejas	
 	#FECHA:		18-02-2013 21:30:07
	***********************************/

	elsif(p_transaccion='PRE_CINGAS_MOD')then

		begin
			--Sentencia de la modificacion
			update pre.tconcepto_ingas set
			id_servicio = v_parametros.id_servicio,
			id_oec = v_parametros.id_oec,
			id_item = v_parametros.id_item,
			tipo = v_parametros.tipo,
			sw_tesoro = v_parametros.sw_tesoro,
			desc_ingas = v_parametros.desc_ingas,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario
			where id_concepto_ingas=v_parametros.id_concepto_ingas;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Concepto ingas modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_concepto_ingas',v_parametros.id_concepto_ingas::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'PRE_CINGAS_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		Gonzalo Sarmiento Sejas	
 	#FECHA:		18-02-2013 21:30:07
	***********************************/

	elsif(p_transaccion='PRE_CINGAS_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from pre.tconcepto_ingas
            where id_concepto_ingas=v_parametros.id_concepto_ingas;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Concepto ingas eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_concepto_ingas',v_parametros.id_concepto_ingas::varchar);
              
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
ALTER FUNCTION "pre"."f_concepto_ingas_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
