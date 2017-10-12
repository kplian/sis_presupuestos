<?php
/**
*@package pXP
*@file gen-MODAjuste.php
*@author  (admin)
*@date 13-04-2016 13:21:12
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODAjuste extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarAjuste(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='pre.ft_ajuste_sel';
		$this->transaccion='PRE_AJU_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		
		$this->setParametro('tipo_interfaz','tipo_interfaz','varchar');	
		$this->setParametro('id_funcionario_usu','id_funcionario_usu','int4');
				
		//Definicion de la lista del resultado del query
		$this->captura('id_ajuste','int4');
		$this->captura('id_estado_wf','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('estado','varchar');
		$this->captura('justificacion','varchar');
		$this->captura('id_proceso_wf','int4');
		$this->captura('tipo_ajuste','varchar');
		$this->captura('nro_tramite','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_ai','int4');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');		
		$this->captura('fecha','date');
		$this->captura('id_gestion','int4');
		$this->captura('importe_ajuste','numeric');
		$this->captura('movimiento','varchar');
		$this->captura('nro_tramite_aux','varchar');
		$this->captura('desc_moneda','varchar');
		$this->captura('id_moneda','int4');
		
		
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarAjuste(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pre.ft_ajuste_ime';
		$this->transaccion='PRE_AJU_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('justificacion','justificacion','varchar');
		$this->setParametro('tipo_ajuste','tipo_ajuste','varchar');
		$this->setParametro('fecha','fecha','date');
		$this->setParametro('importe_ajuste','importe_ajuste','numeric');
		$this->setParametro('movimiento','movimiento','varchar');
		$this->setParametro('nro_tramite_aux','nro_tramite_aux','varchar');
		
		
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarAjuste(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pre.ft_ajuste_ime';
		$this->transaccion='PRE_AJU_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_ajuste','id_ajuste','int4');
		$this->setParametro('justificacion','justificacion','varchar');
		$this->setParametro('tipo_ajuste','tipo_ajuste','varchar');
		$this->setParametro('fecha','fecha','date');
		$this->setParametro('importe_ajuste','importe_ajuste','numeric');
		$this->setParametro('movimiento','movimiento','varchar');
		$this->setParametro('nro_tramite_aux','nro_tramite_aux','varchar');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarAjuste(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pre.ft_ajuste_ime';
		$this->transaccion='PRE_AJU_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_ajuste','id_ajuste','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
	
	function siguienteEstadoAjuste(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento = 'pre.ft_ajuste_ime';
        $this->transaccion = 'PRE_SIGAJT_IME';
        $this->tipo_procedimiento = 'IME';
   
        //Define los parametros para la funcion
        $this->setParametro('id_ajuste','id_ajuste','int4');
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


    function anteriorEstadoAjuste(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='pre.ft_ajuste_ime';
        $this->transaccion='PR_ANTEAJT_IME';
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
			
}
?>