<?php
require_once dirname(__FILE__).'/../../pxp/lib/lib_reporte/ReportePDF.php';

class RConsultaIngasPDF extends  ReportePDF{
    var $datos ;
    var $ancho_hoja;
    var $numeracion;
    var $ancho_sin_totales;
    var $cantidad_columnas_estaticas;

    function Header() {
        $white = array('LTRB' =>array('width' => 0.3, 'cap' => 'butt', 'join' => 'miter', 'dash' => 0, 'color' => array(255, 255, 255)));
        $black = array('T' =>array('width' => 0.3, 'cap' => 'butt', 'join' => 'miter', 'dash' => 0, 'color' => array(0, 0, 0)));
        
        $this->Ln(3);
        //cabecera del reporte
        $this->Image(dirname(__FILE__).'/../../lib/imagenes/logos/logo.jpg', 10,5,35,20);
        $this->ln(5);
        $this->SetFont('','B',11);
        $this->Cell(0,5,"AUTORIZACIONES",0,1,'C');
        $this->Cell(0,5,"CONCEPTOS INGRESOS / GASTOS",0,1,'C');
        $this->Ln(10);

        $this->SetFont('','B',7);

        $this->Cell(10,0,"N°",1,0,'C');
        $this->Cell(40,0,"CONCEPTO GASTOS",1,0,'C');
        $this->Cell(15,0,"TIPO",1,0,'C');
        $this->Cell(40,0,"PARTIDA",1,0,'C');
        $this->Cell(20,0,"CAJA CHICA",1,0,'C');
        $this->Cell(25,0,"ADQUISICIONES",1,0,'C');
        $this->Cell(22,0,"PAGO DIRECTO",1,0,'C');
        $this->Cell(23,0,"FONDO AVANCE",1,0,'C');
        $this->Cell(20,0,"PAGO UNICO",1,0,'C');
        $this->Cell(20,0,"CONTRATO",1,0,'C');
        $this->Cell(20,0,"ESPECIAL",1,1,'C');
    }

    function setDatos($datos) {

        $this->datos = $datos;
        $this->SetHeaderMargin(8);
        $this->SetAutoPageBreak(TRUE, 12);
        $this->ancho_hoja = $this->getPageWidth()-PDF_MARGIN_LEFT-PDF_MARGIN_RIGHT-10;
        $this->SetMargins(15, 40, 15);
        //var_dump( $this->datos);exit;
    }

    function  generarReporte()
    {

        $this->AddPage();

        $fill = 0;
        $contador = 1;
        foreach ($this->datos as $record) {
            $this->SetFillColor(136, 146, 191);
            $this->SetTextColor(0);
            $this->SetFont('','B',6);

            $conf_par_tablewidths=array(10,40,15,40,20,25,22,23,20,20,20);
            $conf_par_tablealigns=array('C','L','C','L','C','C','C','C','C','C','C');
            $conf_par_tablenumbers=array(0,0,0,0,0,0,0,0,0,0,0);
            $conf_tableborders=array('T','T','T','T','T','T','T','T','T','T','T');

            $this->tablewidths=$conf_par_tablewidths;
            $this->tablealigns=$conf_par_tablealigns;
            $this->tablenumbers=$conf_par_tablenumbers;
            $this->tableborders=$conf_tableborders;

            $RowArray = array(
                's0' => $contador,
                's1' => $record["desc_ingas"],
                's2' => $record["tipo"],
                's3' => $record["desc_partida"],
                's4' => $record["caja_chica"],
                's5' => $record["adquisiciones"],
                's6' => $record["pago_directo"],
                's7' => $record["fondo_avance"],
                's8' => $record["pago_unico"],
                's9' => $record["contrato"],
                's10' => $record["especial"]
            );


            $this-> MultiRow($RowArray,$fill,1);
            $fill = !$fill;
            $contador++;

        }



    }
}
?>