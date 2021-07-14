<?php
/**
* HISTORIAL DE MODIFICACIONES:
   #ETR-1890          13/11/2020      JJA         Reporte partida ejecucion presupuestaria
    #ETR-4575           13/07/2021     JJA        Excluir partida del reporte ejecucion presupuestaria
 */
class REjecucionAgrupadoXls
{
    private $docexcel;
    private $objWriter;
    private $numero;
    private $equivalencias=array();
    private $objParam;
    public  $url_archivo;
    private $contador=0.0;
    private $acumulados2=0.0;
    private $styleTitulos2=ARRAY();
    function __construct(CTParametro $objParam)
    {
        $this->objParam = $objParam;
        $this->url_archivo = "../../../reportes_generados/".$this->objParam->getParametro('nombre_archivo');
        //ini_set('memory_limit','512M');
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


        $objDrawing = new PHPExcel_Worksheet_Drawing();
        $objDrawing->setName('Logo');
        $objDrawing->setDescription('Logo');
        $objDrawing->setPath(dirname(__FILE__).'/../../lib'.$_SESSION['_DIR_LOGO']);
        $objDrawing->setHeight(75);
        $objDrawing->setWorksheet($this->docexcel->setActiveSheetIndex(0));


        $this->docexcel->getActiveSheet()->setTitle('Ejecución presupuestaria');
        $this->docexcel->setActiveSheetIndex(0);

        $datos = $this->objParam->getParametro('datos');

        $styleTitulos1 = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 13,
                'name'  => 'Calibri'
            ),
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            ),
        );

        $this->$styleTitulos2 = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 11,
                'name'  => 'Calibri',
                'color' => array(
                    'rgb' => 'FFFFFF'
                )

            ),
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            ),
            'fill' => array(
                'type' => PHPExcel_Style_Fill::FILL_SOLID,
                'color' => array(
                    'rgb' => '366092'
                )
            ),
            'borders' => array(
                'allborders' => array(
                    'style' => PHPExcel_Style_Border::BORDER_THIN
                )
            ));
        $styleTitulosFecha = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 11,
                'name'  => 'Calibri',

            ),
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            )
            );

        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,2,'EJECUCIÓN PRESUPUESTARIA ' );
        $this->docexcel->getActiveSheet()->getStyle('A2:G2')->applyFromArray($styleTitulos1);//#40
        $this->docexcel->getActiveSheet()->mergeCells('A2:G2');//#40

        $this->docexcel->getActiveSheet()->getStyle('A3:G3')->applyFromArray($styleTitulosFecha);//#40
        $this->docexcel->getActiveSheet()->mergeCells('A3:G3');//#40

        /*if($this->objParam->getParametro('fecha_ini')){ //#45
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,3,'Desde '.$this->objParam->getParametro('fecha_ini').' Hasta '.$this->objParam->getParametro('fecha_fin') );
        }*/
        /*else{
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,3,'id_gestion '.$this->objParam->getParametro('id_gestion') ); //#45
        }*/


        $this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(50);
        $this->docexcel->getActiveSheet()->getColumnDimension('C')->setWidth(40);
        $this->docexcel->getActiveSheet()->getColumnDimension('D')->setWidth(30);
        $this->docexcel->getActiveSheet()->getColumnDimension('E')->setWidth(30);
        $this->docexcel->getActiveSheet()->getColumnDimension('F')->setWidth(30);
        $this->docexcel->getActiveSheet()->getColumnDimension('G')->setWidth(30);



        $this->docexcel->getActiveSheet()->getStyle('A5:G5')->getAlignment()->setWrapText(true);
        $this->docexcel->getActiveSheet()->getStyle('A5:G5')->applyFromArray($this->$styleTitulos2);



        //*************************************Cabecera*****************************************
        $this->docexcel->getActiveSheet()->setCellValue('A5','Nº');
        $this->docexcel->getActiveSheet()->setCellValue('B5','PARTIDA');
        $this->docexcel->getActiveSheet()->setCellValue('C5','FORMULADO');
        $this->docexcel->getActiveSheet()->setCellValue('D5','COMPROMETIDO');
        $this->docexcel->getActiveSheet()->setCellValue('E5','EJECUTADO');
        $this->docexcel->getActiveSheet()->setCellValue('F5','% EJECUTADO/FORMULADO');
        $this->docexcel->getActiveSheet()->setCellValue('G5','% EJECUTADO/COMPROMETIDO');

        /*$this->docexcel->getActiveSheet()->setCellValue('J5','SUBTOTAL C = A - B');
        if($datos[0]['gestion']<2017) {
            $this->docexcel->getActiveSheet()->setCellValue('K5', 'DESCUENTOS BONIFICACION ES Y REBAJAS OBTENIDAS D');
        }else{
            $this->docexcel->getActiveSheet()->setCellValue('K5', 'DESCUENTOS BONIFICACION ES Y REBAJAS SUJETAS AL IVA D');
        }
        $this->docexcel->getActiveSheet()->setCellValue('L5','MPORTE BASE PARA CREDITO FISCAL E = C-D');
        $this->docexcel->getActiveSheet()->setCellValue('M5','CREDITO FISCAL F = E*13%');
        $this->docexcel->getActiveSheet()->setCellValue('N5','CODIGO DE CONTROL');
        $this->docexcel->getActiveSheet()->setCellValue('O5','TIPO DE COMPRA');*/



    }
    function generarDatos()
    {

        $styleTitulos3 = array(
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            ),
        );

        $this->numero = 1;
        $fila = 6;
        $datos = $this->objParam->getParametro('datos');
        $this->imprimeCabecera(0);
        //var_dump($datos);exit;
        $acumulados=0.0;
        $bandera=0;
        $contador=0;
        //var_dump($datos[$fila-1]["sumar_partida"]);
     
        $estilo_titular = array(
         
            'font'  => array(
                'bold'  => true,
                'size'  => 11,
                'name'  => 'Calibri',
                'color' => array(
                    'rgb' => '060908'
                )
            ),

            'fill' => array(
            'type' => PHPExcel_Style_Fill::FILL_SOLID,
            'color' => array(
            'rgb' => 'DCE6F1'
            )
            ),
            'borders' => array(
                'allborders' => array(
                    'style' => PHPExcel_Style_Border::BORDER_THIN
                )
            )

        );
        $estilo_contenido = array( 
            'borders' => array(
                'allborders' => array(
                    'style' => PHPExcel_Style_Border::BORDER_THIN
                )
            )
        );

        $estilo_porcentaje = array( 
            'borders' => array(
                'allborders' => array(
                    'style' => PHPExcel_Style_Border::BORDER_THIN
                )
            )
        );

        $total=0;
        $ejecutado=0.0;
        $formulado=0.0;
        $comprometido=0.0;

        foreach ($datos as $value){
         
             if($value['sw_transaccional']=='titular'){
                $this->docexcel->getActiveSheet()->getStyle("A$fila:G$fila")->applyFromArray($estilo_titular);
                $ejecutado +=(float)$value['ejecutado'];
                $formulado +=(float)$value['formulado'];
                $comprometido +=(float)$value['comprometido'];
             }else{
                $this->docexcel->getActiveSheet()->getStyle("A$fila:G$fila")->applyFromArray($estilo_contenido);
             }

            $this->docexcel->getActiveSheet()->getStyle("H$fila:G$fila")->applyFromArray($estilo_contenido);

            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, $this->numero);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila, $value['nivel'].$value['partida']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila, number_format($value['formulado'],2,",","."));
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila, number_format($value['comprometido'],2,",","."));

            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4, $fila, number_format($value['ejecutado'],2,",","."));
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5, $fila,  number_format($value['porcentaje_eje_form'] * 100, 2, ",", ".")." %");
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6, $fila, number_format($value['porcentaje_eje_comp'] * 100, 2, ",", ".")." %");
            $fila++;
            $this->numero++;
            
        }


            $this->docexcel->getActiveSheet()->getStyle("A$fila:G$fila")->applyFromArray($this->$styleTitulos2);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, '');
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila, 'TOTAL GENERAL');
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila, number_format($formulado,2,",","."));
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila, number_format($comprometido,2,",","."));
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4, $fila, number_format($ejecutado,2,",","."));


        if($formulado<=0){//#ETR-4575
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5, $fila,  number_format(0,2,",",".")." %");
        }else{
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5, $fila,  number_format(($ejecutado/$formulado)*100,2,",",".")." %");
        }
        if($comprometido<=0){
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6, $fila, number_format(0,2,",",".")." %");

        }else{
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6, $fila, number_format(($ejecutado/$comprometido)*100,2,",",".")." %");
        }

         



    
    }
    function generarReporte(){

        //$this->docexcel->setActiveSheetIndex(0);
        $this->objWriter = PHPExcel_IOFactory::createWriter($this->docexcel, 'Excel5');
        $this->objWriter->save($this->url_archivo);
        $this->imprimeCabecera(0);

    }

}
?>