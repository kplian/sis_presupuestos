<?php
/**
*@package pXP
*@file Presupuesto.php
*@author  Gonzalo Sarmiento Sejas
*@date 27-02-2013 00:30:39
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.Presupuesto=Ext.extend(Phx.gridInterfaz,{
	 swEstado : 'borrador',
     gruposBarraTareas:[{name:'borrador',title:'<H1 align="center"><i class="fa fa-thumbs-o-down"></i> Borradores</h1>', grupo:0,height:0},
                        {name:'en_proceso',title:'<H1 align="center"><i class="fa fa-eye"></i> En Proceso</h1>', grupo:1,height:0},
                        {name:'finalizados',title:'<H1 align="center"><i class="fa fa-file-o"></i> Finalizados</h1>', grupo:2,height:0}],
	
     beditGroups: [0,1,2],     
     bactGroups:  [0,1,2],
     btestGroups: [0],
     bexcelGroups: [0,1,2],

	constructor:function(config){
		this.maestro=config.maestro;
		this.initButtons=[this.cmbGestion, this.cmbTipoPres];
    	//llama al constructor de la clase padre
		Phx.vista.Presupuesto.superclass.constructor.call(this,config);
		this.init();
		
		
		
		
		this.bloquearOrdenamientoGrid();
		this.cmbGestion.on('select', function(){
		    
		    if(this.validarFiltros()){
                  this.capturaFiltros();
           }
		    
		    
		},this);
		
		this.bloquearOrdenamientoGrid();

		this.cmbTipoPres.on('clearcmb', function() {
				this.DisableSelect();
				this.store.removeAll();
			}, this);

		this.cmbTipoPres.on('valid', function() {
				this.capturaFiltros();

			}, this);
		
		
		//Crea el botón para llamar a la replicación
		this.addButton('btnRepRelCon',
			{
				grupo:[2],
				text: 'Duplicar Presupuestos',
				iconCls: 'bchecklist',
				disabled: false,
				handler: this.duplicarPresupuestos,
				tooltip: '<b>Duplicar presupuestos </b><br/>Duplicar presupuestos para la siguiente gestión'
			}
		);
		
		//Crea el botón para iniciar tramite
		this.addButton('btnIniTra',
			{
				grupo:[0],
				text: 'Iniciar',
				iconCls: 'bchecklist',
				disabled: false,
				handler: this.iniTramite,
				tooltip: '<b>Iniciar Trámite</b><br/>Inicia el trámite de formulación para el presupuesto'
			}
		);
		
		 this.addButton('ant_estado',{
         	  grupo:[1],
              argument: {estado: 'anterior'},
              text: 'Retroceder',
              iconCls: 'batras',
              disabled: true,
              handler: this.antEstado,
              tooltip: '<b>Pasar al Anterior Estado</b>'
          });
          
        this.addButton('fin_registro', { grupo:[0,1], text:'Siguiente', iconCls: 'badelante',disabled:true,handler:this.fin_registro,tooltip: '<b>Siguiente</b><p>Pasa al siguiente estado, si esta en borrador comprometera presupuesto</p>'});
        this.finCons = true;
		
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
	
	capturaFiltros:function(combo, record, index){
		
		this.desbloquearOrdenamientoGrid();
        this.store.baseParams.id_gestion=this.cmbGestion.getValue();
        this.store.baseParams.codigos_tipo_pres = this.cmbTipoPres.getValue();
        this.store.baseParams.estado = this.swEstado;
        this.load({params:{start:0, limit:50}});
		
		
		
			
			
	},
	
	actualizarSegunTab: function(name, indice){
		
		this.swEstado = name;
    	if(this.validarFiltros()){
            this.store.baseParams.estado = this.swEstado;
            this.store.baseParams.id_gestion=this.cmbGestion.getValue();
            this.store.baseParams.codigos_tipo_pres = this.cmbTipoPres.getValue();
            Phx.vista.Presupuesto.superclass.onButtonAct.call(this);
        }
    },
	
	onButtonAct:function(){
        if(!this.validarFiltros()){
            alert('Especifique los filtros antes')
         }
        else{
            this.store.baseParams.id_gestion=this.cmbGestion.getValue();
            this.store.baseParams.codigos_tipo_pres = this.cmbTipoPres.getValue();
            this.store.baseParams.estado = this.swEstado;
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
	
	
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_presupuesto'
			},
			type:'Field',
			form:true 
		},
		{
			config:{
				name: 'codigo_cc',
				fieldLabel: 'Centro Costo',
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
			filters:{pfiltro:'tp.codigo#tp.nombre',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
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
			grid: true,
			form: false
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
				name: 'descripcion',
				fieldLabel: 'Descripcion',
				allowBlank: true,
				anchor: '80%',
				gwidth: 200,
				maxLength:30
			},
			type:'TextArea',
			filters: { pfiltro:'pre.descripcion',type:'string' },
			id_grupo:1,
			grid: true,
			form: true
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
		{name:'id_presupuesto', type: 'numeric'},
		{name:'id_centro_costo', type: 'numeric'},
		{name:'codigo_cc', type: 'string'},
		{name:'tipo_pres', type: 'string'},
		{name:'estado_pres', type: 'string'},
		{name:'estado_reg', type: 'string'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},'estado',
		'id_estado_wf','nro_tramite','id_proceso_wf',
		'desc_tipo_presupuesto','descripcion','movimiento_tipo_pres','id_gestion'
		
	],
	tabeast:[
		  {
    		  url:'../../../sis_presupuestos/vista/presupuesto_funcionario/PresupuestoFuncionario.php',
    		  title:'Funcionarios', 
    		  width:'60%',
    		  cls:'PresupuestoFuncionario'
		  },
		  {
    		  url:'../../../sis_presupuestos/vista/presup_partida/PresupPartida.php',
    		  title:'Partidas', 
    		  width:'60%',
    		  cls:'PresupPartida'
		  }
		],
	sortInfo:{
		field: 'id_presupuesto',
		direction: 'ASC'
	},
	
	antEstado:function(res,eve)
     {                   
            var d= this.sm.getSelected().data;
            Phx.CP.loadingShow();
            var operacion = 'cambiar';
            operacion=  res.argument.estado == 'inicio'?'inicio':operacion; 
            
            Ext.Ajax.request({
                url:'../../sis_tesoreria/control/ObligacionPago/anteriorEstadoObligacion',
                params:{id_obligacion_pago:d.id_obligacion_pago, 
                        operacion: operacion},
                success:this.successSinc,
                failure: this.conexionFailure,
                timeout:this.timeout,
                scope:this
            });     
      },
	fin_registro: function(a,b,forzar_fin, paneldoc){                   
            var d = this.sm.getSelected().data;
            this.mostrarWizard(this.sm.getSelected());
	},
      
    preparaMenu:function(n){
          var data = this.getSelectedData();
          var tb =this.tbar;
          Phx.vista.Presupuesto.superclass.preparaMenu.call(this,n);
          
          if (data['estado']== 'borrador'){
              if(data['nro_tramite']){
              	 this.getBoton('fin_registro').enable();
              }
              
             this.getBoton('ant_estado').disable(); 
          }
          else{
          	 this.getBoton('fin_registro').disable();
          	 this.getBoton('ant_estado').disable(); 
          }
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
	bdel: false,
	bnew: false,
	bsave: false

})
</script>
		
		