<?php
/**
*@package pXP
*@file gen-CategoriaProgramatica.php
*@author  (admin)
*@date 19-04-2016 15:30:34
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.CategoriaProgramatica=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
		var me = this;
		me.maestro=config.maestro;
    	me.initButtons=[me.cmbGestion];
    	//llama al constructor de la clase padre
		Phx.vista.CategoriaProgramatica.superclass.constructor.call(this,config);
		this.cmbGestion.on('select', function(combo, record, index){
			this.capturaFiltros();
			var id_gestion = this.cmbGestion.getValue();
			
			this.Cmp.id_cp_actividad.store.baseParams.id_gestion = id_gestion;
	        this.Cmp.id_cp_actividad.modificado =true;
	        this.Cmp.id_cp_programa.store.baseParams.id_gestion = id_gestion;
	        this.Cmp.id_cp_programa.modificado = true;
	        this.Cmp.id_cp_proyecto.store.baseParams.id_gestion = id_gestion;
	        this.Cmp.id_cp_proyecto.modificado = true;
	        this.Cmp.id_cp_fuente_fin.store.baseParams.id_gestion = id_gestion;
	        this.Cmp.id_cp_fuente_fin.modificado = true;
	        this.Cmp.id_cp_organismo_fin.store.baseParams.id_gestion = id_gestion;
	        this.Cmp.id_cp_organismo_fin.modificado = true;
			
			
        },this);
		
		this.bloquearOrdenamientoGrid();
		this.init();
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_categoria_programatica'
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
				name: 'codigo_categoria',
				fieldLabel: 'Código',
				allowBlank: false,
				anchor: '80%',
				gwidth: 200,
				maxLength:400
			},
				type:'TextArea',
				filters:{pfiltro:'codigo_categoria',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'descripcion',
				fieldLabel: 'descripcion',
				allowBlank: false,
				anchor: '80%',
				gwidth: 180,
				maxLength:400
			},
				type:'TextArea',
				filters:{pfiltro:'cpr.descripcion',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
		
		
		{
			
			config: {
				name: 'id_cp_programa',
				fieldLabel: 'Programa',
				allowBlank: true,
				emptyText: 'Elija una opción...',
				store: new Ext.data.JsonStore({
					url: '../../sis_presupuestos/control/CpPrograma/listarCpPrograma',
					id: 'id_cp_programa',
					root: 'datos',
					sortInfo: {
						field: 'codigo',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_cp_programa', 'descripcion', 'codigo'],
					remoteSort: true,
					baseParams: {par_filtro: 'codigo#descripcion'}
				}),
				valueField: 'id_cp_programa',
				displayField: 'descripcion',
				gdisplayField: 'desc_programa',
				hiddenName: 'id_cp_programa',
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
				tpl:'<tpl for="."><div class="x-combo-list-item"><p>{codigo}-{descripcion}</p> </div></tpl>',
				renderer : function(value, p, record) {
					return String.format('({1})  {0}', record.data['desc_programa'],record.data['codigo_programa']);
				}
			},
			type: 'ComboBox',
			id_grupo: 0,
			filters: {pfiltro: 'desc_programa',type: 'string'},
			grid: true,
			form: true
		},
		{
			config: {
				name: 'id_cp_proyecto',
				fieldLabel: 'Proyecto',
				allowBlank: true,
				emptyText: 'Elija una opción...',
				store: new Ext.data.JsonStore({
					url: '../../sis_presupuestos/control/CpProyecto/listarCpProyecto',
					id: 'id_cp_proyecto',
					root: 'datos',
					sortInfo: {
						field: 'codigo',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_cp_proyecto', 'descripcion', 'codigo'],
					remoteSort: true,
					baseParams: {par_filtro: 'codigo#descripcion'}
				}),
				valueField: 'id_cp_proyecto',
				displayField: 'descripcion',
				gdisplayField: 'desc_proyecto',
				hiddenName: 'id_cp_proyecto',
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
				tpl:'<tpl for="."><div class="x-combo-list-item"><p>{codigo}-{descripcion}</p> </div></tpl>',
				renderer : function(value, p, record) {
					return String.format('({1})  {0}', record.data['desc_proyecto'],record.data['codigo_proyecto']);
				}
			},
			type: 'ComboBox',
			id_grupo: 0,
			filters: {pfiltro: 'desc_proyecto',type: 'string'},
			grid: true,
			form: true
		},
		{
			config: {
				name: 'id_cp_actividad',
				fieldLabel: 'Actividad',
				allowBlank: true,
				emptyText: 'Elija una opción...',
				store: new Ext.data.JsonStore({
					url: '../../sis_presupuestos/control/CpActividad/listarCpActividad',
					id: 'id_cp_actividad',
					root: 'datos',
					sortInfo: {
						field: 'codigo',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_cp_actividad', 'descripcion', 'codigo'],
					remoteSort: true,
					baseParams: {par_filtro: 'codigo#descripcion'}
				}),
				valueField: 'id_cp_actividad',
				displayField: 'descripcion',
				gdisplayField: 'desc_actividad',
				hiddenName: 'id_cp_actividad',
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
				tpl:'<tpl for="."><div class="x-combo-list-item"><p>{codigo}-{descripcion}</p> </div></tpl>',
				renderer : function(value, p, record) {
					return String.format('({1})  {0}', record.data['desc_actividad'],record.data['codigo_actividad']);
				}
			},
			type: 'ComboBox',
			id_grupo: 0,
			filters: {pfiltro: 'desc_actividad',type: 'string'},
			grid: true,
			form: true
		},
		{
			config: {
				name: 'id_cp_organismo_fin',
				fieldLabel: 'Organismo Financiador',
				allowBlank: true,
				emptyText: 'Elija una opción...',
				store: new Ext.data.JsonStore({
					url: '../../sis_presupuestos/control/CpOrganismoFin/listarCpOrganismoFin',
					id: 'id_cp_organismo_fin',
					root: 'datos',
					sortInfo: {
						field: 'codigo',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_cp_organismo_fin', 'descripcion', 'codigo'],
					remoteSort: true,
					baseParams: {par_filtro: 'codigo#descripcion'}
				}),
				valueField: 'id_cp_organismo_fin',
				displayField: 'descripcion',
				gdisplayField: 'desc_origen_fin',
				hiddenName: 'id_cp_organismo_fin',
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
				tpl:'<tpl for="."><div class="x-combo-list-item"><p>{codigo}-{descripcion}</p> </div></tpl>',
				renderer : function(value, p, record) {
					return String.format('({1})  {0}', record.data['desc_origen_fin'],record.data['codigo_origen_fin']);
				}
			},
			type: 'ComboBox',
			id_grupo: 0,
			filters: {pfiltro: 'desc_organismo_fin',type: 'string'},
			grid: true,
			form: true
		},
		
		{
			config: {
				name: 'id_cp_fuente_fin',
				fieldLabel: 'Fuente Financiador',
				allowBlank: true,
				emptyText: 'Elija una opción...',
				store: new Ext.data.JsonStore({
					url: '../../sis_presupuestos/control/CpFuenteFin/listarCpFuenteFin',
					id: 'id_cp_fuente_fin',
					root: 'datos',
					sortInfo: {
						field: 'codigo',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_cp_fuente_fin', 'descripcion', 'codigo'],
					remoteSort: true,
					baseParams: {par_filtro: 'codigo#descripcion'}
				}),
				valueField: 'id_cp_fuente_fin',
				displayField: 'descripcion',
				gdisplayField: 'desc_fuente_fin',
				hiddenName: 'id_cp_fuente_fin',
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
				tpl:'<tpl for="."><div class="x-combo-list-item"><p>{codigo}-{descripcion}</p> </div></tpl>',
				renderer : function(value, p, record) {
					return String.format('({1})  {0}', record.data['desc_fuente_fin'],record.data['codigo_fuente_fin']);
				}
			},
			type: 'ComboBox',
			id_grupo: 0,
			filters: {pfiltro: 'desc_fuente_fin',type: 'string'},
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
				filters:{pfiltro:'cpr.estado_reg',type:'string'},
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
				filters:{pfiltro:'cpr.id_usuario_ai',type:'numeric'},
				id_grupo:1,
				grid:false,
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
				filters:{pfiltro:'cpr.fecha_reg',type:'date'},
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
				filters:{pfiltro:'cpr.usuario_ai',type:'string'},
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
				name: 'fecha_mod',
				fieldLabel: 'Fecha Modif.',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
							format: 'd/m/Y', 
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
			},
				type:'DateField',
				filters:{pfiltro:'cpr.fecha_mod',type:'date'},
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
		}
	],
	tam_pag:50,	
	title:'Categoría Programatica',
	ActSave:'../../sis_presupuestos/control/CategoriaProgramatica/insertarCategoriaProgramatica',
	ActDel:'../../sis_presupuestos/control/CategoriaProgramatica/eliminarCategoriaProgramatica',
	ActList:'../../sis_presupuestos/control/CategoriaProgramatica/listarCategoriaProgramatica',
	id_store:'id_categoria_programatica',
	fields: [
		{name:'id_categoria_programatica', type: 'numeric'},
		{name:'id_cp_actividad', type: 'numeric'},
		{name:'id_gestion', type: 'numeric'},
		{name:'id_cp_organismo_fin', type: 'numeric'},
		{name:'descripcion', type: 'string'},
		{name:'id_cp_programa', type: 'numeric'},
		{name:'id_cp_fuente_fin', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'id_cp_proyecto', type: 'numeric'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usuario_ai', type: 'string'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		'codigo_programa', 'codigo_proyecto','codigo_actividad','codigo_fuente_fin','codigo_origen_fin','desc_programa',
        'desc_proyecto','desc_actividad','desc_fuente_fin','desc_origen_fin','codigo_categoria','gestion'
		
	],
	sortInfo:{
		field: 'id_categoria_programatica',
		direction: 'ASC'
	},
	
	cmbGestion: new Ext.form.ComboBox({
				fieldLabel: 'Gestion',
				allowBlank: false,
				emptyText:'Gestion...',
				blankText: 'Año',
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
	
	capturaFiltros:function(combo, record, index){
        this.desbloquearOrdenamientoGrid();
        if(this.validarFiltros()){
        	this.store.baseParams.id_gestion = this.cmbGestion.getValue();
	        this.load(); 
        }
        
    },
    
    validarFiltros:function(){
        if(this.cmbGestion.validate()){
            this.desbloquearOrdenamientoGrid();
            return true;
        }
        else{
            this.bloquearOrdenamientoGrid();
            return false;
        }
    },
    onButtonAct:function(){
    	if(!this.validarFiltros()){
            alert('Especifique los filtros antes')
        }
    },
    
     onButtonAct:function(){
        if(!this.validarFiltros()){
            alert('Especifique el año y el mes antes')
         }
        else{
            this.store.baseParams.id_gestion=this.cmbGestion.getValue();
            Phx.vista.CategoriaProgramatica.superclass.onButtonAct.call(this);
        }
    },
    
    onButtonNew:function(){
	    if(!this.validarFiltros()){
	        alert('Especifique el año y el mes antes')
	    }
	    else{
	      Phx.vista.CategoriaProgramatica.superclass.onButtonNew.call(this);
	      this.Cmp.id_gestion.setValue(this.cmbGestion.getValue());
	      
	       
	    } 
    },
    
    
	bdel:true,
	bsave:false
	}
)
</script>
		
		