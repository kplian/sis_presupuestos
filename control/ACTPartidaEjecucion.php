<?php
/**
*@package pXP
*@file gen-ACTPartidaEjecucion.php
*@author  (gvelasquez)
*@date 03-10-2016 15:47:23
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
 * HISTORIAL DE MODIFICACIONES:
 * ##11 ETR		  12/02/2019		   MMV Kplian	 R eporte Integridad presupuestaria
 * ##33 ETR		  13/01/2020		   JUAN          Corregir filtro por gestión en partida ejecución
 * #37 ENDETR	  31/03/2020		   JUAN          Reporte ejecución de proyectos con proveedor
 * #138 ENDETR     25/06/2020           JUAN          Mejora de filtros de gestión en partida ejecución con tipo_cc
   #42  ENDETR    17/07/2020            JJA          Interface que muestre la información de "tipo centro de costo" con todos los parámetros
   #44  ENDETR    23/07/2020        JJA          Mejoras en reporte tipo centro de costo de presupuesto 
*/
require_once(dirname(__FILE__).'/../reportes/RIntegridadPresupuestaria.php');
require_once(dirname(__FILE__).'/../reportes/REjecucionProyectoXls.php');
class ACTPartidaEjecucion extends ACTbase{    
			
	function listarPartidaEjecucion(){
		$this->objParam->defecto('ordenacion','fecha, fecha_reg');
		$this->objParam->defecto('dir_ordenacion','asc');

        if($this->objParam->getParametro('id_partida')!=''){
            $this->objParam->addFiltro("id_partida = ".$this->objParam->getParametro('id_partida'));
        }
		
		if($this->objParam->getParametro('momento')!=''){
            $this->objParam->addFiltro("tipo_movimiento = ''".$this->objParam->getParametro('momento')."''");
        }

        if($this->objParam->getParametro('id_centro_costo')!=''){
            //se agrego el alias vpe al tipo cc #138
            $this->objParam->addFiltro("vpe.id_presupuesto = ".$this->objParam->getParametro('id_centro_costo'));
        }

        if($this->objParam->getParametro('nro_tramite')!=''){
            $this->objParam->addFiltro("nro_tramite ilike ''%".$this->objParam->getParametro('nro_tramite')."%''");
        }

        if($this->objParam->getParametro('desde')!='' && $this->objParam->getParametro('hasta')!=''){
            $this->objParam->addFiltro("(fecha::date  BETWEEN ''%".$this->objParam->getParametro('desde')."%''::date  and ''%".$this->objParam->getParametro('hasta')."%''::date)");
        }

        if($this->objParam->getParametro('desde')!='' && $this->objParam->getParametro('hasta')==''){
            $this->objParam->addFiltro("(fecha::date  >= ''%".$this->objParam->getParametro('desde')."%''::date)");
        }

        if($this->objParam->getParametro('desde')=='' && $this->objParam->getParametro('hasta')!=''){
            $this->objParam->addFiltro("(fecha::date  <= ''%".$this->objParam->getParametro('hasta')."%''::date)");
        }

        if($this->objParam->getParametro('id_gestion')){//#33
            //Comparando el id_gestion no lista la gestion que corresponde
            $this->objParam->addFiltro("(select EXTRACT(year from fecha::date))::integer  =  (select EXTRACT(year from g.fecha_ini) from param.tgestion g where g.id_gestion= ".$this->objParam->getParametro('id_gestion')." )::integer"); //#33  verificar para quitar este filtro ya que existe el id_gestion en el tipo cc agregado en el issue #138
            $this->objParam->addFiltro(" cc.id_gestion= ".$this->objParam->getParametro('id_gestion')."::integer"); //#138

        }//#33

		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODPartidaEjecucion','listarPartidaEjecucion');
		} else{
			$this->objFunc=$this->create('MODPartidaEjecucion');
			
			$this->res=$this->objFunc->listarPartidaEjecucion($this->objParam);
		}
		
		                        
		    //adicionar una fila al resultado con el summario
			$temp = Array();
			$temp['egreso_mb'] = $this->res->extraData['total_egreso_mb'];
			$temp['ingreso_mb'] = $this->res->extraData['total_ingreso_mb'];
			$temp['monto_anticipo_mb'] = $this->res->extraData['total_monto_anticipo_mb'];
			$temp['monto_desc_anticipo_mb'] = $this->res->extraData['total_monto_desc_anticipo_mb'];
			$temp['monto_iva_revertido_mb'] = $this->res->extraData['total_monto_iva_revertido_mb'];
			$temp['tipo_reg'] = 'summary';
			$temp['id_partida_ejecucion'] = 0;
			
			$this->res->total++;
			
			$this->res->addLastRecDatos($temp);
		
		
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function listarTramitesAjustables(){
		$this->objParam->defecto('ordenacion','nro_tramite');
		$this->objParam->defecto('dir_ordenacion','asc');
		
        if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODPartidaEjecucion','listarTramitesAjustables');
		} else{
			$this->objFunc=$this->create('MODPartidaEjecucion');
			
			$this->res=$this->objFunc->listarTramitesAjustables($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	
	
	
				
	function insertarPartidaEjecucion(){
		$this->objFunc=$this->create('MODPartidaEjecucion');	
		if($this->objParam->insertar('id_partida_ejecucion')){
			$this->res=$this->objFunc->insertarPartidaEjecucion($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarPartidaEjecucion($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarPartidaEjecucion(){
			$this->objFunc=$this->create('MODPartidaEjecucion');	
		$this->res=$this->objFunc->eliminarPartidaEjecucion($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

	//#11
    function IntegridadPresupuestaria(){
        $this->objFunc = $this->create('MODPartidaEjecucion');
        $this->res = $this->objFunc->IntegridadPresupuestaria($this->objParam);
        $titulo = 'Integridad Presupuestaria';
        $nombreArchivo = uniqid(md5(session_id()) . $titulo);
        $nombreArchivo .= '.xls';
        $this->objParam->addParametro('nombre_archivo', $nombreArchivo);
        $this->objParam->addParametro('datos', $this->res->datos);
        //Instancia la clase de excel
        $this->objReporteFormato = new RIntegridadPresupuestaria($this->objParam);
        $this->objReporteFormato->generarDatos();
        $this->objReporteFormato->generarReporte();

        $this->mensajeExito = new Mensaje();
        $this->mensajeExito->setMensaje('EXITO', 'Reporte.php', 'Reporte generado','Se generó con éxito el reporte: ' . $nombreArchivo, 'control');
        $this->mensajeExito->setArchivoGenerado($nombreArchivo);
        $this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());
    }
    //#11
    function ReporteEjecucionProyecto(){ //#37

        if($this->objParam->getParametro('fecha_ini')){
            $this->objParam->addFiltro(" (pe.fecha::date  >= ''".$this->objParam->getParametro('fecha_ini')."''::date )");
        }
        if($this->objParam->getParametro('fecha_fin')){
            $this->objParam->addFiltro(" (pe.fecha::date  <= ''".$this->objParam->getParametro('fecha_fin')."''::date )");
        }

        $this->objFunc = $this->create('MODPartidaEjecucion');
        $this->res = $this->objFunc->ReporteEjecucionProyecto($this->objParam);
        $titulo = 'Ejecución Proyecto';
        $nombreArchivo = uniqid(md5(session_id()) . $titulo);
        $nombreArchivo .= '.xls';
        $this->objParam->addParametro('nombre_archivo', $nombreArchivo);
        $this->objParam->addParametro('fecha_ini', $this->objParam->getParametro('fecha_ini'));
        $this->objParam->addParametro('fecha_fin', $this->objParam->getParametro('fecha_fin'));
       // var_dump($this->res->datos);

        $this->objParam->addParametro('datos', $this->res->datos);
        //Instancia la clase de excel
        $this->objReporteFormato = new REjecucionProyectoXls($this->objParam);
        $this->objReporteFormato->generarDatos();
        $this->objReporteFormato->generarReporte();

        $this->mensajeExito = new Mensaje();
        $this->mensajeExito->setMensaje('EXITO', 'Reporte.php', 'Reporte generado','Se generó con éxito el reporte: ' . $nombreArchivo, 'control');
        $this->mensajeExito->setArchivoGenerado($nombreArchivo);
        $this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());
    }
    function listarTipoCentroCosto(){//#42
       /* $this->objParam->defecto('ordenacion','orden');
        $this->objParam->defecto('dir_ordenacion','asc');*/

        if($this->objParam->getParametro('desde')){
            $this->objParam->addFiltro("(tcc.fecha_inicio  >= ''%".$this->objParam->getParametro('desde')."%''::date  or cc.id_gestion is NULL )");
        }

        if($this->objParam->getParametro('hasta')){
            $this->objParam->addFiltro("(tcc.fecha_final  <= ''%".$this->objParam->getParametro('hasta')."%''::date  or cc.id_gestion is NULL )");
        }
        if($this->objParam->getParametro('id_gestion')){
            $this->objParam->addFiltro("(cc.id_gestion::integer  =  ".$this->objParam->getParametro('id_gestion')."::integer or cc.id_gestion is NULL)"); 
        }
        if($this->objParam->getParametro('operativo') !='todos'){
            $this->objParam->addFiltro("(tcc.operativo::varchar =  ''".$this->objParam->getParametro('operativo')."''::varchar or cc.id_gestion is NULL)"); 
        }
        if($this->objParam->getParametro('sueldo_planta') !='todos'){
            $this->objParam->addFiltro("(tcc.sueldo_planta::varchar =  ''".$this->objParam->getParametro('sueldo_planta')."''::varchar or cc.id_gestion is NULL)"); 
        }
        if($this->objParam->getParametro('sueldo_obradet') !='todos'){
            $this->objParam->addFiltro("(tcc.sueldo_obradet::varchar =  ''".$this->objParam->getParametro('sueldo_obradet')."''::varchar or cc.id_gestion is NULL)");
        }
        if($this->objParam->getParametro('mov_ingreso') !='todos'){
            $this->objParam->addFiltro("(tcc.mov_ingreso::varchar =  ''".$this->objParam->getParametro('mov_ingreso')."''::varchar or cc.id_gestion is NULL)");
        }
        if($this->objParam->getParametro('mov_egreso') !='todos'){
            $this->objParam->addFiltro("(tcc.mov_egreso::varchar =  ''".$this->objParam->getParametro('mov_egreso')."''::varchar or cc.id_gestion is NULL)");
        }
        if($this->objParam->getParametro('tipo_nodo') !='todos'){//#44
            if($this->objParam->getParametro('tipo_nodo') == 'transaccional'){
               $this->objParam->addFiltro("(tcc.movimiento =  ''si''::varchar or cc.id_gestion is NULL)");
            }else{
               $this->objParam->addFiltro("(tcc.movimiento !=  ''si''::varchar or cc.id_gestion is NULL)");
            }
        }
        
        if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
            $this->objReporte = new Reporte($this->objParam,$this);
            $this->res = $this->objReporte->generarReporteListado('MODPartidaEjecucion','listarTipoCentroCosto');
        } else{
            $this->objFunc=$this->create('MODPartidaEjecucion');
            
            $this->res=$this->objFunc->listarTipoCentroCosto($this->objParam);
        }

        //adicionar una fila al resultado con el summario
        $temp = Array();
        $temp['formulacion_egreso_mb'] = $this->res->extraData['total_mov_egreso_mb'];
        $temp['formulacion_ingreso_mb'] = $this->res->extraData['total_mov_ingreso_mb'];

        $temp['tipo_reg'] = 'summary';
        $temp['id_tipo_cc'] = 0;
        
        $this->res->total++;
        
        $this->res->addLastRecDatos($temp);

        $this->res->imprimirRespuesta($this->res->generarJson());
    }
}

?>