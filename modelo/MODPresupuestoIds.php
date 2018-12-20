<?php
/**
*@package pXP
*@file gen-MODPresupuestoIds.php
*@author  (miguel.mamani)
*@date 17-12-2018 19:20:26
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/
/**
HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
#2			 20/12/2018	Miguel Mamani			Replicación de partidas y presupuestos
 **/

class MODPresupuestoIds extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarPresupuestoIds(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='pre.ft_presupuesto_ids_sel';
		$this->transaccion='PRE_RPP_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
        
        $this->setParametro('id_gestion','id_gestion','int4');
		//Definicion de la lista del resultado del query
		$this->captura('id_presupuesto_uno','int4');
        $this->captura('id_presupuesto_dos','int4');
        $this->captura('id_categoria_prog','int4');
        $this->captura('id_categoria_prog_dos','int4');
        $this->captura('nro_tramite','varchar');
        $this->captura('nro_tramite_dos','varchar');
        $this->captura('descripcion','varchar');
        $this->captura('descripcion_dos','varchar');
        $this->captura('descripcion_tcc','varchar');
        $this->captura('descripcion_tcc_dos','varchar');
        $this->captura('gestion','int4');
        $this->captura('gestion_dos','int4');
        $this->captura('nombre','varchar');
        $this->captura('nombre_dos','varchar');
        $this->captura('estado_reg','varchar');
        $this->captura('id_usuario_reg','int4');
        $this->captura('fecha_reg','date');
        $this->captura('usr_reg','varchar');
        $this->captura('insercion','varchar');
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarPresupuestoIds(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pre.ft_presupuesto_ids_ime';
		$this->transaccion='PRE_RPP_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_presupuesto_uno','id_presupuesto_uno','int4');
        $this->setParametro('id_gestion_act','id_gestion_act','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

			
	function eliminarPresupuestoIds(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pre.ft_presupuesto_ids_ime';
		$this->transaccion='PRE_RPP_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_presupuesto_uno','id_presupuesto_uno','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>