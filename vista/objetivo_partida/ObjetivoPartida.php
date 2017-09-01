<?php
/**
*@package pXP
*@file gen-ObjetivoPartida.php
*@author  (franklin.espinoza)
*@date 24-07-2017 13:34:28
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.ObjetivoPartida=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;

    	//llama al constructor de la clase padre
		Phx.vista.ObjetivoPartida.superclass.constructor.call(this,config);
		this.init();

	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_objetivo_partida'
			},
			type:'Field',
			form:true 
		},
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
			config:{
				 name:'id_partida',
				 fieldLabel:'Partida',
				 allowBlank:false,
				 emptyText:'Partida...',
				 store: new Ext.data.JsonStore({
					 url: '../../sis_presupuestos/control/Partida/listarPartida',
					 id: 'id_partida',
					 root: 'datos',
					 sortInfo:{
					 field: 'codigo',
					 direction: 'ASC'
					 },
					 totalProperty: 'total',
					 fields: ['id_partida','codigo','nombre_partida','tipo','sw_movimiento'],
					 // turn on remote sorting
					 remoteSort: true,
					 baseParams: {par_filtro:'par.codigo#par.nombre_partida',sw_transaccional:'movimiento', tipo:'gasto'}
				 }),
				 valueField: 'id_partida',
				 displayField: 'nombre_partida',
				 gdisplayField: 'desc_partida',
				 hiddenName: 'id_partida',
				 forceSelection:true,
				 typeAhead: false,
				 triggerAction: 'all',
				 lazyRender:true,
				 mode:'remote',
				 pageSize:10,
				 queryDelay:1000,
				 resizable: true,
				 anchor:'100%',
				 minChars:2,
                 gwidth: 300,
				 enableMultiSelect: true,
				 renderer: function(value, p, record){

					if(record.data.tipo_reg != 'summary'){
						return String.format('{0} - ({1})', record.data['desc_partida'],   record.data['desc_gestion']);
					}
					else{
						return  String.format('<div style="vertical-align:middle;text-align:right;"><b >{0}</b></div>','Total:');
					}

				 },
				 tpl: new Ext.XTemplate([
					'<tpl for=".">',
					'<div class="x-combo-list-item">',
					 '<div class="awesomecombo-item {checked}">',
					'<tpl if="sw_movimiento == \'flujo\'">',
					'<font color="red"><p>{nombre_partida} ({codigo})</p></font>',
					'</tpl>',
					'<tpl if="sw_movimiento == \'presupuestaria\'">',
					'<font color="green"><p>{nombre_partida} ({codigo})</p></font>',
					'</tpl>',
					 '</div>',
					'<p><b>Tipo:</b> {sw_movimiento} </p><b>Rubro:</b> {tipo}</p>',
					'</div>',
					'</tpl>'

				 ])
			},
			type:'AwesomeCombo',
			bottom_filter: true,
			id_grupo:0,
			filters:{
				pfiltro: 'tpar.codigo#tpar.nombre_partida',
				type: 'string'
			},

			grid:true,
			form:true
		},

        {
            config:{
                name: 'tipo_reg',
                fieldLabel: 'Tipo',
                allowBlank: true,
                anchor: '80%',
                gwidth: 150,
                renderer:function (value, p, record){
                    if(value == 'PROPIO'){
                        return String.format('<font color="green"><b>{0}</b></font>', value);
                    }
                    else{
                        return String.format('<font color="orange">{0}</font>', value);
                    }

                },
                maxLength:10
            },
            type:'TextField',
            id_grupo:1,
            grid:true,
            form:false
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
				filters:{pfiltro:'obj_part.estado_reg',type:'string'},
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
				name: 'usuario_ai',
				fieldLabel: 'Funcionaro AI',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:300
			},
				type:'TextField',
				filters:{pfiltro:'obj_part.usuario_ai',type:'string'},
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
				filters:{pfiltro:'obj_part.fecha_reg',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'id_usuario_ai',
				fieldLabel: 'Fecha creación',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
				type:'Field',
				filters:{pfiltro:'obj_part.id_usuario_ai',type:'numeric'},
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
				filters:{pfiltro:'obj_part.fecha_mod',type:'date'},
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
	title:'ObjetivoPartida',
	ActSave:'../../sis_presupuestos/control/ObjetivoPartida/insertarObjetivoPartida',
	ActDel:'../../sis_presupuestos/control/ObjetivoPartida/eliminarObjetivoPartida',
	ActList:'../../sis_presupuestos/control/ObjetivoPartida/listarObjetivoPartida',
	id_store:'id_objetivo_partida',
	fields: [
		{name:'id_objetivo_partida', type: 'numeric'},
		{name:'id_objetivo', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'id_partida', type: 'numeric'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'usuario_ai', type: 'string'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		{name:'desc_partida', type: 'string'},
		{name:'desc_gestion', type: 'string'},
		{name:'tipo_reg', type: 'string'}

	],
	sortInfo:{
		field: 'id_objetivo_partida',
		direction: 'ASC'
	},
	bdel:true,
    btest: false,
    bsave: false,
	fheight: '35%',
	onReloadPage:function(m){
		this.maestro=m;
		this.store.baseParams={id_objetivo:this.maestro.id_objetivo};
		this.load({ params: { start: 0, limit: 50 }});
	},

	loadValoresIniciales:function()
	{
		Phx.vista.ObjetivoPartida.superclass.loadValoresIniciales.call(this);
		this.Cmp.id_objetivo.setValue(this.maestro.id_objetivo);
	},

	onButtonNew: function () {
		Phx.vista.ObjetivoPartida.superclass.onButtonNew.call(this);
		this.Cmp.id_partida.store.baseParams ={par_filtro:'par.codigo#par.nombre_partida', id_gestion:this.maestro.id_gestion, sw_transaccional:'movimiento',  tipo:'gasto'};
	},

	successSave: function (resp) {
		Phx.vista.ObjetivoPartida.superclass.successSave.call(this,resp);

		var objRes = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
		console.log('objRes.ROOT.datos.v_mensaje',objRes.ROOT.datos.v_mensaje);
		if(objRes.ROOT.datos.v_mensaje!= undefined || objRes.ROOT.datos.v_mensaje!= null) {
			Ext.Msg.show({
				title: 'Información',
				msg: objRes.ROOT.datos.v_mensaje,
				buttons: Ext.Msg.OK,
				width: 650,
				icon: Ext.Msg.INFO
			});
		}
	},

	onButtonEdit: function () {
		Phx.vista.ObjetivoPartida.superclass.onButtonEdit.call(this);
		this.Cmp.id_partida.store.baseParams ={par_filtro:'par.codigo#par.nombre_partida', id_gestion:this.maestro.id_gestion, sw_transaccional:'movimiento',  tipo:'gasto'};

	}
});
</script>
		
		