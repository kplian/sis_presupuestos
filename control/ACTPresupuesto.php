<?php
/**
*@package pXP
*@file gen-ACTPresupuesto.php
*@author  Gonzalo Sarmiento Sejas
*@date 26-11-2012 21:35:35
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/
/*
require_once(dirname(__FILE__).'/../../sis_mantenimiento/reportes/pxpReport/ReportWriter.php');
require_once(dirname(__FILE__).'/../../sis_mantenimiento/reportes/RPresupuesto.php');
require_once(dirname(__FILE__).'/../../sis_mantenimiento/reportes/pxpReport/DataSource.php');
require_once(dirname(__FILE__).'/../../sis_mantenimiento/reportes/pxpReport/DataSource.php');
*/
require_once(dirname(__FILE__).'/../../sis_presupuestos/reportes/RCertificacionPresupuestaria.php');
require_once(dirname(__FILE__).'/../../sis_presupuestos/reportes/RPoaPDF.php');
require_once(dirname(__FILE__).'/../../sis_presupuestos/reportes/RNotaIntern.php');

class ACTPresupuesto extends ACTbase{    
			
	function listarPresupuesto(){
		$this->objParam->defecto('ordenacion','id_presupuesto');

		$this->objParam->defecto('dir_ordenacion','asc');
		$this->objParam->addParametro('id_funcionario_usu',$_SESSION["ss_id_funcionario"]);
        $this->objParam->addParametro('tipo_interfaz',$this->objParam->getParametro('tipo_interfaz'));

        if(strtolower($this->objParam->getParametro('estado'))=='borrador'){
             $this->objParam->addFiltro("(pre.estado in (''borrador''))");
        }
		if(strtolower($this->objParam->getParametro('estado'))=='en_proceso'){
             $this->objParam->addFiltro("(pre.estado not in (''borrador'',''aprobado''))");
        }
		if(strtolower($this->objParam->getParametro('estado'))=='finalizados'){
             $this->objParam->addFiltro("(pre.estado in (''aprobado''))");
        }
		
		if($this->objParam->getParametro('id_gestion')!=''){
	    	$this->objParam->addFiltro("vcc.id_gestion = ".$this->objParam->getParametro('id_gestion'));	
		}
		
		if($this->objParam->getParametro('codigos_tipo_pres')!=''){
	    	$this->objParam->addFiltro("(pre.tipo_pres::integer in (".$this->objParam->getParametro('codigos_tipo_pres').") or pre.tipo_pres is null or pre.tipo_pres = '''')");	
		}
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam, $this);
			$this->res = $this->objReporte->generarReporteListado('MODPresupuesto','listarPresupuesto');
		} else{
			$this->objFunc=$this->create('MODPresupuesto');	
			$this->res=$this->objFunc->listarPresupuesto();
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}


	function listarPresupuestoRest(){
		$this->objParam->addParametro('gestion',$this->objParam->getParametro('gestion'));
		$this->objFunc=$this->create('MODPresupuesto');
		$this->res=$this->objFunc->listarPresupuestoRest();
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

    function listarPresupuestoCmb(){
		$this->objParam->defecto('ordenacion','id_presupuesto');

		$this->objParam->defecto('dir_ordenacion','asc');
		$this->objParam->addParametro('id_funcionario_usu',$_SESSION["ss_id_funcionario"]); 
		
		
		
        if($this->objParam->getParametro('estado')!=''){
	    	$this->objParam->addFiltro("estado = ''".$this->objParam->getParametro('estado')."''");	
		}
		
		
		if($this->objParam->getParametro('id_gestion')!=''){
	    	$this->objParam->addFiltro("id_gestion = ".$this->objParam->getParametro('id_gestion'));	
		}
		
		if($this->objParam->getParametro('codigos_tipo_pres')!=''){
	    	$this->objParam->addFiltro("(tipo_pres::integer in (".$this->objParam->getParametro('codigos_tipo_pres').") or tipo_pres is null or tipo_pres = '''')");	
		}
		
		if($this->objParam->getParametro('movimiento_tipo_pres')!=''){
	    	$this->objParam->addFiltro("movimiento_tipo_pres = ''".$this->objParam->getParametro('movimiento_tipo_pres')."''");	
		}
		
		if($this->objParam->getParametro('sw_oficial')!=''){
	    	$this->objParam->addFiltro("sw_oficial = ''".$this->objParam->getParametro('sw_oficial')."''");	
		}
		
		if($this->objParam->getParametro('sw_consolidado')!=''){
	    	$this->objParam->addFiltro("sw_consolidado = ''".$this->objParam->getParametro('sw_consolidado')."''");	
		}
		
		if($this->objParam->getParametro('tipo_ajuste')!='' && 
		   $this->objParam->getParametro('nro_tramite')!='' && 
		   $this->objParam->getParametro('id_gestion')!=''){
	    	  	
	    	  $this->objParam->addFiltro("id_presupuesto in (select x.id_presupuesto from pre.vpartida_ejecucion_check x where   x.id_gestion =  ".$this->objParam->getParametro('id_gestion')." and  x.nro_tramite = ''".$this->objParam->getParametro('nro_tramite')."'')");	
	    	
	    	  
		}
		
		
		
		
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam, $this);
			$this->res = $this->objReporte->generarReporteListado('MODPresupuesto','listarPresupuestoCmb');
		} else{
			$this->objFunc=$this->create('MODPresupuesto');	
			$this->res=$this->objFunc->listarPresupuestoCmb();
		}

       if($this->objParam->getParametro('_adicionar')!=''){
		    
			$respuesta = $this->res->getDatos();
			
			array_unshift ( $respuesta, array(  'id_presupuesto'=>'0',
		                                'codigo_cc'=>'Todos',
									    'descripcion'=>'Todos',
										'desc_tipo_presupuesto'=>'Todos',
										'estado'=>'Todos',
										'desc_tipo_presupuesto'=>'Todos',
										'movimiento_tipo_pres'=>'Todos',
										'tipo'=>'Todos'));
		    //var_dump($respuesta);
			$this->res->setDatos($respuesta);
		}

		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarPresupuesto(){
		$this->objFunc=$this->create('MODPresupuesto');	
		if($this->objParam->insertar('id_presupuesto')){
			$this->res=$this->objFunc->insertarPresupuesto();			
		} else{			
			$this->res=$this->objFunc->modificarPresupuesto();
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarPresupuesto(){
		$this->objFunc=$this->create('MODPresupuesto');	
		$this->res=$this->objFunc->eliminarPresupuesto();
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
    
    function reportePresupuesto(){
        $dataSource = new DataSource();
        $idPresupuesto = $this->objParam->getParametro('id_presupuesto');
        $this->objParam->addParametroConsulta('id_presupuesto',$idPresupuesto);
        $this->objParam->addParametroConsulta('ordenacion','id_presupuesto');
        $this->objParam->addParametroConsulta('dir_ordenacion','ASC');
        $this->objParam->addParametroConsulta('cantidad',1000);
        $this->objParam->addParametroConsulta('puntero',0);
        $this->objFunc = $this->create('MODPresupuesto');
        $resultPresupuesto = $this->objFunc->reportePresupuesto();
        $datosPresupuesto = $resultPresupuesto->getDatos();
        
        $dataSource->putParameter('moneda', $datosPresupuesto[0]['moneda']);
        
        $presupuestoDataSource = new DataSource();
        $presupuestoDataSource->setDataSet($resultPresupuesto->getDatos());
        $dataSource->putParameter('presupuestoDataSource', $presupuestoDataSource);
        
        //build the report
        $reporte = new RPresupuesto();
        $reporte->setDataSource($dataSource);
        $nombreArchivo = 'ReportePresupuesto.pdf';
        $reportWriter = new ReportWriter($reporte, dirname(__FILE__).'/../../reportes_generados/'.$nombreArchivo);
        $reportWriter->writeReport(ReportWriter::PDF);
        
        $mensajeExito = new Mensaje();
        $mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado',
                                        'Se generó con éxito el reporte: '.$nombreArchivo,'control');
        $mensajeExito->setArchivoGenerado($nombreArchivo);
        $this->res = $mensajeExito;
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function graficaPresupuesto(){
        $idPresupuesto = $this->objParam->getParametro('id_presupuesto');
        
        $this->objParam->defecto('ordenacion','id_presupuesto');
        $this->objParam->defecto('id_presupuesto',$idPresupuesto);
        $this->objParam->defecto('dir_ordenacion','asc');
        $this->objParam->defecto('cantidad',1000);
        $this->objParam->defecto('puntero',0);
        
        $this->objFunc=$this->create('MODPresupuesto');
        $this->objFunc->setCount(false); 
        $this->res=$this->objFunc->reportePresupuesto();        
        $this->res->imprimirRespuesta($this->res->generarJson());        
    }
	
	function clonarPresupuestosGestion(){
		$this->objFunc=$this->create('MODPresupuesto');	
		$this->res=$this->objFunc->clonarPresupuestosGestion();
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function iniciarTramite(){
		$this->objParam->addParametro('id_funcionario_usu',$_SESSION["ss_id_funcionario"]); 
		$this->objFunc=$this->create('MODPresupuesto');	
		$this->res=$this->objFunc->iniciarTramite();
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function siguienteEstadoPresupuesto(){
        $this->objFunc=$this->create('MODPresupuesto');  
        $this->res=$this->objFunc->siguienteEstadoPresupuesto($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

   function anteriorEstadoPresupuesto(){
        $this->objFunc=$this->create('MODPresupuesto');  
        $this->res=$this->objFunc->anteriorEstadoPresupuesto($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
	

	//Reporte Certificación Presupuestaria (FEA) 13/07/2017
	function reporteCertificacionP (){
		$this->objFunc=$this->create('MODPresupuesto');
		$dataSource=$this->objFunc->reporteCertificacionP();
		$this->dataSource=$dataSource->getDatos();

		$nombreArchivo = uniqid(md5(session_id()).'[Reporte-CertificaciónPresupuestaria]').'.pdf';
		$this->objParam->addParametro('orientacion','P');
		$this->objParam->addParametro('tamano','LETTER');
		$this->objParam->addParametro('nombre_archivo',$nombreArchivo);

		$this->objReporte = new RCertificacionPresupuestaria($this->objParam);
		$this->objReporte->setDatos($this->dataSource);
		$this->objReporte->generarReporte();
		$this->objReporte->output($this->objReporte->url_archivo,'F');


		$this->mensajeExito=new Mensaje();
		$this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado', 'Se generó con éxito el reporte: '.$nombreArchivo,'control');
		$this->mensajeExito->setArchivoGenerado($nombreArchivo);
		$this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());
	}

    //Reporte POA (FEA) 31/07/2017
    function reportePOA (){
        $this->objFunc=$this->create('MODPresupuesto');
        $dataSource=$this->objFunc->reportePOA();
        $this->dataSource=$dataSource->getDatos();

        $nombreArchivo = uniqid(md5(session_id()).'[Reporte-POA]').'.pdf';
        $this->objParam->addParametro('orientacion','L');
        $this->objParam->addParametro('tamano','LETTER');
        $this->objParam->addParametro('nombre_archivo',$nombreArchivo);

        $this->objReporte = new RPoaPDF($this->objParam);
        $this->objReporte->setDatos($this->dataSource);
        $this->objReporte->generarReporte();
        $this->objReporte->output($this->objReporte->url_archivo,'F');


        $this->mensajeExito=new Mensaje();
        $this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado', 'Se generó con éxito el reporte: '.$nombreArchivo,'control');
        $this->mensajeExito->setArchivoGenerado($nombreArchivo);
        $this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());
    }
    function notaInterna(){
        $this->objFunc=$this->create('MODPresupuesto');
        $dataSource=$this->objFunc->listarNotaInterna();
        $this->dataSource=$dataSource->getDatos();
        //var_dump($this->dataSource);exit;
        $nombreArchivo = uniqid(md5(session_id()).'[Reporte-POA]').'.pdf';
        $this->objParam->addParametro('orientacion','P');
        $this->objParam->addParametro('tamano','LETTER');
        $this->objParam->addParametro('nombre_archivo',$nombreArchivo);

        $this->objReporte = new RNotaIntern($this->objParam);
        $this->objReporte->setDatos($this->dataSource);
        $this->objReporte->generarReporte();
        $this->objReporte->output($this->objReporte->url_archivo,'F');


        $this->mensajeExito=new Mensaje();
        $this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado', 'Se generó con éxito el reporte: '.$nombreArchivo,'control');
        $this->mensajeExito->setArchivoGenerado($nombreArchivo);
        $this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());
    }

}

?>