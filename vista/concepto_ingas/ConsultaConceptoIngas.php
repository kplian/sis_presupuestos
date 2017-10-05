<?php
/**
 *@package pXP
 *@file gen-SistemaDist.php
 *@author  (fprudencio)
 *@date 20-09-2011 10:22:05
 *@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
 */
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.ConsultaConceptoIngas = Ext.extend(Phx.gridInterfaz, {
        bdel: false,
        bedit: false,
        bnew: false,
        btest: false,
        bexcel:true,
        ActList:'../../sis_presupuestos/control/ConsultasIngas/listarConsultaConceptoIngas',
        title:'Consulta Ingas',
        id_store:'id_concepto_ingas',
        constructor: function(config) {
            this.tbarItems = ['-',
                this.cmbGestion,'-'
            ];
            Phx.vista.ConsultaConceptoIngas.superclass.constructor.call(this,config);
            this.tbar.items.items[1].menu.items.items.splice(1,1);
            this.tbar.items.items[1].text = 'Exportar CSV';

            this.addButton('exportar',{
                grupo: [0,1,2,3,4],
                text: 'Exportar PDF',
                iconCls: 'bfolder',
                disabled: false,
                handler: this.exportarPDF,
                tooltip: '<b>Permite generar reporte PDF.</b>',
                scope:this
            });

            this.init();
            this.iniciarEventos();


        },
        
        exportarPDF: function () {
            Phx.CP.loadingShow();
            Ext.Ajax.request({
                url:'../../sis_presupuestos/control/ConsultasIngas/exportarPDF',
                params:{id_gestion: this.cmbGestion.getValue()},
                success:function (resp) {
                    var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
                    Phx.CP.loadingHide();
                    window.open('../../../lib/lib_control/Intermediario.php?r='+reg.ROOT.detalle.archivo_generado+'&t='+new Date().toLocaleTimeString());
                },
                failure: this.conexionFailure,
                timeout: this.timeout,
                scope: this
            });
        },

        Atributos:[
            {
                //configuracion del componente
                config: {
                    labelSeparator: '',
                    inputType: 'hidden',
                    name: 'id_concepto_ingas'
                },
                type: 'Field',
                form: true,
                id_grupo:1
            },
            {
                config:{
                    name: 'desc_ingas',
                    fieldLabel: 'Concepto Gastos',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 300,
                    maxLength:500,
                    renderer: function(value, p, record){
                        return String.format('<b style="color:green;">{0}</b>', record.data['desc_ingas']);
                    }
                },
                type:'TextArea',
                filters:{pfiltro:'conig.desc_ingas',type:'string'},
                id_grupo:1,
                grid:true,
                form:false,
                bottom_filter : true
            },
            {
                config:{
                    name:'tipo',
                    fieldLabel:'Tipo',
                    allowBlank:false,
                    emptyText:'Tipo...',
                    typeAhead: true,
                    triggerAction: 'all',
                    lazyRender:true,
                    mode: 'local',
                    valueField: 'estilo',
                    gwidth: 70,
                    store:['Bien','Servicio']
                },
                type:'ComboBox',
                id_grupo:0,
                filters:{
                    type: 'list',
                    pfiltro:'conig.tipo',
                    options: ['Bien','Servicio'],
                },
                form:false,
                grid:true,
                bottom_filter : true
            },
            {
                config:{
                    name: 'desc_partida',
                    fieldLabel: 'Partida',
                    allowBlank: true,
                    width: '100%',
                    gwidth: 300,
                    renderer: function(value, p, record){
                        return String.format('<b style="color:green;">{0}</b>', record.data['desc_partida']);
                    }
                },
                type: 'TextField',
                filters: {pfiltro:'tpar.codigo#tpar.nombre_partida', type:'string'},
                id_grupo: 0,
                form:false,
                grid:true,
                bottom_filter : true
            },
            {
                config:{
                    name:'caja_chica',
                    fieldLabel:'Caja Chica',
                    allowBlank: true,
                    anchor: '70%',
                    gwidth: 70,

                    renderer: function (value, p, record, rowIndex, colIndex) {
                        /*if(value != null || value != undefined) {
                            var cadena = value.split(',');*/

                            if (/*cadena.includes('caja_chica')*/value!='X') {
                                var checked = 'checked';
                            }
                        //}
                        return String.format('<div style="vertical-align:middle;text-align:center;"><input style="height:20px;width:20px;" type="checkbox"  {0}></div>', checked);
                    }
                },
                type:'Checkbox',//ComboRec
                id_grupo: 0,
                grid: true,
                form:true
            },
            {
                config:{
                    name:'adquisiciones',
                    fieldLabel:'Adquisiciones',
                    allowBlank: true,
                    anchor: '70%',
                    gwidth: 80,

                    renderer: function (value, p, record, rowIndex, colIndex) {
                        /*if(value != null || value != undefined) {
                            var cadena = value.split(',');*/
                            if (/*cadena.includes('adquisiciones')*/value!='X') {
                                var checked = 'checked';
                            }
                        //}
                        return String.format('<div style="vertical-align:middle;text-align:center;"><input style="height:20px;width:20px;" type="checkbox"  {0}></div>', checked);
                    }
                },
                type:'Checkbox',//ComboRec
                id_grupo: 0,
                grid: true,
                form:true
            },
            {
                config:{
                    name:'pago_directo',
                    fieldLabel:'Pago Directo',
                    allowBlank: true,
                    anchor: '70%',
                    gwidth: 75,

                    renderer: function (value, p, record, rowIndex, colIndex) {
                        /*if(value != null || value != undefined) {
                            var cadena = value.split(',');*/
                            if (/*cadena.includes('pago_directo')*/value!='X') {
                                var checked = 'checked';
                            }
                        //}
                        return String.format('<div style="vertical-align:middle;text-align:center;"><input style="height:20px;width:20px;" type="checkbox"  {0}></div>', checked);
                    }
                },
                type:'Checkbox',//ComboRec
                id_grupo: 0,
                grid: true,
                form:true
            },
            {
                config:{
                    name:'fondo_avance',
                    fieldLabel:'Fondo Avance',
                    allowBlank: true,
                    anchor: '70%',
                    gwidth: 85,
                    renderer: function (value, p, record, rowIndex, colIndex) {
                        /*if(value != null || value != undefined) {
                            var cadena = value.split(',');*/
                            if (/*cadena.includes('fondo_avance')*/value!='X') {
                                var checked = 'checked';
                            }
                        //}
                        return String.format('<div style="vertical-align:middle;text-align:center;"><input style="height:20px;width:20px;" type="checkbox"  {0}></div>', checked);
                    }
                },
                type:'Checkbox',//ComboRec
                id_grupo: 0,
                grid: true,
                form:true
            },
            {
                config:{
                    name:'pago_unico',
                    fieldLabel:'Pago Unico',
                    allowBlank: true,
                    anchor: '70%',
                    gwidth: 80,

                    renderer: function (value, p, record, rowIndex, colIndex) {
                        /*if(value != null || value != undefined) {
                            var cadena = value.split(',');*/
                            if (value!='X'/*cadena.includes('pago_unico')*/) {
                                var checked = 'checked';
                            }
                        //}
                        return String.format('<div style="vertical-align:middle;text-align:center;"><input style="height:20px;width:20px;" type="checkbox"  {0}></div>', checked);
                    }
                },
                type:'Checkbox',//ComboRec
                id_grupo: 0,
                grid: true,
                form:true
            },
            {
                config:{
                    name:'contrato',
                    fieldLabel:'Contrato',
                    allowBlank: true,
                    anchor: '70%',
                    gwidth: 60,

                    renderer: function (value, p, record, rowIndex, colIndex) {
                        /*if(value != null || value != undefined) {
                            var cadena = value.split(',');*/
                            if (value!='X'/*cadena.includes('contrato')*/) {
                                var checked = 'checked';
                            }
                        //}
                        return String.format('<div style="vertical-align:middle;text-align:center;"><input style="height:20px;width:20px;" type="checkbox"  {0}></div>', checked);
                    }
                },
                type:'Checkbox',//ComboRec
                id_grupo: 0,
                grid: true,
                form:true
            },
            {
                config:{
                    name:'especial',
                    fieldLabel:'Especial',
                    allowBlank: true,
                    anchor: '70%',
                    gwidth: 60,
                    editable :false,
                    renderer: function (value, p, record, rowIndex, colIndex) {
                        /*if(value != null || value != undefined) {
                            var cadena = value.split(',');*/
                            if (value!='X'/*cadena.includes('especial')*/) {
                                var checked = 'checked';
                            }
                        //}
                        return String.format('<div style="vertical-align:middle;text-align:center;"><input style="height:20px;width:20px;" type="checkbox"  {0}></div>', checked);
                    }
                },
                type:'Checkbox',//ComboRec
                id_grupo: 0,
                grid: true,
                form:true
            },
            {
                config:{
                    name: 'sw_autorizacion',
                    fieldLabel: 'Autorizaciones',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 400,
                    maxLength:500
                },
                type:'TextField',
                filters: {pfiltro:'conig.sw_autorizacion', type:'string'},

                id_grupo:0,
                form:false,
                grid:true,
                bottom_filter : true
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
                filters:{pfiltro:'conig.estado_reg',type:'string'},
                id_grupo:0,
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
                type:'NumberField',
                filters:{pfiltro:'usu1.cuenta',type:'string'},
                id_grupo:0,
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
                filters:{pfiltro:'conig.fecha_reg',type:'date'},
                id_grupo:0,
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
                filters:{pfiltro:'conig.fecha_mod',type:'date'},
                id_grupo:0,
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
                type:'NumberField',
                filters:{pfiltro:'usu2.cuenta',type:'string'},
                id_grupo:0,
                grid:true,
                form:false
            }
        ],
        arrayDefaultColumHidden:[
            'estado_reg','usr_reg',
            'fecha_reg','fecha_mod','usr_mod'
        ],
        fields: [
            {name:'id_concepto_ingas', type: 'numeric'},
            {name:'desc_ingas', type: 'string'},
            {name:'tipo', type: 'string'},
            {name:'estado_reg', type: 'string'},
            {name:'id_usuario_reg', type: 'numeric'},
            {name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
            {name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
            {name:'id_usuario_mod', type: 'numeric'},
            {name:'usr_reg', type: 'string'},
            {name:'usr_mod', type: 'string'},
            'sw_autorizacion',
            'id_cat_concepto',
            'desc_cat_concepto',
            'desc_partida',
            'caja_chica',
            'adquisiciones',
            'pago_directo',
            'fondo_avance',
            'pago_unico',
            'contrato',
            'especial'

        ],
        sortInfo:{
            field: 'desc_ingas',
            direction: 'ASC'
        },
        iniciarEventos:function() {
            //Se carga el campo gestion con la gestion actual.
            Ext.Ajax.request({
                url: '../../sis_parametros/control/Gestion/obtenerGestionByFecha',
                params: {fecha: new Date()},
                success: function (resp) {
                    var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
                    if (!reg.ROOT.error) {
                        this.cmbGestion.setValue(reg.ROOT.datos.id_gestion);
                        this.cmbGestion.setRawValue(reg.ROOT.datos.anho);
                        this.store.baseParams.id_gestion = reg.ROOT.datos.id_gestion;
                        this.load({params:{start:0, limit:50}});
                    } else {

                        alert('Ocurrio un error al obtener la Gestión')
                    }
                },
                failure: this.conexionFailure,
                timeout: this.timeout,
                scope: this
            });

            this.cmbGestion.on('select', function (combo, record, index) {
                this.store.baseParams.id_gestion = combo.value;
                this.load({params:{start:0, limit:50}});
            },this);


        },

        cmbGestion: new Ext.form.ComboBox({
            name: 'gestion',
            fieldLabel: 'Gestion',
            allowBlank: true,
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
            width:80
        })
    });
</script>
