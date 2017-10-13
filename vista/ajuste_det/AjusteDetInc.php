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
Phx.vista.AjusteDetInc = {
    bedit: true,
    bnew: true,
    bsave: false,
    bdel: true,
	require: '../../../sis_presupuestos/vista/ajuste_det/AjusteDet.php',
	requireclase: 'Phx.vista.AjusteDet',
	title: 'Incrementos',
	nombreVista: 'AjusteDetInc',
		
	constructor: function(config) {
		Phx.vista.AjusteDetInc.superclass.constructor.call(this,config);
        this.init();
        var dataPadre = Phx.CP.getPagina(this.idContenedorPadre).getSelectedData()
        if(dataPadre){
            this.onEnablePanel(this, dataPadre);
        }
        else{
           this.bloquearMenus();
        }
       
   },
   //ll
   onReloadPage:function(m){
		this.maestro=m;
        this.store.baseParams={id_ajuste: this.maestro.id_ajuste, tipo_ajuste: 'incremento'};
        
        if(this.maestro.tipo_ajuste == 'inc_comprometido'){
        	this.Cmp.id_presupuesto.store.baseParams.nro_tramite = this.maestro.nro_tramite;
        	this.Cmp.id_presupuesto.store.baseParams.tipo_ajuste = this.maestro.tipo_ajuste;
        	this.Cmp.id_partida.store.baseParams.nro_tramite = this.maestro.nro_tramite;
        	this.Cmp.id_partida.store.baseParams.tipo_ajuste = this.maestro.tipo_ajuste;
        }
        else{
        	delete this.Cmp.id_presupuesto.store.baseParams.nro_tramite;
        	delete this.Cmp.id_presupuesto.store.baseParams.tipo_ajuste;
        	delete this.Cmp.id_partida.store.baseParams.nro_tramite;
        	delete this.Cmp.id_partida.store.baseParams.tipo_ajuste;
        }
       
        
        this.Cmp.id_presupuesto.store.baseParams.id_gestion = this.maestro.id_gestion;
        this.Cmp.id_presupuesto.store.baseParams.movimiento_tipo_pres = this.maestro.movimiento;
        
        this.Cmp.id_partida.store.baseParams.id_gestion = this.maestro.id_gestion;
        this.Cmp.id_partida.store.baseParams.partida_rubro = this.maestro.movimiento;
        this.Cmp.id_presupuesto.modificado = true;
        this.Cmp.id_partida.modificado = true;
        
        
         this.load({params:{start:0, limit:50}});
   },

   
    
   
   loadValoresIniciales:function(){
        Phx.vista.AjusteDetInc.superclass.loadValoresIniciales.call(this);
        this.Cmp.id_ajuste.setValue(this.maestro.id_ajuste);
        this.Cmp.tipo_ajuste.setValue('incremento');        
    
   }
  
    
};
</script>
