<?php
/**
*@package pXP
*@file gen-MODPresupPartida.php
*@author  (admin)
*@date 29-02-2016 19:40:34
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/
class MODPresupPartida extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarPresupPartida(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='pre.ft_presup_partida_sel';
		$this->transaccion='PRE_PRPA_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		
		$this->capturaCount('total_importe','numeric');
		$this->capturaCount('total_importe_aprobado','numeric');
		
				
		//Definicion de la lista del resultado del query
		$this->captura('id_presup_partida','int4');
		$this->captura('tipo','varchar');
		$this->captura('id_moneda','int4');
		$this->captura('id_partida','int4');
		$this->captura('id_centro_costo','int4');
		$this->captura('fecha_hora','timestamp');
		$this->captura('estado_reg','varchar');
		$this->captura('id_presupuesto','int4');
		$this->captura('importe','numeric');
		$this->captura('id_usuario_ai','int4');
		$this->captura('usuario_ai','varchar');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_reg','int4');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('desc_partida','varchar');
		$this->captura('desc_gestion','varchar');
		$this->captura('importe_aprobado','numeric');
		
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}

    function listarPresupPartidaEstado(){
			//Definicion de variables para ejecucion del procedimientp
			$this->procedimiento='pre.ft_presup_partida_sel';
			$this->transaccion='PRE_PRPAEST_SEL';
			$this->tipo_procedimiento='SEL';//tipo de transaccion
			
			$this->capturaCount('total_importe','numeric');
			$this->capturaCount('total_importe_aprobado','numeric');
			$this->capturaCount('total_importe_formulado','numeric');
			$this->capturaCount('total_importe_comprometido','numeric');
			$this->capturaCount('total_importe_ejecutado','numeric');
			$this->capturaCount('total_importe_pagado','numeric');
			
					
			//Definicion de la lista del resultado del query
			$this->captura('id_presup_partida','int4');
			$this->captura('tipo','varchar');
			$this->captura('id_moneda','int4');
			$this->captura('id_partida','int4');
			$this->captura('id_centro_costo','int4');
			$this->captura('fecha_hora','timestamp');
			$this->captura('estado_reg','varchar');
			$this->captura('id_presupuesto','int4');
			$this->captura('importe','numeric');
			
			
			$this->captura('desc_partida','varchar');
			$this->captura('desc_gestion','varchar');
			$this->captura('importe_aprobado','numeric');
			$this->captura('formulado','numeric');
			$this->captura('comprometido','numeric');
			$this->captura('ejecutado','numeric');
			$this->captura('pagado','numeric');
			
			$this->captura('ajustado','numeric');
			$this->captura('porc_ejecucion','numeric');
			
			
			
			
			
			//Ejecuta la instruccion
			$this->armarConsulta();
			$this->ejecutarConsulta();
			
			//Devuelve la respuesta
			return $this->respuesta;
	}
		
			
	function insertarPresupPartida(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pre.ft_presup_partida_ime';
		$this->transaccion='PRE_PRPA_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('tipo','tipo','varchar');
		$this->setParametro('id_moneda','id_moneda','int4');
		$this->setParametro('id_partida','id_partida','int4');
		$this->setParametro('id_centro_costo','id_centro_costo','int4');
		$this->setParametro('fecha_hora','fecha_hora','timestamp');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_presupuesto','id_presupuesto','int4');
		$this->setParametro('importe','importe','numeric');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarPresupPartida(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pre.ft_presup_partida_ime';
		$this->transaccion='PRE_PRPA_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_presup_partida','id_presup_partida','int4');
		$this->setParametro('importe_aprobado','importe_aprobado','numeric');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarPresupPartida(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pre.ft_presup_partida_ime';
		$this->transaccion='PRE_PRPA_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_presup_partida','id_presup_partida','int4');
       // $this->setParametro('id_partida','id_partida','int4');

        //Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

  function verificarPresupuesto(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pre.ft_presup_partida_ime';
		$this->transaccion='PRE_PREPARVER_IME';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_presupuesto','id_presupuesto','int4');
		$this->setParametro('porcentaje_aprobado','porcentaje_aprobado','int4');
		
		

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
  
  function listarPresupPartidaEstadoXNroTramite(){
			//Definicion de variables para ejecucion del procedimientp
			$this->procedimiento='pre.ft_presup_partida_sel';
			$this->transaccion='PRE_ETPRENRO_SEL';
			$this->tipo_procedimiento='SEL';//tipo de transaccion
			
			$this->capturaCount('total_importe_comprometido','numeric');
			$this->capturaCount('total_importe_ejecutado','numeric');
			$this->capturaCount('total_importe_pagado','numeric');
			
			
			$this->captura('id_presup_partida','int4');
            $this->captura('id_partida','int4');
            $this->captura('id_presupuesto','int4');
            $this->captura('desc_partida','text');
            $this->captura('id_centro_costo','int4');
            $this->captura('codigo_cc','TEXT');
            $this->captura('id_gestion','int4');
            $this->captura('id_uo','int4');
            $this->captura('id_ep','int4');
            $this->captura('tipo_pres','varchar');
            $this->captura('nro_tramite','varchar');
            $this->captura('comprometido','numeric');
            $this->captura('ejecutado','numeric');
            $this->captura('pagado','numeric');
			
			
			//Ejecuta la instruccion
			$this->armarConsulta();
			$this->ejecutarConsulta();
			
			//Devuelve la respuesta
			return $this->respuesta;
	}

	function listarPresupPartidaComprometidoXNroTramiteRendicion(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='pre.ft_presup_partida_sel';
		$this->transaccion='PRE_PRENROREN_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion

		$this->setParametro('nro_tramite','nro_tramite','varchar');

		$this->capturaCount('total_importe_comprometido','numeric');
		$this->capturaCount('total_importe_ejecutado','numeric');
		$this->capturaCount('total_importe_pagado','numeric');


		$this->captura('id_presup_partida','int4');
		$this->captura('id_partida','int4');
		$this->captura('id_presupuesto','int4');
		$this->captura('desc_partida','text');
		$this->captura('id_centro_costo','int4');
		$this->captura('codigo_cc','TEXT');
		$this->captura('id_gestion','int4');
		$this->captura('id_uo','int4');
		$this->captura('id_ep','int4');
		$this->captura('tipo_pres','varchar');
		$this->captura('nro_tramite','varchar');
		$this->captura('comprometido','numeric');
		$this->captura('ejecutado','numeric');
		$this->captura('pagado','numeric');


		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

    function listarRepEjecucion(){
		  	
		  //Definicion de variables para ejecucion del procedimientp
		  $this->procedimiento='pre.f_rep_ejecucion';
		  $this->transaccion='PRE_EJECUCION_REP';
		  $this->tipo_procedimiento='SEL';//tipo de transaccion
		  $this->setCount(false);
		  $this->setTipoRetorno('record');	
		
		  //captura parametros adicionales para el count
		  $this->setParametro('id_cp_programa','id_cp_programa','int4');
		  $this->setParametro('id_categoria_programatica','id_categoria_programatica','int4');
		  $this->setParametro('id_presupuesto','id_presupuesto','int4');
		  $this->setParametro('id_gestion','id_gestion','int4');
		  $this->setParametro('tipo_pres','tipo_pres','VARCHAR');
		  $this->setParametro('tipo_reporte','tipo_reporte','VARCHAR');
		  $this->setParametro('nivel','nivel','int4');
		  $this->setParametro('fecha_ini','fecha_ini','date');
		  $this->setParametro('fecha_fin','fecha_fin','date');
		  
		 
		
		//Definicion de la lista del resultado del query
		$this->captura('id_partida','int4');
        $this->captura('codigo_partida','varchar');
        $this->captura('nombre_partida','varchar');
        $this->captura('nivel_partida','int4');
       
        $this->captura('importe','NUMERIC');
        $this->captura('importe_aprobado','NUMERIC');
        $this->captura('formulado','NUMERIC');
        $this->captura('comprometido','NUMERIC');
        $this->captura('ejecutado','NUMERIC');
        $this->captura('pagado','NUMERIC');
        $this->captura('ajustado','NUMERIC');
        $this->captura('porc_ejecucion','NUMERIC');
		  
		              
		

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}

    function listarRepEjecucionPorPartida(){
		  	
		  //Definicion de variables para ejecucion del procedimientp
		  $this->procedimiento='pre.f_rep_ejecucion';
		  $this->transaccion='PRE_EJEXPAR_REP';
		  $this->tipo_procedimiento='SEL';//tipo de transaccion
		  $this->setCount(false);
		  $this->setTipoRetorno('record');	
		
		  //captura parametros adicionales para el count
		 
		  $this->setParametro('id_categoria_programatica','id_categoria_programatica','int4');
		  $this->setParametro('id_partida','id_partida','int4');
		  $this->setParametro('tipo_pres','tipo_pres','VARCHAR');
		  $this->setParametro('tipo_reporte','tipo_reporte','VARCHAR');
		  $this->setParametro('fecha_ini','fecha_ini','date');
		  $this->setParametro('fecha_fin','fecha_fin','date');
		  
		  //Definicion de la lista del resultado del query
		  $this->captura('id_presupuesto','int4');
	      $this->captura('codigo_cc','text');
	      $this->captura('importe','NUMERIC');
	      $this->captura('importe_aprobado','NUMERIC');
	      $this->captura('formulado','NUMERIC');
	      $this->captura('comprometido','NUMERIC');
	      $this->captura('ejecutado','NUMERIC');
	      $this->captura('pagado','NUMERIC');
        
		              
		

		 //Ejecuta la instruccion
		 $this->armarConsulta();
		 $this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
    function ejecucionGestionAnterior(){

        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='pre.f_rep_ejecucion_wf';
        $this->transaccion='PRE_PROGRA_WF';
        $this->tipo_procedimiento='SEL';//tipo de transaccion
        $this->setCount(false);
        $this->setTipoRetorno('record');

        //captura parametros adicionales para el count
        $this->setParametro('id_proceso_wf','id_proceso_wf','int4');

        //Definicion de la lista del resultado del query
        $this->captura('id_partida','int4');
        $this->captura('codigo_partida','varchar');
        $this->captura('nombre_partida','varchar');
        $this->captura('nivel_partida','int4');
        $this->captura('descripcion','varchar');
        $this->captura('gestion','int4');
        $this->captura('c1','NUMERIC');
        $this->captura('c2','NUMERIC');
        $this->captura('c3','NUMERIC');
        $this->captura('c4','NUMERIC');
        $this->captura('c5','NUMERIC');
        $this->captura('c6','NUMERIC');
        $this->captura('c7','NUMERIC');
        $this->captura('c8','NUMERIC');
        $this->captura('c9','NUMERIC');
        $this->captura('c10','NUMERIC');
        $this->captura('c11','NUMERIC');
        $this->captura('c12','NUMERIC');
        $this->captura('total','NUMERIC');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();
       // var_dump($this->respuesta); exit;
        //Devuelve la respuesta
        return $this->respuesta;
    }
    function memoriaGestionAnterior(){

        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='pre.f_rep_ejecucion_wf';
        $this->transaccion='PRE_MEMORIA_WF';
        $this->tipo_procedimiento='SEL';//tipo de transaccion
        $this->setCount(false);
        $this->setTipoRetorno('record');

        //captura parametros adicionales para el count
        $this->setParametro('id_proceso_wf','id_proceso_wf','int4');

        //Definicion de la lista del resultado del query
        $this->captura('id_partida','int4');
        $this->captura('codigo_partida','varchar');
        $this->captura('nombre_partida','varchar');
        $this->captura('nivel_partida','int4');
        $this->captura('descripcion','varchar');
        $this->captura('gestion','int4');
        $this->captura('m1','NUMERIC');
        $this->captura('m2','NUMERIC');
        $this->captura('m3','NUMERIC');
        $this->captura('m4','NUMERIC');
        $this->captura('m5','NUMERIC');
        $this->captura('m6','NUMERIC');
        $this->captura('m7','NUMERIC');
        $this->captura('m8','NUMERIC');
        $this->captura('m9','NUMERIC');
        $this->captura('m10','NUMERIC');
        $this->captura('m11','NUMERIC');
        $this->captura('m12','NUMERIC');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();
        // var_dump($this->respuesta); exit;
        //Devuelve la respuesta
        return $this->respuesta;
    }
			
}
?>