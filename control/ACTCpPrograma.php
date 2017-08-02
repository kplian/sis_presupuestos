<?php
/**
*@package pXP
*@file gen-ACTCpPrograma.php
*@author  (admin)
*@date 19-04-2016 14:04:56
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTCpPrograma extends ACTbase{    
			
	function listarCpPrograma(){
		$this->objParam->defecto('ordenacion','id_cp_programa');

		$this->objParam->defecto('dir_ordenacion','asc');
		
		if($this->objParam->getParametro('id_gestion')!=''){
	    	$this->objParam->addFiltro("id_gestion = ".$this->objParam->getParametro('id_gestion'));	
		}
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODCpPrograma','listarCpPrograma');
		} else{
			$this->objFunc=$this->create('MODCpPrograma');
			
			$this->res=$this->objFunc->listarCpPrograma($this->objParam);
		}
		
		if($this->objParam->getParametro('_adicionar')!=''){
		    
			$respuesta = $this->res->getDatos();
			
										
		    array_unshift ( $respuesta, array(  'id_cp_programa'=>'0',
		                                'descripcion'=>'Todos',
									    'codigo'=>'Todos'));
		    //var_dump($respuesta);
			$this->res->setDatos($respuesta);
		}
		
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarCpPrograma(){
		$this->objFunc=$this->create('MODCpPrograma');	
		if($this->objParam->insertar('id_cp_programa')){
			$this->res=$this->objFunc->insertarCpPrograma($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarCpPrograma($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarCpPrograma(){
			$this->objFunc=$this->create('MODCpPrograma');	
		$this->res=$this->objFunc->eliminarCpPrograma($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>