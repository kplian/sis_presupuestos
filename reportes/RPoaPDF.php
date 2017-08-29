<?php
require_once dirname(__FILE__).'/../../pxp/lib/lib_reporte/ReportePDF.php';
require_once(dirname(__FILE__) . '/../../lib/tcpdf/tcpdf_barcodes_2d.php');
class RPoaPDF extends  ReportePDF{
    var $datos ;
    var $ancho_hoja;
    /*var $gerencia;
    var $numeracion;
    var $ancho_sin_totales;
    var $cantidad_columnas_estaticas;*/

    function Header() {
        $this->Ln(3);

        //cabecera del reporte
        $this->Image(dirname(__FILE__).'/../../lib/imagenes/logos/logo.jpg', 20,5,40,20);
        $this->ln(5);


        $this->SetFont('','B',12);
        $this->Cell(0,5,"PROGRAMA ANUAL DE OPERACIONES",0,1,'C');
        $this->Cell(0,5,"GESTIÓN - ".$this->datos[0]['gestion'],0,1,'C');
        $this->Ln(5);

        /*$tbl = '<table border="1" style="font-size: 7pt;"><tr align="center">
                        <td width="6%"><b>COD. OBJ. GES. INST.</b></td>
                        <td width="6%"><b>POND. OBJ. GES. INST.</b></td>
                        <td width="21%"><b>OBJETIVOS DE GESTIÓN INSTITUCIONAL</b></td>
                        <td width="7%"><b>COD. OBJ. ESP.</b></td>
                        <td width="6%"><b>POND. OBJ. ESP.</b></td>
                        <td width="17%"><b>OBJETIVO ESPECÍFICO</b></td>
                        <td width="7%"><b>COD. OPE.</b></td>
                        <td width="28%"><b>OPERACIÓN</b></td>
                      </tr></table>
                     ';
        $this->writeHTML ($tbl, true, false,false, false, 'C');*/

    }

    function setDatos($datos) {

        $this->datos = $datos;
        //var_dump( $this->datos);exit;
    }

    function  generarReporte()
    {
        $this->AddPage();
        $this->SetMargins(15, 40, 15);
        $this->SetAutoPageBreak(TRUE, PDF_MARGIN_BOTTOM);

        $obj_institucion = '';
        $obj_gestion = '';
        $obj_operacion = '';
        $id_obj_fk = '';
        $id_padre = '';
        $bandera = true;
        $bandera_head = true;
        $contador = 0;
        $this->Ln(7.5);
        //$tbl = '<table border="1" style="font-size: 7pt;">';
        $cont_lineas = $this->getY();
        $tbl = '';

        foreach( $this->datos as $record) {
            //if($record['gestion']=='2017') {

                if ($bandera_head) {
                    $tbl .= '<table border="1" style="font-size: 7pt;"><tr align="center">
                        <td width="6%"><b>COD. OBJ. GES. INST.</b></td>
                        <td width="6%"><b>POND. OBJ. GES. INST.</b></td>
                        <td width="21%"><b>OBJETIVOS DE GESTIÓN INSTITUCIONAL</b></td>
                        <td width="7%"><b>COD. OBJ. ESP.</b></td>
                        <td width="6%"><b>POND. OBJ. ESP.</b></td>
                        <td width="17%"><b>OBJETIVO ESPECÍFICO</b></td>
                        <td width="7%"><b>COD. OPE.</b></td>
                        <td width="28%"><b>OPERACIÓN</b></td>
                      </tr>
                     ';
                    $bandera_head = false;
                }

                if ($record['nivel_objetivo'] == '1') {
                    if ($contador >= 1) {
                        $tbl .= '</table>';
                        if ($cont_lineas >= 180 && $cont_lineas <= 215.9) {

                            $tbl .= '<br><br><br><br><br><br><br>';
                            $tbl .= '<table border="1" style="font-size: 7pt;">
                                        <tr align="center">
                                            <td width="6%"><b>COD. OBJ. GES. INST.</b></td>
                                            <td width="6%"><b>POND. OBJ. GES. INST.</b></td>
                                            <td width="21%"><b>OBJETIVOS DE GESTIÓN INSTITUCIONAL</b></td>
                                            <td width="7%"><b>COD. OBJ. ESP.</b></td>
                                            <td width="6%"><b>POND. OBJ. ESP.</b></td>
                                            <td width="17%"><b>OBJETIVO ESPECÍFICO</b></td>
                                            <td width="7%"><b>COD. OPE.</b></td>
                                            <td width="28%"><b>OPERACIÓN</b></td>
                                        </tr>
                                     ';
                        } else {
                            $tbl .= '<table border="1" style="font-size: 7pt;">';
                        }


                    }
                    $contador++;
                    $tbl .= '<tr style="font-size: 7pt;">     
                        <td width="6%" align="center" rowspan="' . $record['nietos'] . '"><br>' . $record['codigo'] . '</td>
                        <td width="6%" align="center" valign="center" rowspan="' . $record['nietos'] . '"><br>' . $record['ponderacion'] . '%</td>
                        <td width="21%" rowspan="' . $record['nietos'] . '"><br>' . $record['descripcion'] . '</td>
                      ';
                    $id_padre = $record['id_objetivo'];
                    $bandera = false;
                }

                if ($record['nivel_objetivo'] == '2') {
                    //if($obj_gestion!='') {
                    if ($record['codigo'] != $obj_gestion && $bandera) {
                        $tbl .= '<tr style="font-size: 7pt;">';

                    }
                    //}
                    $tbl .= '<td width="7%" align="center" rowspan="' . $record['hijos'] . '"><br>' . $record['codigo'] . '</td>
                       <td width="6%" align="center" rowspan="' . $record['hijos'] . '"><br>' . $record['ponderacion'] . '%</td>
                       <td width="17%" rowspan="' . $record['hijos'] . '"><br>' . $record['descripcion'] . '</td>
                      ';
                    $obj_gestion = $record['codigo'];
                    $bandera = true;
                }

                if ($record['nivel_objetivo'] == '3') {
                    //if($record['hijos']!=0 && $record['nietos']!=0){
                    if ($record['id_objetivo_fk'] != '') {
                        if ($record['id_objetivo_fk'] == $id_obj_fk)
                            $tbl .= '<tr style="font-size: 7pt;">';
                    }
                    $tbl .= '<td width="7%" align="center">' . $record['codigo'] . '</td>
                       <td width="28%">' . $record['descripcion'] . '</td>
                       </tr>
                      ';
                    $id_obj_fk = $record['id_objetivo_fk'];
                    $bandera = true;
                    $cont_lineas += 8;
                }

           /*}else {

                if ($bandera_head) {
                    $tbl .= '<table border="1" style="font-size: 7pt;"><tr align="center">
                                <td width="7%"><b>COD. OBJ. ESP.</b></td>
                                <td width="6%"><b>POND. OBJ. ESP.</b></td>
                                <td width="35%"><b>OBJETIVO ESPECÍFICO</b></td>
                                <td width="7%"><b>COD. OPE.</b></td>
                                <td width="45%"><b>OPERACIÓN</b></td>
                          </tr>
                         ';
                    $bandera_head = false;
                }

                if ($record['nivel_objetivo'] == '1') {
                    if($contador>=1){
                        $tbl.='</table>';
                        if($cont_lineas>=180&&$cont_lineas<=215.9){

                            $tbl.='<br><br><br><br><br><br>';
                            $tbl .= '<table border="1" style="font-size: 7pt;">
                                            <tr align="center">
                                            <td width="6%"><b>COD. OBJ. GES. INST.</b></td>
                                            <td width="6%"><b>POND. OBJ. GES. INST.</b></td>
                                            <td width="21%"><b>OBJETIVOS DE GESTIÓN INSTITUCIONAL</b></td>
                                            <td width="7%"><b>COD. OBJ. ESP.</b></td>
                                            <td width="6%"><b>POND. OBJ. ESP.</b></td>
                                            <td width="17%"><b>OBJETIVO ESPECÍFICO</b></td>
                                            <td width="7%"><b>COD. OPE.</b></td>
                                            <td width="28%"><b>OPERACIÓN</b></td>
                                      </tr>
                                     ';
                        }else{
                            $tbl .= '<table border="1" style="font-size: 7pt;">';
                        }
                    }
                    $contador++;
                    $tbl .= '<tr style="font-size: 7pt;">     
                        <td align="center" rowspan="' . $record['nietos'] . '">' . $record['codigo'] . '</td>
                        <td align="center" valign="center" rowspan="' . $record['nietos'] . '">' . $record['ponderacion'] . '%</td>
                        <td rowspan="' . $record['nietos'] . '">' . $record['descripcion'] . '</td>
                      ';
                    $id_padre = $record['id_objetivo'];
                    $bandera = false;
                }

                if ($record['nivel_objetivo'] == '2') {
                    if ($record['codigo'] != $obj_gestion && $bandera) {
                        $tbl .= '<tr style="font-size: 7pt;">';

                    }
                    $tbl .= '<td align="center" rowspan="' . $record['hijos'] . '">' . $record['codigo'] . '</td>
                       <td align="center" rowspan="' . $record['hijos'] . '">' . $record['ponderacion'] . '%</td>
                       <td rowspan="' . $record['hijos'] . '">' . $record['descripcion'] . '</td>
                      ';
                    $obj_gestion = $record['codigo'];
                    $bandera = true;
                    $cont_lineas+=8;
                }

                if ($record['nivel_objetivo'] == '3') {
                    if ($record['id_objetivo_fk'] != '') {
                        if ($record['id_objetivo_fk'] == $id_obj_fk)
                            $tbl .= '<tr style="font-size: 7pt;">';
                    }
                    $tbl .= '<td align="center">' . $record['codigo'] . '</td>
                       <td>' . $record['descripcion'] . '</td>
                       </tr>
                      ';
                    $id_obj_fk = $record['id_objetivo_fk'];
                    $bandera = true;
                    $cont_lineas+=8;
                }

            }*/

        }
        $tbl .='</table>';
        $this->writeHTML ($tbl);

    }


    function generarImagen($nom, $car, $ofi){
        $cadena_qr = 'Nombre: '.$nom. "\n" . 'Cargo: '.$car."\n".'Oficina: '.$ofi ;
        $barcodeobj = new TCPDF2DBarcode($cadena_qr, 'QRCODE,M');
        $png = $barcodeobj->getBarcodePngData($w = 8, $h = 8, $color = array(0, 0, 0));
        $im = imagecreatefromstring($png);
        if ($im !== false) {
            header('Content-Type: image/png');
            imagepng($im, dirname(__FILE__) . "/../../reportes_generados/" . $nom . ".png");
            imagedestroy($im);

        } else {
            echo 'A ocurrido un Error.';
        }
        $url_archivo = dirname(__FILE__) . "/../../reportes_generados/" . $nom . ".png";

        return $url_archivo;
    }

}
?>