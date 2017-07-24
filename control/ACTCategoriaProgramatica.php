<?php
/**
*@package pXP
*@file gen-ACTCategoriaProgramatica.php
*@author  (admin)
*@date 19-04-2016 15:30:34
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTCategoriaProgramatica extends ACTbase{    
			
	function listarCategoriaProgramatica(){
		$this->objParam->defecto('ordenacion','id_categoria_programatica');

		$this->objParam->defecto('dir_ordenacion','asc');
		
		if($this->objParam->getParametro('id_gestion')!=''){
	    	$this->objParam->addFiltro("id_gestion = ".$this->objParam->getParametro('id_gestion'));	
		}
		
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODCategoriaProgramatica','listarCategoriaProgramatica');
		} else{
			$this->objFunc=$this->create('MODCategoriaProgramatica');
			
			$this->res=$this->objFunc->listarCategoriaProgramatica($this->objParam);
		}
		
		if($this->objParam->getParametro('_adicionar')!=''){
		    
			$respuesta = $this->res->getDatos();
			
										
		    array_unshift ( $respuesta, array(  'id_categoria_programatica'=>'0',
		                                'descripcion'=>'Todos',
									    'codigo_categoria'=>'Todos'));
		    //var_dump($respuesta);
			$this->res->setDatos($respuesta);
		}
		
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarCategoriaProgramatica(){
		$this->objFunc=$this->create('MODCategoriaProgramatica');	
		if($this->objParam->insertar('id_categoria_programatica')){
			$this->res=$this->objFunc->insertarCategoriaProgramatica($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarCategoriaProgramatica($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarCategoriaProgramatica(){
		$this->objFunc=$this->create('MODCategoriaProgramatica');	
		$this->res=$this->objFunc->eliminarCategoriaProgramatica($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function clonarCategoriaProgramatica(){
		$this->objFunc=$this->create('MODCategoriaProgramatica');	
		$this->res=$this->objFunc->clonarCategoriaProgramatica($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>