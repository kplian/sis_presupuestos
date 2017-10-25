<?php
/**
 *@package pXP
 *@file    GenerarLibroBancos.php
 *@author  Gonzalo Sarmiento Sejas
 *@date    01-12-2014
 *@description Archivo con la interfaz para generaci�n de reporte
 */
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.FormRepEjecucionPorPartida = Ext.extend(Phx.frmInterfaz, {
		
		Atributos : [
		
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'concepto'
			},
			type:'Field',
			form:true 
		},
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'concepto2'
			},
			type:'Field',
			form:true 
		},
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'categoria'
			},
			type:'Field',
			form:true 
		},
		
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
            	name: 'tipo_pres',
				fieldLabel: 'Tipo',
				grupo: [0, 1, 2],
				allowBlank: false,
				emptyText:'Filtro...',
				store : new Ext.data.JsonStore({
							url:'../../sis_presupuestos/control/TipoPresupuesto/listarTipoPresupuesto',
							id : 'codigo',
							root: 'datos',
							sortInfo:{
									field: 'codigo',
									direction: 'ASC'
							},
							totalProperty: 'total',
							fields: ['codigo', 'nombre', 'movimiento'],
							remoteSort: true,
							baseParams: { par_filtro:'nombre' }
				}),
				valueField : 'codigo',
			    displayField : 'nombre',
			    hiddenName : 'codigo',
				enableMultiSelect : true,
				triggerAction : 'all',
				lazyRender : true,
				mode : 'remote',
				pageSize : 20,
				width : 150,
				anchor : '80%',
				listWidth : '280',
				resizable : true,
				minChars : 2
			},
            type:'AwesomeCombo',
            id_grupo:0,
            filters:{   
                        pfiltro:'gestion',
                        type:'string'
                    },
            form:true
        },
        
        {
   			config:{
   				sysorigen:'sis_presupuestos',
       		    name:'id_partida',
   				origen:'PARTIDA',
   				allowBlank:true,
   				fieldLabel:'Partida',
   				gdisplayField:'desc_partida',//mapea al store del grid
   				baseParams: {_adicionar:'si',sw_transaccional: 'movimiento', partida_tipo: 'presupuestaria'},
   				anchor: '100%',
   				listWidth: 350
       	     },
   			type:'ComboRec',
   			id_grupo:0,
   			form:true
	   	},
	   	
	   	{
			config:{
				name:'tipo_reporte',
				fieldLabel:'Filtrar por',
				typeAhead: true,
				allowBlank:false,
	    		triggerAction: 'all',
	    		emptyText:'Tipo...',
	    		selectOnFocus:true,
				mode:'local',
				store:new Ext.data.ArrayStore({
	        	fields: ['ID', 'valor'],
	        	data :	[
		        	        ['categoria','Categoría Programática'],	
							['tipo_cc','Tipo Centro Costo']
						]	        				
	    		}),
				valueField:'ID',
				displayField:'valor',
				width:250,			
				
			},
			type:'ComboBox',
			id_grupo:1,
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
   			form:true
	    },
		
		
		
		{
			config:{
				name: 'id_categoria_programatica',
				fieldLabel: 'Categoria Programatica',
				qtip: 'la categoria programatica permite la integración de reportes para sigma',
				allowBlank: false,
				emptyText : '...',
				store : new Ext.data.JsonStore({
							url:'../../sis_presupuestos/control/CategoriaProgramatica/listarCategoriaProgramatica',
							id : 'id_categoria_programatica',
							root: 'datos',
							sortInfo:{field: 'codigo_categoria',direction: 'ASC'},
							totalProperty: 'total',
							fields: ['codigo_categoria','id_categoria_programatica','descripcion'],
							remoteSort: true,
							baseParams:{par_filtro:'descripcion#codigo_categoria',_adicionar:'si'}
				}),
			   valueField: 'id_categoria_programatica',
			   displayField: 'codigo_categoria',
			   gdisplayField: 'codigo_categoria',
			   hiddenName: 'id_categoria_programatica',
			   forceSelection:true,
			   typeAhead: true,
			   triggerAction: 'all',
			   lazyRender:true,
			   mode:'remote',
			   pageSize:10,
			   queryDelay:1000,
			   width: 150,
			   listWidth: 280,
			   minChars:2,
			   tpl:'<tpl for="."><div class="x-combo-list-item"><p>{codigo_categoria}</p><p>{descripcion}</p> </div></tpl>'
			},
			type:'ComboBox',
			id_grupo:1,
			form:true
		},
		
		
		
	   	
		{
			config:{
				name:'formato_reporte',
				fieldLabel:'Formato del Reporte',
				typeAhead: true,
				allowBlank:false,
	    		triggerAction: 'all',
	    		emptyText:'Formato...',
	    		selectOnFocus:true,
				mode:'local',
				store:new Ext.data.ArrayStore({
	        	fields: ['ID', 'valor'],
	        	data :[ ['pdf','PDF'],	
						['csv','CSV']]	        				
	    		}),
				valueField:'ID',
				displayField:'valor',
				width:250,			
				
			},
			type:'ComboBox',
			id_grupo:1,
			form:true
		},
		{
				config:{
					name: 'fecha_ini',
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
					name: 'fecha_fin',
					fieldLabel: 'Hasta',
					allowBlank: true,
					format: 'd/m/Y',
					width: 150
				},
				type: 'DateField',
				id_grupo: 0,
				form: true
		  }],
		
		
		title : 'Reporte Libro Compras Ventas IVA',		
		ActSave : '../../sis_presupuestos/control/MemoriaCalculo/reporteMemoriaCalculo',
		
		topBar : true,
		botones : false,
		labelSubmit : 'Generar',
		tooltipSubmit : '<b>Reporte Proyecto Presupeustario</b>',
		
		constructor : function(config) {
			Phx.vista.FormRepEjecucionPorPartida.superclass.constructor.call(this, config);
			this.init();
			
			this.ocultarComponente(this.Cmp.id_tipo_cc);
			this.ocultarComponente(this.Cmp.id_categoria_programatica);
			
			this.iniciarEventos();
		},
		
		iniciarEventos:function(){        
			
			this.Cmp.id_gestion.on('select',function(c,r,n){
				
					this.Cmp.id_categoria_programatica.reset();
					this.Cmp.id_categoria_programatica.store.baseParams.id_gestion =c.value;				
					this.Cmp.id_categoria_programatica.modificado=true;
					
					this.Cmp.id_partida.reset();
					this.Cmp.id_partida.store.baseParams.id_gestion = c.value;				
					this.Cmp.id_partida.modificado=true;
					
					this.Cmp.fecha_ini.setValue('01/01/'+r.data.gestion);
					this.Cmp.fecha_fin.setValue('31/12/'+r.data.gestion);
					
				
				
			},this);
			
			this.Cmp.id_partida.on('select',function(c,r,n){
				 
				 if (r.data.nombre_partida == 'Todos'){
				 	this.Cmp.concepto.setValue('Todas');
				 }
				 else{
				 	this.Cmp.concepto.setValue('('+r.data.codigo +') '+r.data.nombre_partida);
				 }
				 
				
			},this);
			
			
			this.Cmp.tipo_reporte.on('select',function(combo, record, index){
				
				this.Cmp.id_categoria_programatica.reset();				
				this.Cmp.id_tipo_cc.reset();
				
				if(record.data.ID == 'categoria'){
					this.mostrarComponente(this.Cmp.id_categoria_programatica);					
					this.ocultarComponente(this.Cmp.id_tipo_cc);
				}
				
				if(record.data.ID == 'tipo_cc'){
					this.ocultarComponente(this.Cmp.id_categoria_programatica);
					this.mostrarComponente(this.Cmp.id_tipo_cc);
				}
				
				
			}, this);
			
			
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
		
	ActSave:'../../sis_presupuestos/control/PresupPartida/reporteEjecucionPorPartida',
	
	onSubmit: function(o, x, force){
		
		if(this.Cmp.tipo_reporte.getValue()=='categoria'){
			this.Cmp.categoria.setValue(this.Cmp.id_categoria_programatica.getRawValue());
		}
		
		if(this.Cmp.tipo_reporte.getValue()=='tipo_cc'){
			this.Cmp.categoria.setValue(this.Cmp.id_tipo_cc.getRawValue());
		}
		
		
		Phx.vista.FormRepEjecucionPorPartida.superclass.onSubmit.call(this,o, x, force);
	},
	
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
       
        if(this.Cmp.formato_reporte.getValue()=='pdf'){
        	window.open('../../../lib/lib_control/Intermediario.php?r='+nomRep+'&t='+new Date().toLocaleTimeString())
        }
        else{
        	window.open('../../../reportes_generados/'+nomRep+'?t='+new Date().toLocaleTimeString())
        }
       
	}
})
</script>