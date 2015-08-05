<?php
/**
*@package pXP
*@file gen-ACTConceptoPartida.php
*@author  (admin)
*@date 25-02-2013 22:09:52
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTConceptoPartida extends ACTbase{    
			
	function listarConceptoPartida(){
		$this->objParam->defecto('ordenacion','id_concepto_partida');

		$this->objParam->defecto('dir_ordenacion','asc');
		
		if($this->objParam->getParametro('id_concepto_ingas')!=''){
	    	$this->objParam->addFiltro("conp.id_concepto_ingas = ''".$this->objParam->getParametro('id_concepto_ingas')."''");	
		}
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODConceptoPartida','listarConceptoPartida');
		} else{
			$this->objFunc=$this->create('MODConceptoPartida');
			
			$this->res=$this->objFunc->listarConceptoPartida($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarConceptoPartida(){
		$this->objFunc=$this->create('MODConceptoPartida');	
		if($this->objParam->insertar('id_concepto_partida')){
			$this->res=$this->objFunc->insertarConceptoPartida($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarConceptoPartida($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarConceptoPartida(){
			$this->objFunc=$this->create('MODConceptoPartida');	
		$this->res=$this->objFunc->eliminarConceptoPartida($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

	function clonarConfig(){
		$this->objFunc=$this->create('MODConceptoPartida');	
		$this->res=$this->objFunc->clonarConfig($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>