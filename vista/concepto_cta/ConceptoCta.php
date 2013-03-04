<?php
/**
*@package pXP
*@file ConceptoCta.php
*@author  Gonzalo Sarmiento Sejas 
*@date 18-02-2013 22:57:58
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.ConceptoCta=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		
		this.maestro=config.maestro;
		this.initButtons=[this.cmbGestion];
    	//llama al constructor de la clase padre
		Phx.vista.ConceptoCta.superclass.constructor.call(this,config);
		this.init();
		 //si la interface es pestanha este código es para iniciar 
		 this.cmbGestion.on('select',this.capturaFiltros,this);
		 
	      var dataPadre = Phx.CP.getPagina(this.idContenedorPadre).getSelectedData()
	      if(dataPadre){
	         this.onEnablePanel(this, dataPadre);
	      }
	      else
	      {
	         this.bloquearMenus();
	      }
		
		
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_concepto_cta'
			},
			type:'Field',
			form:true 
		},
		{
			config:{
				name: 'id_concepto_ingas',
				fieldLabel: 'Id Concepto Ingas',
				inputType:'hidden'
			},
			type:'Field',
			form:true
		},
		{
			config:{
				name: 'id_cuenta',
				fieldLabel: 'Id Cuenta',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
			type:'NumberField',
			filters:{pfiltro:'ccta.id_cuenta',type:'numeric'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'id_auxiliar',
				fieldLabel: 'Id Auxiliar',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4 
			},
			type:'NumberField',
			filters:{pfiltro:'ccta.id_auxiliar',type:'numeric'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'id_centro_costo',
				fieldLabel: 'Id Centro Costo',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
			type:'NumberField',
			filters:{pfiltro:'ccta.id_centro_costo',type:'numeric'},
			id_grupo:1,
			grid:true,
			form:true
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
			filters:{pfiltro:'ccta.estado_reg',type:'string'},
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
			filters:{pfiltro:'ccta.fecha_reg',type:'date'},
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
				name: 'fecha_mod',
				fieldLabel: 'Fecha Modif.',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
						format: 'd/m/Y', 
						renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
			},
			type:'DateField',
			filters:{pfiltro:'ccta.fecha_mod',type:'date'},
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
	
	title:'Concepto cuenta',
	ActSave:'../../sis_presupuestos/control/ConceptoCta/insertarConceptoCta',
	ActDel:'../../sis_presupuestos/control/ConceptoCta/eliminarConceptoCta',
	ActList:'../../sis_presupuestos/control/ConceptoCta/listarConceptoCta',
	id_store:'id_concepto_cta',
	fields: [
		{name:'id_concepto_cta', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'id_auxiliar', type: 'numeric'},
		{name:'id_cuenta', type: 'numeric'},
		{name:'id_concepto_ingas', type: 'numeric'},
		{name:'id_partida', type: 'numeric'},
		{name:'id_centro_costo', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'}
		
	],
	
	cmbGestion:new Ext.form.ComboBox({
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
	sortInfo:{
		field: 'id_concepto_cta',
		direction: 'ASC'
	},
	capturaFiltros:function(combo, record, index){
		this.store.baseParams.id_gestion=this.cmbGestion.getValue();
		this.store.load({params:{start:0, limit:250}});	
	},
	onReloadPage:function(m){
		this.maestro=m;
		this.store.baseParams={
			 id_concepto_ingas:this.maestro.id_concepto_ingas,
			 id_gestion:this.cmbGestion.getValue()};
		this.load({params:{start:0, limit:50}})
		//this.getComponente('id_concepto_ingas').store.baseParams.id_tipo_proceso =this.maestro.id_tipo_proceso;		
	    
	},
	loadValoresIniciales:function()
	{
		Phx.vista.ConceptoCta.superclass.loadValoresIniciales.call(this);
		this.getComponente('id_concepto_ingas').setValue(this.maestro.id_concepto_ingas);
		
		this.getComponente('id_cuenta').store.baseParams.id_gestion= this.cmbGestion.getValue();
		this.getComponente('id_centro_costo').store.baseParams.id_gestion=this.cmbGestion.getValue();	
			
		
	},
	bdel:true,
	bsave:true
	}
)
</script>	
		