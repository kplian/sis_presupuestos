<?php
/**
*@package pXP
*@file gen-SistemaDist.php
*@author  (fprudencio)
*@date 20-09-2011 10:22:05
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.ConceptoIngasDir = {
	require:'../../../sis_parametros/vista/concepto_ingas/ConceptoIngas.php',
	requireclase:'Phx.vista.ConceptoIngas',
	title:'Concepto Ingas',
	nombreVista: 'concetoIngasDir',
	bdel: true,
	bedit: true,
	bnew: true,
	constructor: function(config) {
		Phx.vista.ConceptoIngasDir.superclass.constructor.call(this,config);
		this.init();
		this.load({params:{start:0, limit:50}});
		
	},
	
	tabsouth:[
	      { 
		  url:'../../../sis_presupuestos/vista/concepto_partida/ConceptoPartida.php',
		  title:'Partidas', 
		  height:'50%',
		  cls:'ConceptoPartida'
		 },
	     {
		  url:'../../../sis_presupuestos/vista/concepto_cta/ConceptoCta.php',
		  title:'Hijos', 
		  height:'50%',
		  cls:'ConceptoCta'
		 },
	
	   ]
	
	
	
};
</script>
