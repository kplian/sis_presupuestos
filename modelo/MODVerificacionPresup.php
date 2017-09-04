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
		
		$this->captura('id_ver','bigint');
		$this->captura('control_partida','VARCHAR');
		$this->captura('id_par','int4');
		$this->captura('id_agrupador','INTEGER');
		$this->captura('monto_mo','NUMERIC');		
		$this->captura('movimiento','VARCHAR');
		$this->captura('id_presupuesto','INTEGER');
		$this->captura('tipo_cambio','NUMERIC');
		$this->captura('monto_mb','NUMERIC');
		$this->captura('verificacion','VARCHAR');
		$this->captura('saldo','NUMERIC');		
		$this->captura('codigo_partida','VARCHAR');
		$this->captura('nombre_partida','VARCHAR');
		$this->captura('desc_tipo_presupuesto','VARCHAR');
		$this->captura('descripcion','VARCHAR');		
		$this->captura('desc_cp','VARCHAR');
		$this->captura('codigo_categoria','VARCHAR');
		$this->captura('codigo_tcc','VARCHAR');
		$this->captura('desc_tcc','VARCHAR');
		
		$this->captura('pre_verificar_categoria','VARCHAR');
		$this->captura('pre_verificar_tipo_cc','VARCHAR');
		
		
		
		
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		//echo $this->consulta;exit;
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
    
}
?>