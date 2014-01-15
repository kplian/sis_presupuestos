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
    	//llama al constructor de la clase padre
		Phx.vista.Presupuesto.superclass.constructor.call(this,config);
		this.init();
		this.load({params:{start:0, limit:50}})
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
				name: 'id_centro_costo',
				fieldLabel: 'Centro Costo',
				allowBlank: false,
				emptyText : 'Centro Costo...',
				store : new Ext.data.JsonStore({
							url:'../../sis_parametros/control/CentroCosto/listarCentroCosto',
							id : 'id_centro_costo',
							root: 'datos',
							sortInfo:{
									field: 'codigo_cc',
									direction: 'ASC'
							},
							totalProperty: 'total',
							fields: ['id_centro_costo','codigo_cc'],
							remoteSort: true,
							baseParams:{par_filtro:'codigo_cc'}
				}),
				valueField: 'id_centro_costo',
	   displayField: 'codigo_cc',
	   gdisplayField: 'codigo_cc',
	   hiddenName: 'id_centro_costo',
	   forceSelection:true,
	   typeAhead: true,
	   triggerAction: 'all',
	   lazyRender:true,
	   mode:'remote',
	   pageSize:10,
	   queryDelay:1000,
	   width:250,
	   minChars:2,
	   renderer:function(value, p, record){return String.format('{0}', record.data['codigo_cc']);}
			},
			type:'ComboBox',
			filters:{pfiltro:'pre.id_centro_costo',type:'numeric'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'tipo_pres',
				fieldLabel: 'Tipo Pres',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:30
			},
			type:'TextField',
			filters:{pfiltro:'pre.tipo_pres',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'estado_pres',
				fieldLabel: 'Estado Presupuesto',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:30
			},
			type:'TextField',
			filters:{pfiltro:'pre.estado_pres',type:'string'},
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
		{name:'usr_mod', type: 'string'},
		
	],
	sortInfo:{
		field: 'id_presupuesto',
		direction: 'ASC'
	},
	bdel:true,
	bsave:true

})
</script>
		
		