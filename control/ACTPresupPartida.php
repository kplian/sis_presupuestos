<?php
/**
*@package pXP
*@file gen-ACTPresupPartida.php
*@author  (admin)
*@date 29-02-2016 19:40:34
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/
require_once(dirname(__FILE__).'/../../pxp/pxpReport/DataSource.php');
require_once(dirname(__FILE__).'/../reportes/REjecucion.php');
require_once(dirname(__FILE__).'/../reportes/REjecucionXls.php');
require_once(dirname(__FILE__).'/../reportes/REjecucionPorPartida.php');
require_once(dirname(__FILE__).'/../reportes/REjecucionPorPartidaXls.php');
require_once(dirname(__FILE__).'/../reportes/REjecucionGestionAnterior.php');
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
		
		$temp = Array();
		$temp['importe'] = $this->res->extraData['total_importe'];
		$temp['importe_aprobado'] = $this->res->extraData['total_importe_aprobado'];
		$temp['tipo_reg'] = 'summary';
		$temp['id_presup_partida'] = 0;
		
		
		
		
		$this->res->total++;
		
		$this->res->addLastRecDatos($temp);
		
		
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

    function listarPresupPartidaEstado(){
			$this->objParam->defecto('ordenacion','id_presup_partida');
	
			$this->objParam->defecto('dir_ordenacion','asc');
			
			if($this->objParam->getParametro('id_presupuesto')!=''){
	            $this->objParam->addFiltro("prpa.id_presupuesto = ".$this->objParam->getParametro('id_presupuesto'));    
	        }
			
			
			if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
				$this->objReporte = new Reporte($this->objParam,$this);
				$this->res = $this->objReporte->generarReporteListado('MODPresupPartida','listarPresupPartidaEstado');
			} else{
				$this->objFunc=$this->create('MODPresupPartida');
				
				$this->res=$this->objFunc->listarPresupPartidaEstado($this->objParam);
			}
		
			$temp = Array();
			$temp['importe'] = $this->res->extraData['total_importe'];
			$temp['importe_aprobado'] = $this->res->extraData['total_importe_aprobado'];
			$temp['formulado'] = $this->res->extraData['total_importe_formulado'];
			$temp['comprometido'] = $this->res->extraData['total_importe_comprometido'];
			$temp['ejecutado'] = $this->res->extraData['total_importe_ejecutado'];
			$temp['pagado'] = $this->res->extraData['total_importe_pagado'];
			$temp['tipo_reg'] = 'summary';
			$temp['id_presup_partida'] = 0;
			
			
			$this->res->total++;
			
			$this->res->addLastRecDatos($temp);
		
		
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
	
	function verificarPresupuesto(){
		$this->objFunc=$this->create('MODPresupPartida');	
		$this->res=$this->objFunc->verificarPresupuesto($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
    function listarPresupPartidaEstadoXNroTramite(){
			$this->objParam->defecto('ordenacion','id_presup_partida');	
			$this->objParam->defecto('dir_ordenacion','asc');
			
			if($this->objParam->getParametro('nro_tramite')!=''){
	            $this->objParam->addFiltro("prpa.nro_tramite = ''".$this->objParam->getParametro('nro_tramite')."''");    
	        }
			
			
			if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
				$this->objReporte = new Reporte($this->objParam,$this);
				$this->res = $this->objReporte->generarReporteListado('MODPresupPartida','listarPresupPartidaEstadoXNroTramite');
			} else{
				$this->objFunc=$this->create('MODPresupPartida');
				
				$this->res=$this->objFunc->listarPresupPartidaEstadoXNroTramite($this->objParam);
			}
		
			$temp = Array();			
			$temp['comprometido'] = $this->res->extraData['total_importe_comprometido'];
			$temp['ejecutado'] = $this->res->extraData['total_importe_ejecutado'];
			$temp['pagado'] = $this->res->extraData['total_importe_pagado'];
			$temp['tipo_reg'] = 'summary';
			$temp['id_presup_partida'] = 0;
			
			$this->res->total++;
			
			$this->res->addLastRecDatos($temp);
		
		
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

	function listarPresupPartidaComprometidoXNroTramiteRendicion(){
		$this->objParam->defecto('ordenacion','id_presup_partida');
		$this->objParam->defecto('dir_ordenacion','asc');
		/*
		if($this->objParam->getParametro('nro_tramite')!=''){
			$this->objParam->addFiltro("prpa.nro_tramite = ''".$this->objParam->getParametro('nro_tramite')."''");
		}
		*/

		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODPresupPartida','listarPresupPartidaComprometidoXNroTramiteRendicion');
		} else{
			$this->objFunc=$this->create('MODPresupPartida');

			$this->res=$this->objFunc->listarPresupPartidaComprometidoXNroTramiteRendicion($this->objParam);
		}

		$temp = Array();
		$temp['comprometido'] = $this->res->extraData['total_importe_comprometido'];
		$temp['ejecutado'] = $this->res->extraData['total_importe_ejecutado'];
		$temp['pagado'] = $this->res->extraData['total_importe_pagado'];
		$temp['tipo_reg'] = 'summary';
		$temp['id_presup_partida'] = 0;

		$this->res->total++;

		$this->res->addLastRecDatos($temp);


		$this->res->imprimirRespuesta($this->res->generarJson());
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

	function recuperarEjecucion(){    	
		$this->objFunc = $this->create('MODPresupPartida');
		$cbteHeader = $this->objFunc->listarRepEjecucion($this->objParam);
		if($cbteHeader->getTipo() == 'EXITO'){				
			return $cbteHeader;
		}
        else{
		    $cbteHeader->imprimirRespuesta($cbteHeader->generarJson());
			exit;
		}              
		
    }

    function reporteEjecucion(){
		
			    if($this->objParam->getParametro('formato_reporte')=='pdf'){
					$nombreArchivo = 'Ejecucion'.uniqid(md5(session_id())).'.pdf'; 
				}
				else{
					$nombreArchivo = 'Ejecucion'.uniqid(md5(session_id())).'.xls'; 
				}
				
				$dataSource = $this->recuperarEjecucion();
				$dataGestion = $this->recuperarDatosGestion();
				$dataEmpresa = $this->recuperarDatosEmpresa();
				
				
				//parametros basicos
				$tamano = 'LETTER';
				$orientacion = 'L';
				$titulo = 'Consolidado';
				
				
				$this->objParam->addParametro('orientacion',$orientacion);
				$this->objParam->addParametro('tamano',$tamano);		
				$this->objParam->addParametro('titulo_archivo',$titulo);        
				$this->objParam->addParametro('nombre_archivo',$nombreArchivo);
				
				//Instancia la clase de pdf
				if($this->objParam->getParametro('formato_reporte')=='pdf'){
				    $reporte = new REjecucion($this->objParam);
					$reporte->datosHeader($dataSource->getDatos(),  $dataSource->extraData,$dataGestion->getDatos(),$dataEmpresa->getDatos());
				    $reporte->generarReporte();
				    $reporte->output($reporte->url_archivo,'F');  
				}
				else{
					$reporte = new REjecucionXls($this->objParam); 
					$reporte->datosHeader($dataSource->getDatos(),  $dataSource->extraData,$dataGestion->getDatos(),$dataEmpresa->getDatos());
				    $reporte->generarReporte(); 
				}
		         
				
				
				$this->mensajeExito=new Mensaje();
				$this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado','Se generó con éxito el reporte: '.$nombreArchivo,'control');
				$this->mensajeExito->setArchivoGenerado($nombreArchivo);
				$this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());
		
	}

   function recuperarEjecucionPorPartida(){    	
		$this->objFunc = $this->create('MODPresupPartida');
		$cbteHeader = $this->objFunc->listarRepEjecucionPorPartida($this->objParam);
		if($cbteHeader->getTipo() == 'EXITO'){				
			return $cbteHeader;
		}
        else{
		    $cbteHeader->imprimirRespuesta($cbteHeader->generarJson());
			exit;
		}              
		
    }

   function reporteEjecucionPorPartida(){
		
			    if($this->objParam->getParametro('formato_reporte')=='pdf'){
					$nombreArchivo = 'EjecucionPorPartida'.uniqid(md5(session_id())).'.pdf'; 
				}
				else{
					$nombreArchivo = 'EjecucionPorPartida'.uniqid(md5(session_id())).'.xls'; 
				}
				
				$dataSource = $this->recuperarEjecucionPorPartida();
				$dataGestion = $this->recuperarDatosGestion();
				$dataEmpresa = $this->recuperarDatosEmpresa();
				
				
				//parametros basicos
				$tamano = 'LETTER';
				$orientacion = 'L';
				$titulo = 'Consolidado';
				
				
				$this->objParam->addParametro('orientacion',$orientacion);
				$this->objParam->addParametro('tamano',$tamano);		
				$this->objParam->addParametro('titulo_archivo',$titulo);        
				$this->objParam->addParametro('nombre_archivo',$nombreArchivo);
				
				//Instancia la clase de pdf
				if($this->objParam->getParametro('formato_reporte')=='pdf'){
				    $reporte = new REjecucionPorPartida($this->objParam);
					$reporte->datosHeader($dataSource->getDatos(),  $dataSource->extraData,$dataGestion->getDatos(),$dataEmpresa->getDatos());
				    $reporte->generarReporte();
				    $reporte->output($reporte->url_archivo,'F');  
				}
				else{
					$reporte = new REjecucionPorPartidaXls($this->objParam); 
					$reporte->datosHeader($dataSource->getDatos(),  $dataSource->extraData,$dataGestion->getDatos(),$dataEmpresa->getDatos());
				    $reporte->generarReporte(); 
				}
		         
				$this->mensajeExito=new Mensaje();
				$this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado','Se generó con éxito el reporte: '.$nombreArchivo,'control');
				$this->mensajeExito->setArchivoGenerado($nombreArchivo);
				$this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());
		
	}
    function listarPartidaEjecutados(){
        $this->objFunc = $this->create('MODPresupPartida');
        $cbteHeader = $this->objFunc->ejecucionGestionAnterior($this->objParam);
        if($cbteHeader->getTipo() == 'EXITO'){
            return $cbteHeader;
        }
        else{
            $cbteHeader->imprimirRespuesta($cbteHeader->generarJson());
            exit;
        }

    }
    function listarPartidaMemoria(){
        $this->objFunc = $this->create('MODPresupPartida');
        $cbteHeader = $this->objFunc->memoriaGestionAnterior($this->objParam);
        if($cbteHeader->getTipo() == 'EXITO'){
            return $cbteHeader;
        }
        else{
            $cbteHeader->imprimirRespuesta($cbteHeader->generarJson());
            exit;
        }

    }
    function listarPartidaEjecutadoAnterior (){
        $dataSource = $this->listarPartidaEjecutados();
        $dataSourceMemoria = $this->listarPartidaMemoria();
        $nombreArchivo = uniqid(md5(session_id()).'Partidas').'.xls';
        $this->objParam->addParametro('nombre_archivo',$nombreArchivo);
        $reporte = new REjecucionGestionAnterior($this->objParam);
        $reporte->datosHeader($dataSource->getDatos(),$dataSource->extraData,$dataSourceMemoria->getDatos());
        $reporte->generarReporte();
        $this->mensajeExito=new Mensaje();
        $this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado','Se generó con éxito el reporte: '.$nombreArchivo,'control');
        $this->mensajeExito->setArchivoGenerado($nombreArchivo);
        $this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());

    }

			
}

?>