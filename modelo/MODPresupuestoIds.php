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
#ISSUE				FECHA				AUTOR				    DESCRIPCION
#2			       20/12/2018	       Miguel Mamani			Replicación de partidas y presupuestos
#4				   03/01/2019	       Miguel Mamani			Relación por gestiones paridas y presupuesto e reporte de presupuesto que no figuran en gestión nueva
#9			       01/02/2019	       Miguel Mamani			MODIFICACIONES PRESUPUESTO CONTABLE CON SALDO QUE NO FIGURAN EN GESTIÓN

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

	///////////////#4///////////////////
    function relacionarPresupuestoIds(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='pre.ft_presupuesto_ids_ime';
        $this->transaccion='PRE_PPR_INS';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_presupuesto_uno','id_presupuesto_uno','int4');
        $this->setParametro('id_presupuesto_dos','id_presupuesto_dos','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
    function reporteMovmiento(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento = 'pre.ft_presupuesto_ids_sel';
        $this->transaccion = 'PRE_RPM_SEL';
        $this->tipo_procedimiento = 'SEL';//tipo de transaccion
        $this->setCount(false);
        $this->setParametro('id_gestion','id_gestion','int4');

        //Definicion de la lista del resultado del query
        $this->captura('id_cuenta','int4');//#9
        $this->captura('nro_cuenta','varchar');//#9
        $this->captura('nombre_cuenta', 'varchar');//#9
        $this->captura('id_centro_costo','int4');
        $this->captura('codigo_tcc','varchar');
        $this->captura('descripcion_tcc', 'varchar');
        $this->captura('importe_debe_mb','numeric');//#9
        $this->captura('importe_haber_mb','numeric');//#9
        $this->captura('saldo_mb','numeric');//#9
        $this->captura('importe_debe_mt','numeric');//#9
        $this->captura('importe_haber_mt','numeric');//#9
        $this->captura('saldo_mt','numeric');//#9
        $this->captura('importe_debe_ma','numeric');//#9
        $this->captura('importe_haber_ma','numeric');//#9
        $this->captura('saldo_ma','numeric');//#9
        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();
       // var_dump($this->respuesta); exit;
        //Devuelve la respuesta
        return $this->respuesta;
    }
    ///////////////#4///////////////////
			
}
?>