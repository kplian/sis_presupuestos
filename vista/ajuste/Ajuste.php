<?php
/**
*@package pXP
*@file gen-Ajuste.php
*@author  (admin)
*@date 13-04-2016 13:21:12
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.Ajuste=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){		
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.Ajuste.superclass.constructor.call(this,config);
		this.addButton('ant_estado',{
         	  grupo:[4],
              argument: {estado: 'anterior'},
              text: 'Retroceder',
              iconCls: 'batras',
              disabled: true,
              handler: this.antEstado,
              tooltip: '<b>Pasar al Anterior Estado</b>'
        });
          
        this.addButton('fin_registro', { grupo:[0], text:'Siguiente', iconCls: 'badelante', disabled:true,handler:this.fin_registro,tooltip: '<b>Siguiente</b><p>Pasa al siguiente estado, si esta en borrador comprometera presupuesto</p>'});
        this.addButton('diagrama_gantt',{ grupo:[1,2], text: 'Gantt', iconCls: 'bgantt', disabled: true, handler: this.diagramGantt, tooltip: '<b>Diagrama gantt de proceso macro</b>'});
        this.addButton('btnChequeoDocumentosWf',
            {
                text: 'Documentos',
                grupo:[0,1,2],
                iconCls: 'bchecklist',
                disabled: true,
                handler: this.loadCheckDocumentosSolWf,
                tooltip: '<b>Documentos de la Solicitud</b><br/>Subir los documetos requeridos en la solicitud seleccionada.'
            }
        );
        
        this.addButton('btnObs',{
                    text :'Obs Wf',
                    grupo:[1,2],
                    iconCls : 'bchecklist',
                    disabled: true,
                    handler : this.onOpenObs,
                    tooltip : '<b>Observaciones</b><br/><b>Observaciones del WF</b>'
         });
         
          this.addButton('chkpresupuesto',{
                    text :'Comp/Ejec',
                    grupo:[0,1,2],
                    iconCls : 'bchecklist',
                    disabled: true,
                    handler : this.checkPresupuesto,
                    tooltip: '<b>Revisar Presupuesto</b><p>Revisar estado de ejecución presupeustaria para el tramite</p>',

         });
         
         
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_ajuste'
			},
			type:'Field',
			form:true 
		},
		
		{
			config:{
				name: 'nro_tramite',
				fieldLabel: 'Nº Trámite',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:300
			},
				type:'TextField',
				filters: { pfiltro:'aju.nro_tramite',type:'string'},
				id_grupo: 1,
				grid: true,
				form: false
		},
        {
            config:{
                name: 'fecha',
                fieldLabel: 'Fecha',
                allowBlank: false,
                gwidth: 80,
                format: 'd/m/Y', 
                renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
            },
            type:'DateField',
            filters:{pfiltro:'aju.fecha',type:'date'},
            id_grupo:0,
            grid:true,
            form:true
      },
      {
            config:{
                name: 'tipo_ajuste',
                fieldLabel: 'Tipo ',
                allowBlank: false,
                anchor: '40%',
                gwidth: 100,
                typeAhead: true,
                triggerAction: 'all',
                lazyRender:true,
                mode: 'local',
                valueField: 'variable',
                displayField: 'valor',
                renderer:function(value,p,record){
                        if( record.data.total_pagado == record.data.monto_ejecutar_total_mo ){
                               
                              var ajustes = {
				                              	'traspaso':'Traspaso',
				                              	'reformulacion':'Reformulación',
				                              	'incremento':'Incremento',
				                              	'decremento':'Decremento',
				                              	'inc_comprometido':'Comprometer',
				                              	'rev_comprometido':'Revertir Comprometido'
				                              };
				                               
	                           return String.format('<b><font color="green">{0}</font></b>', ajustes[value]);
	                          
                         }
                 },
                store:new Ext.data.ArrayStore({
                            fields :['variable','valor'],
                            data :  [['traspaso','Traspaso'],
                                      ['reformulacion','Reformulación'],
                                      ['incremento','Incremento'],
                                      ['decremento','Decremento'],
                                      ['inc_comprometido','Comprometer'],
                                      ['rev_comprometido','Revertir Comprometido']]}),
            },
            type:'ComboBox',
            id_grupo:1,
            filters:{   pfiltro:'aju.tipo_ajuste',
                        type: 'list',
                        options: ['reformulacion','reformulacion','incremento','decremento','inc_comprometido','rev_comprometido'],  
                    },
            grid:true,
            form:true
        },
        {
            config:{
                name:'nro_tramite_aux',
                fieldLabel:'Nº Trámite',
                allowBlank:true,
                emptyText:'Tipo...',
                store: new Ext.data.JsonStore({
                    url: '../../sis_presupuestos/control/PartidaEjecucion/listarTramitesAjustables',
                    id: 'nro_tramite',
                    root: 'datos',
                    sortInfo:{
                        field: 'pe.nro_tramite',
                        direction: 'ASC'
                    },
                    totalProperty: 'total',
                    fields: ['nro_tramite','codigo','desc_moneda','id_moneda'],
                    // turn on remote sorting
                    remoteSort: true,
                    baseParams:{par_filtro:'pe.nro_tramite#pm.codigo'}

                }),
                tpl:'<tpl for="."><div class="x-combo-list-item"><p>{nro_tramite} ({desc_moneda})</p></div></tpl>',
				valueField: 'nro_tramite',
                displayField: 'nro_tramite',
                gdisplayField: 'nro_tramite',
                forceSelection:true,
                typeAhead: false,
                triggerAction: 'all',
                lazyRender:true,
                mode:'remote',
                pageSize:20,
                queryDelay:1000,
                width:250,
                minChars:2

            },
            type:'ComboBox',
            id_grupo:0,
            grid:false,
            form:true
        },
		{
            config:{
                name: 'movimiento',
                fieldLabel: 'Movimiento ',
                qtip: '¿Para definir si se ajusta  presupuestos de gasto o de recurso?',
                allowBlank: false,
                anchor: '40%',
                gwidth: 100,
                typeAhead: true,
                triggerAction: 'all',
                lazyRender:true,
                mode: 'local',
                valueField: 'variable',
                displayField: 'valor',
                renderer:function(value,p,record){
                        if( record.data.total_pagado == record.data.monto_ejecutar_total_mo ){
                               
                              var ajustes = {
				                              	'recurso':'Recurso',
				                              	'gasto':'Gasto'
				                              };
				               return String.format('<b>{0}</b>', ajustes[value]);
	                     }
                 },
                store:new Ext.data.ArrayStore({
                            fields :['variable','valor'],
                            data :  [['recurso','Recurso'],
                                      ['gasto','Gasto']]}),
            },
            type:'ComboBox',
            filters:{   pfiltro:'aju.tipo_ajuste',
                        type: 'list',
                        options: ['recurso','gasto'],  
                    },
            grid:true,
            form:true
        },
        {
			config:{
				name: 'desc_moneda',
				fieldLabel: 'Moneda',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:50
			},
				type:'TextField',
				filters:{pfiltro:'mon.codigo',type:'string'},
				id_grupo:1,
				grid: true,
				form: false
		},
        
        {
			config:{
				name: 'importe_ajuste',
				fieldLabel: 'Importe',
				selectOnFocus: true,
				allowBlank: false,
				allowNegative: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:1179650
			},
				type:'NumberField',
				filters:{ pfiltro:'aju.importe_ajuste',type:'numeric' },
				id_grupo:1,
				egrid: true,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'justificacion',
				fieldLabel: 'justificacion',
				allowBlank: false,
				anchor: '80%',
				gwidth: 280,
				maxLength: 400
			},
				type:'TextArea',
				filters:{pfiltro:'aju.justificacion',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'estado',
				fieldLabel: 'Estado',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:50
			},
				type:'TextField',
				filters:{pfiltro:'aju.estado',type:'string'},
				id_grupo:1,
				grid: true,
				form: false
		},
		{
			config:{
				name: 'estado_reg',
				fieldLabel: 'Estado Reg.',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:10
			},
				type:'TextField',
				filters:{pfiltro:'aju.estado_reg',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'usr_reg',
				fieldLabel: 'Creado por',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
				type:'Field',
				filters:{pfiltro:'usu1.cuenta',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'fecha_reg',
				fieldLabel: 'Fecha creación',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
							format: 'd/m/Y', 
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
			},
				type:'DateField',
				filters:{pfiltro:'aju.fecha_reg',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'id_usuario_ai',
				fieldLabel: 'Funcionaro AI',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
				type:'Field',
				filters:{pfiltro:'aju.id_usuario_ai',type:'numeric'},
				id_grupo:1,
				grid:false,
				form:false
		},
		{
			config:{
				name: 'usr_mod',
				fieldLabel: 'Modificado por',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
				type:'Field',
				filters:{pfiltro:'usu2.cuenta',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'fecha_mod',
				fieldLabel: 'Fecha Modif.',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
							format: 'd/m/Y', 
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
			},
				type:'DateField',
				filters:{pfiltro:'aju.fecha_mod',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'usuario_ai',
				fieldLabel: 'Funcionaro AI',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:300
			},
				type:'TextField',
				filters:{pfiltro:'aju.usuario_ai',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		}
	],
	tam_pag:50,	
	title:'Ajustes',
	ActSave:'../../sis_presupuestos/control/Ajuste/insertarAjuste',
	ActDel:'../../sis_presupuestos/control/Ajuste/eliminarAjuste',
	ActList:'../../sis_presupuestos/control/Ajuste/listarAjuste',
	id_store:'id_ajuste',
	fields: [
		{name:'id_ajuste', type: 'numeric'},
		{name:'id_estado_wf', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'estado', type: 'string'},
		{name:'justificacion', type: 'string'},
		{name:'id_proceso_wf', type: 'numeric'},
		{name:'tipo_ajuste', type: 'string'},
		{name:'nro_tramite', type: 'string'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_reg', type: 'date', dateFormat:'Y-m-d H:i:s.u'},
		{name:'usuario_ai', type: 'string'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date', dateFormat:'Y-m-d H:i:s.u'},
		{name:'fecha', type: 'date', dateFormat:'Y-m-d'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'}, 
		'importe_ajuste','movimiento','id_gestion','nro_tramite_aux','desc_moneda','id_moneda'
		
	],
	sortInfo:{
		field: 'id_ajuste',
		direction: 'ASC'
	},
	loadCheckDocumentosSolWf:function() {
            var rec=this.sm.getSelected();
            rec.data.nombreVista = this.nombreVista;
            Phx.CP.loadWindows('../../../sis_workflow/vista/documento_wf/DocumentoWf.php',
                    'Documentos del Proceso',
                    {
                        width:'90%',
                        height:500
                    },
                    rec.data,
                    this.idContenedor,
                    'DocumentoWf');
    },
	onOpenObs:function() {
            var rec=this.sm.getSelected();
            
            var data = {
            	id_proceso_wf: rec.data.id_proceso_wf,
            	id_estado_wf: rec.data.id_estado_wf,
            	num_tramite: rec.data.nro_tramite
            }
            
            Phx.CP.loadWindows('../../../sis_workflow/vista/obs/Obs.php',
                    'Observaciones del WF',
                    {
                        width:'80%',
                        height:'70%'
                    },
                    data,
                    this.idContenedor,
                    'Obs'
        )
    },
    diagramGantt:function(){           
            var data=this.sm.getSelected().data.id_proceso_wf;
            Phx.CP.loadingShow();
            Ext.Ajax.request({
                url:'../../sis_workflow/control/ProcesoWf/diagramaGanttTramite',
                params:{'id_proceso_wf':data},
                success:this.successExport,
                failure: this.conexionFailure,
                timeout:this.timeout,
                scope:this
            });         
    },
    antEstado:function(res){
         var rec=this.sm.getSelected();
         Phx.CP.loadWindows('../../../sis_workflow/vista/estado_wf/AntFormEstadoWf.php',
            'Estado de Wf',
            {
                modal:true,
                width:450,
                height:250
            }, { data:rec.data, estado_destino: res.argument.estado }, this.idContenedor,'AntFormEstadoWf',
            {
                config:[{
                          event: 'beforesave',
                          delegate: this.onAntEstado,
                        }
                        ],
               scope:this
             })
   },
   
   onAntEstado: function(wizard,resp){
            Phx.CP.loadingShow();
            Ext.Ajax.request({
                url:'../../sis_presupuestos/control/Ajuste/anteriorEstadoAjuste',
                params:{
                        id_proceso_wf: resp.id_proceso_wf,
                        id_estado_wf:  resp.id_estado_wf,  
                        obs: resp.obs,
                        estado_destino: resp.estado_destino
                 },
                argument: { wizard: wizard },  
                success:this.successEstadoSinc,
                failure: this.conexionFailure,
                timeout:this.timeout,
                scope:this
            });
           
     },
     
   successEstadoSinc:function(resp){
        Phx.CP.loadingHide();
        resp.argument.wizard.panel.destroy()
        this.reload();
    },
    fin_registro: function(a,b,forzar_fin, paneldoc){                   
            var d = this.sm.getSelected().data;
            this.mostrarWizard(this.sm.getSelected());
	},
	
	mostrarWizard : function(rec) {
     	var configExtra = [],
     		obsValorInicial;
     	 
     	console.log('rec.data',rec.data)
     	this.objWizard = Phx.CP.loadWindows('../../../sis_workflow/vista/estado_wf/FormEstadoWf.php',
                                'Estado de Wf',
                                {
                                    modal: true,
                                    width: 700,
                                    height: 450
                                }, {
                                	configExtra: configExtra,
                                	data:{
                                       id_estado_wf: rec.data.id_estado_wf,
                                       id_proceso_wf: rec.data.id_proceso_wf, 
                                       id_ajuste: rec.data.id_ajuste,
                                       fecha_ini: rec.data.fecha_tentativa
                                      
                                   },
                                   obsValorInicial : obsValorInicial,
                                }, this.idContenedor, 'FormEstadoWf',
                                {
                                    config:[{
                                              event:'beforesave',
                                              delegate: this.onSaveWizard,
                                              
                                            },
					                        {
					                          event:'requirefields',
					                          delegate: function () {
						                          	this.onButtonEdit();
										        	this.window.setTitle('Registre los campos antes de pasar al siguiente estado');
										        	this.formulario_wizard = 'si';
					                          }
					                          
					                        }],
                                    
                                    scope:this
                                 });        
     },
    onSaveWizard:function(wizard,resp){
        Phx.CP.loadingShow();
        Ext.Ajax.request({
            url: '../../sis_presupuestos/control/Ajuste/siguienteEstadoAjuste',
            params:{
            	    
            	    id_ajuste: 			wizard.data.id_ajuste,
            	    id_proceso_wf_act:  resp.id_proceso_wf_act,
	                id_estado_wf_act:   resp.id_estado_wf_act,
	                id_tipo_estado:     resp.id_tipo_estado,
	                id_funcionario_wf:  resp.id_funcionario_wf,
	                id_depto_wf:        resp.id_depto_wf,
	                obs:                resp.obs,
	                json_procesos:      Ext.util.JSON.encode(resp.procesos)
                },
            success: this.successWizard,
            failure: this.conexionFailure, //chequea si esta en verificacion presupeusto para enviar correo de transferencia
            argument: { wizard: wizard },
            timeout: this.timeout,
            scope: this
        });
    },
    successWizard:function(resp){
        Phx.CP.loadingHide();
        resp.argument.wizard.panel.destroy()
        this.reload();
    }, 
    
    
    
    
    
    liberaMenu:function(){
        var tb = Phx.vista.Ajuste.superclass.liberaMenu.call(this);
        if(tb){
            this.getBoton('fin_registro').disable();
            this.getBoton('ant_estado').disable(); 
            this.getBoton('btnObs').disable();    
            this.getBoton('btnChequeoDocumentosWf').disable(); 
            this.getBoton('diagrama_gantt').disable();
            this.getBoton('chkpresupuesto').disable();
         }
    },
  
    enableAllTab: function(){
    	if(this.TabPanelEast && this.TabPanelEast.get(0) && this.TabPanelEast.get(1)){
    	  this.TabPanelEast.get(0).enable();
    	  this.TabPanelEast.get(1).enable();
    	 }
    },
    
    disableAllTab: function(){
    	if(this.TabPanelEast && this.TabPanelEast.get(0) && this.TabPanelEast.get(1)){
    	   this.TabPanelEast.get(0).disable();
    	    this.TabPanelEast.get(1).disable();
    	 }
    },
    enableTabDecrementos:function(){
     	if(this.TabPanelEast && this.TabPanelEast.get(0)){
     		      this.TabPanelEast.get(0).enable();
			      this.TabPanelEast.setActiveTab(0);
		        }
     },
     
    enableTabIncrementos:function(){
     	if(this.TabPanelEast && this.TabPanelEast.get(1)){
     		      this.TabPanelEast.get(1).enable();
			      this.TabPanelEast.setActiveTab(1);
		        }
     }, 
     
    disableTabDecrementos:function(){
     	if(this.TabPanelEast && this.TabPanelEast.get(0)){
     		      this.TabPanelEast.get(0).disable();
     		      this.TabPanelEast.get(1).enable();	
		          this.TabPanelEast.setActiveTab(1)
		          
		}
    },
    
    disableTabIncrementos:function(){
    	if(this.TabPanelEast && this.TabPanelEast.get(1)){
     		      this.TabPanelEast.get(1).disable();	
     		      this.TabPanelEast.get(0).enable();
		          this.TabPanelEast.setActiveTab(0)
		          
		}
    },
      
	bdel:true,
	bsave:true,
	
	checkPresupuesto:function(){                   
			  var rec=this.sm.getSelected();
			  var configExtra = [];
			  this.objChkPres = Phx.CP.loadWindows('../../../sis_presupuestos/vista/presup_partida/ChkPresupuesto.php',
										'Estado del Presupuesto',
										{
											modal:true,
											width:700,
											height:450
										}, {
											data:{
											   nro_tramite: rec.data.nro_tramite								  
											}}, this.idContenedor,'ChkPresupuesto');
			   
	 },
	
	
	tabeast:[
	      {
    		  url:'../../../sis_presupuestos/vista/ajuste_det/AjusteDetDec.php',
    		  title:'Decrementos (-)', 
    		  width:'60%',
    		  cls:'AjusteDetDec'
		  },
          {
    		  url:'../../../sis_presupuestos/vista/ajuste_det/AjusteDetInc.php',
    		  title:'Incrementos (+)', 
    		  width:'60%',
    		  cls:'AjusteDetInc'
		  },
		  
		  ],
	
});
</script>