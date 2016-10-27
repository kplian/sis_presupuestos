<?php
/**
*@package pXP
*@file gen-AgrupadorPresupuesto.php
*@author  (gvelasquez)
*@date 25-10-2016 19:21:34
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.AgrupadorPresupuesto=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.AgrupadorPresupuesto.superclass.constructor.call(this,config);

		this.init();
		//this.load({params:{start:0, limit:this.tam_pag}})
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_agrupador_presupuesto'
			},
			type:'Field',
			form:true 
		},
		{
			//configuracion del componente
			config:{
				labelSeparator:'',
				inputType:'hidden',
				name: 'id_agrupador'
			},
			type:'Field',
			form:true
		},
		{
			config:{
				name: 'gestion',
				fieldLabel: 'Gestión',
				allowBlank: true,
				anchor: '80%',
				gwidth: 50,
				maxLength:4
			},
			type:'Field',
			id_grupo:0,
			grid:true,
			form:false
		},
		{
			config:{
				sysorigen: 'sis_presupuestos',
				name: 'id_presupuesto',
				fieldLabel: 'ID',
				allowBlank: true,
				tinit: false,
				baseParams: {_adicionar:'si'},
				origen: 'PRESUPUESTO',
				width: 350,
				listWidth: 350,
				gwidth: 50
			},
			type: 'ComboRec',
			id_grupo: 0,
			grid: true,
			form: true
		},

		{
			config:{
				name: 'descripcion_pre',
				fieldLabel: 'Presupuesto',
				allowBlank: true,
				anchor: '80%',
				gwidth: 200,
				maxLength:4
			},
			type:'TextField',
			filters:{pfiltro:'pre.descripcion',type:'string'},
			id_grupo:1,
			bottom_filter: true,
			grid:true,
			form:false
		},
		{
			config:{
				name: 'nombre_uo',
				fieldLabel: 'Unidad Organizacional',
				allowBlank: true,
				anchor: '80%',
				gwidth: 300,
				maxLength:4
			},
			type:'TextField',
			filters:{pfiltro:'pre.nombre_uo',type:'string'},
			id_grupo:1,
			bottom_filter: true,
			grid:true,
			form:false
		},
		{
			config:{
				name: 'desc_tipo_presupuesto',
				fieldLabel: 'Tipo',
				allowBlank: true,
				anchor: '80%',
				gwidth: 80,
				maxLength:4
			},
			type:'Field',
			filters:{pfiltro:'pre.desc_tipo_presupuesto',type:'string'},
			id_grupo:1,
			grid:true,
			form:false
		},
		{
			config:{
				name: 'codigo_categoria',
				fieldLabel: 'Cod. Categoría',
				allowBlank: true,
				anchor: '80%',
				gwidth: 150,
				maxLength:4
			},
			type:'TextField',
			filters:{pfiltro:'cat.codigo_categoria',type:'string'},
			id_grupo:1,
			bottom_filter: true,
			grid:true,
			form:false
		},
		{
			config:{
				name: 'descripcion_cat',
				fieldLabel: 'Categoría Programática',
				allowBlank: true,
				anchor: '80%',
				gwidth: 300,
				maxLength:4
			},
			type:'TextField',
			filters:{pfiltro:'cat.descripcion',type:'string'},
			id_grupo:1,
			bottom_filter: true,
			grid:true,
			form:false
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
				filters:{pfiltro:'agrpre.estado_reg',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},

		{
			config:{
				name: 'id_usuario_ai',
				fieldLabel: '',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
				type:'Field',
				filters:{pfiltro:'agrpre.id_usuario_ai',type:'numeric'},
				id_grupo:1,
				grid:false,
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
				name: 'usuario_ai',
				fieldLabel: 'Funcionaro AI',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:300
			},
				type:'TextField',
				filters:{pfiltro:'agrpre.usuario_ai',type:'string'},
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
				filters:{pfiltro:'agrpre.fecha_reg',type:'date'},
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
				filters:{pfiltro:'agrpre.fecha_mod',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		}
	],
	tam_pag:50,	
	title:'Presupuesto',
	ActSave:'../../sis_presupuestos/control/AgrupadorPresupuesto/insertarAgrupadorPresupuesto',
	ActDel:'../../sis_presupuestos/control/AgrupadorPresupuesto/eliminarAgrupadorPresupuesto',
	ActList:'../../sis_presupuestos/control/AgrupadorPresupuesto/listarAgrupadorPresupuesto',
	id_store:'id_agrupador_presupuesto',
	fields: [
		{name:'id_agrupador_presupuesto', type: 'numeric'},
		{name:'id_presupuesto', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'id_agrupador', type: 'numeric'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'usuario_ai', type: 'string'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},'gestion', 'nombre_uo', 'descripcion_pre', 'nombre_uo', 'desc_tipo_presupuesto', 'codigo_categoria', 'descripcion_cat'
		
	],
	sortInfo:{
		field: 'id_agrupador_presupuesto',
		direction: 'ASC'
	},
	onReloadPage:function(m){
		this.maestro=m;
		this.store.baseParams={id_agrupador:this.maestro.id_agrupador};
		this.load({params:{start:0, limit:50}});
	},
	loadValoresIniciales:function()
	{
		Phx.vista.AgrupadorPresupuesto.superclass.loadValoresIniciales.call(this);
		this.Cmp.id_agrupador.setValue(this.maestro.id_agrupador);
	},
	successSave:function(resp){
		Phx.vista.AgrupadorPresupuesto.superclass.successSave.call(this,resp);
		Phx.CP.getPagina(this.idContenedorPadre).reload();

	},
	bdel:true,
	bsave:true
	}
)
</script>
		
		