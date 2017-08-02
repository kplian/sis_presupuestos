<?php
// Extend the TCPDF class to create custom MultiRow
class RMemoriaProgramacionWf extends  ReportePDF {
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



    function datosHeader ( $detalle, $totales,$dataEmpresa) {
        $this->ancho_hoja = $this->getPageWidth()-PDF_MARGIN_LEFT-PDF_MARGIN_RIGHT-10;
        $this->datos_detalle = $detalle;
        $this->datos_titulo = $totales;
        $this->datos_entidad = $dataEmpresa;
        $this->subtotal = 0;
        $this->SetMargins(7, 41, 5);

        $this->SetHeaderMargin(4);
        $this->SetAutoPageBreak(TRUE, -15);
    }

    function Header() {

        $white = array('LTRB' =>array('width' => 0.3, 'cap' => 'butt', 'join' => 'miter', 'dash' => 0, 'color' => array(255, 255, 255)));
        $black = array('T' =>array('width' => 0.3, 'cap' => 'butt', 'join' => 'miter', 'dash' => 0, 'color' => array(0, 0, 0)));


        $this->Ln(3);
        //formato de fecha

        //cabecera del reporte
        $this->Image(dirname(__FILE__).'/../../lib/imagenes/logos/logo.jpg', 10,5,35,20);
        //$this->ln(5);


        $this->SetFont('','B',12);
        $this->Cell(0,5,"PROGRAMACIÓN PRESUPUESTARIA",0,1,'C');
        $this->Cell(0,5,mb_strtoupper($this->datos_entidad['nombre'],'UTF-8'),0,1,'C');
        $this->Cell(0,5,"GESTIÓN ".$this->datos_detalle[0]["gestion"],0,1,'C');
        //$this->Ln();
        $this->SetFont('','B',7);
        $this->Cell(0,5,"(Expresado en Bolivianos)",0,1,'C');
        //$this->Ln(2);

        $this->SetFont('','',10);

        $height = 5;
        $width1 = 5;
        $esp_width = 10;
        $width_c1= 55;
        $width_c2= 120;
        $width3 = 40;
        $width4 = 75;


        $this->Ln();
        $tmp = 'PRESUPUESTO';

        $this->Cell($width1, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $this->Cell($width_c1, $height, $tmp.": ", 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $this->SetFont('', '');
        //$this->SetFillColor(192,192,192, true);
        $this->Cell($width_c2, $height, $this->datos_detalle[0]["descripcion"], 0, 0, 'L', false, '', 0, false, 'T', 'C');


        //$this->Ln();
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

        //arma cabecera de la tabla
        $conf_par_tablewidths=array(12,1,43,16,16,16,16,16,16,16,16,16,16,16,16,20);
        $conf_par_tablealigns=array('C','C','C','C','C','C','C','C','C','C','C','C','C','C','C','C');
        $conf_par_tablenumbers=array(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
        $conf_tableborders=array('TB','TB','TB','TB','TB','TB','TB','TB','TB','TB','TB','TB','TB','TB','TB','TB');
        $conf_tabletextcolor=array();

        $this->tablewidths=$conf_par_tablewidths;
        $this->tablealigns=$conf_par_tablealigns;
        $this->tablenumbers=$conf_par_tablenumbers;
        $this->tableborders=$conf_tableborders;
        $this->tabletextcolor=$conf_tabletextcolor;

        $RowArray = array(
            's0'  => 'COD',
            's1.0' => '',
            's1' => 'PARTIDA',
            's2' => 'ENERO',
            's3' => 'FEBRERO',
            's4' => 'MARZO',
            's5' => 'ABRIL',
            's6' => 'MAYO',
            's7' => 'JUNIO',
            's8' => 'JULIO',
            's9' => 'AGOSTO',
            's10' => 'SEPTIEMBRE',
            's11' => 'OCTUBRE',
            's12' => 'NOVIEMBRE',
            's13' => 'DICIEMBRE',
            's14' => 'TOTAL');

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



    }

    function imprimirLinea($val,$count,$fill){

        $this->SetFillColor(224, 235, 255);
        $this->SetTextColor(0);
        $tab = '';
        $this->tabletextcolor=$conf_tabletextcolor;
        $total = $val['c1'] + $val['c2'] + $val['c3'] + $val['c4'] + $val['c5'] + $val['c6'] + $val['c7'] + $val['c8'] + $val['c9'] + $val['c10'] + $val['c11'] + $val['c12'];


        if ($val['nivel_partida'] == 0){
            $this->SetFont('','BU',6);
            $this->tableborders=array('LRTB','LRTB','LRTB','LRTB','LRTB','LRTB','LRTB','LRTB','LRTB','LRTB','LRTB','LRTB','LRTB','LRTB','LRTB');
            $this->tablewidths=array(10,45,16,16,16,16,16,16,16,16,16,16,16,16,20);
            $this->tablealigns=array('L','L','R','R','R','R','R','R','R','R','R','R','R','R','R');
            $this->tablenumbers=array(0,0,2,2,2,2,2,2,2,2,2,2,2,2,2);
            $RowArray = array(
                's1' =>  $tab.$val['codigo_partida'],
                's2' => $tab.$val['nombre_partida'],
                's3' => $val['c1'],
                's4' => $val['c2'],
                's5' => $val['c3'],
                's6' => $val['c4'],
                's7' => $val['c5'],
                's8' => $val['c6'],
                's9' => $val['c7'],
                's10' => $val['c8'],
                's11' => $val['c9'],
                's12' => $val['c10'],
                's13' => $val['c11'],
                's14' => $val['c12'],
                's15' => $total);

        }

        if ($val['nivel_partida'] == 1){
            //$this->ln();
            $this->SetFont('','BU',6);
            $this->tableborders=array('LR','LR','LR','LR','LR','LR','LR','LR','LR','LR','LR','LR','LR','LR','LR');
            $this->tablewidths=array(10,45,16,16,16,16,16,16,16,16,16,16,16,16,20);
            $this->tablealigns=array('L','L','R','R','R','R','R','R','R','R','R','R','R','R','R');
            $this->tablenumbers=array(0,0,2,2,2,2,2,2,2,2,2,2,2,2,2);

            $tab = '';
            $RowArray = array(
                's1' =>  $tab.$val['codigo_partida'],
                's2' => $tab.$val['nombre_partida'],
                's3' => $val['c1'],
                's4' => $val['c2'],
                's5' => $val['c3'],
                's6' => $val['c4'],
                's7' => $val['c5'],
                's8' => $val['c6'],
                's9' => $val['c7'],
                's10' => $val['c8'],
                's11' => $val['c9'],
                's12' => $val['c10'],
                's13' => $val['c11'],
                's14' => $val['c12'],
                's15' => $total);

        }

        if ($val['nivel_partida'] == 2){
            $this->SetFont('','',5);
            $this->tableborders=array('LR','L','R','LR','LR','LR','LR','LR','LR','LR','LR','LR','LR','LR','LR','LR');
            $this->tablewidths=array(10,2,43,16,16,16,16,16,16,16,16,16,16,16,16,20);
            $this->tablealigns=array('L','L','L','R','R','R','R','R','R','R','R','R','R','R','R','R');
            $this->tablenumbers=array(0,0,0,2,2,2,2,2,2,2,2,2,2,2,2,2);
            $tab = "\t\t";
            $RowArray = array(
                's1' =>  $tab.$val['codigo_partida'],
                's2.0' => '',
                's2' => $val['nombre_partida'],
                's3' => $val['c1'],
                's4' => $val['c2'],
                's5' => $val['c3'],
                's6' => $val['c4'],
                's7' => $val['c5'],
                's8' => $val['c6'],
                's9' => $val['c7'],
                's10' => $val['c8'],
                's11' => $val['c9'],
                's12' => $val['c10'],
                's13' => $val['c11'],
                's14' => $val['c12'],
                's15' => $total);

        }
        if ($val['nivel_partida'] == 3){
            $this->SetFont('','',5);
            $this->tableborders=array('LR','L','R','LR','LR','LR','LR','LR','LR','LR','LR','LR','LR','LR','LR','LR');
            $this->tablewidths=array(10,3,42,16,16,16,16,16,16,16,16,16,16,16,16,20);
            $this->tablealigns=array('L','L','L','R','R','R','R','R','R','R','R','R','R','R','R','R');
            $this->tablenumbers=array(0,0,0,2,2,2,2,2,2,2,2,2,2,2,2,2);

            $tab = "\t\t\t";
            $RowArray = array(
                's1' =>  $tab.$val['codigo_partida'],
                's2.0' => '',
                's2' => $val['nombre_partida'],
                's3' => $val['c1'],
                's4' => $val['c2'],
                's5' => $val['c3'],
                's6' => $val['c4'],
                's7' => $val['c5'],
                's8' => $val['c6'],
                's9' => $val['c7'],
                's10' => $val['c8'],
                's11' => $val['c9'],
                's12' => $val['c10'],
                's13' => $val['c11'],
                's14' => $val['c12'],
                's15' => $total);

        }
        if ($val['nivel_partida'] > 3){
            $this->SetFont('','',5);
            $this->tableborders=array('LR','L','R','LR','LR','LR','LR','LR','LR','LR','LR','LR','LR','LR','LR','LR');
            $this->tablewidths=array(10,4,41,16,16,16,16,16,16,16,16,16,16,16,16,20);
            $this->tablealigns=array('L','L','L','R','R','R','R','R','R','R','R','R','R','R','R','R');
            $this->tablenumbers=array(0,0,0,2,2,2,2,2,2,2,2,2,2,2,2,2);

            $tab = "\t\t\t";
            $RowArray = array(
                's1' =>  $tab.$val['codigo_partida'],
                's2.0' => '',
                's2' => $val['nombre_partida'],
                's3' => $val['c1'],
                's4' => $val['c2'],
                's5' => $val['c3'],
                's6' => $val['c4'],
                's7' => $val['c5'],
                's8' => $val['c6'],
                's9' => $val['c7'],
                's10' => $val['c8'],
                's11' => $val['c9'],
                's12' => $val['c10'],
                's13' => $val['c11'],
                's14' => $val['c12'],
                's15' => $total);

        }








        $this-> MultiRow($RowArray,$fill,1);

    }


    function revisarfinPagina(){
        $dimensions = $this->getPageDimensions();
        $hasBorder = false; //flag for fringe case

        $startY = $this->GetY();
        $this->getNumLines($row['cell1data'], 80);

        if (($startY + 4 * 10) + $dimensions['bm'] > ($dimensions['hk'])) {


            $k = 	($startY + 4 * 6) + $dimensions['bm'] - ($dimensions['hk']);
            /*
            for($i=0;$i<=k;$i++){
                $this->ln();
                $this->ln();
                $this->ln();
                $this->ln();
                $this->ln();
                $this->ln();
            }*/

            if($this->total!= 0){
                $this->AddPage();
            }



        }


    }





    function cerrarCuadro(){


        //si noes inicio termina el cuardro anterior

        $this->tablewidths=array(10 +45+16+16+16+16+16+16+16+16+16+16+16+16+20);
        $this->tablealigns=array('L');
        $this->tablenumbers=array(0,);
        $this->tableborders=array('T');
        $RowArray = array('espacio' => '');
        $this-> MultiRow($RowArray,false,1);


    }






}
?>