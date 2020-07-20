<?php
/**
*@package pXP
*@file gen-ACTAjuste.php
*@author  (admin)
*@date 13-04-2016 13:21:12
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
* ISSUE		FORK		 FECHA				AUTHOR 				DESCRIPCION
  #39         ENDETR      09/07/2020           JJA                Agregar un catalogo de (tipo_presupuesto_formulacion)
*/

class ACTAjuste extends ACTbase{    
			
	function listarAjuste(){
		$this->objParam->defecto('ordenacion','id_ajuste');
		$this->objParam->defecto('dir_ordenacion','asc');
		$this->objParam->addParametro('id_funcionario_usu',$_SESSION["ss_id_funcionario"]); 
		
		if(strtolower($this->objParam->getParametro('estado'))=='borrador'){
             $this->objParam->addFiltro("(aju.estado in (''borrador''))");
        }
		if(strtolower($this->objParam->getParametro('estado'))=='en_proceso'){
             $this->objParam->addFiltro("(aju.estado not in (''borrador'',''aprobado''))");
        }
		if(strtolower($this->objParam->getParametro('estado'))=='finalizados'){
             $this->objParam->addFiltro("(aju.estado in (''aprobado''))");
        }
		
		if($this->objParam->getParametro('tipoReporte') == 'excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODAjuste','listarAjuste');
		} else{
			$this->objFunc=$this->create('MODAjuste');			
			$this->res=$this->objFunc->listarAjuste($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarAjuste(){
		$this->objFunc=$this->create('MODAjuste');	
		if($this->objParam->insertar('id_ajuste')){
			$this->res=$this->objFunc->insertarAjuste($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarAjuste($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarAjuste(){
			$this->objFunc=$this->create('MODAjuste');	
		$this->res=$this->objFunc->eliminarAjuste($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function siguienteEstadoAjuste(){
        $this->objFunc=$this->create('MODAjuste');  
        $this->res=$this->objFunc->siguienteEstadoAjuste($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

   function anteriorEstadoAjuste(){
        $this->objFunc=$this->create('MODAjuste');  
        $this->res=$this->objFunc->anteriorEstadoAjuste($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
   function Editar_tipo_ajuste_formulacion(){//#39
        $this->objFunc=$this->create('MODAjuste');  
        $this->res=$this->objFunc->Editar_tipo_ajuste_formulacion($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
			
}

?>