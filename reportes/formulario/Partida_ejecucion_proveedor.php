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
#45 ENDETR      26/07/2020       JJA             Agregado de filtros en el reporte de Ejecución de proyectos
#ETR-1599     03/1/2020    JJA       Agregado de filtros en el reporte de Ejecución de proyectos
 */
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.Partida_ejecucion_proveedor = Ext.extend(Phx.frmInterfaz, {

        Atributos : [

            {//#45
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
                        // turn on remote sorting
                        remoteSort: true,
                        baseParams:{par_filtro:'gestion'}
                    }),
                    valueField: 'id_gestion',
                    displayField: 'gestion',
                    //tpl:'<tpl for="."><div class="x-combo-list-item"><p><b>{nro_cuenta}</b></p><p>{denominacion}</p></div></tpl>',
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
            {//#45
                config:{
                    name:'id_tipo_cc_techo',
                    fieldLabel:'Ceco techo',
                    allowBlank:true,
                    emptyText:'Ceco techo...',
                    store: new Ext.data.JsonStore({
                        url: '../../sis_presupuestos/control/PartidaEjecucion/listarCecoTecho',
                        id: 'id_tipo_cc_techo',
                        root: 'datos',
                        sortInfo:{
                            field: 'ceco_techo',
                            direction: 'DESC'
                        },
                        totalProperty: 'total',
                        fields: ['id_tipo_cc_techo','ceco_techo'],
                        // turn on remote sorting
                        remoteSort: true,
                        baseParams:{par_filtro:'ceco_techo'}
                    }),
                    valueField: 'id_tipo_cc_techo',
                    displayField: 'ceco_techo',
                    //tpl:'<tpl for="."><div class="x-combo-list-item"><p><b>{nro_cuenta}</b></p><p>{denominacion}</p></div></tpl>',
                    hiddenName: 'id_tipo_cc_techo',
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
                    pfiltro:'ct.ceco_techo',
                    type:'string'
                },
                grid:true,
                form:true
            },
            {//#45
                config:{
                    name:'origen',
                    fieldLabel:'Origen',
                    allowBlank:true,
                    emptyText:'...',
                    typeAhead: true,
                    triggerAction: 'all',
                    lazyRender:true,
                    mode: 'local',
                    width: 222,
                    valueField: 'origen',                  
                    store:new Ext.data.ArrayStore({
                        fields: ['variable', 'valor'],
                        data : [ 
                                    ['ejecucion_proyectos','Ejecucion proyectos '],
                                    ['ejecucion_proyectos_con_iva','Ejecucion proyectos con iva'],
                                    ['ejecucion_comprometido_proyectos','Ejecucion y comprometido proyectos']
                                   
                                ]
                    }),
                    valueField: 'variable',
                    displayField: 'valor'
                },
                type:'ComboBox',
                form:true
            },
            {
                config:{
                    name: 'fecha_ini',
                    fieldLabel: 'Fecha Inicio',
                    allowBlank: true,//#45
                    anchor: '100%', //#45
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
                    allowBlank: true,//#45
                    anchor: '100%',//#45
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
        ActSave:'../../sis_presupuestos/control/PartidaEjecucion/ReporteEjecucionProyecto', //#ETR-1599
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