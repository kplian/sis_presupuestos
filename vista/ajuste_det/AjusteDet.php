<?php
/**
*@package pXP
*@file gen-AjusteDet.php
*@author  (admin)
*@date 13-04-2016 13:51:41
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.AjusteDet=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.AjusteDet.superclass.constructor.call(this,config);
		this.iniciarEventos();
		
	},
			//ll
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_ajuste_det'
			},
			type:'Field',
			form:true 
		},
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_ajuste'
			},
			type:'Field',
			form:true 
		},
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'tipo_ajuste'
			},
			type:'Field',
			form:true 
		},
		{
            config:{
            	sysorigen:'sis_presupuestos',
                name: 'id_presupuesto',
                fieldLabel: 'Presupuesto',
                allowBlank: false,
                tinit:false,
                origen:'PRESUPUESTO',
                gdisplayField: 'desc_presupuesto',
                baseParams: {estado: 'aprobado'},
                width: 350,
   				listWidth: 350,
                gwidth: 300
            },
            type:'ComboRec',
            filters:{pfiltro:'pre.codigo_cc',type:'string'},
            id_grupo:1,
            grid:true,
            bottom_filter: true,
            form:true
        },
	   	{
   			config:{
   				sysorigen:'sis_presupuestos',
       		    name:'id_partida',
   				origen:'PARTIDA',
   				allowBlank:false,
   				fieldLabel:'Partida',
   				gdisplayField:'desc_partida',//mapea al store del grid
   				baseParams: {sw_transaccional: 'movimiento', sw_oficial: 'si'},
   				gwidth:200,
   				width: 350,
   				listWidth: 350
       	     },
   			type:'ComboRec',
   			id_grupo:0,
   			filters:{	
		        pfiltro: 'par.codigo_partida#par.nombre_partida',
				type: 'string'
			},   		   
   			grid:true,   			
   			form:true
	   	},
		{
			config:{
				name: 'importe',
				fieldLabel: 'importe',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:1310722,
				renderer:function (value,p,record){
					if(record.data.tipo_reg != 'summary'){
						return  String.format('{0}', Ext.util.Format.number(value,'0,000.00'));
					}
					else{
						return  String.format('<b><font size=2 >{0}</font><b>', Ext.util.Format.number(value,'0,000.00'));
					}
					
				}
			},
				type:'NumberField',
				filters:{pfiltro:'ajd.importe',type:'numeric'},
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
				filters:{pfiltro:'ajd.estado_reg',type:'string'},
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
				filters:{pfiltro:'ajd.fecha_reg',type:'date'},
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
				filters:{pfiltro:'ajd.fecha_mod',type:'date'},
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
				name: 'usuario_ai',
				fieldLabel: 'Funcionaro AI',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:300
			},
				type:'TextField',
				filters:{pfiltro:'ajd.usuario_ai',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		}
	],
	tam_pag:50,	
	title:'Detalle del Ajuste',
	ActSave:'../../sis_presupuestos/control/AjusteDet/insertarAjusteDet',
	ActDel:'../../sis_presupuestos/control/AjusteDet/eliminarAjusteDet',
	ActList:'../../sis_presupuestos/control/AjusteDet/listarAjusteDet',
	id_store:'id_ajuste_det',
	fields: [
		{name:'id_ajuste_det', type: 'numeric'},
		{name:'id_presupuesto', type: 'numeric'},
		{name:'id_partida_ejecucion', type: 'numeric'},
		{name:'importe', type: 'numeric'},
		{name:'id_partida', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'tipo_ajuste', type: 'string'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usuario_ai', type: 'string'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},'desc_presupuesto','desc_partida','tipo_reg'
		
	],
	sortInfo:{
		field: 'id_ajuste_det',
		direction: 'ASC'
	},
	preparaMenu:function(){
		var rec = this.sm.getSelected();
		var tb = this.tbar;
		if (rec.data.tipo_reg == 'summary'){
			if( this.getBoton('edit') ){
				this.getBoton('edit').disable();
			}
			if( this.getBoton('del') ){
				this.getBoton('del').disable();
			}
			if( this.getBoton('new') ){
				this.getBoton('new').disable();
			}
		     
             
		}
		else{
		   Phx.vista.AjusteDet.superclass.preparaMenu.call(this);
		}
   },
	
    liberaMenu: function() {
		var tb = Phx.vista.AjusteDet.superclass.liberaMenu.call(this);
		
    },
   
    
	iniciarEventos : function() {

        this.Cmp.id_presupuesto.on('select', function (c, r, i) {
             this.Cmp.id_partida.reset();
            if(this.maestro.tipo_ajuste == 'inc_comprometido' || this.maestro.tipo_ajuste == 'rev_comprometido'){
			    
			    this.Cmp.id_partida.store.baseParams.id_presupuesto_ajuste = this.Cmp.id_presupuesto.getValue();
			    delete this.Cmp.id_partida.store.baseParams.id_presupuesto;
			}
			else{
				
				this.Cmp.id_partida.store.baseParams.id_presupuesto = this.Cmp.id_presupuesto.getValue();
				delete this.Cmp.id_partida.store.baseParams.id_presupuesto_ajuste;
			}
			this.Cmp.id_partida.modificado = true;
           
        }, this);
    },
    onButtonEdit : function () {
        var selected = this.sm.getSelected().data;
        Phx.vista.AjusteDet.superclass.onButtonEdit.call(this);
        this.Cmp.id_presupuesto.disable();
        this.Cmp.id_partida.disable();
       
    },
     onButtonNew : function () {
       
        Phx.vista.AjusteDet.superclass.onButtonNew.call(this);
        this.Cmp.id_presupuesto.enable();
        this.Cmp.id_partida.enable();
       
    },
	
	
	
	bdel:true,
	bsave:true
})
</script>		
		