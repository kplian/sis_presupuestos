<?php
/**
*@package pXP
*@file gen-ACTPresupPartida.php
*@author  (admin)
*@date 29-02-2016 19:40:34
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTPresupPartida extends ACTbase{    
			
	function listarPresupPartida(){
		$this->objParam->defecto('ordenacion','id_presup_partida');

		$this->objParam->defecto('dir_ordenacion','asc');
		
		if($this->objParam->getParametro('id_presupuesto')!=''){
            $this->objParam->addFiltro("prpa.id_presupuesto = ".$this->objParam->getParametro('id_presupuesto'));    
        }
		
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODPresupPartida','listarPresupPartida');
		} else{
			$this->objFunc=$this->create('MODPresupPartida');
			
			$this->res=$this->objFunc->listarPresupPartida($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarPresupPartida(){
		$this->objFunc=$this->create('MODPresupPartida');	
		if($this->objParam->insertar('id_presup_partida')){
			$this->res=$this->objFunc->insertarPresupPartida($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarPresupPartida($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarPresupPartida(){
			$this->objFunc=$this->create('MODPresupPartida');	
		$this->res=$this->objFunc->eliminarPresupPartida($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>