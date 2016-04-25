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
    v_id_depto				integer;
    v_obs					varchar;
    v_id_estado_actual		integer;
    v_id_tipo_estado		integer;
    v_codigo_estado_siguiente			varchar;
    v_registros_proc 					record;
    v_codigo_tipo_pro   				varchar;
    v_operacion 						varchar;
    v_registros_pp 						record;
    v_id_funcionario  					integer;
    v_id_usuario_reg  					integer;
    v_id_estado_wf_ant  				integer;
    v_acceso_directo 					varchar;
    v_clase 							varchar;
    v_parametros_ad 					varchar;
    v_tipo_noti 						varchar;
    v_titulo  							varchar;
    
    
			    
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
        	raise exception 'Para insertar presupuesto inserte un centro de costo';
			
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
              sw_consolidado = v_parametros.sw_consolidado,
              id_categoria_prog = v_parametros.id_categoria_prog,
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
    /*********************************    
 	#TRANSACCION:  'PRE_SIGESTP_IME'
 	#DESCRIPCION:  cambia al siguiente estado	
 	#AUTOR:		RAC	
 	#FECHA:		04-03-2016 12:12:51
	***********************************/

	elseif(p_transaccion='PRE_SIGESTP_IME')then   
        begin
        
         /*   PARAMETROS
         
        $this->setParametro('id_proceso_wf_act','id_proceso_wf_act','int4');
        $this->setParametro('id_tipo_estado','id_tipo_estado','int4');
        $this->setParametro('id_funcionario_wf','id_funcionario_wf','int4');
        $this->setParametro('id_depto_wf','id_depto_wf','int4');
        $this->setParametro('obs','obs','text');
        $this->setParametro('json_procesos','json_procesos','text');
        */
        
        --obtenermos datos basicos
          select
              p.id_proceso_wf,
              p.id_estado_wf,
              p.estado
              
             into
              v_id_proceso_wf,
              v_id_estado_wf,
              v_codigo_estado
              
          from pre.tpresupuesto p
          where p.id_presupuesto = v_parametros.id_presupuesto;
          
          --------------------------------------------
          --  validamos que el presupeusto tenga por 
          --  lo menos una partida asignada
          --------------------------------------------
          IF not EXISTS(
                        select 1
                        from pre.tpresup_partida pp
                        where     pp.estado_reg = 'activo'  
                              and pp.id_presupuesto = v_parametros.id_presupuesto) THEN
              
              raise exception 'Por lo menos necesita asignar una partida para formulación';
          END IF;
         
         
         
          -- recupera datos del estado
         
           select 
            ew.id_tipo_estado ,
            te.codigo
           into 
            v_id_tipo_estado,
            v_codigo_estado
          from wf.testado_wf ew
          inner join wf.ttipo_estado te on te.id_tipo_estado = ew.id_tipo_estado
          where ew.id_estado_wf = v_parametros.id_estado_wf_act;
        
         
          
           -- obtener datos tipo estado
           select
                 te.codigo
            into
                 v_codigo_estado_siguiente
           from wf.ttipo_estado te
           where te.id_tipo_estado = v_parametros.id_tipo_estado;
                
           IF  pxp.f_existe_parametro(p_tabla,'id_depto_wf') THEN
              v_id_depto = v_parametros.id_depto_wf;
           END IF;
                
           IF  pxp.f_existe_parametro(p_tabla,'obs') THEN
                  v_obs=v_parametros.obs;
           ELSE
                  v_obs='---';
           END IF;
            
           ---------------------------------------
           -- REGISTA EL SIGUIENTE ESTADO DEL WF.
           ---------------------------------------
            
           v_id_estado_actual =  wf.f_registra_estado_wf(  v_parametros.id_tipo_estado, 
                                                           v_parametros.id_funcionario_wf, 
                                                           v_parametros.id_estado_wf_act, 
                                                           v_id_proceso_wf,
                                                           p_id_usuario,
                                                           v_parametros._id_usuario_ai,
                                                           v_parametros._nombre_usuario_ai,
                                                           v_id_depto,
                                                           v_obs);
                                                             
          --------------------------------------
          -- registra los procesos disparados
          --------------------------------------
         
          FOR v_registros_proc in ( select * from json_populate_recordset(null::wf.proceso_disparado_wf, v_parametros.json_procesos::json)) LOOP
    
               -- get cdigo tipo proceso
               select   
                  tp.codigo 
               into 
                  v_codigo_tipo_pro   
               from wf.ttipo_proceso tp 
               where  tp.id_tipo_proceso =  v_registros_proc.id_tipo_proceso_pro;
          
          
              -- disparar creacion de procesos seleccionados
              SELECT
                       ps_id_proceso_wf,
                       ps_id_estado_wf,
                       ps_codigo_estado
                 into
                       v_id_proceso_wf,
                       v_id_estado_wf,
                       v_codigo_estado
              FROM wf.f_registra_proceso_disparado_wf(
                       p_id_usuario,
                       v_parametros._id_usuario_ai,
                       v_parametros._nombre_usuario_ai,
                       v_id_estado_actual, 
                       v_registros_proc.id_funcionario_wf_pro, 
                       v_registros_proc.id_depto_wf_pro,
                       v_registros_proc.obs_pro,
                       v_codigo_tipo_pro,    
                       v_codigo_tipo_pro);
                       
                       
           END LOOP; 
           
           
           
          --------------------------------------------------
          --  ACTUALIZA EL NUEVO ESTADO DEL PRESUPUESTO
          ----------------------------------------------------
               
           
          IF  pre.f_fun_inicio_presupuesto_wf(p_id_usuario, 
           									v_parametros._id_usuario_ai, 
                                            v_parametros._nombre_usuario_ai, 
                                            v_id_estado_actual, 
                                            v_id_proceso_wf, 
                                            v_codigo_estado_siguiente) THEN
          
                                              
          END IF;
          
         
             
          -- si hay mas de un estado disponible  preguntamos al usuario
          v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Se realizo el cambio de estado del presupuesto id='||v_parametros.id_presupuesto); 
          v_resp = pxp.f_agrega_clave(v_resp,'operacion','cambio_exitoso');
          
          
          -- Devuelve la respuesta
          return v_resp;
        
     end;  


	/*********************************    
 	#TRANSACCION:  'PR_ANTEPR_IME'
 	#DESCRIPCION: retrocede el estado de presupuestos
 	#AUTOR:		RAC	
 	#FECHA:		19-02-2016 12:12:51
	***********************************/

	elseif(p_transaccion='PR_ANTEPR_IME')then   
        begin
        
        v_operacion = 'anterior';
        
        IF  pxp.f_existe_parametro(p_tabla , 'estado_destino')  THEN
           v_operacion = v_parametros.estado_destino;
        END IF;
        
      
        
        --obtenermos datos basicos
        select
            pp.id_presupuesto,
            pp.id_proceso_wf,
            pp.estado,
            pwf.id_tipo_proceso
        into 
            v_registros_pp
            
        from pre.tpresupuesto  pp
        inner  join wf.tproceso_wf pwf  on  pwf.id_proceso_wf = pp.id_proceso_wf
        where pp.id_proceso_wf  = v_parametros.id_proceso_wf;
        
        
        IF v_registros_pp.estado = 'aprobado' THEN
            raise exception 'El presupuesto ya se encuentra aprobado, solo puede modificar a traves de la interface de ajustes presupuestarios';
        END IF;
        
        
        v_id_proceso_wf = v_registros_pp.id_proceso_wf;
        
        IF  v_operacion = 'anterior' THEN
            --------------------------------------------------
            --Retrocede al estado inmediatamente anterior
            -------------------------------------------------
           --recuperaq estado anterior segun Log del WF
              SELECT  
             
                 ps_id_tipo_estado,
                 ps_id_funcionario,
                 ps_id_usuario_reg,
                 ps_id_depto,
                 ps_codigo_estado,
                 ps_id_estado_wf_ant
              into
                 v_id_tipo_estado,
                 v_id_funcionario,
                 v_id_usuario_reg,
                 v_id_depto,
                 v_codigo_estado,
                 v_id_estado_wf_ant 
              FROM wf.f_obtener_estado_ant_log_wf(v_parametros.id_estado_wf);
              
              
             
              
              
        ELSE
           --recupera el estado inicial
           -- recuperamos el estado inicial segun tipo_proceso
             
             SELECT  
               ps_id_tipo_estado,
               ps_codigo_estado
             into
               v_id_tipo_estado,
               v_codigo_estado
             FROM wf.f_obtener_tipo_estado_inicial_del_tipo_proceso(v_registros_pp.id_tipo_proceso);
             
             
             
             --busca en log e estado de wf que identificamos como el inicial
             SELECT 
               ps_id_funcionario,
              ps_id_depto
             into
              v_id_funcionario,
             v_id_depto
               
                
             FROM wf.f_obtener_estado_segun_log_wf(v_id_estado_wf, v_id_tipo_estado);
             
            
        
        
        END IF; 
          
          
          
         --configurar acceso directo para la alarma   
             v_acceso_directo = '';
             v_clase = '';
             v_parametros_ad = '';
             v_tipo_noti = 'notificacion';
             v_titulo  = 'Visto Bueno';
             
           
           IF   v_codigo_estado_siguiente not in('borrador','formulacion','vobopre','aprobado','anulado')   THEN
                  v_acceso_directo = '../../../sis_presupuestos/vista/presupuesto/PresupuestoVb.php';
                 v_clase = 'PresupuestoVb';
                 v_parametros_ad = '{filtro_directo:{campo:"pre.id_proceso_wf",valor:"'||v_id_proceso_wf::varchar||'"}}';
                 v_tipo_noti = 'notificacion';
                 v_titulo  = 'Visto Bueno';
             
           END IF;
             
          
          -- registra nuevo estado
                      
          v_id_estado_actual = wf.f_registra_estado_wf(
              v_id_tipo_estado,                --  id_tipo_estado al que retrocede
              v_id_funcionario,                --  funcionario del estado anterior
              v_parametros.id_estado_wf,       --  estado actual ...
              v_id_proceso_wf,                 --  id del proceso actual
              p_id_usuario,                    -- usuario que registra
              v_parametros._id_usuario_ai,
              v_parametros._nombre_usuario_ai,
              v_id_depto,                       --depto del estado anterior
              '[RETROCESO] '|| v_parametros.obs,
              v_acceso_directo,
              v_clase,
              v_parametros_ad,
              v_tipo_noti,
              v_titulo);
                      
              IF  not pre.f_fun_regreso_presupuesto_wf(p_id_usuario, 
                                                   v_parametros._id_usuario_ai, 
                                                   v_parametros._nombre_usuario_ai, 
                                                   v_id_estado_actual, 
                                                   v_parametros.id_proceso_wf, 
                                                   v_codigo_estado) THEN
            
               raise exception 'Error al retroceder estado';
            
            END IF;              
                         
                         
         -- si hay mas de un estado disponible  preguntamos al usuario
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Se realizo el cambio de estado)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'operacion','cambio_exitoso');
                        
                              
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