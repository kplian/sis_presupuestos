<?php
/**
*@package pXP
*@file gen-ACTEntidadTransferencia.php
*@author  (franklin.espinoza)
*@date 21-07-2017 12:57:45
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTEntidadTransferencia extends ACTbase{    
			
	function listarEntidadTransferencia(){
		$this->objParam->defecto('ordenacion','id_entidad_transferencia');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODEntidadTransferencia','listarEntidadTransferencia');
		} else{
			$this->objFunc=$this->create('MODEntidadTransferencia');
			
			$this->res=$this->objFunc->listarEntidadTransferencia($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarEntidadTransferencia(){
		$this->objFunc=$this->create('MODEntidadTransferencia');	
		if($this->objParam->insertar('id_entidad_transferencia')){
			$this->res=$this->objFunc->insertarEntidadTransferencia($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarEntidadTransferencia($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarEntidadTransferencia(){
			$this->objFunc=$this->create('MODEntidadTransferencia');	
		$this->res=$this->objFunc->eliminarEntidadTransferencia($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

	function validarCampos(){
			$this->objFunc=$this->create('MODEntidadTransferencia');
		$this->res=$this->objFunc->validarCampos($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>