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
        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();
        //var_dump($this->respuesta); exit;
        //Devuelve la respuesta
        return $this->respuesta;
    }
}
?>