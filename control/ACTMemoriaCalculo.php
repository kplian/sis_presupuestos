<?php
/*
****************************************************************************
                     HISTORIAL DE MODIFICACIONES:
#ISSUE		FORK		FECHA				AUTOR				DESCRIPCION
  #5         ENDEETR     09/01/2018         Manuel Guerra      Se corrigió y agrego funcionalidades a la importación subida del archivo de presupuestos. 
*/

require_once(dirname(__FILE__).'/../../pxp/pxpReport/DataSource.php');
require_once(dirname(__FILE__).'/../reportes/RMemoriaCalculo.php');
require_once(dirname(__FILE__).'/../reportes/RMemoriaCalculoXls.php');
require_once(dirname(__FILE__).'/../reportes/RMemoriaProgramacion.php');
require_once(dirname(__FILE__).'/../reportes/RMemoriaProgramacionXls.php');
require_once(dirname(__FILE__).'/../reportes/RMemoriaCalculaWf.php');
require_once(dirname(__FILE__).'/../reportes/RMemoriaProgramacionWf.php');
require_once(dirname(__FILE__).'/../reportes/RMemCalMensualPDF.php');
require_once(dirname(__FILE__).'/../reportes/RMemoriaCalculoMensualXls.php');


class ACTMemoriaCalculo extends ACTbase{

	function listarMemoriaCalculo(){
		$this->objParam->defecto('ordenacion','id_memoria_calculo');

		$this->objParam->defecto('dir_ordenacion','asc');
		
		if($this->objParam->getParametro('id_presupuesto')!=''){
            $this->objParam->addFiltro("mca.id_presupuesto = ".$this->objParam->getParametro('id_presupuesto'));    
        }

		if($this->objParam->getParametro('id_objetivo')!=''){
			$this->objParam->addFiltro("mca.id_objetivo = ".$this->objParam->getParametro('id_objetivo'));
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

				if($this->objParam->getParametro('tipo_rep') == 'general') {

					if($this->objParam->getParametro('formato_reporte')=='pdf'){
						$nombreArchivo = uniqid(md5(session_id()).'Memoria') . '.pdf';
					}
					else{
						$nombreArchivo = uniqid(md5(session_id()).'Memoria') . '.xls';
					}

					$dataSource = $this->recuperarMemoriaCalculo();
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
						$reporte = new RMemoriaCalculo($this->objParam);
						$reporte->datosHeader($dataSource->getDatos(),  $dataSource->extraData,$dataGestion->getDatos(),$dataEmpresa->getDatos());
						$reporte->generarReporte();
						$reporte->output($reporte->url_archivo,'F');
					}
					else{
						$reporte = new RMemoriaCalculoXls($this->objParam);
						$reporte->datosHeader($dataSource->getDatos(),  $dataSource->extraData,$dataGestion->getDatos(),$dataEmpresa->getDatos());
						$reporte->generarReporte();
					}



					$this->mensajeExito=new Mensaje();
					$this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado','Se generó con éxito el reporte: '.$nombreArchivo,'control');
					$this->mensajeExito->setArchivoGenerado($nombreArchivo);
					$this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());

				} else {
					if($this->objParam->getParametro('formato_reporte')=='pdf'){
					    $this->reporteMemoriaCalculoMensual();
					}
					else{
						//$this->reporteMemoriaCalculoMensualXLS();
						
						$nombreArchivo = uniqid(md5(session_id()).'Memoria') . '.xls';
						
						/*$dataSource = $this->recuperarMemoriaCalculoXLS();
						$dataGestion = $this->recuperarDatosGestion();
						$dataEmpresa = $this->recuperarDatosEmpresa();*/
						
						$dataSource = $this->recuperarMemoriaCalculoXLS();
						$dataGestion = $this->recuperarDatosGestion();
						$dataEmpresa = $this->recuperarDatosEmpresa();
					
						$tamano = 'LETTER';
						$orientacion = 'L';
						$titulo = 'Consolidado';
	
	
						$this->objParam->addParametro('orientacion',$orientacion);
						$this->objParam->addParametro('tamano',$tamano);
						$this->objParam->addParametro('titulo_archivo',$titulo);
						$this->objParam->addParametro('nombre_archivo',$nombreArchivo);
						/*$reporte = new RMemoriaCalculoMensualXls($this->objParam);
						$reporte->datosHeader($dataSource->getDatos(),  $dataSource->extraData,$dataGestion->getDatos(),$dataEmpresa->getDatos());
						$reporte->generarReporte();*/
						
						$reporte = new RMemoriaCalculoMensualXls($this->objParam);
						$reporte->datosHeader($dataSource->getDatos(),  $dataSource->extraData,$dataGestion->getDatos(),$dataEmpresa->getDatos());
						$reporte->generarReporte();
						
						$this->mensajeExito=new Mensaje();
						$this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado','Se generó con éxito el reporte: '.$nombreArchivo,'control');
						$this->mensajeExito->setArchivoGenerado($nombreArchivo);
						$this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());
					}
				}

	}

    function recuperarProgramacion(){    	
		$this->objFunc = $this->create('MODMemoriaCalculo');
		$cbteHeader = $this->objFunc->listarRepProgramacion($this->objParam);
		if($cbteHeader->getTipo() == 'EXITO'){				
			return $cbteHeader;
		}
        else{
		    $cbteHeader->imprimirRespuesta($cbteHeader->generarJson());
			exit;
		}              
		
    }

    function reporteProgramacion(){
		
			    if($this->objParam->getParametro('formato_reporte')=='pdf'){
					$nombreArchivo = uniqid(md5(session_id()).'Programacion').'.pdf'; 
				}
				else{
					$nombreArchivo = uniqid(md5(session_id()).'Programacion').'.xls'; 
				}
				
				$dataSource = $this->recuperarProgramacion();
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
				    $reporte = new RMemoriaProgramacion($this->objParam);
					$reporte->datosHeader($dataSource->getDatos(),  $dataSource->extraData,$dataGestion->getDatos(),$dataEmpresa->getDatos());
				    $reporte->generarReporte();
				    $reporte->output($reporte->url_archivo,'F');  
				}
				else{
					$reporte = new RMemoriaProgramacionXls($this->objParam); 
					$reporte->datosHeader($dataSource->getDatos(),  $dataSource->extraData,$dataGestion->getDatos(),$dataEmpresa->getDatos());
				    $reporte->generarReporte(); 
				}
		         
				
				
				$this->mensajeExito=new Mensaje();
				$this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado','Se generó con éxito el reporte: '.$nombreArchivo,'control');
				$this->mensajeExito->setArchivoGenerado($nombreArchivo);
				$this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());
		
	}

	function listarMemoriaCalculoXPartida(){

			$this->objParam->defecto('ordenacion','id_concepto_ingas');
			$this->objParam->defecto('dir_ordenacion','asc');


			if($this->objParam->getParametro('tipo')!=''){

				if($this->objParam->getParametro('tipo')=='Bien'){
					$this->objParam->addFiltro("conig.tipo =''Bien''");
				}
				if($this->objParam->getParametro('tipo')=='Servicio'){
					$this->objParam->addFiltro("conig.tipo =''Servicio''");
				}
			}

			if($this->objParam->getParametro('movimiento')!=''){
				if(  $this->objParam->getParametro('movimiento') == 'ingreso_egreso'){
					$this->objParam->addFiltro("conig.movimiento in (''ingreso'',''gasto'')");
				}
				else{
					$this->objParam->addFiltro("conig.movimiento =''".$this->objParam->getParametro('movimiento')."''");
				}

			}

			if($this->objParam->getParametro('id_gestion')!=''){
				$this->objParam->addFiltro("par.id_gestion =".$this->objParam->getParametro('id_gestion'));
			}

			if($this->objParam->getParametro('requiere_ot')!=''){
				$this->objParam->addFiltro("conig.requiere_ot =''".$this->objParam->getParametro('requiere_ot')."''");
			}

			if($this->objParam->getParametro('id_concepto_ingas')!=''){
				$this->objParam->addFiltro("conig.id_concepto_ingas =''".$this->objParam->getParametro('id_concepto_ingas')."''");
			}



			if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
				$this->objReporte = new Reporte($this->objParam,$this);
				$this->res = $this->objReporte->generarReporteListado('MODMemoriaCalculo','listarMemoriaCalculoXPartida');
			} else{
				$this->objFunc=$this->create('MODMemoriaCalculo');

				$this->res=$this->objFunc->listarMemoriaCalculoXPartida($this->objParam);
			}
			$this->res->imprimirRespuesta($this->res->generarJson());
	}


	function recuperarMemoriaCalculoWf(){
        $this->objFunc = $this->create('MODMemoriaCalculo');
        $cbteHeader = $this->objFunc->listarMemoriaCalculoWf($this->objParam);
        if($cbteHeader->getTipo() == 'EXITO'){
            return $cbteHeader;
        }
        else{
            $cbteHeader->imprimirRespuesta($cbteHeader->generarJson());
            exit;
        }

    }
    function reporteMemoriaCalculoWf(){
        $nombreArchivo = uniqid(md5(session_id()).'Memoria') . '.pdf';
        $dataSource = $this->recuperarMemoriaCalculoWf();
        $dataEmpresa = $this->recuperarDatosEmpresa();
        //parametros basicos
        $tamano = 'LETTER';
        $orientacion = 'L';
        $titulo = 'Consolidado';
        $this->objParam->addParametro('orientacion',$orientacion);
        $this->objParam->addParametro('tamano',$tamano);
        $this->objParam->addParametro('titulo_archivo',$titulo);
        $this->objParam->addParametro('nombre_archivo',$nombreArchivo);
        $reporte = new RMemoriaCalculaWf($this->objParam);
        $reporte->datosHeader($dataSource->getDatos(),  $dataSource->extraData,$dataEmpresa->getDatos());
        $reporte->generarReporte();
        $reporte->output($reporte->url_archivo,'F');
        $this->mensajeExito=new Mensaje();
        $this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado','Se generó con éxito el reporte: '.$nombreArchivo,'control');
        $this->mensajeExito->setArchivoGenerado($nombreArchivo);
        $this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());
    }
    function recuperarProgramacionWf(){
        $this->objFunc = $this->create('MODMemoriaCalculo');
        $cbteHeader = $this->objFunc->listarRepProgramacionWf($this->objParam);
        if($cbteHeader->getTipo() == 'EXITO'){
            return $cbteHeader;
        }
        else{
            $cbteHeader->imprimirRespuesta($cbteHeader->generarJson());
            exit;
        }

    }
    function reporteProgramacionWf(){

       $nombreArchivo = uniqid(md5(session_id()).'Programacion').'.pdf';
        $dataSource = $this->recuperarProgramacionWf();
        $dataEmpresa = $this->recuperarDatosEmpresa();
        //parametros basicos
        $tamano = 'LETTER';
        $orientacion = 'L';
        $titulo = 'Consolidado';
        $this->objParam->addParametro('orientacion',$orientacion);
        $this->objParam->addParametro('tamano',$tamano);
        $this->objParam->addParametro('titulo_archivo',$titulo);
        $this->objParam->addParametro('nombre_archivo',$nombreArchivo);

        $reporte = new RMemoriaProgramacionWf($this->objParam);
        $reporte->datosHeader($dataSource->getDatos(),  $dataSource->extraData,$dataEmpresa->getDatos());
        $reporte->generarReporte();
        $reporte->output($reporte->url_archivo,'F');
        $this->mensajeExito=new Mensaje();
        $this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado','Se generó con éxito el reporte: '.$nombreArchivo,'control');
        $this->mensajeExito->setArchivoGenerado($nombreArchivo);
        $this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());

    }

	function reporteMemoriaCalculoMensual(){

		if($this->objParam->getParametro('tipo_rep') == null){
			$this->objParam->addParametro('tipo_rep','');
		}

		$this->objFunc = $this->create('MODMemoriaCalculo');
		$cbteHeader = $this->objFunc->listarMemoriaCalculoMensual($this->objParam);
		if($cbteHeader->getTipo() == 'EXITO'){										
			$nombreArchivo = uniqid(md5(session_id()).'Memoria') . '.pdf';
			
			$dataSource = $cbteHeader;
			$dataEmpresa = $this->recuperarDatosEmpresa();
			//parametros basicos
			$tamano = 'A3';
			$orientacion = 'L';
			$titulo = 'Consolidado';
			$this->objParam->addParametro('orientacion',$orientacion);
			$this->objParam->addParametro('tamano',$tamano);
			$this->objParam->addParametro('titulo_archivo',$titulo);
			$this->objParam->addParametro('nombre_archivo',$nombreArchivo);
			$reporte = new RMemCalMensualPDF($this->objParam);
			$reporte->datosHeader($dataSource->getDatos(),  $dataSource->extraData,$dataEmpresa->getDatos());
			$reporte->generarReporte();
			$reporte->output($reporte->url_archivo,'F');
			$this->mensajeExito=new Mensaje();
			$this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado','Se generó con éxito el reporte: '.$nombreArchivo,'control');
			$this->mensajeExito->setArchivoGenerado($nombreArchivo);
			$this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());			
		}
		else{
			$cbteHeader->imprimirRespuesta($cbteHeader->generarJson());
			exit;
		}	

		
	}

	function recuperarMemoriaCalculoXLS(){    	
		$this->objFunc = $this->create('MODMemoriaCalculo');
		$cbteHeader = $this->objFunc->listarMemoriaCalculoMensual($this->objParam);
		if($cbteHeader->getTipo() == 'EXITO'){				
			return $cbteHeader;
		}
        else{
		    $cbteHeader->imprimirRespuesta($cbteHeader->generarJson());
			exit;
		}              
		
    }
	//#5
	function SubirArchivoPre(){
		$arregloFiles = $this->objParam->getArregloFiles();
		$ext = pathinfo($arregloFiles['archivo']['name']);
		$extension = $ext['extension'];
		$error = 'no';
		$mensaje_completo = '';
		//validar errores unicos del archivo: existencia, copia y extension
		if(isset($arregloFiles['archivo']) && is_uploaded_file($arregloFiles['archivo']['tmp_name'])){
			if ($extension != 'csv' && $extension != 'CSV') {
				$mensaje_completo = "La extensión del archivo debe ser CSV";
				$error = 'error_fatal';
			}			
			$upload_dir = "/tmp/";  			
			$file_path = $upload_dir . $arregloFiles['archivo']['name'];
			if (!move_uploaded_file($arregloFiles['archivo']['tmp_name'], $file_path)) {	
				$mensaje_completo = "Error al guardar el archivo csv en disco";
				$error = 'error_fatal';	  
			} 				
		} else {
			$mensaje_completo = "No se subio el archivo";
			$error = 'error_fatal';
		}
				
		if ($error == 'error_fatal') {			
			$this->mensajeRes=new Mensaje();
			$this->mensajeRes->setMensaje('ERROR','ACTMemoriaCalculo.php',$mensaje_completo,$mensaje_completo,'control');
			
		} else {
			$lines = file($file_path);			
			foreach ($lines as $line_num => $line) {
				$arr_temp = explode('|', $line);	
				
				if (count($arr_temp) != 16) {
					$error = 'error';
					$mensaje_completo .= "No se proceso la linea: $line_num, por un error en el formato \n";					
				} else {														
					$this->objParam->addParametro('cod_presupuesto', $arr_temp[0]);					
					$this->objParam->addParametro('desc_pre', $arr_temp[1]);
					$this->objParam->addParametro('cod_partida', $arr_temp[2]);	
					$this->objParam->addParametro('desc_partida', $arr_temp[3]);
					$this->objParam->addParametro('enero', $arr_temp[4]);
					$this->objParam->addParametro('febrero', $arr_temp[5]);
					$this->objParam->addParametro('marzo', $arr_temp[6]);
					$this->objParam->addParametro('abril', $arr_temp[7]);
					$this->objParam->addParametro('mayo', $arr_temp[8]);
					$this->objParam->addParametro('junio', $arr_temp[9]);
					$this->objParam->addParametro('julio', $arr_temp[10]);
					$this->objParam->addParametro('agosto', $arr_temp[11]);
					$this->objParam->addParametro('septiembre', $arr_temp[12]);
					$this->objParam->addParametro('octubre', $arr_temp[13]);
					$this->objParam->addParametro('noviembre', $arr_temp[14]);
					$this->objParam->addParametro('diciembre', $arr_temp[15]);
					//$this->objParam->addParametro('id_usuario', $arr_temp[16]);
					$this->objParam->addParametro('id_gestion', $this->objParam->getParametro('id_gestion'));
					$this->objParam->addParametro('id_funcionario', $this->objParam->getParametro('id_funcionario'));
					$this->objParam->addParametro('id_sesion', $this->objParam->getParametro('id_sesion'));
									
					$this->objFunc = $this->create('MODMemoriaCalculo');											
					$this->res = $this->objFunc->insertarMemoriaCalculoXLS($this->objParam);
					
					if ($this->res->getTipo() == 'ERROR') {
						$error = 'error';
						$mensaje_completo .= $this->res->getMensaje() . " \n";						
					}							
				}
			}
			$this->objFunc = $this->create('MODMemoriaCalculo');											
			$this->res = $this->objFunc->actualizarDatos($this->objParam);
			if ($this->res->getTipo() == 'ERROR') {
				$error = 'errors';
				$mensaje_completo .= $this->res->getMensaje() . " \n";						
			}	
		}

		//armar respuesta en caso de exito o error en algunas tuplas
		if ($error == 'error') {
			$this->mensajeRes=new Mensaje();
			$this->mensajeRes->setMensaje('ERROR','ACTMemoriaCalculo.php','Ocurrieron los siguientes errores : ' . $mensaje_completo,$mensaje_completo,'control');
		} else if ($error == 'no') {
			$this->mensajeRes=new Mensaje();
			$this->mensajeRes->setMensaje('EXITO','ACTMemoriaCalculo.php','El archivo fue ejecutado con éxito',	'El archivo fue ejecutado con éxito','control');
		}		
		
		//devolver respuesta
		$this->mensajeRes->imprimirRespuesta($this->mensajeRes->generarJson());

	}
}

?>