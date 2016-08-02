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
    v_factor				numeric;
    v_resp_presu		    varchar;
			    
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
           IF  v_registros.estado not in  ('borrador','finalizado') THEN
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
 	#TRANSACCION:  'PRE_PRPA_MOD'
 	#DESCRIPCION:	modificacion de presupuestos y partidas
 	#AUTOR:		admin	
 	#FECHA:		29-02-2016 19:40:34
	***********************************/

	elsif(p_transaccion='PRE_PRPA_MOD')then
					
       begin
       
           update pre.tpresup_partida pp set
             importe_aprobado =  v_parametros.importe_aprobado
           where id_presup_partida  =  v_parametros.id_presup_partida;
           
           v_resp = pxp.f_agrega_clave(v_resp,'mensaje','importe aprobado modificado '||v_parametros.id_presup_partida); 
           v_resp = pxp.f_agrega_clave(v_resp,'id_presup_partida',v_parametros.id_presup_partida::varchar);
           
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
              pre.estado,
              pp.importe
            into
             v_registros
            from pre.tpresupuesto pre
            inner join pre.tpresup_partida pp on pre.id_presupuesto = pp.id_presupuesto
            where pp.id_presup_partida = v_parametros.id_presup_partida;
            
            
            --TODO aumentar una bnadera de correccion al presupuesto para añadir partidas
            IF  v_registros.estado != 'borrador' THEN
             raise exception 'Solo puede elimnar partidas en presupuesto en estado borrador';
            END IF;
        
        
            IF v_registros.importe > 0 THEN
               raise exception 'Tiene que eliminar primero las memorias de calculo asociadas a esta partida';
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
         
	/*********************************    
 	#TRANSACCION:  'PRE_PREPARVER_IME'
 	#DESCRIPCION:	VErifica seun por centaje el monto a presupuestar
 	#AUTOR:		admin	
 	#FECHA:		29-02-2016 19:40:34
	***********************************/

	elsif(p_transaccion='PRE_PREPARVER_IME')then

		begin
        
               v_factor = v_parametros.porcentaje_aprobado/100.00;
        
              --lista los presupeustos partidas
              FOR v_registros in   ( select 
                                         pp.id_presup_partida,
                                         pp.importe,
                                         pp.importe_aprobado
                                      from pre.tpresup_partida pp
                                      where pp.id_presupuesto = v_parametros.id_presupuesto) LOOP
                                      
                     update pre.tpresup_partida pp set
                        importe_aprobado = importe * v_factor
                     where pp.id_presup_partida  = v_registros.id_presup_partida;
              
              END LOOP; 
                  
                  
               -- actuliza el importe vericado
        
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','PRESUPUESTO PARTIDA VERIFICADO AL '||v_parametros.porcentaje_aprobado::Varchar||' %'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_presupuesto',v_parametros.id_presupuesto::varchar);
              
            --Devuelve la respuesta
            return v_resp;

		end;
    /*********************************    
 	#TRANSACCION:  'PRE_VERPRE_IME'
 	#DESCRIPCION:	Interface para Verificar Presupuesto
 	#AUTOR:	     Rensi ARteaga Copari
 	#FECHA:		15-08-2013 22:02:47
	***********************************/

	elsif(p_transaccion='PRE_VERPRE_IME')then

		begin
			
           v_resp_presu =    pre.f_verificar_presupuesto_partida ( v_parametros.id_presupuesto,
            									v_parametros.id_partida,
                                                v_parametros.id_moneda,
                                                v_parametros.monto_total);
                                                
          
         
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Presupuesto verificado)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'presu_verificado',v_resp_presu);
              
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