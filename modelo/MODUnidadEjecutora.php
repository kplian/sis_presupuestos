<?php
/**
*@package pXP
*@file gen-MODUnidadEjecutora.php
*@author  (franklin.espinoza)
*@date 21-07-2017 13:41:05
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODUnidadEjecutora extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarUnidadEjecutora(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='pre.ft_unidad_ejecutora_sel';
		$this->transaccion='PRE_UND_EJE_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_unidad_ejecutora','int4');
		$this->captura('id_gestion','int4');
		$this->captura('nombre','varchar');
		$this->captura('codigo','varchar');
		$this->captura('estado_reg','varchar');
		$this->captura('id_usuario_ai','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('gestion','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarUnidadEjecutora(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pre.ft_unidad_ejecutora_ime';
		$this->transaccion='PRE_UND_EJE_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_gestion','id_gestion','int4');
		$this->setParametro('nombre','nombre','varchar');
		$this->setParametro('codigo','codigo','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarUnidadEjecutora(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pre.ft_unidad_ejecutora_ime';
		$this->transaccion='PRE_UND_EJE_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_unidad_ejecutora','id_unidad_ejecutora','int4');
		$this->setParametro('id_gestion','id_gestion','int4');
		$this->setParametro('nombre','nombre','varchar');
		$this->setParametro('codigo','codigo','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarUnidadEjecutora(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pre.ft_unidad_ejecutora_ime';
		$this->transaccion='PRE_UND_EJE_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_unidad_ejecutora','id_unidad_ejecutora','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

    function validarCampos(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='pre.ft_unidad_ejecutora_ime';
        $this->transaccion='PRE_UND_EJE_VAL';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('codigo','codigo','varchar');
        $this->setParametro('nombre','nombre','varchar');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
			
}
?>