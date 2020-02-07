<?php
/**
*@package pXP
*@file gen-PresupuestoIds.php
*@author  (miguel.mamani)
*@date 17-12-2018 19:20:26
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/
/**
HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
#2				 20/12/2018	        Miguel Mamani			Replicación de partidas y presupuestos
#4				 03/01/2019	        Miguel Mamani			Relación por gestiones paridas y presupuesto e reporte de presupuesto que no figuran en gestión nueva
#36              07/02/2020         JJA                     Corrección de impresión del grid en replicación de presupuesto
 **/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.PresupuestoIds=Ext.extend(Phx.gridInterfaz,{
    anhio:0, //#4
	constructor:function(config){
		this.maestro=config.maestro;
        this.initButtons=[this.cmbGestion];

        //llama al constructor de la clase padre
		Phx.vista.PresupuestoIds.superclass.constructor.call(this,config);
		this.init();
        this.addButton('inserAuto',{ text: 'Relacionar Pre', iconCls: 'blist', disabled: false, handler: this.mostarFormAuto, tooltip: '<b>Relacion entre dos presupueste de gestion actual y el siguiente</b>'}); ///#4
        this.addButton('btnReport',{text : 'Reporte Movimiento', iconCls : 'bpdf32', disabled: false, handler : this.onButtonReporte}); //#4
        this.cmbGestion.on('select', function(combo, record, index){
            this.iniciarEvento();
            this.capturaFiltros();
            this.anhio = this.cmbGestion.getValue(); //#4
            this.crearFormAuto(); //#4
        },this);
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_presupuesto_uno'
			},
			type:'Field',
			form:true
		},{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_gestion_act'
			},
			type:'Field',
			form:true
		},
        {
            config:{
                name: 'gestion',
                fieldLabel: 'Gestion',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:4
            },
            type:'Field',
            id_grupo:1,
            grid:true,
            form:false
        },
        {
            config:{
                sysorigen: 'sis_presupuestos',
                name: 'id_presupuesto_uno',
                fieldLabel: 'Presupuesto Act.', //#36
                allowBlank: false,
                tinit: false,
                origen: 'PRESUPUESTO',
                gdisplayField: 'descripcion',
                width: 350,
                listWidth: 350,
                gwidth: 350,
                renderer : function(value, p, record) {
                    return '<div><p><b>'+record.data['descripcion']+'</b></p></div>';
                }
            },
            type: 'ComboRec',
            filters:{pfiltro:'pr1.descripcion',type:'string'},
            id_grupo:1,
            grid: true,
            bottom_filter: true,
            form: true
        },
        {
            config:{
                name: 'gestion_dos',
                fieldLabel: 'Gestion',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:4
            },
            type:'Field',
            id_grupo:1,
            grid:true,
            form:false
        },
        {
            config:{
                sysorigen: 'sis_presupuestos',
                name: 'id_presupuesto_dos',
                fieldLabel: 'Presupuesto Sig.',
                allowBlank: false,
                tinit: false,
                origen: 'PRESUPUESTO',
                gdisplayField: 'descripcion_dos', //#36 
                baseParams: { estado: 'borrador', sw_oficial: 'no' },
                width: 350,
                listWidth: 350,
                gwidth: 350,
                renderer : function(value, p, record) {
                    return '<div><p><b>'+record.data['descripcion_dos']+'</b></p></div>';
                }
            },
            type: 'ComboRec',
            id_grupo:1,
            grid: true,
            form: false
        },
        {
            config:{
                name: 'insercion',
                fieldLabel: 'Insercion',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:20,
                renderer : function(value, p, record) {
                    var color = '';
                    if(record.data['insercion'] == "automatico"){
                        color = '<font color="green">';
                    }else{
                        color = '<font color="#ff8c00">';
                    }
                    return String.format(color+'{0}</font>', record.data['insercion']);
                }
            },
            type:'TextField',
            filters:{pfiltro:'rpp.insercion',type:'string'},
            id_grupo:1,
            grid:true,
            form:false
        },
		{
			config:{
				name: 'estado_reg',
				fieldLabel: 'Estado',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:1
			},
				type:'TextField',
				filters:{pfiltro:'rpp.estado_reg',type:'string'},
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
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
			},
				type:'DateField',
				filters:{pfiltro:'pi.fecha_reg',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		}
	],
	tam_pag:50,	
	title:'Replicacion Presupuesto',
	ActSave:'../../sis_presupuestos/control/PresupuestoIds/insertarPresupuestoIds',
	ActDel:'../../sis_presupuestos/control/PresupuestoIds/eliminarPresupuestoIds',
	ActList:'../../sis_presupuestos/control/PresupuestoIds/listarPresupuestoIds',
	id_store:'id_presupuesto_uno',
	fields: [
		{name:'id_presupuesto_uno', type: 'numeric'},
		{name:'id_presupuesto_dos', type: 'numeric'},
		{name:'id_categoria_prog', type: 'numeric'},
        {name:'id_categoria_prog_dos', type: 'numeric'},
        {name:'nro_tramite', type: 'string'},
		{name:'nro_tramite_dos', type: 'string'},
		{name:'descripcion', type: 'string'},
		{name:'descripcion_dos', type: 'string'},
        {name:'descripcion_tcc', type: 'string'},
        {name:'descripcion_tcc_dos', type: 'string'},
        {name:'categoria', type: 'string'},
		{name:'gestion', type: 'numeric'},
        {name:'gestion_dos', type: 'numeric'},
        {name:'nombre', type: 'string'},
        {name:'nombre_dos', type: 'string'},
        {name:'estado_reg', type: 'string'},
        {name:'id_usuario_reg', type: 'numeric'},
        {name:'fecha_reg', type: 'date',dateFormat:'Y-m-d'},
        {name:'usr_reg', type: 'string'},
        {name:'insercion', type: 'string'}
	],
	sortInfo:{
		field: 'insercion',
		direction: 'DESC'
	},
	bdel:true,
	bsave:false,
    bedit:false,
    capturaFiltros:function(combo, record, index){
        this.desbloquearOrdenamientoGrid();
        // this.validarFiltros();
        if(this.validarFiltros()){
            this.store.baseParams.id_gestion = this.cmbGestion.getValue();
            this.load();
        }

    },
    onButtonNew:function(){
        Phx.vista.PresupuestoIds.superclass.onButtonNew.call(this);
        this.Cmp.id_gestion_act.setValue(this.cmbGestion.getValue());
        console.log('Hola');
    },
    validarFiltros:function(){
        if(this.cmbGestion.validate()){
            this.getBoton('new').enable();
            this.getBoton('del').enable();
            return true;
        }
        else{
            this.getBoton('new').disable();
            this.getBoton('del').disable();
            return false;
        }
    },
    onButtonAct:function(){
        if(!this.validarFiltros()){
            alert('Especifique el año antes')
        }
        else{
            this.store.baseParams.id_gestion=this.cmbGestion.getValue();
            Phx.vista.PresupuestoIds.superclass.onButtonAct.call(this);
        }
    },
    cmbGestion: new Ext.form.ComboBox({
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
        width:80
    }),
    iniciarEvento: function (){
        Ext.apply(this.Cmp.id_presupuesto_uno.store.baseParams,{par_filtro: 'id_centro_costo#codigo_cc#desc_tipo_presupuesto#movimiento_tipo_pres',id_gestion: this.cmbGestion.getValue()});
    },
    ////#4
    mostarFormAuto:function(){
        if(!this.validarFiltros()){
            alert('Especifique el año antes')
        }else{
            this.cmpAutoAct.setValue();
            this.cmpAutoSig.setValue();
            this.wAuto.show();
        }
    },
    crearFormAuto:function(){
        var storeCombo = new Ext.data.JsonStore({
            url: '../../sis_presupuestos/control/Presupuesto/listarPresupuestoCmb',
            id: 'id_presupuesto',
            root: 'datos',
            sortInfo:{
                field: 'codigo_cc',
                direction: 'ASC'
            },
            totalProperty: 'total',
            fields: [ 'id_centro_costo','id_presupuesto','desc_tipo_presupuesto','descripcion','codigo_cc','tipo_pres',
                      'desc_tipo_presupuesto','movimiento_tipo_pres','nro_tramite','id_gestion',
                      'movimiento_tipo_pres','estado'],
            remoteSort: true,
            baseParams: {par_filtro: 'id_centro_costo#codigo_cc#desc_tipo_presupuesto#movimiento_tipo_pres',id_gestion:  this.anhio }
        });
        var combo = new Ext.form.ComboBox({
            name:'id_presupuesto_uno',
            fieldLabel:'Presupuesto Act',
            allowBlank : false,
            typeAhead: true,
            store: storeCombo,
            mode: 'remote',
            pageSize: 15,
            triggerAction: 'all',
            valueField : 'id_presupuesto',
            displayField : 'codigo_cc',
            forceSelection: true,
            allowBlank : false,
            anchor: '100%',
            resizable : true,
            enableMultiSelect: false
        });
        var sig = parseInt(this.anhio)+1;
        var storeComboSig = new Ext.data.JsonStore({
            url: '../../sis_presupuestos/control/Presupuesto/listarPresupuestoCmb',
            id: 'id_presupuesto',
            root: 'datos',
            sortInfo:{
                field: 'codigo_cc',
                direction: 'ASC'
            },
            totalProperty: 'total',
            fields: [ 'id_centro_costo','id_presupuesto','desc_tipo_presupuesto','descripcion','codigo_cc','tipo_pres',
                'desc_tipo_presupuesto','movimiento_tipo_pres','nro_tramite','id_gestion',
                'movimiento_tipo_pres','estado'],
            remoteSort: true,
            baseParams: {par_filtro: 'id_centro_costo#codigo_cc#desc_tipo_presupuesto#movimiento_tipo_pres',id_gestion: sig}
        });

        var comboSig = new Ext.form.ComboBox({
            name:'id_presupuesto_dos',
            fieldLabel:'Presupuesto Sig',
            allowBlank : false,
            typeAhead: true,
            store: storeComboSig,
            mode: 'remote',
            pageSize: 15,
            triggerAction: 'all',
            valueField : 'id_presupuesto',
            displayField : 'codigo_cc',
            forceSelection: true,
            allowBlank : false,
            anchor: '100%',
            resizable : true,
            enableMultiSelect: false
        });
        this.formAuto = new Ext.form.FormPanel({
            baseCls: 'x-plain',
            autoDestroy: true,
            border: false,
            layout: 'form',
            autoHeight: true,
            items: [combo,comboSig]
        });
        this.wAuto = new Ext.Window({
            title: 'Relacion Rresupuestaria',
            collapsible: true,
            maximizable: true,
            autoDestroy: true,
            width: 420,
            height: 170,
            layout: 'fit',
            plain: true,
            bodyStyle: 'padding:5px;',
            buttonAlign: 'center',
            items: this.formAuto,
            modal:true,
            closeAction: 'hide',
            buttons: [{
                text: 'Guardar',
                handler: this.saveAuto,
                scope: this},
                {
                    text: 'Cancelar',
                    handler: function(){ this.wAuto.hide() },
                    scope: this
                }]
        });
        this.cmpAutoAct = this.formAuto.getForm().findField('id_presupuesto_uno');
        this.cmpAutoSig = this.formAuto.getForm().findField('id_presupuesto_dos');
    },
    saveAuto: function(){
        Phx.CP.loadingShow();
        Ext.Ajax.request({
            url: '../../sis_presupuestos/control/PresupuestoIds/relacionarPresupuestoIds',
            params: {
                id_presupuesto_uno : this.cmpAutoAct.getValue(),
                id_presupuesto_dos : this.cmpAutoSig.getValue()
            },
            success: this.successSinc,
            failure: this.conexionFailure,
            timeout: this.timeout,
            scope: this
        });

    },
    successSinc:function(resp){
        Phx.CP.loadingHide();
        var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
        if(!reg.ROOT.error){
            if(this.wAuto){
                this.wAuto.hide();
            }
            this.reload();
        }else{
            alert('ocurrio un error durante el proceso')
        }
    },
    onButtonReporte:function () {
        if(!this.validarFiltros()){
            alert('Especifique el año antes')
        }
        else{
            Phx.CP.loadingShow();
            Ext.Ajax.request({
                url : '../../sis_presupuestos/control/PresupuestoIds/reporteMovmiento',
                params : {
                    'id_gestion' : this.cmbGestion.getValue(),
                    'gestion': this.cmbGestion.getRawValue()
                },
                success : this.successExport,
                failure : this.conexionFailure,
                timeout : this.timeout,
                scope : this
            });
        }
    }
    //#4
	}
)
</script>
		
		