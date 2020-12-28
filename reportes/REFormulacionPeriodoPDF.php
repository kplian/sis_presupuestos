<?php
// #ETR-1877          22/12/2020      JJA         Reporte memoria de calculo
class REFormulacionPeriodoPDF extends  ReportePDF {
	var $datos_titulo;
	var $datos_detalle;
	var $ancho_hoja;
	var $gerencia;
	var $numeracion;
	var $ancho_sin_totales;
	var $cantidad_columnas_estaticas;
	var $s1;
	var $s2;
	var $s3;
	var $s4;
	var $s5;
	var $s6;

	var $s7;
	var $s8;
	var $s9;
	var $s10;
	var $s11;
	var $s12;
	var $s13;
	var $s14;

	var $t1;
	var $t2;
	var $t3;
	var $t4;
	var $t5;
	var $t6;
	var $total;
	var $datos_entidad;
	var $datos_periodo;
	var $param;
	
	
	
	function datosHeader ( $detalle,$par) {
        $this->SetHeaderMargin(8);
        $this->SetAutoPageBreak(TRUE, 10);
		$this->ancho_hoja = $this->getPageWidth()-PDF_MARGIN_LEFT-PDF_MARGIN_RIGHT-10;
		$this->datos_detalle = $detalle;
		//$this->datos_titulo = $totales;
		//$this->datos_entidad = $entidad;
		//$this->datos_periodo = $periodo;
		$this->param=$par;	
		//var_dump($this->param->getParametro("ceco"));
		$this->subtotal = 0;
		$this->SetMargins(4.8, 59, 4);

	}
	
	function Header() {
		
		$white = array('LTRB' =>array('width' => 0.3, 'cap' => 'butt', 'join' => 'miter', 'dash' => 0, 'color' => array(255, 255, 255)));
        $black = array('T' =>array('width' => 0.3, 'cap' => 'butt', 'join' => 'miter', 'dash' => 0, 'color' => array(0, 0, 0)));
        
		
		$this->Ln(3);
		//formato de fecha
		
		//cabecera del reporte
		$this->Image(dirname(__FILE__).'/../../lib/imagenes/logos/logo.jpg', 10,5,40,20);
		$this->ln(5);
		

		if($this->param->getParametro("tipo_formulacion")=="ratp"){
		    $this->SetFont('','B',12);		
			$this->Cell(0,5,"ANTEPROYECTO DE PRESUPUESTOS",0,1,'C');
            $this->Ln(-1);	
		}
		if($this->param->getParametro("tipo_formulacion")=="ra"){
		    $this->SetFont('','B',12);		
			$this->Cell(0,5,"PRESUPUESTO APROBADO",0,1,'C');
            $this->Ln(-1);
		}
		if($this->param->getParametro("tipo_formulacion")=="rv"){
		    $this->SetFont('','B',12);		
			$this->Cell(0,5,"PRESUPUESTO VIGENTE",0,1,'C');
            $this->Ln(-1);
		}

		$this->SetFont('','B',8);
		$this->Cell(0,5,$this->param->getParametro("ceco"),0,1,'C');		
        $this->Ln(-1);
		$this->SetFont('','B',7);
		$this->Cell(0,5,'Gestión '.$this->param->getParametro('gestion'),0,1,'C');		
        $this->Ln(-1);
		$this->SetFont('','B',7);
		$this->Cell(0,5,"Valores en Bs.",0,1,'C');		
		$this->Ln(2);


		
		$this->SetFont('','',10);
		
		$height = 5;
        $width1 = 5;
		$esp_width = 10;
        $width_c1= 25;
		$width_c2= 112;
        $width3 = 40;
        $width4 = 75;
		
		$this->SetFont('', 'B');
		$this->Cell($width1, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $this->Cell($width_c1, $height, 'Formato:', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $this->SetFont('', '');
        $this->SetFillColor(192,192,192, true);
        $this->Cell($width_c2, $height, ($this->param->getParametro("periodicidad")=="si")?'Mensual':'Anual', 0, 0, 'L', false, '', 0, false, 'T', 'C');

		$this->Ln();
		$this->SetFont('', 'B');
		$this->Cell($width1, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $this->Cell($width_c1, $height, 'Tipo partida:', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $this->SetFont('', '');
        $this->SetFillColor(192,192,192, true);
        $this->Cell($width_c2, $height, ($this->param->getParametro("tipo_partida")=="tpg")?'Gasto':'Recurso', 0, 0, 'L', false, '', 0, false, 'T', 'C');

		$this->Ln();
		$this->SetFont('', 'B');
		$this->Cell($width1, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $this->Cell($width_c1, $height, 'Nivel:', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $this->SetFont('', '');
        $this->SetFillColor(192,192,192, true);
        $this->Cell($width_c2, $height, ($this->param->getParametro('tipo_reporte')=="agr")?'Agrupado':'Detallado', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        
		$this->Ln(11.1);
	
		$this->SetFont('','B',5);
		$this->generarCabecera();
		
		
	}
	
	function Footer() {
		
		$this->setY(-15);
		$ormargins = $this->getOriginalMargins();
		$this->SetTextColor(0, 0, 0);

		$line_width = 0.85 / $this->getScaleFactor();
		$this->SetLineStyle(array('width' => $line_width, 'cap' => 'butt', 'join' => 'miter', 'dash' => 0, 'color' => array(0, 0, 0)));
		$ancho = round(($this->getPageWidth() - $ormargins['left'] - $ormargins['right']) / 3);
		$this->Ln(2);
		$cur_y = $this->GetY();
		
		$this->Cell($ancho, 0, '', '', 0, 'L');
		$pagenumtxt = 'Página'.' '.$this->getAliasNumPage().' de '.$this->getAliasNbPages();
		$this->Cell($ancho, 0, $pagenumtxt, '', 0, 'C');
		$this->Cell($ancho, 0, '', '', 0, 'R');
		$this->Ln();
		$fecha_rep = date("d-m-Y H:i:s");
		$this->Cell($ancho, 0, '', '', 0, 'L');
		$this->Ln($line_width);
	
	}
	
   
   function generarReporte() {
		$this->setFontSubsetting(false);
		$this->AddPage();
		
	    $sw = false;
		$concepto = '';
		
		$this->generarCuerpo($this->datos_detalle);
		
        //$this->Ln(4);
        $this->cerrarCuadroTotal();
		
		$this->Ln(4);
		
        $this->Firmas();

		
	} 
	function Firmas(){
		$this->Ln();
		

		$this->Ln(30);

		$this->SetTextColor(0, 0, 0);
		$this->Cell(98, 0, '________________________', '', 0, 'C');

		$this->SetTextColor(0, 0, 0);
		$this->Cell(88, 0, '________________________', '', 0, 'C');

		$this->SetTextColor(0, 0, 0);
		$this->Cell(78, 0, '________________________', '', 0, 'C');
        $this->Ln(3);

		$this->SetTextColor(0, 0, 0);
		$this->Cell(98, 0, 'Responsable', '', 0, 'C');

		$this->SetTextColor(0, 0, 0);
		$this->Cell(88, 0, 'Responsable', '', 0, 'C');

		$this->SetTextColor(0, 0, 0);
		$this->Cell(78, 0, 'Responsable', '', 0, 'C');


        $this->Ln(3);
		$this->SetTextColor(0, 0, 0);
		$this->Cell(98, 0, 'Control de Gestión', '', 0, 'C');

		$this->SetTextColor(0, 0, 0);
		$this->Cell(88, 0, 'Centro de Costo', '', 0, 'C');

		$this->SetTextColor(0, 0, 0);
		$this->Cell(78, 0, 'Formulación', '', 0, 'C');

	}
    function generarCabecera(){
    	
		$conf_par_tablewidths=array(38,35,15,15,15,15,15,15,15,15,15,15,15,15,16);
        $conf_par_tablealigns=array('C','C','C','C','C','C','C','C','C','C','C','C','C','C','C');
        $conf_par_tablenumbers=array(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);

        $conf_tableborders=array();
        $conf_tabletextcolor=array(array(255, 255, 255),array(255, 255, 255),array(255, 255, 255),array(255, 255, 255),array(255, 255, 255),array(255, 255, 255),array(255, 255, 255),array(255, 255, 255),array(255, 255, 255),array(255, 255, 255),array(255, 255, 255),array(255, 255, 255),array(255, 255, 255),array(255, 255, 255),array(255, 255, 255));
		
		$this->tablewidths=$conf_par_tablewidths;
        $this->tablealigns=$conf_par_tablealigns;
        $this->tablenumbers=$conf_par_tablenumbers;
        $this->tableborders=$conf_tableborders;
        $this->tabletextcolor=$conf_tabletextcolor;
		

		$this->SetFillColor(54, 96, 146);
		$this->SetTextColor(255,255,255);
        $this->SetFont('','B',5);

		$RowArray = array(
				's0' => 'PARTIDA',
				's1' => 'DESCRIPCIÓN',    
				's2' => "ENERO",       
				's3' => 'FEBRERO',          
				's4' => 'MARZO',
				's5' => 'ABRIL',   
				's6' => "MAYO",
				's7' => "JUNIO",
				
				's8' => "JULIO",
				's9' => "AGOSTO",
				's10' => "SEPTIEMBRE",
				's11' => "OCTUBRE",
				's12' => "NOVIEMBRE",
				's13' => "DICIEMBRE",
				's14' => "FORMULADO"
			     );
		

		$this->MultiRow($RowArray, true, 1);
    }
	
	function generarCuerpo($detalle){
		
		$count = 1;
		$sw = 0;
		$ult_region = '';
		$fill = 0;
		
		$this->total = count($detalle);
		$this->s1 = "";
		$this->s2 = 0;
		$this->s3 = 0;
		$this->s4 = 0;
		$this->s5 = 0;
		$this->s6 = 0;
		$this->s7 = 0;
		$this->s8 = 0;
		$this->s9 = 0;
		$this->s10 = 0;
		$this->s11 = 0;
		$this->s12 = 0;
		$this->s13 = 0;
		$this->s14 = 0;
		foreach ($detalle as $val) {

			$this->imprimirLinea($val,$count,$fill);
			$count = $count + 1;
			$this->total = $this->total -1;
			$this->revisarfinPagina();
		}
	}	
	
	function imprimirLinea($val,$count,$fill){
			
		
		$fill = !$fill;
		$this->SetFillColor(255, 255, 255);
        $this->SetTextColor(0);
        $this->SetFont('','',5);

        /*if($this->objParam->getParametro('tipo_reporte')=="agr"){
        }*/
	
	    $conf_par_tablewidths=array(38,35,15,15,15,15,15,15,15,15,15,15,15,15,16);
        $conf_par_tablealigns=array('L','L','R','R','R','R','R','R','R','R','R','R','R','R','R');
        $conf_par_tablenumbers=array(0,0,2,2,0,2,0,0  ,0,0,0,0,0,0,0);
		$conf_tableborders=array('LRB','LRB','LRB','LRB','LRB','LRB','LRB','LRB'  ,'LRB','LRB','LRB','LRB','LRB','LRB','LRB');
		
		$this->tablewidths=$conf_par_tablewidths;
        $this->tablealigns=$conf_par_tablealigns;
        $this->tablenumbers=$conf_par_tablenumbers;
        $this->tableborders=$conf_tableborders;
        $this->tabletextcolor=$conf_tabletextcolor;
		
		$this->caclularMontos($val);
	    if(trim($val['sw_transaccional'])=="titular"){
			$this->SetFillColor(189, 215, 238);
	        $this->SetTextColor(0);
	        $this->SetFont('','',5);
	    }	
	    else{
			$this->SetFillColor(255, 255, 255);
	        $this->SetTextColor(0);
	        $this->SetFont('','',5);
	    }

		$RowArray = array(
					's0'  => trim($val['partida']),
					's1' => trim($val['obs']),
					's2' => $val['enero'],
					's3' => $val['febrero'],
					's4' => number_format($val['marzo'],2,",","."),
					's5' => $val['abril'],
					's6' => number_format($val['mayo'],2,",",".") ,
					's7' => number_format($val['junio'],2,",",".") ,
					's8' => number_format($val['julio'],2,",",".") ,
					's9' => number_format($val['agosto'],2,",",".") ,
					's10' => number_format($val['septiembre'],2,",","."), 
					's11' => number_format($val['octubre'],2,",",".") ,
					's12' => number_format($val['noviembre'],2,",","."), 
					's13' => number_format($val['diciembre'],2,",",".") ,
					's14' => number_format($val['formulado'],2,",",".") 
                        						);
		
		$this-> MultiRow($RowArray,$fill,1);	
	}

    function revisarfinPagina(){
		$dimensions = $this->getPageDimensions();
		$hasBorder = false; //flag for fringe case
		
		$startY = $this->GetY();
		$this->getNumLines($row['cell1data'], 80);
		
        if ($startY > 190) {

            $this->cerrarCuadroTotal();

            if($this->total!= 0){
                $this->AddPage();
            }

        }

    }
	
	function caclularMontos($val){
		if(trim($val['sw_transaccional'])=="titular"){
			$this->s2 = (float)$this->s2 + (float)($val['enero']) ;
			$this->s3 = (float)$this->s3 + (float)($val['febrero'] );
			$this->s4 = (float)$this->s4 + (float)($val['marzo']);
			$this->s5 = (float)$this->s5 + (float)($val['abril']);
			$this->s6 = (float)$this->s6 + (float)($val['mayo']);
			$this->s7 = (float)$this->s7 + (float)($val['junio']);
			$this->s8 = (float)$this->s8 + (float)($val['julio']);
			$this->s9 = (float)$this->s9 + (float)($val['agosto']);
			$this->s10 = (float)$this->s10 + (float)($val['septiembre']);
			$this->s11 = (float)$this->s11 + (float)($val['octubre'] );
			$this->s12 = (float)$this->s12 + (float)($val['noviembre']);
			$this->s13 = (float)$this->s13 + (float)($val['diciembre']);
			$this->s14 = (float)$this->s14 + (float)($val['formulado']);
	    }
	}

  function cerrarCuadroTotal(){

	$this->tablewidths=array(38,35,15,15,15,15,15,15,15,15,15,15,15,15,16);
    $this->tablealigns=array('L','L','R','R','R','R','R','R','R','R','R','R','R','R','R');
    $this->tablenumbers=array(0,0,2,2,0,2,0,0  ,0,0,0,0,0,0,0);	
    $this->tableborders=array('LRB','LRB','LRB','LRB','LRB','LRB','LRB','LRB'  ,'LRB','LRB','LRB','LRB','LRB','LRB','LRB');		
    $conf_tabletextcolor=array(array(255, 255, 255),array(255, 255, 255),array(255, 255, 255),array(255, 255, 255),array(255, 255, 255),array(255, 255, 255),array(255, 255, 255),array(255, 255, 255),array(255, 255, 255),array(255, 255, 255),array(255, 255, 255),array(255, 255, 255),array(255, 255, 255),array(255, 255, 255),array(255, 255, 255));
    $this->tabletextcolor=$conf_tabletextcolor;

    $this->SetFont('','B',5);
    $this->SetFillColor(54, 96, 146);
    $RowArray = array( 
                'espacio' => 'TOTAL: ', 
                's1' => "",
                's2' => $this->s2,
                's3' => $this->s3,
                's4' => number_format($this->s4,2,",","."),
                's5' => $this->s5,
                's6' => number_format($this->s6,2,",","."),
                's7' => number_format($this->s7,2,",","."),
                's8' => number_format($this->s8,2,",","."),
                's9' => number_format($this->s9,2,",","."),
                's10' => number_format($this->s10,2,",","."),
                's11' => number_format($this->s11,2,",","."),
                's12' => number_format($this->s12,2,",","."),
                's13' => number_format($this->s13,2,",","."),
                's14' => number_format($this->s14,2,",",".")
              );     
                 
    $this-> MultiRow($RowArray,true,1);

  }
  
 
}
?>