<?php
/**
 *@package pXP
 *@file  ACTConsultasIngas.php
 *@author  (fea)
 *@date 29-09-2013 19:49:23
 *@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
 */
require_once(dirname(__FILE__).'/../../sis_presupuestos/reportes/RConsultaIngasPDF.php');

class ACTConsultasIngas extends ACTbase{

    function listarConsultaConceptoIngas(){
        $this->objParam->defecto('ordenacion','desc_ingas');
        $this->objParam->defecto('dir_ordenacion','asc');

        if($this->objParam->getParametro('id_gestion')!=''){
            $this->objParam->addFiltro("tpar.id_gestion =''".$this->objParam->getParametro('id_gestion')."''");
        }

        if($this->objParam->getParametro('movimiento')!=''){
            $this->objParam->addFiltro("conig.movimiento =''".$this->objParam->getParametro('movimiento')."''");
        }

        if($this->objParam->getParametro('id_entidad')!=''){
            $this->objParam->addFiltro("conig.id_entidad =".$this->objParam->getParametro('id_entidad'));
        }



        if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
            $this->objReporte = new Reporte($this->objParam,$this);
            $this->res = $this->objReporte->generarReporteListado('MODConceptoIngas','listarConsultaConceptoIngas');
        } else{
            $this->objFunc=$this->create('MODConceptoIngas');

            $this->res=$this->objFunc->listarConsultaConceptoIngas($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    
    function exportarPDF(){

        $this->objFunc=$this->create('MODConceptoIngas');
        $dataSource=$this->objFunc->exportarPDF($this->objParam);

        $this->dataSource=$dataSource->getDatos();
        //var_dump($this->res);exit;
        $nombreArchivo = uniqid(md5(session_id()).'[Consulta - ConceptoIngas]').'.pdf';
        $this->objParam->addParametro('orientacion','L');
        $this->objParam->addParametro('tamano','LETTER');
        $this->objParam->addParametro('nombre_archivo',$nombreArchivo);

        $this->reporte = new RConsultaIngasPDF($this->objParam);
        $this->reporte->setDatos($this->dataSource);
        $this->reporte->generarReporte();
        $this->reporte->output($this->reporte->url_archivo,'F');

        $this->mensajeExito=new Mensaje();
        $this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado','Se generó con éxito el reporte: '.$nombreArchivo,'control');
        $this->mensajeExito->setArchivoGenerado($nombreArchivo);
        $this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());
    }

}

?>