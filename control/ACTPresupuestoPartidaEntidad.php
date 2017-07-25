<?php
/**
*@package pXP
*@file gen-ACTPresupuestoPartidaEntidad.php
*@author  (franklin.espinoza)
*@date 21-07-2017 12:58:43
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTPresupuestoPartidaEntidad extends ACTbase{    
			
	function listarPresupuestoPartidaEntidad(){
		$this->objParam->defecto('ordenacion','id_presupuesto_partida_entidad');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODPresupuestoPartidaEntidad','listarPresupuestoPartidaEntidad');
		} else{
			$this->objFunc=$this->create('MODPresupuestoPartidaEntidad');
			
			$this->res=$this->objFunc->listarPresupuestoPartidaEntidad($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarPresupuestoPartidaEntidad(){
		$this->objFunc=$this->create('MODPresupuestoPartidaEntidad');	
		if($this->objParam->insertar('id_presupuesto_partida_entidad')){
			$this->res=$this->objFunc->insertarPresupuestoPartidaEntidad($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarPresupuestoPartidaEntidad($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarPresupuestoPartidaEntidad(){
			$this->objFunc=$this->create('MODPresupuestoPartidaEntidad');	
		$this->res=$this->objFunc->eliminarPresupuestoPartidaEntidad($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

    function validarCampos(){
        $this->objFunc=$this->create('MODPresupuestoPartidaEntidad');
        $this->res=$this->objFunc->validarCampos($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
			
}

?>