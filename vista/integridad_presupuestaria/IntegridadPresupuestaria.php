<?php
/**
 *@package pXP
 *@file IntegridadPresupuestaria.php
 *@author  (Miguel Mamani)
 *@date 19/12/2108
 *@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
 * HISTORIAL DE MODIFICACIONES:
 * #11 ETR		  12/02/2019		   MMV Kplian	Reporte Integridad presupuestaria
 *
 */

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.IntegridadPresupuestaria = Ext.extend(Phx.frmInterfaz, {
        Atributos : [
            {
                config:{
                    name : 'id_gestion',
                    origen : 'GESTION',
                    fieldLabel : 'Gestion',
                    gdisplayField: 'desc_gestion',
                    allowBlank : false,
                    width: 150
                },
                type : 'ComboRec',
                id_grupo : 0,
                form : true
            },
            {
                config:{
                    name : 'tipo_filtro',
                    fieldLabel : 'Filtros',
                    items: [
                        {boxLabel: 'Saldo (+)', name: 'tipo_filtro', inputValue: 'positivo', checked: true},
                        {boxLabel: 'Saldo (-)', name: 'tipo_filtro', inputValue: 'negativo'}
                    ]


                },
                type : 'RadioGroupField',
                id_grupo : 0,
                form : true
            }

        ],
        topBar : true,
        botones : false,
        labelSubmit : 'Generar',
        tooltipSubmit : '<b>Reporte Proyectoa</b>',
        constructor : function(config) {
            Phx.vista.IntegridadPresupuestaria.superclass.constructor.call(this, config);
            this.init();
            this.iniciarEventos();
        },
        tipo : 'reporte',
        clsSubmit : 'bprint',

        Grupos : [{
            layout : 'column',
            items : [{
                xtype : 'fieldset',
                layout : 'form',
                border : true,
                title : 'Datos para el reporte',
                bodyStyle : 'padding:0 10px 0;',
                columnWidth : '800px',
                items : [],
                id_grupo : 0,
                collapsible : true
            }]
        }],

        ActSave:'../../sis_presupuestos/control/PartidaEjecucion/IntegridadPresupuestaria',
        iniciarEventos:function(){
            this.Cmp.id_gestion.on('select', function(cmb, rec, ind){
                console.log(rec.data.id_gestion);

            },this);
        },
        agregarArgsExtraSubmit: function() {
            this.argumentExtraSubmit.id_gestions = this.Cmp.id_gestion.getRawValue();
        }
    })
</script>




