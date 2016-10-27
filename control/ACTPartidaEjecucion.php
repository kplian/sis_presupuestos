<?php
/**
*@package pXP
*@file gen-ACTPartidaEjecucion.php
*@author  (gvelasquez)
*@date 03-10-2016 15:47:23
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTPartidaEjecucion extends ACTbase{    
			
	function listarPartidaEjecucion(){
		$this->objParam->defecto('ordenacion','id_partida_ejecucion');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODPartidaEjecucion','listarPartidaEjecucion');
		} else{
			$this->objFunc=$this->create('MODPartidaEjecucion');
			
			$this->res=$this->objFunc->listarPartidaEjecucion($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarPartidaEjecucion(){
		$this->objFunc=$this->create('MODPartidaEjecucion');	
		if($this->objParam->insertar('id_partida_ejecucion')){
			$this->res=$this->objFunc->insertarPartidaEjecucion($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarPartidaEjecucion($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarPartidaEjecucion(){
			$this->objFunc=$this->create('MODPartidaEjecucion');	
		$this->res=$this->objFunc->eliminarPartidaEjecucion($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>