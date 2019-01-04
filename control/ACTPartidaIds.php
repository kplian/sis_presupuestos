<?php
/**
*@package pXP
*@file gen-ACTPartidaIds.php
*@author  (miguel.mamani)
*@date 17-12-2018 19:20:23
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/
/**
HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
#2			     20/12/2018	            Miguel Mamani			Replicación de partidas y presupuestos
#4				 03/01/2019	            Miguel Mamani			Relación por gestiones paridas y presupuesto e reporte de presupuesto que no figuran en gestión nueva

**/
class ACTPartidaIds extends ACTbase{    
			
	function listarPartidaIds(){
		$this->objParam->defecto('ordenacion','id_partida_uno');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODPartidaIds','listarPartidaIds');
		} else{
			$this->objFunc=$this->create('MODPartidaIds');
			
			$this->res=$this->objFunc->listarPartidaIds($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarPartidaIds(){
		$this->objFunc=$this->create('MODPartidaIds');	
        $this->res=$this->objFunc->insertarPartidaIds($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarPartidaIds(){
        $this->objFunc=$this->create('MODPartidaIds');
		$this->res=$this->objFunc->eliminarPartidaIds($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	////////////////#4/////////////////////////////
    function relacionarPartidaIds(){
        $this->objFunc=$this->create('MODPartidaIds');
        $this->res=$this->objFunc->relacionarPartidaIds($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    ////////////////#4/////////////////////////////
}

?>