<?php
class RPartidaEjecutadoXls
{
    private $docexcel;
    private $objWriter;
    private $equivalencias=array();
    private $objParam;
    private $columna;
    private  $cat ;
    private $codigo= array();
    private $titulo= array();
    private $sumaTotal = array();
    var $datos_detalle;
    var $datos_titulo;
    var $datos_total;
    private  $cabecera = array();

    public  $url_archivo;
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
    function datosHeader ( $detalle,$totales,$total,$institucional) {

        $this->datos_detalle = $detalle;
        $this->datos_titulo = $totales;
       $this->datos_total = $total;
        $this->datos_institucional = $institucional;
    }
    function imprimeCabecera($shit,$tipo) {
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




                $styleEjecutado = array(
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
                            'rgb' => '8F6D09'
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

        $styleEjecutado_Comprometido= array(
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
                    'rgb' => '04C91B'
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
        $stylePeriodo= array(
            'font' => array(
                'bold' => true,
                'size' => 10,
                'name' => 'Arial',


            ),
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            ),
            'fill' => array(
                'type' => PHPExcel_Style_Fill::FILL_SOLID,
                'color' => array(
                    'rgb' => 'F7DA4B'
                )
            ),
            'borders' => array(
                'allborders' => array(
                    'style' => PHPExcel_Style_Border::BORDER_THICK,

                ),
            )
        );
        $styleDiferenciaCom= array(
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
                    'rgb' => 'DE5C5C'
                )
            ),
            'borders' => array(
                'allborders' => array(
                    'style' => PHPExcel_Style_Border::BORDER_THICK,

                ),
            )
        );
        $styleDiferenciaEjec= array(
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
                    'rgb' => '9975CF'
                )
            ),
            'borders' => array(
                'allborders' => array(
                    'style' => PHPExcel_Style_Border::BORDER_THICK,

                ),
            )
        );
        $styleAcumuladoComp= array(
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
                    'rgb' => '61BED0'
                )
            ),
            'borders' => array(
                'allborders' => array(
                    'style' => PHPExcel_Style_Border::BORDER_THICK,

                ),
            )
        );
        $styleAcumuladoEjecu= array(
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
                    'rgb' => '9A9852'
                )
            ),
            'borders' => array(
                'allborders' => array(
                    'style' => PHPExcel_Style_Border::BORDER_THICK,

                ),
            )
        );
        $stylePorcentajeComp= array(
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
                    'rgb' => '709A52'
                )
            ),
            'borders' => array(
                'allborders' => array(
                    'style' => PHPExcel_Style_Border::BORDER_THICK,

                ),
            )
        );
        $stylePorcentajeEjecu= array(
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
                    'rgb' => 'CE843F'
                )
            ),
            'borders' => array(
                'allborders' => array(
                    'style' => PHPExcel_Style_Border::BORDER_THICK,

                ),
            )
        );


        $fecha_fin =explode("/",$this->objParam->getParametro('fecha_fin'));
        $fecha_ini =explode("/",$this->objParam->getParametro('fecha_ini'));

        if(($this->objParam->getParametro('tipo_movimiento')== 'todos')){

            foreach (range('G', 'O') as $colum) {

                if ($fecha_fin[1] >= 01 and $fecha_ini[1] <= 01) {
                    $this->docexcel->getActiveSheet()->getColumnDimension($colum)->setVisible(1);

                } else {
                    $this->docexcel->getActiveSheet()->getColumnDimension($colum)->setVisible(0);

                }
            }
        foreach (range('Q', 'Y') as $colum) {

            if ($fecha_fin[1] >= 02 and $fecha_ini[1] <= 02) {
                $this->docexcel->getActiveSheet()->getColumnDimension($colum)->setVisible(1);

            } else {
                $this->docexcel->getActiveSheet()->getColumnDimension($colum)->setVisible(0);

            }

        }

        if ($fecha_fin[1] >= 03 and $fecha_ini[1] <= 03) {
            $this->docexcel->getActiveSheet()->getColumnDimension('AA')->setVisible(1);
            $this->docexcel->getActiveSheet()->getColumnDimension('AB')->setVisible(1);
            $this->docexcel->getActiveSheet()->getColumnDimension('AC')->setVisible(1);
            $this->docexcel->getActiveSheet()->getColumnDimension('AD')->setVisible(1);
            $this->docexcel->getActiveSheet()->getColumnDimension('AF')->setVisible(1);
            $this->docexcel->getActiveSheet()->getColumnDimension('AE')->setVisible(1);
            $this->docexcel->getActiveSheet()->getColumnDimension('AG')->setVisible(1);
            $this->docexcel->getActiveSheet()->getColumnDimension('AH')->setVisible(1);
            $this->docexcel->getActiveSheet()->getColumnDimension('AI')->setVisible(1);
        } else {
            $this->docexcel->getActiveSheet()->getColumnDimension('AA')->setVisible(0);
            $this->docexcel->getActiveSheet()->getColumnDimension('AB')->setVisible(0);
            $this->docexcel->getActiveSheet()->getColumnDimension('AC')->setVisible(0);
            $this->docexcel->getActiveSheet()->getColumnDimension('AD')->setVisible(0);
            $this->docexcel->getActiveSheet()->getColumnDimension('AF')->setVisible(0);
            $this->docexcel->getActiveSheet()->getColumnDimension('AG')->setVisible(0);
            $this->docexcel->getActiveSheet()->getColumnDimension('AH')->setVisible(0);
            $this->docexcel->getActiveSheet()->getColumnDimension('AI')->setVisible(0);
            $this->docexcel->getActiveSheet()->getColumnDimension('AE')->setVisible(0);
        }


        if ($fecha_fin[1] >= 04 and $fecha_ini[1] <= 04) {
            $this->docexcel->getActiveSheet()->getColumnDimension('AK')->setVisible(1);
            $this->docexcel->getActiveSheet()->getColumnDimension('AL')->setVisible(1);
            $this->docexcel->getActiveSheet()->getColumnDimension('AM')->setVisible(1);
            $this->docexcel->getActiveSheet()->getColumnDimension('AN')->setVisible(1);
            $this->docexcel->getActiveSheet()->getColumnDimension('AO')->setVisible(1);
            $this->docexcel->getActiveSheet()->getColumnDimension('AP')->setVisible(1);
            $this->docexcel->getActiveSheet()->getColumnDimension('AQ')->setVisible(1);
            $this->docexcel->getActiveSheet()->getColumnDimension('AR')->setVisible(1);
            $this->docexcel->getActiveSheet()->getColumnDimension('AS')->setVisible(1);

        } else {
            $this->docexcel->getActiveSheet()->getColumnDimension('AK')->setVisible(0);
            $this->docexcel->getActiveSheet()->getColumnDimension('AL')->setVisible(0);
            $this->docexcel->getActiveSheet()->getColumnDimension('AM')->setVisible(0);
            $this->docexcel->getActiveSheet()->getColumnDimension('AO')->setVisible(0);
            $this->docexcel->getActiveSheet()->getColumnDimension('AN')->setVisible(0);
            $this->docexcel->getActiveSheet()->getColumnDimension('AP')->setVisible(0);
            $this->docexcel->getActiveSheet()->getColumnDimension('AQ')->setVisible(0);
            $this->docexcel->getActiveSheet()->getColumnDimension('AR')->setVisible(0);
            $this->docexcel->getActiveSheet()->getColumnDimension('AS')->setVisible(0);

        }
        if ($fecha_fin[1] >= 05 and $fecha_ini[1] <= 05) {
            $this->docexcel->getActiveSheet()->getColumnDimension('AU')->setVisible(1);
            $this->docexcel->getActiveSheet()->getColumnDimension('AV')->setVisible(1);
            $this->docexcel->getActiveSheet()->getColumnDimension('AW')->setVisible(1);
            $this->docexcel->getActiveSheet()->getColumnDimension('AX')->setVisible(1);
            $this->docexcel->getActiveSheet()->getColumnDimension('AY')->setVisible(1);
            $this->docexcel->getActiveSheet()->getColumnDimension('AZ')->setVisible(1);
            $this->docexcel->getActiveSheet()->getColumnDimension('BA')->setVisible(1);
            $this->docexcel->getActiveSheet()->getColumnDimension('BB')->setVisible(1);
            $this->docexcel->getActiveSheet()->getColumnDimension('BC')->setVisible(1);


        } else {
            $this->docexcel->getActiveSheet()->getColumnDimension('AU')->setVisible(0);
            $this->docexcel->getActiveSheet()->getColumnDimension('AV')->setVisible(0);
            $this->docexcel->getActiveSheet()->getColumnDimension('AW')->setVisible(0);
            $this->docexcel->getActiveSheet()->getColumnDimension('AX')->setVisible(0);
            $this->docexcel->getActiveSheet()->getColumnDimension('AY')->setVisible(0);
            $this->docexcel->getActiveSheet()->getColumnDimension('AZ')->setVisible(0);
            $this->docexcel->getActiveSheet()->getColumnDimension('BA')->setVisible(0);
            $this->docexcel->getActiveSheet()->getColumnDimension('BB')->setVisible(0);
            $this->docexcel->getActiveSheet()->getColumnDimension('BC')->setVisible(0);

        }

        if ($fecha_fin[1] >= 06 and $fecha_ini[1] <= 06) {
            $this->docexcel->getActiveSheet()->getColumnDimension('BE')->setVisible(1);
            $this->docexcel->getActiveSheet()->getColumnDimension('BF')->setVisible(1);
            $this->docexcel->getActiveSheet()->getColumnDimension('BG')->setVisible(1);
            $this->docexcel->getActiveSheet()->getColumnDimension('BH')->setVisible(1);
            $this->docexcel->getActiveSheet()->getColumnDimension('BI')->setVisible(1);
            $this->docexcel->getActiveSheet()->getColumnDimension('BJ')->setVisible(1);
            $this->docexcel->getActiveSheet()->getColumnDimension('BL')->setVisible(1);
            $this->docexcel->getActiveSheet()->getColumnDimension('BK')->setVisible(1);
            $this->docexcel->getActiveSheet()->getColumnDimension('BL')->setVisible(1);
            $this->docexcel->getActiveSheet()->getColumnDimension('BM')->setVisible(1);

        } else {
            $this->docexcel->getActiveSheet()->getColumnDimension('BE')->setVisible(0);
            $this->docexcel->getActiveSheet()->getColumnDimension('BF')->setVisible(0);
            $this->docexcel->getActiveSheet()->getColumnDimension('BG')->setVisible(0);
            $this->docexcel->getActiveSheet()->getColumnDimension('BH')->setVisible(0);
            $this->docexcel->getActiveSheet()->getColumnDimension('BI')->setVisible(0);
            $this->docexcel->getActiveSheet()->getColumnDimension('BJ')->setVisible(0);
            $this->docexcel->getActiveSheet()->getColumnDimension('BL')->setVisible(0);
            $this->docexcel->getActiveSheet()->getColumnDimension('BK')->setVisible(0);
            $this->docexcel->getActiveSheet()->getColumnDimension('BL')->setVisible(0);
            $this->docexcel->getActiveSheet()->getColumnDimension('BM')->setVisible(0);
        }
        if ($fecha_fin[1] >= 07 and $fecha_ini[1] <= 07) {
            $this->docexcel->getActiveSheet()->getColumnDimension('BO')->setVisible(1);
            $this->docexcel->getActiveSheet()->getColumnDimension('BP')->setVisible(1);
            $this->docexcel->getActiveSheet()->getColumnDimension('BQ')->setVisible(1);
            $this->docexcel->getActiveSheet()->getColumnDimension('BR')->setVisible(1);
            $this->docexcel->getActiveSheet()->getColumnDimension('BS')->setVisible(1);
            $this->docexcel->getActiveSheet()->getColumnDimension('BT')->setVisible(1);
            $this->docexcel->getActiveSheet()->getColumnDimension('BU')->setVisible(1);
            $this->docexcel->getActiveSheet()->getColumnDimension('BV')->setVisible(1);
            $this->docexcel->getActiveSheet()->getColumnDimension('BW')->setVisible(1);

        } else {
            $this->docexcel->getActiveSheet()->getColumnDimension('BO')->setVisible(0);
            $this->docexcel->getActiveSheet()->getColumnDimension('BP')->setVisible(0);
            $this->docexcel->getActiveSheet()->getColumnDimension('BQ')->setVisible(0);
            $this->docexcel->getActiveSheet()->getColumnDimension('BR')->setVisible(0);
            $this->docexcel->getActiveSheet()->getColumnDimension('BS')->setVisible(0);
            $this->docexcel->getActiveSheet()->getColumnDimension('BT')->setVisible(0);
            $this->docexcel->getActiveSheet()->getColumnDimension('BU')->setVisible(0);
            $this->docexcel->getActiveSheet()->getColumnDimension('BV')->setVisible(0);
            $this->docexcel->getActiveSheet()->getColumnDimension('BW')->setVisible(0);
        }
        if ($fecha_fin[1] >= '08' and $fecha_ini[1] <= '08') {
            $this->docexcel->getActiveSheet()->getColumnDimension('BY')->setVisible(1);
            $this->docexcel->getActiveSheet()->getColumnDimension('BZ')->setVisible(1);
            $this->docexcel->getActiveSheet()->getColumnDimension('CA')->setVisible(1);
            $this->docexcel->getActiveSheet()->getColumnDimension('CB')->setVisible(1);
            $this->docexcel->getActiveSheet()->getColumnDimension('CC')->setVisible(1);
            $this->docexcel->getActiveSheet()->getColumnDimension('CD')->setVisible(1);
            $this->docexcel->getActiveSheet()->getColumnDimension('CE')->setVisible(1);
            $this->docexcel->getActiveSheet()->getColumnDimension('CF')->setVisible(1);
            $this->docexcel->getActiveSheet()->getColumnDimension('CG')->setVisible(1);

        } else {
            $this->docexcel->getActiveSheet()->getColumnDimension('BY')->setVisible(0);
            $this->docexcel->getActiveSheet()->getColumnDimension('BZ')->setVisible(0);
            $this->docexcel->getActiveSheet()->getColumnDimension('CA')->setVisible(0);
            $this->docexcel->getActiveSheet()->getColumnDimension('CB')->setVisible(0);
            $this->docexcel->getActiveSheet()->getColumnDimension('CC')->setVisible(0);
            $this->docexcel->getActiveSheet()->getColumnDimension('CD')->setVisible(0);
            $this->docexcel->getActiveSheet()->getColumnDimension('CE')->setVisible(0);
            $this->docexcel->getActiveSheet()->getColumnDimension('CF')->setVisible(0);
            $this->docexcel->getActiveSheet()->getColumnDimension('CG')->setVisible(0);
        }
        if ($fecha_fin[1] >= '09' and $fecha_ini[1] <= '09') {
            $this->docexcel->getActiveSheet()->getColumnDimension('CI')->setVisible(1);
            $this->docexcel->getActiveSheet()->getColumnDimension('CJ')->setVisible(1);
            $this->docexcel->getActiveSheet()->getColumnDimension('CK')->setVisible(1);
            $this->docexcel->getActiveSheet()->getColumnDimension('CL')->setVisible(1);
            $this->docexcel->getActiveSheet()->getColumnDimension('CM')->setVisible(1);
            $this->docexcel->getActiveSheet()->getColumnDimension('CN')->setVisible(1);
            $this->docexcel->getActiveSheet()->getColumnDimension('CO')->setVisible(1);
            $this->docexcel->getActiveSheet()->getColumnDimension('CP')->setVisible(1);
            $this->docexcel->getActiveSheet()->getColumnDimension('CQ')->setVisible(1);

        } else {
            $this->docexcel->getActiveSheet()->getColumnDimension('CI')->setVisible(0);
            $this->docexcel->getActiveSheet()->getColumnDimension('CJ')->setVisible(0);
            $this->docexcel->getActiveSheet()->getColumnDimension('CK')->setVisible(0);
            $this->docexcel->getActiveSheet()->getColumnDimension('CL')->setVisible(0);
            $this->docexcel->getActiveSheet()->getColumnDimension('CM')->setVisible(0);
            $this->docexcel->getActiveSheet()->getColumnDimension('CN')->setVisible(0);
            $this->docexcel->getActiveSheet()->getColumnDimension('CO')->setVisible(0);
            $this->docexcel->getActiveSheet()->getColumnDimension('CP')->setVisible(0);
            $this->docexcel->getActiveSheet()->getColumnDimension('CQ')->setVisible(0);
        }
        if ($fecha_fin[1] >= 10 and $fecha_ini[1] <= 10) {
            $this->docexcel->getActiveSheet()->getColumnDimension('CS')->setVisible(1);
            $this->docexcel->getActiveSheet()->getColumnDimension('CT')->setVisible(1);
            $this->docexcel->getActiveSheet()->getColumnDimension('CU')->setVisible(1);
            $this->docexcel->getActiveSheet()->getColumnDimension('CV')->setVisible(1);
            $this->docexcel->getActiveSheet()->getColumnDimension('CW')->setVisible(1);
            $this->docexcel->getActiveSheet()->getColumnDimension('CX')->setVisible(1);
            $this->docexcel->getActiveSheet()->getColumnDimension('CY')->setVisible(1);
            $this->docexcel->getActiveSheet()->getColumnDimension('CZ')->setVisible(1);
            $this->docexcel->getActiveSheet()->getColumnDimension('DA')->setVisible(1);

        } else {
            $this->docexcel->getActiveSheet()->getColumnDimension('CS')->setVisible(0);
            $this->docexcel->getActiveSheet()->getColumnDimension('CT')->setVisible(0);
            $this->docexcel->getActiveSheet()->getColumnDimension('CU')->setVisible(0);
            $this->docexcel->getActiveSheet()->getColumnDimension('CV')->setVisible(0);
            $this->docexcel->getActiveSheet()->getColumnDimension('CW')->setVisible(0);
            $this->docexcel->getActiveSheet()->getColumnDimension('CX')->setVisible(0);
            $this->docexcel->getActiveSheet()->getColumnDimension('CY')->setVisible(0);
            $this->docexcel->getActiveSheet()->getColumnDimension('CZ')->setVisible(0);
            $this->docexcel->getActiveSheet()->getColumnDimension('DA')->setVisible(0);
        }
        if ($fecha_fin[1] >= 11 and $fecha_ini[1] <= 11) {
            $this->docexcel->getActiveSheet()->getColumnDimension('DC')->setVisible(1);
            $this->docexcel->getActiveSheet()->getColumnDimension('DD')->setVisible(1);
            $this->docexcel->getActiveSheet()->getColumnDimension('DE')->setVisible(1);
            $this->docexcel->getActiveSheet()->getColumnDimension('DF')->setVisible(1);
            $this->docexcel->getActiveSheet()->getColumnDimension('DG')->setVisible(1);
            $this->docexcel->getActiveSheet()->getColumnDimension('DH')->setVisible(1);
            $this->docexcel->getActiveSheet()->getColumnDimension('DI')->setVisible(1);
            $this->docexcel->getActiveSheet()->getColumnDimension('DJ')->setVisible(1);
            $this->docexcel->getActiveSheet()->getColumnDimension('DK')->setVisible(1);

        } else {
            $this->docexcel->getActiveSheet()->getColumnDimension('DC')->setVisible(0);
            $this->docexcel->getActiveSheet()->getColumnDimension('DD')->setVisible(0);
            $this->docexcel->getActiveSheet()->getColumnDimension('DE')->setVisible(0);
            $this->docexcel->getActiveSheet()->getColumnDimension('DF')->setVisible(0);
            $this->docexcel->getActiveSheet()->getColumnDimension('DG')->setVisible(0);
            $this->docexcel->getActiveSheet()->getColumnDimension('DH')->setVisible(0);
            $this->docexcel->getActiveSheet()->getColumnDimension('DI')->setVisible(0);
            $this->docexcel->getActiveSheet()->getColumnDimension('DJ')->setVisible(0);
            $this->docexcel->getActiveSheet()->getColumnDimension('DK')->setVisible(0);
        }
        if ($fecha_fin[1] >= 12 and $fecha_ini[1] <= 12) {
            $this->docexcel->getActiveSheet()->getColumnDimension('DM')->setVisible(1);
            $this->docexcel->getActiveSheet()->getColumnDimension('DN')->setVisible(1);
            $this->docexcel->getActiveSheet()->getColumnDimension('DO')->setVisible(1);
            $this->docexcel->getActiveSheet()->getColumnDimension('DP')->setVisible(1);
            $this->docexcel->getActiveSheet()->getColumnDimension('DQ')->setVisible(1);
            $this->docexcel->getActiveSheet()->getColumnDimension('DR')->setVisible(1);
            $this->docexcel->getActiveSheet()->getColumnDimension('DS')->setVisible(1);
            $this->docexcel->getActiveSheet()->getColumnDimension('DT')->setVisible(1);
            $this->docexcel->getActiveSheet()->getColumnDimension('DU')->setVisible(1);

        } else {
            $this->docexcel->getActiveSheet()->getColumnDimension('DM')->setVisible(0);
            $this->docexcel->getActiveSheet()->getColumnDimension('DN')->setVisible(0);
            $this->docexcel->getActiveSheet()->getColumnDimension('DO')->setVisible(0);
            $this->docexcel->getActiveSheet()->getColumnDimension('DP')->setVisible(0);
            $this->docexcel->getActiveSheet()->getColumnDimension('DQ')->setVisible(0);
            $this->docexcel->getActiveSheet()->getColumnDimension('DR')->setVisible(0);
            $this->docexcel->getActiveSheet()->getColumnDimension('DS')->setVisible(0);
            $this->docexcel->getActiveSheet()->getColumnDimension('DT')->setVisible(0);
            $this->docexcel->getActiveSheet()->getColumnDimension('DU')->setVisible(0);
            }
         }





        //comprometido

        if(($this->objParam->getParametro('tipo_movimiento')=='ejecutado'))
        {
            $fecha_fin =explode("/",$this->objParam->getParametro('fecha_fin'));
            $fecha_ini =explode("/",$this->objParam->getParametro('fecha_ini'));

            $this->docexcel->getActiveSheet()->getColumnDimension('DZ')->setVisible(0);
            $this->docexcel->getActiveSheet()->getColumnDimension('EA')->setVisible(1);

            $this->docexcel->getActiveSheet()->getColumnDimension('EB')->setVisible(0);
            $this->docexcel->getActiveSheet()->getColumnDimension('EC')->setVisible(1);

            $this->docexcel->getActiveSheet()->getColumnDimension('ED')->setVisible(0);
            $this->docexcel->getActiveSheet()->getColumnDimension('EE')->setVisible(1);

            $this->docexcel->getActiveSheet()->getColumnDimension('EF')->setVisible(0);
            $this->docexcel->getActiveSheet()->getColumnDimension('EG')->setVisible(1);

            $this->docexcel->getActiveSheet()->getColumnDimension('EH')->setVisible(0);
            $this->docexcel->getActiveSheet()->getColumnDimension('EI')->setVisible(1);

            $this->docexcel->getActiveSheet()->getColumnDimension('EJ')->setVisible(0);
            $this->docexcel->getActiveSheet()->getColumnDimension('EK')->setVisible(1);


            if ($fecha_fin[1] >= 01 and $fecha_ini[1] <= 01) {
                $this->docexcel->getActiveSheet()->getColumnDimension('G')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('H')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('I')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('J')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('K')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('L')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('M')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('N')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('O')->setVisible(1);

            }else{
                $this->docexcel->getActiveSheet()->getColumnDimension('G')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('H')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('I')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('J')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('K')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('L')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('M')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('N')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('O')->setVisible(0);

            }
            if ($fecha_fin[1] >= 02 and $fecha_ini[1] <= 02) {
                $this->docexcel->getActiveSheet()->getColumnDimension('Q')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('R')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('S')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('T')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('U')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('V')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('W')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('X')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('Y')->setVisible(1);

            }else{
                $this->docexcel->getActiveSheet()->getColumnDimension('Q')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('R')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('S')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('T')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('U')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('V')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('W')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('X')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('Y')->setVisible(0);

            }
            if ($fecha_fin[1] >= '03' and $fecha_ini[1] <= '03') {
                $this->docexcel->getActiveSheet()->getColumnDimension('AA')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('AB')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('AC')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('AD')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('AE')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('AF')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('AG')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('AH')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('AI')->setVisible(1);
            }else{
                $this->docexcel->getActiveSheet()->getColumnDimension('AA')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('AB')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('AC')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('AD')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('AE')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('AF')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('AG')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('AH')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('AI')->setVisible(0);
            }
            if ($fecha_fin[1] >= 04 and $fecha_ini[1] <= 04) {

                $this->docexcel->getActiveSheet()->getColumnDimension('AK')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('AL')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('AM')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('AN')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('AO')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('AP')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('AQ')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('AR')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('AS')->setVisible(1);

            }
            else {

                $this->docexcel->getActiveSheet()->getColumnDimension('AK')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('AL')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('AM')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('AN')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('AO')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('AP')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('AQ')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('AR')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('AS')->setVisible(0);


            }
            if ($fecha_fin[1] >= 05 and $fecha_ini[1] <= 05) {
                $this->docexcel->getActiveSheet()->getColumnDimension('AU')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('AV')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('AW')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('AX')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('AY')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('AZ')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('BA')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('BB')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('BC')->setVisible(1);

            }
            else {
                $this->docexcel->getActiveSheet()->getColumnDimension('AU')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('AV')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('AW')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('AX')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('AY')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('AZ')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('BA')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('BB')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('BC')->setVisible(0);

            }

            if ($fecha_fin[1] >= 06 and $fecha_ini[1] <= 06) {


                $this->docexcel->getActiveSheet()->getColumnDimension('BE')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('BF')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('BG')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('BH')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('BI')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('BJ')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('BK')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('BL')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('BM')->setVisible(1);



            }
            else {
                $this->docexcel->getActiveSheet()->getColumnDimension('BE')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('BF')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('BG')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('BH')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('BI')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('BJ')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('BK')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('BL')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('BM')->setVisible(0);



            }

            if ($fecha_fin[1] >= 07 and $fecha_ini[1] <= 07) {
                $this->docexcel->getActiveSheet()->getColumnDimension('BO')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('BP')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('BQ')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('BR')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('BS')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('BT')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('BU')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('BV')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('BW')->setVisible(1);




            } else {
                $this->docexcel->getActiveSheet()->getColumnDimension('BO')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('BP')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('BQ')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('BR')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('BS')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('BT')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('BU')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('BV')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('BW')->setVisible(0);



            }
            if ($fecha_fin[1] >= '08' and $fecha_ini[1] <= '08') {
                $this->docexcel->getActiveSheet()->getColumnDimension('BY')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('BZ')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('CA')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('CB')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('CC')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('CD')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('CE')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('CF')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('CG')->setVisible(1);


            } else {
                $this->docexcel->getActiveSheet()->getColumnDimension('BY')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('BZ')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('CA')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('CB')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('CC')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('CD')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('CE')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('CF')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('CG')->setVisible(0);




            }
            if ($fecha_fin[1] >= '09' and $fecha_ini[1] <= '09') {
                $this->docexcel->getActiveSheet()->getColumnDimension('CI')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('CJ')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('CK')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('CL')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('CM')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('CN')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('CO')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('CP')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('CQ')->setVisible(1);

            } else {
                $this->docexcel->getActiveSheet()->getColumnDimension('CI')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('CJ')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('CK')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('CL')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('CM')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('CN')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('CO')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('CP')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('CQ')->setVisible(0);



            }
            if ($fecha_fin[1] >= 10 and $fecha_ini[1] <= 10) {
                $this->docexcel->getActiveSheet()->getColumnDimension('CS')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('CT')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('CU')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('CV')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('CW')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('CX')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('CY')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('CZ')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('DA')->setVisible(1);



            } else {
                $this->docexcel->getActiveSheet()->getColumnDimension('CS')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('CT')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('CU')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('CV')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('CW')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('CX')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('CY')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('CZ')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('DA')->setVisible(0);


            }
            if ($fecha_fin[1] >= 11 and $fecha_ini[1] <= 11){
                $this->docexcel->getActiveSheet()->getColumnDimension('DC')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('DD')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('DE')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('DF')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('DG')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('DH')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('DI')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('DJ')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('DK')->setVisible(1);

            } else {
                $this->docexcel->getActiveSheet()->getColumnDimension('DC')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('DD')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('DE')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('DF')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('DG')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('DH')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('DI')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('DJ')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('DK')->setVisible(0);



            }
            if ($fecha_fin[1] >= 12 and $fecha_ini[1] <= 12) {
                $this->docexcel->getActiveSheet()->getColumnDimension('DM')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('DN')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('DO')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('DP')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('DQ')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('DR')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('DS')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('DT')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('DU')->setVisible(1);

            } else {
                $this->docexcel->getActiveSheet()->getColumnDimension('DM')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('DN')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('DO')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('DP')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('DQ')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('DR')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('DS')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('DT')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('DU')->setVisible(0);


            }

        }
        if(($this->objParam->getParametro('tipo_movimiento')=='comprometido'))

        {
            $fecha_fin =explode("/",$this->objParam->getParametro('fecha_fin'));
            $fecha_ini =explode("/",$this->objParam->getParametro('fecha_ini'));

            $this->docexcel->getActiveSheet()->getColumnDimension('DZ')->setVisible(1);
            $this->docexcel->getActiveSheet()->getColumnDimension('EA')->setVisible(0);

            $this->docexcel->getActiveSheet()->getColumnDimension('EB')->setVisible(1);
            $this->docexcel->getActiveSheet()->getColumnDimension('EC')->setVisible(0);

            $this->docexcel->getActiveSheet()->getColumnDimension('ED')->setVisible(1);
            $this->docexcel->getActiveSheet()->getColumnDimension('EE')->setVisible(0);

            $this->docexcel->getActiveSheet()->getColumnDimension('EF')->setVisible(1);
            $this->docexcel->getActiveSheet()->getColumnDimension('EG')->setVisible(0);

            $this->docexcel->getActiveSheet()->getColumnDimension('EH')->setVisible(1);
            $this->docexcel->getActiveSheet()->getColumnDimension('EI')->setVisible(0);

            $this->docexcel->getActiveSheet()->getColumnDimension('EJ')->setVisible(1);
            $this->docexcel->getActiveSheet()->getColumnDimension('EK')->setVisible(0);

            if ($fecha_fin[1] >= 01 and $fecha_ini[1] <= 01) {
                $this->docexcel->getActiveSheet()->getColumnDimension('G')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('H')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('I')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('J')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('K')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('L')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('M')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('N')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('O')->setVisible(0);

            }else{
                $this->docexcel->getActiveSheet()->getColumnDimension('G')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('H')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('I')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('J')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('K')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('L')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('M')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('N')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('O')->setVisible(0);

            }
            if ($fecha_fin[1] >= 02 and $fecha_ini[1] <= 02) {
                $this->docexcel->getActiveSheet()->getColumnDimension('Q')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('R')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('S')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('T')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('U')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('V')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('W')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('X')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('Y')->setVisible(0);

            }else{
                $this->docexcel->getActiveSheet()->getColumnDimension('Q')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('R')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('S')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('T')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('U')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('V')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('W')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('X')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('Y')->setVisible(0);

            }
            if ($fecha_fin[1] >= '03' and $fecha_ini[1] <= '03') {
                $this->docexcel->getActiveSheet()->getColumnDimension('AA')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('AB')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('AC')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('AD')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('AE')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('AF')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('AG')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('AH')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('AI')->setVisible(0);
            }else{
                $this->docexcel->getActiveSheet()->getColumnDimension('AA')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('AB')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('AC')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('AD')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('AE')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('AF')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('AG')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('AH')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('AI')->setVisible(0);
            }
            if ($fecha_fin[1] >= 04 and $fecha_ini[1] <= 04) {

                $this->docexcel->getActiveSheet()->getColumnDimension('AK')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('AL')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('AM')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('AN')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('AO')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('AP')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('AQ')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('AR')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('AS')->setVisible(0);

            }
            else {

                $this->docexcel->getActiveSheet()->getColumnDimension('AK')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('AL')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('AM')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('AN')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('AO')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('AP')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('AQ')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('AR')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('AS')->setVisible(0);


            }
            if ($fecha_fin[1] >= 05 and $fecha_ini[1] <= 05) {
                $this->docexcel->getActiveSheet()->getColumnDimension('AU')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('AV')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('AW')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('AX')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('AY')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('AZ')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('BA')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('BB')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('BC')->setVisible(0);

            }
            else {
                $this->docexcel->getActiveSheet()->getColumnDimension('AU')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('AV')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('AW')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('AX')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('AY')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('AZ')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('BA')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('BB')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('BC')->setVisible(0);

            }

            if ($fecha_fin[1] >= 06 and $fecha_ini[1] <= 06) {


                $this->docexcel->getActiveSheet()->getColumnDimension('BE')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('BF')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('BG')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('BH')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('BI')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('BJ')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('BK')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('BL')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('BM')->setVisible(0);



            }
            else {
                $this->docexcel->getActiveSheet()->getColumnDimension('BE')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('BF')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('BG')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('BH')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('BI')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('BJ')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('BK')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('BL')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('BM')->setVisible(0);



            }

            if ($fecha_fin[1] >= 07 and $fecha_ini[1] <= 07) {
                $this->docexcel->getActiveSheet()->getColumnDimension('BO')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('BP')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('BQ')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('BR')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('BS')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('BT')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('BU')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('BV')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('BW')->setVisible(0);




            } else {
                $this->docexcel->getActiveSheet()->getColumnDimension('BO')->setVisible(0);

                $this->docexcel->getActiveSheet()->getColumnDimension('BP')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('BQ')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('BR')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('BS')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('BT')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('BU')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('BV')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('BW')->setVisible(0);



            }
            if ($fecha_fin[1] >= '08' and $fecha_ini[1] <= '08') {
                $this->docexcel->getActiveSheet()->getColumnDimension('BY')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('BZ')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('CA')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('CB')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('CC')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('CD')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('CE')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('CF')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('CG')->setVisible(0);


            } else {
                $this->docexcel->getActiveSheet()->getColumnDimension('BY')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('BZ')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('CA')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('CB')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('CC')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('CD')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('CE')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('CF')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('CG')->setVisible(0);




            }
            if ($fecha_fin[1] >= '09' and $fecha_ini[1] <= '09') {
                $this->docexcel->getActiveSheet()->getColumnDimension('CI')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('CJ')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('CK')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('CL')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('CM')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('CN')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('CO')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('CP')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('CQ')->setVisible(0);

            } else {
                $this->docexcel->getActiveSheet()->getColumnDimension('CI')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('CJ')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('CK')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('CL')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('CM')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('CN')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('CO')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('CP')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('CQ')->setVisible(0);



            }
            if ($fecha_fin[1] >= 10 and $fecha_ini[1] <= 10) {
                $this->docexcel->getActiveSheet()->getColumnDimension('CS')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('CT')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('CU')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('CV')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('CW')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('CX')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('CY')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('CZ')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('DA')->setVisible(0);



            } else {
                $this->docexcel->getActiveSheet()->getColumnDimension('CS')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('CT')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('CU')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('CV')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('CW')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('CX')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('CY')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('CZ')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('DA')->setVisible(0);


            }
            if ($fecha_fin[1] >= 11 and $fecha_ini[1] <= 11){
                $this->docexcel->getActiveSheet()->getColumnDimension('DC')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('DD')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('DE')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('DF')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('DG')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('DH')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('DI')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('DJ')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('DK')->setVisible(0);

            } else {
                $this->docexcel->getActiveSheet()->getColumnDimension('DC')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('DD')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('DE')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('DF')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('DG')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('DH')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('DI')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('DJ')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('DK')->setVisible(0);



            }
            if ($fecha_fin[1] >= 12 and $fecha_ini[1] <= 12) {
                $this->docexcel->getActiveSheet()->getColumnDimension('DM')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('DN')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('DO')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('DP')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('DQ')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('DR')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('DS')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('DT')->setVisible(1);
                $this->docexcel->getActiveSheet()->getColumnDimension('DU')->setVisible(0);

            } else {
                $this->docexcel->getActiveSheet()->getColumnDimension('DM')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('DN')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('DO')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('DP')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('DQ')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('DR')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('DS')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('DT')->setVisible(0);
                $this->docexcel->getActiveSheet()->getColumnDimension('DU')->setVisible(0);


            }

        }

        //titulos

        if ($this->objParam->getParametro('tipo_reporte')=='presupuesto') {
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, 2,'"BOLIVIANA DE AVIACIÓN" - BoA');
            $this->docexcel->getActiveSheet()->getStyle('A2:BJ2')->applyFromArray($styleTitulos1);
            $this->docexcel->getActiveSheet()->mergeCells('A2:BJ2');
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, 3, $this->objParam->getParametro('concepto') );
            $this->docexcel->getActiveSheet()->getStyle('A3:BJ3')->applyFromArray($styleTitulos1);
            $this->docexcel->getActiveSheet()->mergeCells('A3:BJ3');
        }else
        {
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, 2, '"BOLIVIANA DE AVIACIÓN" - BoA');
            $this->docexcel->getActiveSheet()->getStyle('A2:BJ2')->applyFromArray($styleTitulos1);
            $this->docexcel->getActiveSheet()->mergeCells('A2:BJ2');
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, 3, $this->cat . ' - ' . $this->objParam->getParametro('concepto'));
            $this->docexcel->getActiveSheet()->getStyle('A3:BJ3')->applyFromArray($styleTitulos1);
            $this->docexcel->getActiveSheet()->mergeCells('A3:BJ3');

        }
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,4,'(Expresado en Bolivianos)');
        $this->docexcel->getActiveSheet()->getStyle('A4:BJ4')->applyFromArray($styleTitulos1);
        $this->docexcel->getActiveSheet()->mergeCells('A4:BJ4');


        $this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(50);
        $this->docexcel->getActiveSheet()->getColumnDimension('C')->setWidth(50);
        $this->docexcel->getActiveSheet()->getColumnDimension('C')->setVisible(false);
        $this->docexcel->getActiveSheet()->getColumnDimension('D')->setWidth(30);
        $this->docexcel->getActiveSheet()->getColumnDimension('D')->setVisible(false);
        $this->docexcel->getActiveSheet()->getColumnDimension('E')->setWidth(30);
        $this->docexcel->getActiveSheet()->getColumnDimension('E')->setVisible(false);

        $this->docexcel->getActiveSheet()->getColumnDimension('F')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('F6')->applyFromArray($styleEjecutado);
        $this->docexcel->getActiveSheet()->getColumnDimension('F')->setVisible(false);
        $this->docexcel->getActiveSheet()->getColumnDimension('G')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('G6')->applyFromArray($styleEjecucionProgramado);
        $this->docexcel->getActiveSheet()->getColumnDimension('H')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('H6')->applyFromArray($styleEjecutado_Comprometido);
        $this->docexcel->getActiveSheet()->getColumnDimension('I')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('I6')->applyFromArray($styleEjecuta);
        $this->docexcel->getActiveSheet()->getColumnDimension('J')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('J6')->applyFromArray($styleDiferenciaCom);
        $this->docexcel->getActiveSheet()->getColumnDimension('K')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('K6')->applyFromArray($styleDiferenciaEjec);
        $this->docexcel->getActiveSheet()->getColumnDimension('L')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('L6')->applyFromArray($styleAcumuladoComp);
        $this->docexcel->getActiveSheet()->getColumnDimension('M')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('M6')->applyFromArray($styleAcumuladoEjecu);
        $this->docexcel->getActiveSheet()->getColumnDimension('N')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('N6')->applyFromArray($stylePorcentajeComp);
        $this->docexcel->getActiveSheet()->getColumnDimension('O')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('O6')->applyFromArray($stylePorcentajeEjecu);


        $this->docexcel->getActiveSheet()->getColumnDimension('P')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('P6')->applyFromArray($styleEjecutado);
        $this->docexcel->getActiveSheet()->getColumnDimension('P')->setVisible(false);
        $this->docexcel->getActiveSheet()->getColumnDimension('Q')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('Q6')->applyFromArray($styleEjecucionProgramado);
        $this->docexcel->getActiveSheet()->getColumnDimension('R')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('R6')->applyFromArray($styleEjecutado_Comprometido);
        $this->docexcel->getActiveSheet()->getColumnDimension('S')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('S6')->applyFromArray($styleEjecuta);
        $this->docexcel->getActiveSheet()->getColumnDimension('T')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('T6')->applyFromArray($styleDiferenciaCom);//
        $this->docexcel->getActiveSheet()->getColumnDimension('U')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('U6')->applyFromArray($styleDiferenciaEjec);
        $this->docexcel->getActiveSheet()->getColumnDimension('V')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('V6')->applyFromArray($styleAcumuladoComp);
        $this->docexcel->getActiveSheet()->getColumnDimension('W')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('W6')->applyFromArray($styleAcumuladoEjecu);
        $this->docexcel->getActiveSheet()->getColumnDimension('X')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('X6')->applyFromArray($stylePorcentajeComp);
        $this->docexcel->getActiveSheet()->getColumnDimension('Y')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('Y6')->applyFromArray($stylePorcentajeEjecu);

        $this->docexcel->getActiveSheet()->getColumnDimension('Z')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('Z6')->applyFromArray($styleEjecutado);
        $this->docexcel->getActiveSheet()->getColumnDimension('Z')->setVisible(false);
        $this->docexcel->getActiveSheet()->getColumnDimension('AA')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('AA6')->applyFromArray($styleEjecucionProgramado);
        $this->docexcel->getActiveSheet()->getColumnDimension('AB')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('AB6')->applyFromArray($styleEjecutado_Comprometido);
        $this->docexcel->getActiveSheet()->getColumnDimension('AC')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('AC6')->applyFromArray($styleEjecuta);
        $this->docexcel->getActiveSheet()->getColumnDimension('AD')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('AD6')->applyFromArray($styleDiferenciaCom);//
        $this->docexcel->getActiveSheet()->getColumnDimension('AE')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('AE6')->applyFromArray($styleDiferenciaEjec);
        $this->docexcel->getActiveSheet()->getColumnDimension('AF')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('AF6')->applyFromArray($styleAcumuladoComp);
        $this->docexcel->getActiveSheet()->getColumnDimension('AG')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('AG6')->applyFromArray($styleAcumuladoEjecu);
        $this->docexcel->getActiveSheet()->getColumnDimension('AH')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('AH6')->applyFromArray($stylePorcentajeComp);
        $this->docexcel->getActiveSheet()->getColumnDimension('AI')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('AI6')->applyFromArray($stylePorcentajeEjecu);

        $this->docexcel->getActiveSheet()->getColumnDimension('AJ')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('AJ6')->applyFromArray($styleEjecutado);
        $this->docexcel->getActiveSheet()->getColumnDimension('AJ')->setVisible(false);
        $this->docexcel->getActiveSheet()->getColumnDimension('AK')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('AK6')->applyFromArray($styleEjecucionProgramado);
        $this->docexcel->getActiveSheet()->getColumnDimension('AL')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('AL6')->applyFromArray($styleEjecutado_Comprometido);
        $this->docexcel->getActiveSheet()->getColumnDimension('AM')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('AM6')->applyFromArray($styleEjecuta);
        $this->docexcel->getActiveSheet()->getColumnDimension('AN')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('AN6')->applyFromArray($styleDiferenciaCom);
        $this->docexcel->getActiveSheet()->getColumnDimension('AO')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('AO6')->applyFromArray($styleDiferenciaEjec);
        $this->docexcel->getActiveSheet()->getColumnDimension('AP')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('AP6')->applyFromArray($styleAcumuladoComp);
        $this->docexcel->getActiveSheet()->getColumnDimension('AQ')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('AQ6')->applyFromArray($styleAcumuladoEjecu);
        $this->docexcel->getActiveSheet()->getColumnDimension('AR')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('AR6')->applyFromArray($stylePorcentajeComp);
        $this->docexcel->getActiveSheet()->getColumnDimension('AS')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('AS6')->applyFromArray($stylePorcentajeEjecu);

        $this->docexcel->getActiveSheet()->getColumnDimension('AT')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('AT6')->applyFromArray($styleEjecutado);
        $this->docexcel->getActiveSheet()->getColumnDimension('AT')->setVisible(false);
        $this->docexcel->getActiveSheet()->getColumnDimension('AU')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('AU6')->applyFromArray($styleEjecucionProgramado);
        $this->docexcel->getActiveSheet()->getColumnDimension('AV')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('AV6')->applyFromArray($styleEjecutado_Comprometido);
        $this->docexcel->getActiveSheet()->getColumnDimension('AW')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('AW6')->applyFromArray($styleEjecuta);
        $this->docexcel->getActiveSheet()->getColumnDimension('AX')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('AX6')->applyFromArray($styleDiferenciaCom);
        $this->docexcel->getActiveSheet()->getColumnDimension('AY')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('AY6')->applyFromArray($styleDiferenciaEjec);
        $this->docexcel->getActiveSheet()->getColumnDimension('AZ')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('AZ6')->applyFromArray($styleAcumuladoComp);
        $this->docexcel->getActiveSheet()->getColumnDimension('BA')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('BA6')->applyFromArray($styleAcumuladoEjecu);
        $this->docexcel->getActiveSheet()->getColumnDimension('BB')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('BB6')->applyFromArray($stylePorcentajeComp);
        $this->docexcel->getActiveSheet()->getColumnDimension('BC')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('BC6')->applyFromArray($stylePorcentajeEjecu);

        $this->docexcel->getActiveSheet()->getColumnDimension('BD')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('BD6')->applyFromArray($styleEjecutado);
        $this->docexcel->getActiveSheet()->getColumnDimension('BD')->setVisible(false);
        $this->docexcel->getActiveSheet()->getColumnDimension('BE')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('BE6')->applyFromArray($styleEjecucionProgramado);
        $this->docexcel->getActiveSheet()->getColumnDimension('BF')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('BF6')->applyFromArray($styleEjecutado_Comprometido);
        $this->docexcel->getActiveSheet()->getColumnDimension('BG')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('BG6')->applyFromArray($styleEjecuta);
        $this->docexcel->getActiveSheet()->getColumnDimension('BH')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('BH6')->applyFromArray($styleDiferenciaCom);
        $this->docexcel->getActiveSheet()->getColumnDimension('BI')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('BI6')->applyFromArray($styleDiferenciaEjec);
        $this->docexcel->getActiveSheet()->getColumnDimension('BJ')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('BJ6')->applyFromArray($styleAcumuladoComp);
        $this->docexcel->getActiveSheet()->getColumnDimension('BK')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('BK6')->applyFromArray($styleAcumuladoEjecu);
        $this->docexcel->getActiveSheet()->getColumnDimension('BL')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('BL6')->applyFromArray($stylePorcentajeComp);
        $this->docexcel->getActiveSheet()->getColumnDimension('BM')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('BM6')->applyFromArray($stylePorcentajeEjecu);

        $this->docexcel->getActiveSheet()->getColumnDimension('BN')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('BN6')->applyFromArray($styleEjecutado);
        $this->docexcel->getActiveSheet()->getColumnDimension('BN')->setVisible(false);
        $this->docexcel->getActiveSheet()->getColumnDimension('BO')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('BO6')->applyFromArray($styleEjecucionProgramado);
        $this->docexcel->getActiveSheet()->getColumnDimension('BP')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('BP6')->applyFromArray($styleEjecutado_Comprometido);
        $this->docexcel->getActiveSheet()->getColumnDimension('BQ')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('BQ6')->applyFromArray($styleEjecuta);
        $this->docexcel->getActiveSheet()->getColumnDimension('BR')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('BR6')->applyFromArray($styleDiferenciaCom);
        $this->docexcel->getActiveSheet()->getColumnDimension('BS')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('BS6')->applyFromArray($styleDiferenciaEjec);
        $this->docexcel->getActiveSheet()->getColumnDimension('BT')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('BT6')->applyFromArray($styleAcumuladoComp);
        $this->docexcel->getActiveSheet()->getColumnDimension('BU')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('BU6')->applyFromArray($styleAcumuladoEjecu);
        $this->docexcel->getActiveSheet()->getColumnDimension('BV')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('BV6')->applyFromArray($stylePorcentajeComp);
        $this->docexcel->getActiveSheet()->getColumnDimension('BW')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('BW6')->applyFromArray($stylePorcentajeEjecu);

        $this->docexcel->getActiveSheet()->getColumnDimension('BX')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('BX6')->applyFromArray($styleEjecutado);
        $this->docexcel->getActiveSheet()->getColumnDimension('BX')->setVisible(false);
        $this->docexcel->getActiveSheet()->getColumnDimension('BY')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('BY6')->applyFromArray($styleEjecucionProgramado);
        $this->docexcel->getActiveSheet()->getColumnDimension('BZ')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('BZ6')->applyFromArray($styleEjecutado_Comprometido);
        $this->docexcel->getActiveSheet()->getColumnDimension('CA')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('CA6')->applyFromArray($styleEjecuta);
        $this->docexcel->getActiveSheet()->getColumnDimension('CB')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('CB6')->applyFromArray($styleDiferenciaCom);
        $this->docexcel->getActiveSheet()->getColumnDimension('CC')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('CC6')->applyFromArray($styleDiferenciaEjec);
        $this->docexcel->getActiveSheet()->getColumnDimension('CD')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('CD6')->applyFromArray($styleAcumuladoComp);
        $this->docexcel->getActiveSheet()->getColumnDimension('CE')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('CE6')->applyFromArray($styleAcumuladoEjecu);
        $this->docexcel->getActiveSheet()->getColumnDimension('CF')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('CF6')->applyFromArray($stylePorcentajeComp);
        $this->docexcel->getActiveSheet()->getColumnDimension('CG')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('CG6')->applyFromArray($stylePorcentajeEjecu);

        $this->docexcel->getActiveSheet()->getColumnDimension('CH')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('CH6')->applyFromArray($styleEjecutado);
        $this->docexcel->getActiveSheet()->getColumnDimension('CH')->setVisible(false);
        $this->docexcel->getActiveSheet()->getColumnDimension('CI')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('CI6')->applyFromArray($styleEjecucionProgramado);
        $this->docexcel->getActiveSheet()->getColumnDimension('CJ')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('CJ6')->applyFromArray($styleEjecutado_Comprometido);
        $this->docexcel->getActiveSheet()->getColumnDimension('CK')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('CK6')->applyFromArray($styleEjecuta);
        $this->docexcel->getActiveSheet()->getColumnDimension('CL')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('CL6')->applyFromArray($styleDiferenciaCom);
        $this->docexcel->getActiveSheet()->getColumnDimension('CM')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('CM6')->applyFromArray($styleDiferenciaEjec);
        $this->docexcel->getActiveSheet()->getColumnDimension('CN')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('CN6')->applyFromArray($styleAcumuladoComp);
        $this->docexcel->getActiveSheet()->getColumnDimension('CO')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('CO6')->applyFromArray($styleAcumuladoEjecu);
        $this->docexcel->getActiveSheet()->getColumnDimension('CP')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('CP6')->applyFromArray($stylePorcentajeComp);
        $this->docexcel->getActiveSheet()->getColumnDimension('CQ')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('CQ6')->applyFromArray($stylePorcentajeEjecu);

        $this->docexcel->getActiveSheet()->getColumnDimension('CR')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('CR6')->applyFromArray($styleEjecutado);
        $this->docexcel->getActiveSheet()->getColumnDimension('CR')->setVisible(false);
        $this->docexcel->getActiveSheet()->getColumnDimension('CS')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('CS6')->applyFromArray($styleEjecucionProgramado);
        $this->docexcel->getActiveSheet()->getColumnDimension('CT')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('CT6')->applyFromArray($styleEjecutado_Comprometido);
        $this->docexcel->getActiveSheet()->getColumnDimension('CU')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('CU6')->applyFromArray($styleEjecuta);
        $this->docexcel->getActiveSheet()->getColumnDimension('CV')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('CV6')->applyFromArray($styleDiferenciaCom);
        $this->docexcel->getActiveSheet()->getColumnDimension('CW')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('CW6')->applyFromArray($styleDiferenciaEjec);
        $this->docexcel->getActiveSheet()->getColumnDimension('CX')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('CX6')->applyFromArray($styleAcumuladoComp);
        $this->docexcel->getActiveSheet()->getColumnDimension('CY')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('CY6')->applyFromArray($styleAcumuladoEjecu);
        $this->docexcel->getActiveSheet()->getColumnDimension('CZ')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('CZ6')->applyFromArray($stylePorcentajeComp);
        $this->docexcel->getActiveSheet()->getColumnDimension('DA')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('DA6')->applyFromArray($stylePorcentajeEjecu);

        $this->docexcel->getActiveSheet()->getColumnDimension('DB')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('DB6')->applyFromArray($styleEjecutado);
        $this->docexcel->getActiveSheet()->getColumnDimension('DB')->setVisible(false);
        $this->docexcel->getActiveSheet()->getColumnDimension('DC')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('DC6')->applyFromArray($styleEjecucionProgramado);
        $this->docexcel->getActiveSheet()->getColumnDimension('DD')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('DD6')->applyFromArray($styleEjecutado_Comprometido);
        $this->docexcel->getActiveSheet()->getColumnDimension('DE')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('DE6')->applyFromArray($styleEjecuta);
        $this->docexcel->getActiveSheet()->getColumnDimension('DF')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('DF6')->applyFromArray($styleDiferenciaCom);
        $this->docexcel->getActiveSheet()->getColumnDimension('DG')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('DG6')->applyFromArray($styleDiferenciaEjec);
        $this->docexcel->getActiveSheet()->getColumnDimension('DH')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('DH6')->applyFromArray($styleAcumuladoComp);
        $this->docexcel->getActiveSheet()->getColumnDimension('DI')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('DI6')->applyFromArray($styleAcumuladoEjecu);
        $this->docexcel->getActiveSheet()->getColumnDimension('DJ')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('DJ6')->applyFromArray($stylePorcentajeComp);
        $this->docexcel->getActiveSheet()->getColumnDimension('DK')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('DK6')->applyFromArray($stylePorcentajeEjecu);

        $this->docexcel->getActiveSheet()->getColumnDimension('DL')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('DL6')->applyFromArray($styleEjecutado);
        $this->docexcel->getActiveSheet()->getColumnDimension('DL')->setVisible(false);
        $this->docexcel->getActiveSheet()->getColumnDimension('DM')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('DM6')->applyFromArray($styleEjecucionProgramado);
        $this->docexcel->getActiveSheet()->getColumnDimension('DN')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('DN6')->applyFromArray($styleEjecutado_Comprometido);
        $this->docexcel->getActiveSheet()->getColumnDimension('DO')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('DO6')->applyFromArray($styleEjecuta);
        $this->docexcel->getActiveSheet()->getColumnDimension('DP')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('DP6')->applyFromArray($styleDiferenciaCom);
        $this->docexcel->getActiveSheet()->getColumnDimension('DQ')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('DQ6')->applyFromArray($styleDiferenciaEjec);
        $this->docexcel->getActiveSheet()->getColumnDimension('DR')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('DR6')->applyFromArray($styleAcumuladoComp);
        $this->docexcel->getActiveSheet()->getColumnDimension('DS')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('DS6')->applyFromArray($styleAcumuladoEjecu);
        $this->docexcel->getActiveSheet()->getColumnDimension('DT')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('DT6')->applyFromArray($stylePorcentajeComp);
        $this->docexcel->getActiveSheet()->getColumnDimension('DU')->setWidth(20);
        $this->docexcel->getActiveSheet()->getStyle('DU6')->applyFromArray($stylePorcentajeEjecu);

        $this->docexcel->getActiveSheet()->getColumnDimension('DV')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('DW')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('DX')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('DY')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('DZ')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('EA')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('EB')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('EC')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('ED')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('EE')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('EF')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('EG')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('EH')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('EI')->setWidth(20);

        $this->docexcel->getActiveSheet()->getColumnDimension('EJ')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('EK')->setWidth(20);

        $this->docexcel->getActiveSheet()->getStyle('A6:Ek6')->getAlignment()->setWrapText(true);
        $this->docexcel->getActiveSheet()->getStyle('A6:E6')->applyFromArray($styleTitulos2);
        $this->docexcel->getActiveSheet()->getStyle('DV6:DY6')->applyFromArray($styleTitulos2);
        $this->docexcel->getActiveSheet()->getStyle('DZ6')->applyFromArray($styleEjecutado_Comprometido);
        $this->docexcel->getActiveSheet()->getStyle('EA6')->applyFromArray($styleEjecuta);

        $this->docexcel->getActiveSheet()->getStyle('EB6')->applyFromArray($styleAcumuladoEjecu);
        $this->docexcel->getActiveSheet()->getStyle('EC6')->applyFromArray($styleAcumuladoComp);
        $this->docexcel->getActiveSheet()->getStyle('ED6')->applyFromArray($styleDiferenciaEjec);
        $this->docexcel->getActiveSheet()->getStyle('EE6')->applyFromArray($styleDiferenciaCom);
        $this->docexcel->getActiveSheet()->getStyle('EF6')->applyFromArray($stylePorcentajeComp);
        $this->docexcel->getActiveSheet()->getStyle('EG6')->applyFromArray($styleEjecutado);
        $this->docexcel->getActiveSheet()->getStyle('EH6')->applyFromArray($stylePorcentajeEjecu);
        $this->docexcel->getActiveSheet()->getStyle('EI6')->applyFromArray($styleEjecuta);
        $this->docexcel->getActiveSheet()->getStyle('EJ6')->applyFromArray($styleTitulos2);
        $this->docexcel->getActiveSheet()->getStyle('EK6')->applyFromArray($styleAcumuladoEjecu);



        //*************************************Cabecera************************************
        $this->cabecera = array('PARTIDA','DESCRIPCION','PRESUPUESTO APROBADO 2016',
            'MODIFICACIONES 2016','PRESUPUESTO VIGENTE 2016',

            'EJECUTADO 31/01/2016','EJECUCION PROGRAMADA PARA ENERO',

            'COMPROMETIDO ENERO','EJECUTADO ENERO',
            'DIFERENCIA PROGRAMADO - COMPROMETIDO','DIFERENCIA PROGRAMADO - EJECUTADO',
            'COMPROMETIDO ACUMULADO AL 31/01/2017','EJECUTADO ACUMULADO AL 31/01/2017','COMPROMETIDO %',
            'EJECUTADO %',

            'EJECUTADO 28/02/2016','EJECUCION PROGRAMADA PARA FEBRERO','COMPROMETIDO FEBRERO',
            'EJECUTADO FEBRERO','DIFERENCIA PROGRAMADO - COMPROMETIDO','DIFERENCIA PROGRAMADO - EJECUTADO','COMPROMETIDO EJECUTADO AL 28/02/2017',
            'EJECUTADO ACUMULADO AL 28/02/2017','COMPROMETIDO %','EJECUTADO %',

            'EJECUTADO 31/03/2016','EJECUCION PROGRAMADA PARA MARZO',
            'COMPROMETIDO MARZO','EJECUTADO MARZO',
            'DIFERENCIA PROGRAMADO - COMPROMETIDO','DIFERENCIA PROGRAMADO - EJECUTADO',
            'COMPROMETIDO ACUMULADO AL 31/03/2017','EJECUTADO ACUMULADO AL 31/03/2017',
            'COMPROMETIDO %','EJECUTADO %',

            'EJECUTADO 31/04/2016','EJECUCION PROGRAMADA PARA ABRIL','COMPROMETIDO ABRIL',
            'EJECUTADO ABRIL','DIFERENCIA PROGRAMADO - COMPROMETIDO','DIFERENCIA PROGRAMADO - EJECUTADO',
            'COMPROMETIDO ACUMULADO AL 31/04/2017','EJECUTADO ACUMULADO AL 31/04/2017','COMPROMETIDO %','EJECUTADO %',

            'EJECUTADO 31/05/2016','EJECUCION PROGRAMADA PARA MAYO','COMPROMETIDO MAYO',
            'EJECUTADO MAYO','DIFERENCIA PROGRAMADO - COMPROMETIDO','DIFERENCIA PROGRAMADO - EJECUTADO',
            'COMPROMETIDO ACUMULADO AL 31/05/2017','EJECUTADO ACUMULADO AL 31/05/2017','COMPROMETIDO %','EJECUTADO %',

            'EJECUTADO 30/06/2016','EJECUCION PROGRAMADA PARA JUNIO','COMPROMETIDO JUNIO',
            'EJECUTADO JUNIO','DIFERENCIA PROGRAMADO - COMPROMETIDO','DIFERENCIA PROGRAMADO - EJECUTADO',
            'COMPROMETIDO ACUMULADA AL 30/06/2017','EJECUTADO ACUMULADO AL 30/06/2017','COMPROMETIDO %','EJECUTADO %',

            'EJECUTADO 31/07/2016','EJECUCION PROGRAMADA PARA JULIO','COMPROMETIDO JULIO',
            'EJECUTADO JULIO','DIFERENCIA PROGRAMADO - COMPROMETIDO','DIFERENCIA PROGRAMADO - EJECUTADO',
            'COMPROMETIDO ACUMULADA AL 31/07/2017','EJECUTADO ACUMULADA AL 31/07/2017','COMPROMETIDO %','EJECUTADO %',

            'EJECUTADO 31/08/2016','EJECUCION PROGRAMADA PARA AGOSTO','COMPROMETIDO AGOSTO',
            'EJECUTADO AGOSTO','DIFERENCIA PROGRAMADO - COMPROMETIDO','DIFERENCIA PROGRAMADO - EJECUTADO',
            'COMPROMETIDO ACUMULADO AL 31/08/2017','EJECUTADO ACUMULADO AL 31/08/2017','COMPROMETIDO %','EJECUTADO %',

            'EJECUTADO 30/09/2016','EJECUCION PROGRAMADA PARA SEPTIEMBRE','COMPROMETIDO SEPTIEMBRE',
            'EJECUTADO SEPTIEMBRE','DIFERENCIA PROGRAMADO - COMPROMETIDO','DIFERENCIA PROGRAMADO - EJECUTADO',
            'COMPROMETIDO ACUMULADO AL 30/09/2017','EJECUTADO ACUMULADO AL 30/09/2017','COMPROMETIDO %','EJECUTADO %',

            'EJECUTADO 31/10/2016','EJECUCION PROGRAMADA PARA OCTUBRE','COMPROMETIDO OCTUBRE',
            'EJECUTADO OCTUBRE','DIFERENCIA PROGRAMADO - COMPROMETIDO','DIFERENCIA PROGRAMADO - EJECUTADO',
            'COMPROMETIDO ACUMULADO AL 31/10/2017','EJECUTADO ACUMULADO AL 31/10/2017','COMPROMETIDO %','EJECUTADO %',

            'EJECUTADO 30/11/2016','EJECUCION PROGRAMADA PARA NOVIEMBRE','COMPROMETIDO NOVIEMBRE',
            'EJECUTADO NOVIEMBRE','DIFERENCIA PROGRAMADO - COMPROMETIDO','DIFERENCIA PROGRAMADO - EJECUTADO',
            'COMPROMETIDO ACUMULADO AL 30/11/2017','EJECUTADO ACUMULADO AL 30/11/2017','COMPROMETIDO %','EJECUTADO %',

            'EJECUTADO 31/12/2016','EJECUCION PROGRAMADA PARA DICIEMBRE','COMPROMETIDO DICIEMBRE',
            'EJECUTADO DICIEMBRE','DIFERENCIA PROGRAMADO - COMPROMETIDO','DIFERENCIA PROGRAMADO - EJECUTADO',
            'COMPROMETIDO ACUMULADO AL 31/12/2017','EJECUTADO ACUMULADO AL 31/12/2017','COMPROMETIDO %','EJECUTADO %',
            'TOTAL PROGRAMADO 2017','PRESUPUESTO APROBADO 2017','MODIFICACIONES 2017','PRESUPUESTO VIGENTE 2017',
            'COMPROMETIDO AL '.$this->objParam->getParametro('fecha_fin'),'EJECUCION AL '.$this->objParam->getParametro('fecha_fin'),'SALDO POR COMPROMETER AL '.$this->objParam->getParametro('fecha_fin'),'SALDO POR EJECUCION AL '.$this->objParam->getParametro('fecha_fin'),
            'TOTAL DIFERENCIA PROGRAMADO - COMPROMETIDO','TOTAL DIFERENCIA PROGRAMADO - EJECUCION','TOTAL DIFERENCIA P.VIGENTE - COMPROMETIDO',
            'TOTAL DIFERENCIA P.VIGENTE - EJECUCION',
            'TOTAL PORCENTAJE DIFERENCIA PROGRAMADO / COMPROMETIDO % ',' TOTAL PORCENTAJE DIFERENCIA PROGRAMADO / EJECUTADO %',
            'TOTAL PORCENTAJE P.VIGENTE / COMPROMETIDO % ','TOTAL PORCENTAJE P.VIGENTE / EJECUTADO '

    );


        $colum = 0;
        //var_dump($this->cabecera); exit;
       foreach ($this->cabecera as  $value)
       {
           $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($colum, 6, $value);
           $colum++;

       }

        $this->docexcel->getActiveSheet()->setCellValue('G5','ENERO');
        $this->docexcel->getActiveSheet()->mergeCells('G5:O5');
        $this->docexcel->getActiveSheet()->getStyle('G5:O5')->applyFromArray($stylePeriodo);
        $this->docexcel->getActiveSheet()->setCellValue('P5','FEBRERO');
        $this->docexcel->getActiveSheet()->mergeCells('P5:Y5');
        $this->docexcel->getActiveSheet()->getStyle('P5:Y5')->applyFromArray($stylePeriodo);
        $this->docexcel->getActiveSheet()->setCellValue('Z5','MARZO');
        $this->docexcel->getActiveSheet()->mergeCells('Z5:AI5');
        $this->docexcel->getActiveSheet()->getStyle('Z5:AI5')->applyFromArray($stylePeriodo);
        $this->docexcel->getActiveSheet()->setCellValue('AJ5','ABRIL');
        $this->docexcel->getActiveSheet()->mergeCells('AJ5:AS5');
        $this->docexcel->getActiveSheet()->getStyle('AJ5:AS5')->applyFromArray($stylePeriodo);
        $this->docexcel->getActiveSheet()->setCellValue('AT5','MAYO');
        $this->docexcel->getActiveSheet()->mergeCells('AT5:BC5');
        $this->docexcel->getActiveSheet()->getStyle('AN5:BC5')->applyFromArray($stylePeriodo);
        $this->docexcel->getActiveSheet()->setCellValue('BD5','JUNIO');
        $this->docexcel->getActiveSheet()->mergeCells('BD5:BM5');
        $this->docexcel->getActiveSheet()->getStyle('BD5:BM5')->applyFromArray($stylePeriodo);//
        $this->docexcel->getActiveSheet()->setCellValue('BN5','JULIO');
        $this->docexcel->getActiveSheet()->mergeCells('BN5:BW5');
        $this->docexcel->getActiveSheet()->getStyle('BN5:BW5')->applyFromArray($stylePeriodo);
        $this->docexcel->getActiveSheet()->setCellValue('BX5','AGOSTO');
        $this->docexcel->getActiveSheet()->mergeCells('BX5:CG5');
        $this->docexcel->getActiveSheet()->getStyle('BX5:CG5')->applyFromArray($stylePeriodo);
        $this->docexcel->getActiveSheet()->setCellValue('CH5','SEPTIEMBRE');
        $this->docexcel->getActiveSheet()->mergeCells('CH5:CQ5');
        $this->docexcel->getActiveSheet()->getStyle('CH5:CQ5')->applyFromArray($stylePeriodo);
        $this->docexcel->getActiveSheet()->setCellValue('CR5','OCTUBRE');
        $this->docexcel->getActiveSheet()->mergeCells('CR5:DA5');
        $this->docexcel->getActiveSheet()->getStyle('CR5:DA5')->applyFromArray($stylePeriodo);
        $this->docexcel->getActiveSheet()->setCellValue('DB5','NOVIEMBRE');
        $this->docexcel->getActiveSheet()->mergeCells('DB5:DK5');
        $this->docexcel->getActiveSheet()->getStyle('DB5:DK5')->applyFromArray($stylePeriodo);
        $this->docexcel->getActiveSheet()->setCellValue('DL5','DICIEMBRE');
        $this->docexcel->getActiveSheet()->mergeCells('DL5:DU5');
        $this->docexcel->getActiveSheet()->getStyle('DL5:DU5')->applyFromArray($stylePeriodo);
        $this->docexcel->getActiveSheet(0)->freezePaneByColumnAndRow(6,7);// inmovilizar paneles

    }
    function generarDatos()
    {
        $styleBordes = array(
            'borders' => array(

                'outline' => array(
                    'style' => PHPExcel_Style_Border::BORDER_THICK,
                )
            )

        );


        if(($this->objParam->getParametro('tipo_movimiento')=='comprometido')or ($this->objParam->getParametro('tipo_movimiento')=='ejecutado')) {
            $fila = 7;
            $datos = $this->datos_detalle;
            $this->cat = $datos[0]['cod_prg'];
            $this->titulo= [0,1,2];
            $sheet = 0;
            $this->codigo =['10000','20000','30000','40000','50000','60000','80000','90000'];
            $this->imprimeCabecera($sheet,$this->cat);

            foreach ($datos as $value) {
                if ($value['cod_prg'] != $this->cat) {
                    $this->cat = $value['cod_prg'];
                    $sheet++;
                    $this->imprimeCabecera($sheet, $this->cat);
                    $fila = 7;

                }
                if ($this->objParam->getParametro('nivel') != 1) {
                    if (in_array($value['codigo_partida'], $this->codigo)) {
                        $this->imprimeSubtitulo($fila, $value['codigo_partida']);
                        $this->columna++;
                        $this->columna = 1;
                    }
                }
                if ($this->objParam->getParametro('nivel') != 2) {
                    if (in_array($value['nivel_partida'], $this->titulo)) {
                        $this->imprimeTituloPartida($fila, $value['nivel_partida']);
                        $this->columna++;
                        $this->columna = 1;
                    }
                }

                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, $value['codigo_partida']);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila, $value['nombre_partida']);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6, $fila, $value['c1']);//memoria
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(16, $fila, $value['c2']);//memoria
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(26, $fila, $value['c3']);//memoria
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(36, $fila, $value['c4']);//memoria
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(46, $fila, $value['c5']);//memoria
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(56, $fila, $value['c6']);//memoria
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(66, $fila, $value['c7']);//memoria
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(76, $fila, $value['c8']);//memoria
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(86, $fila, $value['c9']);//memoria
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(96, $fila, $value['c10']);//memoria
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(106, $fila, $value['c11']);//memoria
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(116, $fila, $value['c12']);//memori

                $presupuestoVigente = $value['importe_aprobado'] + $value['modificaciones'];
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(128, $fila,$presupuestoVigente);


                if (($this->objParam->getParametro('tipo_movimiento') == 'comprometido')) {
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(7, $fila, $value['b1']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(17, $fila, $value['b2']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(27, $fila, $value['b3']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(37, $fila, $value['b4']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(47, $fila, $value['b5']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(57, $fila, $value['b6']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(67, $fila, $value['b7']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(77, $fila, $value['b8']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(87, $fila, $value['b9']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(97, $fila, $value['b10']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(107, $fila, $value['b11']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(117, $fila, $value['b12']);

                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(9, $fila,  $value['diferencia1'] );
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(19, $fila, $value['diferencia2'] );
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(29, $fila, $value['diferencia3'] );
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(39, $fila, $value['diferencia4'] );
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(49, $fila, $value['diferencia5'] );
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(59, $fila, $value['diferencia6'] );
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(69, $fila, $value['diferencia7'] );
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(79, $fila, $value['diferencia8'] );
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(89, $fila, $value['diferencia9'] );
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(99, $fila, $value['diferencia10'] );
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(109, $fila,$value['diferencia11'] );
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(119, $fila,$value['diferencia12' ]);

                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(11, $fila, $value['acumulado1']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(21, $fila, $value['acumulado2']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(31, $fila, $value['acumulado3']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(41, $fila, $value['acumulado4']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(51, $fila, $value['acumulado5']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(61, $fila, $value['acumulado6']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(71, $fila, $value['acumulado7']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(81, $fila, $value['acumulado8']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(91, $fila, $value['acumulado9']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(101, $fila,$value['acumulado10']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(111, $fila,$value['acumulado11']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(121, $fila,$value['acumulado12']);

                    if($value['c1']!=0){
                        $por_eje = ($value['b1']/$value['c1']*100);
                    }
                    else{
                        $por_eje = 0;

                    }
                    if($value['c2']!=0){
                        $por_eje2 = ($value['b2']/$value['c2']*100);
                    }
                    else{
                        $por_eje2 = 0;
                    }
                    if($value['c3']!=0){
                        $por_eje3 = ($value['b3']/$value['c3']*100);
                    }
                    else{
                        $por_eje3 = 0;
                    }
                    if($value['c4']!=0){
                        $por_eje4 = ($value['b4']/$value['c4']*100);
                    }
                    else{
                        $por_eje4 = 0;
                    }
                    if($value['c5']!=0){
                        $por_eje5 = ($value['b5']/$value['c5']*100);
                    }
                    else{
                        $por_eje5 = 0;
                    }
                    if($value['c6']!=0){
                        $por_eje6 = ($value['b6']/$value['c6']*100);
                    }
                    else{
                        $por_eje6 = 0;
                    }
                    if($value['c7']!=0){
                        $por_eje7 = ($value['b7']/$value['c7']*100);
                    }
                    else{
                        $por_eje7 = 0;
                    }
                    if($value['c8']!=0){
                        $por_eje8 = ($value['b8']/$value['c8']*100);
                    }
                    else{
                        $por_eje8 = 0;
                    }
                    if($value['c9']!=0){
                        $por_eje9 = ($value['b9']/$value['c9']*100);
                    }
                    else{
                        $por_eje9 = 0;
                    }
                    if($value['c10']!=0){
                        $por_eje10 = ($value['b10']/$value['c10']*100);
                    }
                    else{
                        $por_eje10 = 0;
                    }
                    if($value['c11']!=0){
                        $por_eje11 = ($value['b11']/$value['c11']*100);
                    }
                    else{
                        $por_eje11 = 0;
                    }
                    if($value['c12']!=0){
                        $por_eje12 = ($value['b12']/$value['c12']*100);
                    }
                    else{
                        $por_eje12 = 0;
                    }
                    if($value['total_programado']!=0){
                        $por_total = ($value['total_comp_ejec']/$value['total_programado']*100);
                    }
                    else{
                        $por_total = 0;
                    }

                    if($presupuestoVigente!=0){
                        $por_total_comp_vigente = ($value['total_comp_ejec']/$presupuestoVigente*100);
                    }
                    else{
                        $por_total_comp_vigente  = 0;
                    }
                    $por_total_comp_vigente = number_format((float)$por_total_comp_vigente, 2, '.', '');




                    $por_eje = number_format((float)$por_eje, 2, '.', '');
                    $por_eje2 = number_format((float)$por_eje2, 2, '.', '');
                    $por_eje3 = number_format((float)$por_eje3, 2, '.', '');
                    $por_eje4 = number_format((float)$por_eje4, 2, '.', '');
                    $por_eje5 = number_format((float)$por_eje5, 2, '.', '');
                    $por_eje6 = number_format((float)$por_eje6, 2, '.', '');
                    $por_eje7 = number_format((float)$por_eje7, 2, '.', '');
                    $por_eje8 = number_format((float)$por_eje8, 2, '.', '');
                    $por_eje9 = number_format((float)$por_eje9, 2, '.', '');
                    $por_eje10 = number_format((float)$por_eje10, 2, '.', '');
                    $por_eje11 = number_format((float)$por_eje11, 2, '.', '');
                    $por_eje12 = number_format((float)$por_eje12, 2, '.', '');
                    $por_total = number_format((float)$por_total, 2, '.', '');

                     $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(13, $fila,$por_eje );
                     $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(23, $fila,$por_eje2 );
                     $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(33, $fila,$por_eje3 );
                     $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(43, $fila,$por_eje4 );
                     $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(53, $fila,$por_eje5 );
                     $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(63, $fila,$por_eje6 );
                     $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(73, $fila,$por_eje7 );
                     $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(83, $fila,$por_eje8 );
                     $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(93, $fila,$por_eje9 );
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(103, $fila,$por_eje10);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(113, $fila,$por_eje11);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(123, $fila,$por_eje12);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(129, $fila,$value['total_comp_ejec']);
                    $difereicaTotal = $value['total_programado'] - $value['total_comp_ejec'];
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(133, $fila,$difereicaTotal);
                    $saldoPresupuestoComprometido =  $presupuestoVigente - $value['total_comp_ejec'];
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(131, $fila,$saldoPresupuestoComprometido);
                    $totalDiferenciaVigente = $presupuestoVigente - $value['total_comp_ejec'];
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(135, $fila,$totalDiferenciaVigente);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(137, $fila,$por_total);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(139, $fila,$por_total_comp_vigente);

                }
                if (($this->objParam->getParametro('tipo_movimiento') == 'ejecutado')) {
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(8, $fila, $value['b1']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(18, $fila, $value['b2']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(28, $fila, $value['b3']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(38, $fila, $value['b4']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(48, $fila, $value['b5']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(58, $fila, $value['b6']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(68, $fila, $value['b7']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(78, $fila, $value['b8']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(88, $fila, $value['b9']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(98, $fila, $value['b10']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(108, $fila, $value['b11']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(118, $fila, $value['b12']);

                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(10, $fila, $value['diferencia1']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(20, $fila, $value['diferencia2']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(30, $fila, $value['diferencia3']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(40, $fila, $value['diferencia4']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(50, $fila, $value['diferencia5']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(60, $fila, $value['diferencia6']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(70, $fila, $value['diferencia7']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(80, $fila, $value['diferencia8']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(90, $fila, $value['diferencia9']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(100, $fila,$value['diferencia10']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(110, $fila,$value['diferencia11']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(120, $fila,$value['diferencia12']);

                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(12, $fila, $value['acumulado1']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(22, $fila, $value['acumulado2']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(32, $fila, $value['acumulado3']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(42, $fila, $value['acumulado4']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(52, $fila, $value['acumulado5']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(62, $fila, $value['acumulado6']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(72, $fila, $value['acumulado7']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(82, $fila, $value['acumulado8']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(92, $fila, $value['acumulado9']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(102, $fila,$value['acumulado10']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(112, $fila,$value['acumulado11']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(122, $fila,$value['acumulado12']);
                    if($value['c1']!=0){
                        $por_eje = ($value['b1']/$value['c1']*100);
                    }
                    else{
                        $por_eje = 0;

                    }
                    if($value['c2']!=0){
                        $por_eje2 = ($value['b2']/$value['c2']*100);
                    }
                    else{
                        $por_eje2 = 0;
                    }
                    if($value['c3']!=0){
                        $por_eje3 = ($value['b3']/$value['c3']*100);
                    }
                    else{
                        $por_eje3 = 0;
                    }
                    if($value['c4']!=0){
                        $por_eje4 = ($value['b4']/$value['c4']*100);
                    }
                    else{
                        $por_eje4 = 0;
                    }
                    if($value['c5']!=0){
                        $por_eje5 = ($value['b5']/$value['c5']*100);
                    }
                    else{
                        $por_eje5 = 0;
                    }
                    if($value['c6']!=0){
                        $por_eje6 = ($value['b6']/$value['c6']*100);
                    }
                    else{
                        $por_eje6 = 0;
                    }
                    if($value['c7']!=0){
                        $por_eje7 = ($value['b7']/$value['c7']*100);
                    }
                    else{
                        $por_eje7 = 0;
                    }
                    if($value['c8']!=0){
                        $por_eje8 = ($value['b8']/$value['c8']*100);
                    }
                    else{
                        $por_eje8 = 0;
                    }
                    if($value['c9']!=0){
                        $por_eje9 = ($value['b9']/$value['c9']*100);
                    }
                    else{
                        $por_eje9 = 0;
                    }
                    if($value['c10']!=0){
                        $por_eje10 = ($value['b10']/$value['c10']*100);
                    }
                    else{
                        $por_eje10 = 0;
                    }
                    if($value['c11']!=0){
                        $por_eje11 = ($value['b11']/$value['c11']*100);
                    }
                    else{
                        $por_eje11 = 0;
                    }
                    if($value['c12']!=0){
                        $por_eje12 = ($value['b12']/$value['c12']*100);
                    }
                    else{
                        $por_eje12 = 0;
                    }
                    if($value['total_programado']!=0){
                        $por_total = ($value['total_comp_ejec']/$value['total_programado']*100);
                    }
                    else{
                        $por_total = 0;
                    }

                    if($presupuestoVigente!=0){
                        $por_total_comp_vigente = ($value['total_comp_ejec']/$presupuestoVigente*100);
                    }
                    else{
                        $por_total_comp_vigente  = 0;
                    }
                    $por_total_comp_vigente = number_format((float)$por_total_comp_vigente, 2, '.', '');




                    $por_eje = number_format((float)$por_eje, 2, '.', '');
                    $por_eje2 = number_format((float)$por_eje2, 2, '.', '');
                    $por_eje3 = number_format((float)$por_eje3, 2, '.', '');
                    $por_eje4 = number_format((float)$por_eje4, 2, '.', '');
                    $por_eje5 = number_format((float)$por_eje5, 2, '.', '');
                    $por_eje6 = number_format((float)$por_eje6, 2, '.', '');
                    $por_eje7 = number_format((float)$por_eje7, 2, '.', '');
                    $por_eje8 = number_format((float)$por_eje8, 2, '.', '');
                    $por_eje9 = number_format((float)$por_eje9, 2, '.', '');
                    $por_eje10 = number_format((float)$por_eje10, 2, '.', '');
                    $por_eje11 = number_format((float)$por_eje11, 2, '.', '');
                    $por_eje12 = number_format((float)$por_eje12, 2, '.', '');
                    $por_total = number_format((float)$por_total, 2, '.', '');
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(14, $fila,$por_eje );
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(24, $fila,$por_eje2 );
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(34, $fila,$por_eje3 );
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(44, $fila,$por_eje4 );
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(54, $fila,$por_eje5 );
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(64, $fila,$por_eje6 );
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(74, $fila,$por_eje7 );
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(84, $fila,$por_eje8 );
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(94, $fila,$por_eje9 );
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(104, $fila,$por_eje10);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(114, $fila,$por_eje11);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(124, $fila,$por_eje12);


                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(130, $fila,$value['total_comp_ejec']);
                    $difereicaTotal = $value['total_programado'] - $value['total_comp_ejec'];
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(134, $fila,$difereicaTotal);
                    $saldoPresupuestoComprometido =  $presupuestoVigente - $value['total_comp_ejec'] ;
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(132, $fila,$saldoPresupuestoComprometido);
                    $totalDiferenciaVigente = $presupuestoVigente - $value['total_comp_ejec'];
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(136, $fila,$totalDiferenciaVigente);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(138, $fila,$por_total);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(140, $fila,$por_total_comp_vigente);

                }
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(125, $fila,$value['total_programado']);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(126, $fila,$value['importe_aprobado']);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(127, $fila,$value['modificaciones']);



                $this->docexcel->getActiveSheet()->getStyle("C$fila:EI$fila")->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat :: FORMAT_NUMBER_COMMA_SEPARATED1);
                $fila++;
                $this->columna++;
            }
        }
        else
            {   ///TODO

            $fila = 7;
            $dato2 = $this->datos_total;
            $this->cat = $dato2[0]['cod_prg'];
            $this->titulo= [0,1,2];
            $sheet = 0;
            $this->codigo =['10000','20000','30000','40000','50000','60000','80000','90000'];
            $this->imprimeCabecera($sheet,$this->cat);

            foreach ($dato2 as $value) {
                if ($value['cod_prg'] != $this->cat) {
                    $this->cat = $value['cod_prg'];
                    $sheet++;
                    $this->imprimeCabecera($sheet, $this->cat);
                    $fila = 7;

                }
                if ($this->objParam->getParametro('nivel') != 1) {
                    if (in_array($value['codigo_partida'], $this->codigo)) {
                        $this->imprimeSubtitulo($fila, $value['codigo_partida']);
                        $this->columna++;
                        $this->columna = 1;
                    }
                }
                if ($this->objParam->getParametro('nivel') != 2) {
                    if (in_array($value['nivel_partida'], $this->titulo)) {
                        $this->imprimeTituloPartida($fila, $value['nivel_partida']);
                        $this->columna++;
                        $this->columna = 1;
                    }
                }

                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, $value['codigo_partida']);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila, $value['nombre_partida']);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6, $fila, $value['c1']);//memoria
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(16, $fila, $value['c2']);//memoria
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(26, $fila, $value['c3']);//memoria
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(36, $fila, $value['c4']);//memoria
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(46, $fila, $value['c5']);//memoria
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(56, $fila, $value['c6']);//memoria
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(66, $fila, $value['c7']);//memoria
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(76, $fila, $value['c8']);//memoria
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(86, $fila, $value['c9']);//memoria
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(96, $fila, $value['c10']);//memoria
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(106, $fila, $value['c11']);//memoria
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(116, $fila, $value['c12']);//memori

                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(7, $fila, $value['b1']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(17, $fila, $value['b2']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(27, $fila, $value['b3']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(37, $fila, $value['b4']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(47, $fila, $value['b5']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(57, $fila, $value['b6']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(67, $fila, $value['b7']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(77, $fila, $value['b8']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(87, $fila, $value['b9']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(97, $fila, $value['b10']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(107, $fila, $value['b11']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(117, $fila, $value['b12']);


                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(9, $fila,  $value['diferencia_compremetido1']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(19, $fila, $value['diferencia_compremetido2']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(29, $fila, $value['diferencia_compremetido3']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(39, $fila, $value['diferencia_compremetido4']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(49, $fila, $value['diferencia_compremetido5']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(59, $fila, $value['diferencia_compremetido6']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(69, $fila, $value['diferencia_compremetido7']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(79, $fila, $value['diferencia_compremetido8']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(89, $fila, $value['diferencia_compremetido9']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(99, $fila, $value['diferencia_compremetido10']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(109, $fila,$value['diferencia_compremetido11']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(119, $fila,$value['diferencia_compremetido12']);

                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(11, $fila, $value['acumulado_comprendido1']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(21, $fila, $value['acumulado_comprendido2']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(31, $fila, $value['acumulado_comprendido3']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(41, $fila, $value['acumulado_comprendido4']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(51, $fila, $value['acumulado_comprendido5']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(61, $fila, $value['acumulado_comprendido6']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(71, $fila, $value['acumulado_comprendido7']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(81, $fila, $value['acumulado_comprendido8']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(91, $fila, $value['acumulado_comprendido9']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(101, $fila,$value['acumulado_comprendido10']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(111, $fila,$value['acumulado_comprendido11']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(121, $fila,$value['acumulado_comprendido12']);




                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(8, $fila, $value['f1']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(18, $fila, $value['f2']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(28, $fila, $value['f3']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(38, $fila, $value['f4']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(48, $fila, $value['f5']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(58, $fila, $value['f6']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(68, $fila, $value['f7']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(78, $fila, $value['f8']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(88, $fila, $value['f9']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(98, $fila, $value['f10']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(108, $fila, $value['f11']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(118, $fila, $value['f12']);


                 $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(10, $fila, $value['diferencia_ejecutado1']);
                 $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(20, $fila, $value['diferencia_ejecutado2']);
                 $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(30, $fila, $value['diferencia_ejecutado3']);
                 $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(40, $fila, $value['diferencia_ejecutado4']);
                 $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(50, $fila, $value['diferencia_ejecutado5']);
                 $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(60, $fila, $value['diferencia_ejecutado6']);
                 $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(70, $fila, $value['diferencia_ejecutado7']);
                 $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(80, $fila, $value['diferencia_ejecutado8']);
                 $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(90, $fila, $value['diferencia_ejecutado9']);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(100, $fila, $value['diferencia_ejecutado10']);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(110, $fila, $value['diferencia_ejecutado11']);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(120, $fila, $value['diferencia_ejecutado12']);


                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(12, $fila, $value['acumulado_ejecutado1']);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(22, $fila, $value['acumulado_ejecutado2']);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(32, $fila, $value['acumulado_ejecutado3']);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(42, $fila, $value['acumulado_ejecutado4']);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(52, $fila, $value['acumulado_ejecutado5']);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(62, $fila, $value['acumulado_ejecutado6']);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(72, $fila, $value['acumulado_ejecutado7']);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(82, $fila, $value['acumulado_ejecutado8']);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(92, $fila, $value['acumulado_ejecutado9']);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(102, $fila,$value['acumulado_ejecutado10']);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(112, $fila,$value['acumulado_ejecutado11']);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(122, $fila,$value['acumulado_ejecutado12']);
                if($value['c1']!=0){
                    $por_eje = ($value['b1']/$value['c1']*100);
                    $por_comp = ($value['f1']/$value['c1']*100);

                }
                else{
                    $por_eje = 0;
                    $por_comp = 0;
                }
                if($value['c2']!=0){
                    $por_eje2 = ($value['b2']/$value['c2']*100);
                    $por_comp2 = ($value['f2']/$value['c2']*100);
                }
                else{
                    $por_eje2 = 0;
                    $por_comp2 = 0;
                }
                if($value['c3']!=0){
                    $por_eje3 = ($value['b3']/$value['c3']*100);
                    $por_comp3 = ($value['f3']/$value['c3']*100);
                }
                else{
                    $por_eje3 = 0;
                    $por_comp3 = 0;
                }
                if($value['c4']!=0){
                    $por_eje4 = ($value['b4']/$value['c4']*100);
                    $por_comp4 = ($value['f4']/$value['c4']*100);
                }
                else{
                    $por_eje4 = 0;
                    $por_comp4 = 0;
                }
                if($value['c5']!=0){
                    $por_eje5 = ($value['b5']/$value['c5']*100);
                    $por_comp5 = ($value['f5']/$value['c5']*100);
                }
                else{
                    $por_eje5 = 0;
                    $por_comp5 = 0;
                }
                if($value['c6']!=0){
                    $por_eje6 = ($value['b6']/$value['c6']*100);
                    $por_comp6 = ($value['f6']/$value['c6']*100);
                }
                else{
                    $por_eje6 = 0;
                    $por_comp6 = 0;
                }
                if($value['c7']!=0){
                    $por_eje7 = ($value['b7']/$value['c7']*100);
                    $por_comp7 = ($value['f7']/$value['c7']*100);
                }
                else{
                    $por_eje7 = 0;
                    $por_comp7 = 0;
                }
                if($value['c8']!=0){
                    $por_eje8 = ($value['b8']/$value['c8']*100);
                    $por_comp8 = ($value['f8']/$value['c8']*100);
                }
                else{
                    $por_eje8 = 0;
                    $por_comp8 = 0;
                }
                if($value['c9']!=0){
                    $por_eje9 = ($value['b9']/$value['c9']*100);
                    $por_comp9 = ($value['f9']/$value['c9']*100);
                }
                else{
                    $por_eje9 = 0;
                    $por_comp9 = 0;
                }
                if($value['c10']!=0){
                    $por_eje10 = ($value['b10']/$value['c10']*100);
                    $por_comp10 = ($value['f10']/$value['c10']*100);
                }
                else{
                    $por_eje10 = 0;
                    $por_comp10 = 0;
                }
                if($value['c11']!=0){
                    $por_eje11 = ($value['b11']/$value['c11']*100);
                    $por_comp11 = ($value['f11']/$value['c11']*100);
                }
                else{
                    $por_eje11 = 0;
                    $por_comp11 = 0;
                }
                if($value['c12']!=0){
                    $por_eje12 = ($value['b12']/$value['c12']*100);
                    $por_comp12 = ($value['f12']/$value['c12']*100);
                }
                else{
                    $por_eje12 = 0;
                    $por_comp12 = 0;
                }

                $por_eje = number_format((float)$por_eje, 2, '.', '');
                $por_comp = number_format((float)$por_comp, 2, '.', '');
                $por_eje2 = number_format((float)$por_eje2, 2, '.', '');
                $por_comp2 = number_format((float)$por_comp2, 2, '.', '');
                $por_eje3 = number_format((float)$por_eje3, 2, '.', '');
                $por_comp3 = number_format((float)$por_comp3, 2, '.', '');
                $por_eje4 = number_format((float)$por_eje4, 2, '.', '');
                $por_comp4 = number_format((float)$por_comp4, 2, '.', '');
                $por_eje5 = number_format((float)$por_eje5, 2, '.', '');
                $por_comp5 = number_format((float)$por_comp5, 2, '.', '');
                $por_eje6 = number_format((float)$por_eje6, 2, '.', '');
                $por_comp6 = number_format((float)$por_comp6, 2, '.', '');
                $por_eje7 = number_format((float)$por_eje7, 2, '.', '');
                $por_comp7 = number_format((float)$por_comp7, 2, '.', '');
                $por_eje8 = number_format((float)$por_eje8, 2, '.', '');
                $por_comp8 = number_format((float)$por_comp8, 2, '.', '');
                $por_eje9 = number_format((float)$por_eje9, 2, '.', '');
                $por_comp9 = number_format((float)$por_comp9, 2, '.', '');
                $por_eje10 = number_format((float)$por_eje10, 2, '.', '');
                $por_comp10 = number_format((float)$por_comp10, 2, '.', '');
                $por_eje11 = number_format((float)$por_eje11, 2, '.', '');
                $por_comp11 = number_format((float)$por_comp11, 2, '.', '');
                $por_eje12 = number_format((float)$por_eje12, 2, '.', '');
                $por_comp12 = number_format((float)$por_comp12, 2, '.', '');

                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(13, $fila,$por_eje );
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(23, $fila,$por_eje2 );
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(33, $fila,$por_eje3 );
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(43, $fila,$por_eje4 );
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(53, $fila,$por_eje5 );
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(63, $fila,$por_eje6 );
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(73, $fila,$por_eje7 );
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(83, $fila,$por_eje8 );
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(93, $fila,$por_eje9 );
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(103, $fila,$por_eje10);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(113, $fila,$por_eje11);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(123, $fila,$por_eje12);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(14, $fila,$por_comp );
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(24, $fila,$por_comp2 );
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(34, $fila,$por_comp3 );
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(44, $fila,$por_comp4 );
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(54, $fila,$por_comp5 );
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(64, $fila,$por_comp6 );
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(74, $fila,$por_comp7 );
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(84, $fila,$por_comp8 );
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(94, $fila,$por_comp9 );
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(104, $fila,$por_comp10);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(114, $fila,$por_comp11);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(124, $fila,$por_comp12);

                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(125, $fila,$value['total_programado']);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(126, $fila,$value['importe_aprobado']);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(127, $fila,$value['modificaciones']);
                $presupuestoVigente = $value['importe_aprobado'] + $value['modificaciones'];
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(128, $fila,$presupuestoVigente);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(129, $fila,$value['total_comprometido']);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(130, $fila,$value['total_ejecutado']);
                $saldoPresupuestoComprometido =  $presupuestoVigente - $value['total_comprometido'] ;
                $saldoPresupuestoEjecucion=  $presupuestoVigente - $value['total_ejecutado'];
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(131, $fila,$saldoPresupuestoComprometido);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(132, $fila,$saldoPresupuestoEjecucion);

                $difeCom = $value['total_programado'] - $value['total_comprometido'];
                $difeEje = $value['total_programado'] - $value['total_ejecutado'];

                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(133, $fila,$difeCom);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(134, $fila,$difeEje);

                $DiferenciaVigeComprometido =  $presupuestoVigente - $value['total_comprometido'];
                $DiferenciaVigeEjecucion=  $presupuestoVigente - $value['total_ejecutado'] ;

                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(135, $fila,$DiferenciaVigeComprometido);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(136, $fila,$DiferenciaVigeEjecucion);

                if($value['total_programado']!=0){
                    $por_total_eje = ($value['total_comprometido']/$value['total_programado']*100);
                    $por_total_comp = ($value['total_ejecutado']/$value['total_programado']*100);
                }
                else{
                    $por_total_eje  = 0;
                    $por_total_comp  = 0;
                }
                $por_total_eje = number_format((float)$por_total_eje, 2, '.', '');
                $por_total_comp = number_format((float)$por_total_comp, 2, '.', '');

                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(137, $fila,$por_total_eje);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(138, $fila,$por_total_comp);

                if($presupuestoVigente!=0){
                    $por_total_eje_vigente = ($value['total_comprometido']/$presupuestoVigente*100);
                    $por_total_comp_vigente = ($value['total_ejecutado']/$presupuestoVigente*100);
                }
                else{
                    $por_total_eje_vigente  = 0;
                    $por_total_comp_vigente  = 0;
                }
                $por_total_eje_vigente = number_format((float)$por_total_eje_vigente, 2, '.', '');
                $por_total_comp_vigente = number_format((float)$por_total_comp_vigente, 2, '.', '');

                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(139, $fila,$por_total_eje_vigente);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(140, $fila,$por_total_comp_vigente);


                $this->docexcel->getActiveSheet()->getStyle("C$fila:EI$fila")->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat :: FORMAT_NUMBER_COMMA_SEPARATED1);
                $fila++;
                $this->columna++;
            }

        }
           /* $TotalMemoria = $dato2[0];

             if (!array_key_exists($TotalMemoria['c1'],$this->sumaTotal)){
                 $this->sumaTotal[$TotalMemoria['c1']][$TotalMemoria['c2']][$TotalMemoria['c3']][$TotalMemoria['c4']][$TotalMemoria['c5']]
                 [$TotalMemoria['c6']][$TotalMemoria['c7']][$TotalMemoria['c8']][$TotalMemoria['c9']][$TotalMemoria['c10']][$TotalMemoria['c11']][$TotalMemoria['c12']]= 1;
                 }else{
                 $this->sumaTotal[$TotalMemoria['c1']][$TotalMemoria['c2']][$TotalMemoria['c3']][$TotalMemoria['c4']][$TotalMemoria['c5']]
                 [$TotalMemoria['c6']][$TotalMemoria['c7']][$TotalMemoria['c8']][$TotalMemoria['c9']][$TotalMemoria['c10']][$TotalMemoria['c11']][$TotalMemoria['c12']]++;
             }
               //var_dump($this->sumaTotal); exit;
           $this->docexcel->getActiveSheet()->setCellValue("B$fila",'TOTAL');
            $col = 6;

            foreach ($this->sumaTotal as $hey => $hr){
                        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($col,$fila,$hey);
                        $col++;
            }
            */
           $fil = 6;
            $fils = $fila - 1;
            $this->docexcel->getActiveSheet()->getStyle("A$fil:E$fils")->applyFromArray($styleBordes);
            $this->docexcel->getActiveSheet()->getStyle("G$fil:O$fils")->applyFromArray($styleBordes);
            $this->docexcel->getActiveSheet()->getStyle("Q$fil:Y$fils")->applyFromArray($styleBordes);
            $this->docexcel->getActiveSheet()->getStyle("AA$fil:AI$fils")->applyFromArray($styleBordes);
            $this->docexcel->getActiveSheet()->getStyle("AK$fil:AS$fils")->applyFromArray($styleBordes);
            $this->docexcel->getActiveSheet()->getStyle("AU$fil:BC$fils")->applyFromArray($styleBordes);
            $this->docexcel->getActiveSheet()->getStyle("BE$fil:BM$fils")->applyFromArray($styleBordes);
            $this->docexcel->getActiveSheet()->getStyle("BO$fil:BW$fils")->applyFromArray($styleBordes);
            $this->docexcel->getActiveSheet()->getStyle("BY$fil:CG$fils")->applyFromArray($styleBordes);
            $this->docexcel->getActiveSheet()->getStyle("CI$fil:CQ$fils")->applyFromArray($styleBordes);
            $this->docexcel->getActiveSheet()->getStyle("CS$fil:DA$fils")->applyFromArray($styleBordes);
            $this->docexcel->getActiveSheet()->getStyle("DC$fil:DK$fils")->applyFromArray($styleBordes);
            $this->docexcel->getActiveSheet()->getStyle("DM$fil:DU$fils")->applyFromArray($styleBordes);

            $this->docexcel->getActiveSheet()->getStyle("DV$fil:DY$fils")->applyFromArray($styleBordes);
            $this->docexcel->getActiveSheet()->getStyle("DZ$fil:EA$fils")->applyFromArray($styleBordes);
            $this->docexcel->getActiveSheet()->getStyle("EB$fil:EC$fils")->applyFromArray($styleBordes);
            $this->docexcel->getActiveSheet()->getStyle("ED$fil:EE$fils")->applyFromArray($styleBordes);
            $this->docexcel->getActiveSheet()->getStyle("EF$fil:EG$fils")->applyFromArray($styleBordes);
            $this->docexcel->getActiveSheet()->getStyle("EH$fil:EI$fils")->applyFromArray($styleBordes);
            $this->docexcel->getActiveSheet()->getStyle("EJ$fil:EJ$fils")->applyFromArray($styleBordes);
            $this->docexcel->getActiveSheet()->getStyle("EK$fil:EK$fils")->applyFromArray($styleBordes);


        $categoria= $this->objParam->getParametro('id_categoria_programatica');
        $presupuesto= $this->objParam->getParametro('id_presupuesto');
        $programa= $this->objParam->getParametro('id_cp_programa');

        $sheet++;
        if($categoria =='0' or $presupuesto =='0' or $programa == '0'){
        $this->institucional($sheet);
       }

    }
    function institucional ($sheet){
        $this->docexcel->createSheet($sheet );
        $this->docexcel->setActiveSheetIndex($sheet);
        $this->imprimeCabecera($sheet,'INSTITUCIONAL');

        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, 3, $this->objParam->getParametro('concepto'));

        $dato2 = $this->datos_institucional;
        $fila = 7;
        $this->titulo= [0,1,2];
        $this->codigo =['10000','20000','30000','40000','50000','60000','80000','90000'];


        foreach ($dato2 as $value) {

            if ($this->objParam->getParametro('nivel') != 1) {
                if (in_array($value['codigo_partida'], $this->codigo)) {
                    $this->imprimeSubtitulo($fila, $value['codigo_partida']);
                    $this->columna++;
                    $this->columna = 1;
                }
            }
            if ($this->objParam->getParametro('nivel') != 2) {
                if (in_array($value['nivel_partida'], $this->titulo)) {
                    $this->imprimeTituloPartida($fila, $value['nivel_partida']);
                    $this->columna++;
                    $this->columna = 1;
                }
            }

            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, $value['codigo_partida']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila, $value['nombre_partida']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6, $fila, $value['c1']);//memoria
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(16, $fila, $value['c2']);//memoria
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(26, $fila, $value['c3']);//memoria
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(36, $fila, $value['c4']);//memoria
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(46, $fila, $value['c5']);//memoria
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(56, $fila, $value['c6']);//memoria
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(66, $fila, $value['c7']);//memoria
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(76, $fila, $value['c8']);//memoria
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(86, $fila, $value['c9']);//memoria
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(96, $fila, $value['c10']);//memoria
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(106, $fila, $value['c11']);//memoria
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(116, $fila, $value['c12']);//memori

            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(7, $fila, $value['b1']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(17, $fila, $value['b2']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(27, $fila, $value['b3']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(37, $fila, $value['b4']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(47, $fila, $value['b5']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(57, $fila, $value['b6']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(67, $fila, $value['b7']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(77, $fila, $value['b8']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(87, $fila, $value['b9']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(97, $fila, $value['b10']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(107, $fila, $value['b11']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(117, $fila, $value['b12']);


            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(9, $fila,  $value['diferencia_compremetido1']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(19, $fila, $value['diferencia_compremetido2']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(29, $fila, $value['diferencia_compremetido3']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(39, $fila, $value['diferencia_compremetido4']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(49, $fila, $value['diferencia_compremetido5']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(59, $fila, $value['diferencia_compremetido6']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(69, $fila, $value['diferencia_compremetido7']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(79, $fila, $value['diferencia_compremetido8']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(89, $fila, $value['diferencia_compremetido9']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(99, $fila, $value['diferencia_compremetido10']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(109, $fila,$value['diferencia_compremetido11']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(119, $fila,$value['diferencia_compremetido12']);

            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(11, $fila, $value['acumulado_comprendido1']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(21, $fila, $value['acumulado_comprendido2']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(31, $fila, $value['acumulado_comprendido3']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(41, $fila, $value['acumulado_comprendido4']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(51, $fila, $value['acumulado_comprendido5']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(61, $fila, $value['acumulado_comprendido6']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(71, $fila, $value['acumulado_comprendido7']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(81, $fila, $value['acumulado_comprendido8']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(91, $fila, $value['acumulado_comprendido9']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(101, $fila,$value['acumulado_comprendido10']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(111, $fila,$value['acumulado_comprendido11']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(121, $fila,$value['acumulado_comprendido12']);




            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(8, $fila, $value['f1']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(18, $fila, $value['f2']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(28, $fila, $value['f3']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(38, $fila, $value['f4']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(48, $fila, $value['f5']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(58, $fila, $value['f6']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(68, $fila, $value['f7']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(78, $fila, $value['f8']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(88, $fila, $value['f9']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(98, $fila, $value['f10']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(108, $fila, $value['f11']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(118, $fila, $value['f12']);


            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(10, $fila, $value['diferencia_ejecutado1']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(20, $fila, $value['diferencia_ejecutado2']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(30, $fila, $value['diferencia_ejecutado3']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(40, $fila, $value['diferencia_ejecutado4']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(50, $fila, $value['diferencia_ejecutado5']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(60, $fila, $value['diferencia_ejecutado6']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(70, $fila, $value['diferencia_ejecutado7']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(80, $fila, $value['diferencia_ejecutado8']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(90, $fila, $value['diferencia_ejecutado9']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(100, $fila, $value['diferencia_ejecutado10']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(110, $fila, $value['diferencia_ejecutado11']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(120, $fila, $value['diferencia_ejecutado12']);


            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(12, $fila, $value['acumulado_ejecutado1']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(22, $fila, $value['acumulado_ejecutado2']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(32, $fila, $value['acumulado_ejecutado3']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(42, $fila, $value['acumulado_ejecutado4']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(52, $fila, $value['acumulado_ejecutado5']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(62, $fila, $value['acumulado_ejecutado6']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(72, $fila, $value['acumulado_ejecutado7']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(82, $fila, $value['acumulado_ejecutado8']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(92, $fila, $value['acumulado_ejecutado9']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(102, $fila,$value['acumulado_ejecutado10']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(112, $fila,$value['acumulado_ejecutado11']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(122, $fila,$value['acumulado_ejecutado12']);
            if($value['c1']!=0){
                $por_eje = ($value['b1']/$value['c1']*100);
                $por_comp = ($value['f1']/$value['c1']*100);

            }
            else{
                $por_eje = 0;
                $por_comp = 0;
            }
            if($value['c2']!=0){
                $por_eje2 = ($value['b2']/$value['c2']*100);
                $por_comp2 = ($value['f2']/$value['c2']*100);
            }
            else{
                $por_eje2 = 0;
                $por_comp2 = 0;
            }
            if($value['c3']!=0){
                $por_eje3 = ($value['b3']/$value['c3']*100);
                $por_comp3 = ($value['f3']/$value['c3']*100);
            }
            else{
                $por_eje3 = 0;
                $por_comp3 = 0;
            }
            if($value['c4']!=0){
                $por_eje4 = ($value['b4']/$value['c4']*100);
                $por_comp4 = ($value['f4']/$value['c4']*100);
            }
            else{
                $por_eje4 = 0;
                $por_comp4 = 0;
            }
            if($value['c5']!=0){
                $por_eje5 = ($value['b5']/$value['c5']*100);
                $por_comp5 = ($value['f5']/$value['c5']*100);
            }
            else{
                $por_eje5 = 0;
                $por_comp5 = 0;
            }
            if($value['c6']!=0){
                $por_eje6 = ($value['b6']/$value['c6']*100);
                $por_comp6 = ($value['f6']/$value['c6']*100);
            }
            else{
                $por_eje6 = 0;
                $por_comp6 = 0;
            }
            if($value['c7']!=0){
                $por_eje7 = ($value['b7']/$value['c7']*100);
                $por_comp7 = ($value['f7']/$value['c7']*100);
            }
            else{
                $por_eje7 = 0;
                $por_comp7 = 0;
            }
            if($value['c8']!=0){
                $por_eje8 = ($value['b8']/$value['c8']*100);
                $por_comp8 = ($value['f8']/$value['c8']*100);
            }
            else{
                $por_eje8 = 0;
                $por_comp8 = 0;
            }
            if($value['c9']!=0){
                $por_eje9 = ($value['b9']/$value['c9']*100);
                $por_comp9 = ($value['f9']/$value['c9']*100);
            }
            else{
                $por_eje9 = 0;
                $por_comp9 = 0;
            }
            if($value['c10']!=0){
                $por_eje10 = ($value['b10']/$value['c10']*100);
                $por_comp10 = ($value['f10']/$value['c10']*100);
            }
            else{
                $por_eje10 = 0;
                $por_comp10 = 0;
            }
            if($value['c11']!=0){
                $por_eje11 = ($value['b11']/$value['c11']*100);
                $por_comp11 = ($value['f11']/$value['c11']*100);
            }
            else{
                $por_eje11 = 0;
                $por_comp11 = 0;
            }
            if($value['c12']!=0){
                $por_eje12 = ($value['b12']/$value['c12']*100);
                $por_comp12 = ($value['f12']/$value['c12']*100);
            }
            else{
                $por_eje12 = 0;
                $por_comp12 = 0;
            }

            $por_eje = number_format((float)$por_eje, 2, '.', '');
            $por_comp = number_format((float)$por_comp, 2, '.', '');
            $por_eje2 = number_format((float)$por_eje2, 2, '.', '');
            $por_comp2 = number_format((float)$por_comp2, 2, '.', '');
            $por_eje3 = number_format((float)$por_eje3, 2, '.', '');
            $por_comp3 = number_format((float)$por_comp3, 2, '.', '');
            $por_eje4 = number_format((float)$por_eje4, 2, '.', '');
            $por_comp4 = number_format((float)$por_comp4, 2, '.', '');
            $por_eje5 = number_format((float)$por_eje5, 2, '.', '');
            $por_comp5 = number_format((float)$por_comp5, 2, '.', '');
            $por_eje6 = number_format((float)$por_eje6, 2, '.', '');
            $por_comp6 = number_format((float)$por_comp6, 2, '.', '');
            $por_eje7 = number_format((float)$por_eje7, 2, '.', '');
            $por_comp7 = number_format((float)$por_comp7, 2, '.', '');
            $por_eje8 = number_format((float)$por_eje8, 2, '.', '');
            $por_comp8 = number_format((float)$por_comp8, 2, '.', '');
            $por_eje9 = number_format((float)$por_eje9, 2, '.', '');
            $por_comp9 = number_format((float)$por_comp9, 2, '.', '');
            $por_eje10 = number_format((float)$por_eje10, 2, '.', '');
            $por_comp10 = number_format((float)$por_comp10, 2, '.', '');
            $por_eje11 = number_format((float)$por_eje11, 2, '.', '');
            $por_comp11 = number_format((float)$por_comp11, 2, '.', '');
            $por_eje12 = number_format((float)$por_eje12, 2, '.', '');
            $por_comp12 = number_format((float)$por_comp12, 2, '.', '');

            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(13, $fila,$por_eje );
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(23, $fila,$por_eje2 );
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(33, $fila,$por_eje3 );
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(43, $fila,$por_eje4 );
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(53, $fila,$por_eje5 );
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(63, $fila,$por_eje6 );
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(73, $fila,$por_eje7 );
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(83, $fila,$por_eje8 );
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(93, $fila,$por_eje9 );
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(103, $fila,$por_eje10);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(113, $fila,$por_eje11);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(123, $fila,$por_eje12);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(14, $fila,$por_comp );
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(24, $fila,$por_comp2 );
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(34, $fila,$por_comp3 );
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(44, $fila,$por_comp4 );
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(54, $fila,$por_comp5 );
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(64, $fila,$por_comp6 );
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(74, $fila,$por_comp7 );
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(84, $fila,$por_comp8 );
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(94, $fila,$por_comp9 );
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(104, $fila,$por_comp10);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(114, $fila,$por_comp11);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(124, $fila,$por_comp12);

            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(125, $fila,$value['total_programado']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(126, $fila,$value['importe_aprobado']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(127, $fila,$value['modificaciones']);
            $presupuestoVigente = $value['importe_aprobado'] + $value['modificaciones'];
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(128, $fila,$presupuestoVigente);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(129, $fila,$value['total_comprometido']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(130, $fila,$value['total_ejecutado']);
            $saldoPresupuestoComprometido =  $presupuestoVigente - $value['total_comprometido'] ;
            $saldoPresupuestoEjecucion=  $presupuestoVigente - $value['total_ejecutado'];
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(131, $fila,$saldoPresupuestoComprometido);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(132, $fila,$saldoPresupuestoEjecucion);

            $difeCom = $value['total_programado'] - $value['total_comprometido'];
            $difeEje = $value['total_programado'] - $value['total_ejecutado'];

            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(133, $fila,$difeCom);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(134, $fila,$difeEje);

            $DiferenciaVigeComprometido =  $presupuestoVigente - $value['total_comprometido'];
            $DiferenciaVigeEjecucion=  $presupuestoVigente - $value['total_ejecutado'] ;

            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(135, $fila,$DiferenciaVigeComprometido);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(136, $fila,$DiferenciaVigeEjecucion);

            if($value['total_programado']!=0){
                $por_total_eje = ($value['total_comprometido']/$value['total_programado']*100);
                $por_total_comp = ($value['total_ejecutado']/$value['total_programado']*100);
            }
            else{
                $por_total_eje  = 0;
                $por_total_comp  = 0;
            }
            $por_total_eje = number_format((float)$por_total_eje, 2, '.', '');
            $por_total_comp = number_format((float)$por_total_comp, 2, '.', '');

            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(137, $fila,$por_total_eje);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(138, $fila,$por_total_comp);

            if($presupuestoVigente!=0){
                $por_total_eje_vigente = ($value['total_comprometido']/$presupuestoVigente*100);
                $por_total_comp_vigente = ($value['total_ejecutado']/$presupuestoVigente*100);
            }
            else{
                $por_total_eje_vigente  = 0;
                $por_total_comp_vigente  = 0;
            }
            $por_total_eje_vigente = number_format((float)$por_total_eje_vigente, 2, '.', '');
            $por_total_comp_vigente = number_format((float)$por_total_comp_vigente, 2, '.', '');

            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(139, $fila,$por_total_eje_vigente);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(140, $fila,$por_total_comp_vigente);


            $this->docexcel->getActiveSheet()->getStyle("C$fila:EI$fila")->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat :: FORMAT_NUMBER_COMMA_SEPARATED1);
            $fila++;
            $this->columna++;
        }

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
        $this->docexcel->getActiveSheet()->getStyle($this->equivalencias[0] . $fila . ":" . $this->equivalencias[140] . $fila)->applyFromArray($styleTitulos);
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, $valor);
    }
    function imprimeTituloPartida($fila, $valor){
        $styleTitulos = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 12,
                'name'  => 'Calibri'
            )

        );
        $this->docexcel->getActiveSheet()->getStyle($this->equivalencias[0] . $fila . ":" . $this->equivalencias[140] . $fila)->applyFromArray($styleTitulos);
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