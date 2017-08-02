<?php
/**
*@package pXP
*@file gen-MODTipoPresupuesto.php
*@author  (admin)
*@date 29-02-2016 05:18:02
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/
class MODTipoPresupuesto extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarTipoPresupuesto(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='pre.ft_tipo_presupuesto_sel';
		$this->transaccion='PRE_TIPR_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_tipo_presupuesto','int4');
		$this->captura('codigo','varchar');
		$this->captura('movimiento','varchar');
		$this->captura('nombre','varchar');
		$this->captura('descripcion','varchar');
		$this->captura('estado_reg','varchar');
		$this->captura('id_usuario_ai','int4');
		$this->captura('usuario_ai','varchar');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		
		$this->captura('sw_oficial','varchar');
		
		
		
	
		
		
		
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarTipoPresupuesto(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pre.ft_tipo_presupuesto_ime';
		$this->transaccion='PRE_TIPR_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('codigo','codigo','varchar');
		$this->setParametro('movimiento','movimiento','varchar');
		$this->setParametro('nombre','nombre','varchar');
		$this->setParametro('descripcion','descripcion','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('sw_oficial','sw_oficial','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarTipoPresupuesto(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pre.ft_tipo_presupuesto_ime';
		$this->transaccion='PRE_TIPR_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_tipo_presupuesto','id_tipo_presupuesto','int4');
		$this->setParametro('codigo','codigo','varchar');
		$this->setParametro('movimiento','movimiento','varchar');
		$this->setParametro('nombre','nombre','varchar');
		$this->setParametro('descripcion','descripcion','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('sw_oficial','sw_oficial','varchar');
		

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarTipoPresupuesto(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pre.ft_tipo_presupuesto_ime';
		$this->transaccion='PRE_TIPR_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_tipo_presupuesto','id_tipo_presupuesto','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>