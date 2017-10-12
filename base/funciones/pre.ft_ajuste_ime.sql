--------------- SQL ---------------

CREATE OR REPLACE FUNCTION pre.ft_ajuste_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Presupuesto
 FUNCION: 		pre.ft_ajuste_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'pre.tajuste'
 AUTOR: 		RAC (KPLIAN)
 FECHA:	        13-04-2016 13:21:12
 COMENTARIOS:	
***************************************************************************
HISTORIAL DE MODIFICACIONES:

   	
 ISSUE            FECHA:		      AUTOR       DESCRIPCION
 0                10/10/2017        RAC        Consirerar inserciones de ajustes de comprometido en PRE_AJU_INS
 0                12/10/2017        RAC        validar inc y rev de comproemtido al cambiar de estado en  PRE_SIGAJT_IME
***************************************************************************/

DECLARE

	v_nro_requerimiento  		  	integer;
	v_parametros      		     	record;
	v_id_requerimiento 		    	integer;
	v_resp		    		        varchar;
	v_nombre_funcion 		        text;
	v_mensaje_error  		        text;
	v_id_ajuste						integer;
    v_id_gestion					integer;
    v_codigo_tipo_proceso			varchar;
    v_id_proceso_macro				integer;
    v_num_tramite					varchar;
    v_id_proceso_wf					integer;
    v_id_estado_wf					integer;
    v_codigo_estado   				varchar;
    v_resp_doc 						boolean;
    v_id_tipo_estado				integer;
    v_codigo_estado_siguiente		varchar;
    v_id_depto 						integer;
    v_obs							varchar;
    v_id_estado_actual 				integer;
    v_registros_proc      	     	record;
    v_codigo_tipo_pro   			varchar;
    v_id_funcionario				integer;
    v_operacion 					varchar;
    v_registros_pp					record;
    v_id_usuario_reg				integer;
    v_id_estado_wf_ant 				integer;
    v_acceso_directo 				varchar;
    v_clase 						varchar;
    v_parametros_ad 				varchar;
    v_tipo_noti 					varchar;
    v_titulo  						varchar;
    v_total_incrementos				numeric;
    v_total_decrementos				numeric;
    va_id_partida					integer[];
    v_id_moneda						integer;
			    
BEGIN

    v_nombre_funcion = 'pre.ft_ajuste_ime';
    v_parametros = pxp.f_get_record(p_tabla);
    
   

	/*********************************    
 	#TRANSACCION:  'PRE_AJU_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		RAC	
 	#FECHA:		13-04-2016 13:21:12
	***********************************/

	if(p_transaccion = 'PRE_AJU_INS')then
					
        begin
        
         -- determina la gestion segun fecha
        
           select 
               per.id_gestion 
             into 
                v_id_gestion 
            from
              param.tperiodo per 
              where per.fecha_ini <= v_parametros.fecha
               and per.fecha_fin >=  v_parametros.fecha
               and per.estado_reg = 'activo'
               limit 1 offset 0;
        	
          --obtener el codigo del tipo de proceso
          
          select   
               tp.codigo, 
               pm.id_proceso_macro 
            into 
               v_codigo_tipo_proceso, 
               v_id_proceso_macro
          from  wf.tproceso_macro pm  
          inner join wf.ttipo_proceso tp on tp.id_proceso_macro = pm.id_proceso_macro
          inner join segu.tsubsistema s on s.id_subsistema = pm.id_subsistema
          where   tp.estado_reg = 'activo' 
                  and tp.inicio = 'si'
                  and pm.codigo = 'AJT'
                  and s.codigo = 'PRE';
                  
                  
         IF  v_parametros.importe_ajuste is null or  v_parametros.importe_ajuste <=0 THEN
            raise exception 'Tiene que definir un importe a ajustar mayor a cero';
         END IF;         
                  
                  
         IF v_codigo_tipo_proceso is NULL THEN
           raise exception 'No existe un proceso inicial para el proceso macro indicado (Revise la configuración)';
         END IF;
         
         --recuperamos la moenda del tramite en partida ejecucion
         IF  v_parametros.tipo_ajuste in ('inc_comprometido','rev_comprometido') and  v_parametros.nro_tramite_aux is not null and v_parametros.nro_tramite_aux != ''THEN
            select               
               pe.id_moneda
            into
              v_id_moneda
            from pre.tpartida_ejecucion pe
            where pe.nro_tramite = v_parametros.nro_tramite_aux
            limit 1 offset 0;
         ELSE   
            v_id_moneda = param.f_get_moneda_base();
         END IF;
         
          
         -- Sentencia de la insercion
        	insert into pre.tajuste(
              estado_reg,
              estado,
              justificacion,
              tipo_ajuste,
              id_usuario_reg,
              fecha_reg,
              usuario_ai,
              id_usuario_ai,
              fecha,
              id_gestion,
              importe_ajuste,
              movimiento,
              id_moneda
          	) values(              
              'activo',
              'borrador',
              v_parametros.justificacion,
              v_parametros.tipo_ajuste,
              p_id_usuario,
              now(),
              v_parametros._nombre_usuario_ai,
              v_parametros._id_usuario_ai,
              v_parametros.fecha,
              v_id_gestion,
              v_parametros.importe_ajuste,
              v_parametros.movimiento,
              v_id_moneda
		  )RETURNING id_ajuste into v_id_ajuste;
            
        -- iniciar el tramite en el sistema de WF
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
             v_id_gestion, 
             v_codigo_tipo_proceso, 
             NULL,
             NULL,
             'Inicio de  '|| v_parametros.tipo_ajuste,
             '',
             v_parametros.nro_tramite_aux);
        
          -- UPDATE DATOS wf
        
          UPDATE pre.tajuste  SET
             nro_tramite = v_num_tramite,
             id_proceso_wf = v_id_proceso_wf,
             id_estado_wf = v_id_estado_wf,
             estado = v_codigo_estado
          WHERE id_ajuste = v_id_ajuste;
          
          -- inserta documentos en estado borrador si estan configurados
           v_resp_doc =  wf.f_inserta_documento_wf(p_id_usuario, v_id_proceso_wf, v_id_estado_wf);
           
           -- verificar documentos
           v_resp_doc = wf.f_verifica_documento(p_id_usuario, v_id_estado_wf); 
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Ajustes almacenado(a) con exito (id_ajuste'||v_id_ajuste||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_ajuste',v_id_ajuste::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'PRE_AJU_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		13-04-2016 13:21:12
	***********************************/

	elsif(p_transaccion='PRE_AJU_MOD')then

		begin
			
            select
              a.id_ajuste,
              a.estado,
              a.movimiento,
              a.tipo_ajuste,
              a.id_gestion,
              nro_tramite
            into
             v_registros_proc
            from pre.tajuste  a
            where  a.id_ajuste = v_parametros.id_ajuste;
            
            IF v_registros_proc.estado != 'borrador' THEN
                 raise exception 'Solo puede editar ajuste  en borrador';  
            END IF;
            
            
            --no peudes cambiar el tipo de ajuste
            IF v_registros_proc.tipo_ajuste !=  v_parametros.tipo_ajuste THEN 
              raise exception 'No peude cambiar el tipo de ajuste';            
            END IF;
            
            IF v_registros_proc.tipo_ajuste in('inc_comprometido','rev_comprometido') THEN 
               IF v_registros_proc.nro_tramite !=  v_parametros.nro_tramite_aux THEN 
                    raise exception 'No peude cambiar el Nro de trámite';            
               END IF;         
            END IF;
            
            
            --El tipo de ajuste y el movieminto solo pueden editarse si que no existe detalle
            
            IF v_registros_proc.tipo_ajuste  != v_parametros.tipo_ajuste or v_registros_proc.movimiento  != v_parametros.movimiento THEN
              --revisar si existe detalle
              IF  EXISTS( select 1 from pre.tajuste_det a where a.id_ajuste = v_parametros.id_ajuste and a.estado_reg = 'activo') THEN
                 raise exception 'No puede modificar el tipo de ajuste ni el movimiento si tiene detalle, primero elimine los detalles existentes';
              END IF;
            
            END IF;
            
            
            select 
               per.id_gestion 
             into 
                v_id_gestion 
            from
              param.tperiodo per 
              where per.fecha_ini <= v_parametros.fecha
               and per.fecha_fin >=  v_parametros.fecha
               and per.estado_reg = 'activo'
               limit 1 offset 0;
            
            IF v_registros_proc.id_gestion != v_id_gestion THEN
                raise exception 'no puede cambiar de gestión';
            END IF;
            
             
            IF  v_parametros.importe_ajuste is null or  v_parametros.importe_ajuste <=0 THEN
                raise exception 'Tiene que definir un importe a ajustar mayor a cero';
            END IF; 
            
            --Sentencia de la modificacion
			update pre.tajuste set
                justificacion = v_parametros.justificacion,
                tipo_ajuste = v_parametros.tipo_ajuste,
                id_usuario_mod = p_id_usuario,
                fecha_mod = now(),
                id_usuario_ai = v_parametros._id_usuario_ai,
                usuario_ai = v_parametros._nombre_usuario_ai,
                importe_ajuste = v_parametros.importe_ajuste,
                movimiento = v_parametros.movimiento
			where id_ajuste = v_parametros.id_ajuste;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Ajuste modificado'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_ajuste',v_parametros.id_ajuste::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'PRE_AJU_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		13-04-2016 13:21:12
	***********************************/

	elsif(p_transaccion='PRE_AJU_ELI')then

		begin
        
            select
              a.id_ajuste,
              a.estado
            into
             v_registros_proc
            from pre.tajuste  a
            where  a.id_ajuste = v_parametros.id_ajuste;
            
            
            IF v_registros_proc.estado != 'borrador' THEN            
                raise exception 'Solo puede eliminar ajustes en borrador';
            END IF;
            
            --elima los detalles
            delete from pre.tajuste_det
            where id_ajuste=v_parametros.id_ajuste; 
            
			--Sentencia de la eliminacion
			delete from pre.tajuste
            where id_ajuste=v_parametros.id_ajuste;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Ajuste eliminado'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_ajuste',v_parametros.id_ajuste::varchar);
              
            --Devuelve la respuesta
            return v_resp;

		end;
         
	/*********************************    
 	#TRANSACCION:  'PRE_SIGAJT_IME'
 	#DESCRIPCION:  cambia al siguiente estado del ajuste presupeustario	
 	#AUTOR:		RAC	
 	#FECHA:		13-04-2016 12:12:51
	***********************************/

	elseif(p_transaccion='PRE_SIGAJT_IME')then   
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
              a.id_proceso_wf,
              a.id_estado_wf,
              a.estado,
              a.tipo_ajuste,
              a.id_ajuste,
              a.importe_ajuste
              
             into
              v_registros_proc
             
              
          from pre.tajuste a
          where a.id_ajuste = v_parametros.id_ajuste;
          
          v_id_proceso_wf = v_registros_proc.id_proceso_wf;
          v_id_estado_wf = v_registros_proc.id_estado_wf;
          v_codigo_estado = v_registros_proc.estado;
          
          
          --TODO VALIDACIONES
          -- si el estado es borrador, validar el detalle segun el tipo de ajuste
          IF v_codigo_estado in ('borrador','revision') THEN
          
                 -- suma los incrementos
                
                 select 
                   sum(a.importe)
                 into
                   v_total_incrementos 
                 from pre.tajuste_det a
                 where a.id_ajuste = v_registros_proc.id_ajuste 
                       and a.tipo_ajuste = 'incremento' 
                       and a.estado_reg = 'activo';
                 
                 v_total_incrementos = COALESCE(v_total_incrementos  ,0);
                       
                 --suma decrementos
                 select 
                    sum(a.importe)
                 into
                    v_total_decrementos 
                 from pre.tajuste_det a
                 where a.id_ajuste = v_registros_proc.id_ajuste 
                       and a.tipo_ajuste = 'decremento' 
                       and a.estado_reg = 'activo';
                       
                       
                 v_total_decrementos  =  COALESCE(v_total_decrementos ,0);         
          
                -----------------------
                --  VALIDACIONES
                ------------------------
          
                 -- si es traspaso
                 IF v_registros_proc.tipo_ajuste = 'traspaso'  THEN
                     
                     IF v_registros_proc.importe_ajuste !=  v_total_incrementos THEN
                        raise exception 'los incrementos no igualan con el monto a ajustar';
                     END IF;
                     
                     -- validar que el monto de incremento iguala al monto del decremento
                     
                     IF (v_total_decrementos*-1) !=  v_total_incrementos THEN
                        raise exception 'los incrementos deben ser proporcionales a los decrementos';
                     END IF;
                     
                     -- validar que sea la misma partida 
                     select 
                        pxp.aggarray(DISTINCT ad.id_partida)
                     into va_id_partida
                     from pre.tajuste_det ad 
                     where ad.id_ajuste = v_parametros.id_ajuste;
                     
                     IF   array_length(va_id_partida,1 ) > 1 THEN                     
                         raise exception 'en traspasos la partida en cada detalle tiene que ser la misma';
                     END IF;
                     
               
                 ELSEIF  v_registros_proc.tipo_ajuste = 'reformulacion'   THEN
                  -- si es reformulacion
                     IF v_registros_proc.importe_ajuste !=  v_total_incrementos THEN
                        raise exception 'los incrementos no igualan con el monto a ajustar';
                     END IF;
                     
                     -- validar que el monto de incremento iguala al monto del decremento
                     
                     IF (v_total_decrementos*-1) !=  v_total_incrementos THEN
                        raise exception 'los incrementos deben ser proporcionales a los decrementos';
                     END IF;
                
                
                 ELSEIF v_registros_proc.tipo_ajuste = 'incremento'   THEN
                 -- si es incremento
             	    -- validar que se tenga un monto de incremento y ningun decremento
                     IF v_registros_proc.importe_ajuste !=  v_total_incrementos THEN
                        raise exception 'los incrementos no igualan con el monto a ajustar';
                     END IF;
                     
                     -- validar que no se tengan decrementos
                     
                     IF v_total_decrementos != 0 THEN
                        raise exception 'elimine los decrementos registrados';
                     END IF;
                
                
                 ELSEIF v_registros_proc.tipo_ajuste = 'decremento'   THEN 
                 -- si es decremento
                    -- validar que se tenga un monto a decrementar y cero a incrementar
                     IF v_registros_proc.importe_ajuste !=  (v_total_decrementos*-1) THEN
                        raise exception 'los decrementos no igualan con el monto a ajustar';
                     END IF;
                                          
                     -- validar que no se tengan incrementos                     
                     IF v_total_incrementos != 0 THEN
                        raise exception 'elimine los incrementos registrados';
                     END IF;
                     
                     
                 ELSEIF v_registros_proc.tipo_ajuste = 'rev_comprometido'   THEN 
                 -- si es decremento
                    -- validar que se tenga un monto a decrementar y cero a incrementar
                     IF v_registros_proc.importe_ajuste !=  (v_total_decrementos*-1) THEN
                        raise exception 'los decrementos no igualan con el monto a ajustar';
                     END IF;
                                          
                     -- validar que no se tengan incrementos                     
                     IF v_total_incrementos != 0 THEN
                        raise exception 'elimine los incrementos registrados';
                     END IF;
                     
                  ELSEIF v_registros_proc.tipo_ajuste = 'inc_comprometido'   THEN
                     -- si es incremento
             	    -- validar que se tenga un monto de incremento y ningun decremento
                     IF v_registros_proc.importe_ajuste !=  v_total_incrementos THEN
                        raise exception 'los incrementos no igualan con el monto a ajustar';
                     END IF;
                     
                     -- validar que no se tengan decrementos
                     
                     IF v_total_decrementos != 0 THEN
                        raise exception 'elimine los decrementos registrados';
                     END IF;        
                 
                 ELSE
                    raise exception 'no se reconoce el tipo de ajuste %', v_registros_proc.tipo_ajuste;
                 END IF;
          
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
          --  ACTUALIZA EL NUEVO ESTADO DE AJUSTES
          ----------------------------------------------------
          
          
          IF  pre.f_fun_inicio_ajuste_wf(p_id_usuario, 
           									v_parametros._id_usuario_ai, 
                                            v_parametros._nombre_usuario_ai, 
                                            v_id_estado_actual, 
                                            v_id_proceso_wf, 
                                            v_codigo_estado_siguiente) THEN
          
                                              
          END IF;
          
          
          -- si hay mas de un estado disponible  preguntamos al usuario
          v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Se realizo el cambio de estado del presupuesto id='||v_parametros.id_ajuste); 
          v_resp = pxp.f_agrega_clave(v_resp,'operacion','cambio_exitoso');
          
          
          -- Devuelve la respuesta
          return v_resp;
        
     end; 
     
    /*********************************    
 	#TRANSACCION:  'PR_ANTEAJT_IME'
 	#DESCRIPCION: retrocede el estado de ajustes
 	#AUTOR:		RAC	
 	#FECHA:		13-04-2016 12:12:51
	***********************************/

	elseif(p_transaccion='PR_ANTEAJT_IME')then   
        begin
        
        v_operacion = 'anterior';
        
        IF  pxp.f_existe_parametro(p_tabla , 'estado_destino')  THEN
           v_operacion = v_parametros.estado_destino;
        END IF;
        
      
        
        --obtenermos datos basicos
        select
            pp.id_ajuste,
            pp.id_proceso_wf,
            pp.estado,
            pwf.id_tipo_proceso
        into 
            v_registros_pp
            
        from pre.tajuste  pp
        inner  join wf.tproceso_wf pwf  on  pwf.id_proceso_wf = pp.id_proceso_wf
        where pp.id_proceso_wf  = v_parametros.id_proceso_wf;
        
        
        IF v_registros_pp.estado = 'aprobado' THEN
            raise exception 'El ajuste ya se encuentra terminado, solo peude modificar con otro ajuste';
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
                      
              IF  not pre.f_fun_regreso_ajuste_wf(p_id_usuario, 
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