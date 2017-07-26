<?php
/**
*@package pXP
*@file gen-PresupuestoPartidaEntidad.php
*@author  (franklin.espinoza)
*@date 21-07-2017 12:58:43
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.PresupuestoPartidaEntidad=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.PresupuestoPartidaEntidad.superclass.constructor.call(this,config);
		this.init();
		this.load({params:{start:0, limit:this.tam_pag}});
		this.iniciaEventos();
	},

	iniciaEventos: function () {
        this.Cmp.id_gestion.on('select',function (cmb, record, index) {
            //this.Cmp.id_partida.store.baseParams = {id_gestion:record.data.id_gestion};
            //this.Cmp.id_presupuesto.store.baseParams = {id_gestion:record.data.id_gestion};
            this.Cmp.id_presupuesto.reset();
            this.Cmp.id_partida.reset();
            this.Cmp.id_entidad_transferencia.reset();

            this.Cmp.id_partida.store.baseParams = {par_filtro:'par.codigo#par.nombre_partida', id_gestion: record.data.id_gestion, sw_transaccional: 'movimiento'};
            this.Cmp.id_presupuesto.store.baseParams = {par_filtro: 'pre.id_presupuesto#pre.tipo_pres#pre.descripcion', tipo_interfaz:'PresupuestoInicio', id_gestion: record.data.id_gestion, codigo_tipo_pres: '2'};

        }, this);
    },

	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_presupuesto_partida_entidad'
			},
			type:'Field',
			form:true 
		},

        {
            config: {
                name: 'id_gestion',
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
                hidden:false,
                width:80,
                minChars: 2,
                editable: false,
                renderer : function(value, p, record) {
                    return String.format('{0}', record.data['desc_gestion']);
                }
            },
            type: 'ComboBox',
            id_grupo: 0,
            bottom_filter: true,
            filters: {pfiltro: 'ges.gestion',type: 'string'},
            grid: true,
            form: true
        },

		{
			config: {
				name: 'id_partida',
				fieldLabel: 'Partida',
				allowBlank: false,
				emptyText: 'Elija una opción...',
				store: new Ext.data.JsonStore({
					url: '../../sis_presupuestos/control/Partida/listarPartida',
					id: 'id_partida',
					root: 'datos',
					sortInfo: {
						field: 'nombre_partida',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_partida', 'codigo', 'nombre_partida','tipo','sw_movimiento'],
					remoteSort: true,
					baseParams: {par_filtro:'par.codigo#par.nombre_partida',sw_transaccional:'movimiento', partida_tipo: 'presupuestaria'}
				}),
				valueField: 'id_partida',
				displayField: 'nombre_partida',
				gdisplayField: 'desc_partida',
				hiddenName: 'id_partida',
				forceSelection: true,
				typeAhead: false,
				triggerAction: 'all',
				lazyRender: true,
				mode: 'remote',
				pageSize: 15,
				queryDelay: 1000,
				anchor: '100%',
				gwidth: 300,
				minChars: 2,
                tpl: new Ext.XTemplate([
                    '<tpl for=".">',
                    '<div class="x-combo-list-item">',
                    '<tpl if="sw_movimiento == \'flujo\'">',
                    '<font color="red"><p>{nombre_partida} ({codigo})</p></font>',
                    '</tpl>',
                    '<tpl if="sw_movimiento == \'presupuestaria\'">',
                    '<font color="green"><p>{nombre_partida} ({codigo})</p></font>',
                    '</tpl>',
                    '<p>Tipo: {sw_movimiento} </p>Rubro: {tipo}</p>',
                    '</div>',
                    '</tpl>'

                ]),
				renderer : function(value, p, record) {
                    return String.format('{0} - ({1})', record.data['desc_partida'],   record.data['desc_gestion']);
				}
			},
			type: 'ComboBox',
			id_grupo: 0,
            bottom_filter: true,

			filters: {pfiltro: 'tpar.codigo#tpar.nombre_partida',type: 'string'},
			grid: true,
			form: true
		},

		{
			config: {
				name: 'id_entidad_transferencia',
				fieldLabel: 'Entidad Transf.',
				allowBlank: false,
				emptyText: 'Elija una opción...',
				store: new Ext.data.JsonStore({
					url: '../../sis_presupuestos/control/EntidadTransferencia/listarEntidadTransferencia',
					id: 'id_entidad_transferencia',
					root: 'datos',
					sortInfo: {
						field: 'nombre',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_entidad_transferencia', 'nombre', 'codigo'],
					remoteSort: true,
					baseParams: {par_filtro: 'ent_tran.codigo#ent_tran.nombre'}
				}),
				valueField: 'id_entidad_transferencia',
				displayField: 'nombre',
				gdisplayField: 'desc_entidad_tranferencia',
				hiddenName: 'id_entidad_transferencia',
				forceSelection: true,
				typeAhead: false,
				triggerAction: 'all',
				lazyRender: true,
				mode: 'remote',
				pageSize: 15,
				queryDelay: 1000,
				anchor: '100%',
				gwidth: 300,
				minChars: 2,
				renderer : function(value, p, record) {
					return String.format('{0}', record.data['desc_entidad_tranferencia']);
				},
                tpl: new Ext.XTemplate([
                    '<tpl for=".">',
                    '<div class="x-combo-list-item">',
                    '<div class="awesomecombo-item {checked}">',
                    '<p><b>Codigo: {codigo}</b></p>',
                    '</div><p><b>Nombre:</b> <span style="color: green;">{nombre}</span></p>',
                    '</div></tpl>'
                ])
			},
			type: 'AwesomeCombo',
			id_grupo: 0,
            bottom_filter: true,
			filters: {pfiltro: 'te.codigo#te.nombre',type: 'string'},
			grid: true,
			form: true
		},

        {
            config: {
                name: 'id_presupuesto',
                fieldLabel: 'Presupuesto',
                allowBlank: false,
                emptyText: 'Elija una opción...',
                store: new Ext.data.JsonStore({
                    url: '../../sis_presupuestos/control/Presupuesto/listarPresupuesto',
                    id: 'id_presupuesto',
                    root: 'datos',
                    sortInfo: {
                        field: 'descripcion',
                        direction: 'ASC'
                    },
                    totalProperty: 'total',
                    fields: ['id_presupuesto', 'tipo_pres', 'descripcion'],
                    remoteSort: true,
                    baseParams: {par_filtro: 'pre.id_presupuesto#pre.tipo_pres#pre.descripcion', tipo_interfaz:'PresupuestoInicio', codigo_tipo_pres: '2'}
                }),
                valueField: 'id_presupuesto',
                displayField: 'descripcion',
                tpl: new Ext.XTemplate([
                    '<tpl for=".">',
                    '<div class="x-combo-list-item">',
                    '<div class="awesomecombo-item {checked}">',
                    '<p><b>Tipo: {tipo_pres}</b></p>',
                    '</div><p><b>Descripción:</b> <span style="color: green;">{descripcion}</span></p>',
                    '</div></tpl>'
                ]),
                gdisplayField: 'desc_presupuesto',
                hiddenName: 'id_presupuesto',
                forceSelection: true,
                typeAhead: false,
                triggerAction: 'all',
                lazyRender: true,
                mode: 'remote',
                pageSize: 15,
                queryDelay: 1000,
                anchor: '100%',
                gwidth: 300,
                minChars: 2,
                resizable:true,
                enableMultiSelect: false,
                renderer : function(value, p, record) {
                    return String.format('{0}', record.data['desc_presupuesto']);
                }
            },
            type: 'ComboBox',
            id_grupo: 0,
            bottom_filter: true,
            filters: {pfiltro: 'tpre.descripcion',type: 'string'},
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
				filters:{pfiltro:'p_p_ent.estado_reg',type:'string'},
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
				filters:{pfiltro:'p_p_ent.id_usuario_ai',type:'numeric'},
				id_grupo:1,
				grid:false,
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
				filters:{pfiltro:'p_p_ent.usuario_ai',type:'string'},
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
				filters:{pfiltro:'p_p_ent.fecha_reg',type:'date'},
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
				filters:{pfiltro:'p_p_ent.fecha_mod',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		}
	],
	tam_pag:50,	
	title:'Relación de Entidades',
	ActSave:'../../sis_presupuestos/control/PresupuestoPartidaEntidad/insertarPresupuestoPartidaEntidad',
	ActDel:'../../sis_presupuestos/control/PresupuestoPartidaEntidad/eliminarPresupuestoPartidaEntidad',
	ActList:'../../sis_presupuestos/control/PresupuestoPartidaEntidad/listarPresupuestoPartidaEntidad',
	id_store:'id_presupuesto_partida_entidad',
	fields: [
		{name:'id_presupuesto_partida_entidad', type: 'numeric'},
		{name:'id_partida', type: 'numeric'},
		{name:'id_gestion', type: 'numeric'},
		{name:'id_entidad_transferencia', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'id_presupuesto', type: 'numeric'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'usuario_ai', type: 'string'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
        'desc_partida',
        'desc_gestion',
        'desc_entidad_tranferencia',
        'desc_presupuesto'
		
	],
	sortInfo:{
		field: 'id_presupuesto_partida_entidad',
		direction: 'ASC'
	},
	bdel:true,
	bsave:true,

    onButtonNew : function () {
        Phx.vista.PresupuestoPartidaEntidad.superclass.onButtonNew.call(this);
        Ext.Ajax.request({
            url:'../../sis_reclamo/control/Reclamo/getDatosOficina',
            params:{id_usuario:0},
            success:function(resp){
                var reg =  Ext.decode(Ext.util.Format.trim(resp.responseText));
                this.Cmp.id_gestion.setValue(reg.ROOT.datos.id_gestion);
                this.Cmp.id_gestion.setRawValue(reg.ROOT.datos.gestion);
                this.Cmp.id_partida.store.baseParams = {par_filtro:'par.codigo#par.nombre_partida', id_gestion:reg.ROOT.datos.id_gestion, sw_transaccional: 'movimiento'};
                this.Cmp.id_presupuesto.store.baseParams = {par_filtro: 'pre.id_presupuesto#pre.tipo_pres#pre.descripcion', tipo_interfaz:'PresupuestoInicio', id_gestion: reg.ROOT.datos.id_gestion, codigo_tipo_pres: '2'};

                //this.store.baseParams.id_gestion=this.cmbGestion.getValue();
            },
            failure: this.conexionFailure,
            timeout:this.timeout,
            scope:this
        });


    },

    onButtonEdit: function () {
        Phx.vista.PresupuestoPartidaEntidad.superclass.onButtonEdit.call(this);
        this.Cmp.id_partida.store.baseParams = {par_filtro:'par.codigo#par.nombre_partida', id_gestion:this.Cmp.id_gestion.getValue(), sw_transaccional: 'movimiento'};
        this.Cmp.id_presupuesto.store.baseParams = {par_filtro: 'pre.id_presupuesto#pre.tipo_pres#pre.descripcion', tipo_interfaz:'PresupuestoInicio', id_gestion: this.Cmp.id_gestion.getValue(), codigo_tipo_pres: '2'};

    },

    onSubmit: function (o, x, force) {

        Ext.Ajax.request({
            url:'../../sis_presupuestos/control/PresupuestoPartidaEntidad/validarCampos',
            params:{
                'id_partida':this.Cmp.id_partida.getValue(),
                'id_entidad_transferencia':this.Cmp.id_entidad_transferencia.getValue(),
                'id_presupuesto': this.Cmp.id_presupuesto.getValue()
            },
            success:function (resp) {
                var reg =  Ext.decode(Ext.util.Format.trim(resp.responseText));
                if(JSON.parse(reg.ROOT.datos.v_valid)){
                    Ext.Msg.show({
                        title: 'Alerta',
                        msg: '<p><b>Estimado Usuario:</b> ' +
                        '</p><br><b>'+reg.ROOT.datos.v_mensaje+'</b> Le sugerimos verificar la relación que esta tratando de registrar.',
                        buttons: Ext.Msg.OK,
                        width: 600,
                        icon: Ext.Msg.WARNING
                    });
                }else{
                    Phx.vista.PresupuestoPartidaEntidad.superclass.onSubmit.call(this, o);
                }

            },
            failure: this.conexionFailure,
            timeout:this.timeout,
            scope:this
        });
    }

	}
)
</script>
		
		