<?php
/**
*@package pXP
*@file ConceptoCta.php
*@author  Gonzalo Sarmiento Sejas 
*@date 18-02-2013 22:57:58
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.ConceptoCta=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		
		this.maestro=config.maestro;
		this.initButtons=[this.cmbGestion];
    	//llama al constructor de la clase padre
		Phx.vista.ConceptoCta.superclass.constructor.call(this,config);
		this.init();
		 //si la interface es pestanha este código es para iniciar 
		 this.cmbGestion.on('select',this.capturaFiltros,this);
		 
	      var dataPadre = Phx.CP.getPagina(this.idContenedorPadre).getSelectedData()
	      if(dataPadre){
	         this.onEnablePanel(this, dataPadre);
	      }
	      else
	      {
	         this.bloquearMenus();
	      }
	      
	     
		
		
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_concepto_cta'
			},
			type:'Field',
			form:true 
		},
		{
			config:{
				name: 'id_concepto_ingas',
				inputType:'hidden'
			},
			type:'Field',
			form:true
		},
        {
            config:{
                name: 'id_gestion',
                inputType:'hidden'
            },
            type:'Field',
            form:true
        },
		{
            config: {
                name: 'id_partida',
                fieldLabel: 'Partida',
                typeAhead: false,
                forceSelection: true,
                allowBlank: false,
                emptyText: 'Partida...',
                store: new Ext.data.JsonStore({
                    url: '../../sis_presupuestos/control/Partida/listarPartida',
                    id: 'id_partida',
                    root: 'datos',
                    sortInfo: {
                        field: 'codigo',
                        direction: 'ASC'
                    },
                    totalProperty: 'total',
                    fields: ['id_partida', 'codigo', 'nombre_partida','descripcion','id_gestion','desc_gestion','tipo','sw_transaccional'],
                    // turn on remote sorting
                    remoteSort: true,
                    baseParams: {par_filtro: 'par.nombre_partida#par.codigo',sw_transaccional:'movimiento'}
                }),
                sortable:false   ,
                valueField: 'id_partida',
                displayField: 'nombre_partida',
                gdisplayField: 'desc_partida',
                triggerAction: 'all',
                lazyRender: true,
                mode: 'remote',
                pageSize: 20,
                queryDelay: 200,
                listWidth:280,
                minChars: 2,
                gwidth: 170,
                renderer: function(value, p, record) {
                    return String.format('{0}', record.data['desc_partida']);
                },
                tpl: '<tpl for="."><div class="x-combo-list-item"><p>Codigo: {codigo}</p><strong>{nombre_partida}</strong> <p>{tipo} - {desc_gestion}</p></div></tpl>'
            },
            type: 'ComboBox',
            id_grupo: 0,
            filters: {
                pfiltro: 'par.nombre_partida#par.codigo',
                type: 'string'
            },
            grid: true,
            form: true
        },
		{
            config: {
                name: 'id_cuenta',
                fieldLabel: 'Cuenta',
                typeAhead: false,
                forceSelection: true,
                allowBlank: false,
                emptyText: 'Cuenta...',
                store: new Ext.data.JsonStore({
                    url: '../../sis_contabilidad/control/Cuenta/listarCuenta',
                    id: 'id_cuenta',
                    root: 'datos',
                    sortInfo: {
                        field: 'nro_cuenta',
                        direction: 'ASC'
                    },
                    totalProperty: 'total',
                    fields: ['id_cuenta', 'desc_cuenta', 'nro_cuenta','nombre_cuenta','id_gestion','gestion','desc_moneda','tipo_cuenta','sw_transaccional'],
                    // turn on remote sorting
                    remoteSort: true,
                    baseParams: {par_filtro: 'cta.desc_cuenta#cta.nro_cuenta#cta.nombre_cuenta',sw_transaccional:'movimiento'}
                }),
                valueField: 'id_cuenta',
                displayField: 'nro_cuenta',
                gdisplayField: 'desc_cuenta',
                triggerAction: 'all',
                lazyRender: true,
                mode: 'remote',
                pageSize: 20,
                queryDelay: 200,
                listWidth:280,
                minChars: 2,
                gwidth: 250,
                renderer: function(value, p, record) {
                    return String.format('{0}', record.data['desc_cuenta']);
                },
                tpl: '<tpl for="."><div class="x-combo-list-item"><p>Codigo: {nro_cuenta}</p><strong>{nombre_cuenta}</strong> <p>{tipo_cuenta} - {desc_moneda} </p><p>{gestion}</p></div></tpl>'
            },
            type: 'ComboBox',
            id_grupo: 0,
            filters: {
                pfiltro: 'cta.desc_cuenta#cta.nro_cuenta#cta.nombre_cuenta',
                type: 'string'
            },
            grid: true,
            form: true
        },
		{
            config: {
                name: 'id_auxiliar',
                fieldLabel: 'Auxiliar',
                typeAhead: false,
                forceSelection: true,
                allowBlank: false,
                emptyText: 'Cuenta...',
                store: new Ext.data.JsonStore({
                    url: '../../sis_contabilidad/control/Auxiliar/listarAuxiliar',
                    id: 'id_auxiliar',
                    root: 'datos',
                    sortInfo: {
                        field: 'codigo_auxiliar',
                        direction: 'ASC'
                    },
                    totalProperty: 'total',
                    fields: ['id_auxiliar', 'codigo_auxiliar', 'nombre_auxiliar'],
                    // turn on remote sorting
                    remoteSort: true,
                    baseParams: {par_filtro: 'aux.codigo_auxiliar#aux.nombre_auxiliar'}
                }),
                valueField: 'id_auxiliar',
                displayField: 'codigo_auxiliar',
                gdisplayField: 'desc_auxiliar',
                triggerAction: 'all',
                lazyRender: true,
                mode: 'remote',
                pageSize: 20,
                queryDelay: 200,
                listWidth:280,
                minChars: 2,
                gwidth: 170,
                renderer: function(value, p, record) {
                    return String.format('{0}', record.data['desc_auxiliar']);
                },
                tpl: '<tpl for="."><div class="x-combo-list-item"><p>Codigo: {codigo_auxiliar}</p><strong>{nombre_auxiliar}</strong></div></tpl>'
            },
            type: 'ComboBox',
            id_grupo: 0,
            filters: {
                pfiltro: 'aux.nombre_auxiliar',
                type: 'string'
            },
            grid: true,
            form: true
        },
		{
            config:{
                name: 'id_centro_costo',
                fieldLabel: 'Centro Costo',
                allowBlank: true,
                emptyText : 'Centro Costo...',
                store : new Ext.data.JsonStore({
                            url:'../../sis_parametros/control/CentroCosto/listarCentroCosto',
                            id : 'id_centro_costo',
                            root: 'datos',
                            sortInfo:{
                                    field: 'codigo_cc',
                                    direction: 'ASC'
                            },
                            totalProperty: 'total',
                            fields: ['id_centro_costo','codigo_cc'],
                            remoteSort: true,
                            baseParams:{par_filtro:'codigo_cc'}
                }),
                valueField: 'id_centro_costo',
               displayField: 'codigo_cc',
               gdisplayField: 'desc_centro_costo',
               hiddenName: 'id_centro_costo',
               forceSelection:true,
               typeAhead: true,
               triggerAction: 'all',
                listWidth:350,
               lazyRender:true,
               mode:'remote',
               pageSize:10,
               queryDelay:1000,
               width:350,
               gwidth:350,
               minChars:2,
               renderer:function(value, p, record){return String.format('{0}', record.data['desc_centro_costo']);}
            },
            type:'ComboBox',
            filters:{pfiltro:'cc.codigo_cc',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },
		{
			config:{
				name: 'estado_reg',
				fieldLabel: 'Estado Reg.',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:10
			},
			type:'TextField',
			filters:{pfiltro:'ccta.estado_reg',type:'string'},
			id_grupo:1,
			grid:true,
			form:false
		},
		{
			config:{
				name: 'fecha_reg',
				fieldLabel: 'Fecha creación',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
						format: 'd/m/Y', 
						renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
			},
			type:'DateField',
			filters:{pfiltro:'ccta.fecha_reg',type:'date'},
			id_grupo:1,
			grid:true,
			form:false
		},
		{
			config:{
				name: 'usr_reg',
				fieldLabel: 'Creado por',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
			type:'NumberField',
			filters:{pfiltro:'usu1.cuenta',type:'string'},
			id_grupo:1,
			grid:true,
			form:false
		},
		{
			config:{
				name: 'fecha_mod',
				fieldLabel: 'Fecha Modif.',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
						format: 'd/m/Y', 
						renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
			},
			type:'DateField',
			filters:{pfiltro:'ccta.fecha_mod',type:'date'},
			id_grupo:1,
			grid:true,
			form:false
		},
		{
			config:{
				name: 'usr_mod',
				fieldLabel: 'Modificado por',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
			type:'NumberField',
			filters:{pfiltro:'usu2.cuenta',type:'string'},
			id_grupo:1,
			grid:true,
			form:false
		}
	],
	
	title:'Concepto cuenta',
	ActSave:'../../sis_presupuestos/control/ConceptoCta/insertarConceptoCta',
	ActDel:'../../sis_presupuestos/control/ConceptoCta/eliminarConceptoCta',
	ActList:'../../sis_presupuestos/control/ConceptoCta/listarConceptoCta',
	id_store:'id_concepto_cta',
	fields: [
		{name:'id_concepto_cta', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'id_auxiliar', type: 'numeric'},
		{name:'id_cuenta', type: 'numeric'},
		{name:'id_concepto_ingas', type: 'numeric'},
		{name:'id_partida', type: 'numeric'},
		{name:'id_centro_costo', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},'desc_centro_costo',
		'desc_moneda','desc_gestion',
		'nombre_cuenta','nro_cuenta','desc_auxiliar','desc_cuenta','codigo_partida','nombre_partida','desc_partida'
		
	],
	
	cmbGestion:new Ext.form.ComboBox({
				fieldLabel: 'Gestion',
				allowBlank: true,
				emptyText:'Gestion...',
				store:new Ext.data.JsonStore(
				{
					url: '../../sis_parametros/control/Gestion/listarGestion',
					id: 'id_gestion',
					root: 'datos',
					sortInfo:{
						field: 'gestion',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_gestion','gestion'],
					// turn on remote sorting
					remoteSort: true,
					baseParams:{par_filtro:'gestion'}
				}),
				valueField: 'id_gestion',
				triggerAction: 'all',
				displayField: 'gestion',
			    hiddenName: 'id_gestion',
    			mode:'remote',
				pageSize:50,
				queryDelay:500,
				listWidth:'280',
				width:80
			}),
	sortInfo:{
		field: 'id_concepto_cta',
		direction: 'ASC'
	},
	capturaFiltros:function(combo, record, index){
		this.store.baseParams.id_gestion=this.cmbGestion.getValue();
		this.store.load({params:{start:0, limit:50}});	
	},
	
	reload:function(p){
	    
	    var idGes= this.cmbGestion.getValue();
	    if(idGes){
    	    this.store.baseParams.id_gestion=idGes;
    	    Phx.vista.ConceptoCta.superclass.reload.call(this,p);
	    }
	},
	onReloadPage:function(m){
		this.maestro=m;
		var idGes= this.cmbGestion.getValue()
		
    		this.store.baseParams={
    			 id_concepto_ingas:this.maestro.id_concepto_ingas,
    			 id_gestion:idGes?idGes:0,
    			 start:0,
    			 limit:this.tam_pag};
		
		if(idGes){
		     
		     this.load({params:{start:0, limit:this.tam_pag}});
		}
		
	},
	 onButtonNew:function(n){
       
        if(this.cmbGestion.getValue()){
	     
	      Phx.vista.ConceptoCta.superclass.onButtonNew.call(this);
	     
	     }
         else
         {
            alert("seleccione una gestion primero");
            
         }   
    },
    
  loadValoresIniciales:function()
	{
		Phx.vista.ConceptoCta.superclass.loadValoresIniciales.call(this);
		this.getComponente('id_concepto_ingas').setValue(this.maestro.id_concepto_ingas);
		this.getComponente('id_gestion').setValue(this.cmbGestion.getValue());  
		
		this.getComponente('id_cuenta').store.baseParams.id_gestion= this.cmbGestion.getValue();
		this.getComponente('id_partida').store.baseParams.id_gestion= this.cmbGestion.getValue();
        this.getComponente('id_centro_costo').store.baseParams.id_gestion=this.cmbGestion.getValue();
		
		var tipo = this.maestro.tipo=='ingreso'?'recurso':'gasto';
        this.getComponente('id_partida').store.baseParams.tipo=tipo;
		
		this.getComponente('id_centro_costo').modificado=true;	
		this.getComponente('id_cuenta').modificado=true;
		this.getComponente('id_partida').modificado=true;
			
		
	},
	bdel:true,
	bsave:false
	}
)
</script>	
		