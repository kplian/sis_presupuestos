<?php
/**
*@package pXP
*@file gen-ACTRelPre.php
*@author  (admin)
*@date 18-04-2016 13:18:06
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTRelPre extends ACTbase{    
			
	function listarRelPre(){
		$this->objParam->defecto('ordenacion','id_rel_pre');

		$this->objParam->defecto('dir_ordenacion','asc');
		
		if($this->objParam->getParametro('id_presupuesto_padre')!=''){
	    	$this->objParam->addFiltro("id_presupuesto_padre = ".$this->objParam->getParametro('id_presupuesto_padre'));	
		}
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODRelPre','listarRelPre');
		} else{
			$this->objFunc=$this->create('MODRelPre');
			
			$this->res=$this->objFunc->listarRelPre($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarRelPre(){
		$this->objFunc=$this->create('MODRelPre');	
		if($this->objParam->insertar('id_rel_pre')){
			$this->res=$this->objFunc->insertarRelPre($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarRelPre($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarRelPre(){
		$this->objFunc=$this->create('MODRelPre');	
		$this->res=$this->objFunc->eliminarRelPre($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function consolidarRelPre(){
		$this->objFunc=$this->create('MODRelPre');	
		$this->res=$this->objFunc->consolidarRelPre($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>