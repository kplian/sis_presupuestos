<?php
/**
*@package pXP
*@file gen-ACTAgrupadorPresupuesto.php
*@author  (gvelasquez)
*@date 25-10-2016 19:21:34
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTAgrupadorPresupuesto extends ACTbase{    
			
	function listarAgrupadorPresupuesto(){
		$this->objParam->defecto('ordenacion','id_agrupador_presupuesto');

		$this->objParam->defecto('dir_ordenacion','asc');

        if($this->objParam->getParametro('id_agrupador')!=''){
            $this->objParam->addFiltro("agrpre.id_agrupador = ".$this->objParam->getParametro('id_agrupador'));
        }

		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODAgrupadorPresupuesto','listarAgrupadorPresupuesto');
		} else{
			$this->objFunc=$this->create('MODAgrupadorPresupuesto');
			
			$this->res=$this->objFunc->listarAgrupadorPresupuesto($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarAgrupadorPresupuesto(){
		$this->objFunc=$this->create('MODAgrupadorPresupuesto');	
		if($this->objParam->insertar('id_agrupador_presupuesto')){
			$this->res=$this->objFunc->insertarAgrupadorPresupuesto($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarAgrupadorPresupuesto($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarAgrupadorPresupuesto(){
			$this->objFunc=$this->create('MODAgrupadorPresupuesto');	
		$this->res=$this->objFunc->eliminarAgrupadorPresupuesto($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>