<?php
/**
*@package pXP
*@file gen-ACTMemoriaDet.php
*@author  (admin)
*@date 01-03-2016 14:23:08
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTMemoriaDet extends ACTbase{    
			
	function listarMemoriaDet(){
		$this->objParam->defecto('ordenacion','id_memoria_det');

		$this->objParam->defecto('dir_ordenacion','asc');
		
		if($this->objParam->getParametro('id_memoria_calculo')!=''){
            $this->objParam->addFiltro("mdt.id_memoria_calculo = ".$this->objParam->getParametro('id_memoria_calculo'));    
        }
		
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODMemoriaDet','listarMemoriaDet');
		} else{
			$this->objFunc=$this->create('MODMemoriaDet');
			
			$this->res=$this->objFunc->listarMemoriaDet($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarMemoriaDet(){
		$this->objFunc=$this->create('MODMemoriaDet');	
		if($this->objParam->insertar('id_memoria_det')){
			$this->res=$this->objFunc->insertarMemoriaDet($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarMemoriaDet($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarMemoriaDet(){
			$this->objFunc=$this->create('MODMemoriaDet');	
		$this->res=$this->objFunc->eliminarMemoriaDet($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>