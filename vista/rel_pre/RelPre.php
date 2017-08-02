<?php
/**
*@package pXP
*@file gen-RelPre.php
*@author  (admin)
*@date 18-04-2016 13:18:06
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.RelPre=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.RelPre.superclass.constructor.call(this,config);
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
					name: 'id_rel_pre'
			},
			type:'Field',
			form:true 
		},
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_presupuesto_padre'
			},
			type:'Field',
			form:true 
		},
		{
            config:{
            	sysorigen: 'sis_presupuestos',
                name: 'id_presupuesto_hijo',
                fieldLabel: 'Presupuesto',
                allowBlank: false,
                tinit: false,
                origen: 'PRESUPUESTO',
                gdisplayField: 'desc_presupuesto_hijo',
                baseParams: { estado: 'borrador', sw_oficial: 'no' },
                width: 350,
   				listWidth: 350,
                gwidth: 300
            },
            type: 'ComboRec',
            filters: { pfiltro: 'pre.codigo_cc', type:'string' },
            id_grupo:1,
            grid: true,
            bottom_filter: true,
            form: true
        },
		
		{
			config:{
				name: 'estado',
				fieldLabel: 'estado',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:30
			},
				type:'TextField',
				filters:{pfiltro:'relp.estado',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'fecha_union',
				fieldLabel: 'fecha_union',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
							format: 'd/m/Y', 
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
			},
				type:'DateField',
				filters:{pfiltro:'relp.fecha_union',type:'date'},
				id_grupo:1,
				grid: true,
				form: false
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
				filters:{pfiltro:'relp.estado_reg',type:'string'},
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
				filters:{pfiltro:'relp.id_usuario_ai',type:'numeric'},
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
				filters:{pfiltro:'relp.fecha_reg',type:'date'},
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
				filters:{pfiltro:'relp.usuario_ai',type:'string'},
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
				filters:{pfiltro:'relp.fecha_mod',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		}
	],
	tam_pag:50,	
	title:'Relación para Consolidado',
	ActSave:'../../sis_presupuestos/control/RelPre/insertarRelPre',
	ActDel:'../../sis_presupuestos/control/RelPre/eliminarRelPre',
	ActList:'../../sis_presupuestos/control/RelPre/listarRelPre',
	id_store:'id_rel_pre',
	fields: [
		{ name:'id_rel_pre', type: 'numeric'},
		{ name:'estado', type: 'string'},
		{ name:'id_presupuesto_hijo', type: 'numeric'},
		{ name:'fecha_union', type: 'date',dateFormat:'Y-m-d'},
		{ name:'estado_reg', type: 'string'},
		{ name:'id_presupuesto_padre', type: 'numeric'},
		{ name:'id_usuario_ai', type: 'numeric'},
		{ name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{ name:'usuario_ai', type: 'string'},
		{ name:'id_usuario_reg', type: 'numeric'},
		{ name:'id_usuario_mod', type: 'numeric'},
		{ name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{ name:'usr_reg', type: 'string'},
		{ name:'usr_mod', type: 'string'}, 
		'desc_presupuesto_hijo'
		
	],
	sortInfo:{
		field: 'id_rel_pre',
		direction: 'ASC'
	},
	bdel: true,
	bsave: true,
	bedit: false,
	
	onReloadPage:function(m){
		this.maestro=m;
        this.store.baseParams={id_ajuste: this.maestro.id_ajuste, tipo_ajuste: 'incremento'};
       
        this.Cmp.id_presupuesto_hijo.store.baseParams.id_gestion = this.maestro.id_gestion;   
        this.Cmp.id_presupuesto_hijo.modificado = true;       
        this.store.baseParams = {id_presupuesto_padre: this.maestro.id_presupuesto};
        this.load({params:{start:0, limit:50}});
   },
   
   loadValoresIniciales:function(){
        Phx.vista.RelPre.superclass.loadValoresIniciales.call(this);
        this.Cmp.id_presupuesto_padre.setValue(this.maestro.id_presupuesto);
   }
})
</script>		