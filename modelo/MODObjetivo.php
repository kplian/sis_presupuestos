<?php
/**
*@package pXP
*@file gen-MODObjetivo.php
*@author  (gvelasquez)
*@date 20-07-2016 20:37:41
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODObjetivo extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarObjetivo(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='pre.ft_objetivo_sel';
		$this->transaccion='PRE_OBJ_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_objetivo','int4');
		$this->captura('id_objetivo_fk','int4');
		$this->captura('nivel_objetivo','int4');
		$this->captura('sw_transaccional','varchar');
		$this->captura('cantidad_verificacion','numeric');
		$this->captura('unidad_verificacion','varchar');
		$this->captura('ponderacion','numeric');
		$this->captura('fecha_inicio','date');
		$this->captura('tipo_objetivo','varchar');
		$this->captura('descripcion','varchar');
		$this->captura('linea_base','varchar');
		$this->captura('estado_reg','varchar');
		$this->captura('id_parametros','int4');
		$this->captura('indicador_logro','varchar');
		$this->captura('id_gestion','int4');
		$this->captura('codigo','varchar');
		$this->captura('periodo_ejecucion','varchar');
		$this->captura('producto','varchar');
		$this->captura('fecha_fin','date');
		$this->captura('fecha_reg','timestamp');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('id_usuario_ai','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
        $this->captura('detalle_descripcion','varchar');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
	
	function listarObjetivoArb(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='pre.ft_objetivo_sel';
        $this-> setCount(false);
        $this->transaccion='PRE_OBJ_ARB_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion
        
        $id_padre = $this->objParam->getParametro('id_padre');
        
        $this->setParametro('id_padre','id_padre','varchar'); 
		
		$this->setParametro('id_gestion','id_gestion','integer'); 
		      
        //$this->setParametro('id_subsistema','id_subsistema','integer');
                
        //Definicion de la lista del resultado del query
        $this->captura('id_objetivo','int4');
        $this->captura('id_objetivo_fk','int4');
        $this->captura('codigo','varchar');
        //$this->captura('tipo','varchar');
        $this->captura('descripcion','varchar');
        $this->captura('tipo_nodo','varchar');
		
		 //$this->captura('nombre_partida','varchar');
		 //$this->captura('sw_movimiento','varchar');
		 $this->captura('sw_transaccional','varchar');
		 $this->captura('id_gestion','integer');
		 
		 $this->captura('nivel_objetivo','int4');
		//$this->captura('sw_transaccional','varchar');
		$this->captura('cantidad_verificacion','numeric');
		$this->captura('unidad_verificacion','varchar');
		$this->captura('ponderacion','numeric');
		$this->captura('fecha_inicio','date');
		$this->captura('tipo_objetivo','varchar');
		//$this->captura('descripcion','varchar');
		$this->captura('linea_base','varchar');
		$this->captura('estado_reg','varchar');
		$this->captura('id_parametros','int4');
		$this->captura('indicador_logro','varchar');
		//$this->captura('id_gestion','int4');
		//$this->captura('codigo','varchar');
		$this->captura('periodo_ejecucion','varchar');
		$this->captura('producto','varchar');
		$this->captura('fecha_fin','date');
		$this->captura('fecha_reg','timestamp');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('id_usuario_ai','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		 
		 
        
        //Ejecuta la instruccion
        $this->armarConsulta();
        $consulta=$this->getConsulta();
        $this->ejecutarConsulta();
        
        return $this->respuesta;       
    }
			
	function insertarObjetivo(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pre.ft_objetivo_ime';
		$this->transaccion='PRE_OBJ_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_objetivo_fk','id_objetivo_fk','varchar');
		$this->setParametro('nivel_objetivo','nivel_objetivo','int4');
		$this->setParametro('sw_transaccional','sw_transaccional','varchar');
		$this->setParametro('cantidad_verificacion','cantidad_verificacion','numeric');
		$this->setParametro('unidad_verificacion','unidad_verificacion','varchar');
		$this->setParametro('ponderacion','ponderacion','numeric');
		$this->setParametro('fecha_inicio','fecha_inicio','date');
		$this->setParametro('tipo_objetivo','tipo_objetivo','varchar');
		$this->setParametro('descripcion','descripcion','varchar');
		$this->setParametro('linea_base','linea_base','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_parametros','id_parametros','int4');
		$this->setParametro('indicador_logro','indicador_logro','varchar');
		$this->setParametro('id_gestion','id_gestion','int4');
		$this->setParametro('codigo','codigo','varchar');
		$this->setParametro('periodo_ejecucion','periodo_ejecucion','varchar');
		$this->setParametro('producto','producto','varchar');
		$this->setParametro('fecha_fin','fecha_fin','date');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarObjetivo(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pre.ft_objetivo_ime';
		$this->transaccion='PRE_OBJ_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_objetivo','id_objetivo','int4');
		$this->setParametro('id_objetivo_fk','id_objetivo_fk','varchar');
		$this->setParametro('nivel_objetivo','nivel_objetivo','int4');
		$this->setParametro('sw_transaccional','sw_transaccional','varchar');
		$this->setParametro('cantidad_verificacion','cantidad_verificacion','numeric');
		$this->setParametro('unidad_verificacion','unidad_verificacion','varchar');
		$this->setParametro('ponderacion','ponderacion','numeric');
		$this->setParametro('fecha_inicio','fecha_inicio','date');
		$this->setParametro('tipo_objetivo','tipo_objetivo','varchar');
		$this->setParametro('descripcion','descripcion','varchar');
		$this->setParametro('linea_base','linea_base','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_parametros','id_parametros','int4');
		$this->setParametro('indicador_logro','indicador_logro','varchar');
		$this->setParametro('id_gestion','id_gestion','int4');
		$this->setParametro('codigo','codigo','varchar');
		$this->setParametro('periodo_ejecucion','periodo_ejecucion','varchar');
		$this->setParametro('producto','producto','varchar');
		$this->setParametro('fecha_fin','fecha_fin','date');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarObjetivo(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pre.ft_objetivo_ime';
		$this->transaccion='PRE_OBJ_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_objetivo','id_objetivo','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
    function ReportePOA(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='pre.ft_objetivo_sel';
        $this-> setCount(false);
        $this->transaccion='PRE_OBJ_REPT';
        $this->tipo_procedimiento='SEL';//tipo de transaccion

        //captura parametros adicionales para el count
        $this->setParametro('id_gestion','id_gestion','int4');

        $this->captura('codigo','varchar');
        $this->captura('nivel_objetivo','int4');
       // $this->captura('sw_transaccional','varchar');
        //$this->captura('cantidad_verificacion','numeric');
        //$this->captura('unidad_verificacion','varchar');
       // $this->captura('ponderacion','numeric');
       // $this->captura('fecha_inicio','date');
       // $this->captura('tipo_objetivo','varchar');
        $this->captura('descripcion','varchar');
        //$this->captura('linea_base','varchar');
        //$this->captura('indicador_logro','varchar');
        //$this->captura('periodo_ejecucion','varchar');
        //$this->captura('producto','varchar');
        //$this->captura('fecha_fin','date');
       // $this->captura('gestion','int4');
        //Ejecuta la instruccion
        $this->captura('nivel_preuspuesto','int4');
        $this->captura('presupuesto','varchar');

        $this->armarConsulta();
        $this->ejecutarConsulta();
        //var_dump( $this->respuesta);exit;
        return $this->respuesta;
    }
			
}
?>