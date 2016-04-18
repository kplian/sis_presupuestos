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
Phx.vista.PresupPartidaAprobacion = {
    bedit: false,
    bnew: false,
    bsave: true,
    bdel: false,
	require:'../../../sis_presupuestos/vista/presup_partida/PresupPartida.php',
	requireclase:'Phx.vista.PresupPartida',
	title:'Partidas',
	nombreVista: 'PresupPartidaAprobacion',
	
	constructor: function(config) {
	    
	    
        this.Atributos[this.getIndAtributo('importe_aprobado')].egrid=true; 
        
        Phx.vista.PresupPartidaAprobacion.superclass.constructor.call(this,config);
        
        //Crea el botón para iniciar tramite
		this.addButton('btnIniTra',
			{
				grupo:[0],
				text: 'Autorizar %',
				iconCls: 'bchecklist',
				disabled: false,
				handler: this.verificarPresupuesto,
				tooltip: '<b>Autorizar Presupuesto</b><br/>Define el porcentaje autorizado '
			});
   },
   preparaMenu:function(){
		var rec = this.sm.getSelected();
		var tb = this.tbar;
		Phx.vista.PresupPartidaAprobacion.superclass.preparaMenu.call(this);
   },
	
   liberaMenu: function() {
		var tb = Phx.vista.PresupPartidaAprobacion.superclass.liberaMenu.call(this);
		
   },
	
   verificarPresupuesto: function(){
   	        
   	        if(confirm('¿Está seguro, se sobre escribira cualquier cambio?')){
   	        	
   	        	var selection, sw = true;
   	        	do{
				    var selection = window.prompt("Introduzca un porcentaje entre 1 y 200", 100);
				    var sw = selection?isNaN(selection):false;
				    
				    console.log('......',selection, sw  , parseInt(selection, 10) > 200 , parseInt(selection, 10) < 1)
				    
				}while(  sw  || parseInt(selection, 10) > 200 || parseInt(selection, 10) < 1);
   	        	
   	        	   	 if(selection){
   	        	   	 	Phx.CP.loadingShow(); 
				   	        Ext.Ajax.request({
								url: '../../sis_presupuestos/control/PresupPartida/verificarPresupuesto',
							  	params: {
							  		  id_presupuesto: this.maestro.id_presupuesto,
							  		  porcentaje_aprobado: parseInt(selection)
							      },
							      success: this.successRep,
							      failure: this.conexionFailure,
							      timeout: this.timeout,
							      scope: this
							});
   	        	   	
   	        	   	 }
		   	        	   	
   	        	    
		}
    },
    
    successRep:function(resp){
        
        Phx.CP.loadingHide();
        var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
        if(!reg.ROOT.error){
            this.reload();
            
           
        }else{
            alert('Ocurrió un error durante el proceso')
        }
        
	}
	
};
</script>
