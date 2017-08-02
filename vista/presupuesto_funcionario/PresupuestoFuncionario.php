<?php
/**
*@package pXP
*@file gen-PresupuestoUsuario.php
*@author  (admin)
*@date 29-02-2016 03:25:38
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.PresupuestoFuncionario=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.PresupuestoFuncionario.superclass.constructor.call(this,config);
		this.init();
		
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
					name: 'id_presupuesto_funcionario'
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
	       		    name:'id_funcionario',
	   				origen:'FUNCIONARIO',
	   				tinit:false,
	   				fieldLabel: 'Funcionario',
	   				gdisplayField:'desc_funcionario',
	   			    gwidth: 250,
	   			    anchor: '100%',
	   			    allowBlank:true,
		   			renderer: function (value, p, record){return String.format('{0}', record.data['desc_funcionario']);}
	       	     },
	   			type:'ComboRec',
	   			id_grupo:8,
	   			filters:{	
			        pfiltro:'f.desc_funcionario1',
					type:'string'
				},
	   			grid:true,
	   			form:true
	   	},
		
		
		{
			config:{
				name: 'accion',
				fieldLabel: 'Acciones',
				allowBlank: false,
				triggerAction:"all",
				forceSelection:true,
                typeAhead: false,
				store: ['formulacion', 'aprobacion', 'responsable'],
				anchor: '80%',
				mode:'local',
				gwidth: 200
			},
				type:'ComboBox',
				filters:{pfiltro:'pf.estado_reg',type:'string'},
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
				filters:{pfiltro:'pf.estado_reg',type:'string'},
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
				name: 'fecha_reg',
				fieldLabel: 'Fecha creación',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
							format: 'd/m/Y', 
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
			},
				type:'DateField',
				filters:{pfiltro:'preus.fecha_reg',type:'date'},
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
				filters:{pfiltro:'preus.usuario_ai',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'id_usuario_ai',
				fieldLabel: 'Funcionaro AI',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
				type:'Field',
				filters:{pfiltro:'preus.id_usuario_ai',type:'numeric'},
				id_grupo:1,
				grid:false,
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
				name: 'fecha_mod',
				fieldLabel: 'Fecha Modif.',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
							format: 'd/m/Y', 
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
			},
				type:'DateField',
				filters:{pfiltro:'preus.fecha_mod',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		}
	],
	tam_pag:50,	
	title:'Funcionario',
	ActSave:'../../sis_presupuestos/control/PresupuestoFuncionario/insertarPresupuestoFuncionario',
	ActDel:'../../sis_presupuestos/control/PresupuestoFuncionario/eliminarPresupuestoFuncionario',
	ActList:'../../sis_presupuestos/control/PresupuestoFuncionario/listarPresupuestoFuncionario',
	id_store:'id_presupuesto_funcionario',
	fields: [
		{name:'id_presupuesto_funcionario', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'accion', type: 'string'},
		{name:'id_funcionario', type: 'numeric'},
		{name:'id_presupuesto', type: 'numeric'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usuario_ai', type: 'string'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},'desc_funcionario'
		
	],
	
	onReloadPage:function(m){
		this.maestro=m;
		this.store.baseParams = { id_presupuesto: this.maestro.id_presupuesto };
		this.load({ params: {start:0, limit:50 } });
		
	},
	loadValoresIniciales:function(){
		Phx.vista.PresupuestoFuncionario.superclass.loadValoresIniciales.call(this);
		this.getComponente('id_presupuesto').setValue(this.maestro.id_presupuesto);		
	},
	
	sortInfo:{
		field: 'id_presupuesto_funcionario',
		direction: 'ASC'
	},
	bdel:true,
	bsave:true
	}
)
</script>	