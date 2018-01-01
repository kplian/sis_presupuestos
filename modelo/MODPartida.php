<?php
/**
*@package pXP
*@file  MODPartida.php
*@author  Gonzalo Sarmiento Sejas
*@date 23-11-2012 20:06:53
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODPartida extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarPartida(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='pre.ft_partida_sel';
		$this->transaccion='PRE_PAR_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
			
		$this->setParametro('filtro_ges','filtro_ges','varchar');	
		$this->setParametro('id_cuenta','id_cuenta','int4');		
		//Definicion de la lista del resultado del query
		$this->captura('id_partida','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('id_partida_fk','int4');
		$this->captura('tipo','varchar');
		$this->captura('descripcion','varchar');
		$this->captura('codigo','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		
		 $this->captura('nombre_partida','varchar');
		 $this->captura('sw_movimiento','varchar');
		 $this->captura('sw_transaccional','varchar');
		 $this->captura('id_gestion','integer');
		 $this->captura('desc_gestion','integer');
		 
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		//echo $this->consulta;exit;
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
    
    function listarPartidaArb(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='pre.ft_partida_sel';
        $this-> setCount(false);
        $this->transaccion='PRE_PAR_ARB_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion
        
        $id_padre = $this->objParam->getParametro('id_padre');
        
        $this->setParametro('id_padre','id_padre','varchar'); 
		
		$this->setParametro('id_gestion','id_gestion','integer');  
		$this->setParametro('tipo','tipo','varchar');  
		      
        //$this->setParametro('id_subsistema','id_subsistema','integer');
                
        //Definicion de la lista del resultado del query
        $this->captura('id_partida','int4');
        $this->captura('id_partida_fk','int4');
        $this->captura('codigo','varchar');
        $this->captura('tipo','varchar');
        $this->captura('descripcion','varchar');
        $this->captura('tipo_nodo','varchar');
		
		 $this->captura('nombre_partida','varchar');
		 $this->captura('sw_movimiento','varchar');
		 $this->captura('sw_transaccional','varchar');
		 $this->captura('id_gestion','integer');
		 
		 
        
        //Ejecuta la instruccion
        $this->armarConsulta();
        $consulta=$this->getConsulta();
        $this->ejecutarConsulta();
        
        return $this->respuesta;       
    }
			
	function insertarPartida(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pre.ft_partida_ime';
		$this->transaccion='PRE_PAR_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_partida_fk','id_partida_fk','varchar');
	
		$this->setParametro('descripcion','descripcion','varchar');
		$this->setParametro('codigo','codigo','varchar');
		$this->setParametro('tipo','tipo','varchar');
		
		$this->setParametro('id_gestion','id_gestion','integer');  
		$this->setParametro('sw_movimiento','sw_movimiento','varchar'); 
		$this->setParametro('sw_transaccional','sw_transaccional','varchar'); 
		$this->setParametro('nombre_partida','nombre_partida','varchar');
		

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarPartida(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pre.ft_partida_ime';
		$this->transaccion='PRE_PAR_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_partida','id_partida','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_partida_fk','id_partida_fk','varchar');
		
		$this->setParametro('descripcion','descripcion','varchar');
		$this->setParametro('codigo','codigo','varchar');
		
		$this->setParametro('id_gestion','id_gestion','integer');  
		$this->setParametro('tipo','tipo','varchar'); 
		
		$this->setParametro('sw_movimiento','sw_movimiento','varchar'); 
		$this->setParametro('sw_transaccional','sw_transaccional','varchar'); 
		$this->setParametro('nombre_partida','nombre_partida','varchar'); 
		

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarPartida(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pre.ft_partida_ime';
		$this->transaccion='PRE_PAR_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_partida','id_partida','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
	
	function clonarPartidasGestion(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pre.ft_partida_ime';
		$this->transaccion='PRE_CLONAR_IME';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_gestion','id_gestion','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

    function listarPartidaEjecutado(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='pre.f_rep_evaluacion_de_partidas';
        $this->transaccion='REP_PAR_EJE';
        $this->tipo_procedimiento='SEL';//tipo de transaccion
        $this-> setCount(false);
        $this->setTipoRetorno('record');

        $this->setParametro('id_cp_programa','id_cp_programa','int4');
        $this->setParametro('id_categoria_programatica','id_categoria_programatica','int4');
        $this->setParametro('id_partida','id_partida','int4');//nuevo
        $this->setParametro('id_presupuesto','id_presupuesto','int4');
        $this->setParametro('id_gestion','id_gestion','int4');
        $this->setParametro('tipo_pres','tipo_pres','VARCHAR');
        $this->setParametro('tipo_reporte','tipo_reporte','VARCHAR');
        $this->setParametro('nivel','nivel','int4');
        $this->setParametro('fecha_ini','fecha_ini','date');
        $this->setParametro('fecha_fin','fecha_fin','date');
        $this->setParametro('tipo_movimiento','tipo_movimiento','varchar');
       

        $this->captura('id_partida','int4');
        $this->captura('codigo_partida','varchar');
        $this->captura('nombre_partida','varchar');
        $this->captura('nivel_partida','int4');
        $this->captura('cod_prg','varchar');


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

        $this->captura('b1', 'NUMERIC');
        $this->captura('b2', 'NUMERIC');
        $this->captura('b3', 'NUMERIC');
        $this->captura('b4', 'NUMERIC');
        $this->captura('b5', 'NUMERIC');
        $this->captura('b6', 'NUMERIC');
        $this->captura('b7', 'NUMERIC');
        $this->captura('b8', 'NUMERIC');
        $this->captura('b9', 'NUMERIC');
        $this->captura('b10', 'NUMERIC');
        $this->captura('b11', 'NUMERIC');
        $this->captura('b12', 'NUMERIC');

        $this->captura('diferencia1', 'NUMERIC');
        $this->captura('diferencia2', 'NUMERIC');
        $this->captura('diferencia3', 'NUMERIC');
        $this->captura('diferencia4', 'NUMERIC');
        $this->captura('diferencia5', 'NUMERIC');
        $this->captura('diferencia6', 'NUMERIC');
        $this->captura('diferencia7', 'NUMERIC');
        $this->captura('diferencia8', 'NUMERIC');
        $this->captura('diferencia9', 'NUMERIC');
        $this->captura('diferencia10', 'NUMERIC');
        $this->captura('diferencia11', 'NUMERIC');
        $this->captura('diferencia12', 'NUMERIC');

        $this->captura('acumulado1', 'NUMERIC');
        $this->captura('acumulado2', 'NUMERIC');
        $this->captura('acumulado3', 'NUMERIC');
        $this->captura('acumulado4', 'NUMERIC');
        $this->captura('acumulado5', 'NUMERIC');
        $this->captura('acumulado6', 'NUMERIC');
        $this->captura('acumulado7', 'NUMERIC');
        $this->captura('acumulado8', 'NUMERIC');
        $this->captura('acumulado9', 'NUMERIC');
        $this->captura('acumulado10', 'NUMERIC');
        $this->captura('acumulado11', 'NUMERIC');
        $this->captura('acumulado12', 'NUMERIC');


        $this->captura('total_programado', 'NUMERIC');
        $this->captura('importe_aprobado', 'NUMERIC');
        $this->captura('modificaciones', 'NUMERIC');
        $this->captura('total_comp_ejec', 'NUMERIC');



        $this->armarConsulta();
        //echo $this->consulta;exit;
        $this->ejecutarConsulta();
       //var_dump($this->respuesta); exit;
        //Devuelve la respuesta
        return $this->respuesta;
    }

    function listarPartidaEjecutadoTotal(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='pre.f_rep_evaluacion_de_partidas';
        $this->transaccion='REP_PAR_CE';
        $this->tipo_procedimiento='SEL';//tipo de transaccion
        $this-> setCount(false);
        $this->setTipoRetorno('record');
        $this->setParametro('id_cp_programa','id_cp_programa','int4');
        $this->setParametro('id_categoria_programatica','id_categoria_programatica','int4');
        $this->setParametro('id_partida','id_partida','int4');//nuevo
        $this->setParametro('id_presupuesto','id_presupuesto','int4');
        $this->setParametro('id_gestion','id_gestion','int4');
        $this->setParametro('tipo_pres','tipo_pres','VARCHAR');
        $this->setParametro('tipo_reporte','tipo_reporte','VARCHAR');
        $this->setParametro('nivel','nivel','int4');
        $this->setParametro('fecha_ini','fecha_ini','date');
        $this->setParametro('fecha_fin','fecha_fin','date');
        $this->setParametro('tipo_movimiento','tipo_movimiento','varchar');

        $this->captura('id_partida','int4');
        $this->captura('codigo_partida','varchar');
        $this->captura('nombre_partida','varchar');
        $this->captura('nivel_partida','int4');
        $this->captura('cod_prg','varchar');
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
        $this->captura('b1', 'NUMERIC');
        $this->captura('b2', 'NUMERIC');
        $this->captura('b3', 'NUMERIC');
        $this->captura('b4', 'NUMERIC');
        $this->captura('b5', 'NUMERIC');
        $this->captura('b6', 'NUMERIC');
        $this->captura('b7', 'NUMERIC');
        $this->captura('b8', 'NUMERIC');
        $this->captura('b9', 'NUMERIC');
        $this->captura('b10', 'NUMERIC');
        $this->captura('b11', 'NUMERIC');
        $this->captura('b12', 'NUMERIC');
        $this->captura('f1','NUMERIC');
        $this->captura('f2','NUMERIC');
        $this->captura('f3','NUMERIC');
        $this->captura('f4','NUMERIC');
        $this->captura('f5','NUMERIC');
        $this->captura('f6','NUMERIC');
        $this->captura('f7','NUMERIC');
        $this->captura('f8','NUMERIC');
        $this->captura('f9','NUMERIC');
        $this->captura('f10','NUMERIC');
        $this->captura('f11','NUMERIC');
        $this->captura('f12','NUMERIC');

        $this->captura('diferencia_compremetido1','NUMERIC');
        $this->captura('diferencia_compremetido2','NUMERIC');
        $this->captura('diferencia_compremetido3','NUMERIC');
        $this->captura('diferencia_compremetido4','NUMERIC');
        $this->captura('diferencia_compremetido5','NUMERIC');
        $this->captura('diferencia_compremetido6','NUMERIC');
        $this->captura('diferencia_compremetido7','NUMERIC');
        $this->captura('diferencia_compremetido8','NUMERIC');
        $this->captura('diferencia_compremetido9','NUMERIC');
        $this->captura('diferencia_compremetido10','NUMERIC');
        $this->captura('diferencia_compremetido11','NUMERIC');
        $this->captura('diferencia_compremetido12','NUMERIC');

        $this->captura('diferencia_ejecutado1','NUMERIC');
        $this->captura('diferencia_ejecutado2','NUMERIC');
        $this->captura('diferencia_ejecutado3','NUMERIC');
        $this->captura('diferencia_ejecutado4','NUMERIC');
        $this->captura('diferencia_ejecutado5','NUMERIC');
        $this->captura('diferencia_ejecutado6','NUMERIC');
        $this->captura('diferencia_ejecutado7','NUMERIC');
        $this->captura('diferencia_ejecutado8','NUMERIC');
        $this->captura('diferencia_ejecutado9','NUMERIC');
        $this->captura('diferencia_ejecutado10','NUMERIC');
        $this->captura('diferencia_ejecutado11','NUMERIC');
        $this->captura('diferencia_ejecutado12','NUMERIC');

        $this->captura('acumulado_comprendido1','NUMERIC');
        $this->captura('acumulado_comprendido2','NUMERIC');
        $this->captura('acumulado_comprendido3','NUMERIC');
        $this->captura('acumulado_comprendido4','NUMERIC');
        $this->captura('acumulado_comprendido5','NUMERIC');
        $this->captura('acumulado_comprendido6','NUMERIC');
        $this->captura('acumulado_comprendido7','NUMERIC');
        $this->captura('acumulado_comprendido8','NUMERIC');
        $this->captura('acumulado_comprendido9','NUMERIC');
        $this->captura('acumulado_comprendido10','NUMERIC');
        $this->captura('acumulado_comprendido11','NUMERIC');
        $this->captura('acumulado_comprendido12','NUMERIC');

        $this->captura('acumulado_ejecutado1','NUMERIC');
        $this->captura('acumulado_ejecutado2','NUMERIC');
        $this->captura('acumulado_ejecutado3','NUMERIC');
        $this->captura('acumulado_ejecutado4','NUMERIC');
        $this->captura('acumulado_ejecutado5','NUMERIC');
        $this->captura('acumulado_ejecutado6','NUMERIC');
        $this->captura('acumulado_ejecutado7','NUMERIC');
        $this->captura('acumulado_ejecutado8','NUMERIC');
        $this->captura('acumulado_ejecutado9','NUMERIC');
        $this->captura('acumulado_ejecutado10','NUMERIC');
        $this->captura('acumulado_ejecutado11','NUMERIC');
        $this->captura('acumulado_ejecutado12','NUMERIC');


        $this->captura('total_programado', 'NUMERIC');
        $this->captura('importe_aprobado', 'NUMERIC');
        $this->captura('modificaciones', 'NUMERIC');
        $this->captura('total_comprometido', 'NUMERIC');
        $this->captura('total_ejecutado', 'NUMERIC');


        $this->armarConsulta();
        //echo $this->consulta;exit;
        $this->ejecutarConsulta();
        //var_dump($this->respuesta); exit;
        return $this->respuesta;
   }
    function listarPartidaInstitucional(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='pre.f_rep_evaluacion_de_partidas';
        $this->transaccion='REP_PAR_INST';
        $this->tipo_procedimiento='SEL';//tipo de transaccion
        $this-> setCount(false);
        $this->setTipoRetorno('record');

        $this->setParametro('id_cp_programa','id_cp_programa','int4');
        $this->setParametro('id_categoria_programatica','id_categoria_programatica','int4');
        $this->setParametro('id_partida','id_partida','int4');//nuevo
        $this->setParametro('id_presupuesto','id_presupuesto','int4');
        $this->setParametro('id_gestion','id_gestion','int4');
        $this->setParametro('tipo_pres','tipo_pres','VARCHAR');

        $this->setParametro('nivel','nivel','int4');
        $this->setParametro('fecha_ini','fecha_ini','date');
        $this->setParametro('fecha_fin','fecha_fin','date');
        $this->setParametro('tipo_movimiento','tipo_movimiento','varchar');


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
        $this->captura('b1', 'NUMERIC');
        $this->captura('b2', 'NUMERIC');
        $this->captura('b3', 'NUMERIC');
        $this->captura('b4', 'NUMERIC');
        $this->captura('b5', 'NUMERIC');
        $this->captura('b6', 'NUMERIC');
        $this->captura('b7', 'NUMERIC');
        $this->captura('b8', 'NUMERIC');
        $this->captura('b9', 'NUMERIC');
        $this->captura('b10', 'NUMERIC');
        $this->captura('b11', 'NUMERIC');
        $this->captura('b12', 'NUMERIC');
        $this->captura('f1','NUMERIC');
        $this->captura('f2','NUMERIC');
        $this->captura('f3','NUMERIC');
        $this->captura('f4','NUMERIC');
        $this->captura('f5','NUMERIC');
        $this->captura('f6','NUMERIC');
        $this->captura('f7','NUMERIC');
        $this->captura('f8','NUMERIC');
        $this->captura('f9','NUMERIC');
        $this->captura('f10','NUMERIC');
        $this->captura('f11','NUMERIC');
        $this->captura('f12','NUMERIC');

        $this->captura('diferencia_compremetido1','NUMERIC');
        $this->captura('diferencia_compremetido2','NUMERIC');
        $this->captura('diferencia_compremetido3','NUMERIC');
        $this->captura('diferencia_compremetido4','NUMERIC');
        $this->captura('diferencia_compremetido5','NUMERIC');
        $this->captura('diferencia_compremetido6','NUMERIC');
        $this->captura('diferencia_compremetido7','NUMERIC');
        $this->captura('diferencia_compremetido8','NUMERIC');
        $this->captura('diferencia_compremetido9','NUMERIC');
        $this->captura('diferencia_compremetido10','NUMERIC');
        $this->captura('diferencia_compremetido11','NUMERIC');
        $this->captura('diferencia_compremetido12','NUMERIC');

        $this->captura('diferencia_ejecutado1','NUMERIC');
        $this->captura('diferencia_ejecutado2','NUMERIC');
        $this->captura('diferencia_ejecutado3','NUMERIC');
        $this->captura('diferencia_ejecutado4','NUMERIC');
        $this->captura('diferencia_ejecutado5','NUMERIC');
        $this->captura('diferencia_ejecutado6','NUMERIC');
        $this->captura('diferencia_ejecutado7','NUMERIC');
        $this->captura('diferencia_ejecutado8','NUMERIC');
        $this->captura('diferencia_ejecutado9','NUMERIC');
        $this->captura('diferencia_ejecutado10','NUMERIC');
        $this->captura('diferencia_ejecutado11','NUMERIC');
        $this->captura('diferencia_ejecutado12','NUMERIC');

        $this->captura('acumulado_comprendido1','NUMERIC');
        $this->captura('acumulado_comprendido2','NUMERIC');
        $this->captura('acumulado_comprendido3','NUMERIC');
        $this->captura('acumulado_comprendido4','NUMERIC');
        $this->captura('acumulado_comprendido5','NUMERIC');
        $this->captura('acumulado_comprendido6','NUMERIC');
        $this->captura('acumulado_comprendido7','NUMERIC');
        $this->captura('acumulado_comprendido8','NUMERIC');
        $this->captura('acumulado_comprendido9','NUMERIC');
        $this->captura('acumulado_comprendido10','NUMERIC');
        $this->captura('acumulado_comprendido11','NUMERIC');
        $this->captura('acumulado_comprendido12','NUMERIC');

        $this->captura('acumulado_ejecutado1','NUMERIC');
        $this->captura('acumulado_ejecutado2','NUMERIC');
        $this->captura('acumulado_ejecutado3','NUMERIC');
        $this->captura('acumulado_ejecutado4','NUMERIC');
        $this->captura('acumulado_ejecutado5','NUMERIC');
        $this->captura('acumulado_ejecutado6','NUMERIC');
        $this->captura('acumulado_ejecutado7','NUMERIC');
        $this->captura('acumulado_ejecutado8','NUMERIC');
        $this->captura('acumulado_ejecutado9','NUMERIC');
        $this->captura('acumulado_ejecutado10','NUMERIC');
        $this->captura('acumulado_ejecutado11','NUMERIC');
        $this->captura('acumulado_ejecutado12','NUMERIC');


        $this->captura('total_programado', 'NUMERIC');
        $this->captura('importe_aprobado', 'NUMERIC');
        $this->captura('modificaciones', 'NUMERIC');
        $this->captura('total_comprometido', 'NUMERIC');
        $this->captura('total_ejecutado', 'NUMERIC');


        $this->armarConsulta();
        //echo $this->consulta;exit;
        $this->ejecutarConsulta();
        //var_dump($this->respuesta); exit;
        return $this->respuesta;
    }


}
?>








