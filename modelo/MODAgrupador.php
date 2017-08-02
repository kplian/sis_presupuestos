<?php
/**
*@package pXP
*@file gen-MODAgrupador.php
*@author  (gvelasquez)
*@date 25-10-2016 19:21:31
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODAgrupador extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarAgrupador(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='pre.ft_agrupador_sel';
		$this->transaccion='PRE_AGRUPA_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_agrupador','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('orden','numeric');
		$this->captura('tipo','varchar');
		$this->captura('nombre_agrupador','varchar');
		$this->captura('codigo','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_ai','int4');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarAgrupador(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pre.ft_agrupador_ime';
		$this->transaccion='PRE_AGRUPA_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('orden','orden','numeric');
		$this->setParametro('tipo','tipo','varchar');
		$this->setParametro('nombre_agrupador','nombre_agrupador','varchar');
		$this->setParametro('codigo','codigo','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarAgrupador(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pre.ft_agrupador_ime';
		$this->transaccion='PRE_AGRUPA_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_agrupador','id_agrupador','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('orden','orden','numeric');
		$this->setParametro('tipo','tipo','varchar');
		$this->setParametro('nombre_agrupador','nombre_agrupador','varchar');
		$this->setParametro('codigo','codigo','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarAgrupador(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pre.ft_agrupador_ime';
		$this->transaccion='PRE_AGRUPA_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_agrupador','id_agrupador','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>