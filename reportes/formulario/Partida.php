<?php
/**
 *@package pXP
 *@file    GenerarLibroBancos.php
 *@author  Gonzalo Sarmiento Sejas
 *@date    01-12-2014
 *@description Archivo con la interfaz para generaci�n de reporte

HISTORIAL DE MODIFICACIONES:


ISSUE            FECHA:          AUTOR       DESCRIPCION
#46 ENDETR      06/08/2020       JJA            Reporte partida en presupuesto
 */
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.Partida = Ext.extend(Phx.frmInterfaz, {

        Atributos : [

            {
                config:{
                    name:'id_gestion',
                    fieldLabel:'Gestión',
                    allowBlank:false,
                    emptyText:'Gestión...',
                    store: new Ext.data.JsonStore({
                        url: '../../sis_parametros/control/Gestion/listarGestion',
                        id: 'id_gestion',
                        root: 'datos',
                        sortInfo:{
                            field: 'gestion',
                            direction: 'DESC'
                        },
                        totalProperty: 'total',
                        fields: ['id_gestion','gestion','moneda','codigo_moneda'],
                        remoteSort: true,
                        baseParams:{par_filtro:'gestion'}
                    }),
                    valueField: 'id_gestion',
                    displayField: 'gestion',
                    hiddenName: 'id_gestion',
                    forceSelection:true,
                    typeAhead: false,
                    triggerAction: 'all',
                    lazyRender:true,
                    mode:'remote',
                    pageSize:10,
                    queryDelay:1000,
                    listWidth:600,
                    resizable:true,
                    anchor:'100%'
                },
                type:'ComboBox',
                id_grupo:0,
                filters:{
                    pfiltro:'gestion',
                    type:'string'
                },
                grid:true,
                form:true
            },

        ],


        //ActSave : '../../sis_contabilidad/control/TsLibroBancos/reporteLibroBancos',

        topBar : true,
        botones : false,
        labelSubmit : 'Generar',
        tooltipSubmit : '<b>Partida</b>',

        constructor : function(config) {
            Phx.vista.Partida.superclass.constructor.call(this, config);
            this.init();
            /*this.mostrarComponente(this.Cmp.fecha_fin);
            this.mostrarComponente(this.Cmp.fecha_ini);*/
            this.iniciarEventos();
        },

        iniciarEventos:function(){
            /*this.mostrarComponente(this.Cmp.fecha_fin);
            this.mostrarComponente(this.Cmp.fecha_ini);*/
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
                columnWidth : '500px',
                items : [],
                id_grupo : 0,
                collapsible : true
            }]
        }],

        //ActSave:'../../sis_contabilidad/control/DocCompraVentaForm/reporteComparacion',
        ActSave:'../../sis_presupuestos/control/PartidaEjecucion/ReportePartidaCentroCosto',
        successSave :function(resp){

            Phx.CP.loadingHide();
            var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
            if (reg.ROOT.error) {
                alert('error al procesar');
                return
            }
            var nomRep = reg.ROOT.detalle.archivo_generado;
            if(Phx.CP.config_ini.x==1){
                nomRep = Phx.CP.CRIPT.Encriptar(nomRep);
            }

            window.open('../../../reportes_generados/'+nomRep+'?t='+new Date().toLocaleTimeString())
        }
    })
</script>