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
        this.load({params:{start:0, limit:this.tam_pag}}); 
    	this.iniciarEventos();
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
          
   },
    
    iniciarEventos:function(){
	        //inicio de eventos 
	        this.Cmp.fecha.on('change',function(f){
	        	this.Cmp.nro_tramite_aux.reset();
	        	this.Cmp.nro_tramite_aux.modificado = true;
	        	this.Cmp.nro_tramite_aux.store.baseParams.fecha_ajuste = this.Cmp.fecha.getValue().dateFormat(this.Cmp.fecha.format);
	             
	             },this);
             
           this.Cmp.tipo_ajuste.on('select',function(cmp,rec){        	
           	   
           	   if(this.Cmp.tipo_ajuste.getValue() == 'inc_comprometido' || this.Cmp.tipo_ajuste.getValue() == 'rev_comprometido'){
                	 this.mostrarComponente(this.Cmp.nro_tramite_aux);
                }
                else{
                	 this.ocultarComponente(this.Cmp.nro_tramite_aux);
                }
           	
           },this);
      
    },
     onButtonEdit:function(){
       var rec = this.getSelectedData();
       Phx.vista.AjusteInicio.superclass.onButtonEdit.call(this);
       
       if(this.Cmp.tipo_ajuste.getValue() == 'inc_comprometido' || this.Cmp.tipo_ajuste.getValue() == 'rev_comprometido'){
            this.mostrarComponente(this.Cmp.nro_tramite_aux);
       }
       else{
           this.ocultarComponente(this.Cmp.nro_tramite_aux);
       }
       this.Cmp.nro_tramite_aux.disable();
       this.Cmp.tipo_ajuste.disable();
       this.Cmp.fecha.disable();
    },
     onButtonNew:function(){
	       //abrir formulario de solicitud
	     var me = this;
	     Phx.vista.AjusteInicio.superclass.onButtonNew.call(this);
	     this.Cmp.nro_tramite_aux.enable();
	     this.Cmp.tipo_ajuste.enable();
         this.Cmp.fecha.enable();
	     this.mostrarComponente(this.Cmp.nro_tramite_aux);
		   
	}    
};
</script>