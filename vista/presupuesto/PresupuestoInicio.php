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
Phx.vista.PresupuestoInicio = {
    bedit:true,
    bnew:true,
    bsave:false,
    bdel:true,
	require:'../../../sis_presupuestos/vista/presupuesto/Presupuesto.php',
	requireclase:'Phx.vista.Presupuesto',
	title:'Presupuesto',
	nombreVista: 'PresupuestoInicio',
	
	swEstado : 'borrador',
    gruposBarraTareas:[{name:'borrador',title:'<H1 align="center"><i class="fa fa-thumbs-o-down"></i> Borradores</h1>', grupo:0,height:0},
                       {name:'en_proceso',title:'<H1 align="center"><i class="fa fa-eye"></i> En Proceso</h1>', grupo:1,height:0},
                       {name:'finalizados',title:'<H1 align="center"><i class="fa fa-file-o"></i> Finalizados</h1>', grupo:2,height:0}],
	
     beditGroups: [0,1,2],     
     bactGroups:  [0,1,2],
     btestGroups: [0],
     bexcelGroups: [0,1,2],
	
	
	constructor: function(config) {
	    this.initButtons=[this.cmbGestion, this.cmbTipoPres];
	    Phx.vista.PresupuestoInicio.superclass.constructor.call(this,config);
        this.bloquearOrdenamientoGrid();
	    this.cmbGestion.on('select', function(){
		    if(this.validarFiltros()){
                  this.capturaFiltros();
           }
		},this);
		
		this.bloquearOrdenamientoGrid();
		this.cmbTipoPres.on('clearcmb', function() {this.DisableSelect();this.store.removeAll();}, this);
		this.cmbTipoPres.on('valid', function() {this.capturaFiltros();}, this);
		//Crea el botón para llamar a la replicación
		this.addButton('btnRepRelCon',{grupo:[2],text: 'Duplicar Presupuestos',iconCls: 'bchecklist',disabled: false,handler: this.duplicarPresupuestos,tooltip: '<b>Duplicar presupuestos </b><br/>Duplicar presupuestos para la siguiente gestión'});
		this.addButton('btnIniTra',{grupo:[0],text: 'Iniciar',iconCls: 'bchecklist',disabled: true,handler: this.iniTramite,tooltip: '<b>Iniciar Trámite</b><br/>Inicia el trámite de formulación para el presupuesto'});
        this.addButton('btnClo',{
            text :'Clonar Formulacio',
            grupo:[1],
            iconCls : 'bfolder',
            disabled: true,
            handler : this.onClonar,
            tooltip : '<b>Clonar Formulacion</b>'
        });
	   
		this.init();
		this.TabPanelEast.get(2).disable();
        this.finCons = true; 
        
        
        this.iniciarEventos();
   },
   
   iniciarEventos: function(){
   	      this.Cmp.id_tipo_cc.on('select',function(cmp, rec, ind){
   	      	   this.Cmp.descripcion.setValue('('+rec.data.codigo+') ' + rec.data.descripcion);
   	      	   this.Cmp.tipo_pres.store.baseParams.mov_pres = rec.data.mov_pres;
   	      	   this.Cmp.tipo_pres.store.modificado = true;
   	      	   
   	      	   
   	      }, this)
		
   },
	
	onButtonEdit:function(){
	         if(this.validarFiltros()){  
			         var rec = this.sm.getSelected().data;
			         Phx.vista.PresupuestoInicio.superclass.onButtonEdit.call(this);			         
			         this.Cmp.id_tipo_cc.store.baseParams.gestion = this.cmbGestion.getRawValue();
					 this.Cmp.id_tipo_cc.modificado = true;
	         }
	       
       },
       
   onButtonNew: function(){
           if(this.validarFiltros()){           	
	           	Phx.vista.PresupuestoInicio.superclass.onButtonNew.call(this);          
	            this.Cmp.id_gestion.setValue(this.cmbGestion.getValue());
			 	this.Cmp.id_tipo_cc.reset();
			    this.Cmp.id_tipo_cc.store.baseParams.gestion = this.cmbGestion.getRawValue();
			    this.Cmp.id_tipo_cc.modificado = true;
		      
		 }
          
    },
	
	
	
   
  
   cmbGestion: new Ext.form.ComboBox({
				fieldLabel: 'Gestion',
				grupo:[0,1,2],
				allowBlank: false,
				emptyText:'Gestion...',
				store:new Ext.data.JsonStore(
				{
					url: '../../sis_parametros/control/Gestion/listarGestion',
					id: 'id_gestion',
					root: 'datos',
					sortInfo:{
						field: 'gestion',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_gestion','gestion'],
					// turn on remote sorting
					remoteSort: true,
					baseParams:{par_filtro:'gestion'}
				}),
				valueField: 'id_gestion',
				triggerAction: 'all',
				displayField: 'gestion',
			    hiddenName: 'id_gestion',
    			mode:'remote',
				pageSize:50,
				queryDelay:500,
				listWidth:'280',
				width:80
			}),	
	
	cmbTipoPres: new Ext.form.AwesomeCombo({
				fieldLabel: 'Tipo',
				grupo:[0,1,2],
				allowBlank: false,
				emptyText:'Filtro...',
				store : new Ext.data.JsonStore({
							url:'../../sis_presupuestos/control/TipoPresupuesto/listarTipoPresupuesto',
							id : 'codigo',
							root: 'datos',
							sortInfo:{
									field: 'codigo',
									direction: 'ASC'
							},
							totalProperty: 'total',
							fields: ['codigo', 'nombre', 'movimiento'],
							remoteSort: true,
							baseParams: { par_filtro:'nombre' }
				}),
				valueField : 'codigo',
			    displayField : 'nombre',
			    hiddenName : 'codigo',
				enableMultiSelect : true,
				triggerAction : 'all',
				lazyRender : true,
				mode : 'remote',
				pageSize : 20,
				width : 150,
				anchor : '80%',
				listWidth : '280',
				resizable : true,
				minChars : 2
			}),	
	
	validarFiltros:function(){
        if(this.cmbGestion.isValid() && this.cmbTipoPres.validate()){
            return true;
        }
        else{
            return false;
        }
        
    },
    
    getParametrosFiltro: function(){
    	this.store.baseParams.id_gestion=this.cmbGestion.getValue();
        this.store.baseParams.codigos_tipo_pres = this.cmbTipoPres.getValue();
        this.store.baseParams.estado = this.swEstado;
        this.store.baseParams.tipo_interfaz = this.nombreVista;
    },
	
	capturaFiltros:function(combo, record, index){
		
		this.desbloquearOrdenamientoGrid();
        this.getParametrosFiltro();
        this.load({params:{start:0, limit:50}});
		
		
	},
	
	actualizarSegunTab: function(name, indice){
		this.swEstado = name;
    	if(this.validarFiltros()){
            this.getParametrosFiltro();
            Phx.vista.Presupuesto.superclass.onButtonAct.call(this);
        }
    },
	
	onButtonAct:function(){
        if(!this.validarFiltros()){
            alert('Especifique los filtros antes')
         }
        else{
            this.getParametrosFiltro();
            Phx.vista.Presupuesto.superclass.onButtonAct.call(this);
        }
    },
    
    duplicarPresupuestos: function(){
		if(this.cmbGestion.getValue()){
			Phx.CP.loadingShow(); 
	   		Ext.Ajax.request({
				url: '../../sis_presupuestos/control/Presupuesto/clonarPresupuestosGestion',
			  	params:{
			  		id_gestion: this.cmbGestion.getValue()
			      },
			      success:this.successRep,
			      failure: this.conexionFailure,
			      timeout:this.timeout,
			      scope:this
			});
		}
		else{
			alert('primero debe selecionar la gestion origen');
		}
   		
   },
   iniTramite: function(){
   	        var rec = this.sm.getSelected();
		    Phx.CP.loadingShow(); 
	   		Ext.Ajax.request({
				url: '../../sis_presupuestos/control/Presupuesto/iniciarTramite',
			  	params:{
			  		id_presupuesto: rec.data.id_presupuesto
			      },
			      success:this.successRep,
			      failure: this.conexionFailure,
			      timeout:this.timeout,
			      scope:this
			});
		
   		
   },
   
   successRep:function(resp){
        Phx.CP.loadingHide();
        var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
        if(!reg.ROOT.error){
            this.reload();
            if(reg.ROOT.datos.observaciones){
               alert(reg.ROOT.datos.observaciones)
            }
           
        }else{
            alert('Ocurrió un error durante el proceso')
        }
	},
	
	
	onButtonPartes:function() {
            var rec=this.sm.getSelected();
            Phx.CP.loadWindows('../../../sis_presupuestos/vista/rel_pre/RelPre.php',
                    'Composición del Presupuesto',
                    {
                        width:'60%',
                        height:'60%'
                    },
                    rec.data,
                    this.idContenedor,
                    'RelPre');
    },
    
    preparaMenu:function(n){
          var data = this.getSelectedData();
          var tb =this.tbar;
          
          Phx.vista.PresupuestoInicio.superclass.preparaMenu.call(this,n);
          if(data['estado'] == 'aprobado' || data['estado'] == 'preparado'){
          	 this.getBoton('btnRepRelCon').enable();
          }
          else{
          	 this.getBoton('btnRepRelCon').disable();
          }
          
          if(data['estado'] == 'borrador'){
          	 this.getBoton('btnIniTra').enable();
          }
          else{
          	 this.getBoton('btnIniTra').disable();
          }
          
           if(data['sw_consolidado'] == 'si'){
          	  this.TabPanelEast.get(2).enable();
          }
          else{
          	  this.TabPanelEast.get(2).disable();
          	  this.TabPanelEast.setActiveTab(0)
          }
          
         
     		     
          
    },
    
    liberaMenu:function(){
        var tb = Phx.vista.PresupuestoInicio.superclass.liberaMenu.call(this);
        if(tb){
            this.getBoton('btnIniTra').disable();
            this.getBoton('btnRepRelCon').disable();
        }
    },
    
	
   tabeast:[
          {
    		  url:'../../../sis_presupuestos/vista/presup_partida/PresupPartidaInicio.php',
    		  title:'Partidas', 
    		  width:'50%',
    		  cls:'PresupPartidaInicio'
		  },
		  {
    		  url:'../../../sis_presupuestos/vista/presupuesto_funcionario/PresupuestoFuncionario.php',
    		  title:'Funcionarios', 
    		  width:'50%',
    		  cls:'PresupuestoFuncionario'
		  },
		  {
    		  url:'../../../sis_presupuestos/vista/rel_pre/RelPreInicio.php',
    		  title:'Composición', 
    		  width:'50%',
    		  cls:'RelPreInicio'
		  },
          {
              url:'../../../sis_presupuestos/vista/presupuesto_objetivo/PresupuestoObjetivo.php',
              title:'Objetivos',
              width:'50%',
              cls:'PresupuestoObjetivo'
          }]
	
    
   
    
};
</script>
