<?php
/**
*@package pXP
*@file ACTConceptoCta.php
*@author  Gonzalo Sarmiento Sejas
*@date 18-02-2013 22:57:58
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTConceptoCta extends ACTbase{    
			
	function listarConceptoCta(){
		$this->objParam->defecto('ordenacion','id_concepto_cta');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODConceptoCta','listarConceptoCta');
		} else{
			$this->objFunc=$this->create('MODConceptoCta');
			
			$this->res=$this->objFunc->listarConceptoCta($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarConceptoCta(){
		$this->objFunc=$this->create('MODConceptoCta');	
		if($this->objParam->insertar('id_concepto_cta')){
			$this->res=$this->objFunc->insertarConceptoCta($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarConceptoCta($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarConceptoCta(){
			$this->objFunc=$this->create('MODConceptoCta');	
		$this->res=$this->objFunc->eliminarConceptoCta($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>