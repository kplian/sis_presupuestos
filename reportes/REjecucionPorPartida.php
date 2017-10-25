<?php
// Extend the TCPDF class to create custom MultiRow
class REjecucionPorPartida extends  ReportePDF {
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

	var $totales_segun_memoria = 0;
	var $totales_aprobado = 0;
	var $totales_ajustado = 0;
	var $totales_vigente = 0;
    var $totales_comprometido = 0;
    var $totales_ejecutado = 0;
    var $totales_pagado = 0;
    var $totales_saldoXcomprometer = 0;
    var $totales_saldoXdevengar = 0;
    var $totales_saldoXpagar = 0;
    var $totales_porcentaje_ejecucion = 0;
	
	
	
	function datosHeader ( $detalle, $totales, $gestion,$dataEmpresa) {
        //var_dump($detalle,$this->totales);exit;
		$this->ancho_hoja = $this->getPageWidth()-PDF_MARGIN_LEFT-PDF_MARGIN_RIGHT-10;
		$this->datos_detalle = $detalle;
		$this->datos_titulo = $totales;
		$this->datos_entidad = $dataEmpresa;
		$this->datos_gestion = $gestion;
		$this->subtotal = 0;
		$this->SetMargins(7, 65, 5);
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
		$this->Cell(0,5,"EJECUCIÓN PRESUPUESTARIA POR PARTIDA",0,1,'C');
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
        $width_c1= 30;
		$width_c2= 120;
        $width3 = 40;
        $width4 = 75;
		
	    
		
		$this->Ln();
		$this->Cell($width1, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $this->Cell($width_c1, $height, "PARTIDA: ", 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $this->SetFont('', '');
        $this->SetFillColor(192,192,192, true);
        $this->Cell($width_c2, $height, $this->objParam->getParametro('concepto'), $black, 0, 'L', true, '', 0, false, 'T', 'C');
        $this->Ln();
		$this->Cell($width1, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $this->Cell($width_c1, $height, "CATEGORIA: ", 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $this->SetFont('', '');
        $this->SetFillColor(192,192,192, true);
        $this->Cell($width_c2, $height, $this->objParam->getParametro('categoria'), $black, 0, 'L', true, '', 0, false, 'T', 'C');
        
        
        
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
		$this->tablewidths=array(15+53,18,18,18,18,18,18,18,18,18,18,15);
        $this->tablealigns=array('C','C','C','C','C','C','C','C','C','C','C','C');
        $this->tablenumbers=array(0,0,0,0,0,0,0,0,0,0,0,0);
        $this->tableborders=array('TB','TB','TB','TB','TB','TB','TB','TB','TB','TB','TB','TB');
        $this->tabletextcolor=array();
		
	    $RowArray = array(
            			's1' => 'PRESUPUESTO',   
                        's2' => 'SEGÚN MEMORIA',        
                        's3' => 'APROBADO',
                        's4' => 'MODIFICADO', //AJUSTADO
                        's5' => 'VIGENTE',
                        's6' => 'COMPROMETIDO',
                        's7' => 'EJECUTADO',  
                        's8' => 'PAGADO', 
                        's9' => 'SALDO POR COMPROMETER',
                        's10' => 'SALDO POR DEVENGAR', 
                        's11' => 'SALDO POR PAGAR',   
                        's12' => '% EJE');

        $this-> MultiRow($RowArray,false,1);
		
		
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
        
        //calcula el tota porcentaje de ejecucion
       if($this->totales_aprobado!=0){
				$this->totales_porcentaje_ejecucion = ($this->totales_ejecutado/$this->totales_aprobado)*100;
		}
		else{
				$this->totales_porcentaje_ejecucion = 100;
		}
        
        
        $por_eje = number_format((float)$this->totales_porcentaje_ejecucion, 2, '.', '');
		
		
        $RowArray = array(
            's2' => 'TOTALES',
            's3' => $this->totales_segun_memoria,
            's4' => $this->totales_aprobado,
            's5' => $this->totales_ajustado,
            's6' => $this->totales_vigente,
            's7' => $this->totales_comprometido,
            's8' => $this->totales_ejecutado,
            's9' => $this->totales_pagado,
            's10' => $this->totales_saldoXcomprometer,
            's11' => $this->totales_saldoXdevengar,
            's12' => $this->totales_saldoXpagar,
            's13' => $por_eje.' %');

        $this->SetFont('','B',5);
        $this->tableborders=array('LRTB','LRTB','LRTB','LRTB','LRTB','LRTB','LRTB','LRTB','LRTB','LRTB','LRTB','LRTB');
        $conf_par_tablewidths=array(15+53,18,18,18,18,18,18,18,18,18,18,15);
        $this->tablealigns=array('L','R','R','R','R','R','R','R','R','R','R','R');
        $this->tablenumbers=array(0,2,2,2,2,2,2,2,2,2,2,0);

        $this-> MultiRow($RowArray,$fill,1);
		
		
		
	}	
	
	function imprimirLinea($val,$count,$fill){
		
			$this->SetFillColor(224, 235, 255);
	        $this->SetTextColor(0);
	        $tab = '';
			$this->tabletextcolor=$conf_tabletextcolor;
			
			$ajustado = $val['formulado'] - $val['importe_aprobado'];
			if($val['importe_aprobado']!=0){
				$por_eje = ($val['ejecutado']/$val['importe_aprobado'])*100;
			}
			else{
				$por_eje = 100;
			}
			$por_eje = number_format((float)$por_eje, 2, '.', '');
			
			
			$sal_comprometido = $val['formulado'] - $val['comprometido'];
			$sal_ejecutado = $val['comprometido'] - $val['ejecutado'];
			$sal_pagado = $val['ejecutado'] - $val['pagado'];
		
		
			 $this->SetFont('','',5);
			 $this->tableborders=array('LRTB','LRTB','LRTB','LRTB','LRTB','LRTB','LRTB','LRTB','LRTB','LRTB','LRTB','LRTB');
			 $conf_par_tablewidths=array(15+53,18,18,18,18,18,18,18,18,18,18,15);
		     $this->tablealigns=array('L','R','R','R','R','R','R','R','R','R','R','R');
		     $this->tablenumbers=array(0,2,2,2,2,2,2,2,2,2,2,0);

		     //Calculo de los totales de Ejecucion Presupuestaria
                $this->totales_segun_memoria += $val['importe'];
                $this->totales_aprobado += $val['importe_aprobado'];
                $this->totales_ajustado += $ajustado;
                $this->totales_vigente += $val['formulado'];
                $this->totales_comprometido += $val['comprometido'];
                $this->totales_ejecutado += $val['ejecutado'];
                $this->totales_pagado += $val['pagado'];
                $this->totales_saldoXcomprometer += $sal_comprometido;
                $this->totales_saldoXdevengar += $sal_ejecutado;
                $this->totales_saldoXpagar += $sal_pagado;
                $this->totales_porcentaje_ejecucion += $por_eje;


			 $RowArray = array(
            			's2' => $tab.$val['codigo_cc'],
                        's3' => $val['importe'],
                        's4' => $val['importe_aprobado'],
						's5' => $ajustado,
                        's6' => $val['formulado'],
                        's7' => $val['comprometido'],
                        's8' => $val['ejecutado'],
						's9' => $val['pagado'],
						's10' => $sal_comprometido,
                        's11' => $sal_ejecutado,
						's12' => $sal_pagado,
                        's13' => $por_eje.' %');
			
           $this-> MultiRow($RowArray,$fill,1);
		
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
	        $this-> MultiRow($RowArray,false,1);			
			
	
  }
  
  

  
  
 
}
?>