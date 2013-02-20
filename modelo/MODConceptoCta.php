<?php
/**
*@package pXP
*@file MODConceptoCta.php
*@author  Gonzalo Sarmiento Sejas
*@date 18-02-2013 22:57:58
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODConceptoCta extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarConceptoCta(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='pre.f_concepto_cta_sel';
		$this->transaccion='PRE_CCTA_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_concepto_cta','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('id_auxiliar','int4');
		$this->captura('id_cuenta','int4');
		$this->captura('id_concepto_ingas','int4');
		$this->captura('id_partida','int4');
		$this->captura('id_centro_costo','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarConceptoCta(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pre.f_concepto_cta_ime';
		$this->transaccion='PRE_CCTA_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_auxiliar','id_auxiliar','int4');
		$this->setParametro('id_cuenta','id_cuenta','int4');
		$this->setParametro('id_concepto_ingas','id_concepto_ingas','int4');
		$this->setParametro('id_partida','id_partida','int4');
		$this->setParametro('id_centro_costo','id_centro_costo','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarConceptoCta(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pre.f_concepto_cta_ime';
		$this->transaccion='PRE_CCTA_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_concepto_cta','id_concepto_cta','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_auxiliar','id_auxiliar','int4');
		$this->setParametro('id_cuenta','id_cuenta','int4');
		$this->setParametro('id_concepto_ingas','id_concepto_ingas','int4');
		$this->setParametro('id_partida','id_partida','int4');
		$this->setParametro('id_centro_costo','id_centro_costo','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarConceptoCta(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pre.f_concepto_cta_ime';
		$this->transaccion='PRE_CCTA_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_concepto_cta','id_concepto_cta','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>