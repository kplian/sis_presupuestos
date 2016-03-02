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
Phx.vista.PresupPartidaForm = {
    bedit: false,
    bnew: false,
    bsave: false,
    bdel: false,
	require:'../../../sis_presupuestos/vista/presup_partida/PresupPartida.php',
	requireclase:'Phx.vista.PresupPartida',
	title:'Partidas',
	nombreVista: 'PresupPartidaForm',
	
	constructor: function(config) {
	    
        Phx.vista.PresupPartidaForm.superclass.constructor.call(this,config);
   },
   preparaMenu:function(){
		var rec = this.sm.getSelected();
		var tb = this.tbar;
		Phx.vista.PresupPartidaForm.superclass.preparaMenu.call(this);
			
		
		
	},
	
	liberaMenu: function() {
		var tb = Phx.vista.PresupPartidaForm.superclass.liberaMenu.call(this);
		
	}
	
};
</script>
