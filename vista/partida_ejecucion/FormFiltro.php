<?php
/**
 *@package pXP
 *@file    FormFiltro.php
 *@author  Grover Velasquez Colque
 *@date    30-10-2016
 *@description permite filtrar varios campos antes de mostrar el contenido de una grilla
 */
header("content-type: text/javascript; charset=UTF-8");
?>

<script>
    Phx.vista.FormFiltro=Ext.extend(Phx.frmInterfaz,{
        constructor:function(config)
        {
            this.panelResumen = new Ext.Panel({html:''});
            this.Grupos = [{

                xtype: 'fieldset',
                border: false,
                autoScroll: true,
                layout: 'form',
                items: [],
                id_grupo: 0

            },
                this.panelResumen
            ];

            Phx.vista.FormFiltro.superclass.constructor.call(this,config);
            this.init();
            this.iniciarEventos();



        },

        Atributos:[
            {
                config:{
                    name : 'id_gestion',
                    origen : 'GESTION',
                    fieldLabel : 'Gestion',
                    allowBlank : false,
                    width: 150
                },
                type : 'ComboRec',
                id_grupo : 0,
                form : true
            },
            {
                config:{
                    name: 'id_centro_costo',
                    fieldLabel: 'Presupuesto',
                    allowBlank: true,
                    tinit: false,
                    origen: 'CENTROCOSTO',
                    gdisplayField: 'desc_centro_costo',
                    width: 150
                },
                type: 'ComboRec',
                id_grupo: 0,
                form: true
            },
            {
                config:{
                    sysorigen: 'sis_presupuestos',
                    name: 'id_partida',
                    origen: 'PARTIDA',
                    allowBlank: true,
                    fieldLabel: 'Partida',
                    width: 150
                },
                type:'ComboRec',
                id_grupo:0,
                form:true
            },

            {
                config: {
                    name: 'nro_tramite',
                    allowBlank: true,
                    fieldLabel: 'Nro. de Trámite',
                    width: 150
                },
                type: 'Field',
                id_grupo: 0,
                form: true
            },
            {
                config:{
                    name: 'desde',
                    fieldLabel: 'Desde',
                    allowBlank: true,
                    format: 'd/m/Y',
                    width: 150
                },
                type: 'DateField',
                id_grupo: 0,
                form: true
            },
            {
                config:{
                    name: 'hasta',
                    fieldLabel: 'Hasta',
                    allowBlank: true,
                    format: 'd/m/Y',
                    width: 150
                },
                type: 'DateField',
                id_grupo: 0,
                form: true
            }

        ],
        labelSubmit: '<i class="fa fa-check"></i> Aplicar Filtro',
        east: {
            url: '../../../sis_presupuestos/vista/partida_ejecucion/PartidaEjecucion.php',
            title: 'Detalle Ejecucion',
            width: '70%',
            cls: 'PartidaEjecucion'
        },
         /*south: {
         url: '../../../sis_presupuestos/vista/partida_ejecucion/PartidaEjecucion.php',
         title: 'Detalle Ejecucion',
         height: '70%',
         cls: 'PartidaEjecucion'
         },*/
         
        title: 'Filtros Para el Reporte de Ejecución',
        // Funcion guardar del formulario
        onSubmit: function(o) {
            var me = this;
            if (me.form.getForm().isValid()) {

                var parametros = me.getValForm()

                console.log('parametros ....', parametros);

                this.onEnablePanel(this.idContenedor + '-east', parametros)
            }
        },
        iniciarEventos:function(){
            this.Cmp.id_gestion.on('select', function(cmb, rec, ind){

                //Ext.apply(this.Cmp.id_cuenta.store.baseParams,{id_gestion: rec.data.id_gestion})
                Ext.apply(this.Cmp.id_partida.store.baseParams,{id_gestion: rec.data.id_gestion})
                Ext.apply(this.Cmp.id_centro_costo.store.baseParams,{id_gestion: rec.data.id_gestion})

            },this);
        }
    })
</script>