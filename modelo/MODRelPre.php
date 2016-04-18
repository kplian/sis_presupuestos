<?php
/**
*@package pXP
*@file gen-MODRelPre.php
*@author  (admin)
*@date 18-04-2016 13:18:06
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODRelPre extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarRelPre(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='pre.ft_rel_pre_sel';
		$this->transaccion='PRE_RELP_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_rel_pre','int4');
		$this->captura('estado','varchar');
		$this->captura('id_presupuesto_hijo','int4');
		$this->captura('fecha_union','date');
		$this->captura('estado_reg','varchar');
		$this->captura('id_presupuesto_padre','int4');
		$this->captura('id_usuario_ai','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('desc_presupuesto_hijo','varchar');
		
		
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarRelPre(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pre.ft_rel_pre_ime';
		$this->transaccion='PRE_RELP_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_presupuesto_hijo','id_presupuesto_hijo','int4');
		$this->setParametro('id_presupuesto_padre','id_presupuesto_padre','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarRelPre(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pre.ft_rel_pre_ime';
		$this->transaccion='PRE_RELP_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_rel_pre','id_rel_pre','int4');
		$this->setParametro('id_presupuesto_hijo','id_presupuesto_hijo','int4');
		$this->setParametro('id_presupuesto_padre','id_presupuesto_padre','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarRelPre(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pre.ft_rel_pre_ime';
		$this->transaccion='PRE_RELP_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_rel_pre','id_rel_pre','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
	
	function consolidarRelPre(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pre.ft_rel_pre_ime';
		$this->transaccion='PRE_CONREL_IME';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_rel_pre','id_rel_pre','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>