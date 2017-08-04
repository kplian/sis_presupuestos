<?php
class REjecucionGestionAnterior
{
    private $docexcel;
    private $objWriter;
    private $numero;
    private $equivalencias=array();
    private $objParam;
    public  $url_archivo;
    private $codigo= array();
    private $titulo= array();
    private $columna;
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
            76=>'BY',77=>'BZ',
            78=>'CA',79=>'CB',80=>'CC',81=>'CD',82=>'CE',83=>'CF',84=>'CG',85=>'CH',
            86=>'CI',87=>'CJ',88=>'CK',89=>'CL',90=>'CM',91=>'CN',92=>'CO',93=>'CP',
            94=>'CQ',95=>'CR',96=>'CS',97=>'CT',98=>'CU',99=>'CV',100=>'CW',101=>'CX',
            102=>'CY',103=>'CZ',
            104=>'DA',105=>'DB',106=>'DC',107=>'DD',108=>'DE',109=>'DF',110=>'DG',111=>'DH',
            112=>'DI',113=>'DJ',114=>'DK',115=>'DL',116=>'DM',117>'DN',118=>'DO',119=>'DP',
            120=>'DQ',121=>'DR',122=>'DS',123=>'DT',124=>'DU',125=>'DV',126=>'DW',127=>'DX',
            128=>'DY',129=>'DZ',

            130=>'EA',131=>'EB',132=>'EC',133=>'ED',134=>'EE',135=>'EF',136=>'EG',137=>'EH',
            138=>'EI',139=>'EJ',140=>'EK',141=>'EL',142=>'EM',143>'EN',144=>'EO',145=>'EP',
            146=>'EQ',147=>'ER',148=>'ES',149=>'ET',150=>'EU',151=>'EV',152=>'EW',153=>'EX',
            154=>'EY',155=>'EZ'

        );

    }
    function datosHeader ($detalle,$memoria,$total) {

        $this->datos_detalle = $detalle;
        $this->datos_memoria = $memoria;
        $this->total= $total;
    }
    function imprimeCabecera($shit,$tipo)
    {
        $this->docexcel->createSheet($shit);
        $this->docexcel->setActiveSheetIndex($shit);
        $this->docexcel->getActiveSheet()->setTitle($tipo);

        $styleTitulos1 = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 11,
                'name'  => 'Arial'
            ),
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_LEFT,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            ),
        );
        $styleTitulos2 = array(
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
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            ),
            'fill' => array(
                'type' => PHPExcel_Style_Fill::FILL_SOLID,
                'color' => array(
                    'rgb' => 'F50E0E'
                )
            ),
            'borders' => array(
                'allborders' => array(
                    'style' => PHPExcel_Style_Border::BORDER_THICK,

                ),
            )
        );
        $styleEjecuta= array(
            'font' => array(
                'bold' => true,
                'size' => 10,
                'name' => 'Arial',
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
                    'rgb' => '0D75CA'
                )
            ),
            'borders' => array(
                'allborders' => array(
                    'style' => PHPExcel_Style_Border::BORDER_THICK,

                ),
            )
        );
        $styleEjecucionProgramado= array(
            'font' => array(
                'bold' => true,
                'size' => 10,
                'name' => 'Arial',
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
                    'rgb' => 'FD8D0D'
                )
            ),
            'borders' => array(
                'allborders' => array(
                    'style' => PHPExcel_Style_Border::BORDER_THICK,

                ),
            )
        );


        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, 2,'"BOLIVIANA DE AVIACIÓN" - BoA');
        $this->docexcel->getActiveSheet()->getStyle('A2:BJ2')->applyFromArray($styleTitulos1);
        $this->docexcel->getActiveSheet()->mergeCells('A2:BJ2');
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, 3, $this->datos_detalle[0]['descripcion'].' - '.$this->datos_detalle[0]['gestion'] );
        $this->docexcel->getActiveSheet()->getStyle('A3:BJ3')->applyFromArray($styleTitulos1);
        $this->docexcel->getActiveSheet()->mergeCells('A3:BJ3');
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,4,'(Expresado en Bolivianos)');
        $this->docexcel->getActiveSheet()->getStyle('A4:BJ4')->applyFromArray($styleTitulos1);
        $this->docexcel->getActiveSheet()->mergeCells('A4:BJ4');


        $this->cabecera = array('PARTIDA','DESCRIPCION','PRESUPUESTO VIGENTE '.$this->datos_detalle[0]['gestion'],'EJECUTADO ENERO','EJECUTADO FEBRERO','EJECUTADO MARZO','EJECUTADO ABRIL',
            'EJECUTADO MAYO','EJECUTADO JUNIO','EJECUTADO JULIO','EJECUTADO AGOSTO','EJECUTADO SEPTIEMBRE','EJECUTADO OCTUBRE','EJECUTADO NOVIEMBRE','EJECUTADO DICIEMBRE',
            'EJECUCION PROGRAMADA PARA ENERO','EJECUCION PROGRAMADA PARA FEBRERO','EJECUCION PROGRAMADA PARA MARZO','EJECUCION PROGRAMADA PARA ABRIL','EJECUCION PROGRAMADA PARA MAYO',
            'EJECUCION PROGRAMADA PARA JUNIO','EJECUCION PROGRAMADA PARA JULIO','EJECUCION PROGRAMADA PARA AGOSTO','EJECUCION PROGRAMADA PARA SEPTIEMBRE','EJECUCION PROGRAMADA PARA OCTUBRE','EJECUCION PROGRAMADA PARA NOVIEMBRE','EJECUCION PROGRAMADA PARA DICIEMBRE'
        );


        $colum = 0;
        foreach ($this->cabecera as  $value)
        {
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($colum, 6, $value);
            $colum++;

        }
        if (date("m")>= '01' and '01' <= date("m")) {
            $this->docexcel->getActiveSheet()->getColumnDimension('D')->setVisible(1);

        }else{
            $this->docexcel->getActiveSheet()->getColumnDimension('D')->setVisible(0);
        }
        if (date("m")>= '02' and '02' <= date("m")) {
            $this->docexcel->getActiveSheet()->getColumnDimension('E')->setVisible(1);
        }else{
            $this->docexcel->getActiveSheet()->getColumnDimension('E')->setVisible(0);
        }
        if (date("m")>= '03' and '03' <= date("m")) {
            $this->docexcel->getActiveSheet()->getColumnDimension('F')->setVisible(1);
        }else{
            $this->docexcel->getActiveSheet()->getColumnDimension('F')->setVisible(0);
        }
        if (date("m")>= '04' and '04' <= date("m")) {
            $this->docexcel->getActiveSheet()->getColumnDimension('G')->setVisible(1);
        }else{
            $this->docexcel->getActiveSheet()->getColumnDimension('G')->setVisible(0);
        }
        if (date("m")>= '05' and '05' <= date("m")) {
            $this->docexcel->getActiveSheet()->getColumnDimension('H')->setVisible(1);
        }else{
            $this->docexcel->getActiveSheet()->getColumnDimension('H')->setVisible(0);
        }
        if (date("m")>= '06' and '06' <= date("m")) {
            $this->docexcel->getActiveSheet()->getColumnDimension('I')->setVisible(1);
        }else{
            $this->docexcel->getActiveSheet()->getColumnDimension('I')->setVisible(0);
        }
        if (date("m")>= '07' and '07' <= date("m")) {
            $this->docexcel->getActiveSheet()->getColumnDimension('J')->setVisible(1);
        }else{
            $this->docexcel->getActiveSheet()->getColumnDimension('J')->setVisible(0);
        }
        if (date("m")>= '08' and '08' <= date("m")) {
            $this->docexcel->getActiveSheet()->getColumnDimension('K')->setVisible(1);
        }else{
            $this->docexcel->getActiveSheet()->getColumnDimension('K')->setVisible(0);

        }
        if (date("m")>= '09' and '09' <= date("m")) {
            $this->docexcel->getActiveSheet()->getColumnDimension('L')->setVisible(1);
        }else{
            $this->docexcel->getActiveSheet()->getColumnDimension('L')->setVisible(0);
        }
        if (date("m")>= '10' and '01' <= date("m")) {
            $this->docexcel->getActiveSheet()->getColumnDimension('M')->setVisible(1);
        }else{
            $this->docexcel->getActiveSheet()->getColumnDimension('M')->setVisible(0);
        }
        if (date("m")>= '11' and '11' <= date("m")) {
            $this->docexcel->getActiveSheet()->getColumnDimension('N')->setVisible(1);
        }else{
            $this->docexcel->getActiveSheet()->getColumnDimension('N')->setVisible(0);
        }
        if (date("m")>= '12' and '12' <= date("m")) {
            $this->docexcel->getActiveSheet()->getColumnDimension('O')->setVisible(1);
        }else{
            $this->docexcel->getActiveSheet()->getColumnDimension('O')->setVisible(0);
        }

        if (date("m")>= '01'){
            $this->docexcel->getActiveSheet()->getColumnDimension('P')->setVisible(0);
        }else{
            $this->docexcel->getActiveSheet()->getColumnDimension('P')->setVisible(1);
        }
        if (date("m")>= '02'){
            $this->docexcel->getActiveSheet()->getColumnDimension('Q')->setVisible(0);
        }else{
            $this->docexcel->getActiveSheet()->getColumnDimension('Q')->setVisible(1);
        }
        if (date("m")>= '03'){
            $this->docexcel->getActiveSheet()->getColumnDimension('R')->setVisible(0);
        }else{
            $this->docexcel->getActiveSheet()->getColumnDimension('R')->setVisible(1);
        }
        if (date("m")>= '04'){
            $this->docexcel->getActiveSheet()->getColumnDimension('S')->setVisible(0);
        }else{
            $this->docexcel->getActiveSheet()->getColumnDimension('S')->setVisible(1);
        }
        if (date("m")>= '05'){
            $this->docexcel->getActiveSheet()->getColumnDimension('T')->setVisible(0);
        }else{
            $this->docexcel->getActiveSheet()->getColumnDimension('T')->setVisible(1);
        }
        if (date("m")>= '06'){
            $this->docexcel->getActiveSheet()->getColumnDimension('U')->setVisible(0);
        }else{
            $this->docexcel->getActiveSheet()->getColumnDimension('U')->setVisible(1);
        }
        if (date("m")>= '07'){
            $this->docexcel->getActiveSheet()->getColumnDimension('V')->setVisible(0);

        }else{
            $this->docexcel->getActiveSheet()->getColumnDimension('V')->setVisible(1);
        }
        if (date("m")>= '08'){
            $this->docexcel->getActiveSheet()->getColumnDimension('W')->setVisible(0);
        }else{
            $this->docexcel->getActiveSheet()->getColumnDimension('W')->setVisible(1);
        }
        if (date("m")>= '09'){
            $this->docexcel->getActiveSheet()->getColumnDimension('X')->setVisible(0);
        }else{
            $this->docexcel->getActiveSheet()->getColumnDimension('X')->setVisible(1);
        }
        if (date("m")>= '10'){
            $this->docexcel->getActiveSheet()->getColumnDimension('Y')->setVisible(0);
        }else{
            $this->docexcel->getActiveSheet()->getColumnDimension('Y')->setVisible(1);
        }
        if (date("m")>= '11'){
            $this->docexcel->getActiveSheet()->getColumnDimension('Z')->setVisible(0);
        }else{
            $this->docexcel->getActiveSheet()->getColumnDimension('Z')->setVisible(1);
        }
        if (date("m")>= '12'){
            $this->docexcel->getActiveSheet()->getColumnDimension('AA')->setVisible(0);
        }else{
            $this->docexcel->getActiveSheet()->getColumnDimension('AA')->setVisible(1);
        }

        $this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(50);
        $this->docexcel->getActiveSheet()->getColumnDimension('C')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('D')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('E')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('F')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('G')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('H')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('I')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('J')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('K')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('L')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('M')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('N')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('O')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('P')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('Q')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('R')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('S')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('T')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('U')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('V')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('W')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('X')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('Y')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('Z')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('AA')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('AB')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('AC')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('AD')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('AE')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('AF')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('AG')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('AH')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('AI')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('AJ')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('AK')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('AL')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('AM')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('AN')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('AO')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('AP')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('AQ')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('AR')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('AS')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('AT')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('AU')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('AV')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('AW')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('AX')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('AY')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('AZ')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('A6:AZ6')->getAlignment()->setWrapText(true);


        $this->docexcel->getActiveSheet()->getStyle('A6:C6')->applyFromArray($styleTitulos2);
        $this->docexcel->getActiveSheet()->getStyle('D6:O6')->applyFromArray($styleEjecuta);
        $this->docexcel->getActiveSheet()->getStyle('P6:AA6')->applyFromArray($styleEjecucionProgramado);

        $this->docexcel->getActiveSheet(0)->freezePaneByColumnAndRow(2,7);// inmovilizar paneles

    }
    function generarDatos(){
        $styleBordes = array(
            'borders' => array(

                'outline' => array(
                    'style' => PHPExcel_Style_Border::BORDER_THICK,
                )
            )

        );
        $this->numero = 7;
        $datos = $this->datos_detalle;
        $titulo = $datos[0]['descripcion'];
        $this->titulo= [0,1,2];
        $sheet = 0;
        $this->codigo =['10000','20000','30000','40000','50000','60000','80000','90000'];
        $this->imprimeCabecera($sheet, $titulo );
        $fi = 7;
        foreach ($datos as $value) {
            if (in_array($value['nivel_partida'], $this->titulo)) {
                $this->imprimeTituloPartida( $this->numero, $value['nivel_partida']);
                $this->columna++;
                $this->columna = 1;
            }
            if (in_array($value['codigo_partida'], $this->codigo)) {
                $this->imprimeSubtitulo( $this->numero, $value['codigo_partida']);
                $this->columna++;
                $this->columna = 1;
            }

            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,  $this->numero, $value['codigo_partida']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1,  $this->numero, $value['nombre_partida']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2,  $this->numero, $value['total']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3,  $this->numero, $value['c1']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4,  $this->numero, $value['c2']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5,  $this->numero, $value['c3']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6,  $this->numero, $value['c4']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(7,  $this->numero, $value['c5']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(8,  $this->numero, $value['c6']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(9,  $this->numero, $value['c7']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(10,  $this->numero, $value['c8']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(11,  $this->numero, $value['c9']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(12,  $this->numero, $value['c10']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(13,  $this->numero, $value['c11']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(14,  $this->numero, $value['c12']);
            $this->numero++;
            $this->docexcel->getActiveSheet()->getStyle("C$fi:AA$this->numero")->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat :: FORMAT_NUMBER_COMMA_SEPARATED1);
        }


        $memoria = $this->total;
        $fill= 7;
        foreach ($memoria as $val) {
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(15,  $fill, $val['m1']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(16,  $fill, $val['m2']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(17,  $fill, $val['m3']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(18,  $fill, $val['m4']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(19,  $fill, $val['m5']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(20,  $fill, $val['m6']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(21,  $fill, $val['m7']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(22,  $fill, $val['m8']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(23,  $fill, $val['m9']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(24,  $fill, $val['m10']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(25,  $fill, $val['m11']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(26,  $fill, $val['m12']);
            $fill++;
        }
        $fi= 6;
        $this->docexcel->getActiveSheet()->getStyle("A$fi:B$fill")->applyFromArray($styleBordes);
        $this->docexcel->getActiveSheet()->getStyle("B$fi:C$fill")->applyFromArray($styleBordes);
        $this->docexcel->getActiveSheet()->getStyle("C$fi:D$fill")->applyFromArray($styleBordes);
        $this->docexcel->getActiveSheet()->getStyle("D$fi:E$fill")->applyFromArray($styleBordes);
        $this->docexcel->getActiveSheet()->getStyle("E$fi:F$fill")->applyFromArray($styleBordes);
        $this->docexcel->getActiveSheet()->getStyle("F$fi:G$fill")->applyFromArray($styleBordes);
        $this->docexcel->getActiveSheet()->getStyle("G$fi:H$fill")->applyFromArray($styleBordes);
        $this->docexcel->getActiveSheet()->getStyle("H$fi:I$fill")->applyFromArray($styleBordes);
        $this->docexcel->getActiveSheet()->getStyle("I$fi:J$fill")->applyFromArray($styleBordes);
        $this->docexcel->getActiveSheet()->getStyle("J$fi:K$fill")->applyFromArray($styleBordes);
        $this->docexcel->getActiveSheet()->getStyle("K$fi:L$fill")->applyFromArray($styleBordes);
        $this->docexcel->getActiveSheet()->getStyle("L$fi:M$fill")->applyFromArray($styleBordes);
        $this->docexcel->getActiveSheet()->getStyle("M$fi:N$fill")->applyFromArray($styleBordes);
        $this->docexcel->getActiveSheet()->getStyle("N$fi:O$fill")->applyFromArray($styleBordes);
        $this->docexcel->getActiveSheet()->getStyle("O$fi:P$fill")->applyFromArray($styleBordes);
        $this->docexcel->getActiveSheet()->getStyle("P$fi:Q$fill")->applyFromArray($styleBordes);
        $this->docexcel->getActiveSheet()->getStyle("Q$fi:R$fill")->applyFromArray($styleBordes);
        $this->docexcel->getActiveSheet()->getStyle("R$fi:S$fill")->applyFromArray($styleBordes);
        $this->docexcel->getActiveSheet()->getStyle("S$fi:T$fill")->applyFromArray($styleBordes);
        $this->docexcel->getActiveSheet()->getStyle("T$fi:U$fill")->applyFromArray($styleBordes);
        $this->docexcel->getActiveSheet()->getStyle("U$fi:V$fill")->applyFromArray($styleBordes);
        $this->docexcel->getActiveSheet()->getStyle("V$fi:W$fill")->applyFromArray($styleBordes);
        $this->docexcel->getActiveSheet()->getStyle("W$fi:X$fill")->applyFromArray($styleBordes);
        $this->docexcel->getActiveSheet()->getStyle("X$fi:Y$fill")->applyFromArray($styleBordes);
        $this->docexcel->getActiveSheet()->getStyle("Y$fi:Z$fill")->applyFromArray($styleBordes);
        $this->docexcel->getActiveSheet()->getStyle("Z$fi:AA$fill")->applyFromArray($styleBordes);




    }
    function imprimeTituloPartida($fila, $valor){
        $styleTitulos = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 12,
                'name'  => 'Calibri'
            )

        );
        $this->docexcel->getActiveSheet()->getStyle($this->equivalencias[0] . $fila . ":" . $this->equivalencias[26] . $fila)->applyFromArray($styleTitulos);
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, $valor);
    }
    function imprimeSubtitulo($fila, $valor){
        $styleTitulos = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 12,
                'name'  => 'Calibri'
            ),
            'fill' => array(
                'type' => PHPExcel_Style_Fill::FILL_SOLID,
                'color' => array(
                    'rgb' => '9BDCFA'
                )
            ),
        );
        $this->docexcel->getActiveSheet()->getStyle($this->equivalencias[0] . $fila . ":" . $this->equivalencias[26] . $fila)->applyFromArray($styleTitulos);
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, $valor);
    }

    function generarReporte(){
        $this->generarDatos();
        $this->docexcel->setActiveSheetIndex(0);
        $this->objWriter = PHPExcel_IOFactory::createWriter($this->docexcel, 'Excel5');
        $this->objWriter->save($this->url_archivo);


    }

}
?>