<?php
/**
*@package pXP
*@file gen-ACTClaseGasto.php
*@author  (admin)
*@date 26-02-2016 01:22:22
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTClaseGasto extends ACTbase{    
			
	function listarClaseGasto(){
		$this->objParam->defecto('ordenacion','id_clase_gasto');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODClaseGasto','listarClaseGasto');
		} else{
			$this->objFunc=$this->create('MODClaseGasto');
			
			$this->res=$this->objFunc->listarClaseGasto($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarClaseGasto(){
		$this->objFunc=$this->create('MODClaseGasto');	
		if($this->objParam->insertar('id_clase_gasto')){
			$this->res=$this->objFunc->insertarClaseGasto($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarClaseGasto($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarClaseGasto(){
			$this->objFunc=$this->create('MODClaseGasto');	
		$this->res=$this->objFunc->eliminarClaseGasto($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>