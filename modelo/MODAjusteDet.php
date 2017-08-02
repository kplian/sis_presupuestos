<?php
/**
*@package pXP
*@file gen-MODAjusteDet.php
*@author  (admin)
*@date 13-04-2016 13:51:41
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODAjusteDet extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarAjusteDet(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='pre.ft_ajuste_det_sel';
		$this->transaccion='PRE_AJD_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		
		$this->capturaCount('total_importe','numeric');
				
		//Definicion de la lista del resultado del query
		$this->captura('id_ajuste_det','int4');
		$this->captura('id_presupuesto','int4');
		$this->captura('id_partida_ejecucion','int4');
		$this->captura('importe','numeric');
		$this->captura('id_partida','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('tipo_ajuste','varchar');
		$this->captura('id_usuario_ai','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		
		$this->captura('desc_presupuesto','text');
		$this->captura('desc_partida','varchar');
		$this->captura('id_ajuste','int4');
		
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarAjusteDet(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pre.ft_ajuste_det_ime';
		$this->transaccion='PRE_AJD_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_presupuesto','id_presupuesto','int4');
		$this->setParametro('id_partida_ejecucion','id_partida_ejecucion','int4');
		$this->setParametro('importe','importe','numeric');
		$this->setParametro('id_partida','id_partida','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('tipo_ajuste','tipo_ajuste','varchar');
		$this->setParametro('id_ajuste','id_ajuste','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarAjusteDet(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pre.ft_ajuste_det_ime';
		$this->transaccion='PRE_AJD_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_ajuste_det','id_ajuste_det','int4');
		$this->setParametro('id_presupuesto','id_presupuesto','int4');
		$this->setParametro('id_partida_ejecucion','id_partida_ejecucion','int4');
		$this->setParametro('importe','importe','numeric');
		$this->setParametro('id_partida','id_partida','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('tipo_ajuste','tipo_ajuste','varchar');
		$this->setParametro('id_ajuste','id_ajuste','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarAjusteDet(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pre.ft_ajuste_det_ime';
		$this->transaccion='PRE_AJD_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_ajuste_det','id_ajuste_det','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>