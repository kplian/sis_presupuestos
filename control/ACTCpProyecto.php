<?php
/**
*@package pXP
*@file gen-ACTCpProyecto.php
*@author  (admin)
*@date 19-04-2016 14:40:49
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTCpProyecto extends ACTbase{    
			
	function listarCpProyecto(){
		$this->objParam->defecto('ordenacion','id_cp_proyecto');

		$this->objParam->defecto('dir_ordenacion','asc');
		
		if($this->objParam->getParametro('id_gestion')!=''){
	    	$this->objParam->addFiltro("id_gestion = ".$this->objParam->getParametro('id_gestion'));	
		}
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODCpProyecto','listarCpProyecto');
		} else{
			$this->objFunc=$this->create('MODCpProyecto');
			
			$this->res=$this->objFunc->listarCpProyecto($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarCpProyecto(){
		$this->objFunc=$this->create('MODCpProyecto');	
		if($this->objParam->insertar('id_cp_proyecto')){
			$this->res=$this->objFunc->insertarCpProyecto($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarCpProyecto($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarCpProyecto(){
			$this->objFunc=$this->create('MODCpProyecto');	
		$this->res=$this->objFunc->eliminarCpProyecto($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>