--------------- SQL ---------------

CREATE OR REPLACE FUNCTION pre.ft_memoria_calculo_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Presupuesto
 FUNCION: 		pre.ft_memoria_calculo_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'pre.tmemoria_calculo'
 AUTOR: 		 (admin)
 FECHA:	        01-03-2016 14:22:24
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
	v_id_memoria_calculo	integer;
    v_id_gestion			integer;
    v_registros				record;
    v_estado				varchar;
    v_gestion				integer;
    v_id_partida			integer;
			    
BEGIN

    v_nombre_funcion = 'pre.ft_memoria_calculo_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PRE_MCA_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		01-03-2016 14:22:24
	***********************************/

	if(p_transaccion='PRE_MCA_INS')then
					
        begin
        
            select 
              cc.id_gestion,
              pre.estado,
              ges.gestion
            into
              v_id_gestion,
              v_estado,
              v_gestion
            from pre.tpresupuesto pre
            inner join param.tcentro_costo cc on cc.id_centro_costo = pre.id_centro_costo
            inner join param.tgestion ges on ges.id_gestion = cc.id_gestion
            where pre.id_presupuesto = v_parametros.id_presupuesto;
            
            --raise exception 'v_gestion %', v_gestion;
        
            IF v_estado = 'aprobado' THEN
               raise exception 'No puede agregar concepto en un presupuesto aprobado';
            END IF;
            
            --recuperar gestion de lpresupeusto
            
            SELECT 
                par.id_partida
            into
               v_id_partida
            FROM pre.tpresupuesto pre 
               JOIN param.tcentro_costo cc ON cc.id_centro_costo = pre.id_centro_costo
               JOIN param.tconcepto_ingas cig ON cig.id_concepto_ingas = v_parametros.id_concepto_ingas
               JOIN pre.tconcepto_partida cp ON cp.id_concepto_ingas = v_parametros.id_concepto_ingas
               JOIN param.tgestion ges ON ges.id_gestion = cc.id_gestion
               JOIN pre.tpartida par ON par.id_partida = cp.id_partida AND
                 par.id_gestion = cc.id_gestion
           where pre.id_presupuesto = v_parametros.id_presupuesto
                 and cig.id_concepto_ingas  = v_parametros.id_concepto_ingas;
            
            
          
            
        	--Sentencia de la insercion
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
              fecha_mod,
              id_usuario_mod,
              id_partida
          	) values(
              v_parametros.id_concepto_ingas,
              0,
              v_parametros.obs,
              v_parametros.id_presupuesto,
              'activo',
              v_parametros._id_usuario_ai,
              now(),
              v_parametros._nombre_usuario_ai,
              p_id_usuario,
              null,
              null,
              v_id_partida
			
			)RETURNING id_memoria_calculo into v_id_memoria_calculo;
            
            
           -- inserta valores para todos los periodos de la gestion con valor 0
            
           FOR v_registros in (select
                                   per.id_periodo
                                from param.tperiodo per
                                where per.id_gestion = v_id_gestion 
                                      and per.estado_reg = 'activo'
                                order by per.fecha_ini) LOOP
                            
                            insert into pre.tmemoria_det(
                                importe,
                                estado_reg,
                                id_periodo,
                                id_memoria_calculo,
                                usuario_ai,
                                fecha_reg,
                                id_usuario_reg,
                                id_usuario_ai
                              ) 
                              values
                              (
                                0,
                                'activo',
                                v_registros.id_periodo,
                                v_id_memoria_calculo,
                                v_parametros._nombre_usuario_ai,
                                now(),
                                p_id_usuario,
                                v_parametros._id_usuario_ai);
			    
            END LOOP;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','MEMCAL almacenado(a) con exito (id_memoria_calculo'||v_id_memoria_calculo||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_memoria_calculo',v_id_memoria_calculo::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'PRE_MCA_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		01-03-2016 14:22:24
	***********************************/

	elsif(p_transaccion='PRE_MCA_MOD')then

		begin
            select 
              cc.id_gestion,
              pre.estado
            into
              v_registros
            from pre.tpresupuesto pre
            inner join param.tcentro_costo cc on cc.id_centro_costo = pre.id_centro_costo
            where pre.id_presupuesto = v_parametros.id_presupuesto;
           
        
            IF v_registros.estado = 'aprobado' THEN            
              --raise exception 'no puede editar  conceptos de un presupuesto aprobado';
            END IF;
            
            SELECT 
                par.id_partida
            into
               v_id_partida
            FROM pre.vpresupuesto pre 
               JOIN param.tconcepto_ingas cig ON cig.id_concepto_ingas = v_parametros.id_concepto_ingas                
               JOIN pre.tconcepto_partida cp ON cp.id_concepto_ingas = v_parametros.id_concepto_ingas
             JOIN pre.tpartida par ON par.id_partida = cp.id_partida AND
                 par.id_gestion = pre.id_gestion
           where pre.id_presupuesto = v_parametros.id_presupuesto
                 and cig.id_concepto_ingas  = v_parametros.id_concepto_ingas;
        
        
			--Sentencia de la modificacion
			update pre.tmemoria_calculo set
              id_concepto_ingas = v_parametros.id_concepto_ingas,
              obs = v_parametros.obs,
              id_presupuesto = v_parametros.id_presupuesto,
              fecha_mod = now(),
              id_usuario_mod = p_id_usuario,
              id_usuario_ai = v_parametros._id_usuario_ai,
              usuario_ai = v_parametros._nombre_usuario_ai,
              id_partida = v_id_partida
			where id_memoria_calculo = v_parametros.id_memoria_calculo;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','MEMCAL modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_memoria_calculo',v_parametros.id_memoria_calculo::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'PRE_MCA_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		01-03-2016 14:22:24
	***********************************/

	elsif(p_transaccion='PRE_MCA_ELI')then

		begin
            
            select 
              cc.id_gestion,
              pre.estado
            into
              v_registros
            from pre.tpresupuesto pre
            inner join param.tcentro_costo cc on cc.id_centro_costo = pre.id_centro_costo
            inner join pre.tmemoria_calculo m on m.id_presupuesto = pre.id_presupuesto
            where m.id_memoria_calculo=v_parametros.id_memoria_calculo;
           
        
            IF v_registros.estado = 'aprobado' THEN            
              raise exception 'no puede eliminar concpetos de un presupuesto aprobado';
            END IF;
        
             --Sentencia de la eliminacion
			delete from pre.tmemoria_det
            where id_memoria_calculo=v_parametros.id_memoria_calculo;
        
			--Sentencia de la eliminacion
			delete from pre.tmemoria_calculo
            where id_memoria_calculo=v_parametros.id_memoria_calculo;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','MEMCAL eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_memoria_calculo',v_parametros.id_memoria_calculo::varchar);
              
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