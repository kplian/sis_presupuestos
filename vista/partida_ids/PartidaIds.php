<?php
/**
*@package pXP
*@file gen-PartidaIds.php
*@author  (miguel.mamani)
*@date 17-12-2018 19:20:23
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/
/**
HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
#2			     20/12/2018	            Miguel Mamani			Replicación de partidas y presupuestos
#4				 03/01/2019	            Miguel Mamani			Relación por gestiones paridas y presupuesto e reporte de presupuesto que no figuran en gestión nueva

 **/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.PartidaIds=Ext.extend(Phx.gridInterfaz,{
    anhio:0, //#4
	constructor:function(config){
		this.maestro=config.maestro;
        this.initButtons=[this.cmbGestion];
        //llama al constructor de la clase padre
		Phx.vista.PartidaIds.superclass.constructor.call(this,config);
		this.init();
        this.addButton('inserAuto',{ text: 'Relacionar Partida', iconCls: 'blist', disabled: false, handler: this.mostarFormAuto, tooltip: '<b>Relacion entre dos partidas de gestion actual y el siguiente</b>'}); //#4
        this.cmbGestion.on('select', function(combo, record, index){
            this.capturaFiltros();
            this.iniciarEvento();
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
                name: 'id_partida_uno'
            },
            type:'Field',
            form:true
        },
        {
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
                sysorigen: 'sis_presupuestos',
                name: 'id_partida_uno',
                origen: 'PARTIDA',
                gdisplayField: 'desc_partida',
                allowBlank: true,
                fieldLabel: 'Partida Act.',
                gwidth: 400,
                anchor: '80%',
                renderer : function(value, p, record) {
                    if(record.data['codigo_dos'] != '0'){
                        return '<div><p><b> Codigo: ' + record.data['codigo'] +' ('+record.data['nombre_partida']+')</b></p>' +
                            '<p> Gestion: <font color="#00008b"><b>'+record.data['gestion']+'</b></div>';
                    }else {
                        return '<p><font color="red"><b>NO SE REPLICO</b></font></div>';
                    }
                }
            },
            type:'ComboRec',
            filters:{pfiltro:'par1.codigo',type:'string'},
            id_grupo:0,
            form:true,
            bottom_filter: true,
            grid:true
        },
        {
            config:{
                sysorigen: 'sis_presupuestos',
                name: 'id_partida_dos',
                origen: 'PARTIDA',
                gdisplayField: 'desc_partida',
                allowBlank: true,
                fieldLabel: 'Partida Sig.',
                gwidth: 400,
                anchor: '80%',
                renderer : function(value, p, record) {
                     if(record.data['codigo_dos'] != '0'){
                         return '<div><p><b> Codigo: ' + record.data['codigo_dos'] +' ('+record.data['nombre_partida_dos']+')</b></p>' +
                                '<p> Gestion: <font color="#00008b"><b>'+record.data['gestion_dos']+'</b></font> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; <font color="#00008b">'+record.data['validar']+'</font> </div>';
                     }else {
                         return '<p><font color="red"><b>NO SE REPLICO</b></font></div>';
                     }
                }
            },
            type:'ComboRec',
            id_grupo:0,
            form:false,
            grid:true
        },
		{
			config:{
				name: 'sw_cambio_gestion',
				fieldLabel: 'Cambio Gstion',
				allowBlank: true,
				anchor: '80%',
				gwidth: 150,
				maxLength:10
			},
				type:'TextField',
				filters:{pfiltro:'rps.sw_cambio_gestion',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
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
				filters:{pfiltro:'ga.insercion',type:'string'},
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
				maxLength:50
			},
				type:'TextField',
				filters:{pfiltro:'rps.estado_reg',type:'string'},
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
				filters:{pfiltro:'rps.fecha_reg',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		}
	],
	tam_pag:50,	
	title:'Replicacion Partidas',
	ActSave:'../../sis_presupuestos/control/PartidaIds/insertarPartidaIds',
	ActDel:'../../sis_presupuestos/control/PartidaIds/eliminarPartidaIds',
	ActList:'../../sis_presupuestos/control/PartidaIds/listarPartidaIds',
	id_store:'id_partida_uno',
	fields: [
		{name:'id_partida_uno', type: 'numeric'},
		{name:'id_partida_dos', type: 'numeric'},
		{name:'sw_cambio_gestion', type: 'string'},
		{name:'insercion', type: 'string'},
		{name:'estado_reg', type: 'string'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d'},
		{name:'usr_reg', type: 'string'},
        {name:'codigo', type: 'string'},
        {name:'nombre_partida', type: 'string'},
        {name:'gestion', type: 'numeric'},
        {name:'codigo_dos', type: 'string'},
        {name:'nombre_partida_dos', type: 'string'},
        {name:'gestion_dos', type: 'numeric'},
        {name:'validar', type: 'string'}
		
	],
	sortInfo:{
		field: 'insercion',
		direction: 'DESC'
	},

    capturaFiltros:function(combo, record, index){
        this.desbloquearOrdenamientoGrid();
       // this.validarFiltros();
        if(this.validarFiltros()){
            this.store.baseParams.id_gestion = this.cmbGestion.getValue();
            this.load();
        }

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
    onButtonNew:function(){
        Phx.vista.PartidaIds.superclass.onButtonNew.call(this);
        this.Cmp.id_gestion_act.setValue(this.cmbGestion.getValue());
    },
    onButtonAct:function(){
        if(!this.validarFiltros()){
            alert('Especifique el año antes')
        }
        else{
            this.store.baseParams.id_gestion=this.cmbGestion.getValue();
            Phx.vista.PartidaIds.superclass.onButtonAct.call(this);
        }
    },
	bdel:true,
	bsave:false,
    bedit:false,
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
        Ext.apply(this.Cmp.id_partida_uno.store.baseParams,{par_filtro:'codigo#nombre_partida',id_gestion: this.cmbGestion.getValue()});
    },
    //#4
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
            url: '../../sis_presupuestos/control/Partida/listarPartida',
            id: 'id_partida',
            root: 'datos',
            sortInfo:{
                field: 'codigo',
                direction: 'ASC'
            },
            totalProperty: 'total',
            fields: ['id_partida','codigo','nombre_partida','tipo','sw_movimiento'],
            remoteSort: true,
            baseParams: {par_filtro:'codigo#nombre_partida',id_gestion:this.anhio }
        });
        var combo = new Ext.form.ComboBox({
            name:'id_partida_uno',
            fieldLabel:'Partida Act',
            allowBlank : false,
            typeAhead: true,
            store: storeCombo,
            mode: 'remote',
            pageSize: 15,
            triggerAction: 'all',
            valueField : 'id_partida',
            displayField : 'nombre_partida',
            forceSelection: true,
            allowBlank : false,
            anchor: '100%',
            resizable : true,
            enableMultiSelect: false,
            tpl:'<tpl for="."><div class="x-combo-list-item"><p>{codigo} {nombre_partida}</p></div></tpl>'

        });
        var sig = parseInt(this.anhio)+1;

        var storeComboSig = new Ext.data.JsonStore({
            url: '../../sis_presupuestos/control/Partida/listarPartida',
            id: 'id_partida',
            root: 'datos',
            sortInfo:{
                field: 'codigo',
                direction: 'ASC'
            },
            totalProperty: 'total',
            fields: ['id_partida','codigo','nombre_partida','tipo','sw_movimiento'],
            remoteSort: true,
            baseParams: {par_filtro:'codigo#nombre_partida',id_gestion: sig}
        });
        var comboSig = new Ext.form.ComboBox({
            name:'id_partida_dos',
            fieldLabel:'Partida Sig',
            allowBlank : false,
            typeAhead: true,
            store: storeComboSig,
            mode: 'remote',
            pageSize: 15,
            triggerAction: 'all',
            valueField : 'id_partida',
            displayField : 'nombre_partida',
            forceSelection: true,
            allowBlank : false,
            anchor: '100%',
            resizable : true,
            enableMultiSelect: false,
            tpl:'<tpl for="."><div class="x-combo-list-item"><p>{codigo} {nombre_partida}</p></div></tpl>'

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
        this.cmpAutoAct = this.formAuto.getForm().findField('id_partida_uno');
        this.cmpAutoSig = this.formAuto.getForm().findField('id_partida_dos');
    },
    saveAuto: function(){
        Phx.CP.loadingShow();
        Ext.Ajax.request({
            url: '../../sis_presupuestos/control/PartidaIds/relacionarPartidaIds',
            params: {
                id_partida_uno : this.cmpAutoAct.getValue(),
                id_partida_dos : this.cmpAutoSig.getValue()
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
    }
    //#4
	}
)
</script>



