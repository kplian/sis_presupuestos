<?php
/**
*@package pXP
*@file gen-DetalleTipoCentroCosto.php
*@author  (gvelasquez)
*@date 03-10-2016 15:47:23
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
  ISSUE            FECHA:          AUTOR       DESCRIPCION
 #PRES-5  ENDETR    23/07/2020      JJA          Mejoras en reporte tipo centro de costo de presupuesto
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.AnalisisImputacionPartida=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		var me = this;
		console.log('?',me);
		this.maestro=config.maestro;
		//llama al constructor de la clase padre
	    this.Atributos=[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					fieldLabel: 'id_partida',
					name: 'id_partida'
			},
			type:'Field',
			grid: false,
			form:true 
		},
		{
			config:{
				name: 'partida',
				fieldLabel: 'partida',
				allowBlank: true,
				anchor: '200%',
				gwidth: 200,
				maxLength:4,
                renderer: function (value, p, record, rowIndex, colIndex){

                   var espacion_blanco="";
                   var duplicar="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                   var nivel = record.data.nivel==null?0:record.data.nivel;
                   var espacion_blanco = duplicar.repeat(nivel);

                   if(record.data.nivel ==1){
                        return  String.format('<div style="vertical-align:middle;text-align:left;"> '+espacion_blanco+' <img src="../../../lib/imagenes/a_form_edit.png"> '+ record.data.partida+' </div>');
                   }
                   else{       
	                   	if(record.data.nivel){
	                        return  String.format('<div style="vertical-align:middle;text-align:left;"> '+espacion_blanco+' <img src="../../../lib/imagenes/a_form.png"> '+ record.data.partida+' </div>');
	                   	}
                        
                   }
                }
			},
				type:'Field',
				filters:{pfiltro:'partida',type:'string'},
				id_grupo:1,
				grid:true,
				form:false,
				bottom_filter: true,
		},
		{
			config:{
				name: 'ceco',
				fieldLabel: 'ceco',
				allowBlank: true,
				anchor: '200%',
				gwidth: 200,
				maxLength:4
			},
				type:'Field',
				filters:{pfiltro:'ceco',type:'string'},
				id_grupo:1,
				grid:true,
				form:false,
				bottom_filter: true,
		},
		{
			config:{
				name: 'nivel',
				fieldLabel: 'Nivel',
				allowBlank: true,
				anchor: '100%',
				gwidth: 70,
				maxLength:4
			},
				type:'NumberField', 
				filters:{pfiltro:'nivel',type:'numeric'}, 
				id_grupo:1,
				grid:true,
				form:false
		},

		{
			config:{
				name: 'formulado',
				fieldLabel: 'Formulado',
				allowBlank: true,
				anchor: '100%',
				gwidth: 70,
				maxLength:4
			},
				type:'NumberField', 
				filters:{pfiltro:'formulado',type:'numeric'}, 
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'comprometido',
				fieldLabel: 'Comprometido',
				allowBlank: true,
				anchor: '100%',
				gwidth: 70,
				maxLength:4
			},
				type:'NumberField', 
				filters:{pfiltro:'forcomprometidomulado',type:'numeric'}, 
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'por_comprometer',
				fieldLabel: 'Por comprometer',
				allowBlank: true,
				anchor: '100%',
				gwidth: 70,
				maxLength:4
			},
				type:'NumberField', 
				filters:{pfiltro:'por_comprometer',type:'numeric'}, 
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'ejecutado',
				fieldLabel: 'Ejecutado',
				allowBlank: true,
				anchor: '100%',
				gwidth: 70,
				maxLength:4
			},
				type:'NumberField', 
				filters:{pfiltro:'ejecutado',type:'numeric'}, 
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'por_ejecutar',
				fieldLabel: 'Por ejecutar',
				allowBlank: true,
				anchor: '100%',
				gwidth: 70,
				maxLength:4
			},
				type:'NumberField', 
				filters:{pfiltro:'por_ejecutar',type:'numeric'}, 
				id_grupo:1,
				grid:true,
				form:false
		}


		];     
		Phx.vista.AnalisisImputacionPartida.superclass.constructor.call(this,config);
			
		this.init();
	},
				
	tam_pag:50,	
	title:'Detalle tipo Centro de costo',
	ActList:'../../sis_presupuestos/control/PartidaEjecucion/AnalisisImputacionPartida',
	id_store:'id_partida',
	fields: [

        {name:'id_partida', type: 'numeric'},
		{name:'partida', type: 'string'},
		{name:'ceco', type: 'string'},
		{name:'nivel', type: 'numeric'},
		{name:'formulado', type: 'numeric'},
		{name:'comprometido', type: 'numeric'},
		{name:'por_comprometer', type: 'numeric'},
		{name:'ejecutado', type: 'numeric'},
		{name:'por_ejecutar', type: 'numeric'}
		
	],

	sortInfo:{
		field: 'order',
		direction: 'asc'
	},

	loadValoresIniciales:function(){
		Phx.vista.AnalisisImputacionPartida.superclass.loadValoresIniciales.call(this);
	
	},
	onReloadPage:function(param){
		
		var me = this;
		this.initFiltro2(param);
	},

	initFiltro2: function(param){
		this.store.baseParams=param;
		console.log(" llega",param);
		this.load( { params: { start:0, limit: this.tam_pag } });
	},

	bdel:false,
	bsave:false,
	bedit:false,
	bnew:false
	}
)
</script>
		
