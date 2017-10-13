<?php
/**
*@package pXP
*@file Presupuesto.php
*@author  Rensi Arteaga Copari
*@date 27-02-2016 00:30:39
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.Presupuesto=Ext.extend(Phx.gridInterfaz,{
	 

	constructor:function(config){
		this.maestro=config.maestro;
		
    	//llama al constructor de la clase padre
		Phx.vista.Presupuesto.superclass.constructor.call(this,config);
		
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
        this.addButton('btnMemoria',{ grupo:[0,1,2], text :'Memoria', iconCls:'bdocuments', disabled: true, handler : this.onButtonMemoria,tooltip : '<b>Memoria de Calculo</b><br/><b>Planificación de gastos o recursos</b>'});
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
		this.addButton('diagrama_gantt',{ grupo:[0,1,2], text: 'Gantt', iconCls: 'bgantt', disabled: true, handler: this.diagramGantt, tooltip: '<b>Diagrama gantt de proceso macro</b>'});

		this.addButton('btnObs',{
                    text :'Obs Wf',
                    grupo:[1,2],
                    iconCls : 'bchecklist',
                    disabled: true,
                    handler : this.onOpenObs,
                    tooltip : '<b>Observaciones</b><br/><b>Observaciones del WF</b>'
         });

        
	},
	
	
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_presupuesto',
					fieldLabel: 'ID',
					gwidth: 50
			},
			type:'Field',
			grid: false,
			form:true 
		},
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_gestion',
					gwidth: 50
			},
			type:'Field',
			grid: false,
			form:true 
		},
		
		{
	   		config:{
	   				name:'id_tipo_cc',
	   				qtip: 'Tipo de centro de costos, cada tipo solo puede tener un centro por gestión',	   				
	   				origen:'TIPOCC',
	   				fieldLabel:'Tipo Centro',
	   				gdisplayField: 'desc_tcc',	   				
	   				allowBlank:false,
	   				width:350,
	   				gwidth:200
	   				
	      		},
   			type:'ComboRec',
   			id_grupo:0,
   			filters:{pfiltro:'vcc.codigo_tcc#vcc.descripcion_tcc',type:'string'},
   		    grid:true,
   			form:true
	    },
	    
		{
	   		config:{
	   				name:'id_uo',
	   				qtip:'La unidad dueña del presupeusto (no es necesiramente la que aplique el costo)',
	   				origen:'UO',
	   				fieldLabel:'Unidad',
	   				allowBlank:false,
	   				gdisplayField:'nombre_uo',//mapea al store del grid
	   			    gwidth:200,
	   			    width:250,
	   			    baseParams:{presupuesta:'si'},
	      			renderer:function (value, p, record){return String.format('{0} {1}' , record.data['codigo_uo'], record.data['nombre_uo']);}
	      		},
   			type:'ComboRec',
   			id_grupo:0,
   			filters:{pfiltro:'nombre_uo',type:'string'},
   		    grid:true,
   			form:true
	    },
		
		
		{
			config:{
				name: 'descripcion',
				fieldLabel: 'Descripcion',
				allowBlank: true,
				anchor: '80%',
				gwidth: 200,
				maxLength:200
			}, 
			type:'TextArea',
			filters: { pfiltro:'vcc.descripcion_tcc#vcc.codigo_tcc',type:'string' },
			id_grupo:1,
			bottom_filter: true,
			grid: true,
			form: true
		},
		{
			config:{
				name: 'estado',
				fieldLabel: 'Estado Presupuesto',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:30
			},
			type:'TextField',
			filters:{pfiltro:'pre.estado',type:'string'},
			id_grupo:1,
			grid: true,
			form: false
		},
		{
			config:{
				name: 'tipo_pres',
				fieldLabel: 'Tipo Presupuesto',
				allowBlank: false,
				emptyText : '...',
				store : new Ext.data.JsonStore({
					url:'../../sis_presupuestos/control/TipoPresupuesto/listarTipoPresupuesto',
					id : 'codigo',
					root: 'datos',
					sortInfo:{
						field: 'codigo',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['codigo','nombre','movimiento'],
					remoteSort: true,
					baseParams:{par_filtro:'nombre'}
				}),
				valueField: 'codigo',
				displayField: 'nombre',
				gdisplayField: 'desc_tipo_presupuesto',
				hiddenName: 'id_centro_costo',
				forceSelection:true,
				typeAhead: true,
				triggerAction: 'all',
				lazyRender:true,
				mode:'remote',
				pageSize:10,
				queryDelay:1000,
				width: 150,
				listWidth: 280,
				gwidth: 150,
				minChars:2,
				renderer:function(value, p, record){return String.format('{0}', record.data['desc_tipo_presupuesto']);}
			},
			type:'ComboBox',
			bottom_filter: true,
			filters:{pfiltro:'cp.codigo_categoria#cp.descripcion',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'id_categoria_prog',
				fieldLabel: 'Categoria Programatica',
				qtip: 'la categoria programatica permite la integración de reportes para sigma',
				allowBlank: true,
				emptyText : '...',
				store : new Ext.data.JsonStore({
					url:'../../sis_presupuestos/control/CategoriaProgramatica/listarCategoriaProgramatica',
					id : 'id_categoria_programatica',
					root: 'datos',
					sortInfo:{
						field: 'codigo_categoria',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['codigo_categoria','id_categoria_programatica','descripcion'],
					remoteSort: true,
					baseParams:{par_filtro:'descripcion#codigo_categoria'}
				}),
				valueField: 'id_categoria_programatica',
				displayField: 'codigo_categoria',
				gdisplayField: 'codigo_categoria',
				hiddenName: 'id_categoria_prog',
				forceSelection:true,
				typeAhead: true,
				triggerAction: 'all',
				lazyRender:true,
				mode:'remote',
				pageSize:10,
				queryDelay:1000,
				width: 150,
				listWidth: 280,
				gwidth: 150,
				minChars:2,
				tpl:'<tpl for="."><div class="x-combo-list-item"><p>{codigo_categoria}</p><p>{descripcion}</p> </div></tpl>',
				renderer:function(value, p, record){return String.format('{0}', record.data['codigo_categoria']);}
			},
			type:'ComboBox',
			bottom_filter: true,
			filters:{pfiltro:'codigo_categoria',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'codigo_cc',
				fieldLabel: 'Centro de Costo',
				allowBlank: true,
				anchor: '80%',
				gwidth: 300,
				maxLength:30
			},
			type:'TextField',
			filters:{pfiltro:'vcc.codigo_cc',type:'string'},
			id_grupo:1,
			bottom_filter: true,
			grid: true,
			form: false
		},

		{
	       		config:{
	       			name:'sw_consolidado',
	       			fieldLabel:'Consolidado',
	       			qtip: 'los presupuestos oficiales y consolidados se formulan a partir de los presupuestos no oficiales',
	       			allowBlank:false,
	       			typeAhead: true,
	       		    triggerAction: 'all',
	       		    lazyRender:true,
	       		    mode: 'local',
	       		    store: ['si','no']
	       		    
	       		},
	       		type:'ComboBox',
	       		id_grupo:0,
	       		filters:{	
	       		         type: 'list',
	       		         pfiltro:'pre.sw_consolidado',
	       				 options: ['si','no']
	       		 	},
	       		grid:true,
	       		form:true
	    },

		{
			config: {
				name: 'fecha_inicio_pres',
				fieldLabel: 'Fecha Inicio Presupuesto',
				allowBlank: false,
				anchor: '42.3%',
				gwidth: 100,


				format: 'd/m/Y',
				renderer: function (value, p, record) {
					return value ? value.dateFormat('d/m/Y') : ''
				}
			},
			type: 'DateField',
			filters: {pfiltro: 'pre.fecha_inicio_pres', type: 'date'},
			id_grupo: 1,
			grid: true,
			form: true
		},

		{
			config: {
				name: 'fecha_fin_pres',
				fieldLabel: 'Fecha Fin Presupuesto',
				allowBlank: false,
				anchor: '42.3%',
				gwidth: 100,


				format: 'd/m/Y',
				renderer: function (value, p, record) {
					return value ? value.dateFormat('d/m/Y') : ''
				}
			},
			type: 'DateField',
			filters: {pfiltro: 'pre.fecha_fin_pres', type: 'date'},
			id_grupo: 1,
			grid: true,
			form: true
		},

		{
			config:{
				name: 'nro_tramite',
				fieldLabel: 'Nro Tramite',
				allowBlank: true,
				anchor: '80%',
				gwidth: 150,
				maxLength:30
			},
			type:'TextField',
			filters:{pfiltro:'pre.nro_tramite',type:'string'},
			id_grupo:1,
			bottom_filter: true,
			grid: true,
			form: false
		},
		

		
		
		
		{
			config:{
				name: 'obs_wf',
				fieldLabel: 'Observaciones estado',
				allowBlank: true,
				anchor: '80%',
				gwidth: 200,
				maxLength:30
			},
			type:'TextArea',
			filters: { pfiltro:'ewf.obs_wf',type:'string' },
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
			filters:{pfiltro:'pre.estado_reg',type:'string'},
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
			type:'NumberField',
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
			filters:{pfiltro:'pre.fecha_reg',type:'date'},
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
			filters:{pfiltro:'pre.fecha_mod',type:'date'},
			id_grupo:1,
			grid:true,
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
			type:'NumberField',
			filters:{pfiltro:'usu2.cuenta',type:'string'},
			id_grupo:1,
			grid:true,
			form:false
		}
	],
	
	title:'Presupuesto',
	ActSave:'../../sis_presupuestos/control/Presupuesto/insertarPresupuesto',
	ActDel:'../../sis_presupuestos/control/Presupuesto/eliminarPresupuesto',
	ActList:'../../sis_presupuestos/control/Presupuesto/listarPresupuesto',
	id_store:'id_presupuesto',
	fields: [
		{ name:'id_presupuesto', type: 'numeric'},
		{ name:'id_centro_costo', type: 'numeric'},
		{ name:'codigo_cc', type: 'string'},
		{ name:'tipo_pres', type: 'string'},
		{ name:'estado_pres', type: 'string'},
		{ name:'estado_reg', type: 'string'},
		{ name:'id_usuario_reg', type: 'numeric'},
		{ name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{ name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{ name:'id_usuario_mod', type: 'numeric'},
		{ name:'usr_reg', type: 'string'},
		{ name:'usr_mod', type: 'string'},'estado',
		'id_estado_wf','nro_tramite','id_proceso_wf',
		'desc_tipo_presupuesto','descripcion','movimiento_tipo_pres',
		'id_gestion','obs_wf','sw_consolidado','codigo_categoria','id_categoria_prog','mov_pres','momento_pres','id_uo','codigo_uo','nombre_uo','id_tipo_cc','desc_tcc',
		{ name:'fecha_inicio_pres', type: 'date'},
		{ name:'fecha_fin_pres', type: 'date'}

	],
	
	
	sortInfo:{
		field: 'id_presupuesto',
		direction: 'ASC'
	},

	fheight: '68%',
	fwidth: '55%',
	
	onButtonEdit : function () {
        var rec=this.sm.getSelected();
        Phx.vista.Presupuesto.superclass.onButtonEdit.call(this); 
        this.Cmp.id_categoria_prog.store.baseParams.id_gestion = rec.data.id_gestion;  
        this.Cmp.id_categoria_prog.modificado = true; 
        		   
    },  
	
    
	fin_registro: function(a,b,forzar_fin, paneldoc){                   
            var d = this.sm.getSelected().data;
            this.mostrarWizard(this.sm.getSelected());
	},
      
    
    liberaMenu:function(){
        var tb = Phx.vista.Presupuesto.superclass.liberaMenu.call(this);
        if(tb){
            this.getBoton('fin_registro').disable();
            this.getBoton('ant_estado').disable(); 
        }
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
                                       id_presupuesto: rec.data.id_presupuesto,
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
            url: '../../sis_presupuestos/control/Presupuesto/siguienteEstadoPresupuesto',
            params:{
            	    
            	    id_presupuesto: wizard.data.id_presupuesto,
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
    preparaMenu:function(n){
          var data = this.getSelectedData();
          var tb =this.tbar;
          
          Phx.vista.Presupuesto.superclass.preparaMenu.call(this,n);
          
          if(data['nro_tramite'] && data['nro_tramite']!=''){
          	 if (data['estado']!= 'aprobado'){
              	 this.getBoton('fin_registro').enable();
            }
          }
          
          
          if (data['estado']!= 'borrador' && data['estado']!= 'aprobado'){
             this.getBoton('ant_estado').enable(); 
          }
          
          this.getBoton('btnMemoria').enable();
          this.getBoton('btnObs').enable();    
          this.getBoton('btnChequeoDocumentosWf').enable(); 
          this.getBoton('diagrama_gantt').enable();
    }, 
    
    
    liberaMenu:function(){
        var tb = Phx.vista.Presupuesto.superclass.liberaMenu.call(this);
        if(tb){
           this.getBoton('btnMemoria').disable(); 
           this.getBoton('btnObs').disable();  
           this.getBoton('diagrama_gantt').disable();
           this.getBoton('btnChequeoDocumentosWf').disable();
        }
        return tb;
    },  

	bnew: false,
	bedit: false,
	bdel: false,
	bsave: false,
	 
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
                    'DocumentoWf'
        )
    },
    onOpenObs:function() {
            var rec=this.sm.getSelected();
            
            var data = {
            	id_proceso_wf: rec.data.id_proceso_wf,
            	id_estado_wf: rec.data.id_estado_wf,
            	num_tramite: rec.data.num_tramite
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
    onButtonMemoria:function() {
            var rec=this.sm.getSelected();
            Phx.CP.loadWindows('../../../sis_presupuestos/vista/memoria_calculo/MemoriaCalculo.php',
                    'Memoria de Calculo',
                    {
                        width:'98%',
                        height:'98%'
                    },
                    rec.data,
                    this.idContenedor,
                    'MemoriaCalculo');
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
                        }],
               scope:this
             });
   },
   
   onAntEstado: function(wizard,resp){
            Phx.CP.loadingShow();
            Ext.Ajax.request({
                // form:this.form.getForm().getEl(),
                url:'../../sis_presupuestos/control/Presupuesto/anteriorEstadoPresupuesto',
                params:{
                        id_proceso_wf: resp.id_proceso_wf,
                        id_estado_wf:  resp.id_estado_wf,  
                        obs: resp.obs,
                        estado_destino: resp.estado_destino
                 },
                argument: { wizard: wizard },  
                success: this.successEstadoSinc,
                failure: this.conexionFailure,
                timeout: this.timeout,
                scope: this
            });
           
     },
     
   successEstadoSinc:function(resp){
        Phx.CP.loadingHide();
        resp.argument.wizard.panel.destroy()
        this.reload();
     }

})
</script>
		
		