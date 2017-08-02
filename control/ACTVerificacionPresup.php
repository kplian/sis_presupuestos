<?php
/**
*@package pXP
*@file ACTVerificacionPresup.php
*@author  RCM
*@date 	20/12/2013
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTVerificacionPresup extends ACTbase{    
			
	function verificarPresup(){
		$this->objParam->defecto('ordenacion','desc_partida');
		$this->objParam->defecto('dir_ordenacion','asc');
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam, $this);
			$this->res = $this->objReporte->generarReporteListado('MODVerificacionPresup','verificarPresup');
		} else{
			$this->objFunc=$this->create('MODVerificacionPresup');	
			$this->res=$this->objFunc->verificarPresup();
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}			
}

?>