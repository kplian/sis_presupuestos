<?php
/**
*@package pXP
*@file gen-ACTCpOrganismoFin.php
*@author  (admin)
*@date 19-04-2016 14:40:42
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTCpOrganismoFin extends ACTbase{    
			
	function listarCpOrganismoFin(){
		$this->objParam->defecto('ordenacion','id_cp_organismo_fin');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('id_gestion')!=''){
	    	$this->objParam->addFiltro("id_gestion = ".$this->objParam->getParametro('id_gestion'));	
		}
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODCpOrganismoFin','listarCpOrganismoFin');
		} else{
			$this->objFunc=$this->create('MODCpOrganismoFin');
			
			$this->res=$this->objFunc->listarCpOrganismoFin($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarCpOrganismoFin(){
		$this->objFunc=$this->create('MODCpOrganismoFin');	
		if($this->objParam->insertar('id_cp_organismo_fin')){
			$this->res=$this->objFunc->insertarCpOrganismoFin($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarCpOrganismoFin($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarCpOrganismoFin(){
			$this->objFunc=$this->create('MODCpOrganismoFin');	
		$this->res=$this->objFunc->eliminarCpOrganismoFin($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>