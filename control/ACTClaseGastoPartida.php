<?php
/**
*@package pXP
*@file gen-ACTClaseGastoPartida.php
*@author  (admin)
*@date 26-02-2016 02:33:23
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTClaseGastoPartida extends ACTbase{    
			
	function listarClaseGastoPartida(){
		$this->objParam->defecto('ordenacion','id_clase_gasto_partida');

		$this->objParam->defecto('dir_ordenacion','asc');
		
		if($this->objParam->getParametro('id_clase_gasto')!=''){
            $this->objParam->addFiltro("cgp.id_clase_gasto = ".$this->objParam->getParametro('id_clase_gasto'));    
        }
		
		if($this->objParam->getParametro('id_gestion')!=''){
            $this->objParam->addFiltro("p.id_gestion = ".$this->objParam->getParametro('id_gestion'));    
        }
		
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODClaseGastoPartida','listarClaseGastoPartida');
		} else{
			$this->objFunc=$this->create('MODClaseGastoPartida');
			
			$this->res=$this->objFunc->listarClaseGastoPartida($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarClaseGastoPartida(){
		$this->objFunc=$this->create('MODClaseGastoPartida');	
		if($this->objParam->insertar('id_clase_gasto_partida')){
			$this->res=$this->objFunc->insertarClaseGastoPartida($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarClaseGastoPartida($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarClaseGastoPartida(){
			$this->objFunc=$this->create('MODClaseGastoPartida');	
		$this->res=$this->objFunc->eliminarClaseGastoPartida($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>