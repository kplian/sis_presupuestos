<?php
/**
*@package pXP
*@file gen-ObjetivoPresupuesto.php
*@author  (franklin.espinoza)
*@date 27-07-2017 16:10:48
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.ObjetivoPresupuesto=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.ObjetivoPresupuesto.superclass.constructor.call(this,config);
		this.init();
        var dataPadre = Phx.CP.getPagina(this.idContenedorPadre).getSelectedData();
         if(dataPadre){
         this.onEnablePanel(this, dataPadre);
         }
         else
         {
         this.bloquearMenus();
         }
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_objetivo_presupuesto'
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
                    fields: ['id_presupuesto', 'tipo_pres', 'descripcion', 'desc_tcc', 'nombre_uo','codigo_tcc', 'descripcion_tcc'],
                    remoteSort: true,
                    baseParams: {par_filtro: 'pre.tipo_pres#pre.descripcion#codigo_tcc', tipo_interfaz:'PresupuestoInicio'}
                }),
                valueField: 'id_presupuesto',
                displayField: 'descripcion',
				gdisplayField: 'desc_presupuesto',
                tpl: new Ext.XTemplate([
                    '<tpl for=".">',
                    '<div class="x-combo-list-item">',
                    '<div class="awesomecombo-item {checked}">',
                    '<p><b>Depto: {nombre_uo}</b></p>',
                    '</div><p><b>Descripción:</b> <span style="color: green;">{desc_tcc}</span></p>',
                    '</div></tpl>'
                ]),

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
                enableMultiSelect: true,
                renderer : function(value, p, record) {
                    return String.format('{0}', record.data['desc_presupuesto']);
                }
            },
            type: 'AwesomeCombo',
            id_grupo: 0,
            bottom_filter: true,
            filters: {pfiltro: 'tpre.descripcion',type: 'string'},
            grid: true,
            form: true
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
                        return String.format('<font color="orange"><b>{0}</b></font>', value);
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
				filters:{pfiltro:'obj_pres.estado_reg',type:'string'},
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
				name: 'fecha_reg',
				fieldLabel: 'Fecha creación',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
							format: 'd/m/Y', 
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
			},
				type:'DateField',
				filters:{pfiltro:'obj_pres.fecha_reg',type:'date'},
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
				filters:{pfiltro:'obj_pres.usuario_ai',type:'string'},
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
				filters:{pfiltro:'obj_pres.id_usuario_ai',type:'numeric'},
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
				filters:{pfiltro:'obj_pres.fecha_mod',type:'date'},
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
	title:'ObjetivoPresupuesto',
	ActSave:'../../sis_presupuestos/control/ObjetivoPresupuesto/insertarObjetivoPresupuesto',
	ActDel:'../../sis_presupuestos/control/ObjetivoPresupuesto/eliminarObjetivoPresupuesto',
	ActList:'../../sis_presupuestos/control/ObjetivoPresupuesto/listarObjetivoPresupuesto',
	id_store:'id_objetivo_presupuesto',
	fields: [
		{name:'id_objetivo_presupuesto', type: 'numeric'},
		{name:'id_objetivo', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'id_presupuesto', type: 'numeric'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usuario_ai', type: 'string'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		{name:'desc_presupuesto', type: 'string'},
		{name:'tipo_reg', type: 'string'}

	],
	sortInfo:{
		field: 'id_objetivo_presupuesto',
		direction: 'ASC'
	},
	bdel:true,
    btest: false,
    bsave: false,
    fheight: '30%',

    onReloadPage:function(m){
        this.maestro=m;
        console.log('maestro',this.maestro);
        this.store.baseParams={id_objetivo:this.maestro.id_objetivo};
        this.load({ params: { start: 0, limit: 50 }});
    },

    loadValoresIniciales:function()
    {
        Phx.vista.ObjetivoPresupuesto.superclass.loadValoresIniciales.call(this);
        this.Cmp.id_objetivo.setValue(this.maestro.id_objetivo);

    },


    onButtonNew: function () {
        Phx.vista.ObjetivoPresupuesto.superclass.onButtonNew.call(this);
        //this.Cmp.id_partida.store.baseParams ={id_gestion:this.maestro.id_gestion, sw_transaccional:'movimiento'};
        this.Cmp.id_presupuesto.store.baseParams = {par_filtro: 'pre.tipo_pres#pre.descripcion#codigo_tcc', id_gestion:this.maestro.id_gestion, tipo_interfaz:'PresupuestoInicio', codigo_tipo_pres: '2'}
    },

	successSave: function (resp) {
		Phx.vista.ObjetivoPresupuesto.superclass.successSave.call(this,resp);

		var objRes = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
		console.log('v_mensaje',objRes.ROOT.datos.v_mensaje);
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
		Phx.vista.ObjetivoPresupuesto.superclass.onButtonEdit.call(this);
		this.Cmp.id_presupuesto.store.baseParams = {par_filtro: 'pre.tipo_pres#pre.descripcion#codigo_tcc', id_gestion:this.maestro.id_gestion, tipo_interfaz:'PresupuestoInicio', codigo_tipo_pres: '2'}
	}


	}
)
</script>
		
		