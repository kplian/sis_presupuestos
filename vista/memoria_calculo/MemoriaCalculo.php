<?php
/**
*@package pXP
*@file gen-MemoriaCalculo.php
*@author  (admin)
*@date 01-03-2016 14:22:24
*@date 29/06/2018 calvarez - se añadió filtro para conig.sw_autorizacion='formulacion_presupuesto' para listar conceptos en la formulación de la memoria de cálculo
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.MemoriaCalculo=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.MemoriaCalculo.superclass.constructor.call(this,config);
		this.init();
		
		
        this.Cmp.id_concepto_ingas.store.baseParams.id_gestion = this.id_gestion;
        this.Cmp.id_concepto_ingas.store.baseParams.movimiento = this.movimiento_tipo_pres;
        
        
        
		this.store.baseParams={id_presupuesto:this.id_presupuesto}; 
		this.load({params:{start:0, limit:this.tam_pag}})
		
		
		
		
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_memoria_calculo'
			},
			type:'Field',
			form:true 
		},
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_presupuesto'
			},
			type:'Field',
			form:true 
		},
		{
            config:{
                name: 'id_concepto_ingas',
                fieldLabel: 'Concepto',
                allowBlank: false,
                emptyText : 'Concepto...',
                store : new Ext.data.JsonStore({
                            url:'../../sis_parametros/control/ConceptoIngas/listarConceptoIngasMasPartida',
                            id : 'id_concepto_ingas',
                            root: 'datos',
                            sortInfo:{
                                    field: 'desc_ingas',
                                    direction: 'ASC'
                            },
                            totalProperty: 'total',
                            fields: ['id_concepto_ingas','tipo','desc_ingas','movimiento','desc_partida','id_grupo_ots','filtro_ot','requiere_ot','desc_gestion'],
                            remoteSort: true,
                            baseParams: { par_filtro: 'desc_ingas#par.codigo', sw_autorizacion: 'formulacion_presupuesto' }
                }),
               valueField: 'id_concepto_ingas',
               displayField: 'desc_ingas',
               gdisplayField: 'desc_ingas',
               hiddenName: 'id_concepto_ingas',
               forceSelection:true,
               typeAhead: false,
               triggerAction: 'all',
               listWidth:500,
               resizable:true,
               lazyRender:true,
               mode:'remote',
               pageSize:10,
               queryDelay:1000,
               width: 250,
               gwidth:350,
               minChars:2,
               qtip:'Si el concepto de gasto que necesita no existe por favor  comuniquese con el área de presupuestos para solicitar la creación.',
               tpl: '<tpl for="."><div class="x-combo-list-item"><p><b>{desc_ingas}</b></p><strong>{tipo}</strong><p>PARTIDA: {desc_partida} - ({desc_gestion})</p></div></tpl>',
               renderer:function(value, p, record){
               	return String.format('{0} <br/><b>{1} - ({2}) </b>', record.data['desc_ingas'],  record.data['desc_partida'], record.data['desc_gestion']);
               	
               	}
            },
            type:'ComboBox',
			bottom_filter: true,
            filters:{pfiltro:'cig.desc_ingas#par.codigo',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },
       
		{
			config:{
				name: 'importe_total',
				fieldLabel: 'Importe Total',
				allowBlank: false,
				allowNegative: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:1179650,
				renderer:function (value,p,record){

					Number.prototype.formatDinero = function(c, d, t){
						var n = this,
							c = isNaN(c = Math.abs(c)) ? 2 : c,
							d = d == undefined ? "." : d,
							t = t == undefined ? "," : t,
							s = n < 0 ? "-" : "",
							i = parseInt(n = Math.abs(+n || 0).toFixed(c)) + "",
							j = (j = i.length) > 3 ? j % 3 : 0;
						return s + (j ? i.substr(0, j) + t : "") + i.substr(j).replace(/(\d{3})(?=\d)/g, "$1" + t) + (c ? d + Math.abs(n - i).toFixed(c).slice(2) : "");
					};

					return  String.format('<div style="vertical-align:middle;text-align:right;"><span >{0}</span></div>',(parseFloat(value)).formatDinero(2, ',', '.'));
				}
			},
				type:'NumberField',
				filters:{pfiltro:'mca.importe_total',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'obs',
				fieldLabel: 'Observacions',
				qtip:  'Justifique la necesidad del item',
				allowBlank: false,
				anchor: '80%',
				gwidth: 300,
				maxLength:400
			},
				type:'TextArea',
				bottom_filter: true,
				filters:{pfiltro:'mca.obs',type:'string'},
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
				filters:{pfiltro:'mca.estado_reg',type:'string'},
				id_grupo:1,
				grid:false,
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
				filters:{pfiltro:'mca.fecha_reg',type:'date'},
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
				type:'Field',
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
				filters:{pfiltro:'mca.fecha_mod',type:'date'},
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
				type:'Field',
				filters:{pfiltro:'usu2.cuenta',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'id_usuario_ai',
				fieldLabel: '',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
				type:'Field',
				filters:{pfiltro:'mca.id_usuario_ai',type:'numeric'},
				id_grupo:1,
				grid:false,
				form:false
		},
		{
			config:{
				name: 'usuario_ai',
				fieldLabel: 'Funcionaro AI',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:300
			},
				type:'TextField',
				filters:{pfiltro:'mca.usuario_ai',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		}
	],
	tam_pag:50,	
	title:'MEMCAL',
	ActSave:'../../sis_presupuestos/control/MemoriaCalculo/insertarMemoriaCalculo',
	ActDel:'../../sis_presupuestos/control/MemoriaCalculo/eliminarMemoriaCalculo',
	ActList:'../../sis_presupuestos/control/MemoriaCalculo/listarMemoriaCalculo',
	id_store:'id_memoria_calculo',
	fields: [
		{name:'id_memoria_calculo', type: 'numeric'},
		{name:'id_concepto_ingas', type: 'numeric'},
		{name:'importe_total', type: 'numeric'},
		{name:'obs', type: 'string'},
		{name:'id_presupuesto', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usuario_ai', type: 'string'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},'desc_ingas','id_partida','desc_partida','desc_gestion','desc_ingas'
		
	],
	sortInfo:{
		field: 'id_memoria_calculo',
		direction: 'DESC'
	},
	bdel:  true,
	bsave: false,
	bedit: true,
	
	tabeast:[
	       {
    		  url:'../../../sis_presupuestos/vista/memoria_det/MemoriaDet.php',
    		  title:'Distribución', 
    		  width:'50%',
    		  cls:'MemoriaDet'
		  }],
	
	onButtonNew:function(){         
            Phx.vista.MemoriaCalculo.superclass.onButtonNew.call(this);
            this.Cmp.id_presupuesto.setValue(this.id_presupuesto); 
    },
    
    onButtonEdit:function(){ 
    	Phx.vista.MemoriaCalculo.superclass.onButtonEdit.call(this);
    }
})
</script>
		
		