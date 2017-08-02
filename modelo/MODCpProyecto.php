<?php
/**
*@package pXP
*@file gen-MODCpProyecto.php
*@author  (admin)
*@date 19-04-2016 14:40:49
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODCpProyecto extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarCpProyecto(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='pre.ft_cp_proyecto_sel';
		$this->transaccion='PRE_CPPROY_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_cp_proyecto','int4');
		$this->captura('codigo','varchar');
		$this->captura('id_gestion','int4');
		$this->captura('codigo_sisin','varchar');
		$this->captura('descripcion','varchar');
		$this->captura('estado_reg','varchar');
		$this->captura('id_usuario_ai','int4');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('usuario_ai','varchar');
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
			
	function insertarCpProyecto(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pre.ft_cp_proyecto_ime';
		$this->transaccion='PRE_CPPROY_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('codigo','codigo','varchar');
		$this->setParametro('id_gestion','id_gestion','int4');
		$this->setParametro('codigo_sisin','codigo_sisin','varchar');
		$this->setParametro('descripcion','descripcion','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarCpProyecto(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pre.ft_cp_proyecto_ime';
		$this->transaccion='PRE_CPPROY_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_cp_proyecto','id_cp_proyecto','int4');
		$this->setParametro('codigo','codigo','varchar');
		$this->setParametro('id_gestion','id_gestion','int4');
		$this->setParametro('codigo_sisin','codigo_sisin','varchar');
		$this->setParametro('descripcion','descripcion','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarCpProyecto(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pre.ft_cp_proyecto_ime';
		$this->transaccion='PRE_CPPROY_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_cp_proyecto','id_cp_proyecto','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>