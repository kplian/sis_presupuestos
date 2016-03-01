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

	constructor:function(config){
		this.maestro=config.maestro;
		this.initButtons=[this.cmbGestion];
    	//llama al constructor de la clase padre
		Phx.vista.Presupuesto.superclass.constructor.call(this,config);
		this.init();
		
		
		
		
		this.bloquearOrdenamientoGrid();
		this.cmbGestion.on('select', function(){
		    
		    if(this.validarFiltros()){
                  this.capturaFiltros();
           }
		    
		    
		},this);
		
		
		//Crea el botón para llamar a la replicación
		this.addButton('btnRepRelCon',
			{
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
				text: 'Iniciar',
				iconCls: 'bchecklist',
				disabled: false,
				handler: this.iniTramite,
				tooltip: '<b>Iniciar Trámite</b><br/>Inicia el trámite de formulación para el presupuesto'
			}
		);
	},
	cmbGestion: new Ext.form.ComboBox({
				fieldLabel: 'Gestion',
				allowBlank: true,
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
	
	validarFiltros:function(){
        if(this.cmbGestion.isValid()){
            return true;
        }
        else{
            return false;
        }
        
    },
	
	capturaFiltros:function(combo, record, index){
		
		this.desbloquearOrdenamientoGrid();
        this.store.baseParams.id_gestion=this.cmbGestion.getValue();
		
		this.load({params:{start:0, limit:50}});
	},
	
	onButtonAct:function(){
        if(!this.validarFiltros()){
            alert('Especifique los filtros antes')
         }
        else{
            this.store.baseParams.id_gestion=this.cmbGestion.getValue();
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
    		  url:'../../../sis_presupuestos/vista/presupuesto_usuario/PresupuestoUsuario.php',
    		  title:'Usuarios', 
    		  width:'60%',
    		  cls:'PresupuestoUsuario'
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
	bdel: false,
	bnew: false,
	bsave: false

})
</script>
		
		