<?php
/**
*@package pXP
*@file gen-MODPresupuestoPartidaEntidad.php
*@author  (franklin.espinoza)
*@date 21-07-2017 12:58:43
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODPresupuestoPartidaEntidad extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarPresupuestoPartidaEntidad(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='pre.ft_presupuesto_partida_entidad_sel';
		$this->transaccion='PRE_P_P_ENT_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_presupuesto_partida_entidad','int4');
		$this->captura('id_partida','int4');
		$this->captura('id_gestion','int4');
		$this->captura('id_entidad_transferencia','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('id_presupuesto','int4');
		$this->captura('id_usuario_ai','int4');
		$this->captura('id_usuario_reg','int4');
		$this->captura('usuario_ai','varchar');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('desc_partida','varchar');
		$this->captura('desc_gestion','varchar');
		$this->captura('desc_entidad_tranferencia','varchar');
		$this->captura('desc_presupuesto','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarPresupuestoPartidaEntidad(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pre.ft_presupuesto_partida_entidad_ime';
		$this->transaccion='PRE_P_P_ENT_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_partida','id_partida','int4');
		$this->setParametro('id_gestion','id_gestion','int4');
		$this->setParametro('id_entidad_transferencia','id_entidad_transferencia','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_presupuesto','id_presupuesto','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarPresupuestoPartidaEntidad(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pre.ft_presupuesto_partida_entidad_ime';
		$this->transaccion='PRE_P_P_ENT_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_presupuesto_partida_entidad','id_presupuesto_partida_entidad','int4');
		$this->setParametro('id_partida','id_partida','int4');
		$this->setParametro('id_gestion','id_gestion','int4');
		$this->setParametro('id_entidad_transferencia','id_entidad_transferencia','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_presupuesto','id_presupuesto','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarPresupuestoPartidaEntidad(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pre.ft_presupuesto_partida_entidad_ime';
		$this->transaccion='PRE_P_P_ENT_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_presupuesto_partida_entidad','id_presupuesto_partida_entidad','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

    function validarCampos(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='pre.ft_presupuesto_partida_entidad_ime';
        $this->transaccion='PRE_P_P_ENT_VAL';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_partida','id_partida','int4');
        $this->setParametro('id_entidad_transferencia','id_entidad_transferencia','int4');
        $this->setParametro('id_presupuesto','id_presupuesto','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
			
}
?>