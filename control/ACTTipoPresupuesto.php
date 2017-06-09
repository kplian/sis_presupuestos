<?php
/**
*@package pXP
*@file gen-ACTTipoPresupuesto.php
*@author  (admin)
*@date 29-02-2016 05:18:02
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTTipoPresupuesto extends ACTbase{    
			
	function listarTipoPresupuesto(){
		$this->objParam->defecto('ordenacion','id_tipo_presupuesto');

		$this->objParam->defecto('dir_ordenacion','asc');
		
		
		if($this->objParam->getParametro('mov_pres')!=''){
			
			if($this->objParam->getParametro('mov_pres') =='{ingreso,egreso}' || $this->objParam->getParametro('mov_pres') =='{egreso,ingreso}'){
				$this->objParam->addFiltro("tipr.movimiento in (''ingreso_egreso'', ''administrativo'')");	
			}
			if($this->objParam->getParametro('mov_pres') =='{ingreso}'){
				$this->objParam->addFiltro("tipr.movimiento in (''recurso'')");	
			}
			if($this->objParam->getParametro('mov_pres') =='{egreso}'){
				$this->objParam->addFiltro("tipr.movimiento in (''gasto'')");	
			}
	    	
		}
		
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODTipoPresupuesto','listarTipoPresupuesto');
		} else{
			$this->objFunc=$this->create('MODTipoPresupuesto');
			
			$this->res=$this->objFunc->listarTipoPresupuesto($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarTipoPresupuesto(){
		$this->objFunc=$this->create('MODTipoPresupuesto');	
		if($this->objParam->insertar('id_tipo_presupuesto')){
			$this->res=$this->objFunc->insertarTipoPresupuesto($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarTipoPresupuesto($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarTipoPresupuesto(){
			$this->objFunc=$this->create('MODTipoPresupuesto');	
		$this->res=$this->objFunc->eliminarTipoPresupuesto($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>