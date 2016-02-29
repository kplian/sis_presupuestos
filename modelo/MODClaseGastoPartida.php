<?php
/**
*@package pXP
*@file gen-MODClaseGastoPartida.php
*@author  (admin)
*@date 26-02-2016 02:33:23
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODClaseGastoPartida extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarClaseGastoPartida(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='pre.ft_clase_gasto_partida_sel';
		$this->transaccion='PRE_CGP_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_clase_gasto_partida','int4');
		$this->captura('id_partida','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('id_clase_gasto','int4');
		$this->captura('id_usuario_ai','int4');
		$this->captura('usuario_ai','varchar');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_reg','int4');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('desc_partida','varchar');
		$this->captura('id_gestion','int4');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarClaseGastoPartida(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pre.ft_clase_gasto_partida_ime';
		$this->transaccion='PRE_CGP_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_partida','id_partida','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_clase_gasto','id_clase_gasto','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarClaseGastoPartida(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pre.ft_clase_gasto_partida_ime';
		$this->transaccion='PRE_CGP_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_clase_gasto_partida','id_clase_gasto_partida','int4');
		$this->setParametro('id_partida','id_partida','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_clase_gasto','id_clase_gasto','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarClaseGastoPartida(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pre.ft_clase_gasto_partida_ime';
		$this->transaccion='PRE_CGP_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_clase_gasto_partida','id_clase_gasto_partida','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>