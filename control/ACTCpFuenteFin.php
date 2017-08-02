<?php
/**
*@package pXP
*@file gen-ACTCpFuenteFin.php
*@author  (admin)
*@date 19-04-2016 14:40:45
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTCpFuenteFin extends ACTbase{    
			
	function listarCpFuenteFin(){
		$this->objParam->defecto('ordenacion','id_cp_fuente_fin');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('id_gestion')!=''){
	    	$this->objParam->addFiltro("id_gestion = ".$this->objParam->getParametro('id_gestion'));	
		}
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODCpFuenteFin','listarCpFuenteFin');
		} else{
			$this->objFunc=$this->create('MODCpFuenteFin');
			
			$this->res=$this->objFunc->listarCpFuenteFin($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarCpFuenteFin(){
		$this->objFunc=$this->create('MODCpFuenteFin');	
		if($this->objParam->insertar('id_cp_fuente_fin')){
			$this->res=$this->objFunc->insertarCpFuenteFin($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarCpFuenteFin($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarCpFuenteFin(){
			$this->objFunc=$this->create('MODCpFuenteFin');	
		$this->res=$this->objFunc->eliminarCpFuenteFin($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>