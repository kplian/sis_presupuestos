<?php
/**
 *@package pXP
 *@file    GenerarLibroBancos.php
 *@author  Gonzalo Sarmiento Sejas
 *@date    01-12-2014
 *@description Archivo con la interfaz para generaci�n de reporte

  #ETR-1815    ENDETR  18/11/2020     JJA     Reporte ejecucion Presupuestaria
 */
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.FormRepEjecucion = Ext.extend(Phx.frmInterfaz, {
		
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
            config:{
                name:'id_gestion',
                fieldLabel:'Gestión',
                allowBlank:false,//#ETR-1815 
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
	   				allowBlank:true,
	   				width: 150 
	   				
	      		},
   			type:'ComboRec',
   			id_grupo:0,
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
                width: 222,
                valueField: 'tipo_reporte',                  
                store:new Ext.data.ArrayStore({
                    fields: ['variable', 'valor'],
                    data : [ 
                                ['movimiento','Solo movimiento '],
                                ['todos','Todos']
                               
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
                fieldLabel:'Periodicidad',
                allowBlank:false,
                emptyText:'...',
                typeAhead: true,
                triggerAction: 'all',
                lazyRender:true,
                mode: 'local',
                width: 222,
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
		  },
		
		],
		
		
		title : 'Reporte Libro Compras Ventas IVA',		

		topBar : true,
		botones : false,
		labelSubmit : 'Generar',
		tooltipSubmit : '<b>Reporte Proyecto Presupeustario</b>',
		
		constructor : function(config) {
			Phx.vista.FormRepEjecucion.superclass.constructor.call(this, config);
			this.init();
			
			this.mostrarComponente(this.Cmp.id_tipo_cc);//#ETR-1815
						
			this.iniciarEventos();
		},
		iniciarEventos:function(){        
			
			this.Cmp.id_gestion.on('select',function(c,r,n){
				
					
					this.Cmp.id_tipo_cc.reset();
					this.Cmp.id_tipo_cc.modificado=true;
					
					
					
					this.Cmp.fecha_ini.setValue('01/01/'+r.data.gestion);
					this.Cmp.fecha_fin.setValue('31/12/'+r.data.gestion);
					
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
		
	//ActSave:'../../sis_presupuestos/control/Partida_ejecucion/reporteEjecucion',
	ActSave:'../../sis_presupuestos/control/PartidaEjecucion/reporteEjecucion',
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