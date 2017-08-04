<?php
class RNotaIntern extends  ReportePDF{

    function Header() {
        $this->Ln(15);
        $url_imagen = dirname(__FILE__) . '/../../pxp/lib/images/Logo-BoA.png';



        $citeFin = $this->datos[0]['nro_cite_fin'];
        $tbl = '
                
                <font size="8">
                    <table width="100%" style="text-align: center;" cellspacing="0" cellpadding="1" border="1">
                        
                            <tr>
                                <th style="width: 25%; color: #444444;" rowspan="3">
                                    &nbsp;<br><img  style="width: 150px;" src="'.$url_imagen.'" alt="Logo">
                                </th>		
                                <th style="width: 45%;" rowspan="3"><br>  <h1>NOTA INTERNA </h1></th>
                                <th style="width: 30%;" colspan="2"><b>R-GG-14</b> <br> <b>Rev.01-Sep/2012<br></b></th>
                               
                            </tr>
                            <tr>
                                <th style="width: 10%; "><b>CITE:</b></th>
                                <td style="width: 20%;  color: #444444;"><b>'.$citeFin.'</b></td>
                            </tr>
                            <tr>
                                <th style="width: 10%;"  ><b>Fecha:</b></th>
                                <td style="width: 20%;  color: #444444;"  >'.$this->datos[0]['fecha_nota'].'</td>
                                
                            </tr>
                            
                       
                    </table>
                </font>
                ';

        $this->writeHTML($tbl);

    }
    public function Footer()
    {
        $this->SetY(-15);
        $this->SetFont('helvetica', 'I', 6);
        $this->Cell(0, 0, 'c.c:Archivo', 0, 1, 'L');
        $this->Cell(0, 0, 'adj./doc', 0, 0, 'L');
    }
    function setDatos($datos) {
        $this->datos = $datos;
    }
    function reporteGeneral(){

        $this->SetAutoPageBreak(TRUE, PDF_MARGIN_BOTTOM);
        $this->SetFont('helvetica','',10);
        $this->Ln(10);
        $this->Cell(150, 2,'A                   :                  '.'Gonzalo Mayorga Lazcano', 0, 2, 'L', false, '', 0, false, 'T', 'C');
        $this->SetFont('helvetica','B',10);
        $this->Cell(150, 2,'                                        '.'Gerente Administrativo Financiero' , 0, 2, 'L', false, '', 0, false, 'T', 'C');
        $this->ln();
        $this->SetFont('helvetica','',10);
        $this->Cell(150, 2,'                     :                   '.'Karina Barrancos Ríos', 0, 2, 'L', false, '', 0, false, 'T', 'C');
        $this->SetFont('helvetica','B',10);
        $this->Cell(150, 2,'                                         '.'Jefe Presupuestos y Planificación Financiera' , 0, 2, 'L', false, '', 0, false, 'T', 'C');
        $this->ln();
        $this->SetFont('helvetica','',10);
        $this->Cell(150, 2,'Via                :                  '.$this->datos[0]['desc_funcionario1'], 0, 2, 'L', false, '', 0, false, 'T', 'C');
        $this->SetFont('helvetica','B',10);
        $this->Cell(150, 2,'                                        '.$this->datos[0]['nombre_cargo'] , 0, 2, 'L', false, '', 0, false, 'T', 'C');
        $this->ln();
        $this->SetFont('helvetica','',10);
        $this->Cell(150, 2,'De                 :                  '.$this->datos[0]['funcionario_gerencia'], 0, 2, 'L', false, '', 0, false, 'T', 'C');
        $this->SetFont('helvetica','B',10);
        $this->Cell(150, 2,'                                        '.$this->datos[0]['cargo_gerencia'] , 0, 2, 'L', false, '', 0, false, 'T', 'C');
        $this->ln();
        $this->Cell(150, 2,'' , 0, 2, 'L', false, '', 0, false, 'T', 'C');
        $this->Cell(150, 2,'Ref.               :                 '.'PRESENTACION FORMULACIÓN ANTEPROYECTO PRESUPUESTO GESTIÓN '.$this->datos[0]['gestion'], 0, 2, 'L', false, '', 0, false, 'T', 'C');

        $style = array('width' => 0.5, 'cap' => 'butt', 'join' => 'miter', 'dash' => 0, 'color' => 'black');
        $this->Line(17, 125, 200, 125, $style);
        $this->SetFont('helvetica','',11);
        $this->Ln(20);
        $this->writeHTML('<p>De mi consideración:</p><br><p align="justica">En atención a Nota interna ('.$this->datos[0]['nro_cite_inicio'].') referida a la formulación del Plan Operativo Anual y Anteproyecto de Presupuesto Institucional - Gestion '.$this->datos[0]['gestion'].', 
                            remito para su consideración y posterior aprobación la conclusión del presupuesto correspondiente en esta jefatuta y las diferentes 
                            unidades que componen la misma.</p>
                            <p align="justica">Haciendo notar, que se tomó en cuenta los lineamientos establecidos por la alta gerencia.</p>
                            <p align="justica">Sin otro particular, saludo a usted atentamente.</p>
                            ',true);

        $html = 'Funcionario: '.$this->datos[0]['funcionario_gerencia']."\n".'Cargo: '.$this->datos[0]['cargo_gerencia'];
        $style = array(
            'border' => 2,
            'vpadding' => 'auto',
            'hpadding' => 'auto',
            'fgcolor' => array(0,0,0),
            'bgcolor' => false, //array(255,255,255)
            'module_width' => 1, // width of a single module in points
            'module_height' => 1 // height of a single module in points
        );
        $this->write2DBarcode($html, 'QRCODE,M', 90, 188, 30, 30, $style, 'N');
        $this->Ln(6);
        $this->writeHTML('<p align="center">'.$this->datos[0]['funcionario_gerencia'].'</p> ',true);


        //var_dump(date("Y")); exit;

    }
    function fechaLiteral($va){
        setlocale(LC_ALL,"es_ES@euro","es_ES","esp");
        $fecha = strftime("%d de %B de %Y", strtotime($va));
        return $fecha;
    }
    function generarReporte() {
        $this->SetMargins(15,40,15);
        $this->setFontSubsetting(false);
        $this->AddPage();
        $this->SetMargins(15,40,15);
        $this->reporteGeneral();
    }
}
?>