<?php
/**
*@package pXP
*@file gen-PartidaEjecucion.php
*@author  (gvelasquez)
*@date 03-10-2016 15:47:23
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.PartidaEjecucion=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.PartidaEjecucion.superclass.constructor.call(this,config);
		this.grid.getTopToolbar().disable();
		this.grid.getBottomToolbar().disable();
		this.init();
		//this.load({params:{start:0, limit:this.tam_pag}})
	},
			
	Atributos:[
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
			filters:{pfiltro:'pareje.fecha_reg',type:'date'},
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
			filters:{pfiltro:'pareje.tipo_movimiento',type:'string'},
			id_grupo:0,
			grid:true,
			form:false
		},

		{
			config:{
				name: 'monto_mb',
				fieldLabel: 'Monto Moneda Base',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:-5
			},
			type:'NumberField',
			filters:{pfiltro:'pareje.monto_mb',type:'numeric'},
			id_grupo:1,
			grid:true,
			form:true
		},
		/*{
			config:{
				name: 'monto',
				fieldLabel: 'Monto',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:-5
			},
			type:'NumberField',
			filters:{pfiltro:'pareje.monto',type:'numeric'},
			bottom_filter: true,
			id_grupo:1,
			grid:true,
			form:true
		},*/
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

					return  String.format('<div style="vertical-align:middle;text-align:right;"><span >{0}</span></div>',(parseFloat(value)).formatDinero(2, ',', '.'));
				}
			},
			type:'NumberField',
			filters:{pfiltro:'pareje.monto',type:'numeric'},
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
			filters:{pfiltro:'mon.moneda',type:'string'},
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
			filters:{pfiltro:'pre.id_presupuesto',type:'string'},
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
			filters:{pfiltro:'pre.descripcion',type:'string'},
			id_grupo:1,
			bottom_filter: true,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'codigo_categoria',
				fieldLabel: 'Código Categoría',
				allowBlank: true,
				anchor: '80%',
				gwidth: 150,
				maxLength:-5
			},
			type:'TextField',
			filters:{pfiltro:'pareje.nro_tramite',type:'string'},
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
			filters: {pfiltro: 'movtip.nombre',type: 'string'},
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
			filters:{pfiltro:'par.codigo',type:'string'},
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
			filters:{pfiltro:'par.nombre_partida',type:'string'},
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
				filters:{pfiltro:'pareje.nro_tramite',type:'string'},
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
			filters:{pfiltro:'pareje.fecha',type:'date'},
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
			filters: {pfiltro: 'pareje.id_int_comprobante',type: 'string'},
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
			filters:{pfiltro:'pareje.tipo_cambio',type:'numeric'},
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
				filters:{pfiltro:'pareje.valor_id_origen',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:true
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
			filters:{pfiltro:'pareje.columna_origen',type:'string'},
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
			filters:{pfiltro:'pareje.estado_reg',type:'string'},
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
				filters:{pfiltro:'pareje.usuario_ai',type:'string'},
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
				filters:{pfiltro:'pareje.id_usuario_ai',type:'numeric'},
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
				filters:{pfiltro:'pareje.fecha_mod',type:'date'},
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
		{name:'valor_id_origen', type: 'numeric'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usuario_ai', type: 'string'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},'moneda','desc_pres','codigo_categoria','codigo','nombre_partida',
		
	],
	arrayDefaultColumHidden:['id_partida_ejecucion','columna_origen','valor_id_origen',
		'tipo_cambio','monto_mb','fecha_mod', 'id_usuario_ai','usr_mod','estado_reg'],


	sortInfo:{
		field: 'fecha_reg',
		direction: 'DESC'
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
		
		