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
#2				 20/12/2018	Miguel Mamani			Replicación de partidas y presupuestos
 **/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.PresupuestoIds=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
        this.initButtons=[this.cmbGestion];

        //llama al constructor de la clase padre
		Phx.vista.PresupuestoIds.superclass.constructor.call(this,config);
		this.init();
        //this.load({params:{start:0, limit:this.tam_pag}})
        this.cmbGestion.on('select', function(combo, record, index){
            this.iniciarEvento();
            this.capturaFiltros();
        },this);
	},
			
	Atributos:[
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
                fieldLabel: 'Presupuesto Act.',
                allowBlank: false,
                tinit: false,
                origen: 'PRESUPUESTO',
                gdisplayField: 'desc_presupuesto_hijo',
                width: 350,
                listWidth: 350,
                gwidth: 300,
                renderer : function(value, p, record) {
                    return '<div><p><b> Tipo: <font color="#00008b">'+record.data['nombre']+'</font></b></span></p>' +
                        '<p><b>' + record.data['descripcion'] +'</b></p></div>';
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
                name: 'nro_tramite',
                fieldLabel: 'Centro Costo',
                allowBlank: false,
                anchor: '80%',
                gwidth: 300,
                maxLength:10,
                renderer : function(value, p, record) {
                    return '<div><p><b> Tipo: <font color="#00008b">'+record.data['nro_tramite']+'</font></b></span></p>' +
                        '<p><b>' + record.data['descripcion_tcc'] +'</b></p></div>';
                }
            },
            type:'TextField',
           // bottom_filter: true,
            id_grupo:1,
            grid:true,
            form:false
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
                gdisplayField: 'desc_presupuesto_hijo',
                baseParams: { estado: 'borrador', sw_oficial: 'no' },
                width: 350,
                listWidth: 350,
                gwidth: 300,
                renderer : function(value, p, record) {
                    return '<div><p><b><font color="#006400">'+record.data['nombre_dos']+'</font></b></span></p>' +
                        '<p><b>'+record.data['descripcion_dos']+'</b></p></div>';
                }
            },
            type: 'ComboRec',
            id_grupo:1,
            grid: true,
            form: false
        },
        {
            config:{
                name: 'nro_tramite_dos',
                fieldLabel: 'Centro Costo',
                allowBlank: false,
                anchor: '80%',
                gwidth: 300,
                maxLength:10,
                renderer : function(value, p, record) {
                    return '<div><p><b><font color="#006400">'+record.data['nro_tramite_dos']+'</font></b></span></p>' +
                        '<p><b>' + record.data['descripcion_tcc_dos'] +'</b></p></div>';
                }
            },
            type:'TextField',

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
				filters:{pfiltro:'rpp.fecha_reg',type:'date'},
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
    }
	}
)
</script>
		
		