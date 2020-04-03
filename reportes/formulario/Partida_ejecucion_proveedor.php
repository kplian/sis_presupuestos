<?php
/**
 *@package pXP
 *@file    GenerarLibroBancos.php
 *@author  Gonzalo Sarmiento Sejas
 *@date    01-12-2014
 *@description Archivo con la interfaz para generaci�n de reporte

HISTORIAL DE MODIFICACIONES:


ISSUE            FECHA:          AUTOR       DESCRIPCION
#37 ENDETR      31/03/2020       JUAN            Reporte ejecución de proyectos con proveedor
 */
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.Partida_ejecucion_proveedor = Ext.extend(Phx.frmInterfaz, {

        Atributos : [

            {
                config:{
                    name: 'id_entidad',
                    fieldLabel: 'Entidad',
                    qtip: 'entidad a la que pertenese el depto, ',
                    allowBlank: false,
                    emptyText:'Entidad...',
                    store:new Ext.data.JsonStore(
                        {
                            url: '../../sis_parametros/control/Entidad/listarEntidad',
                            id: 'id_entidad',
                            root: 'datos',
                            sortInfo:{
                                field: 'nombre',
                                direction: 'ASC'
                            },
                            totalProperty: 'total',
                            fields: ['id_entidad','nit','nombre'],
                            // turn on remote sorting
                            remoteSort: true,
                            baseParams: { par_filtro:'nit#nombre' }
                        }),
                    valueField: 'id_entidad',
                    displayField: 'nombre',
                    gdisplayField:'desc_entidad',
                    hiddenName: 'id_entidad',
                    triggerAction: 'all',
                    lazyRender:true,
                    mode:'remote',
                    pageSize:50,
                    queryDelay:500,
                    anchor:"90%",
                    listWidth:280,
                    gwidth:150,
                    minChars:2,
                    renderer:function (value, p, record){return String.format('{0}', record.data['desc_entidad']);}

                },
                type:'ComboBox',
                filters:{pfiltro:'ENT.nombre',type:'string'},
                id_grupo:0,
                egrid: true,
                grid:true,
                form:true
            },

            {
                config:{
                    name: 'fecha_ini',
                    fieldLabel: 'Fecha Inicio',
                    allowBlank: false,
                    anchor: '80%',
                    gwidth: 100,
                    format: 'd/m/Y',
                    renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
                },
                type:'DateField',
                filters:{pfiltro:'fecha_ini',type:'date'},
                id_grupo:1,
                grid:true,
                form:true
            },
            {
                config:{
                    name: 'fecha_fin',
                    fieldLabel: 'Fecha Fin',
                    allowBlank: false,
                    anchor: '80%',
                    gwidth: 100,
                    format: 'd/m/Y',
                    renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
                },
                type:'DateField',
                filters:{pfiltro:'fecha_fin',type:'date'},
                id_grupo:1,
                grid:true,
                form:true
            }

        ],


        //ActSave : '../../sis_contabilidad/control/TsLibroBancos/reporteLibroBancos',

        topBar : true,
        botones : false,
        labelSubmit : 'Generar',
        tooltipSubmit : '<b>Ejecución de proyecto</b>',

        constructor : function(config) {
            Phx.vista.Partida_ejecucion_proveedor.superclass.constructor.call(this, config);
            this.init();
            this.mostrarComponente(this.Cmp.fecha_fin);
            this.mostrarComponente(this.Cmp.fecha_ini);
            this.iniciarEventos();
        },

        iniciarEventos:function(){
            this.mostrarComponente(this.Cmp.fecha_fin);
            this.mostrarComponente(this.Cmp.fecha_ini);
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
        ActSave:'../../sis_presupuestos/control/PartidaEjecucion/ReporteEjecucionProyecto',
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