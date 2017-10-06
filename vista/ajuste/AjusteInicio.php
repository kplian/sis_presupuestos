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
Phx.vista.AjusteInicio = {
    bedit: true,
    bnew: true,
    bsave: false,
    bdel: true,
	require: '../../../sis_presupuestos/vista/ajuste/Ajuste.php',
	requireclase: 'Phx.vista.Ajuste',
	title: 'Ajustes Presupuestarios',
	nombreVista: 'AjusteInicio',	
	
	swEstado : 'borrador',
    gruposBarraTareas:[{name:'borrador',title:'<H1 align="center"><i class="fa fa-thumbs-o-down"></i> Borradores</h1>', grupo:0,height:0},
                        {name:'en_proceso',title:'<H1 align="center"><i class="fa fa-eye"></i> En Proceso</h1>', grupo:1,height:0},
                        {name:'finalizados',title:'<H1 align="center"><i class="fa fa-file-o"></i> Finalizados</h1>', grupo:2,height:0}],
	
     beditGroups: [0,1,2],     
     bactGroups:  [0,1,2],
     btestGroups: [0],
     bexcelGroups: [0,1,2],
	
	constructor: function(config) {
	    Phx.vista.AjusteInicio.superclass.constructor.call(this,config);
        this.init();
       
        
        this.store.baseParams={tipo_interfaz:this.nombreVista, estado : 'borrador'};
        //this.store.baseParams.pes_estado = 'borrador';
    	this.load({params:{start:0, limit:this.tam_pag}});
    	
    	 this.finCons = true;
        
   },
   validarFiltros:function(){
      
        return true;
   },
   
   getParametrosFiltro: function(){
       
        this.store.baseParams.estado = this.swEstado;
        this.store.baseParams.tipo_interfaz = this.nombreVista;
     
  
    },
   
    capturaFiltros:function(combo, record, index){
        
		this.desbloquearOrdenamientoGrid();
        this.getParametrosFiltro();
        this.load( { params:{start:0, limit:50 } });
		
			
			
	},
	
	actualizarSegunTab: function(name, indice){
        this.swEstado = name;
		if(this.finCons){
	    	if(this.validarFiltros()){            
	            this.getParametrosFiltro();
	            this.load({params:{start:0, limit:this.tam_pag}});
	         }
	   }
    },
    
    
	
	onButtonAct:function(){
       
        if(!this.validarFiltros()){
            alert('Especifique los filtros antes')
         }
        else{
            this.getParametrosFiltro();
            Phx.vista.AjusteInicio.superclass.onButtonAct.call(this);
        }
   },
   
   preparaMenu:function(n){
          var data = this.getSelectedData();
          var tb =this.tbar;
       
          Phx.vista.AjusteInicio.superclass.preparaMenu.call(this,n);
          
          if (data['estado']== 'borrador'){
              	 this.getBoton('fin_registro').enable();
              	  this.getBoton('ant_estado').disable();
          }
          
          if (data['estado']!= 'borrador'){
             this.getBoton('edit').disable(); 
             this.getBoton('del').disable();
             this.getBoton('new').disable();
          }
          
          
          
          this.getBoton('btnObs').enable();    
          this.getBoton('btnChequeoDocumentosWf').enable(); 
          this.getBoton('diagrama_gantt').enable();
          
          
          if (data['tipo_ajuste'] == 'incremento'){ 
          	this.disableTabDecrementos();
          }
          else {
          	if (data['tipo_ajuste'] == 'decremento'){ 
          	  this.disableTabIncrementos();
            }
            else{
            	this.enableTabIncrementos();
            	this.enableTabDecrementos();
            }
          }
          
          
    }
    
};
</script>