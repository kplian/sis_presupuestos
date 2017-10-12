<?php
/**
*@package pXP
*@file gen-ACTPartida.php
*@author  (admin)
*@date 23-11-2012 20:06:53
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/
require_once(dirname(__FILE__).'/../reportes/RPartidaEjecutadoXls.php');
class ACTPartida extends ACTbase{    
			
	function listarPartida(){
		$this->objParam->defecto('ordenacion','id_partida');
		
		/////////////////
		//	FILTROS
		////////////////
		if($this->objParam->getParametro('id_gestion')!=''){
	    	$this->objParam->addFiltro("par.id_gestion = ".$this->objParam->getParametro('id_gestion'));	
		}
		if($this->objParam->getParametro('id_concepto_ingas')!=''){
	    	$this->objParam->addFiltro("par.id_partida in (select id_partida from pre.tconcepto_partida cp where cp.id_concepto_ingas = " . $this->objParam->getParametro('id_concepto_ingas') . ")");	
		}
		if($this->objParam->getParametro('tipo')!=''){
			
			if($this->objParam->getParametro('tipo') == 'ingreso_egreso'){
				$this->objParam->addFiltro("par.tipo in (''recurso'',''gasto'')");	
			}
			else{
				$this->objParam->addFiltro("par.tipo = ''".$this->objParam->getParametro('tipo')."''");	
			}
	    	
		}
		if($this->objParam->getParametro('sw_transaccional')!=''){
	    	$this->objParam->addFiltro("par.sw_transaccional = ''".$this->objParam->getParametro('sw_transaccional')."''");	
		}
		if($this->objParam->getParametro('partida_tipo')!=''){
			$tmp=$this->objParam->getParametro('partida_tipo');
			if($tmp=='flujo'||$tmp=='presupuestaria'){
				$this->objParam->addFiltro("par.sw_movimiento = ''$tmp'' ");
			} 
		}
		if($this->objParam->getParametro('partida_rubro')!=''){
			$tmp=$this->objParam->getParametro('partida_rubro');
			if($tmp == 'recurso' || $tmp == 'gasto'){
				$this->objParam->addFiltro("par.tipo = ''$tmp'' ");
			} 
		}
		
		if($this->objParam->getParametro('id_centro_costo')!=''){
	    	$this->objParam->addFiltro("par.id_partida in (select id_partida from pre.tpresup_partida where id_presupuesto = " . $this->objParam->getParametro('id_centro_costo') . ")");	
		}
		
		if($this->objParam->getParametro('id_presupuesto')!=''){
	    	$this->objParam->addFiltro("par.id_partida in (select id_partida from pre.tpresup_partida where id_presupuesto = " . $this->objParam->getParametro('id_presupuesto') . ")");	
		}
		
		if($this->objParam->getParametro('tipo_ajuste')!='' && 
		   $this->objParam->getParametro('nro_tramite')!='' && 
		   $this->objParam->getParametro('id_gestion')!='' &&
		   $this->objParam->getParametro('id_presupuesto_ajuste')!=''
		   ){
	    	  	
	    	  $this->objParam->addFiltro("id_partida in (select x.id_partida from pre.vpe_check_partida x where x.id_presupuesto = ".$this->objParam->getParametro('id_presupuesto_ajuste')." and x.id_gestion =  ".$this->objParam->getParametro('id_gestion')." and  x.nro_tramite = ''".$this->objParam->getParametro('nro_tramite')."'')");	
	     }
		
		
		
		/////////////////////
		//Llamada al Modelo	
		/////////////////////	

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam, $this);
			$this->res = $this->objReporte->generarReporteListado('MODPartida','listarPartida');
		} else{
			$this->objFunc=$this->create('MODPartida');	
			$this->res=$this->objFunc->listarPartida();
		}
		
		
		if($this->objParam->getParametro('_adicionar')!=''){
		    
			$respuesta = $this->res->getDatos();
			
										
		    array_unshift ( $respuesta, array(  'id_partida'=>'0',
		                                'nombre_partida'=>'Todos',
									    'codigo'=>'Todos',
										'sw_movimiento'=>'Todos',
										'sw_transaccional'=>'Todos',
										'desc_gestion'=>'Todos',
										'tipo'=>'Todos'));
		    //var_dump($respuesta);
			$this->res->setDatos($respuesta);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
    
    function listarPartidaArb(){
        //$this->objFunc=$this->create('MODPartida');    
        
        //obtiene el parametro nodo enviado por la vista
        $node=$this->objParam->getParametro('node');

        $id_partida=$this->objParam->getParametro('id_partida');
        $tipo_nodo=$this->objParam->getParametro('tipo_nodo');
        
                   
        if($node=='id'){
            $this->objParam->addParametro('id_padre','%');
        }
        else {
            $this->objParam->addParametro('id_padre',$id_partida);
        }
        
		$this->objFunc=$this->create('MODPartida');
        $this->res=$this->objFunc->listarPartidaArb();
        
        $this->res->setTipoRespuestaArbol();
        
        $arreglo=array();
        
        array_push($arreglo,array('nombre'=>'id','valor'=>'id_partida'));
        array_push($arreglo,array('nombre'=>'id_p','valor'=>'id_partida_fk'));
        
        
        array_push($arreglo,array('nombre'=>'text','valores'=>'#codigo# - #nombre_partida#'));
        array_push($arreglo,array('nombre'=>'cls','valor'=>'codigo'));
        array_push($arreglo,array('nombre'=>'qtip','valores'=>'<b> #codigo#</b><b> #nombre_partida#</b><br> #descripcion#'));
        
        
        $this->res->addNivelArbol('tipo_nodo','raiz',array('leaf'=>false,
                                                        'allowDelete'=>true,
                                                        'allowEdit'=>true,
                                                        'cls'=>'folder',
                                                        'tipo_nodo'=>'raiz',
                                                        'icon'=>'../../../lib/imagenes/a_form.png'),
                                                        $arreglo);
         
        /*se ande un nivel al arbol incluyendo con tido de nivel carpeta con su arreglo de equivalencias
          es importante que entre los resultados devueltos por la base exista la variable\
          tipo_dato que tenga el valor en texto = 'hoja' */
                                                                

         $this->res->addNivelArbol('tipo_nodo','hijo',array(
                                                        'leaf'=>false,
                                                        'allowDelete'=>true,
                                                        'allowEdit'=>true,
                                                        'tipo_nodo'=>'hijo',
                                                        'icon'=>'../../../lib/imagenes/a_form.png'),
                                                        $arreglo);
														
		$this->res->addNivelArbol('tipo_nodo','hoja',array(
                                                        'leaf'=>true,
                                                        'allowDelete'=>true,
                                                        'allowEdit'=>true,
                                                        'tipo_nodo'=>'hoja',
                                                        'icon'=>'../../../lib/imagenes/a_form.png'),
                                                        $arreglo);												
														

        $this->res->imprimirRespuesta($this->res->generarJson());         

    }
				
	function insertarPartida(){
		$this->objFunc=$this->create('MODPartida');	
		if($this->objParam->insertar('id_partida')){
			$this->res=$this->objFunc->insertarPartida();			
		} else{			
			$this->res=$this->objFunc->modificarPartida();
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarPartida(){
		$this->objFunc=$this->create('MODPartida');	
		$this->res=$this->objFunc->eliminarPartida();
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function clonarPartidasGestion(){
		$this->objFunc=$this->create('MODPartida');	
		$this->res=$this->objFunc->clonarPartidasGestion($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function reporteClasificador(){
			
		$nombreArchivo = uniqid(md5(session_id()).'Clasificador') . '.pdf'; 
		$dataSource = $this->recuperarDatosPlanCuentas();	
		
		
		//parametros basicos
		$tamano = 'LETTER';
		$orientacion = 'P';
		$titulo = 'Clasificador de Partidas Gestión XXXX';
		
		$this->objParam->addParametro('orientacion',$orientacion);
		$this->objParam->addParametro('tamano',$tamano);		
		$this->objParam->addParametro('titulo_archivo',$titulo);	
        
		$this->objParam->addParametro('nombre_archivo',$nombreArchivo);
		//Instancia la clase de pdf
		
		$reporte = new RPlanCuentas($this->objParam);
		$reporte->datosHeader($dataSource);
		//$this->objReporteFormato->renderDatos($this->res2->datos);
		
		$reporte->generarReporte();
		$reporte->output($reporte->url_archivo,'F');
		
		$this->mensajeExito=new Mensaje();
		$this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado','Se generó con éxito el reporte: '.$nombreArchivo,'control');
		$this->mensajeExito->setArchivoGenerado($nombreArchivo);
		$this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());
		
	}
	function listarPartidaEjecutados(){
		$this->objFunc = $this->create('MODPartida');
		$cbteHeader = $this->objFunc->listarPartidaEjecutado($this->objParam);
		if($cbteHeader->getTipo() == 'EXITO'){
			return $cbteHeader;
		}
		else{
			$cbteHeader->imprimirRespuesta($cbteHeader->generarJson());
			exit;
		}

	}
	function listarPartidaEjecutadoTotal(){
		$this->objFunc = $this->create('MODPartida');
		$cbteHeader = $this->objFunc->listarPartidaEjecutadoTotal($this->objParam);
		if($cbteHeader->getTipo() == 'EXITO'){
			return $cbteHeader;
		}
		else{
			$cbteHeader->imprimirRespuesta($cbteHeader->generarJson());
			exit;
		}

	}
    function listarPartidaInstitucional(){
        $this->objFunc = $this->create('MODPartida');
        $cbteHeader = $this->objFunc->listarPartidaInstitucional($this->objParam);
        if($cbteHeader->getTipo() == 'EXITO'){
            return $cbteHeader;
        }
        else{
            $cbteHeader->imprimirRespuesta($cbteHeader->generarJson());
            exit;
        }

    }
    function listarPartidaEjecutado (){
		$dataSource = $this->listarPartidaEjecutados();

        $dataSourceTotal = $this->listarPartidaEjecutadoTotal();
        $dateSourseInstitucional = $this->listarPartidaInstitucional();

		$nombreArchivo = uniqid(md5(session_id()).'Partidas').'.xls';
		$this->objParam->addParametro('nombre_archivo',$nombreArchivo);
		$reporte = new RPartidaEjecutadoXls($this->objParam);
		$reporte->datosHeader($dataSource->getDatos(),$dataSource->extraData,$dataSourceTotal->getDatos(),$dateSourseInstitucional->getDatos());
		$reporte->generarReporte();
		$this->mensajeExito=new Mensaje();
		$this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado','Se generó con éxito el reporte: '.$nombreArchivo,'control');
		$this->mensajeExito->setArchivoGenerado($nombreArchivo);
		$this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());




    }

			
}

?>