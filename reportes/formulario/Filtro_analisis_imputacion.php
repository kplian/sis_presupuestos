<?php
/**
 *@package pXP
 *@file    FormFiltro.php
 *@author  Grover Velasquez Colque
 *@date    30-10-2016
 *@description permite filtrar varios campos antes de mostrar el contenido de una grilla

  ISSUE            FECHA:          AUTOR       DESCRIPCION
  #PRES-5  ENDETR  23/07/2020      JJA         Mejoras en reporte partida con centros de costo de presupuestos
 */
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.Filtro_analisis_imputacion=Ext.extend(Phx.frmInterfaz,{
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

            Phx.vista.Filtro_analisis_imputacion.superclass.constructor.call(this,config);
            this.init();
            this.iniciarEventos();
            console.log('-->'+this.Cmp.id_gestion.getValue());
            if(config.detalle){
            
                //cargar los valores para el filtro
                this.loadForm({data: config.detalle});
                var me = this;
                setTimeout(function(){
                    me.onSubmit()
                }, 1500);
                
            }
            this.maestro=config;

            this.getComponente('tipo_nodo').setValue('todos');

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
                    name:'tipo_nodo',
                    fieldLabel:'Tipo nodo',
                    allowBlank:true,
                    emptyText:'...',
                    typeAhead: true,
                    triggerAction: 'all',
                    lazyRender:true,
                    mode: 'local',
                    width: 150,
                    valueField: 'tipo_nodo',                    
                    store:new Ext.data.ArrayStore({
                        fields: ['variable', 'valor'],
                        data : [ 
                                    ['todos','todos'],
                                    ['transaccional','transaccional'],
                                    ['agrupador','agrupador']
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
                    name:'id_tipo_cc',
                    qtip: 'Tipo de centro de costos, cada tipo solo puede tener un centro por gestión',                 
                    origen:'TIPOCC',
                    fieldLabel:'Tipo Centro',
                    gdisplayField: 'desc_tipo_cc',
                    url:  '../../sis_parametros/control/TipoCc/listarTipoCcAll',
                    baseParams: {movimiento:''},                    
                    allowBlank:true,
                    width: 150 
                    
                },
            type:'ComboRec',
            id_grupo:0,
            filters:{pfiltro:'vcc.codigo_tcc#vcc.descripcion_tcc',type:'string'},
            grid:true,
            form:true
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
            url: '../../../sis_presupuestos/vista/partida_ejecucion/AnalisisImputacionTipoCentroCosto.php',
            title: 'Centro de costo',
            width: '70%',
            cls: 'AnalisisImputacionTipoCentroCosto'
        },
        
         
         
        title: 'Filtros Para el Reporte de Tipo centro de costo',
        // Funcion guardar del formulario
        onSubmit: function(o) {
            var me = this;
            if (me.form.getForm().isValid()) {
                var parametros = me.getValForm();
                this.onEnablePanel(this.idContenedor + '-east', parametros)
            }
        },
        iniciarEventos:function(){
            
            this.Cmp.id_gestion.on('select', function(cmb, rec, ind){
                console.log('-->'+rec.data.id_gestion);
                Ext.apply(this.Cmp.id_gestion.store.baseParams,{id_gestion: rec.data.id_gestion});
                //Ext.apply(this.Cmp.id_centro_costo.store.baseParams,{id_gestion: rec.data.id_gestion});
                
            },this);
        },
        //mp filtran el el combo partida de acuerdo a la gestion
        loadValoresIniciales: function () {     
            //console.log('manu',this.Cmp.id_gestion.getValue());
            //console.log('-->'+this.Cmp.id_gestion.getValue());
            //this.Cmp.id_partida.store.setBaseParam('id_gestion', this.Cmp.id_gestion.getValue());
            //this.Cmp.id_partida.modificado = true;    
            Phx.vista.Filtro_analisis_imputacion.superclass.loadValoresIniciales.call(this);
            //console.log('->'+this.maestro.id_gestion);
            //if(this.maestro.id_gestion!=''){
                //this.getComponente('id_partida').store.baseParams.id_gestion= this.maestro.id_gestion;
                //this.getComponente('id_partida').modificado=true; 
            //}         
            
        },
    
    })
</script>