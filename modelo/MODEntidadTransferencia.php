<?php
/**
*@package pXP
*@file gen-MODEntidadTransferencia.php
*@author  (franklin.espinoza)
*@date 21-07-2017 12:57:45
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODEntidadTransferencia extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarEntidadTransferencia(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='pre.ft_entidad_transferencia_sel';
		$this->transaccion='PRE_ENT_TRAN_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_entidad_transferencia','int4');
		$this->captura('id_gestion','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('codigo','varchar');
		$this->captura('nombre','varchar');
		$this->captura('usuario_ai','varchar');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_reg','int4');
		$this->captura('id_usuario_ai','int4');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('gestion','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarEntidadTransferencia(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pre.ft_entidad_transferencia_ime';
		$this->transaccion='PRE_ENT_TRAN_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_gestion','id_gestion','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('codigo','codigo','varchar');
		$this->setParametro('nombre','nombre','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarEntidadTransferencia(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pre.ft_entidad_transferencia_ime';
		$this->transaccion='PRE_ENT_TRAN_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_entidad_transferencia','id_entidad_transferencia','int4');
		$this->setParametro('id_gestion','id_gestion','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('codigo','codigo','varchar');
		$this->setParametro('nombre','nombre','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarEntidadTransferencia(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pre.ft_entidad_transferencia_ime';
		$this->transaccion='PRE_ENT_TRAN_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_entidad_transferencia','id_entidad_transferencia','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

    function validarCampos(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='pre.ft_entidad_transferencia_ime';
        $this->transaccion='PRE_ENT_TRAN_VAL';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('codigo','codigo','varchar');
        $this->setParametro('nombre','nombre','varchar');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
			
}
?>