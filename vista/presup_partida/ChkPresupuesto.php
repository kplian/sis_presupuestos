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
Phx.vista.ChkPresupuesto=Ext.extend(Phx.gridInterfaz,{
    tam_pag:200,
	constructor:function(config){
		this.maestro=config.maestro;
		console.log('.............',config)
    	//llama al constructor de la clase padre
		Phx.vista.ChkPresupuesto.superclass.constructor.call(this,config);
		this.init();
		
		this.store.baseParams={nro_tramite:this.data.nro_tramite}; 
        this.load({params:{start:0, limit:this.tam_pag}});
		
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
				name: 'codigo_cc',
				fieldLabel: 'Presupeusto',
				allowBlank: true,
				anchor: '80%',
				gwidth: 200,
				maxLength:300
			},
				type:'TextField',
				bottom_filter: true,
   			    filters:{pfiltro:'prpa.codigo_cc',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'desc_partida',
				fieldLabel: 'Partida',
				allowBlank: true,
				anchor: '80%',
				gwidth: 200,
				maxLength:300
			},
				type:'TextField',
				bottom_filter: true,
   			    filters:{pfiltro:'prpa.desc_partida',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
	   	
		
		{
			config:{
				name: 'comprometido',
				fieldLabel: 'Comprometido',
				gwidth: 100,
				renderer:function (value,p,record){
						if(record.data.tipo_reg != 'summary'){
							return  String.format('{0}', Ext.util.Format.number(value,'0,000.00'));
						}
						else{
							return  String.format('<b><font size=2 >{0}</font><b>', Ext.util.Format.number(value,'0,000.00'));
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
							return  String.format('{0}', Ext.util.Format.number(value,'0,000.00'));
						}
						else{
							return  String.format('<b><font size=2 >{0}</font><b>', Ext.util.Format.number(value,'0,000.00'));
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
							return  String.format('{0}', Ext.util.Format.number(value,'0,000.00'));
						}
						else{
							return  String.format('<b><font size=2 >{0}</font><b>', Ext.util.Format.number(value,'0,000.00'));
						}
						
					}
			},
				type: 'NumberField',
				filters: { pfiltro:'prpa.pagado', type: 'numeric' },
				id_grupo: 1,
				grid: true,
				form: false
		}
		
		
	],
	tam_pag:50,	
	title:'PREPAR',
	ActList:'../../sis_presupuestos/control/PresupPartida/listarPresupPartidaEstadoXNroTramite',
	id_store:'id_presup_partida',
	fields: [
		{name:'id_presup_partida', type: 'numeric'},
		{name:'tipo', type: 'string'},
		{name:'id_partida', type: 'numeric'},
		{name:'id_centro_costo', type: 'numeric'},
		{name:'id_presupuesto', type: 'numeric'},
		'codigo_cc','desc_partida','tipo_reg',
		'comprometido','ejecutado','pagado'
		
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
		
		