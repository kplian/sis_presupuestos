<?php
/**
*@package pXP
*@file gen-ClaseGastoPartida.php
*@author  (admin)
*@date 26-02-2016 02:33:23
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.ClaseGastoPartida=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
		this.initButtons=[this.cmbGestion];
    	//llama al constructor de la clase padre
		Phx.vista.ClaseGastoPartida.superclass.constructor.call(this,config);
		this.init();
		this.bloquearMenus();
		
		this.cmbGestion.on('select', function(){
			    if(this.validarFiltros()){
	                  this.capturaFiltros();
	           }
			},this);
		
	},
	
	cmbGestion: new Ext.form.ComboBox({
				fieldLabel: 'Gestion',
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
			
		
		
	
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_clase_gasto_partida'
			},
			type:'Field',
			form:true 
		},
		{
			config: {
				name: 'id_clase_gasto',
				inputType:'hidden',
				},
			type: 'Field',
			form: true
		},
	   	{
   			config:{
   				sysorigen:'sis_presupuestos',
       		    name:'id_partida',
   				origen:'PARTIDA',
   				allowBlank:false,
   				fieldLabel:'Partida',
   				gdisplayField:'desc_partida',//mapea al store del grid
   				gwidth:200,
   				width: 350,
   				listWidth: 350
       	     },
   			type:'ComboRec',
   			id_grupo:0,
   			filters:{	
		        pfiltro: 'p.codigo_partida#p.nombre_partida',
				type: 'string'
			},
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
				filters:{pfiltro:'cgp.estado_reg',type:'string'},
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
				filters:{pfiltro:'cgp.fecha_reg',type:'date'},
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
				filters:{pfiltro:'cgp.fecha_mod',type:'date'},
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
				filters:{pfiltro:'cgp.id_usuario_ai',type:'numeric'},
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
				filters:{pfiltro:'cgp.usuario_ai',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		}
	],
	tam_pag:50,	
	title:'CGPR',
	ActSave:'../../sis_presupuestos/control/ClaseGastoPartida/insertarClaseGastoPartida',
	ActDel:'../../sis_presupuestos/control/ClaseGastoPartida/eliminarClaseGastoPartida',
	ActList:'../../sis_presupuestos/control/ClaseGastoPartida/listarClaseGastoPartida',
	id_store:'id_clase_gasto_partida',
	fields: [
		{name:'id_clase_gasto_partida', type: 'numeric'},
		{name:'id_partida', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'id_clase_gasto', type: 'numeric'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'usuario_ai', type: 'string'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},'desc_partida','id_gestion'
		
	],
	onReloadPage:function(m){
		this.maestro=m;
		this.store.baseParams = { id_clase_gasto: this.maestro.id_clase_gasto };
		this.load({ params: {start:0, limit:50 } });
		
	},
	loadValoresIniciales:function(){
		Phx.vista.ClaseGastoPartida.superclass.loadValoresIniciales.call(this);
		this.getComponente('id_clase_gasto').setValue(this.maestro.id_clase_gasto);		
	},
	sortInfo:{
		field: 'id_clase_gasto_partida',
		direction: 'ASC'
	},
	onButtonNew:function(){
		if(this.validarFiltros()){
	       Phx.vista.ClaseGastoPartida.superclass.onButtonNew.call(this);
	       this.Cmp.id_partida.store.baseParams.id_gestion = this.cmbGestion.getValue();
		}
		else{
			alert('seleccione una gestion primero')
		}
	},
	onButtonEdit:function(){
		if(this.validarFiltros()){
	       Phx.vista.ClaseGastoPartida.superclass.onButtonEdit.call(this);
	       this.Cmp.id_partida.store.baseParams.id_gestion = this.cmbGestion.getValue();
		}
		else{
			alert('seleccione una gestion primero')
		}
	},
	onButtonDelete:function(){
		if(this.validarFiltros()){
	       Phx.vista.ClaseGastoPartida.superclass.onButtonDelete.call(this);
	     }
		else{
			alert('seleccione una gestion primero')
		}
	},
	capturaFiltros:function(combo, record, index){
	        this.desbloquearOrdenamientoGrid();
	        this.store.baseParams.id_gestion=this.cmbGestion.getValue();
	        this.load(); 
	            
	        
	    },
	validarFiltros:function(){
	        if(this.cmbGestion.isValid()){
	            return true;
	        }
	        else{
	            return false;
	        }	        
	},	
	bdel:true,
	bsave:true
	}
)
</script>
		
		