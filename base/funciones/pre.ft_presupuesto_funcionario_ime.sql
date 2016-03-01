--------------- SQL ---------------

CREATE OR REPLACE FUNCTION pre.ft_presupuesto_funcionario_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Presupuesto
 FUNCION: 		pre.ft_presupuesto_funcionario_ime
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
	v_id_presupuesto_funcionario	integer;
			    
BEGIN

    v_nombre_funcion = 'pre.ft_presupuesto_funcionario_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PRE_PREFUN_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		29-02-2016 03:25:38
	***********************************/

	if(p_transaccion='PRE_PREFUN_INS')then
					
        begin
        
        
             IF exists(select 
                      1
                     from pre.tpresupuesto_funcionario pf
                     where  pf.id_funcionario = v_parametros.id_funcionario
                           and pf.estado_reg = 'activo'
                           and pf.id_presupuesto = v_parametros.id_presupuesto) THEN
                raise exception 'El funcionario ya se encuentra registrado para este presupuesto';   
             END IF;
        
        
        	--Sentencia de la insercion
        	insert into pre.tpresupuesto_funcionario(
              estado_reg,
              accion,
              id_funcionario,
              id_presupuesto,
              id_usuario_reg,
              fecha_reg,
              usuario_ai,
              id_usuario_ai,
              id_usuario_mod,
              fecha_mod
          	) values(
			'activo',
			v_parametros.accion,
			v_parametros.id_funcionario,
			v_parametros.id_presupuesto,
			p_id_usuario,
			now(),
			v_parametros._nombre_usuario_ai,
			v_parametros._id_usuario_ai,
			null,
			null
							
			
			
			)RETURNING id_presupuesto_funcionario into v_id_presupuesto_funcionario;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','funcionario presupuesto almacenado(a) con exito (id_presupuesto_funcionario'||v_id_presupuesto_funcionario||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_presupuesto_funcionario',v_id_presupuesto_funcionario::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'PRE_PREFUN_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		29-02-2016 03:25:38
	***********************************/

	elsif(p_transaccion='PRE_PREFUN_MOD')then

		begin
            
            IF exists(select 
                      1
                     from pre.tpresupuesto_funcionario pf
                     where  pf.id_funcionario = v_parametros.id_funcionario
                           and pf.estado_reg = 'activo'
                           and pf.id_presupuesto = v_parametros.id_presupuesto
                           and   pf.id_presupuesto_funcionario != v_parametros.id_presupuesto_funcionario ) THEN
                raise exception 'El funcionario ya se encuentra registrado para este presupuesto';   
             END IF;
        
        
			--Sentencia de la modificacion
			update pre.tpresupuesto_funcionario set
                accion = v_parametros.accion,
                id_funcionario = v_parametros.id_funcionario,
                id_presupuesto = v_parametros.id_presupuesto,
                id_usuario_mod = p_id_usuario,
                fecha_mod = now(),
                id_usuario_ai = v_parametros._id_usuario_ai,
                usuario_ai = v_parametros._nombre_usuario_ai
			where id_presupuesto_funcionario=v_parametros.id_presupuesto_funcionario;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Funcionario presupuesto modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_presupuesto_funcionario',v_parametros.id_presupuesto_funcionario::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'PRE_PREFUN_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		29-02-2016 03:25:38
	***********************************/

	elsif(p_transaccion='PRE_PREFUN_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from pre.tpresupuesto_funcionario
            where id_presupuesto_funcionario=v_parametros.id_presupuesto_funcionario;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Funcionario presupeusto  eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_presupuesto_funcionario',v_parametros.id_presupuesto_funcionario::varchar);
              
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