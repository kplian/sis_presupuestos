<?php
/**
*@package pXP
*@file gen-MODConceptoPartida.php
*@author  (admin)
*@date 25-02-2013 22:09:52
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODConceptoPartida extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarConceptoPartida(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='pre.f_concepto_partida_sel';
		$this->transaccion='PRE_CONP_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_concepto_partida','int4');
		$this->captura('id_partida','int4');
		$this->captura('id_concepto_ingas','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		
		$this->captura('desc_gestion','integer');
		$this->captura('codigo_partida','varchar');
		$this->captura('nombre_partida','varchar');
		$this->captura('desc_partida','text');
		
		
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarConceptoPartida(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pre.f_concepto_partida_ime';
		$this->transaccion='PRE_CONP_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_partida','id_partida','int4');
		$this->setParametro('id_concepto_ingas','id_concepto_ingas','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarConceptoPartida(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pre.f_concepto_partida_ime';
		$this->transaccion='PRE_CONP_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_concepto_partida','id_concepto_partida','int4');
		$this->setParametro('id_partida','id_partida','int4');
		$this->setParametro('id_concepto_ingas','id_concepto_ingas','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarConceptoPartida(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pre.f_concepto_partida_ime';
		$this->transaccion='PRE_CONP_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_concepto_partida','id_concepto_partida','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>