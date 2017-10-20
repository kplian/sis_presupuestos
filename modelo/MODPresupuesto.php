<?php
/**
*@package pXP
*@file gen-MODPresupuesto.php
*@author  Gonzalo Sarmiento Sejas
*@date 26-11-2012 21:35:35
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODPresupuesto extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarPresupuesto(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='pre.ft_presupuesto_sel';
		$this->transaccion='PRE_PRE_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		$this->setParametro('tipo_interfaz','tipo_interfaz','varchar');	
		$this->setParametro('id_funcionario_usu','id_funcionario_usu','int4');
			
			
		//Definicion de la lista del resultado del query
		$this->captura('id_presupuesto','int4');
		$this->captura('id_centro_costo','int4');
		$this->captura('codigo_cc','text');
		$this->captura('tipo_pres','varchar');
		$this->captura('estado_pres','varchar');
		$this->captura('estado_reg','varchar');		
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('estado','varchar');
		$this->captura('id_estado_wf','int4');
		$this->captura('nro_tramite','varchar');
		$this->captura('id_proceso_wf','int4');
		$this->captura('desc_tipo_presupuesto','varchar');
		$this->captura('descripcion','varchar');
		$this->captura('movimiento_tipo_pres','varchar');
		$this->captura('id_gestion','int4');
		$this->captura('obs_wf','varchar');
		$this->captura('sw_consolidado','VARCHAR');		
		$this->captura('id_categoria_prog','int4');
		$this->captura('codigo_categoria','varchar');
		$this->captura('mov_pres','varchar');
		$this->captura('momento_pres','varchar');		
		$this->captura('id_uo','int4');
		$this->captura('codigo_uo','varchar');		
		$this->captura('nombre_uo','varchar');
		$this->captura('id_tipo_cc','int4');
		$this->captura('desc_tcc','varchar');
		$this->captura('fecha_inicio_pres','date');
		$this->captura('fecha_fin_pres','date');

		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}

    function listarPresupuestoRest(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='pre.ft_presupuesto_sel';
        $this->transaccion='PRE_PREREST_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion
        //$this->setCount(false);
        $this->setParametro('gestion','gestion','varchar');

        //Definicion de la lista del resultado del query
        $this->captura('id_centro_costo','int4');
        $this->captura('descripcion','text');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function listarPresupuestoCmb(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='pre.ft_presupuesto_sel';
		$this->transaccion='PRE_CBMPRES_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		
		      $this->captura('id_centro_costo','int4');
              $this->captura('estado_reg','VARCHAR');
              $this->captura('id_ep','int4');
              $this->captura('id_gestion','int4');
              $this->captura('id_uo','int4');
              $this->captura('id_usuario_reg','int4');
              $this->captura('fecha_reg','timestamp');
              $this->captura('id_usuario_mod','int4');
              $this->captura('fecha_mod','timestamp');
              $this->captura('usr_reg','VARCHAR');
              $this->captura('usr_mod','VARCHAR');
              $this->captura('codigo_uo','VARCHAR');
              $this->captura('nombre_uo','VARCHAR');
              $this->captura('ep','TEXT');
              $this->captura('gestion','INTEGER');
              $this->captura('codigo_cc','text');
              $this->captura('nombre_programa','VARCHAR');
              $this->captura('nombre_proyecto','VARCHAR');
              $this->captura('nombre_actividad','VARCHAR');
              $this->captura('nombre_financiador','VARCHAR');
              $this->captura('nombre_regional','VARCHAR');
              $this->captura('tipo_pres','VARCHAR');
              $this->captura('cod_act','VARCHAR');
              $this->captura('cod_fin','VARCHAR');
              $this->captura('cod_prg','VARCHAR');
              $this->captura('cod_pry','VARCHAR');
              $this->captura('estado_pres','VARCHAR');
              $this->captura('estado','VARCHAR');
              $this->captura('id_presupuesto','int4');
              $this->captura('id_estado_wf','int4');
              $this->captura('nro_tramite','VARCHAR');
              $this->captura('id_proceso_wf','int4');
              $this->captura('movimiento_tipo_pres','VARCHAR');
              $this->captura('desc_tipo_presupuesto','VARCHAR');
			  $this->captura('sw_oficial','VARCHAR');
			  $this->captura('sw_consolidado','VARCHAR');
			
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarPresupuesto(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pre.ft_presupuesto_ime';
		$this->transaccion='PRE_PRE_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_tipo_cc','id_tipo_cc','int4');
		$this->setParametro('id_uo','id_uo','int4');
		$this->setParametro('id_gestion','id_gestion','int4');		
		$this->setParametro('tipo_pres','tipo_pres','varchar');
		$this->setParametro('descripcion','descripcion','varchar');
		$this->setParametro('sw_consolidado','sw_consolidado','varchar');
		$this->setParametro('id_categoria_prog','id_categoria_prog','int4');
		$this->setParametro('fecha_inicio_pres','fecha_inicio_pres','date');
		$this->setParametro('fecha_fin_pres','fecha_fin_pres','date');

	

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarPresupuesto(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pre.ft_presupuesto_ime';
		$this->transaccion='PRE_PRE_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_presupuesto','id_presupuesto','int4');
		
		$this->setParametro('id_tipo_cc','id_tipo_cc','int4');
		$this->setParametro('id_uo','id_uo','int4');
		$this->setParametro('id_gestion','id_gestion','int4');	
		
		$this->setParametro('tipo_pres','tipo_pres','varchar');
		$this->setParametro('descripcion','descripcion','varchar');
		$this->setParametro('sw_consolidado','sw_consolidado','varchar');
		$this->setParametro('id_categoria_prog','id_categoria_prog','int4');
        $this->setParametro('fecha_inicio_pres','fecha_inicio_pres','date');
        $this->setParametro('fecha_fin_pres','fecha_fin_pres','date');
		

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarPresupuesto(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pre.ft_presupuesto_ime';
		$this->transaccion='PRE_PRE_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_presupuesto','id_presupuesto','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
	
	function verificarPresupuesto(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='pre.ft_presup_partida_ime';
        $this->transaccion='PRE_VERPRE_IME';
        $this->tipo_procedimiento='IME';
                
        //Define los parametros para la funcion
        $this->setParametro('id_presupuesto','id_presupuesto','int4');
        $this->setParametro('id_partida','id_partida','int4');
        $this->setParametro('id_moneda','id_moneda','int4');
        $this->setParametro('monto_total','monto_total','numeric');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
    
    function reportePresupuesto(){
        $this->procedimiento='pre.ft_presupuesto_sel';
        $this->transaccion='PRE_SALPRE_SEL';
        $this->tipo_procedimiento='SEL';
        
        $this->setCount(false);
        
        //definicion de los parametros para la funcion
        $this->setParametro('id_presupuesto','id_presupuesto','varchar');
        $this->setParametro('id_partida','id_partida','varchar');
        $this->setParametro('fecha_ini','fecha_ini','timestamp');
        $this->setParametro('fecha_fin','fecha_fin','timestamp');
        
        //Definicion de la lista del resultado del query
        $this->captura('id_partida','int4');
        $this->captura('codigo_par','varchar');
        $this->captura('id_presupuesto','int4');
        $this->captura('codigo_pres','varchar');
        $this->captura('centro_costo','varchar');
        $this->captura('moneda','varchar');      
        $this->captura('presup_ene','numeric');
        $this->captura('ejec_ene','numeric');
        $this->captura('presup_feb','numeric');
        $this->captura('ejec_feb','numeric');
        $this->captura('presup_mar','numeric');
        $this->captura('ejec_mar','numeric');
        $this->captura('presup_abr','numeric');
        $this->captura('ejec_abr','numeric');
        $this->captura('presup_may','numeric');
        $this->captura('ejec_may','numeric');
        $this->captura('presup_jun','numeric');
        $this->captura('ejec_jun','numeric');
        $this->captura('presup_jul','numeric');
        $this->captura('ejec_jul','numeric');
        $this->captura('presup_ago','numeric');
        $this->captura('ejec_ago','numeric');
        $this->captura('presup_sep','numeric');
        $this->captura('ejec_sep','numeric');
        $this->captura('presup_oct','numeric');
        $this->captura('ejec_oct','numeric');
        $this->captura('presup_nov','numeric');
        $this->captura('ejec_nov','numeric');
        $this->captura('presup_dic','numeric');
        $this->captura('ejec_dic','numeric');        
        
        //devuelve la respuesta
        $this->armarConsulta();
        $this->ejecutarConsulta();
        
        return $this->respuesta;
    }	

   function clonarPresupuestosGestion(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pre.ft_presupuesto_ime';
		$this->transaccion='PRE_CLONARPRE_IME';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_gestion','id_gestion','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
   
   
   
   function iniciarTramite(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pre.ft_presupuesto_ime';
		$this->transaccion='PRE_INITRA_IME';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		
		$this->setParametro('id_presupuesto','id_presupuesto','int4');
		$this->setParametro('id_funcionario_usu','id_funcionario_usu','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
   
   function siguienteEstadoPresupuesto(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento = 'pre.ft_presupuesto_ime';
        $this->transaccion = 'PRE_SIGESTP_IME';
        $this->tipo_procedimiento = 'IME';
   
        //Define los parametros para la funcion
        $this->setParametro('id_presupuesto','id_presupuesto','int4');
        $this->setParametro('id_proceso_wf_act','id_proceso_wf_act','int4');
        $this->setParametro('id_estado_wf_act','id_estado_wf_act','int4');
        $this->setParametro('id_funcionario_usu','id_funcionario_usu','int4');
        $this->setParametro('id_tipo_estado','id_tipo_estado','int4');
        $this->setParametro('id_funcionario_wf','id_funcionario_wf','int4');
        $this->setParametro('id_depto_wf','id_depto_wf','int4');		
        $this->setParametro('obs','obs','text');
        $this->setParametro('json_procesos','json_procesos','text');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }


    function anteriorEstadoPresupuesto(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='pre.ft_presupuesto_ime';
        $this->transaccion='PR_ANTEPR_IME';
        $this->tipo_procedimiento='IME';
                
        //Define los parametros para la funcion
        $this->setParametro('id_proceso_wf','id_proceso_wf','int4');
        $this->setParametro('id_estado_wf','id_estado_wf','int4');
		$this->setParametro('obs','obs','varchar');
		$this->setParametro('estado_destino','estado_destino','varchar');
		
		
	
        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function reporteCertificacionP(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='pre.ft_presupuesto_sel';
        $this->transaccion='PR_REPCERPRE_SEL';
        $this->tipo_procedimiento='SEL';

        //Define los parametros para la funcion
        $this->setParametro('id_proceso_wf','id_proceso_wf','int4');


        $this->captura('id_cp', 'int4');
        $this->captura('centro_costo', 'varchar');
        $this->captura('codigo_programa', 'varchar');
        $this->captura('codigo_proyecto', 'varchar');
        $this->captura('codigo_actividad', 'varchar');
        $this->captura('codigo_fuente_fin', 'varchar');
        $this->captura('codigo_origen_fin', 'varchar');

        $this->captura('codigo_partida', 'varchar');
        $this->captura('nombre_partidad', 'varchar');
        $this->captura('codigo_cg', 'varchar');
        $this->captura('nombre_cg', 'varchar');
        $this->captura('precio_total', 'numeric');
        $this->captura('codigo_moneda', 'varchar');
        $this->captura('num_tramite', 'varchar');
        $this->captura('nombre_entidad', 'varchar');
        $this->captura('direccion_admin', 'varchar');
        $this->captura('unidad_ejecutora', 'varchar');
        $this->captura('firmas', 'varchar');
        $this->captura('justificacion', 'varchar');
        $this->captura('codigo_transf', 'varchar');
        $this->captura('unidad_solicitante', 'varchar');
        $this->captura('funcionario_solicitante', 'varchar');
        $this->captura('fecha_soli', 'date');
        $this->captura('gestion', 'integer');
        $this->captura('codigo_poa', 'varchar');
        $this->captura('codigo_descripcion', 'varchar');


        //Ejecuta la instruccion
        $this->armarConsulta();
        //var_dump($this->consulta);exit;
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function reportePOA(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='pre.ft_presupuesto_sel';
        $this->transaccion='PR_REPPOA_SEL';
        $this->tipo_procedimiento='SEL';

        //Define los parametros para la funcion
        $this->setParametro('id_proceso_wf','id_proceso_wf','int4');

        $this->captura('id_objetivo','int4');
        $this->captura('id_objetivo_fk','int4');
        $this->captura('codigo','varchar');
        $this->captura('nivel_objetivo','int4');
        $this->captura('hijos','int4');
        $this->captura('nietos','int4');
        $this->captura('hermanos','int4');
        $this->captura('sw_transaccional','varchar');
        $this->captura('cantidad_verificacion','numeric');
        $this->captura('unidad_verificacion','varchar');
        $this->captura('ponderacion','numeric');
        $this->captura('fecha_inicio','date');
        $this->captura('tipo_objetivo','varchar');
        $this->captura('descripcion','varchar');
        $this->captura('linea_base','varchar');
        $this->captura('indicador_logro','varchar');

        $this->captura('periodo_ejecucion','varchar');
        $this->captura('producto','varchar');
        $this->captura('fecha_fin','date');

        $this->captura('gestion','varchar');

        //Ejecuta la instruccion
        $this->armarConsulta();
        //var_dump($this->consulta);exit;
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }


    function listarNotaInterna(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='pre.ft_presupuesto_sel';
        $this->transaccion='PR_NOTA_SEL';
        $this->tipo_procedimiento='SEL';
        $this->setCount(false);
        //Define los parametros para la funcion
        $this->setParametro('id_proceso_wf','id_proceso_wf','int4');

        $this->captura('desc_funcionario1','varchar');
        $this->captura('nombre_cargo','varchar');
        $this->captura('funcionario_gerencia','varchar');
        $this->captura('cargo_gerencia','varchar');
        $this->captura('nro_cite_inicio','varchar');
        $this->captura('nro_cite_fin','varchar');
        $this->captura('fecha_nota','varchar');
        $this->captura('gestion','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();
        //var_dump($this->consulta);exit;
        //Devuelve la respuesta
        return $this->respuesta;
    }

 
   		
}
?>