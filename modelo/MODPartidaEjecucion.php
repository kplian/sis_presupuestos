<?php
/**
*@package pXP
*@file gen-MODPartidaEjecucion.php
*@author  (gvelasquez)
*@date 03-10-2016 15:47:23
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
 * HISTORIAL DE MODIFICACIONES:
 * #11 ETR		  12/02/2019		   MMV Kplian	Reporte Integridad presupuestaria
 * #31 ETR          07/01/2019        RAC KPLIAN     listado de tramties para ajuste de presupeusto ordenado por fecha
 * #37 ENDETR      31/03/2020       JUAN            Reporte ejecución de proyectos con proveedor
   #40 ENDETR      09/07/2020       JUAN            Agregar Numero Tramite a reporte Ejecución de proyectos
   #41 ENDETR     12/07/2020        JJA               Agregar columna tipo_ajuste_formulacion en la tabla de partida ejecucion
   #42  ENDETR    17/07/2020            JJA          Interface que muestre la información de "tipo centro de costo" con todos los parámetros
   #44  ENDETR    23/07/2020        JJA          Mejoras en reporte tipo centro de costo de presupuesto
   #45 ENDETR      26/07/2020       JJA             Agregado de filtros en el reporte de Ejecución de proyectos
   #46 ENDETR      06/08/2020       JJA            Reporte partida en presupuesto
   #PRES-5  ENDETR      10/08/2020       JJA            Mejoras en reporte partida con centros de costo de presupuestos
   #PRES-6  ENDETR      28/09/2020       JJA            Reporte formulacion presupuestaria
   #PRES-7  ENDETR      29/09/2020       JJA         Reporte ejecucion inversion
   #ETR-1599     03/1/2020    JJA       Agregado de filtros en el reporte de Ejecución de proyectos
   #ETR-1632 ENDETR     04/11/2020       JJA         Agregado de tramite y proveedor con movimiento comprometido en el reporte de ejecucion de inversiones
   #PRES-8          13/11/2020      JJA         Reporte partida ejecucion con adquisiciones
   #ETR-1823    ENDETR  17/11/2020     JJA     añadir una vista al detalle con trámites 
   #ETR-1877          22/12/2020      JJA         Reporte memoria de calculo
   #ETR-3221          08/03/2021      JJA         Cambios en filtros del reporte formulacion presupuestaria
*/

class MODPartidaEjecucion extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarPartidaEjecucion(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='pre.ft_partida_ejecucion_sel';
		$this->transaccion='PRE_PAREJE_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		
		$this->setParametro('id_tipo_cc','id_tipo_cc','int4');
		
		$this->capturaCount('total_egreso_mb','numeric');
		$this->capturaCount('total_ingreso_mb','numeric');
		$this->capturaCount('total_monto_anticipo_mb','numeric');
		$this->capturaCount('total_monto_desc_anticipo_mb','numeric');
		$this->capturaCount('total_monto_iva_revertido_mb','numeric');
				
		//Definicion de la lista del resultado del query
		$this->captura('id_partida_ejecucion','int4');
		$this->captura('id_int_comprobante','int4');
		$this->captura('id_moneda','int4');
        $this->captura('moneda','varchar');
		$this->captura('id_presupuesto','int4');
        $this->captura('desc_pres','varchar');
        $this->captura('codigo_categoria','varchar');
		$this->captura('id_partida','int4');
        $this->captura('codigo','varchar');
        $this->captura('nombre_partida','varchar');
		$this->captura('nro_tramite','varchar');
		$this->captura('tipo_cambio','numeric');
		$this->captura('columna_origen','varchar');
		$this->captura('tipo_movimiento','varchar');
		$this->captura('id_partida_ejecucion_fk','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('fecha','date');
		$this->captura('egreso_mb','numeric');
		$this->captura('ingreso_mb','numeric');
		$this->captura('monto_mb','numeric');
		$this->captura('monto','numeric');
		$this->captura('valor_id_origen','int4');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_ai','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');		
		$this->captura('id_tipo_cc','int4');
		$this->captura('desc_tipo_cc','varchar');
		
		$this->captura('nro_cbte','varchar');
		$this->captura('id_proceso_wf','int4');
		
		$this->captura('monto_anticipo_mb','numeric');
		$this->captura('monto_desc_anticipo_mb','numeric');
		$this->captura('monto_iva_revertido_mb','numeric');
		
		$this->captura('glosa1','varchar');		
		$this->captura('glosa','varchar');
		
		$this->captura('cantidad_descripcion','numeric');

        $this->captura('total_pago','numeric');
        $this->captura('desc_contrato','varchar');
        $this->captura('obs','varchar');
        $this->captura('tipo_ajuste_formulacion','varchar'); //#41
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}


   function listarTramitesAjustables(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='pre.ft_partida_ejecucion_sel';
		$this->transaccion='PRE_LISTRAPE_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		
		$this->setParametro('fecha_ajuste','fecha_ajuste','date');
		$this->captura('id_gestion','int4');
        $this->captura('nro_tramite','varchar');
        $this->captura('codigo','varchar');
		$this->captura('id_moneda','int4');
		$this->captura('desc_moneda','varchar');
		
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarPartidaEjecucion(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pre.ft_partida_ejecucion_ime';
		$this->transaccion='PRE_PAREJE_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_int_comprobante','id_int_comprobante','int4');
		$this->setParametro('id_moneda','id_moneda','int4');
		$this->setParametro('id_presupuesto','id_presupuesto','int4');
		$this->setParametro('id_partida','id_partida','int4');
		$this->setParametro('nro_tramite','nro_tramite','varchar');
		$this->setParametro('tipo_cambio','tipo_cambio','numeric');
		$this->setParametro('columna_origen','columna_origen','varchar');
		$this->setParametro('tipo_movimiento','tipo_movimiento','varchar');
		$this->setParametro('id_partida_ejecucion_fk','id_partida_ejecucion_fk','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('fecha','fecha','date');
		$this->setParametro('monto_mb','monto_mb','numeric');
		$this->setParametro('monto','monto','numeric');
		$this->setParametro('valor_id_origen','valor_id_origen','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarPartidaEjecucion(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pre.ft_partida_ejecucion_ime';
		$this->transaccion='PRE_PAREJE_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_partida_ejecucion','id_partida_ejecucion','int4');
		$this->setParametro('id_int_comprobante','id_int_comprobante','int4');
		$this->setParametro('id_moneda','id_moneda','int4');
		$this->setParametro('id_presupuesto','id_presupuesto','int4');
		$this->setParametro('id_partida','id_partida','int4');
		$this->setParametro('nro_tramite','nro_tramite','varchar');
		$this->setParametro('tipo_cambio','tipo_cambio','numeric');
		$this->setParametro('columna_origen','columna_origen','varchar');
		$this->setParametro('tipo_movimiento','tipo_movimiento','varchar');
		$this->setParametro('id_partida_ejecucion_fk','id_partida_ejecucion_fk','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('fecha','fecha','date');
		$this->setParametro('monto_mb','monto_mb','numeric');
		$this->setParametro('monto','monto','numeric');
		$this->setParametro('valor_id_origen','valor_id_origen','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarPartidaEjecucion(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pre.ft_partida_ejecucion_ime';
		$this->transaccion='PRE_PAREJE_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_partida_ejecucion','id_partida_ejecucion','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

	//#11
	function IntegridadPresupuestaria(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pre.ft_partida_ejecucion_sel';
		$this->transaccion='PRE_INPRE_SEL';
		$this->tipo_procedimiento='SEL';
        $this-> setCount(false);

        //Define los parametros para la funcion
        $this->setParametro('id_gestion','id_gestion','int4');
        $this->setParametro('tipo_filtro','tipo_filtro','varchar');

        $this->captura('gestion','int4');
        $this->captura('codigo_techo','varchar');
        $this->captura('control_partida','varchar');
        $this->captura('descripcion_techo','varchar');
        $this->captura('movimiento','varchar');
        $this->captura('total_formulado','numeric');
        $this->captura('total_comprometido','numeric');
        $this->captura('saldo_por_comprometer','numeric');
        $this->captura('total_ejecutado','numeric');
        $this->captura('saldo_por_ejecutar','numeric');
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
        //var_dump($this->respuesta); exit;
		//Devuelve la respuesta
		return $this->respuesta;
	}
    //#11
    function ReporteEjecucionProyecto(){ //#37
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='pre.ft_partida_ejecucion_sel';
        $this->transaccion='PRE_EJEPRO_SEL';
        $this->tipo_procedimiento='SEL';
        $this-> setCount(false);

        $this->captura('ceco_techo','varchar');
        $this->captura('ceco','varchar');
        $this->captura('partida','varchar');
        $this->captura('clas_nivel_1','varchar');
        $this->captura('clas_nivel_2','varchar');
        $this->captura('clas_nivel_3','varchar');
        $this->captura('proveedor','varchar');
        $this->captura('tipo_costo','varchar');
        $this->captura('fecha','date');
        $this->captura('monto_mb','numeric');
        $this->captura('nro_tramite','varchar'); //#40  
        $this->captura('origen','varchar'); 
        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();
        //var_dump($this->respuesta); exit;
        //Devuelve la respuesta
        return $this->respuesta;
    }
	function listarTipoCentroCosto(){ //#42

		$this->procedimiento='pre.ft_partida_ejecucion_sel';
		$this->transaccion='PRE_TCENCOS_SEL';
		$this->tipo_procedimiento='SEL';

		$this->setParametro('id_tipo_cc','id_tipo_cc','int4');
		
		$this->capturaCount('total_mov_egreso_mb','numeric');
		$this->capturaCount('total_mov_ingreso_mb','numeric');
		
        $this->captura('ceco','varchar'); 
        $this->captura('fecha_inicio','date');
        $this->captura('fecha_final','date');
        $this->captura('operativo','varchar');
	    $this->captura('nivel','int4');
	    $this->captura('formulacion_egreso_mb','numeric');
	    $this->captura('formulacion_ingreso_mb','numeric');
        $this->captura('tipo_nodo','varchar');
        $this->captura('mov_ingreso','varchar');
        $this->captura('mov_egreso','varchar');


        $this->captura('control_partida','varchar');
        $this->captura('control_techo','varchar');
	    $this->captura('sueldo_planta','varchar');
	    $this->captura('sueldo_obradet','varchar');
        $this->captura('usuario_reg','varchar');
        $this->captura('usuario_mod','varchar');
        $this->captura('fecha_reg','date');
        $this->captura('fecha_mod','date');
        $this->captura('gestion','int4');
        $this->captura('id_tipo_cc','int4');

        $this->captura('nombre_programa','varchar'); //#44
        $this->captura('nombre_proyecto','varchar'); //#44
        $this->captura('nombre_actividad','varchar');//#44
        $this->captura('nombre_regional','varchar'); //#44
        $this->captura('nombre_financiador','varchar'); //#44

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
    function listarCecoTecho(){ //#45

        $this->procedimiento='pre.ft_partida_ejecucion_sel';
        $this->transaccion='PRE_CETECHO_SEL';
        $this->tipo_procedimiento='SEL';

        $this->captura('id_tipo_cc_techo','int4');
        $this->captura('ceco_techo','varchar');

        $this->armarConsulta();
        $this->ejecutarConsulta();

        return $this->respuesta;
    }
	function ReportePartidaCentroCosto(){ //#46

		$this->procedimiento='pre.ft_partida_ejecucion_sel';
		$this->transaccion='PRE_PARCEN_SEL';
		$this->tipo_procedimiento='SEL';
		
        $this-> setCount(false);

        $this->captura('partida_1','varchar'); //#PRES-5 
		$this->captura('partida_2','varchar'); //#PRES-5 
		$this->captura('partida_3','varchar'); //#PRES-5 
		$this->captura('partida_4','varchar'); //#PRES-5 

        $this->captura('ceco','varchar');
        $this->captura('nivel','int4');
        $this->captura('formulado','numeric');
        $this->captura('reformulado','numeric');
        $this->captura('ajuste','numeric');
        $this->captura('vigente','numeric');
        $this->captura('comprometido','numeric');
        $this->captura('ejecutado','numeric');
        $this->captura('desviacion_comprometido','numeric');
        $this->captura('desviacion_ejecutado','numeric');
        $this->captura('proveedor','varchar');
        $this->captura('nro_tramite','varchar');

        $this->armarConsulta();
        $this->ejecutarConsulta();
        //var_dump($this->respuesta); exit;
        //Devuelve la respuesta
        return $this->respuesta;
	}
	function ReportePartidaCentroCostoSinTramite(){ //#PRES-5 

		$this->procedimiento='pre.ft_partida_ejecucion_sel';
		$this->transaccion='PRE_STPARCEN_SEL';
		$this->tipo_procedimiento='SEL';
		
        $this-> setCount(false);

        $this->captura('partida_1','varchar'); 
		$this->captura('partida_2','varchar'); 
		$this->captura('partida_3','varchar'); 
		$this->captura('partida_4','varchar'); 

        $this->captura('ceco','varchar');
        $this->captura('nivel','int4');
        $this->captura('formulado','numeric');
        $this->captura('reformulado','numeric');
        $this->captura('ajuste','numeric');
        $this->captura('vigente','numeric');
        $this->captura('comprometido','numeric');
        $this->captura('ejecutado','numeric');
        $this->captura('desviacion_comprometido','numeric');
        $this->captura('desviacion_ejecutado','numeric');
        $this->captura('proveedor','varchar');

        $this->armarConsulta();
        $this->ejecutarConsulta();
        //var_dump($this->respuesta); exit;
        //Devuelve la respuesta
        return $this->respuesta;
	}
	function AnalisisImputacionTipoCentroCosto(){//#PRES-5 

		$this->procedimiento='pre.ft_partida_ejecucion_sel';
		$this->transaccion='PRE_AITCENCOS_SEL';
		$this->tipo_procedimiento='SEL';

		$this->setParametro('id_tipo_cc','id_tipo_cc','int4');
		$this->setParametro('id_gestion','id_gestion','int4');
		
		$this->capturaCount('total_mov_egreso_mb','numeric');
		$this->capturaCount('total_mov_ingreso_mb','numeric');
		
        $this->captura('ceco','varchar'); 
        $this->captura('fecha_inicio','date');
        $this->captura('fecha_final','date');
        $this->captura('operativo','varchar');
	    $this->captura('nivel','int4');
	    $this->captura('formulacion_egreso_mb','numeric');
	    $this->captura('formulacion_ingreso_mb','numeric');
        $this->captura('tipo_nodo','varchar');
        $this->captura('mov_ingreso','varchar');
        $this->captura('mov_egreso','varchar');


        $this->captura('control_partida','varchar');
        $this->captura('control_techo','varchar');
	    $this->captura('sueldo_planta','varchar');
	    $this->captura('sueldo_obradet','varchar');
        $this->captura('usuario_reg','varchar');
        $this->captura('usuario_mod','varchar');
        $this->captura('fecha_reg','date');
        $this->captura('fecha_mod','date');
        $this->captura('gestion','int4');
        $this->captura('id_tipo_cc','int4');

        $this->captura('nombre_programa','varchar'); 
        $this->captura('nombre_proyecto','varchar'); 
        $this->captura('nombre_actividad','varchar');
        $this->captura('nombre_regional','varchar'); 
        $this->captura('nombre_financiador','varchar'); 

        $this->captura('id_centro_costo','int4'); //#PRES-5
        $this->captura('id_gestion','int4'); //#PRES-5

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
	function AnalisisImputacionPartida(){ //#PRES-5 

		$this->procedimiento='pre.ft_partida_ejecucion_sel';
		$this->transaccion='PRE_AJUIMPPART_SEL';
		$this->tipo_procedimiento='SEL';

		$this->setParametro('id_tipo_cc','id_tipo_cc','int4');
		$this->setParametro('id_gestion','id_gestion','int4'); //#PRES-5
		
        $this->captura('id_partida','int4'); 
        $this->captura('partida','varchar');
        $this->captura('nivel','int4');
        $this->captura('filtro_tipo_cc','varchar');//##ETR-1823
        $this->captura('id_gestion','int4'); //##ETR-1823
	    $this->captura('formulado','numeric');
	    $this->captura('comprometido','numeric');
	    $this->captura('por_comprometer','numeric');
        $this->captura('ejecutado','numeric');
        $this->captura('por_ejecutar','numeric');
        

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
    function ReporteFormulacionPresupuestaria(){ //#PRES-6 

		$this->procedimiento='pre.ft_partida_ejecucion_sel';
		$this->transaccion='PRE_RFORPRESUP_SEL';
		$this->tipo_procedimiento='SEL';

		$this->setParametro('id_tipo_cc','id_tipo_cc','int4');
		$this->setParametro('tipo_formulacion','tipo_formulacion','varchar'); //#PRES-6 
		
        $this-> setCount(false);
        

        $this->captura('id_tipo_cc_techo','int4');
        $this->captura('periodo','varchar'); 
        $this->captura('tipo','varchar'); 
        $this->captura('ceco_techo','varchar'); 
        $this->captura('importe','numeric');
        $this->captura('estado_presupuesto','varchar'); 
        $this->captura('tipo_formulacion','varchar'); 
        $this->captura('estado_ajuste','varchar'); 
        $this->captura('gestion','varchar'); 
        $this->captura('origen','varchar');
        $this->captura('ceco_transaccional','varchar'); //#ETR-3221
        $this->captura('partida','varchar'); //#ETR-3221

        $this->armarConsulta();
        $this->ejecutarConsulta();
   
        //Devuelve la respuesta
        return $this->respuesta;
    }
    function ReporteResumenFormulacionPresupuestaria(){ //#PRES-6 

		$this->procedimiento='pre.ft_partida_ejecucion_sel';
		$this->transaccion='PRE_RFORPRESUP_SEL';
		$this->tipo_procedimiento='SEL';

		$this->setParametro('id_tipo_cc','id_tipo_cc','int4');
		$this->setParametro('tipo_formulacion','tipo_formulacion','varchar'); 
		
        $this-> setCount(false);
        
        $this->captura('ceco_techo','varchar');
        $this->captura('formulacion','numeric'); 
        $this->captura('reformulacion','numeric'); 
        $this->captura('traspaso','numeric'); 
        $this->captura('en_blanco','numeric');

        $this->armarConsulta();
        $this->ejecutarConsulta();
  // var_dump($this->consulta);
        //Devuelve la respuesta
        return $this->respuesta;
    }
    function ReporteEjecucionInversion(){ //#PRES-7 

		$this->procedimiento='pre.ft_partida_ejecucion_sel';
		$this->transaccion='PRE_REJEINVER_SEL';
		$this->tipo_procedimiento='SEL';

		$this->setParametro('origen','origen','varchar');

        $this-> setCount(false);
        

        $this->captura('ceco_techo','varchar');
        $this->captura('gestion','int4');
        $this->captura('periodo','varchar'); 
        $this->captura('origen','varchar'); 
        $this->captura('monto_mb','numeric');
        $this->captura('nombre_actividad','varchar'); 
        $this->captura('nombre_proyecto','varchar'); 
        $this->captura('nro_tramite','varchar'); //#ETR-1632
        $this->captura('proveedor','varchar'); //#ETR-1632

        $this->armarConsulta();
        $this->ejecutarConsulta();
   
        //Devuelve la respuesta
        return $this->respuesta;
    }
    function Ejecucion_centro_costo_componente(){//#PRES-8 
		$this->procedimiento='pre.ft_partida_ejecucion_sel';
		$this->transaccion='PRE_REJEDETCOMP_SEL';
		$this->tipo_procedimiento='SEL';

        $this->setCount(false);        

        $this->captura('monto_mb','numeric');
        $this->captura('partida_homologada','varchar');
        $this->captura('codigo_proceso','varchar'); 
        $this->captura('ceco','varchar'); 
        $this->captura('cantidad_adju','numeric');
        $this->captura('unidad_medida','varchar'); 
        $this->captura('proveedor','varchar'); 
        $this->captura('proveedor_costo_indirecto','varchar'); 
        $this->captura('id_gestion','int4'); 
        $this->captura('gestion','varchar'); 
        $this->captura('periodo','varchar'); 
        $this->captura('tipo_costo','varchar'); 
        $this->captura('descripcion','varchar'); 
        $this->captura('nro_tramite','varchar'); 
        $this->captura('tipo_tramite','varchar'); 
        $this->captura('tipo_partida','varchar'); 
        $this->captura('id_tipo_cc_techo','int4');  
        
        $this->armarConsulta();
        $this->ejecutarConsulta();
        //var_dump($this->respuesta); exit;
        //Devuelve la respuesta
        return $this->respuesta;
    }
	function AnalisisImputacionPartidaDetalle(){//#ETR-1823

		$this->procedimiento='pre.ft_partida_ejecucion_sel';
		$this->transaccion='PRE_AIMPPARTDET_SEL';
		$this->tipo_procedimiento='SEL';

        $this->setParametro('filtro_tipo_cc','filtro_tipo_cc','varchar');
		$this->setParametro('id_partida','id_partida','int4');
		$this->setParametro('id_gestion','id_gestion','int4'); 
		
        $this->captura('id_partida','int4'); 
        $this->captura('partida','varchar');

        $this->captura('nivel','int4');
        $this->captura('nro_tramite','varchar');

	    $this->captura('formulado','numeric');
	    $this->captura('comprometido','numeric');
	    $this->captura('por_comprometer','numeric');
        $this->captura('ejecutado','numeric');
        $this->captura('por_ejecutar','numeric');
        

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
    function reporteEjecucion(){ //#ETR-1890

        $this->procedimiento='pre.ft_partida_ejecucion_sel';
        $this->transaccion='PRE_REJECUPRES_SEL';
        $this->tipo_procedimiento='SEL';
        $this-> setCount(false);

		  $this->setParametro('id_tipo_cc','id_tipo_cc','int4');  
		  $this->setParametro('id_gestion','id_gestion','int4');
		  $this->setParametro('fecha_ini','fecha_ini','date');
		  $this->setParametro('fecha_fin','fecha_fin','date');
		  $this->setParametro('tipo_reporte','tipo_reporte','varchar');
		  

		$this->captura('partida','varchar');
		
		$this->captura('nro_tramite','varchar');
        $this->captura('formulado','numeric');
        $this->captura('comprometido','numeric');

        $this->captura('enero','numeric');
        $this->captura('febrero','numeric');
        $this->captura('marzo','numeric');
        $this->captura('abril','numeric');
        $this->captura('mayo','numeric');
        $this->captura('junio','numeric');
        $this->captura('julio','numeric');
        $this->captura('agosto','numeric');
        $this->captura('septiembre','numeric');
        $this->captura('octubre','numeric');
        $this->captura('noviembre','numeric');
        $this->captura('diciembre','numeric');
        $this->captura('ejecutado','numeric');
        $this->captura('porcentaje_eje_form','numeric'); 
        $this->captura('porcentaje_eje_comp','numeric'); 
        $this->captura('sw_transaccional','varchar');
        
        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();	
        //var_dump($this->consulta); exit;
        //Devuelve la respuesta
        return $this->respuesta;


	}
    function reporteEjecucionAgrupado(){ //#ETR-1890

        $this->procedimiento='pre.ft_partida_ejecucion_sel';
        $this->transaccion='PRE_REJPREAGR_SEL';
        $this->tipo_procedimiento='SEL';
        $this-> setCount(false);

		  $this->setParametro('id_tipo_cc','id_tipo_cc','int4');  
		  $this->setParametro('id_gestion','id_gestion','int4');
		  $this->setParametro('fecha_ini','fecha_ini','date');
		  $this->setParametro('fecha_fin','fecha_fin','date');
		  $this->setParametro('tipo_reporte','tipo_reporte','varchar');
		  

		$this->captura('partida','varchar');
		
        $this->captura('formulado','numeric');
        $this->captura('comprometido','numeric');

        $this->captura('enero','numeric');
        $this->captura('febrero','numeric');
        $this->captura('marzo','numeric');
        $this->captura('abril','numeric');
        $this->captura('mayo','numeric');
        $this->captura('junio','numeric');
        $this->captura('julio','numeric');
        $this->captura('agosto','numeric');
        $this->captura('septiembre','numeric');
        $this->captura('octubre','numeric');
        $this->captura('noviembre','numeric');
        $this->captura('diciembre','numeric');
        $this->captura('ejecutado','numeric');
        $this->captura('porcentaje_eje_form','numeric'); 
        $this->captura('porcentaje_eje_comp','numeric'); 
        $this->captura('sw_transaccional','varchar');
        
        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();	
        //var_dump($this->consulta); exit;
        //Devuelve la respuesta
        return $this->respuesta;


	}
    function ReporteFormulacionPeriodo(){ //#ETR-1877

        $this->procedimiento='pre.ft_partida_ejecucion_sel';
        $this->transaccion='PRE_RFORMUPERIO_SEL';
        $this->tipo_procedimiento='SEL';
        $this-> setCount(false);

		$this->setParametro('id_tipo_cc','id_tipo_cc','int4');  
		$this->setParametro('id_gestion','id_gestion','int4');
		$this->setParametro('tipo_reporte','tipo_reporte','varchar');
		$this->setParametro('tipo_formulacion','tipo_formulacion','varchar');
		$this->setParametro('periodicidad','periodicidad','varchar');
		$this->setParametro('tipo_partida','tipo_partida','varchar');

		$this->captura('partida','varchar');
        $this->captura('sw_transaccional','varchar');
        $this->captura('obs','varchar');

        $this->captura('enero','numeric');
        $this->captura('febrero','numeric');
        $this->captura('marzo','numeric');
        $this->captura('abril','numeric');
        $this->captura('mayo','numeric');
        $this->captura('junio','numeric');
        $this->captura('julio','numeric');
        $this->captura('agosto','numeric');
        $this->captura('septiembre','numeric');
        $this->captura('octubre','numeric');
        $this->captura('noviembre','numeric');
        $this->captura('diciembre','numeric');
        $this->captura('formulado','numeric');
        $this->captura('nivel','varchar');
        
        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();	
        //var_dump($this->consulta); exit;
        //Devuelve la respuesta
        return $this->respuesta;


	}
}
?>