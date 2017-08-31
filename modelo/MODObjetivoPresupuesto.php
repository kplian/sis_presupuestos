<?php
/**
*@package pXP
*@file gen-MODObjetivoPresupuesto.php
*@author  (franklin.espinoza)
*@date 27-07-2017 16:10:48
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODObjetivoPresupuesto extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarObjetivoPresupuesto(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='pre.ft_objetivo_presupuesto_sel';
		$this->transaccion='PRE_OBJ_PRES_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion

        $this->setParametro('id_objetivo','id_objetivo','int4');
		//Definicion de la lista del resultado del query
		$this->captura('id_objetivo_presupuesto','int4');
		$this->captura('id_objetivo','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('id_presupuesto','int4');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_ai','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('desc_presupuesto','varchar');
        $this->captura('tipo_reg','varchar');
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarObjetivoPresupuesto(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pre.ft_objetivo_presupuesto_ime';
		$this->transaccion='PRE_OBJ_PRES_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_objetivo','id_objetivo','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_presupuesto','id_presupuesto','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarObjetivoPresupuesto(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pre.ft_objetivo_presupuesto_ime';
		$this->transaccion='PRE_OBJ_PRES_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_objetivo_presupuesto','id_objetivo_presupuesto','int4');
		$this->setParametro('id_objetivo','id_objetivo','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_presupuesto','id_presupuesto','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarObjetivoPresupuesto(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pre.ft_objetivo_presupuesto_ime';
		$this->transaccion='PRE_OBJ_PRES_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_objetivo_presupuesto','id_objetivo_presupuesto','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>