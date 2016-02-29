<?php
/**
*@package pXP
*@file gen-ACTPresupuestoUsuario.php
*@author  (admin)
*@date 29-02-2016 03:25:38
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTPresupuestoUsuario extends ACTbase{    
			
	function listarPresupuestoUsuario(){
		$this->objParam->defecto('ordenacion','id_presupuesto_usuario');

		$this->objParam->defecto('dir_ordenacion','asc');
		
		if($this->objParam->getParametro('id_presupuesto')!=''){
            $this->objParam->addFiltro("preus.id_presupuesto = ".$this->objParam->getParametro('id_presupuesto'));    
        }
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODPresupuestoUsuario','listarPresupuestoUsuario');
		} else{
			$this->objFunc=$this->create('MODPresupuestoUsuario');
			
			$this->res=$this->objFunc->listarPresupuestoUsuario($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarPresupuestoUsuario(){
		$this->objFunc=$this->create('MODPresupuestoUsuario');	
		if($this->objParam->insertar('id_presupuesto_usuario')){
			$this->res=$this->objFunc->insertarPresupuestoUsuario($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarPresupuestoUsuario($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarPresupuestoUsuario(){
			$this->objFunc=$this->create('MODPresupuestoUsuario');	
		$this->res=$this->objFunc->eliminarPresupuestoUsuario($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>