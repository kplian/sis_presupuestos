<?php
/**
 *@package pXP
 *@file RMomientoPre.php
 *@author  (miguel.mamani)
 *@date 17-12-2018 19:20:26
 *@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
 */
/**
HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
#4				 03/01/2019	          Miguel Mamani			reporte de presupuesto que no figuran en gestión nueva
#9			       01/02/2019	       Miguel Mamani			MODIFICACIONES PRESUPUESTO CONTABLE CON SALDO QUE NO FIGURAN EN GESTIÓN

 **/
class RMomientoPre
{
    private $docexcel;
    private $objWriter;
    private $equivalencias=array();
    private $objParam;
    public  $url_archivo;

    function __construct(CTParametro $objParam)
    {
        $this->objParam = $objParam;
        $this->url_archivo = "../../../reportes_generados/".$this->objParam->getParametro('nombre_archivo');
        set_time_limit(400);
        $cacheMethod = PHPExcel_CachedObjectStorageFactory:: cache_to_phpTemp;
        $cacheSettings = array('memoryCacheSize'  => '10MB');
        PHPExcel_Settings::setCacheStorageMethod($cacheMethod, $cacheSettings);

        $this->docexcel = new PHPExcel();
        $this->docexcel->getProperties()->setCreator("PXP")
            ->setLastModifiedBy("PXP")
            ->setTitle($this->objParam->getParametro('titulo_archivo'))
            ->setSubject($this->objParam->getParametro('titulo_archivo'))
            ->setDescription('Reporte "'.$this->objParam->getParametro('titulo_archivo').'", generado por el framework PXP')
            ->setKeywords("office 2007 openxml php")
            ->setCategory("Report File");
        $this->equivalencias=array( 0=>'A',1=>'B',2=>'C',3=>'D',4=>'E',5=>'F',6=>'G',7=>'H',8=>'I',
            9=>'J',10=>'K',11=>'L',12=>'M',13=>'N',14=>'O',15=>'P',16=>'Q',17=>'R',
            18=>'S',19=>'T',20=>'U',21=>'V',22=>'W',23=>'X',24=>'Y',25=>'Z',
            26=>'AA',27=>'AB',28=>'AC',29=>'AD',30=>'AE',31=>'AF',32=>'AG',33=>'AH',
            34=>'AI',35=>'AJ',36=>'AK',37=>'AL',38=>'AM',39=>'AN',40=>'AO',41=>'AP',
            42=>'AQ',43=>'AR',44=>'AS',45=>'AT',46=>'AU',47=>'AV',48=>'AW',49=>'AX',
            50=>'AY',51=>'AZ',
            52=>'BA',53=>'BB',54=>'BC',55=>'BD',56=>'BE',57=>'BF',58=>'BG',59=>'BH',
            60=>'BI',61=>'BJ',62=>'BK',63=>'BL',64=>'BM',65=>'BN',66=>'BO',67=>'BP',
            68=>'BQ',69=>'BR',70=>'BS',71=>'BT',72=>'BU',73=>'BV',74=>'BW',75=>'BX',
            76=>'BY',77=>'BZ');
    }
    function imprimeCabecera() {

        $titulossubcabezera = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 9,
                'name'  => 'Arial'
            ),
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER
            )
        );
        //
        $styleTitulos3 = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 10,
                'name'  => 'Arial',
                'color' => array(
                    'rgb' => 'FFFFFF'
                )
            ),
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER
            ),
            'fill' => array(
                'type' => PHPExcel_Style_Fill::FILL_SOLID,
                'color' => array(
                    'rgb' => '000000'
                )
            ),
            'borders' => array(
                'allborders' => array(
                    'style' => PHPExcel_Style_Border::BORDER_THIN,
                    'color' => array('rgb' => 'AAAAAA')
                )
            )
        );
        //Cabecera
        $this->docexcel->createSheet();
        $this->docexcel->getActiveSheet()->setTitle('Movimientos');
        $this->docexcel->setActiveSheetIndex(0);
        //recuperar datos
        $gestion = $this->objParam->getParametro('gestion');
        $gestionSig =(int)($this->objParam->getParametro('gestion')) + 1;
        $this->docexcel->getActiveSheet()->setCellValue('A1','EMPRESA: ENDE TRANSMISION S.A.');
        $this->docexcel->getActiveSheet()->setCellValue('A2','GESTION: '.$gestion);
        $this->docexcel->getActiveSheet()->setCellValue('A4','REPORTE PRESUPUESTO CONTABLE CON SALDO QUE NO FIGURAN EN GESTION '.$gestionSig );
        $this->docexcel->getActiveSheet()->mergeCells('A4:E4');
        $this->docexcel->getActiveSheet()->getStyle('A4:E4')->applyFromArray($titulossubcabezera);
        $this->docexcel->getActiveSheet()->setCellValue('A5','(TODAS LAS MONEDAS)'); //#9
        $this->docexcel->getActiveSheet()->mergeCells('A5:E5');
        $this->docexcel->getActiveSheet()->getStyle('A5:E5')->applyFromArray($titulossubcabezera);
        $this->docexcel->getActiveSheet()->getColumnDimension('A')->setWidth(12);
        $this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(80);//#9
        $this->docexcel->getActiveSheet()->getColumnDimension('C')->setWidth(15);//#9
        $this->docexcel->getActiveSheet()->getColumnDimension('D')->setWidth(15);//#9
        $this->docexcel->getActiveSheet()->getColumnDimension('E')->setWidth(15);//#9
        //*************************************Cabecera*****************************************
        $this->docexcel->getActiveSheet()->setCellValue('A7','CODIGO');//#9
        $this->docexcel->getActiveSheet()->setCellValue('B7','NOMBRE');//#9
        $this->docexcel->getActiveSheet()->setCellValue('C7','SALDO MB');//#9
        $this->docexcel->getActiveSheet()->setCellValue('D7','SALDO MT');//#9
        $this->docexcel->getActiveSheet()->setCellValue('E7','SALDO MA');//#9
        $this->docexcel->getActiveSheet()->getStyle('A7:E7')->getAlignment()->setWrapText(true);
        $this->docexcel->getActiveSheet()->getStyle('A7:E7')->applyFromArray($styleTitulos3);

    }

    function generarDatos(){
        $border = array(
            'borders' => array(
                'vertical' => array(
                    'style' => PHPExcel_Style_Border::BORDER_THIN
                )
            )
        );
        $centraar= array(
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER
            )
        );
        $this->imprimeCabecera();
        $datos = $this->objParam->getParametro('datos');
        $fila = 8;
        $cat= '';//#9
        foreach ($datos as $value){
            if ($value['nro_cuenta'] != $cat) {//#9
                $this->imprimeSubtitulo($fila,$value['nombre_cuenta'].' ('.$value['nro_cuenta'].')');//#9
                $cat = $value['nro_cuenta'];//#9
                $fila++;//#9
            }//#9
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, $value['codigo_tcc']);//#9
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila, $value['descripcion_tcc']);//#9
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila, $value['saldo_mb']);//#9
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila, $value['saldo_mt']);//#9
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4, $fila, $value['saldo_ma']);//#9
            $this->docexcel->getActiveSheet()->getStyle("C$fila:E$fila")->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat::FORMAT_NUMBER_COMMA_SEPARATED1);
            $this->docexcel->getActiveSheet()->getStyle("A$fila:F$fila")->applyFromArray($border);
            $this->docexcel->getActiveSheet()->getStyle("A$fila:A$fila")->applyFromArray($centraar);
            $fila ++;
        }

    }

    //#9
    function imprimeSubtitulo($fila, $valor) {
        $styleTitulos = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 10,
                'name'  => 'Arial'
            ),
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER
            ),
            'fill' => array(
                'type' => PHPExcel_Style_Fill::FILL_SOLID,
                'color' => array(
                    'rgb' => '33FFE6'
                )
            ));
        $border = array(
            'borders' => array(
                'vertical' => array(
                    'style' => PHPExcel_Style_Border::BORDER_THIN
                )
            )
        );
        $this->docexcel->getActiveSheet()->getStyle("A$fila:E$fila")->applyFromArray($styleTitulos);
        $this->docexcel->getActiveSheet()->mergeCells("A$fila:E$fila");
        $this->docexcel->getActiveSheet()->getStyle("A$fila:F$fila")->applyFromArray($border);
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, $valor);

    }
    //#9
    function generarReporte(){
        $this->objWriter = PHPExcel_IOFactory::createWriter($this->docexcel, 'Excel5');
        $this->objWriter->save($this->url_archivo);
    }

}
?>