--------------- SQL ---------------

CREATE OR REPLACE FUNCTION pre.ft_presupuesto_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de presupuesto
 FUNCION: 		pre.ft_presupuesto_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'pre.tpresupuesto'
 AUTOR: 		Gonzalo Sarmiento Sejas
 FECHA:	        27-02-2013 00:30:39
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
	v_id_presupuesto		integer;
    v_registros_ges			record;
    v_id_gestion_destino	integer;
    v_conta 				integer;
    v_registros 			record;
    v_reg_cc_ori 			record;
    v_reg_pres		    	record;
    v_id_centro_costo 		integer;
    
    v_num_tramite			varchar;
    v_id_proceso_wf			integer;
    v_id_estado_wf			integer;
    v_codigo_estado 		varchar;
    v_codigo_wf				varchar;
			    
BEGIN

    v_nombre_funcion = 'pre.ft_presupuesto_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PRE_PRE_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		Gonzalo Sarmiento Sejas	
 	#FECHA:		27-02-2013 00:30:39
	***********************************/

	if(p_transaccion='PRE_PRE_INS')then
					
        begin
        	--Sentencia de la insercion
        	raise exception 'Para isnertar presupuesto inserte un centro de costo';
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Presupuestos almacenado(a) con exito (id_presupuesto'||v_id_presupuesto||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_presupuesto',v_id_presupuesto::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'PRE_PRE_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		Gonzalo Sarmiento Sejas	
 	#FECHA:		27-02-2013 00:30:39
	***********************************/

	elsif(p_transaccion='PRE_PRE_MOD')then

		begin
			
            select
              p.estado,
              p.tipo_pres
            into
             v_reg_pres
            from pre.tpresupuesto p
            where  p.id_presupuesto = v_parametros.id_presupuesto;
            
            IF v_reg_pres.estado != 'borrador' and v_reg_pres.tipo_pres != v_parametros.tipo_pres THEN
              raise exception 'Solo puede editar el tipo de presupuesto  en estado borrador';
            END IF;
            
            
            --Sentencia de la modificacion
			update pre.tpresupuesto set
			
			tipo_pres = v_parametros.tipo_pres,
			descripcion = v_parametros.descripcion,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario
			where id_presupuesto=v_parametros.id_presupuesto;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Presupuestos modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_presupuesto',v_parametros.id_presupuesto::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'PRE_PRE_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		Gonzalo Sarmiento Sejas	
 	#FECHA:		27-02-2013 00:30:39
	***********************************/

	elsif(p_transaccion='PRE_PRE_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from pre.tpresupuesto
            where id_presupuesto=v_parametros.id_presupuesto;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Presupuestos eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_presupuesto',v_parametros.id_presupuesto::varchar);
              
            --Devuelve la respuesta
            return v_resp;

		end;
     
    /*********************************    
 	#TRANSACCION:  'PRE_INITRA_IME'
 	#DESCRIPCION:	Iniciar tramite de presupuesto
 	#AUTOR:		Rensi Artega Copari (KPLIAN)
 	#FECHA:		02/03/2016 00:30:39
	***********************************/

	elsif(p_transaccion='PRE_INITRA_IME')then

		begin
        
                
             
                 select
                   cc.id_gestion,
                   cc.codigo_cc,
                   pre.nro_tramite
                 into
                   v_reg_pres
                 from pre.tpresupuesto pre
                 inner join param.vcentro_costo cc on cc.id_centro_costo = pre.id_presupuesto
                 where pre.id_presupuesto = v_parametros.id_presupuesto;
                 
                 
                  v_codigo_wf = pxp.f_get_variable_global('pre_wf_codigo');
                           
              IF  v_reg_pres.nro_tramite is not NULL or  v_reg_pres.nro_tramite !='' THEN
                 raise exception 'El trámite ya fue iniciado % ', v_reg_pres.nro_tramite;              
              END IF;
        
              -- obtiene numero de tramite
                 SELECT 
                       ps_num_tramite ,
                       ps_id_proceso_wf ,
                       ps_id_estado_wf ,
                       ps_codigo_estado 
                    into
                       v_num_tramite,
                       v_id_proceso_wf,
                       v_id_estado_wf,
                       v_codigo_estado   
                        
                  FROM wf.f_inicia_tramite(
                       p_id_usuario, 
                       v_parametros._id_usuario_ai,
                       v_parametros._nombre_usuario_ai,
                       v_reg_pres.id_gestion, 
                       v_codigo_wf, 
                       v_parametros.id_funcionario_usu,
                       NULL,
                       'Inicio de tramite.... ',
                       v_reg_pres.codigo_cc);
			
            
            
            update pre.tpresupuesto  p  set
               nro_tramite = v_num_tramite,
               id_estado_wf = v_id_estado_wf,
               id_proceso_wf = v_id_proceso_wf,
               estado = v_codigo_estado
            where p.id_presupuesto = v_parametros.id_presupuesto;
            
            
            
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','se inicio el tramite del presupuesto' ); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_presupuesto',v_parametros.id_presupuesto::varchar);
            
              
            --Devuelve la respuesta
            return v_resp;

		end;
    
       
    /*********************************    
 	#TRANSACCION:  'PRE_CLONARPRE_IME'
 	#DESCRIPCION:	Clona los presupeustos y centros de costos para la siguiente gestion
 	#AUTOR:	    Rensi Arteaga Copari
 	#FECHA:		04-08-2015 00:30:39
	***********************************/

	elsif(p_transaccion='PRE_CLONARPRE_IME')then

		begin
			
            -------------------------------------------------------------------
            --  REGLA, el id_centro_costo tiene que ser igual al id_presupuesto
            --------------------------------------------------------------------
            --  definir id de la gestion siguiente
    
           select
              ges.id_gestion,
              ges.gestion,
              ges.id_empresa
           into 
              v_registros_ges
           from 
           param.tgestion ges
           where ges.id_gestion = v_parametros.id_gestion;
          
          
          
           select
              ges.id_gestion
           into 
              v_id_gestion_destino
           from 
           param.tgestion ges
           where       ges.gestion = v_registros_ges.gestion + 1 
                   and ges.id_empresa = v_registros_ges.id_empresa 
                   and ges.estado_reg = 'activo';
           
          IF v_id_gestion_destino is null THEN        
                   raise exception 'no se encontró una siguiente gestión preparada (primero cree  gestión siguiente)';
          END IF;
          v_conta = 0;
            
            --clonamos presupuestos y centros de costos
            FOR v_registros in (
                                  select p.* from pre.tpresupuesto p 
                                  inner join param.tcentro_costo cc on cc.id_centro_costo = p.id_centro_costo
                                  where cc.id_gestion = v_parametros.id_gestion   
                                        and p.estado_reg = 'activo') LOOP
                    -- preguntamos si ya existe en la tabla de ids                    
                     IF NOT EXISTS ( select 1 from pre.tpresupuesto_ids i where i.id_presupuesto_uno = v_registros.id_presupuesto  )  THEN
                       
                         -- clonamos el centro de costos
                           select * into v_reg_cc_ori 
                           from param.tcentro_costo cc 
                           where cc.id_centro_costo = v_registros.id_centro_costo;
                           
                         --insertamos nuevo centro de costo  
                           INSERT INTO  param.tcentro_costo
                                      (
                                        id_usuario_reg,
                                        fecha_reg,
                                        estado_reg,
                                        id_ep,
                                        id_uo,
                                        id_gestion
                                      )
                                      VALUES (
                                        p_id_usuario,
                                        now(),
                                        'activo',
                                        v_reg_cc_ori.id_ep,
                                        v_reg_cc_ori.id_uo,
                                        v_id_gestion_destino
                                      ) RETURNING id_centro_costo into v_id_centro_costo;
                           
                       
                     --TODO revisar el estado de formualcion del presupeusto ......        OJO
                     --  insertamos nuevo presupuesto
                     INSERT INTO  pre.tpresupuesto
                                  (
                                    id_usuario_reg,                                   
                                    fecha_reg,
                                    estado_reg,
                                    id_presupuesto,
                                    id_centro_costo,
                                    tipo_pres,
                                    estado_pres,
                                    id_categoria_prog,
                                    id_parametro,
                                    id_fuente_financiamiento,
                                    id_concepto_colectivo,
                                    cod_fin,
                                    cod_prg,
                                    cod_pry,
                                    cod_act
                                  )
                                  VALUES (
                                    p_id_usuario,                                   
                                    now(),
                                    'activo',
                                    v_id_centro_costo, --id_presupeusto tiene que ser igual al id centro de costo
                                    v_id_centro_costo,
                                    v_registros.tipo_pres,
                                    v_registros.estado_pres,
                                    v_registros.id_categoria_prog,
                                    v_registros.id_parametro,
                                    v_registros.id_fuente_financiamiento,
                                    v_registros.id_concepto_colectivo,
                                    v_registros.cod_fin,
                                    v_registros.cod_prg,
                                    v_registros.cod_pry,
                                    v_registros.cod_act
                                  )RETURNING id_presupuesto into v_id_presupuesto;
                                  
                                  INSERT INTO pre.tpresupuesto_ids (id_presupuesto_uno, id_presupuesto_dos, sw_cambio_gestion ) 
                                  VALUES ( v_registros.id_presupuesto, v_id_presupuesto, 'gestion');
                                   v_conta = v_conta + 1;
                                   
                     END IF;
                                       
            END LOOP;
        
        
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Presupuestos clonados para la gestion: '||v_registros_ges.gestion::varchar); 
            v_resp = pxp.f_agrega_clave(v_resp,'observaciones','Se insertaron presupuestos: '|| v_conta::varchar);
              
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