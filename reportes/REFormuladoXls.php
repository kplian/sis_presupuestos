<?php
/**
* HISTORIAL DE MODIFICACIONES:
   #ETR-1877          22/12/2020      JJA         Reporte memoria de calculo
 */
class REFormuladoXls
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
    private $styleTextoDerecho=ARRAY();
    private $styleTitulos1=ARRAY();
    private $styleTitulosFecha=ARRAY();
    function __construct(CTParametro $objParam)
    {
        $this->styleTitulos2=ARRAY();
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
        $objDrawing->setHeight(55);
        $objDrawing->setWorksheet($this->docexcel->setActiveSheetIndex(0));

        //muestra el nombre la pestaña
       $this->docexcel->getActiveSheet()->setTitle('Formulación Presupuestarias');
       $this->docexcel->setActiveSheetIndex(0);
  

        $datos = $this->objParam->getParametro('datos');

        $this->styleTitulos1  = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 11,
                'name'  => 'Calibri'
            ),
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            ),
        );

        $this->styleTitulos2 = array(
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
        $this->styleTitulosFecha = array(
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

        $this->styleTextoDerecho = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 11,
                'name'  => 'Calibri',

            ),
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_LEFT,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            )
            );

        if($this->objParam->getParametro('tipo_reporte')=="agr"){
            $this->generarCabeceraAgrupado();
        }
        else{
            $this->generarCabeceraDetalle();
        }

    }
    function generarCabeceraDetalle(){

        if($this->objParam->getParametro('tipo_formulacion')=="ratp"){
           $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,2,'ANTEPROYECTO DE PRESUPUESTOS' );
           $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,3,$this->objParam->getParametro('ceco') );
           $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,4,'Gestión '.$this->objParam->getParametro('gestion') );         
           $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,5,'Valores en Bs.' );
           $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,6,'Formato:' );
           $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,7,'Tipo de Partida:' );
           $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,8,'Nivel:' );
           //if($this->objParam->getParametro('tipo_reporte')=="movimiento"){ 
           $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1,6,($this->objParam->getParametro('periodicidad')=="si")?'Mensual':'Anual');

           $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1,7,($this->objParam->getParametro('tipo_partida')=="tpg")?'Gasto':'Recurso');
           $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1,8,($this->objParam->getParametro('tipo_reporte')=="agr")?'Agrupado':'Detallado' );
        }
        elseif($this->objParam->getParametro('tipo_formulacion')=="ra"){
           $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,2,'PRESUPUESTO APROBADO' );
           $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,3,$this->objParam->getParametro('ceco') );
           $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,4,'Gestión '.$this->objParam->getParametro('gestion') );         
           $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,5,'Valores en Bs.' );
           $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,6,'Formato:' );
           $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,7,'Tipo de Partida:' );
           $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,8,'Nivel:' );
           //if($this->objParam->getParametro('tipo_reporte')=="movimiento"){ 
           $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1,6,($this->objParam->getParametro('periodicidad')=="si")?'Mensual':'Anual');

           $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1,7,($this->objParam->getParametro('tipo_partida')=="tpg")?'Gasto':'Recurso');
           $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1,8,($this->objParam->getParametro('tipo_reporte')=="agr")?'Agrupado':'Detallado' );
        }
          elseif($this->objParam->getParametro('tipo_formulacion')=="rv"){
           $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,2,'PRESUPUESTO VIGENTE' );
           $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,3,$this->objParam->getParametro('ceco') );
           $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,4,'Gestión '.$this->objParam->getParametro('gestion') );         
           $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,5,'Valores en Bs.' );
           $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,6,'Formato:' );
           $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,7,'Tipo de Partida:' );
           $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,8,'Nivel:' );
           //if($this->objParam->getParametro('tipo_reporte')=="movimiento"){ 
           $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1,6,($this->objParam->getParametro('periodicidad')=="si")?'Mensual':'Anual');

           $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1,7,($this->objParam->getParametro('tipo_partida')=="tpg")?'Gasto':'Recurso');
           $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1,8,($this->objParam->getParametro('tipo_reporte')=="agr")?'Agrupado':'Detallado' );
        }

        $this->docexcel->getActiveSheet()->getStyle('A2:D3')->applyFromArray($this->styleTitulos1);
        $this->docexcel->getActiveSheet()->mergeCells('A2:D2');

        $this->docexcel->getActiveSheet()->getStyle('A3:D3')->applyFromArray($this->styleTitulosFecha);
        $this->docexcel->getActiveSheet()->mergeCells('A3:D3');
        $this->docexcel->getActiveSheet()->getStyle('A4:D4')->applyFromArray($this->styleTitulosFecha);
        $this->docexcel->getActiveSheet()->mergeCells('A4:D4');    
        $this->docexcel->getActiveSheet()->getStyle('A5:D5')->applyFromArray($this->styleTitulosFecha);
        $this->docexcel->getActiveSheet()->mergeCells('A5:D5');

        $this->docexcel->getActiveSheet()->getStyle('A6:A8')->applyFromArray($this->styleTextoDerecho);

        $this->docexcel->getActiveSheet()->getColumnDimension('A')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(50);
        $this->docexcel->getActiveSheet()->getColumnDimension('C')->setWidth(60);
        $this->docexcel->getActiveSheet()->getColumnDimension('D')->setWidth(15);

        $this->docexcel->getActiveSheet()->getStyle('A10:D10')->getAlignment()->setWrapText(true);
        $this->docexcel->getActiveSheet()->getStyle('A10:D10')->applyFromArray($this->styleTitulos2);


        //*************************************Cabecera*****************************************
        $this->docexcel->getActiveSheet()->setCellValue('A10','Nº');
        $this->docexcel->getActiveSheet()->setCellValue('B10','PARTIDA PRESUPUESTARÍA');
        $this->docexcel->getActiveSheet()->setCellValue('C10','DESCRIPCIÓN');
        $this->docexcel->getActiveSheet()->setCellValue('D10','FORMULADO'); 
    }
    function generarCabeceraAgrupado(){

        if($this->objParam->getParametro('tipo_formulacion')=="ratp"){
           $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,2,'ANTEPROYECTO DE PRESUPUESTOS' );
           $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,3,$this->objParam->getParametro('ceco') );
           $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,4,'Gestión '.$this->objParam->getParametro('gestion') );         
           $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,5,'Valores en Bs.' );
           $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,6,'Formato:' );
           $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,7,'Tipo de Partida:' );
           $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,8,'Nivel:' );
           //if($this->objParam->getParametro('tipo_reporte')=="movimiento"){ 
           $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1,6,($this->objParam->getParametro('periodicidad')=="si")?'Mensual':'Anual');

           $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1,7,($this->objParam->getParametro('tipo_partida')=="tpg")?'Gasto':'Recurso');
           $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1,8,($this->objParam->getParametro('tipo_reporte')=="agr")?'Agrupado':'Detallado' );
        }
        elseif($this->objParam->getParametro('tipo_formulacion')=="ra"){
           $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,2,'PRESUPUESTO APROBADO' );
           $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,3,$this->objParam->getParametro('ceco') );
           $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,4,'Gestión '.$this->objParam->getParametro('gestion') );         
           $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,5,'Valores en Bs.' );
           $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,6,'Formato:' );
           $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,7,'Tipo de Partida:' );
           $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,8,'Nivel:' );
           //if($this->objParam->getParametro('tipo_reporte')=="movimiento"){ 
           $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1,6,($this->objParam->getParametro('periodicidad')=="si")?'Mensual':'Anual');

           $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1,7,($this->objParam->getParametro('tipo_partida')=="tpg")?'Gasto':'Recurso');
           $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1,8,($this->objParam->getParametro('tipo_reporte')=="agr")?'Agrupado':'Detallado' );
        }
          elseif($this->objParam->getParametro('tipo_formulacion')=="rv"){
           $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,2,'PRESUPUESTO VIGENTE' );
           $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,3,$this->objParam->getParametro('ceco') );
           $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,4,'Gestión '.$this->objParam->getParametro('gestion') );         
           $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,5,'Valores en Bs.' );
           $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,6,'Formato:' );
           $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,7,'Tipo de Partida:' );
           $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,8,'Nivel:' );
           //if($this->objParam->getParametro('tipo_reporte')=="movimiento"){ 
           $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1,6,($this->objParam->getParametro('periodicidad')=="si")?'Mensual':'Anual');

           $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1,7,($this->objParam->getParametro('tipo_partida')=="tpg")?'Gasto':'Recurso');
           $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1,8,($this->objParam->getParametro('tipo_reporte')=="agr")?'Agrupado':'Detallado' );
        }

        $this->docexcel->getActiveSheet()->getStyle('A2:C3')->applyFromArray($this->styleTitulos1);
        $this->docexcel->getActiveSheet()->mergeCells('A2:C2');

        $this->docexcel->getActiveSheet()->getStyle('A3:C3')->applyFromArray($this->styleTitulosFecha);
        $this->docexcel->getActiveSheet()->mergeCells('A3:C3');
        $this->docexcel->getActiveSheet()->getStyle('A4:C4')->applyFromArray($this->styleTitulosFecha);
        $this->docexcel->getActiveSheet()->mergeCells('A4:C4');    
        $this->docexcel->getActiveSheet()->getStyle('A5:C5')->applyFromArray($this->styleTitulosFecha);
        $this->docexcel->getActiveSheet()->mergeCells('A5:C5');

        $this->docexcel->getActiveSheet()->getStyle('A6:A8')->applyFromArray($this->styleTextoDerecho);

        $this->docexcel->getActiveSheet()->getColumnDimension('A')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(50);
        $this->docexcel->getActiveSheet()->getColumnDimension('C')->setWidth(60);

        $this->docexcel->getActiveSheet()->getStyle('A10:C10')->getAlignment()->setWrapText(true);
        $this->docexcel->getActiveSheet()->getStyle('A10:C10')->applyFromArray($this->styleTitulos2);


        //*************************************Cabecera*****************************************
        $this->docexcel->getActiveSheet()->setCellValue('A10','Nº');
        $this->docexcel->getActiveSheet()->setCellValue('B10','PARTIDA PRESUPUESTARÍA');
        $this->docexcel->getActiveSheet()->setCellValue('C10','FORMULADO');
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
        $fila = 11;
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


        if($this->objParam->getParametro('tipo_reporte')=="agr"){
            $total=0;
            $ejecutado=0.0;
            $formulado=0.0;
            $comprometido=0.0;

            $formulado=0.0;
            foreach ($datos as $value){
             
                if($value['sw_transaccional']=='titular'){
                    $this->docexcel->getActiveSheet()->getStyle("A$fila:C$fila")->applyFromArray($estilo_titular); 
                    $formulado +=(float)$value['formulado'];
                 }else{
                    $this->docexcel->getActiveSheet()->getStyle("A$fila:C$fila")->applyFromArray($estilo_contenido);
                 }

                $this->docexcel->getActiveSheet()->getStyle("H$fila:C$fila")->applyFromArray($estilo_contenido);

                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, $this->numero);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila, $value['nivel'].$value['partida']);
                //$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila, $value['obs']);
      
                
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila, number_format($value['formulado'],2,",","."));

                $fila++;
                $this->numero++;    
            }

            $this->docexcel->getActiveSheet()->getStyle("A$fila:C$fila")->applyFromArray($this->styleTitulos2);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, '');
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila, 'TOTAL GENERAL');
            //$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila, '');
            
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila, number_format($formulado,2,",","."));
        }else{
            $total=0;
            $ejecutado=0.0;
            $formulado=0.0;
            $comprometido=0.0;

            $formulado=0.0;
            foreach ($datos as $value){
             
                if($value['sw_transaccional']=='titular'){
                    $this->docexcel->getActiveSheet()->getStyle("A$fila:D$fila")->applyFromArray($estilo_titular); 
                    $formulado +=(float)$value['formulado'];
                 }else{
                    $this->docexcel->getActiveSheet()->getStyle("A$fila:D$fila")->applyFromArray($estilo_contenido);
                 }

                $this->docexcel->getActiveSheet()->getStyle("H$fila:D$fila")->applyFromArray($estilo_contenido);

                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, $this->numero);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila, $value['nivel'].$value['partida']);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila, $value['obs']);
      
                
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila, number_format($value['formulado'],2,",","."));

                $fila++;
                $this->numero++;    
            }

            $this->docexcel->getActiveSheet()->getStyle("A$fila:D$fila")->applyFromArray($this->styleTitulos2);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, '');
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila, 'TOTAL GENERAL');
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila, '');
            
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila, number_format($formulado,2,",","."));
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