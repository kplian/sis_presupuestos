<?php
/**
 *@package pXP
 *@file    GenerarLibroBancos.php
 *@author  Gonzalo Sarmiento Sejas
 *@date    01-12-2014
 *@description Archivo con la interfaz para generaci�n de reporte

HISTORIAL DE MODIFICACIONES:


ISSUE            FECHA:          AUTOR       DESCRIPCION
  #PRES-6  ENDETR      28/09/2020       JJA            Reporte formulacion presupuestaria
 */
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.Filtro_memoria_calculo = Ext.extend(Phx.frmInterfaz, {

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
                    name:'id_tipo_cc',
                    qtip: 'Tipo de centro de costos, cada tipo solo puede tener un centro por gestión',                 
                    origen:'TIPOCC',
                    fieldLabel:'Tipo Centro',
                    gdisplayField: 'desc_tipo_cc',
                    url:  '../../sis_parametros/control/TipoCc/listarTipoCcAll',
                    baseParams: {movimiento:''},                    
                    allowBlank:false,
                    width: 250 
                    
                },
            type:'ComboRec',
            id_grupo:0,
            filters:{pfiltro:'vcc.codigo_tcc#vcc.descripcion_tcc',type:'string'},
            grid:true,
            form:true
            },
            {
                config: {
                    name: 'id_partida',
                    fieldLabel: 'Excluir partida ',
                    allowBlank: true,
                    emptyText: 'Partida...',
                    blankText: 'Debe seleccionar una partida',
                    store: new Ext.data.JsonStore({
                        url: '../../sis_presupuestos/control/PartidaEjecucion/listarPartidaPresupuestaria',
                        //id: 'id_competencia_nivel',
                        id: 'id_partida',
                        root: 'datos',
                        sortInfo: {
                            field: 'p.id_partida,p.partida,codigo,nombre_partida',
                            //field: 'competencia_nivel',
                            direction: 'ASC'
                        },
                        totalProperty: 'total',
                        fields: ['id_partida', 'partida','codigo','nombre_partida'],
                        remoteSort: true,
                        baseParams: {par_filtro: 'codigo#nombre_partida'}
                    }),
                    valueField: 'id_partida',
                    displayField: 'partida',
                    //tpl: '<tpl for=".">  <div class="x-combo-list-item" >  <div class="awesomecombo-item {checked}"> <b>{tipo} </b> </div> <p>{competencia} </p> </div> </tpl>',
                    tpl: '<tpl for=".">  <div class="x-combo-list-item" >  <div class="awesomecombo-item {checked}">{partida} </div>  </div> </tpl>',
                    gdisplayField: 'partida',
                    hiddenName: 'id_partida',
                    forceSelection: true,
                    typeAhead: false,
                    triggerAction: 'all',
                    lazyRender: true,
                    mode: 'remote',
                    pageSize: 300,
                    queryDelay: 1000,
                    anchor: '110%',
                    gwidth: 180,
                    minChars: 2,
                    enableMultiSelect: true,
                    /*renderer: function (value, p, record) {
                        return String.format('{0}', (record.data['desc_competencia']) ? record.data['desc_competencia'] : '');
                    }*/
                },
                type: 'AwesomeCombo',
                id_grupo: 0,
                filters: {pfiltro: 'partida', type: 'string'},
                grid: true,
                form: true
            },
            { 
                config:{
                    name:'tipo_formulacion',
                    fieldLabel:'Formulación',
                    allowBlank:false,
                    emptyText:'...',
                    typeAhead: true,
                    triggerAction: 'all',
                    lazyRender:true,
                    mode: 'local',
                    width: 250,
                    valueField: 'tipo_formulacion',                   
                    store:new Ext.data.ArrayStore({
                        fields: ['variable', 'valor'],
                        data : [ 
                                    ['ratp','Ante Proyecto'],
                                    ['ra','Aprobado'],
                                    ['rv','Vigente'],
                                ]
                    }),
                    valueField: 'variable',
                    displayField: 'valor',

                    enableMultiSelect: false,
                },
                type: 'ComboBox',
                form:true
            },
            {
            config:{
                name:'tipo_reporte',
                fieldLabel:'Tipo de reporte',
                allowBlank:false,
                emptyText:'...',
                typeAhead: true,
                triggerAction: 'all',
                lazyRender:true,
                mode: 'local',
                width: 250,
                valueField: 'tipo_reporte',                  
                store:new Ext.data.ArrayStore({
                    fields: ['variable', 'valor'],
                    data : [ 
                               
                                 ['agr','Agrupado '],
                                ['det','Detallado']
                               
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
                name:'periodicidad',
                fieldLabel:'Mensualizado',
                allowBlank:false,
                emptyText:'...',
                typeAhead: true,
                triggerAction: 'all',
                lazyRender:true,
                mode: 'local',
                width: 250,
                valueField: 'periodicidad',                  
                store:new Ext.data.ArrayStore({
                    fields: ['variable', 'valor'],
                    data : [ 
                                ['si','Si'],
                                ['no','No']
                               
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
                    name:'tipo_partida',
                    fieldLabel:'Tipo Partida',
                    allowBlank:false,
                    emptyText:'...',
                    typeAhead: true,
                    triggerAction: 'all',
                    lazyRender:true,
                    mode: 'local',
                    width: 250,
                    valueField: 'tipo_partida',                   
                    store:new Ext.data.ArrayStore({
                        fields: ['variable', 'valor'],
                        data : [ 
                                    ['tpg','Gasto'],
                                    ['tpr','Recurso'],
                                ]
                    }),
                    valueField: 'variable',
                    displayField: 'valor',

                    enableMultiSelect: false,
                },
                type: 'ComboBox',
                form:true
            },

            {
            config:{
                name:'exportar',
                fieldLabel:'Exportar',
                allowBlank:false,
                emptyText:'...',
                typeAhead: true,
                triggerAction: 'all',
                lazyRender:true,
                mode: 'local',
                width: 250,
                valueField: 'exportar',                  
                store:new Ext.data.ArrayStore({
                    fields: ['variable', 'valor'],
                    data : [ 
                                ['xls','Excel '],
                                ['pdf','Pdf']
                               
                            ]
                }),
                valueField: 'variable',
                displayField: 'valor'
            },
            type:'ComboBox',
            form:true
        }

        ],


        //ActSave : '../../sis_contabilidad/control/TsLibroBancos/reporteLibroBancos',

        topBar : true,
        botones : false,
        labelSubmit : 'Generar',
        tooltipSubmit : '<b>Ejecución de proyecto</b>',

        constructor : function(config) {
            Phx.vista.Filtro_memoria_calculo.superclass.constructor.call(this, config);
            this.init();
            this.iniciarEventos();
        },

        iniciarEventos:function(){
            this.Cmp.id_gestion.on('select',function(c,r,n){

                console.log("ver gestion ",c.value);
                this.Cmp.id_partida.reset();
                this.Cmp.id_partida.store.baseParams.id_gestion = c.value;
                this.Cmp.id_partida.modificado=true;


            },this);
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
        ActSave:'../../sis_presupuestos/control/PartidaEjecucion/ReporteFormulacion',
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
        },
        agregarArgsExtraSubmit: function() {
            //Phx.vista.Filtro_memoria_calculo.superclass.agregarArgsExtraSubmit.call(this);
            console.log("idssss ",this.Cmp.id_tipo_cc.value);
            this.argumentExtraSubmit.gestion = this.Cmp.id_gestion.getRawValue();
            var bandera=0;
            for (var i = 0; i < parseInt(this.Cmp.id_tipo_cc.store.data.items.length); i++) {
                if(this.Cmp.id_tipo_cc.store.data.items[i].data.id_tipo_cc == this.Cmp.id_tipo_cc.value && bandera==0){
                  bandera=1;
                  this.argumentExtraSubmit.ceco = this.Cmp.id_tipo_cc.store.data.items[i].data.codigo+" - "+this.Cmp.id_tipo_cc.store.data.items[i].data.descripcion;
                  //this.argumentExtraSubmit.gestion = this.Cmp.id_gestion.getRawValue();
                  //console.log("for descripcion",this.Cmp.id_tipo_cc.store.data.items[i].data.descripcion);
                  //console.log("for id_tipo_cc",this.Cmp.id_tipo_cc.store.data.items[i].data.id_tipo_cc+" - "+this.Cmp.id_tipo_cc.store.data.items[i].data.descripcion);
                }
                //console.log("for recorre",this.Cmp.id_tipo_cc.store.data.items[0].data.descripcion);
            }
            //console.log("variable  sotore de jonas gay",this.Cmp.id_tipo_cc.store.data.items.length);
            //console.log("variable  descripcion de jonas gay",this.Cmp.id_tipo_cc.store.data.items[0].data.descripcion);
            //console.log("variable codigo  de jonas gay",this.Cmp.id_tipo_cc.store.data.items[0].data.codigo);
            //lastSelectionText
        },
    })
</script>