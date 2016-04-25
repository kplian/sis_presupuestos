--------------- SQL ---------------

CREATE OR REPLACE FUNCTION pre.ft_rel_pre_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Presupuesto
 FUNCION: 		pre.ft_rel_pre_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'pre.trel_pre'
 AUTOR: 		 (admin)
 FECHA:	        18-04-2016 13:18:06
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
    v_registros				record;
    v_registros_mem			record;
    v_registros_memdet		record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_rel_pre			integer;
    v_id_memoria_calculo	integer;
			    
BEGIN

    v_nombre_funcion = 'pre.ft_rel_pre_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PRE_RELP_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		18-04-2016 13:18:06
	***********************************/

	if(p_transaccion='PRE_RELP_INS')then
					
        begin
        	
             --valida que el presupeusto hijo no sea parte de otro presupeusto padre
             select 
              p.codigo_cc,
              rp.id_rel_pre
            into
              v_registros            
            from pre.trel_pre rp
            inner join pre.vpresupuesto_cc p on p.id_presupuesto = rp.id_presupuesto_padre
            where rp.id_presupuesto_hijo = v_parametros.id_presupuesto_hijo
                  and rp.estado_reg = 'activo';
                  
            IF v_registros is not null THEN
                raise exception 'Este presupeusto ya es parte de %', v_registros.codigo_cc;
            END IF;
            
            
            --Sentencia de la insercion
        	insert into pre.trel_pre(
              estado,
              id_presupuesto_hijo,
              estado_reg,
              id_presupuesto_padre,
              id_usuario_ai,
              fecha_reg,
              usuario_ai,
              id_usuario_reg
              ) values(
              'borrador',
              v_parametros.id_presupuesto_hijo,
              'activo',
              v_parametros.id_presupuesto_padre,
              v_parametros._id_usuario_ai,
              now(),
              v_parametros._nombre_usuario_ai,
              p_id_usuario
		   )RETURNING id_rel_pre into v_id_rel_pre;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Relación para Consolidado almacenado(a) con exito (id_rel_pre'||v_id_rel_pre||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_rel_pre',v_id_rel_pre::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'PRE_RELP_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		18-04-2016 13:18:06
	***********************************/

	elsif(p_transaccion='PRE_RELP_MOD')then

		begin
			--Sentencia de la modificacion
			 raise exception 'nose permite editar';
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Relación para Consolidado modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_rel_pre',v_parametros.id_rel_pre::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'PRE_RELP_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		18-04-2016 13:18:06
	***********************************/

	elsif(p_transaccion='PRE_RELP_ELI')then

		begin
			
            select  
               *
            into
              v_registros
            from pre.trel_pre rp
            where rp.id_rel_pre = v_parametros.id_rel_pre;
            
            IF  v_registros.estado != 'borrador' THEN
               raise exception 'solo puede eliminar  si se encuentra en estado borrador ';
            END IF;
            
            --Sentencia de la eliminacion
			delete from pre.trel_pre
            where id_rel_pre=v_parametros.id_rel_pre;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Relación para Consolidado eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_rel_pre',v_parametros.id_rel_pre::varchar);
              
            --Devuelve la respuesta
            return v_resp;

		end;
    
    /*********************************    
 	#TRANSACCION:  'PRE_CONREL_IME'
 	#DESCRIPCION:	Consolida presupuestos no oficiales
 	#AUTOR:		rac (KPLIAN)	
 	#FECHA:		18-04-2016 13:18:06
	***********************************/

	elsif(p_transaccion='PRE_CONREL_IME')then

		begin
        
              --recupera datos de relacion
              
              select 
                 rp.id_presupuesto_padre,
                 rp.id_presupuesto_hijo,
                 rp.estado,
                 p.codigo_cc
              into
                v_registros
              from pre.trel_pre rp
              inner join pre.vpresupuesto p on rp.id_presupuesto_hijo = p.id_presupuesto
              where rp.id_rel_pre = v_parametros.id_rel_pre;
              
              
              IF v_registros.estado != 'borrador' THEN
                   raise exception 'El presupeusto ya fue consolidado';
              END IF;
  			
             
              --listar todas las memorias de calculo del presupuesto hijo
             FOR v_registros_mem in ( 
               select
                 mc.id_memoria_calculo,
                 mc.id_concepto_ingas,
                 mc.importe_total,
                 mc.id_partida,
                 mc.id_presupuesto,
                 mc.obs
              from pre.vmemoria_calculo mc
              where mc.id_presupuesto = v_registros.id_presupuesto_hijo ) LOOP
              
              
               
                     -- verifica si existe la relacion partida presupuesto
                     IF not EXISTS(select 
                                    1
                                 from pre.tpresup_partida pp
                                 where pp.id_presupuesto = v_registros.id_presupuesto_padre and
                                       pp.id_partida = v_registros_mem.id_partida and
                                       pp.estado_reg = 'activo') THEN
                           
                     
                    
                               -- si no existe insertamos la relacion presupeusto partida 
                                insert into pre.tpresup_partida(
                                  id_partida,
                                  id_centro_costo,
                                  id_presupuesto,			
                                  id_usuario_ai,
                                  usuario_ai,
                                  estado_reg,
                                  fecha_reg,
                                  id_usuario_reg
                                ) values(
                                  v_registros_mem.id_partida,
                                  v_registros.id_presupuesto_padre,		
                                  v_registros.id_presupuesto_padre,			
                                  v_parametros._id_usuario_ai,
                                  v_parametros._nombre_usuario_ai,
                                  'activo',
                                  now(),
                                  p_id_usuario);
                           
                           
                     END IF;
                        
                
                  
                     -- insertar nueva memoria de calculo relacionada con la original
                     insert into pre.tmemoria_calculo(
                        id_concepto_ingas,
                        importe_total,
                        obs,
                        id_presupuesto,
                        estado_reg,
                        id_usuario_ai,
                        fecha_reg,
                        usuario_ai,
                        id_usuario_reg,
                        id_memoria_calculo_original,
                        id_rel_pre
                      ) values(
                        v_registros_mem.id_concepto_ingas,
                        v_registros_mem.importe_total,  
                        v_registros_mem.obs || '(Consolidado de: '||v_registros.codigo_cc||')',
                        v_registros.id_presupuesto_padre,
                        'activo',
                        v_parametros._id_usuario_ai,
                        now(),
                        v_parametros._nombre_usuario_ai,
                        p_id_usuario,
                        v_registros_mem.id_memoria_calculo,
                        v_parametros.id_rel_pre
          							
          			 )RETURNING id_memoria_calculo into v_id_memoria_calculo;
                     
                    
                       --inserta el detalle de la memoria de calculo
                      FOR v_registros_memdet in ( 
                         select
                           md.id_memoria_det,
                           md.id_periodo,
                           md.importe,
                           md.cantidad_mem,
                           md.importe_unitario,
                           md.unidad_medida
                         from pre.tmemoria_det md
                         where  md.id_memoria_calculo = v_registros_mem.id_memoria_calculo
                                and md.estado_reg = 'activo' ) LOOP
                     
                    
                           insert into pre.tmemoria_det(
                                importe,
                                estado_reg,
                                id_periodo,
                                id_memoria_calculo,
                                usuario_ai,
                                fecha_reg,
                                id_usuario_reg,
                                id_usuario_ai,
                                cantidad_mem,
                                importe_unitario,
                                unidad_medid
                              ) 
                              values
                              (
                                v_registros_memdet.importe,
                                'activo',
                                v_registros_memdet.id_periodo,
                                v_id_memoria_calculo,
                                v_parametros._nombre_usuario_ai,
                                now(),
                                p_id_usuario,
                                v_parametros._id_usuario_ai,
                                v_registros_memdet.cantidad_mem,
                                v_registros_memdet.importe_unitario,
                                v_registros_memdet.unidad_medid);
                           
                    
                      END LOOP; 
                  
                   
          
            END LOOP; 
           
            -- acutlizamos estado de la relacion y fecha de union
            update pre.trel_pre r set
              estado = 'procesado',
              fecha_union = now()
            where r.id_rel_pre = v_parametros.id_rel_pre;
              
          
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','presupuesto  consolidado)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_rel_pre',v_parametros.id_rel_pre::varchar);
              
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