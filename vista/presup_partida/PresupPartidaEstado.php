<?php
/**
*@package pXP
*@file gen-PresupPartida.php
*@author  (admin)
*@date 29-02-2016 19:40:34
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.PresupPartidaEstado=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.PresupPartidaEstado.superclass.constructor.call(this,config);
		this.init();
		this.bloquearMenus();
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_presup_partida'
			},
			type:'Field',
			form:false 
		},
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_presupuesto'
			},
			type:'Field',
			form:false 
		},
	   	{
   			config:{
   				sysorigen:'sis_presupuestos',
       		    name:'id_partida',
   				origen:'PARTIDA',
   				allowBlank:false,
   				fieldLabel:'Partida',
   				gdisplayField:'desc_partida',//mapea al store del grid
   				baseParams: {sw_transaccional: 'movimiento', partida_tipo: 'presupuestaria'},
   				renderer:function(value, p, record){
   					
   					 if(record.data.tipo_reg != 'summary'){
	            	   return String.format('{0} - ({1})', record.data['desc_partida'],   record.data['desc_gestion']);
	            	 }
	            	 else{
	            	 	''
	            	 }
               	 
                },
   				gwidth:459,
   				width: 280,
   				listWidth: 350
       	     },
   			type:'ComboRec',
   			bottom_filter: true,
   			id_grupo:0,
   			filters:{	
		        pfiltro: 'par.codigo#par.nombre_partida',
				type: 'string'
			},
   		   
   			grid:true,   			
   			form:false
	   	},
		
		{
			config:{
				name: 'importe',
				fieldLabel: 'Según Memoria',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:1179650,
				renderer:function (value,p,record){
						if(record.data.tipo_reg != 'summary'){
							return  String.format('{0}', value);
						}
						else{
							return  String.format('<b><font size=2 >{0}</font><b>', value);
						}
						
					}
			},
				type:'NumberField',
				filters:{pfiltro:'prpa.importe',type:'numeric'},
				id_grupo:1,
				grid: true,
				form: false
		},
		
		{
			config:{
				name: 'importe_aprobado',
				fieldLabel: 'Aprobado',
				gwidth: 100,
				renderer:function (value,p,record){
						if(record.data.tipo_reg != 'summary'){
							return  String.format('{0}', value);
						}
						else{
							return  String.format('<b><font size=2 >{0}</font><b>', value);
						}
						
					}
			},
				type: 'NumberField',
				filters: { pfiltro:'prpa.importe', type: 'numeric' },
				id_grupo: 1,
				grid: true,
				form: false
		},
		{
			config:{
				name: 'formulado',
				fieldLabel: 'Formulado',
				gwidth: 100,
				renderer:function (value,p,record){
						if(record.data.tipo_reg != 'summary'){
							return  String.format('{0}', value);
						}
						else{
							return  String.format('<b><font size=2 >{0}</font><b>', value);
						}
						
					}
			},
				type: 'NumberField',
				filters: { pfiltro:'prpa.formulado', type: 'numeric' },
				id_grupo: 1,
				grid: true,
				form: false
		},
		{
			config:{
				name: 'comprometido',
				fieldLabel: 'Comprometido',
				gwidth: 100,
				renderer:function (value,p,record){
						if(record.data.tipo_reg != 'summary'){
							return  String.format('{0}', value);
						}
						else{
							return  String.format('<b><font size=2 >{0}</font><b>', value);
						}
						
					}
			},
				type: 'NumberField',
				filters: { pfiltro:'prpa.comprometido', type: 'numeric' },
				id_grupo: 1,
				grid: true,
				form: false
		},
		{
			config:{
				name: 'ejecutado',
				fieldLabel: 'Ejecutado',
				gwidth: 100,
				renderer:function (value,p,record){
						if(record.data.tipo_reg != 'summary'){
							return  String.format('{0}', value);
						}
						else{
							return  String.format('<b><font size=2 >{0}</font><b>', value);
						}
						
					}
			},
				type: 'NumberField',
				filters: { pfiltro:'prpa.ejecutado', type: 'numeric' },
				id_grupo: 1,
				grid: true,
				form: false
		},
		{
			config:{
				name: 'pagado',
				fieldLabel: 'Pagado',
				gwidth: 100,
				renderer:function (value,p,record){
						if(record.data.tipo_reg != 'summary'){
							return  String.format('{0}', value);
						}
						else{
							return  String.format('<b><font size=2 >{0}</font><b>', value);
						}
						
					}
			},
				type: 'NumberField',
				filters: { pfiltro:'prpa.pagado', type: 'numeric' },
				id_grupo: 1,
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
				filters:{pfiltro:'prpa.estado_reg',type:'string'},
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
				filters:{pfiltro:'prpa.fecha_reg',type:'date'},
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
				filters:{pfiltro:'prpa.fecha_mod',type:'date'},
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
				filters:{pfiltro:'prpa.id_usuario_ai',type:'numeric'},
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
				filters:{pfiltro:'prpa.usuario_ai',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		}
	],
	tam_pag:50,	
	title:'PREPAR',
	ActList:'../../sis_presupuestos/control/PresupPartida/listarPresupPartidaEstado',
	id_store:'id_presup_partida',
	fields: [
		{name:'id_presup_partida', type: 'numeric'},
		{name:'tipo', type: 'string'},
		{name:'id_moneda', type: 'numeric'},
		{name:'id_partida', type: 'numeric'},
		{name:'id_centro_costo', type: 'numeric'},
		{name:'fecha_hora', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'estado_reg', type: 'string'},
		{name:'id_presupuesto', type: 'numeric'},
		{name:'importe', type: 'numeric'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'usuario_ai', type: 'string'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},'desc_partida','desc_gestion','importe_aprobado','tipo_reg',
		'formulado','comprometido','ejecutado','pagado'
		
	],
	
	onReloadPage:function(m){
		this.maestro=m;
        this.store.baseParams={id_presupuesto:this.maestro.id_presupuesto};
        this.load({ params: { start: 0, limit: 50 }});
        
    },
    
	sortInfo:{
		field: 'id_presup_partida',
		direction: 'ASC'
	},
	bdel: false,
	bedit: false,
	bsave: false,
	bnew: false
})
</script>
		
		