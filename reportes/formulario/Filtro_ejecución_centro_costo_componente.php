<?php
/**
 *@package pXP
 *@file    GenerarLibroBancos.php
 *@author  Gonzalo Sarmiento Sejas
 *@date    01-12-2014
 *@description Archivo con la interfaz para generaci�n de reporte

HISTORIAL DE MODIFICACIONES:


ISSUE            FECHA:          AUTOR       DESCRIPCION
#PRES-8          13/11/2020      JJA         Reporte partida ejecucion con adquisiciones
 */
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.Filtro_ejecución_centro_costo_componente = Ext.extend(Phx.frmInterfaz, {

        Atributos : [

            {
                config:{
                    name:'id_gestion',
                    fieldLabel:'Gestión',
                    allowBlank:true,
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
            {
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
                        remoteSort: true,
                        baseParams:{par_filtro:'ceco_techo'}
                    }),
                    valueField: 'id_tipo_cc_techo',
                    displayField: 'ceco_techo',
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
            {
                config:{
                    name:'periodo',
                    fieldLabel:'Periodo',
                    allowBlank:true,
                    emptyText:'...',
                    typeAhead: true,
                    triggerAction: 'all',
                    lazyRender:true,
                    mode: 'local',
                    width: 222,
                    valueField: 'periodo',                  
                    store:new Ext.data.ArrayStore({
                        fields: ['variable', 'valor'],
                        data : [ 
                                    ['1','Enero'],
                                    ['2','Febrero'],
                                    ['3','Marzo'],
                                    ['4','Abril'],
                                    ['5','Mayo'],
                                    ['6','Junio'],
                                    ['7','Julio'],
                                    ['8','Agosto'],
                                    ['9','Septiembre'],
                                    ['10','Octubre'],
                                    ['11','Noviembre'],
                                    ['12','Diciembre']
                                ]
                    }),
                    valueField: 'variable',
                    displayField: 'valor'
                },
                type:'ComboBox',
                form:true
            }

        ],


        topBar : true,
        botones : false,
        labelSubmit : 'Generar',
        tooltipSubmit : '<b>Ejecución de proyecto</b>',

        constructor : function(config) {
            Phx.vista.Filtro_ejecución_centro_costo_componente.superclass.constructor.call(this, config);
            this.init();
            this.iniciarEventos();
        },

        iniciarEventos:function(){

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

        ActSave:'../../sis_presupuestos/control/PartidaEjecucion/Ejecucion_centro_costo_componente', 
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