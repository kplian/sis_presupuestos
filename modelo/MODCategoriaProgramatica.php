<?php
/**
*@package pXP
*@file gen-MODCategoriaProgramatica.php
*@author  (admin)
*@date 19-04-2016 15:30:34
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODCategoriaProgramatica extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarCategoriaProgramatica(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='pre.ft_categoria_programatica_sel';
		$this->transaccion='PRE_CPR_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_categoria_programatica','int4');
		$this->captura('id_cp_actividad','int4');
		$this->captura('id_gestion','int4');
		$this->captura('id_cp_organismo_fin','int4');
		$this->captura('descripcion','text');
		$this->captura('id_cp_programa','int4');
		$this->captura('id_cp_fuente_fin','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('id_cp_proyecto','int4');
		$this->captura('id_usuario_ai','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		
		
		$this->captura('codigo_programa','varchar');
        $this->captura('codigo_proyecto','varchar');
        $this->captura('codigo_actividad','varchar');
        $this->captura('codigo_fuente_fin','varchar');
        $this->captura('codigo_origen_fin','varchar');
        $this->captura('desc_programa','varchar');
        $this->captura('desc_proyecto','varchar');
        $this->captura('desc_actividad','varchar');
        $this->captura('desc_fuente_fin','varchar');
        $this->captura('desc_origen_fin','varchar');
        $this->captura('codigo_categoria','varchar');
        $this->captura('gestion','integer');
		
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarCategoriaProgramatica(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pre.ft_categoria_programatica_ime';
		$this->transaccion='PRE_CPR_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_cp_actividad','id_cp_actividad','int4');
		$this->setParametro('id_gestion','id_gestion','int4');
		$this->setParametro('id_cp_organismo_fin','id_cp_organismo_fin','int4');
		$this->setParametro('descripcion','descripcion','text');
		$this->setParametro('id_cp_programa','id_cp_programa','int4');
		$this->setParametro('id_cp_fuente_fin','id_cp_fuente_fin','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_cp_proyecto','id_cp_proyecto','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarCategoriaProgramatica(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pre.ft_categoria_programatica_ime';
		$this->transaccion='PRE_CPR_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_categoria_programatica','id_categoria_programatica','int4');
		$this->setParametro('id_cp_actividad','id_cp_actividad','int4');
		$this->setParametro('id_gestion','id_gestion','int4');
		$this->setParametro('id_cp_organismo_fin','id_cp_organismo_fin','int4');
		$this->setParametro('descripcion','descripcion','text');
		$this->setParametro('id_cp_programa','id_cp_programa','int4');
		$this->setParametro('id_cp_fuente_fin','id_cp_fuente_fin','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_cp_proyecto','id_cp_proyecto','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarCategoriaProgramatica(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pre.ft_categoria_programatica_ime';
		$this->transaccion='PRE_CPR_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_categoria_programatica','id_categoria_programatica','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

    function clonarCategoriaProgramatica(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pre.ft_categoria_programatica_ime';
		$this->transaccion='PRE_CLCARPRO_IME';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_gestion','id_gestion','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}


			
}
?>