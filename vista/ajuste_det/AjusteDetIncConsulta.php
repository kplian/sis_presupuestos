<?php
/**
*@package pXP
*@file gen-SistemaDist.php
*@author  (rensi)
*@date 13-10-2017 10:22:05
*@description Archivo con la interfaz de usuario que permite 
*dar el visto a solicitudes de compra
*
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.AjusteDetIncConsulta = {
    bedit: false,
    bnew: false,
    bsave: false,
    bdel: false,
	require: '../../../sis_presupuestos/vista/ajuste_det/AjusteDet.php',
	requireclase: 'Phx.vista.AjusteDet',
	title: 'Incrementos',
	nombreVista: 'AjusteDetInc',
		
	constructor: function(config) {
		Phx.vista.AjusteDetIncConsulta.superclass.constructor.call(this,config);
        this.init();
        var dataPadre = Phx.CP.getPagina(this.idContenedorPadre).getSelectedData()
        if(dataPadre){
            this.onEnablePanel(this, dataPadre);
        }
        else{
           this.bloquearMenus();
        }
       
   },
  
   onReloadPage:function(m){
		this.maestro=m;
        this.store.baseParams={id_ajuste: this.maestro.id_ajuste, tipo_ajuste: 'incremento'};
        this.load({params:{start:0, limit:50}});
   }
    
};
</script>