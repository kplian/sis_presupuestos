<?php
/**
*@package pXP
*@file gen-Objetivo.php
*@author  (gvelasquez)
*@date 20-07-2016 20:37:41
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.Objetivo=Ext.extend(Phx.arbGridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
		this.initButtons=[this.cmbGestion];
    	//llama al constructor de la clase padre
		Phx.vista.Objetivo.superclass.constructor.call(this,config);
		this.loaderTree.baseParams={id_gestion:0};
		this.init();
		
		//this.load({params:{start:0, limit:this.tam_pag}})
		this.cmbGestion.on('select',this.capturaFiltros,this);
		
	},
	
	successRep:function(resp){
        Phx.CP.loadingHide();
        var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
        if(!reg.ROOT.error){
            this.reload();
            alert(reg.ROOT.datos.observaciones)
        }else{
            alert('Ocurrió un error durante el proceso')
        }
	},
	
	capturaFiltros:function(combo, record, index){
		
		this.loaderTree.baseParams={id_gestion:this.cmbGestion.getValue()};
		this.root.reload();
	},
	
	loadValoresIniciales:function()
	{
		Phx.vista.Objetivo.superclass.loadValoresIniciales.call(this);
		this.getComponente('id_gestion').setValue(this.cmbGestion.getValue());	
		
	},	
				
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_objetivo'
			},
			type:'Field',
			form:true 
		},
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_gestion'
			},
			type:'Field',
			form:true 
		},
		{
			config:{
				name: 'id_objetivo_fk',
				inputType:'hidden'
			},
			type:'Field',
			form:true
		},	
		
		{
			config:{
				name: 'text',
				fieldLabel: 'Objetivo',
				allowBlank: false,
				anchor: '80%',
				gwidth: 400,
				maxLength:100
			},
			type:'TextField',
			id_grupo:1,
			grid:true,
			form:false
		},
		{
			config:{
				name: 'codigo',
				fieldLabel: 'Codigo',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:30
			},
				type:'TextField',
				filters:{pfiltro:'obj.codigo',type:'string'},
				id_grupo:1,
				grid:false,
				form:true
		},	
		
		{
			config:{
				name: 'tipo_objetivo',
				fieldLabel: 'Tipo',
				allowBlank: true,
				anchor: '80%',
				gwidth: 140,
				mode: 'local',
				store:['Objetivo Institucional','Objetivo de Gestion', 'Objetivo Específico', 'Operación', 'Actividad']
			},
				type:'ComboBox',
				filters:{pfiltro:'obj.tipo_objetivo',type:'string'},
				id_grupo:1,
				filters:{
	       		         type: 'list',
	       		         pfiltro:'obj.tipo_objetivo',
	       				 options: ['Objetivo Institucional','Objetivo de Gestion'],	
	       		 	},
				grid:true,
				form:true
		},

		{
			config:{
				name: 'descripcion',
				fieldLabel: 'Descripcion',
				allowBlank: true,
				anchor: '80%',
				gwidth: 400,
				maxLength:1000
			},
				type:'TextField',
				filters:{pfiltro:'obj.descripcion',type:'string'},
				id_grupo:1,
				grid:false,
				form:true
		},
		{
			config:{
				name: 'indicador_logro',
				fieldLabel: 'Indicador de Logro',
				allowBlank: true,
				anchor: '80%',
				gwidth: 300,
				maxLength:1000
			},
				type:'TextField',
				filters:{pfiltro:'obj.indicador_logro',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
		
		{
			config:{
				name: 'periodo_ejecucion',
				fieldLabel: 'Periodo de Ejecucion',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:100
			},
				type:'TextField',
				filters:{pfiltro:'obj.periodo_ejecucion',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
		
		{
			config:{
				name: 'ponderacion',
				fieldLabel: 'Ponderacion (%)',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:1245186
			},
				type:'NumberField',
				filters:{pfiltro:'obj.ponderacion',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:true
		},
		
		{
			config:{
				name: 'producto',
				fieldLabel: 'Producto',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:500
			},
				type:'TextField',
				filters:{pfiltro:'obj.producto',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
		
		{
			config:{
				name: 'linea_base',
				fieldLabel: 'Linea Base',
				allowBlank: true,
				anchor: '80%',
				gwidth: 200,
				maxLength:500
			},
				type:'TextField',
				filters:{pfiltro:'obj.linea_base',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
		
		{
			config:{
				name: 'fecha_inicio',
				fieldLabel: 'Fecha Inicio',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
							format: 'd/m/Y', 
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
			},
				type:'DateField',
				filters:{pfiltro:'obj.fecha_inicio',type:'date'},
				id_grupo:1,
				grid:true,
				form:true
		},
		
		{
			config:{
				name: 'fecha_fin',
				fieldLabel: 'Fecha Fin',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
							format: 'd/m/Y', 
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
			},
				type:'DateField',
				filters:{pfiltro:'obj.fecha_fin',type:'date'},
				id_grupo:1,
				grid:true,
				form:true
		},
		
		{
			config:{
				name: 'unidad_verificacion',
				fieldLabel: 'Medio de Verificacion',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:100
			},
				type:'TextField',
				filters:{pfiltro:'obj.unidad_verificacion',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
		
		{
			config:{
				name: 'cantidad_verificacion',
				fieldLabel: 'Cantidad Verificacion',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:1245186
			},
				type:'NumberField',
				filters:{pfiltro:'obj.cantidad_verificacion',type:'numeric'},
				id_grupo:1,
				grid:false,
				form:true
		},
		
		
		
		{
			config:{
				name: 'nivel_objetivo',
				fieldLabel: 'Nivel Objetivo',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
				type:'NumberField',
				filters:{pfiltro:'obj.nivel_objetivo',type:'numeric'},
				id_grupo:1,
				grid:false,
				form:true
		},
		{
			config:{
				name: 'sw_transaccional',
				fieldLabel: 'Transaccional',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:20
			},
				type:'TextField',
				filters:{pfiltro:'obj.sw_transaccional',type:'string'},
				id_grupo:1,
				grid:false,
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
				filters:{pfiltro:'obj.estado_reg',type:'string'},
				id_grupo:1,
				grid:false,
				form:false
		},
		/*{
			config: {
				name: 'id_parametros',
				fieldLabel: 'id_parametros',
				allowBlank: true,
				emptyText: 'Elija una opción...',
				store: new Ext.data.JsonStore({
					url: '../../sis_/control/Clase/Metodo',
					id: 'id_',
					root: 'datos',
					sortInfo: {
						field: 'nombre',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_', 'nombre', 'codigo'],
					remoteSort: true,
					baseParams: {par_filtro: 'movtip.nombre#movtip.codigo'}
				}),
				valueField: 'id_',
				displayField: 'nombre',
				gdisplayField: 'desc_',
				hiddenName: 'id_parametros',
				forceSelection: true,
				typeAhead: false,
				triggerAction: 'all',
				lazyRender: true,
				mode: 'remote',
				pageSize: 15,
				queryDelay: 1000,
				anchor: '100%',
				gwidth: 150,
				minChars: 2,
				renderer : function(value, p, record) {
					return String.format('{0}', record.data['desc_']);
				}
			},
			type: 'ComboBox',
			id_grupo: 0,
			filters: {pfiltro: 'movtip.nombre',type: 'string'},
			grid: false,
			form: true
		},*/
		
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
				filters:{pfiltro:'obj.fecha_reg',type:'date'},
				id_grupo:1,
				grid:false,
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
				filters:{pfiltro:'obj.usuario_ai',type:'string'},
				id_grupo:1,
				grid:false,
				form:false
		},
		
		{
			config:{
				name: 'id_usuario_ai',
				fieldLabel: 'Creado por',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
				type:'Field',
				filters:{pfiltro:'obj.id_usuario_ai',type:'numeric'},
				id_grupo:1,
				grid:false,
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
				filters:{pfiltro:'obj.fecha_mod',type:'date'},
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
				grid:false,
				form:false
		}
	],
	//tam_pag:50,	
	title:'Objetivo',
	ActSave:'../../sis_presupuestos/control/Objetivo/insertarObjetivo',
	ActDel:'../../sis_presupuestos/control/Objetivo/eliminarObjetivo',
	ActList:'../../sis_presupuestos/control/Objetivo/listarObjetivoArb',
	id_store:'id_objetivo',
	textRoot:'OBJETIVOS',
    id_nodo:'id_objetivo',
    id_nodo_p:'id_objetivo_fk',
	
	fields: [
		{name:'id_objetivo', type: 'numeric'},
		{name:'id_objetivo_fk', type: 'numeric'},
		{name:'nivel_objetivo', type: 'numeric'},
		{name:'sw_transaccional', type: 'string'},
		{name:'cantidad_verificacion', type: 'numeric'},
		{name:'unidad_verificacion', type: 'string'},
		{name:'ponderacion', type: 'numeric'},
		{name:'fecha_inicio', type: 'date',dateFormat:'Y-m-d'},
		{name:'tipo_objetivo', type: 'string'},
		{name:'descripcion', type: 'string'},
		{name:'linea_base', type: 'string'},
		{name:'estado_reg', type: 'string'},
		{name:'id_parametros', type: 'numeric'},
		{name:'indicador_logro', type: 'string'},
		{name:'id_gestion', type: 'numeric'},
		{name:'codigo', type: 'string'},
		{name:'periodo_ejecucion', type: 'string'},
		{name:'producto', type: 'string'},
		{name:'fecha_fin', type: 'date',dateFormat:'Y-m-d'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usuario_ai', type: 'string'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		
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
						direction: 'DESC'
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
		field: 'id_objetivo',
		direction: 'ASC'
	},
	bdel:true,
	bsave:false,
	rootVisible:true,
	expanded:false,
	
	onButtonNew:function(){
		if(this.cmbGestion.getValue()){
	        var nodo = this.sm.getSelectedNode();           
	        Phx.vista.Objetivo.superclass.onButtonNew.call(this);
	     }
	     else
	     {
	     	alert("Seleccione una gestion primero.");
	     	
	     }   
    },



    preparaMenu:function(n){
		var rec = this.getSelectedData();
        if(n.attributes.tipo_nodo == 'hijo' || n.attributes.tipo_nodo == 'raiz' || n.attributes.id == 'id'){
            this.tbar.items.get('b-new-'+this.idContenedor).enable()
        }
        else {
            this.tbar.items.get('b-new-'+this.idContenedor).disable()
        }
        // llamada funcion clase padre
		Phx.vista.Objetivo.superclass.preparaMenu.call(this,n);

    },


	enableTabPartida:function(){
		if(this.TabPanelEast.get(0)){
			this.TabPanelEast.get(0).enable();
			this.TabPanelEast.setActiveTab(0);
		}
	},

	disableTabPartida:function(){
		if(this.TabPanelEast.get(0)){
			this.TabPanelEast.get(0).disable();
		}
	},

	tabeast:[
		{
            url:'../../../sis_presupuestos/vista/objetivo_partida/ObjetivoPartida.php',
            title:'Partidas',
            width:'50%',
            cls:'ObjetivoPartida'
        },
        {
            url:'../../../sis_presupuestos/vista/objetivo_presupuesto/ObjetivoPresupuesto.php',
            title:'Presupuestos',
            width:'50%',
            cls:'ObjetivoPresupuesto'
        }]
}
)
</script>
		
		