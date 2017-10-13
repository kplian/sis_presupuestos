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
Phx.vista.AjusteVb = {
    bedit: true,
    bnew: false,
    bsave: false,
    bdel: true,
	require: '../../../sis_presupuestos/vista/ajuste/Ajuste.php',
	requireclase: 'Phx.vista.Ajuste',
	title: 'Ajustes Presupuestarios',
	nombreVista: 'AjusteVb',	
	constructor: function(config) {
	    Phx.vista.AjusteVb.superclass.constructor.call(this,config);
        this.init();
        this.store.baseParams.tipo_interfaz = this.nombreVista;
        this.load({params:{start:0, limit:50}});
  },
  preparaMenu:function(n){
          var data = this.getSelectedData();
          var tb =this.tbar;
          
          Phx.vista.AjusteVb.superclass.preparaMenu.call(this,n);
          
          if (data['estado']!= 'aprobado'){
              	 this.getBoton('fin_registro').enable();
          }
          
          if (data['estado']!= 'borrador' && data['estado']!= 'aprobado'){
             this.getBoton('ant_estado').enable(); 
          }
          
          this.getBoton('btnObs').enable();    
          this.getBoton('btnChequeoDocumentosWf').enable(); 
          this.getBoton('diagrama_gantt').enable();
          
          
          if (data['tipo_ajuste'] == 'incremento' || data['tipo_ajuste'] == 'inc_comprometido'){ 
          	this.disableTabDecrementos();
          }
          else {
          	if (data['tipo_ajuste'] == 'decremento' || data['tipo_ajuste'] == 'rev_comprometido'){ 
          	  this.disableTabIncrementos();
            }
            else{
            	this.enableAllTab();
            }
          }
          
          if (data['tipo_ajuste'] == 'rev_comprometido' || data['tipo_ajuste'] == 'inc_comprometido'){
          	 this.getBoton('chkpresupuesto').enable();
          } 
          else{
          	 this.getBoton('chkpresupuesto').disable();
          }
          
          
    }
    
};
</script>
