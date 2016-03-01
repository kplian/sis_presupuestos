--------------- SQL ---------------

CREATE OR REPLACE FUNCTION pre.ft_presup_partida_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Presupuesto
 FUNCION: 		pre.ft_presup_partida_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'pre.tpresup_partida'
 AUTOR: 		 (admin)
 FECHA:	        29-02-2016 19:40:34
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
	v_id_presup_partida		integer;
    v_registros				record;
			    
BEGIN

    v_nombre_funcion = 'pre.ft_presup_partida_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PRE_PRPA_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		29-02-2016 19:40:34
	***********************************/

	if(p_transaccion='PRE_PRPA_INS')then
					
        begin
        
        
        
           select 
             pre.estado
           into
            v_registros
           from pre.tpresupuesto pre
           where pre.id_presupuesto = v_parametros.id_presupuesto;
        
        
           --TODO aumentar una bnadera de correccion al presupuesto para añadir partidas
           IF  v_registros.estado != 'borrador' THEN
             raise exception 'Solo puede añadir partidas en presupuesto en estado borrador';
           END IF; 
        
          
           IF exists(select 1
                    from pre.tpresup_partida pp
                    where pp.id_partida = v_parametros.id_partida 
                          and pp.id_presupuesto = v_parametros.id_presupuesto
                          and pp.estado_reg = 'activo') THEN              
                raise exception 'esta aprtida ya esta relacionada con el presupuesto';            
           END IF;
        
        
        	--Sentencia de la insercion
        	insert into pre.tpresup_partida(
              id_partida,
              id_centro_costo,
              id_presupuesto,			
              id_usuario_ai,
              usuario_ai,
              estado_reg,
              fecha_reg,
              id_usuario_reg,
              id_usuario_mod,
              fecha_mod
          	) values(
              v_parametros.id_partida,
              v_parametros.id_presupuesto,		
              v_parametros.id_presupuesto,			
              v_parametros._id_usuario_ai,
              v_parametros._nombre_usuario_ai,
              'activo',
              now(),
              p_id_usuario,
              null,
              null
							
			
			
			)RETURNING id_presup_partida into v_id_presup_partida;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','PREPAR almacenado(a) con exito (id_presup_partida'||v_id_presup_partida||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_presup_partida',v_id_presup_partida::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	

	/*********************************    
 	#TRANSACCION:  'PRE_PRPA_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		29-02-2016 19:40:34
	***********************************/

	elsif(p_transaccion='PRE_PRPA_ELI')then

		begin
        
            
        
            select 
              pre.estado
            into
             v_registros
            from pre.tpresupuesto pre
            inner join pre.tpresup_partida pp on pre.id_presupuesto = pp.id_presupuesto
            where pp.id_presup_partida = v_parametros.id_presup_partida;
        
        
            --TODO aumentar una bnadera de correccion al presupuesto para añadir partidas
            IF  v_registros.estado != 'borrador' THEN
             raise exception 'Solo puede elimnar partidas en presupuesto en estado borrador';
            END IF;
           
			--Sentencia de la eliminacion
			delete from pre.tpresup_partida
            where id_presup_partida=v_parametros.id_presup_partida;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','PREPAR eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_presup_partida',v_parametros.id_presup_partida::varchar);
              
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