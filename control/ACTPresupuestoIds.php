<?php
/**
*@package pXP
*@file gen-ACTPresupuestoIds.php
*@author  (miguel.mamani)
*@date 17-12-2018 19:20:26
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/
/**
HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
#2				 20/12/2018	            Miguel Mamani			Replicación de partidas y presupuestos
#4				 03/01/2019	            Miguel Mamani			Relación por gestiones paridas y presupuesto e reporte de presupuesto que no figuran en gestión nueva

 **/
require_once(dirname(__FILE__).'/../reportes/RMomientoPre.php');
class ACTPresupuestoIds extends ACTbase{    
			
	function listarPresupuestoIds(){
		$this->objParam->defecto('ordenacion','id_presupuesto_uno');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODPresupuestoIds','listarPresupuestoIds');
		} else{
			$this->objFunc=$this->create('MODPresupuestoIds');
			
			$this->res=$this->objFunc->listarPresupuestoIds($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarPresupuestoIds(){
		$this->objFunc=$this->create('MODPresupuestoIds');	
        $this->res=$this->objFunc->insertarPresupuestoIds($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarPresupuestoIds(){
        $this->objFunc=$this->create('MODPresupuestoIds');
        $this->res=$this->objFunc->eliminarPresupuestoIds($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
	}
	///////////////////////#4///////////////////////////
    function relacionarPresupuestoIds(){
        $this->objFunc=$this->create('MODPresupuestoIds');
        $this->res=$this->objFunc->relacionarPresupuestoIds($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    function reporteMovmiento(){
        $this->objFunc = $this->create('MODPresupuestoIds');
        $this->res = $this->objFunc->reporteMovmiento($this->objParam);
        $titulo = 'Reporte Movimiento';
        $nombreArchivo = uniqid(md5(session_id()) . $titulo);
        $nombreArchivo .= '.xls';
        $this->objParam->addParametro('nombre_archivo', $nombreArchivo);
        $this->objParam->addParametro('datos', $this->res->datos);
        //Instancia la clase de excel
        $this->objReporteFormato = new RMomientoPre($this->objParam);
        $this->objReporteFormato->generarDatos();
        $this->objReporteFormato->generarReporte();
        $this->mensajeExito = new Mensaje();
        $this->mensajeExito->setMensaje('EXITO', 'Reporte.php', 'Reporte generado','Se generó con éxito el reporte: ' . $nombreArchivo, 'control');
        $this->mensajeExito->setArchivoGenerado($nombreArchivo);
        $this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());
    }
    ///////////////////////#4///////////////////////////
}

?>