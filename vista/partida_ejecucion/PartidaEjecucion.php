<?php
/**
*@package pXP
*@file gen-PartidaEjecucion.php
*@author  (gvelasquez)
*@date 03-10-2016 15:47:23
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
 
 #41 ENDETR     12/07/2020        JJA               Agregar columna tipo_ajuste_formulacion en la tabla de partida ejecucion
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.PartidaEjecucion=Ext.extend(Phx.gridInterfaz,{

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
					fieldLabel: 'ID Partida Ejecucion',
					name: 'id_partida_ejecucion'
			},
			type:'Field',
			grid: true,
			form:true 
		},
		{
			config:{
				name: 'fecha_reg',
				fieldLabel: 'Fecha Creación',
				allowBlank: true,
				anchor: '80%',
				gwidth: 120,
				format: 'd/m/Y',
				renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
			},
			type:'DateField',
			filters:{pfiltro:'fecha_reg',type:'date'},
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
			filters:{pfiltro:'usr_reg',type:'string'},
			bottom_filter: true,
			id_grupo:1,
			grid:true,
			form:false
		},
		{
			config:{
				name: 'tipo_movimiento',
				fieldLabel: 'Tipo Movimiento',
				allowBlank: false,

				renderer:function (value, p, record){
					
					var color = 'green';
					if(record.data["tipo_reg"] != 'summary'){
						
					}
					var dato=value;
					dato = (value=='1')?'Comprometido':dato;
					dato = (dato==''&&value=='2')?'Revertido':dato;
					dato = (dato==''&&value=='3')?'Devengado':dato;
					dato = (dato==''&&value=='4')?'Pagado':dato;
					dato = (dato==''&&value=='5')?'Traspaso':dato;
					dato = (dato==''&&value=='6')?'Reformulacion':dato;
					dato = (dato==''&&value=='7')?'Incremento':dato;
					return String.format('{0}', dato);
					
		
				},

				store:new Ext.data.ArrayStore({
					fields :['variable','valor'],
					data :  []}),

				valueField: 'variable',
				displayField: 'valor',
				forceSelection: true,
				triggerAction: 'all',
				lazyRender: true,
				resizable:true,
				gwidth: 100,
				listWidth:'500',
				mode: 'local',
				wisth: 380
			},
			type:'ComboBox',
			filters:{pfiltro:'tipo_movimiento',type:'string'},
			id_grupo:0,
			grid:true,
			form:false
		},
		
		{
			config:{
				name: 'egreso_mb',
				fieldLabel: 'Egresos MB',
				allowBlank: false,
				allowNegative: false,
				anchor: '80%',
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
			type:'NumberField',
			filters:{pfiltro:'egreso_mb',type:'numeric'},
			id_grupo:1,			
			grid:true,
			form:false
		},
		
		{
			config:{
				name: 'ingreso_mb',
				fieldLabel: 'Ingresos MB',
				allowBlank: false,
				allowNegative: false,
				anchor: '80%',
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
			type:'NumberField',
			filters:{pfiltro:'ingreso_mb',type:'numeric'},
			id_grupo:1,
			grid:true,
			form:false
		},
		

		{
			config:{
				name: 'monto_anticipo_mb',
				fieldLabel: 'Anticipos Eje',
				allowBlank: false,
				allowNegative: false,
				anchor: '80%',
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
			type:'NumberField',
			filters:{pfiltro:'monto_anticipo_mb',type:'numeric'},
			id_grupo:1,
			grid:true,
			form:false
		},
		
		{
			config:{
				name: 'monto_desc_anticipo_mb',
				fieldLabel: 'Desc Anticipo',
				allowBlank: false,
				allowNegative: false,
				anchor: '80%',
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
			type:'NumberField',
			filters:{pfiltro:'monto_desc_anticipo_mb',type:'numeric'},
			id_grupo:1,
			grid:true,
			form:false
		},
		{
			config:{
				name: 'monto_iva_revertido_mb',
				fieldLabel: 'IVA Revertido',
				allowBlank: false,
				allowNegative: false,
				anchor: '80%',
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
			type:'NumberField',
			filters:{pfiltro:'monto_iva_revertido_mb',type:'numeric'},
			id_grupo:1,
			grid:true,
			form:false
		},
		
		{
			config:{
				name: 'monto',
				fieldLabel: 'Monto',
				allowBlank: false,
				allowNegative: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:1179650,
				renderer:function (value,p,record){
						if(record.data.tipo_reg != 'summary'){
							return  String.format('{0}', Ext.util.Format.number(value,'0,000.00'));
						}
						else{
							return  String.format('<b><font size=2 >{0}</font><b>', Ext.util.Format.number(value,'0,000.00'));
						}
					}
			},
			type:'NumberField',
			filters:{pfiltro:'monto',type:'numeric'},
			id_grupo:1,
			grid:true,
			form:false
		},
		
		{
			config:{
				name: 'moneda',
				fieldLabel: 'Moneda',
				allowBlank: true,
				anchor: '80%',
				gwidth: 80
			},
			type:'TextField',
			filters:{pfiltro:'moneda',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			//configuracion del componente
			config:{
				labelSeparator:'',
				inputType:'hidden',
				fieldLabel: 'ID Presupuesto',
				name: 'id_presupuesto',
				gwidth: 50
			},
			type:'Field',
			grid: true,
			filters:{pfiltro:'id_presupuesto',type:'string'},
			bottom_filter: true,
			form:true
		},
		{
			config:{
				name: 'desc_pres',
				fieldLabel: 'Desc. Presupuesto',
				allowBlank: true,
				anchor: '80%',
				gwidth: 200
			},
			type:'TextField',
			filters:{pfiltro:'desc_pres',type:'string'},
			id_grupo:1,
			bottom_filter: true,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'desc_tipo_cc',
				fieldLabel: 'Tipo Centro',
				allowBlank: true,
				anchor: '80%',
				gwidth: 150,
				maxLength:-5
			},
			type:'TextField',
			filters:{pfiltro:'desc_tipo_cc',type:'string'},
			bottom_filter: true,
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config: {
				name: 'id_partida',
				fieldLabel: 'ID Partida'

			},
			type: 'TextField',
			id_grupo: 0,			
			grid: false,
			gwidth: 50,
			form: true
		},
		{
			config:{
				name: 'codigo',
				fieldLabel: 'Codigo Partida',
				allowBlank: true,
				anchor: '80%',
				gwidth: 80,
				maxLength:-5
			},
			type:'TextField',
			filters:{pfiltro:'codigo',type:'string'},
			bottom_filter: true,
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'nombre_partida',
				fieldLabel: 'Nombre Partida',
				allowBlank: true,
				anchor: '80%',
				gwidth: 200,
				maxLength:-5
			},
			type:'TextField',
			filters:{pfiltro:'nombre_partida',type:'string'},
			bottom_filter: true,
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'nro_tramite',
				fieldLabel: 'Nro Tramite',
				allowBlank: true,
				anchor: '80%',
				gwidth: 150,
				maxLength:-5
			},
				type:'TextField',
				filters:{pfiltro:'nro_tramite',type:'string'},
				bottom_filter: true,
				id_grupo:1,
				grid:true,
				form:true
		},
		{//#41
		   config : {
			     name : 'tipo_ajuste_formulacion',
			     fieldLabel : '*Tipo ajuste de la formulación',
			     anchor : '90%',
			     tinit : false,
			     allowBlank : true,
			     origen : 'CATALOGO',
			     gdisplayField : 'tipo_ajuste_formulacion',
			     gwidth : 100,
			     anchor : '40%',
				 sortable: false,
			     baseParams : {
			     cod_subsistema : 'PRE',
			     catalogo_tipo : 'tipo_ajuste_formulacion'},
			     renderer : function(value, p, record) {
					return String.format('{0}',record.data['tipo_ajuste_formulacion']);
				}
		   },
		   type : 'ComboRec',
		   id_grupo : 0,
		   filters : {pfiltro : 'mdt.tipo_ajuste_formulacion',type : 'string'},
		   egrid: false,
		   grid : true,
		   form : true
		},
		{
			config:{
				name: 'total_pago',
				fieldLabel: 'Total pago',
				allowBlank: true,
				anchor: '80%',
				gwidth: 150,
				maxLength:-5,
				renderer: function(value, metaData, record, rowIndex, colIndex, store) {

					return Ext.util.Format.number(record.data['total_pago'],'0,000.00');
				}
			},
				type:'TextField',
				filters:{pfiltro:'total_pago',type:'string'},
				bottom_filter: true,
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'desc_contrato',
				fieldLabel: 'Contrato',
				allowBlank: true,
				anchor: '80%',
				gwidth: 150,
			},
				type:'TextField',
				filters:{pfiltro:'desc_contrato',type:'string'},
				bottom_filter: true,
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'obs',
				fieldLabel: 'Justificación',
				allowBlank: true,
				anchor: '80%',
				gwidth: 150,
			},
				type:'TextField',
				filters:{pfiltro:'obs',type:'string'},
				bottom_filter: true,
				id_grupo:1,
				grid:true,
				form:true
		},
		
		{
			config:{
				name: 'fecha',
				fieldLabel: 'Fecha Ejecucion',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				format: 'd/m/Y',
				renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
			},
			type:'DateField',
			filters:{pfiltro:'fecha',type:'date'},
			id_grupo:1,
			grid:true,
			form:true
		},


		{
			config: {
				name: 'id_int_comprobante',
				fieldLabel: 'ID Int Comprobante',

			},
			type: 'TextField',
			id_grupo: 0,
			filters: {pfiltro: 'id_int_comprobante',type: 'string'},
			grid: true,
			form: true
		},
		{
			config:{
				name: 'tipo_cambio',
				fieldLabel: 'Tipo de Cambio',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:-5
			},
			type:'NumberField',
			filters:{pfiltro:'tipo_cambio',type:'numeric'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'valor_id_origen',
				fieldLabel: 'Valor Id Origen',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
				type:'NumberField',
				filters:{pfiltro:'valor_id_origen',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'glosa1',
				fieldLabel: 'Descripcion',
				allowBlank: true,
				anchor: '80%',
				gwidth: 300,
				//maxLength:4
				maxLength:1000,
				renderer: function(value, metaData, record, rowIndex, colIndex, store) {
					metaData.css = 'multilineColumn'; 
					return String.format('{0} <br> {1}', record.data['glosa1'],'');
				}
			},
				type:'TextArea',
				filters:{pfiltro:'glosa1',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'glosa',
				fieldLabel: 'Glosa',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
				type:'Field',
				filters:{pfiltro:'glosa1',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'columna_origen',
				fieldLabel: 'Columna Origen',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:-5
			},
			type:'TextField',
			filters:{pfiltro:'columna_origen',type:'string'},
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
			filters:{pfiltro:'estado_reg',type:'string'},
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
				filters:{pfiltro:'usuario_ai',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'id_usuario_ai',
				fieldLabel: 'Funcionaro AI',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
				type:'Field',
				filters:{pfiltro:'id_usuario_ai',type:'numeric'},
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
				filters:{pfiltro:'fecha_mod',type:'date'},
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
				filters:{pfiltro:'usr_mod',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		}];     
		Phx.vista.PartidaEjecucion.superclass.constructor.call(this,config);
			
		this.addButton('btnChequeoDocumentosWf',{
		    text: 'Documentos',
			grupo:[0,1,2,3],
			iconCls: 'bchecklist',
			disabled: true,
			handler: this.loadCheckDocumentosWf,
			tooltip: '<b>Documentos del Trámite</b><br/>Permite ver los documentos asociados al NRO de trámite.'
		});	
		    
		this.addButton('btnImprimir', {
			text : 'Imprimir',
			iconCls : 'bprint',
			disabled : true,
			handler : this.imprimirCbte,
			tooltip : '<b>Imprimir Comprobante</b><br/>Imprime el Comprobante en el formato oficial'
		});  
		
		this.addButton('chkpresupuesto',{
			text:'Chk Presupuesto',
			iconCls: 'blist',
			disabled: true,
			handler: this.checkPresupuesto,
			tooltip: '<b>Revisar Presupuesto</b><p>Revisar estado de ejecución presupeustaria para el tramite</p>'
		});
		
		this.grid.getTopToolbar().disable();
		this.grid.getBottomToolbar().disable();
		this.init();
	},
				
	tam_pag:50,	
	title:'Partida Ejecucion',
	ActSave:'../../sis_presupuestos/control/PartidaEjecucion/insertarPartidaEjecucion',
	ActDel:'../../sis_presupuestos/control/PartidaEjecucion/eliminarPartidaEjecucion',
	ActList:'../../sis_presupuestos/control/PartidaEjecucion/listarPartidaEjecucion',
	id_store:'id_partida_ejecucion',
	fields: [
		{name:'id_partida_ejecucion', type: 'numeric'},
		{name:'id_int_comprobante', type: 'numeric'},
		{name:'id_moneda', type: 'numeric'},
		{name:'id_presupuesto', type: 'numeric'},
		{name:'id_partida', type: 'numeric'},
		{name:'nro_tramite', type: 'string'},
		{name:'tipo_cambio', type: 'numeric'},
		{name:'columna_origen', type: 'string'},
		{name:'tipo_movimiento', type: 'string'},
		{name:'id_partida_ejecucion_fk', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'fecha', type: 'date',dateFormat:'Y-m-d'},
		{name:'monto_mb', type: 'numeric'},
		{name:'monto', type: 'numeric'},
		{name:'glosa1', type: 'string'},
		{name:'glosa', type: 'string'},
		{name:'cantidad_descripcion', type: 'string'},
		{name:'valor_id_origen', type: 'numeric'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usuario_ai', type: 'string'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},'moneda','desc_pres','codigo_categoria','codigo','nombre_partida',
		'ingreso_mb','egreso_mb','desc_tipo_cc','id_tipo_cc','tipo_reg','nro_cbte','id_proceso_wf',
		'monto_anticipo_mb',
		'monto_desc_anticipo_mb',
		'monto_iva_revertido_mb',

		'total_pago',
		'desc_contrato',
		'obs',
		'tipo_ajuste_formulacion' //#41
		
	],
	
	imprimirCbte : function() {
		var rec = this.sm.getSelected();
		var data = rec.data;
		if (data) {
			Phx.CP.loadingShow();
			Ext.Ajax.request({
				url : '../../sis_contabilidad/control/IntComprobante/reporteCbte',
				params : {
					'id_proceso_wf' : data.id_proceso_wf
				},
				success : this.successExport,
				failure : this.conexionFailure,
				timeout : this.timeout,
				scope : this
			});
		}
	
	},

	loadCheckDocumentosWf:function() {
		var rec=this.sm.getSelected();
		rec.data.nombreVista = this.nombreVista;
		Phx.CP.loadWindows('../../../sis_workflow/vista/documento_wf/DocumentoWf.php',
		    'Documentos del Proceso',
		    {
		        width:'90%',
		        height:500
		    },
		    rec.data,
		    this.idContenedor,
		    'DocumentoWf'
	   	);
	},	
    
    checkPresupuesto:function(){                   
		var rec=this.sm.getSelected();
		var configExtra = [];
		this.objChkPres = Phx.CP.loadWindows('../../../sis_presupuestos/vista/presup_partida/ChkPresupuesto.php',
			'Estado del Presupuesto',
			{
				modal:true,
				width:700,
				height:450
			}, {
				data:{
				   nro_tramite: rec.data.nro_tramite								  
				}}, this.idContenedor,'ChkPresupuesto',
			{
				config:[{
					event:'onclose',
					delegate: this.onCloseChk												  
				}],				
				scope:this
			});	   
	 },
	
	arrayDefaultColumHidden:['id_partida_ejecucion','columna_origen','valor_id_origen',
		'tipo_cambio','monto_mb','fecha_mod', 'id_usuario_ai','usr_mod','estado_reg'],
		
		
	preparaMenu : function(n) {
		var rec=this.sm.getSelected();
		if(rec.data.tipo_reg != 'summary'){
			var tb = Phx.vista.PartidaEjecucion.superclass.preparaMenu.call(this);
			this.getBoton('chkpresupuesto').enable();
			this.getBoton('btnChequeoDocumentosWf').enable();
			if(rec.data.nro_cbte != ''){
				this.getBoton('btnImprimir').enable();
			}			
			return tb;
		}
		else{
			 this.getBoton('chkpresupuesto').disable();
			 this.getBoton('btnChequeoDocumentosWf').disable();			 
			 this.getBoton('btnImprimir').disable();
		}
			
		return undefined;
	},
	
	
	liberaMenu : function() {
		var tb = Phx.vista.PartidaEjecucion.superclass.liberaMenu.call(this);
		this.getBoton('chkpresupuesto').disable();
		this.getBoton('btnChequeoDocumentosWf').disable();
		this.getBoton('btnImprimir').disable();
	},
	
	sortInfo:{
		field: 'id_partida_ejecucion',
		direction: 'asc'
	},

	loadValoresIniciales:function(){
		Phx.vista.PartidaEjecucion.superclass.loadValoresIniciales.call(this);
		//this.getComponente('id_int_comprobante').setValue(this.maestro.id_int_comprobante);
	},
	onReloadPage:function(param){
		//Se obtiene la gestión en función de la fecha del comprobante para filtrar partidas, cuentas, etc.
		var me = this;
		this.initFiltro(param);
	},

	initFiltro: function(param){
		this.store.baseParams=param;
		this.load( { params: { start:0, limit: this.tam_pag } });
	},

	bdel:false,
	bsave:false,
	bedit:false,
	bnew:false
	}
)
</script>
		
		