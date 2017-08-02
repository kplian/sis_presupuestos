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
Phx.vista.PresupPartida=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.PresupPartida.superclass.constructor.call(this,config);
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
			form:true 
		},
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
   				sysorigen: 'sis_presupuestos',
       		    name: 'id_partida',
   				origen: 'PARTIDA',
   				allowBlank: false,
   				fieldLabel: 'Partida',
   				gdisplayField: 'desc_partida',//mapea al store del grid
   				baseParams: { sw_transaccional: 'movimiento', partida_tipo: 'presupuestaria'},
   				renderer: function(value, p, record){
   					
   					 if(record.data.tipo_reg != 'summary'){
	            	   return String.format('{0} - ({1})', record.data['desc_partida'],   record.data['desc_gestion']);
	            	 }
	            	 else{
	            	 	''
	            	 }
                },
   				gwidth:350,
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
   			form:true
	   	},
		
		{
			config:{
				name: 'importe',
				fieldLabel: 'Importe',
				allowBlank: true,
				anchor: '80%',
				gwidth: 130,
				maxLength:1179650,
				renderer:function (value,p,record){

					 Number.prototype.formatDinero = function(c, d, t){
					 var n = this,
					 c = isNaN(c = Math.abs(c)) ? 2 : c,
					 d = d == undefined ? "." : d,
					 t = t == undefined ? "," : t,
					 s = n < 0 ? "-" : "",
					 i = parseInt(n = Math.abs(+n || 0).toFixed(c)) + "",
					 j = (j = i.length) > 3 ? j % 3 : 0;
					 return s + (j ? i.substr(0, j) + t : "") + i.substr(j).replace(/(\d{3})(?=\d)/g, "$1" + t) + (c ? d + Math.abs(n - i).toFixed(c).slice(2) : "");
					 };

					 if(record.data.tipo_reg != 'summary'){

					 return  String.format('<div style="vertical-align:middle;text-align:right;"><span >{0}</span></div>',(parseFloat(value)).formatDinero(2, ',', '.'));
					 }
					 else{

					 return  String.format('<div style="vertical-align:middle;text-align:right;"><span ><b>{0}</b></span></div>',(parseFloat(value)).formatDinero(2, ',', '.'));

					 }

				 }
			},
				//type:'NumberField',
				type:'MoneyField',
				filters:{pfiltro:'prpa.importe',type:'numeric'},
				id_grupo:1,
				grid: true,
				form: false
		},

		
		{
			config:{
				name: 'importe_aprobado',
				fieldLabel: 'Importe Verificado',
				selectOnFocus: true,
				allowNegative: false,
				allowDecimals: true,
				allowBlank: false,
				anchor: '80%',
				gwidth: 130,
				maxLength: 1179650,
				renderer:function (value,p,record){

					Number.prototype.formatDinero = function(c, d, t){
						var n = this,
							c = isNaN(c = Math.abs(c)) ? 2 : c,
							d = d == undefined ? "." : d,
							t = t == undefined ? "," : t,
							s = n < 0 ? "-" : "",
							i = parseInt(n = Math.abs(+n || 0).toFixed(c)) + "",
							j = (j = i.length) > 3 ? j % 3 : 0;
						return s + (j ? i.substr(0, j) + t : "") + i.substr(j).replace(/(\d{3})(?=\d)/g, "$1" + t) + (c ? d + Math.abs(n - i).toFixed(c).slice(2) : "");
					};


						if(record.data.tipo_reg != 'summary'){

							return  String.format('<div style="vertical-align:middle;text-align:right;"><span >{0}</span></div>',(parseFloat(value)).formatDinero(2, ',', '.'));
						}
						else{
							return  String.format('<div style="vertical-align:middle;text-align:right;"><span ><b>{0}</b></span></div>',(parseFloat(value)).formatDinero(2, ',', '.'));
						}
					}
			},
				//type: 'NumberField',
				type:'MoneyField',
				filters: { pfiltro:'prpa.importe', type: 'numeric' },
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
	ActSave:'../../sis_presupuestos/control/PresupPartida/insertarPresupPartida',
	ActDel:'../../sis_presupuestos/control/PresupPartida/eliminarPresupPartida',
	ActList:'../../sis_presupuestos/control/PresupPartida/listarPresupPartida',
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
		{name:'usr_mod', type: 'string'},'desc_partida','desc_gestion','importe_aprobado','tipo_reg'
		
	],
	onReloadPage:function(m){
		this.maestro=m;
        
        this.store.baseParams={id_presupuesto:this.maestro.id_presupuesto};
        
        
        this.load({ params: { start: 0, limit: 50 }});
        
        console.log('xxxxxx', this.maestro, this.maestro.movimiento_tipo_pres)
        if(this.maestro.movimiento_tipo_pres == "administrativo"){
        	 this.Cmp.id_partida.store.baseParams.partida_tipo =  'flujo';
        	 delete this.Cmp.id_partida.store.baseParams.tipo;
        }
        else{
        	 this.Cmp.id_partida.store.baseParams.partida_tipo =  'presupuestaria';
        	 this.Cmp.id_partida.store.baseParams.tipo = this.maestro.movimiento_tipo_pres;
        }
       
        
       
        this.Cmp.id_partida.store.baseParams.id_gestion = this.maestro.id_gestion;        
        this.Cmp.id_partida.modificado = true;
    },
    loadValoresIniciales:function()
    {
        Phx.vista.PresupPartida.superclass.loadValoresIniciales.call(this);
        this.Cmp.id_presupuesto.setValue(this.maestro.id_presupuesto);       
    },
	sortInfo:{
		field: 'par.codigo',
		direction: 'ASC'
	},
	preparaMenu:function(){
		var rec = this.sm.getSelected();
		var tb = this.tbar;
		if (rec.data.tipo_reg == 'summary'){
			if( this.getBoton('edit') ){
				this.getBoton('edit').disable();
			}
			if( this.getBoton('del') ){
				this.getBoton('del').disable();
			}
			if( this.getBoton('new') ){
				this.getBoton('new').disable();
			}
		     
             
		}
		else{
		   Phx.vista.PresupPartida.superclass.preparaMenu.call(this);
		}
   },
	
   liberaMenu: function() {
		var tb = Phx.vista.PresupPartida.superclass.liberaMenu.call(this);
		
   },
	
	
	bdel: true,
	bedit: false,
	bsave: false
	}
)
</script>
		
		