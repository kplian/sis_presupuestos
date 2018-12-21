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
#2			 20/12/2018	Miguel Mamani			Replicación de partidas y presupuestos
 **/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.PartidaIds=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
        this.initButtons=[this.cmbGestion];
        //llama al constructor de la clase padre
		Phx.vista.PartidaIds.superclass.constructor.call(this,config);
		this.init();
        this.cmbGestion.on('select', function(combo, record, index){
            this.capturaFiltros();
            this.iniciarEvento();
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
        console.log('Hola');
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
    }
	}
)
</script>
		
		