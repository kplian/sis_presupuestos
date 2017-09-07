<?php
/**
*@package pXP
*@file gen-ACTObjetivo.php
*@author  (gvelasquez)
*@date 20-07-2016 20:37:41
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/
//require_once(dirname(__FILE__).'/../reportes/RpoaXls.php');
class ACTObjetivo extends ACTbase{    
			
	function listarObjetivo(){
		$this->objParam->defecto('ordenacion','id_objetivo');

		/////////////////
		//	FILTROS
		////////////////
		if($this->objParam->getParametro('id_gestion')!='') {
	    	$this->objParam->addFiltro("obj.id_gestion = ".$this->objParam->getParametro('id_gestion'));	
		}

        if($this->objParam->getParametro('sw_transaccional')!='') {
            $this->objParam->addFiltro("obj.sw_transaccional = ''".$this->objParam->getParametro('sw_transaccional')."''");
        }
		
		/////////////////////
		//Llamada al Modelo	
		/////////////////////	
		
		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODObjetivo','listarObjetivo');
		} else{
			$this->objFunc=$this->create('MODObjetivo');
			
			$this->res=$this->objFunc->listarObjetivo($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function listarObjetivoArb(){
        //$this->objFunc=$this->create('MODPartida');    
        
        //obtiene el parametro nodo enviado por la vista
        $node=$this->objParam->getParametro('node');

        $id_objetivo=$this->objParam->getParametro('id_objetivo');
        $tipo_nodo=$this->objParam->getParametro('tipo_nodo');
        
                   
        if($node=='id'){
            $this->objParam->addParametro('id_padre','%');
        }
        else {
            $this->objParam->addParametro('id_padre',$id_objetivo);
        }
		
        
		$this->objFunc=$this->create('MODObjetivo');
        $this->res=$this->objFunc->listarObjetivoArb();
        
        $this->res->setTipoRespuestaArbol();
        
        $arreglo=array();
        
        array_push($arreglo,array('nombre'=>'id','valor'=>'id_objetivo'));
        array_push($arreglo,array('nombre'=>'id_p','valor'=>'id_objetivo_fk'));
        
        
        array_push($arreglo,array('nombre'=>'text','valores'=>'#codigo# - #descripcion#'));
        array_push($arreglo,array('nombre'=>'cls','valor'=>'codigo'));
        array_push($arreglo,array('nombre'=>'qtip','valores'=>'<b> #codigo#</b><b> #descripcion#</b><br> #indicador_logro#'));
        
        
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
				
	function insertarObjetivo(){
		$this->objFunc=$this->create('MODObjetivo');	
		if($this->objParam->insertar('id_objetivo')){
			$this->res=$this->objFunc->insertarObjetivo($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarObjetivo($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarObjetivo(){
			$this->objFunc=$this->create('MODObjetivo');	
		$this->res=$this->objFunc->eliminarObjetivo($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

    function ReportePoa(){
        $this->objFunc = $this->create('MODObjetivo');
        $this->res = $this->objFunc->ReportePOA($this->objParam);
        //var_dump( $this->res);exit;
        //obtener titulo de reporte
        $titulo = 'Reporte POA';
        //Genera el nombre del archivo (aleatorio + titulo)
        $nombreArchivo = uniqid(md5(session_id()) . $titulo);

        $nombreArchivo .= '.xls';
        $this->objParam->addParametro('nombre_archivo', $nombreArchivo);
        $this->objParam->addParametro('datos', $this->res->datos);
        //Instancia la clase de excel
        $this->objReporteFormato = new RpoaXls($this->objParam);
        $this->objReporteFormato->generarDatos();
        $this->objReporteFormato->generarReporte();

        $this->mensajeExito = new Mensaje();
        $this->mensajeExito->setMensaje('EXITO', 'Reporte.php', 'Reporte generado','Se generó con éxito el reporte: ' . $nombreArchivo, 'control');
        $this->mensajeExito->setArchivoGenerado($nombreArchivo);
        $this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());
    }
			
}

?>