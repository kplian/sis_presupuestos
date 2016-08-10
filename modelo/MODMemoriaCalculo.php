<?php
/**
*@package pXP
*@file gen-MODMemoriaCalculo.php
*@author  (admin)
*@date 01-03-2016 14:22:24
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODMemoriaCalculo extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarMemoriaCalculo(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='pre.ft_memoria_calculo_sel';
		$this->transaccion='PRE_MCA_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_memoria_calculo','int4');
		$this->captura('id_concepto_ingas','int4');
		$this->captura('importe_total','numeric');
		$this->captura('obs','varchar');
		$this->captura('id_presupuesto','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('id_usuario_ai','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		
		$this->captura('desc_ingas','varchar');
		$this->captura('id_partida','int4');
		$this->captura('desc_partida','varchar');
		$this->captura('desc_gestion','varchar');
		
		
		
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarMemoriaCalculo(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pre.ft_memoria_calculo_ime';
		$this->transaccion='PRE_MCA_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_concepto_ingas','id_concepto_ingas','int4');
		$this->setParametro('importe_total','importe_total','numeric');
		$this->setParametro('obs','obs','varchar');
		$this->setParametro('id_presupuesto','id_presupuesto','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarMemoriaCalculo(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pre.ft_memoria_calculo_ime';
		$this->transaccion='PRE_MCA_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_memoria_calculo','id_memoria_calculo','int4');
		$this->setParametro('id_concepto_ingas','id_concepto_ingas','int4');
		$this->setParametro('importe_total','importe_total','numeric');
		$this->setParametro('obs','obs','varchar');
		$this->setParametro('id_presupuesto','id_presupuesto','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarMemoriaCalculo(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pre.ft_memoria_calculo_ime';
		$this->transaccion='PRE_MCA_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_memoria_calculo','id_memoria_calculo','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
	
	function listarRepMemoriaCalculo(){
		  //Definicion de variables para ejecucion del procedimientp
		  $this->procedimiento='pre.ft_memoria_calculo_sel';
		  $this->transaccion='PRE_MEMCAL_REP';
		  $this->tipo_procedimiento='SEL';//tipo de transaccion
		  $this->setCount(false);	
		
		  //captura parametros adicionales para el count
		  $this->setParametro('id_cp_programa','id_cp_programa','int4');
		  $this->setParametro('id_categoria_programatica','id_categoria_programatica','int4');
		  $this->setParametro('id_presupuesto','id_presupuesto','int4');
		  $this->setParametro('id_gestion','id_gestion','int4');
		  $this->setParametro('tipo_pres','tipo_pres','VARCHAR');
		  $this->setParametro('tipo_reporte','tipo_reporte','VARCHAR');
		  $this->setParametro('id_partida','id_partida','int4');
		
		  //Definicion de la lista del resultado del query
		 $this->captura('id_concepto','int4');
         $this->captura('concepto','VARCHAR');
		 
		 $this->captura('id_concepto_ingas','int4');
         $this->captura('id_partida','int4');
         $this->captura('codigo_partida','varchar');
         $this->captura('nombre_partida','varchar');
		 $this->captura('descripcion_pres','varchar');
         $this->captura('desc_ingas','varchar');
         $this->captura('justificacion','varchar');
         $this->captura('unidad_medida','varchar');
         $this->captura('importe_unitario','NUMERIC');
         $this->captura('cantidad_mem','NUMERIC');
         $this->captura('importe','NUMERIC');
		  
		              
		

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}

    function listarRepProgramacion(){
		  //Definicion de variables para ejecucion del procedimientp
		  $this->procedimiento='pre.f_rep_programacion';
		  $this->transaccion='PRE_PROGR_REP';
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
		  
		 
		
		//Definicion de la lista del resultado del query
		$this->captura('id_partida','int4');
        $this->captura('codigo_partida','varchar');
        $this->captura('nombre_partida','varchar');
        $this->captura('nivel_partida','int4');
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
		  
		              
		

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>