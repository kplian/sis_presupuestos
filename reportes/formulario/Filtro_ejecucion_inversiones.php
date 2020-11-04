<?php
/**
 *@package pXP
 *@file    GenerarLibroBancos.php
 *@author  Gonzalo Sarmiento Sejas
 *@date    01-12-2014
 *@description Archivo con la interfaz para generaci�n de reporte

HISTORIAL DE MODIFICACIONES:


ISSUE                 FECHA:          AUTOR       DESCRIPCION
#PRES-7  ENDETR      29/09/2020       JJA         Reporte ejecucion inversion
 */
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.Filtro_ejecucion_inversiones = Ext.extend(Phx.frmInterfaz, {

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

            {
				config:{
					name:'origen',
					fieldLabel:'Origen',
					allowBlank:false,
					emptyText:'...',
					typeAhead: true,
					triggerAction: 'all',
					lazyRender:true,
					mode: 'local',
                    width: 251,
					valueField: 'origen',					
					store:new Ext.data.ArrayStore({
						fields: ['variable', 'valor'],
						data : [ 
									['ejecucion','Ejecución'],
                                    ['comprometido','Comprometido'],
									['iva','IVA'], 
									['inflacion','Inflación']
								]
					}),
					valueField: 'variable',
					displayField: 'valor',

					 enableMultiSelect: true,
				},
				type: 'AwesomeCombo',
				form:true
			}


        ],


        //ActSave : '../../sis_contabilidad/control/TsLibroBancos/reporteLibroBancos',

        topBar : true,
        botones : false,
        labelSubmit : 'Generar',
        tooltipSubmit : '<b>Ejecución de proyecto</b>',

        constructor : function(config) {
            Phx.vista.Filtro_ejecucion_inversiones.superclass.constructor.call(this, config);
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

        //ActSave:'../../sis_contabilidad/control/DocCompraVentaForm/reporteComparacion',
        ActSave:'../../sis_presupuestos/control/PartidaEjecucion/ReporteEjecucionInversion',
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