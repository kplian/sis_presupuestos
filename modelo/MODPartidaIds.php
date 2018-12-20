<?php
/**
*@package pXP
*@file gen-MODPartidaIds.php
*@author  (miguel.mamani)
*@date 17-12-2018 19:20:23
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/
/**
HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
#2				 20/12/2018	Miguel Mamani			Replicación de partidas y presupuestos
 **/
class MODPartidaIds extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarPartidaIds(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='pre.ft_partida_ids_sel';
		$this->transaccion='PRE_RPS_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
        $this->setParametro('id_gestion','id_gestion','int4');
		//Definicion de la lista del resultado del query
		$this->captura('id_partida_uno','int4');
		$this->captura('id_partida_dos','int4');
		$this->captura('codigo','varchar');
		$this->captura('nombre_partida','varchar');
        $this->captura('gestion','int4');
        $this->captura('codigo_dos','varchar');
        $this->captura('nombre_partida_dos','varchar');
        $this->captura('gestion_dos','int4');
        $this->captura('sw_cambio_gestion','varchar');
		$this->captura('insercion','varchar');
		$this->captura('estado_reg','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','date');
		$this->captura('usr_reg','varchar');
		$this->captura('validar','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarPartidaIds(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pre.ft_partida_ids_ime';
		$this->transaccion='PRE_RPS_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
        $this->setParametro('id_gestion_act','id_gestion_act','int4');
		$this->setParametro('id_partida_uno','id_partida_uno','int4');
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

			
	function eliminarPartidaIds(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pre.ft_partida_ids_ime';
		$this->transaccion='PRE_RPS_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_partida_uno','id_partida_uno','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>