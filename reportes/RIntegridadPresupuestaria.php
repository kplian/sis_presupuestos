<?php
// Extend the TCPDF class to create custom MultiRow
class RIntegridadPresupuestaria{
    private $docexcel;
    private $objWriter;
    public $fila_aux = 0;
    private $equivalencias=array();
    private $objParam;
    public  $url_archivo;
    public $aux ;
    function __construct(CTParametro $objParam){
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

        $this->docexcel->createSheet();
        $this->docexcel->getActiveSheet()->setTitle('RIntegridad Presupuestaria');
        $this->docexcel->setActiveSheetIndex(0);


        $titulossubcabezera = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 9,
                'name'  => 'Arial'
            )
        );

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

        $datos = $this->objParam->getParametro('datos');
        $this->docexcel->getActiveSheet()->setCellValue('A1','EMPRESA: ENDE TRANSMISION S.A.');
        $this->docexcel->getActiveSheet()->setCellValue('A2','GESTION: '.$datos[0]['gestion']);
        $this->docexcel->getActiveSheet()->setCellValue('A4','INTEGRIDAD PRESUPUESTARIA');
        $this->docexcel->getActiveSheet()->setCellValue('A5','(EXPRESADO EN BOLIVIANOS)');

        $this->docexcel->getActiveSheet()->getStyle('A1:Q5')->applyFromArray($titulossubcabezera);
        $this->docexcel->getActiveSheet()->getColumnDimension('A')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(40);
        $this->docexcel->getActiveSheet()->getColumnDimension('C')->setWidth(25);
        $this->docexcel->getActiveSheet()->getColumnDimension('D')->setWidth(25);
        $this->docexcel->getActiveSheet()->getColumnDimension('E')->setWidth(25);
        $this->docexcel->getActiveSheet()->getColumnDimension('F')->setWidth(25);
        $this->docexcel->getActiveSheet()->getColumnDimension('F')->setWidth(25);
        $this->docexcel->getActiveSheet()->getColumnDimension('G')->setWidth(25);

        $this->docexcel->getActiveSheet()->setCellValue('A7','Codigo Techo');
        $this->docexcel->getActiveSheet()->setCellValue('B7','Descripcion Techo');
        $this->docexcel->getActiveSheet()->setCellValue('C7','Formulado');
        $this->docexcel->getActiveSheet()->setCellValue('D7','Compromotido');
        $this->docexcel->getActiveSheet()->setCellValue('E7','Saldo Por Comprometer');
        $this->docexcel->getActiveSheet()->setCellValue('F7','Total Ejecutado');
        $this->docexcel->getActiveSheet()->setCellValue('G7','Saldo Por Ejecutar');
        $this->docexcel->getActiveSheet()->getStyle('A7:G7')->getAlignment()->setWrapText(true);
        $this->docexcel->getActiveSheet()->getStyle('A7:G7')->applyFromArray($styleTitulos3);

    }
    function generarDatos(){
        $border = array(
            'borders' => array(
                'allborders' => array(
                    'style' => PHPExcel_Style_Border::BORDER_THIN
                )
            )
        );
        $total= array(
            'font'  => array(
                'bold'  => true,
                'size'  => 9,
                'name'  => 'Arial'
            ),
            'borders' => array(
                'allborders' => array(
                    'style' => PHPExcel_Style_Border::BORDER_THIN
                )
            )
        );
        $centar = array('alignment' => array(
            'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
            'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
        ),
            'borders' => array(
                'allborders' => array(
                    'style' => PHPExcel_Style_Border::BORDER_THIN
                )
            ));
        $this->imprimeCabecera();
        $fila = 8;
        $datos = $this->objParam->getParametro('datos');
        foreach ($datos as $value) {
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, $value['codigo_techo']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila, $value['descripcion_techo']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila, $value['total_formulado']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila, $value['total_comprometido']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4, $fila, $value['saldo_por_comprometer']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5, $fila, $value['total_ejecutado']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6, $fila, $value['saldo_por_ejecutar']);
            $this->docexcel->getActiveSheet()->getStyle("C$fila:G$fila")->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat::FORMAT_NUMBER_COMMA_SEPARATED1);
            $this->docexcel->getActiveSheet()->getStyle("A$fila:G$fila")->applyFromArray($border);
            $this->docexcel->getActiveSheet()->getStyle("A$fila:A$fila")->applyFromArray($centar);
            $fila ++;
            $this->fila_aux = $fila;
        }
        if($datos[0]['total_formulado'] !=0) {
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $this->fila_aux, '=SUM(C8:C' . ($this->fila_aux - 1) . ')');
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $this->fila_aux, '=SUM(D8:D' . ($this->fila_aux - 1) . ')');
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4, $this->fila_aux, '=SUM(E8:E' . ($this->fila_aux - 1) . ')');
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5, $this->fila_aux, '=SUM(F8:F' . ($this->fila_aux - 1) . ')');
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6, $this->fila_aux, '=SUM(G8:G' . ($this->fila_aux - 1) . ')');
            $this->docexcel->getActiveSheet()->getStyle("A$fila:G$fila")->applyFromArray($total);
            $this->docexcel->getActiveSheet()->getStyle("C$fila:G$fila")->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat::FORMAT_NUMBER_COMMA_SEPARATED1);
        }

    }

    function generarReporte(){
        $this->objWriter = PHPExcel_IOFactory::createWriter($this->docexcel, 'Excel5');
        $this->objWriter->save($this->url_archivo);

    }

}
?>

