<?php
/**
*@package pXP
*@file gen-ACTPresupPartida.php
*@author  (admin)
*@date 29-02-2016 19:40:34
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

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
			
}

?>