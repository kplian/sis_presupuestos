<?php
/**
*@package pXP
*@file gen-ACTMemoriaCalculo.php
*@author  (admin)
*@date 01-03-2016 14:22:24
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/
require_once(dirname(__FILE__).'/../../pxp/pxpReport/DataSource.php');
require_once(dirname(__FILE__).'/../reportes/RMemoriaCalculo.php');
class ACTMemoriaCalculo extends ACTbase{    
			
	function listarMemoriaCalculo(){
		$this->objParam->defecto('ordenacion','id_memoria_calculo');

		$this->objParam->defecto('dir_ordenacion','asc');
		
		if($this->objParam->getParametro('id_presupuesto')!=''){
            $this->objParam->addFiltro("mca.id_presupuesto = ".$this->objParam->getParametro('id_presupuesto'));    
        }
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODMemoriaCalculo','listarMemoriaCalculo');
		} else{
			$this->objFunc=$this->create('MODMemoriaCalculo');
			
			$this->res=$this->objFunc->listarMemoriaCalculo($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarMemoriaCalculo(){
		$this->objFunc=$this->create('MODMemoriaCalculo');	
		if($this->objParam->insertar('id_memoria_calculo')){
			$this->res=$this->objFunc->insertarMemoriaCalculo($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarMemoriaCalculo($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarMemoriaCalculo(){
		$this->objFunc=$this->create('MODMemoriaCalculo');	
		$this->res=$this->objFunc->eliminarMemoriaCalculo($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	
	function recuperarMemoriaCalculo(){    	
		$this->objFunc = $this->create('MODMemoriaCalculo');
		$cbteHeader = $this->objFunc->listarRepMemoriaCalculo($this->objParam);
		if($cbteHeader->getTipo() == 'EXITO'){				
			return $cbteHeader;
		}
        else{
		    $cbteHeader->imprimirRespuesta($cbteHeader->generarJson());
			exit;
		}              
		
    }
	
	function recuperarDatosGestion(){    	
		$this->objFunc = $this->create('sis_parametros/MODGestion');
		$cbteHeader = $this->objFunc->obtenerGestionById($this->objParam);
		if($cbteHeader->getTipo() == 'EXITO'){				
			return $cbteHeader;
		}
        else{
		    $cbteHeader->imprimirRespuesta($cbteHeader->generarJson());
			exit;
		}              
		
    }
	
	function recuperarDatosEmpresa(){    	
		$this->objFunc = $this->create('sis_parametros/MODEmpresa');
		$cbteHeader = $this->objFunc->getEmpresa($this->objParam);
		if($cbteHeader->getTipo() == 'EXITO'){				
			return $cbteHeader;
		}
        else{
		    $cbteHeader->imprimirRespuesta($cbteHeader->generarJson());
			exit;
		}              
	}
	
	
	
	
	
	
	
	
	function reporteMemoriaCalculo(){
		
			
		$nombreArchivo = uniqid(md5(session_id()).'Memoria') . '.pdf'; 
		$dataSource = $this->recuperarMemoriaCalculo();
		$dataGestion = $this->recuperarDatosGestion();
		$dataEmpresa = $this->recuperarDatosEmpresa();
		
		
		//parametros basicos
		$tamano = 'LETTER';
		$orientacion = 'P';
		$titulo = 'Consolidado';
		
		
		$this->objParam->addParametro('orientacion',$orientacion);
		$this->objParam->addParametro('tamano',$tamano);		
		$this->objParam->addParametro('titulo_archivo',$titulo);        
		$this->objParam->addParametro('nombre_archivo',$nombreArchivo);
		
		//Instancia la clase de pdf
		$reporte = new RMemoriaCalculo($this->objParam);  
		
         
		$reporte->datosHeader($dataSource->getDatos(),  $dataSource->extraData,$dataGestion->getDatos(),$dataEmpresa->getDatos());
		//$this->objReporteFormato->renderDatos($this->res2->datos);
		
		$reporte->generarReporte();
		$reporte->output($reporte->url_archivo,'F');
		
		$this->mensajeExito=new Mensaje();
		$this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado','Se generó con éxito el reporte: '.$nombreArchivo,'control');
		$this->mensajeExito->setArchivoGenerado($nombreArchivo);
		$this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());
		
	}
			
}

?>