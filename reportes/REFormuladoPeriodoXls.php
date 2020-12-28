<?php
/**
* HISTORIAL DE MODIFICACIONES:
   #ETR-1877          22/12/2020      JJA         Reporte memoria de calculo
 */
class REFormuladoPeriodoXls
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


        $this->docexcel->getActiveSheet()->setTitle('Formulación Presupuestaria');
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

        $this->docexcel->getActiveSheet()->getStyle('A2:O3')->applyFromArray($this->styleTitulos1);
        $this->docexcel->getActiveSheet()->mergeCells('A2:O2');

        $this->docexcel->getActiveSheet()->getStyle('A3:O3')->applyFromArray($this->styleTitulosFecha);
        $this->docexcel->getActiveSheet()->mergeCells('A3:O3');
        $this->docexcel->getActiveSheet()->getStyle('A4:O4')->applyFromArray($this->styleTitulosFecha);
        $this->docexcel->getActiveSheet()->mergeCells('A4:O4');    
        $this->docexcel->getActiveSheet()->getStyle('A5:O5')->applyFromArray($this->styleTitulosFecha);
        $this->docexcel->getActiveSheet()->mergeCells('A5:O5');

        $this->docexcel->getActiveSheet()->getStyle('A6:A8')->applyFromArray($this->styleTextoDerecho);

        $this->docexcel->getActiveSheet()->getColumnDimension('A')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(55);
        $this->docexcel->getActiveSheet()->getColumnDimension('C')->setWidth(10);
        /* INCREMENTAMOS VALORES DESDE SEPTIEMBRE HASTA FORMULADO
        */
        $this->docexcel->getActiveSheet()->getColumnDimension('K')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('L')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('M')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('N')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('O')->setWidth(15);

        $this->docexcel->getActiveSheet()->getStyle('A10:O10')->getAlignment()->setWrapText(true);
        $this->docexcel->getActiveSheet()->getStyle('A10:O10')->applyFromArray($this->styleTitulos2);


        //*************************************Cabecera*****************************************
        $this->docexcel->getActiveSheet()->setCellValue('A10','Nº');
        $this->docexcel->getActiveSheet()->setCellValue('B10','PARTIDA PRESUPUESTARÍA');

        $this->docexcel->getActiveSheet()->setCellValue('C10','ENERO');
        $this->docexcel->getActiveSheet()->setCellValue('D10','FEBRERO');
        $this->docexcel->getActiveSheet()->setCellValue('E10','MARZO');
        $this->docexcel->getActiveSheet()->setCellValue('F10','ABRIL');
        $this->docexcel->getActiveSheet()->setCellValue('G10','MAYO');
        $this->docexcel->getActiveSheet()->setCellValue('H10','JUNIO');
        $this->docexcel->getActiveSheet()->setCellValue('I10','JULIO');
        $this->docexcel->getActiveSheet()->setCellValue('J10','AGOSTO');

        $this->docexcel->getActiveSheet()->setCellValue('K10','SEPTIEMBRE');
        $this->docexcel->getActiveSheet()->setCellValue('L10','OCTUBRE');
        $this->docexcel->getActiveSheet()->setCellValue('M10','NOVIEMBRE');
        $this->docexcel->getActiveSheet()->setCellValue('N10','DICIEMBRE');

        $this->docexcel->getActiveSheet()->setCellValue('O10','FORMULADO');
    }
    function generarCabeceraDetalle(){
        if($this->objParam->getParametro('tipo_formulacion')=="ratp"){//ante proyecto
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
        elseif($this->objParam->getParametro('tipo_formulacion')=="ra"){//ante proyecto
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
        elseif($this->objParam->getParametro('tipo_formulacion')=="rv"){//ante proyecto
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

        $this->docexcel->getActiveSheet()->getStyle('A2:P3')->applyFromArray($this->styleTitulos1);
        $this->docexcel->getActiveSheet()->mergeCells('A2:P2');

        $this->docexcel->getActiveSheet()->getStyle('A3:P3')->applyFromArray($this->styleTitulosFecha);
        $this->docexcel->getActiveSheet()->mergeCells('A3:P3');
        $this->docexcel->getActiveSheet()->getStyle('A4:P4')->applyFromArray($this->styleTitulosFecha);
        $this->docexcel->getActiveSheet()->mergeCells('A4:P4');    
        $this->docexcel->getActiveSheet()->getStyle('A5:P5')->applyFromArray($this->styleTitulosFecha);
        $this->docexcel->getActiveSheet()->mergeCells('A5:P5');

        $this->docexcel->getActiveSheet()->getStyle('A6:A8')->applyFromArray($this->styleTextoDerecho);

        $this->docexcel->getActiveSheet()->getColumnDimension('A')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(60);
        $this->docexcel->getActiveSheet()->getColumnDimension('C')->setWidth(60);
        $this->docexcel->getActiveSheet()->getColumnDimension('D')->setWidth(15);

        $this->docexcel->getActiveSheet()->getStyle('A10:D10')->getAlignment()->setWrapText(true);
        $this->docexcel->getActiveSheet()->getStyle('A10:D10')->applyFromArray($this->styleTitulos2);
  

        /*if($this->objParam->getParametro('fecha_ini')){ //#410
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,3,'Desde '.$this->objParam->getParametro('fecha_ini').' Hasta '.$this->objParam->getParametro('fecha_fin') );
        }*/
        /*else{
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,3,'id_gestion '.$this->objParam->getParametro('id_gestion') ); //#410
        }*/


        $this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(50);
        $this->docexcel->getActiveSheet()->getColumnDimension('C')->setWidth(60);
        $this->docexcel->getActiveSheet()->getColumnDimension('D')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('E')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('F')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('G')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('H')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('I')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('J')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('K')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('L')->setWidth(15); //#40
        $this->docexcel->getActiveSheet()->getColumnDimension('M')->setWidth(15); //#45
        
        $this->docexcel->getActiveSheet()->getColumnDimension('N')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('O')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('P')->setWidth(15);
        // $this->docexcel->getActiveSheet()->getColumnDimension('Q')->setWidth(30);
        // $this->docexcel->getActiveSheet()->getColumnDimension('R')->setWidth(30);
        // $this->docexcel->getActiveSheet()->getColumnDimension('S')->setWidth(30);



        $this->docexcel->getActiveSheet()->getStyle('A10:P10')->getAlignment()->setWrapText(true);
        $this->docexcel->getActiveSheet()->getStyle('A10:P10')->applyFromArray($this->styleTitulos2);



        //*************************************Cabecera*****************************************
        $this->docexcel->getActiveSheet()->setCellValue('A10','Nº');
        $this->docexcel->getActiveSheet()->setCellValue('B10','PARTIDA PRESUPUESTARÍA');
        $this->docexcel->getActiveSheet()->setCellValue('C10','DESCRIPCIÓN');

        $this->docexcel->getActiveSheet()->setCellValue('D10','ENERO');
        $this->docexcel->getActiveSheet()->setCellValue('E10','FEBRERO');
        $this->docexcel->getActiveSheet()->setCellValue('F10','MARZO');
        $this->docexcel->getActiveSheet()->setCellValue('G10','ABRIL');
        $this->docexcel->getActiveSheet()->setCellValue('H10','MAYO');
        $this->docexcel->getActiveSheet()->setCellValue('I10','JUNIO');
        $this->docexcel->getActiveSheet()->setCellValue('J10','JULIO');
        $this->docexcel->getActiveSheet()->setCellValue('K10','AGOSTO');

        $this->docexcel->getActiveSheet()->setCellValue('L10','SEPTIEMBRE');
        $this->docexcel->getActiveSheet()->setCellValue('M10','OCTUBRE');
        $this->docexcel->getActiveSheet()->setCellValue('N10','NOVIEMBRE');
        $this->docexcel->getActiveSheet()->setCellValue('O10','DICIEMBRE');

        $this->docexcel->getActiveSheet()->setCellValue('P10','FORMULADO');
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

            $enero=0.0;
            $febrero=0.0;
            $marzo=0.0;
            $abril=0.0;
            $mayo=0.0;
            $junio=0.0;
            $julio=0.0;
            $agosto=0.0;
            $septiembre=0.0;
            $octubre=0.0;
            $noviembre=0.0;
            $diciembre=0.0;
            $formulado=0.0;
            foreach ($datos as $value){
             
                 if($value['sw_transaccional']=='titular'){
                    $this->docexcel->getActiveSheet()->getStyle("A$fila:O$fila")->applyFromArray($estilo_titular);
                   
                  

                    $enero +=(float)$value['enero'];
                    $febrero +=(float)$value['febrero'];
                    $marzo +=(float)$value['marzo'];
                    $abril +=(float)$value['abril'];
                    $mayo +=(float)$value['mayo'];
                    $junio +=(float)$value['junio'];
                    $julio +=(float)$value['julio'];
                    $agosto +=(float)$value['agosto'];
                    $septiembre  +=(float)$value['septiembre'];
                    $octubre +=(float)$value['octubre'];
                    $noviembre +=(float)$value['noviembre'];
                    $diciembre +=(float)$value['diciembre'];
                    $formulado +=(float)$value['formulado'];
                 }else{
                    $this->docexcel->getActiveSheet()->getStyle("A$fila:O$fila")->applyFromArray($estilo_contenido);
                 }

                $this->docexcel->getActiveSheet()->getStyle("H$fila:O$fila")->applyFromArray($estilo_contenido);

                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, $this->numero);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila, $value['nivel'].$value['partida']);
                //$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila, $value['obs']);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila, number_format($value['enero'],2,",","."));
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila, number_format($value['febrero'],2,",","."));
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4, $fila, number_format($value['marzo'],2,",","."));
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5, $fila, number_format($value['abril'],2,",","."));
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6, $fila, number_format($value['mayo'],2,",","."));
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(7, $fila, number_format($value['junio'],2,",","."));
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(8, $fila, number_format($value['julio'],2,",","."));
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(9, $fila, number_format($value['agosto'],2,",","."));
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(10, $fila, number_format($value['septiembre'],2,",",".")
                );
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(11, $fila, number_format($value['octubre'],2,",","."));
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(12, $fila, number_format($value['noviembre'],2,",","."));
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(13, $fila, number_format($value['diciembre'],2,",","."));
                   $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(14, $fila, number_format($value['formulado'],2,",","."));

                $fila++;
                $this->numero++;   
                
            }

            $this->docexcel->getActiveSheet()->getStyle("A$fila:O$fila")->applyFromArray($this->styleTitulos2);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, '');
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila, 'TOTAL GENERAL');
            //$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila, '');
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila, number_format($enero,2,",","."));
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila, number_format($febrero,2,",","."));
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4, $fila, number_format($marzo,2,",","."));
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5, $fila, number_format($abril,2,",","."));
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6, $fila, number_format($mayo,2,",","."));
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(7, $fila, number_format($junio,2,",","."));
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(8, $fila, number_format($julio,2,",","."));
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(9, $fila, number_format($agosto,2,",","."));
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(10, $fila, number_format($septiembre,2,",","."));
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(11, $fila, number_format($octubre,2,",","."));
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(12, $fila, number_format($noviembre,2,",","."));
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(13, $fila, number_format($diciembre,2,",","."));
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(14, $fila, number_format($formulado,2,",","."));

        }
        else{
            $total=0;
            $ejecutado=0.0;
            $formulado=0.0;
            $comprometido=0.0;

            $enero=0.0;
            $febrero=0.0;
            $marzo=0.0;
            $abril=0.0;
            $mayo=0.0;
            $junio=0.0;
            $julio=0.0;
            $agosto=0.0;
            $septiembre=0.0;
            $octubre=0.0;
            $noviembre=0.0;
            $diciembre=0.0;
            $formulado=0.0;
            foreach ($datos as $value){
             
                 if($value['sw_transaccional']=='titular'){
                    $this->docexcel->getActiveSheet()->getStyle("A$fila:P$fila")->applyFromArray($estilo_titular);
                   
                  

                    $enero +=(float)$value['enero'];
                    $febrero +=(float)$value['febrero'];
                    $marzo +=(float)$value['marzo'];
                    $abril +=(float)$value['abril'];
                    $mayo +=(float)$value['mayo'];
                    $junio +=(float)$value['junio'];
                    $julio +=(float)$value['julio'];
                    $agosto +=(float)$value['agosto'];
                    $septiembre  +=(float)$value['septiembre'];
                    $octubre +=(float)$value['octubre'];
                    $noviembre +=(float)$value['noviembre'];
                    $diciembre +=(float)$value['diciembre'];
                    $formulado +=(float)$value['formulado'];
                 }else{
                    $this->docexcel->getActiveSheet()->getStyle("A$fila:P$fila")->applyFromArray($estilo_contenido);
                 }

                $this->docexcel->getActiveSheet()->getStyle("H$fila:P$fila")->applyFromArray($estilo_contenido);

                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, $this->numero);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila, $value['nivel'].$value['partida']);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila, $value['obs']);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila, number_format($value['enero'],2,",","."));
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4, $fila, number_format($value['febrero'],2,",","."));
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5, $fila, number_format($value['marzo'],2,",","."));
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6, $fila, number_format($value['abril'],2,",","."));
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(7, $fila, number_format($value['mayo'],2,",","."));
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(8, $fila, number_format($value['junio'],2,",","."));
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(9, $fila, number_format($value['julio'],2,",","."));
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(10, $fila, number_format($value['agosto'],2,",","."));
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(11, $fila, number_format($value['septiembre'],2,",",".")
                );
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(12, $fila, number_format($value['octubre'],2,",","."));
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(13, $fila, number_format($value['noviembre'],2,",","."));
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(14, $fila, number_format($value['diciembre'],2,",","."));
                   $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(15, $fila, number_format($value['formulado'],2,",","."));

                $fila++;
                $this->numero++;   
                
            }

            $this->docexcel->getActiveSheet()->getStyle("A$fila:P$fila")->applyFromArray($this->styleTitulos2);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, '');
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila, 'TOTAL GENERAL');
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila, '');
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila, number_format($enero,2,",","."));
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4, $fila, number_format($febrero,2,",","."));
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5, $fila, number_format($marzo,2,",","."));
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6, $fila, number_format($abril,2,",","."));
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(7, $fila, number_format($mayo,2,",","."));
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(8, $fila, number_format($junio,2,",","."));
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(9, $fila, number_format($julio,2,",","."));
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(10, $fila, number_format($agosto,2,",","."));
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(11, $fila, number_format($septiembre,2,",","."));
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(12, $fila, number_format($octubre,2,",","."));
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(13, $fila, number_format($noviembre,2,",","."));
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(14, $fila, number_format($diciembre,2,",","."));
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(15, $fila, number_format($formulado,2,",","."));

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