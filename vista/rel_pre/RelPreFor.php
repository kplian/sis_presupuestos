<?php
/**
*@package pXP
*@file gen-SistemaDist.php
*@author  (fprudencio)
*@date 20-09-2011 10:22:05
*@description Archivo con la interfaz de usuario que permite 
*dar el visto a solicitudes de compra
*
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.RelPreFor = {
    bedit: false,
    bnew: false,
    bsave: false,
    bdel: false,
	require: '../../../sis_presupuestos/vista/rel_pre/RelPre.php',
	requireclase: 'Phx.vista.RelPre',
	title: 'Composición',
	nombreVista: 'RelPreFor',	
	
	constructor: function(config) {
	    Phx.vista.RelPreFor.superclass.constructor.call(this,config);
	    this.addButton('btnConsolidado',
			{
				grupo:[0],
				text: 'Consolidar',
				iconCls: 'bchecklist',
				disabled: false,
				handler: this.consolidaPresupuesto,
				tooltip: '<b>Consolida presupuesto</b><br/>Copia las memoria de calculo es esta relación hacia el presupuesto oficial '
			});
        
    },
    
    consolidaPresupuesto: function(){
   	        var data=this.sm.getSelected().data;
   	        Phx.CP.loadingShow(); 
   	        Ext.Ajax.request({
				url: '../../sis_presupuestos/control/RelPre/consolidarRelPre',
			  	params: {
			  		  id_rel_pre: data.id_rel_pre
			      },
			      success: this.successRep,
			      failure: this.conexionFailure,
			      timeout: this.timeout,
			      scope: this
			});
   	        	   	
   	},
   	
   	preparaMenu:function(){
		var rec = this.sm.getSelected();
		var tb = this.tbar;
		Phx.vista.RelPreFor.superclass.preparaMenu.call(this);
		if (rec.data.estado == 'borrador'){
			this.getBoton('btnConsolidado').enable(); 
		}
		else{
			this.getBoton('btnConsolidado').disable(); 
		}
		
   },
	
   liberaMenu: function() {
		var tb = Phx.vista.RelPreFor.superclass.liberaMenu.call(this);
		this.getBoton('btnConsolidado').disable(); 
		return tb;
   },
   
   successRep:function(resp){
        Phx.CP.loadingHide();
        this.reload();
   }
   
    
};
</script>
