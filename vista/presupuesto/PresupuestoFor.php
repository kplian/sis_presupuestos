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
Phx.vista.PresupuestoFor = {
    bedit:false,
    bnew:false,
    bsave:false,
    bdel:false,
	require:'../../../sis_presupuestos/vista/presupuesto/Presupuesto.php',
	requireclase:'Phx.vista.Presupuesto',
	title:'Presupuesto',
	nombreVista: 'PresupuestoFor',
	
	
	constructor: function(config) {
	   var me = this; 
	   Phx.vista.PresupuestoFor.superclass.constructor.call(this,config);
	   
       this.init();
       this.load({params:{start:0, limit:this.tam_pag, tipo_interfaz: me.nombreVista }}) 
   },
   
   preparaMenu:function(n){
          var data = this.getSelectedData();
          var tb =this.tbar;
          
          Phx.vista.PresupuestoFor.superclass.preparaMenu.call(this,n);
          
           if(data['sw_consolidado'] == 'si'){
          	  this.TabPanelEast.get(1).enable();
          }
          else{
          	  this.TabPanelEast.get(1).disable();
          	  this.TabPanelEast.setActiveTab(0)
          }
          
           
    },
    
    liberaMenu:function(){
        var tb = Phx.vista.PresupuestoFor.superclass.liberaMenu.call(this);
        
        return tb
    },
   
   
   tabeast:[

		   /*{
			   url:'../../../sis_presupuestos/vista/presupuesto_objetivo/PresupuestoObjetivoForm.php',
			   title:'Objetivos',
			   width:'50%',
			   cls:'PresupuestoObjetivoForm'
		   },*/
	       {
    		  url:'../../../sis_presupuestos/vista/presup_partida/PresupPartidaForm.php',
    		  title:'Partidas', 
    		  width:'50%',
    		  cls:'PresupPartidaForm'
		  },
		  {
    		  url:'../../../sis_presupuestos/vista/rel_pre/RelPreFor.php',
    		  title:'Composición', 
    		  width:'50%',
    		  cls:'RelPreFor'
		  }]
   
   
    
   
    
   
    
};
</script>
