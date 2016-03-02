<?php
/**
*@package pXP
*@file gen-ACTMemoriaCalculo.php
*@author  (admin)
*@date 01-03-2016 14:22:24
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTMemoriaCalculo extends ACTbase{    
			
	function listarMemoriaCalculo(){
		$this->objParam->defecto('ordenacion','id_memoria_calculo');

		$this->objParam->defecto('dir_ordenacion','asc');
		
		if($this->objParam->getParametro('id_presupuesto')!=''){
            $this->objParam->addFiltro("mca.id_presupuesto = ".$this->objParam->getParametro('id_presupuesto'));    
        }
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODMemoriaCalculo','listarMemoriaCalculo');
		} else{
			$this->objFunc=$this->create('MODMemoriaCalculo');
			
			$this->res=$this->objFunc->listarMemoriaCalculo($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarMemoriaCalculo(){
		$this->objFunc=$this->create('MODMemoriaCalculo');	
		if($this->objParam->insertar('id_memoria_calculo')){
			$this->res=$this->objFunc->insertarMemoriaCalculo($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarMemoriaCalculo($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarMemoriaCalculo(){
			$this->objFunc=$this->create('MODMemoriaCalculo');	
		$this->res=$this->objFunc->eliminarMemoriaCalculo($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>