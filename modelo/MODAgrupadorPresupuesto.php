<?php
/**
*@package pXP
*@file gen-MODAgrupadorPresupuesto.php
*@author  (gvelasquez)
*@date 25-10-2016 19:21:34
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODAgrupadorPresupuesto extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarAgrupadorPresupuesto(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='pre.ft_agrupador_presupuesto_sel';
		$this->transaccion='PRE_AGRPRE_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_agrupador_presupuesto','int4');
		$this->captura('id_presupuesto','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('id_agrupador','int4');
		$this->captura('id_usuario_ai','int4');
		$this->captura('id_usuario_reg','int4');
		$this->captura('usuario_ai','varchar');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');

        $this->captura('gestion','integer');
        $this->captura('nombre_uo','varchar');
        $this->captura('descripcion_pre','varchar');
        $this->captura('desc_tipo_presupuesto','varchar');
        $this->captura('codigo_categoria','varchar');
        $this->captura('descripcion_cat','text');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarAgrupadorPresupuesto(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pre.ft_agrupador_presupuesto_ime';
		$this->transaccion='PRE_AGRPRE_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_presupuesto','id_presupuesto','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_agrupador','id_agrupador','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarAgrupadorPresupuesto(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pre.ft_agrupador_presupuesto_ime';
		$this->transaccion='PRE_AGRPRE_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_agrupador_presupuesto','id_agrupador_presupuesto','int4');
		$this->setParametro('id_presupuesto','id_presupuesto','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_agrupador','id_agrupador','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarAgrupadorPresupuesto(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pre.ft_agrupador_presupuesto_ime';
		$this->transaccion='PRE_AGRPRE_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_agrupador_presupuesto','id_agrupador_presupuesto','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>