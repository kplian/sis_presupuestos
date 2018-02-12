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
            
            if(config.detalle){
        	
				//cargar los valores para el filtro
				this.loadForm({data: config.detalle});
				var me = this;
				setTimeout(function(){
					me.onSubmit()
				}, 1500);
				
			}  



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
					name:'momento',
					fieldLabel:'Momento Presupuestario',
					allowBlank:true,
					emptyText:'...',
					typeAhead: true,
					triggerAction: 'all',
					lazyRender:true,
					mode: 'local',
                    width: 150,
					valueField: 'tipo_moneda',					
					store:new Ext.data.ArrayStore({
						fields: ['variable', 'valor'],
						data : [ 
									['formulado','formulado'],
									['comprometido','comprometido'],
									['ejecutado','ejecutado']
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
         
         
        title: 'Filtros Para el Reporte de Ejecución',
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
                Ext.apply(this.Cmp.id_partida.store.baseParams,{id_gestion: rec.data.id_gestion});
                Ext.apply(this.Cmp.id_centro_costo.store.baseParams,{id_gestion: rec.data.id_gestion});

            },this);
        }
    })
</script>