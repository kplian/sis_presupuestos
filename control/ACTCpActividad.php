<?php
/**
*@package pXP
*@file gen-ACTCpActividad.php
*@author  (admin)
*@date 19-04-2016 14:40:47
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTCpActividad extends ACTbase{    
			
	function listarCpActividad(){
		$this->objParam->defecto('ordenacion','id_cp_actividad');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('id_gestion')!=''){
	    	$this->objParam->addFiltro("id_gestion = ".$this->objParam->getParametro('id_gestion'));	
		}
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODCpActividad','listarCpActividad');
		} else{
			$this->objFunc=$this->create('MODCpActividad');
			
			$this->res=$this->objFunc->listarCpActividad($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarCpActividad(){
		$this->objFunc=$this->create('MODCpActividad');	
		if($this->objParam->insertar('id_cp_actividad')){
			$this->res=$this->objFunc->insertarCpActividad($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarCpActividad($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarCpActividad(){
			$this->objFunc=$this->create('MODCpActividad');	
		$this->res=$this->objFunc->eliminarCpActividad($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>