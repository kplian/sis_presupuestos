<?php

class RMemoriaCalculoXls
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
		$datos = $this->datos_detalle;
		
		$config = $this->objParam->getParametro('config');
		$columnas = 0;
		
		
		$styleTitulos = array(
							      'font'  => array(
							          'bold'  => true,
							          'size'  => 8,
							          'name'  => 'Arial'
							      ),
							      'alignment' => array(
							          'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
							          'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
							      ),
								   'fill' => array(
								      'type' => PHPExcel_Style_Fill::FILL_SOLID,
								      'color' => array('rgb' => 'c5d9f1')
								   ),
								   'borders' => array(
								         'allborders' => array(
								             'style' => PHPExcel_Style_Border::BORDER_THIN
								         )
								     ));

       $this->docexcel->getActiveSheet()->getStyle('A1:I1')->applyFromArray($styleTitulos);
		
		//*************************************Cabecera*****************************************
		$this->docexcel->getActiveSheet()->getColumnDimension($this->equivalencias[0])->setWidth(20);		
		$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(0,1,'Nro');
		$this->docexcel->getActiveSheet()->getColumnDimension($this->equivalencias[1])->setWidth(20);
		$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(1,1,'Concepto');
		$this->docexcel->getActiveSheet()->getColumnDimension($this->equivalencias[2])->setWidth(20);
		$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(2,1,'Partida');
		$this->docexcel->getActiveSheet()->getColumnDimension($this->equivalencias[3])->setWidth(20);
		$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(3,1,'Concepto de Gasto');
		$this->docexcel->getActiveSheet()->getColumnDimension($this->equivalencias[4])->setWidth(20);
		$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(4,1,'Justificación');
		$this->docexcel->getActiveSheet()->getColumnDimension($this->equivalencias[5])->setWidth(20);
		$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(5,1,'Unidad de Medida');
		$this->docexcel->getActiveSheet()->getColumnDimension($this->equivalencias[6])->setWidth(20);
		$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(6,1,'Costo Unitario');
		$this->docexcel->getActiveSheet()->getColumnDimension($this->equivalencias[7])->setWidth(20);
		$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(7,1,'Cantidad Requerida');
		$this->docexcel->getActiveSheet()->getColumnDimension($this->equivalencias[8])->setWidth(20);
		$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(8,1,'Total Estacionalidad');
		//*************************************Fin Cabecera*****************************************
		
		$fila = 2;
		$contador = 1;
		
		/////////////////////***********************************Detalle***********************************************
		foreach($datos as $value) {
							
			$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(0,$fila,$contador);
			$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(1,$fila,$value['concepto']);
			$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(2,$fila,"(".$value['codigo_partida'].") ".$value['nombre_partida']);
			$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(3,$fila,$value['desc_ingas']);
			$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(4,$fila,$value['justificacion']);
			$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(5,$fila,$value['unidad_medida']);
			$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(6,$fila,$value['importe_unitario']);
			$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(7,$fila,$value['cantidad_mem']);
			$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(8,$fila,$value['importe']);
			
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