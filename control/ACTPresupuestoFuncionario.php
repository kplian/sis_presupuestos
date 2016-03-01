<?php
/**
*@package pXP
*@file gen-ACTPresupuestoUsuario.php
*@author  (admin)
*@date 29-02-2016 03:25:38
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTPresupuestoFuncionario extends ACTbase{    
			
	function listarPresupuestoFuncionario(){
		$this->objParam->defecto('ordenacion','id_presupuesto_funcionario');

		$this->objParam->defecto('dir_ordenacion','asc');
		
		if($this->objParam->getParametro('id_presupuesto')!=''){
            $this->objParam->addFiltro("pf.id_presupuesto = ".$this->objParam->getParametro('id_presupuesto'));    
        }
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODPresupuestoFuncionario','listarPresupuestoFuncionario');
		} else{
			$this->objFunc=$this->create('MODPresupuestoFuncionario');
			
			$this->res=$this->objFunc->listarPresupuestoFuncionario($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarPresupuestoFuncionario(){
		$this->objFunc=$this->create('MODPresupuestoFuncionario');	
		if($this->objParam->insertar('id_presupuesto_funcionario')){
			$this->res=$this->objFunc->insertarPresupuestoFuncionario($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarPresupuestoFuncionario($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarPresupuestoFuncionario(){
			$this->objFunc=$this->create('MODPresupuestoFuncionario');	
		$this->res=$this->objFunc->eliminarPresupuestoFuncionario($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>