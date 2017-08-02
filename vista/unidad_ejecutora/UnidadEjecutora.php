<?php
/**
*@package pXP
*@file gen-UnidadEjecutora.php
*@author  (franklin.espinoza)
*@date 21-07-2017 13:41:05
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.UnidadEjecutora=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.UnidadEjecutora.superclass.constructor.call(this,config);
		this.init();
		this.load({params:{start:0, limit:this.tam_pag}})
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_unidad_ejecutora'
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
                    return String.format('{0}', record.data['gestion']);
                }
            },
            type: 'ComboBox',
            id_grupo: 0,
            bottom_filter: true,
            filters: {pfiltro: 'tg.gestion',type: 'string'},
            grid: true,
            form: true
        },
		{
			config:{
				name: 'codigo',
				fieldLabel: 'Codigo',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:20
			},
			type:'TextField',
            bottom_filter: true,
			filters:{pfiltro:'und_eje.codigo',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		
		{
			config:{
				name: 'nombre',
				fieldLabel: 'Nombre',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:256
			},
				type:'TextField',
                bottom_filter: true,
				filters:{pfiltro:'und_eje.nombre',type:'string'},
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
				filters:{pfiltro:'und_eje.estado_reg',type:'string'},
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
				filters:{pfiltro:'und_eje.id_usuario_ai',type:'numeric'},
				id_grupo:1,
				grid:false,
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
				filters:{pfiltro:'und_eje.fecha_reg',type:'date'},
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
				filters:{pfiltro:'und_eje.usuario_ai',type:'string'},
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
				name: 'fecha_mod',
				fieldLabel: 'Fecha Modif.',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
							format: 'd/m/Y', 
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
			},
				type:'DateField',
				filters:{pfiltro:'und_eje.fecha_mod',type:'date'},
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
	title:'UnidadEjecutora',
	ActSave:'../../sis_presupuestos/control/UnidadEjecutora/insertarUnidadEjecutora',
	ActDel:'../../sis_presupuestos/control/UnidadEjecutora/eliminarUnidadEjecutora',
	ActList:'../../sis_presupuestos/control/UnidadEjecutora/listarUnidadEjecutora',
	id_store:'id_unidad_ejecutora',
	fields: [
		{name:'id_unidad_ejecutora', type: 'numeric'},
		{name:'id_gestion', type: 'numeric'},
		{name:'nombre', type: 'string'},
		{name:'codigo', type: 'string'},
		{name:'estado_reg', type: 'string'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usuario_ai', type: 'string'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		{name:'gestion', type: 'string'}

	],
	sortInfo:{
		field: 'id_unidad_ejecutora',
		direction: 'ASC'
	},
	bdel:true,
	bsave:true,

    onButtonNew : function () {
        Ext.Ajax.request({
            url:'../../sis_reclamo/control/Reclamo/getDatosOficina',
            params:{id_usuario:0},
            success:function(resp){
                var reg =  Ext.decode(Ext.util.Format.trim(resp.responseText));
                this.Cmp.id_gestion.setValue(reg.ROOT.datos.id_gestion);
                this.Cmp.id_gestion.setRawValue(reg.ROOT.datos.gestion);
                //this.store.baseParams.id_gestion=this.cmbGestion.getValue();
            },
            failure: this.conexionFailure,
            timeout:this.timeout,
            scope:this
        });

        Phx.vista.UnidadEjecutora.superclass.onButtonNew.call(this);
    },

    onSubmit: function (o, x, force) {

        Ext.Ajax.request({
            url:'../../sis_presupuestos/control/UnidadEjecutora/validarCampos',
            params:{
                'codigo':this.Cmp.codigo.getValue(),
                'nombre':this.Cmp.nombre.getValue()
            },
            success:function (resp) {
                var reg =  Ext.decode(Ext.util.Format.trim(resp.responseText));
                if(JSON.parse(reg.ROOT.datos.v_valid)){
                    Ext.Msg.show({
                        title: 'Alerta',
                        msg: '<p><b>Estimado Usuario,</b> informarle que el o los campo(s): ' +
                        '</p><br><b>'+reg.ROOT.datos.v_mensaje+'</b> ya se encuentra registrado. Le sugerimos verificar los datos que esta tratando de registrar.',
                        buttons: Ext.Msg.OK,
                        width: 600,
                        icon: Ext.Msg.WARNING
                    });
                }else{
                    Phx.vista.UnidadEjecutora.superclass.onSubmit.call(this, o);
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
		
		