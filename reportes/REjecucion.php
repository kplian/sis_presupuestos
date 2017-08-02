<?php
// Extend the TCPDF class to create custom MultiRow
class REjecucion extends  ReportePDF {
	var $datos_titulo;
	var $datos_detalle;
	var $ancho_hoja;
	var $gerencia;
	var $numeracion;
	var $ancho_sin_totales;
	var $cantidad_columnas_estaticas;
	var $s1;
	var $t1;
	var $tg1;
	var $total;
	var $datos_entidad;
	var $datos_periodo;
	var $ult_codigo_partida;
	var $ult_concepto;
	
	
	
	function datosHeader ( $detalle, $totales, $gestion,$dataEmpresa) {
		$this->ancho_hoja = $this->getPageWidth()-PDF_MARGIN_LEFT-PDF_MARGIN_RIGHT-10;
		$this->datos_detalle = $detalle;
		$this->datos_titulo = $totales;
		$this->datos_entidad = $dataEmpresa;
		$this->datos_gestion = $gestion;
		$this->subtotal = 0;
		$this->SetMargins(7, 60, 5);
	}
	
	function Header() {
		
		$white = array('LTRB' =>array('width' => 0.3, 'cap' => 'butt', 'join' => 'miter', 'dash' => 0, 'color' => array(255, 255, 255)));
        $black = array('T' =>array('width' => 0.3, 'cap' => 'butt', 'join' => 'miter', 'dash' => 0, 'color' => array(0, 0, 0)));
        
		
		$this->Ln(3);
		//formato de fecha
		
		//cabecera del reporte
		$this->Image(dirname(__FILE__).'/../../lib/imagenes/logos/logo.jpg', 10,5,35,20);
		$this->ln(5);
		
		
	    $this->SetFont('','BU',12);		
		$this->Cell(0,5,"EJECUCIÓN PRESUPUESTARIA",0,1,'C');
		$this->Cell(0,5,mb_strtoupper($this->datos_entidad['nombre'],'UTF-8'),0,1,'C');
		$this->Cell(0,5,"GESTIÓN ".$this->datos_gestion['anho'],0,1,'C');		
		//$this->Ln();
		$this->SetFont('','B',7);
		$this->Cell(0,5,"(Expresado en Bolivianos)",0,1,'C');		
		$this->Ln(2);
		
		$this->SetFont('','',10);
		
		$height = 5;
        $width1 = 5;
		$esp_width = 10;
        $width_c1= 55;
		$width_c2= 120;
        $width3 = 40;
        $width4 = 75;
		
	    
		
		$this->Ln();
		
		if($this->objParam->getParametro('tipo_reporte') =='categoria'){
			$tmp = 'CATEGORÍA';
		}
		if($this->objParam->getParametro('tipo_reporte') =='programa'){
			$tmp = 'PROGRAMA';
		}
		if($this->objParam->getParametro('tipo_reporte') =='presupuesto'){
			$tmp = 'PRESUPUESTO';
		}
		
		
		
		$this->Cell($width1, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $this->Cell($width_c1, $height, $tmp.": ", 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $this->SetFont('', '');
        $this->SetFillColor(192,192,192, true);
        $this->Cell($width_c2, $height, $this->objParam->getParametro('concepto'), $black, 0, 'L', true, '', 0, false, 'T', 'C');
        
        
		$this->Ln();
		$this->Ln();
		
		$this->SetFont('','B',6);
		$this->generarCabecera();
		
		
	}
   
   function generarReporte() {
		$this->setFontSubsetting(false);
		$this->AddPage();
		$this->generarCuerpo($this->datos_detalle);		
		$this->cerrarCuadro();	
		
		
	} 
    function generarCabecera(){
    	
		//armca caecera de la tabla
		$this->tablewidths=array(15,53,18,18,18,18,18,18,18,18,18,18,15);
        $this->tablealigns=array('C','C','C','C','C','C','C','C','C','C','C','C','C');
        $this->tablenumbers=array(0,0,0,0,0,0,0,0,0,0,0,0,0);
        $this->tableborders=array('TB','TB','TB','TB','TB','TB','TB','TB','TB','TB','TB','TB','TB');
        $this->tabletextcolor=array();
		
	    $RowArray = array(
            			's0'  => 'COD',
            			's1' => 'PARTIDA',   
                        's2' => 'SEGÚN MEMORIA',        
                        's3' => 'APROBADO',
                        's4' => 'AJUSTADO',            
                        's5' => 'VIGENTE',
                        's6' => 'COMPROMETIDO',
                        's7' => 'EJECUTADO',  
                        's8' => 'PAGADO', 
                        's9' => 'SALDO POR COMPROMETER',
                        's10' => 'SALDO POR DEVENGAR', 
                        's11' => 'SALDO POR PAGAR',   
                        's12' => '% EJE');
                         
        $this-> MultiRow2($RowArray,false,1);
		
		
    }
	
	function generarCuerpo($detalle){
		
		$count = 1;
		$sw = 0;
		$sw1 = 0;
		$this->ult_codigo_partida = '';
		$this->ult_concepto = '';
		$fill = 0;
		
		$this->total = count($detalle);
		
		$this->s1 = 0;
		$this->t1 = 0;
		$this->tg1 = 0;
		
		
		foreach ($detalle as $val) {
				
			$this->imprimirLinea($val,$count,$fill);
			$fill = !$fill;
			$count = $count + 1;
			$this->total = $this->total -1;
			$this->revisarfinPagina();
			
		}
		
		
		
	}	
	
	function imprimirLinea($val,$count,$fill){
		
		$this->SetFillColor(224, 235, 255);
        $this->SetTextColor(0);
        $tab = '';
		$this->tabletextcolor=$conf_tabletextcolor;
		$sal_comprometido = $val['formulado'] - $val['comprometido'];
		$sal_ejecutado = $val['comprometido'] - $val['ejecutado'];
		$sal_pagado = $val['ejecutado'] - $val['pagado'];
		
		
		if ($val['nivel_partida'] == 0){
			 $this->SetFont('','BU',6);
			 $this->tableborders=array('LRTB','LRTB','LRTB','LRTB','LRTB','LRTB','LRTB','LRTB','LRTB','LRTB','LRTB','LRTB','LRTB');
			 $conf_par_tablewidths=array(15,53,18,18,18,18,18,18,18,18,18,18,15);
		     $this->tablealigns=array('L','L','R','R','R','R','R','R','R','R','R','R','R');
		     $this->tablenumbers=array(0,0,2,2,2,2,2,2,2,2,2,2,0);
			 $RowArray = array(
            			's1' =>  $tab.$val['codigo_partida'],
            			's2' => $tab.$val['nombre_partida'],
                        's3' => $val['importe'],
                        's4' => $val['importe_aprobado'],
						's5' => $val['ajustado'],
                        's6' => $val['formulado'],
                        's7' => $val['comprometido'],
                        's8' => $val['ejecutado'],
						's9' => $val['pagado'],
						's10' => $sal_comprometido,
                        's11' => $sal_ejecutado,
						's12' => $sal_pagado,
                        's13' => $val['porc_ejecucion'].' %');
			
        }
		
		if ($val['nivel_partida'] == 1){
			 //$this->ln();
			 $this->SetFont('','BU',6);
			 $this->tableborders=array('LR','LR','LR','LR','LR','LR','LR','LR','LR','LR','LR','LR','LR');
			 $this->tablewidths=array(15,53,18,18,18,18,18,18,18,18,18,18,15);
		     $this->tablealigns=array('L','L','R','R','R','R','R','R','R','R','R','R','R');
		     $this->tablenumbers=array(0,0,2,2,2,2,2,2,2,2,2,2,0);
			 
			 $tab = '';
			 $RowArray = array(
            			's1' =>  $tab.$val['codigo_partida'],
            			's2' => $tab.$val['nombre_partida'],
                        's3' => $val['importe'],
                        's4' => $val['importe_aprobado'],
						's5' => $val['ajustado'],
                        's6' => $val['formulado'],
                        's7' => $val['comprometido'],
                        's8' => $val['ejecutado'],
						's9' => $val['pagado'],
						's10' => $sal_comprometido,
                        's11' => $sal_ejecutado,
						's12' => $sal_pagado,
                        's13' => $val['porc_ejecucion'].' %');
			 
		}
		
		
		
		if ($val['nivel_partida'] == 2){
			 $this->SetFont('','',6);
			 $this->tableborders=array('LR','L','R','LR','LR','LR','LR','LR','LR','LR','LR','LR','LR','LR');
			 $this->tablewidths=array(15,3,50,18,18,18,18,18,18,18,18,18,18,15);
		     $this->tablealigns=array('L','L','L','R','R','R','R','R','R','R','R','R','R','R');
		     $this->tablenumbers=array(0,0,0,2,2,2,2,2,2,2,2,2,2,0);
			 $tab = "\t\t";
			 $RowArray = array(
            			's1' =>  $tab.$val['codigo_partida'],
            			's2.0' => '',
                        's2' => $val['nombre_partida'],
                        's3' => $val['importe'],
                        's4' => $val['importe_aprobado'],
						's5' => $val['ajustado'],
                        's6' => $val['formulado'],
                        's7' => $val['comprometido'],
                        's8' => $val['ejecutado'],
						's9' => $val['pagado'],
						's10' => $sal_comprometido,
                        's11' => $sal_ejecutado,
						's12' => $sal_pagado,
                        's13' => $val['porc_ejecucion'].' %');
			
		}
       if ($val['nivel_partida'] == 3){
			  $this->SetFont('','',6);
		      $this->tableborders=array('LR','L','R','LR','LR','LR','LR','LR','LR','LR','LR','LR','LR','LR');
			  $this->tablewidths=array(15,5,48,18,18,18,18,18,18,18,18,18,18,15);
		      $this->tablealigns=array('L','L','L','R','R','R','R','R','R','R','R','R','R','R');
		      $this->tablenumbers=array(0,0,0,2,2,2,2,2,2,2,2,2,2,0);
			 
		     $tab = "\t\t\t";
			 $RowArray = array(
            			's1' =>  $tab.$val['codigo_partida'],
            			's2.0' => '',
                        's2' => $val['nombre_partida'],
                        's3' => $val['importe'],
                        's4' => $val['importe_aprobado'],
						's5' => $val['ajustado'],
                        's6' => $val['formulado'],
                        's7' => $val['comprometido'],
                        's8' => $val['ejecutado'],
						's9' => $val['pagado'],
						's10' => $sal_comprometido,
                        's11' => $sal_ejecutado,
						's12' => $sal_pagado,
                        's13' => $val['porc_ejecucion'].' %');
			 
		}
      if ($val['nivel_partida'] > 3){
			  $this->SetFont('','',6);
		      $this->tableborders=array('LR','L','R','LR','LR','LR','LR','LR','LR','LR','LR','LR','LR','LR');
			  $this->tablewidths=array(15,7,46,18,18,18,18,18,18,18,18,18,18,15);
		      $this->tablealigns=array('L','L','L','R','R','R','R','R','R','R','R','R','R','R');
		      $this->tablenumbers=array(0,0,0,2,2,2,2,2,2,2,2,2,2,0);
			 
		     $tab = "\t\t\t\t";
			 $RowArray = array(
            			's1' =>  $tab.$val['codigo_partida'],
            			's2.0' => '',
                        's2' => $val['nombre_partida'],
                        's3' => $val['importe'],
                        's4' => $val['importe_aprobado'],
						's5' => $val['ajustado'],
                        's6' => $val['formulado'],
                        's7' => $val['comprometido'],
                        's8' => $val['ejecutado'],
						's9' => $val['pagado'],
						's10' => $sal_comprometido,
                        's11' => $sal_ejecutado,
						's12' => $sal_pagado,
                        's13' => $val['porc_ejecucion'].' %');
			 
		}
	   
	   
       
		
		
        
       
						
		$this-> MultiRow2($RowArray,$fill,1);
		
	}


    function revisarfinPagina(){
		$dimensions = $this->getPageDimensions();
		$hasBorder = false; //flag for fringe case
		
		$startY = $this->GetY();
		$this->getNumLines($row['cell1data'], 80);
		
		if (($startY + 4 * 3) + $dimensions['bm'] > ($dimensions['hk'])) {
		    if($this->total!= 0){
				$this->AddPage();
			}
		} 
	}
	
	
   
 
  
  function cerrarCuadro(){
  	
	   
	   	    //si noes inicio termina el cuardro anterior
	   	   
			$this->tablewidths=array(15+53+18+18+18+18+18+18+18+18+18+18+15);
            $this->tablealigns=array('L');
            $this->tablenumbers=array(0,);
            $this->tableborders=array('T');		
	        $RowArray = array('espacio' => '');     
	        $this-> MultiRow2($RowArray,false,1);			
			
	
  }
  
  

  
  
 
}
?>