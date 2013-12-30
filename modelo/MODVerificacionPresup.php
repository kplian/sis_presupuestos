<?php
/**
*@package pXP
*@file  MODVerificacionPresup.php
*@author  RCM
*@date 	28/12/2013
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODVerificacionPresup extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function verificarPresup(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='pre.f_verificacion_presup_sel';
		$this->transaccion='PRE_VERPRE_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		$this->setCount(false);
		$this->setTipoRetorno('record');	
			
		$this->setParametro('tabla','tabla','varchar');		
		$this->setParametro('id','id','int4');
		
		//Definicion de la lista del resultado del query
		$this->captura('id_partida','int4');
		$this->captura('id_centro_costo','int4');
		$this->captura('id_moneda','int4');
		$this->captura('importe','numeric');
		$this->captura('disponibilidad','varchar');
		$this->captura('desc_partida','text');
		$this->captura('desc_cc','text');
		 
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		//echo $this->consulta;exit;
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
    
}
?>