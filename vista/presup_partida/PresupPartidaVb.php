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
Phx.vista.PresupPartidaVb = {
    bedit: false,
    bnew: false,
    bsave: true,
    bdel: false,
	require:'../../../sis_presupuestos/vista/presup_partida/PresupPartida.php',
	requireclase:'Phx.vista.PresupPartida',
	title:'Partidas',
	nombreVista: 'PresupPartidaVb',
	
	constructor: function(config) {
	    Phx.vista.PresupPartidaVb.superclass.constructor.call(this,config);
        
    },
    preparaMenu:function(){
		var rec = this.sm.getSelected();
		var tb = this.tbar;
		Phx.vista.PresupPartidaVb.superclass.preparaMenu.call(this);
    },
	
    liberaMenu: function() {
		var tb = Phx.vista.PresupPartidaVb.superclass.liberaMenu.call(this);
		
    }

};
</script>
