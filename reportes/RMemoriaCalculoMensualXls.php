<?php

class RMemoriaCalculoMensualXls
{
	private $docexcel;
	private $objWriter;
	private $nombre_archivo;
	private $hoja;
	private $columnas=array();
	private $fila;
	private $equivalencias=array();
	
	private $indice, $m_fila, $titulo;
	private $swEncabezado=0; //variable que define si ya se imprimi� el encabezado
	private $objParam;
	public  $url_archivo;
	
	var $datos_titulo;
	var $datos_detalle;
	var $ancho_hoja;
	var $gerencia;
	var $numeracion;
	var $ancho_sin_totales;
	var $cantidad_columnas_estaticas;
	var $s1;
	var $t1;
	var $tg1;
	var $total;
	var $datos_entidad;
	var $datos_periodo;
	var $ult_codigo_partida;
	var $ult_concepto;	
	
	
	
	function __construct(CTParametro $objParam){
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
							 
		$this->docexcel->setActiveSheetIndex(0);
		
		$this->docexcel->getActiveSheet()->setTitle($this->objParam->getParametro('titulo_archivo'));
		
		$this->equivalencias=array(0=>'A',1=>'B',2=>'C',3=>'D',4=>'E',5=>'F',6=>'G',7=>'H',8=>'I',
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
	
	function datosHeader ( $detalle, $totales, $gestion,$dataEmpresa) {
		
		$this->datos_detalle = $detalle;
		$this->datos_titulo = $totales;
		$this->datos_entidad = $dataEmpresa;
		$this->datos_gestion = $gestion;
		
		
	}
			
	function imprimeDatos(){
		
        $this->docexcel->createSheet();		
		$tipo=$this->objParam->getParametro('var');
        /*$this->docexcel->getActiveSheet()->setTitle('MEMORIA de CA');
        $this->docexcel->setActiveSheetIndex(0);*/
        //$datos = $this->objParam->getParametro('datos');


        $styleTitulos1 = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 12,
                'name'  => 'Arial'
            ),
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            ),
        );
		

        //$this->Image(dirname(__FILE__).'/../../lib/imagenes/logos/logo.jpg', 10,5,40,20);

		
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,2,'MEMORIA DE CÁLCULO Y CRONOGRAMA DE REQUERIMIENTOS');
		$this->docexcel->getActiveSheet()->getStyle('A2:P2')->applyFromArray($styleTitulos1);
		$this->docexcel->getActiveSheet()->mergeCells('A2:P2');
		$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,3,$this->datos_entidad['nombre']);
		$this->docexcel->getActiveSheet()->getStyle('A3:P3')->applyFromArray($styleTitulos1);
		$this->docexcel->getActiveSheet()->mergeCells('A3:P3');
		$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,3,"ANTEPROYECTO PRESUPUESTO GESTION ".$this->datos_detalle[0]["gestion"]);
		$this->docexcel->getActiveSheet()->getStyle('A4:P4')->applyFromArray($styleTitulos1);
		$this->docexcel->getActiveSheet()->mergeCells('A4:P4');
			
        /*$this->SetFont('','B',11);
        $this->Cell(0,5,"MEMORIA DE CÁLCULO Y CRONOGRAMA DE REQUERIMIENTOS",0,1,'C');
        $this->Cell(0,5,mb_strtoupper($this->datos_entidad['nombre'],'UTF-8'),0,1,'C');
        $this->Cell(0,5,"ANTEPROYECTO PRESUPUESTO GESTION ".$this->datos_detalle[0]["gestion"],0,1,'C');
        $this->SetFont('','B',7);
        $this->Cell(0,5,"(Expresado en Bolivianos)",0,1,'C');
        $this->Ln(2);
        $this->SetFont('','',9);*/
			
			
			
			
		
		$datos = $this->datos_detalle;
		
		$config = $this->objParam->getParametro('config');
		$columnas = 0;
		
		

		
							 
        $styleTitulos2 = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 9,
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
                    'rgb' => '0066CC'
                )
            ),
            'borders' => array(
                'allborders' => array(
                    'style' => PHPExcel_Style_Border::BORDER_THIN
                )
            ));						 

        $this->docexcel->getActiveSheet()->getStyle('A6:R6')->applyFromArray($styleTitulos2);
		
		//*************************************Cabecera*****************************************
		$this->docexcel->getActiveSheet()->getColumnDimension($this->equivalencias[0])->setWidth(20);		
		$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(0,6,'Nro');
		
		$this->docexcel->getActiveSheet()->getColumnDimension($this->equivalencias[1])->setWidth(20);
		$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(1,6,'CENTRO DE COSTO');
		
		$this->docexcel->getActiveSheet()->getColumnDimension($this->equivalencias[2])->setWidth(20);
		$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(2,6,'CONCEPTO DE GASTO'); //concepto
		$this->docexcel->getActiveSheet()->getColumnDimension($this->equivalencias[3])->setWidth(20);
		$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(3,6,'JUSTIFICACION');
		$this->docexcel->getActiveSheet()->getColumnDimension($this->equivalencias[4])->setWidth(20);
		$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(4,6,'UNIDAD DE MEDIDA');
		/*$this->docexcel->getActiveSheet()->getColumnDimension($this->equivalencias[4])->setWidth(20);
		$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(5,1,'COSTO UNITARIO');
		$this->docexcel->getActiveSheet()->getColumnDimension($this->equivalencias[5])->setWidth(20);
		$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(6,1,'CANTIDAD REQUERIDA');*/
		$this->docexcel->getActiveSheet()->getColumnDimension($this->equivalencias[5])->setWidth(20);
		$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(5,6,'ENE');
		$this->docexcel->getActiveSheet()->getColumnDimension($this->equivalencias[6])->setWidth(20);
		$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(6,6,'FEB');
		$this->docexcel->getActiveSheet()->getColumnDimension($this->equivalencias[7])->setWidth(20);
		$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(7,6,'MAR');
		$this->docexcel->getActiveSheet()->getColumnDimension($this->equivalencias[8])->setWidth(20);
		$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(8,6,'ABR');
		$this->docexcel->getActiveSheet()->getColumnDimension($this->equivalencias[9])->setWidth(20);
		$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(9,6,'MAY');
		$this->docexcel->getActiveSheet()->getColumnDimension($this->equivalencias[10])->setWidth(20);
		$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(10,6,'JUN');
		$this->docexcel->getActiveSheet()->getColumnDimension($this->equivalencias[11])->setWidth(20);
		$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(11,6,'JUL');
		$this->docexcel->getActiveSheet()->getColumnDimension($this->equivalencias[12])->setWidth(20);
		$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(12,6,'AGO');
		$this->docexcel->getActiveSheet()->getColumnDimension($this->equivalencias[13])->setWidth(20);
		$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(13,6,'SEP');
		$this->docexcel->getActiveSheet()->getColumnDimension($this->equivalencias[14])->setWidth(20);
		$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(14,6,'OCT');
		$this->docexcel->getActiveSheet()->getColumnDimension($this->equivalencias[15])->setWidth(20);
		$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(15, 6,'NOV');
		$this->docexcel->getActiveSheet()->getColumnDimension($this->equivalencias[16])->setWidth(20);
		$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(16,6,'DIC');
		$this->docexcel->getActiveSheet()->getColumnDimension($this->equivalencias[17])->setWidth(20);
		$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(17,6,'TOTAL ESTACIONALIDAD');
		


		//*************************************Fin Cabecera*****************************************
		
		$fila = 7;
		$contador = 1;
		
		

		
		/////////////////////***********************************Detalle***********************************************
		foreach($datos as $value) {
			
			$importeXperiodo = explode(',',$value['importe_periodo']);		

			$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(0,$fila,$contador);
			
			$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(1,$fila,$value['descripcion_pres']); //Centro de costo
			
			$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(2,$fila,$value['desc_ingas']);
			$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(3,$fila,"".$value['justificacion']." ");
			$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(4,$fila,$value['unidad_medida']);
			/*$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(5,$fila,$value['importe_unitario']);
			$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(6,$fila,$value['cantidad_mem']);*/
			
			$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(5,$fila,$importeXperiodo[0]);
			$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(6,$fila,$importeXperiodo[1]);
			$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(7,$fila,$importeXperiodo[2]);
			$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(8,$fila,$importeXperiodo[3]);
			$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(9,$fila,$importeXperiodo[4]);
			$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(10,$fila,$importeXperiodo[5]);
			$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(11,$fila,$importeXperiodo[6]);
			$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(12,$fila,$importeXperiodo[7]);
			$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(13,$fila,$importeXperiodo[8]);
			$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(14,$fila,$importeXperiodo[9]);
			$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(15,$fila,$importeXperiodo[10]);
			$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(16,$fila,$importeXperiodo[11]);
			$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(17,$fila,$value['importe']);

			

			
			$fila++;
			$contador++;
		}
		//************************************************Fin Detalle***********************************************
		
	}


	
	function generarReporte(){
		
		$this->imprimeDatos();
		
		//echo $this->nombre_archivo; exit;
		// Set active sheet index to the first sheet, so Excel opens this as the first sheet
		$this->docexcel->setActiveSheetIndex(0);
		$this->objWriter = PHPExcel_IOFactory::createWriter($this->docexcel, 'Excel5');
		$this->objWriter->save($this->url_archivo);		
		
		
	}	
	

}

?>