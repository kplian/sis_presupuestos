<?php
/**
*@package pXP
*@file    SubirArchivo.php
*@author  Manuel Guerra
*@date    22-03-2012
*@description permites subir archivos a la tabla de documento_sol
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.SubirArchivoPre=Ext.extend(Phx.frmInterfaz,{
	ActSave:'../../sis_presupuestos/control/MemoriaCalculo/SubirArchivoPre',
	breset: false,
	constructor:function(config)
	{
		Phx.vista.SubirArchivoPre.superclass.constructor.call(this,config);
		this.init(); 
		this.loadValoresIniciales();
		// id_aux=Phx.CP.config_ini.id_usuario;
	},

	loadValoresIniciales:function()
	{
		Phx.vista.SubirArchivoPre.superclass.loadValoresIniciales.call(this);
		this.getComponente('id_memoria_calculo').setValue(this.id_memoria_calculo); 
		var id_aux=Phx.CP.config_ini.id_usuario;
		this.getComponente('id_sesion').setValue(id_aux);
	},

	successSave:function(resp)
	{
		Phx.CP.loadingHide();
		var objRes = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
		this.fireEvent('successsave',this,objRes);
		Phx.CP.getPagina(this.idContenedorPadre).reload();
		this.panel.close();
	},

	Atributos:[
		{
			config:{
				labelSeparator:'',
				inputType:'hidden',
				name: 'id_memoria_calculo'
			},
			type:'Field',
			form:true
		},
		{
			config:{
				labelSeparator:'',
				inputType:'hidden',
				name: 'id_sesion'
			},
			type:'Field',
			form:true
		},
		{
			config:{
				name : 'id_gestion',
				origen : 'GESTION',
				fieldLabel : 'Gestion',
				allowBlank : false,
				width : 250,
			},
			type : 'ComboRec',
			form : true
		},
		{
			config:{
				name:'id_funcionario',
				origen:'FUNCIONARIO',
				tinit:false,
				fieldLabel: 'Funcionario',
				gdisplayField:'desc_funcionario',
				width : 250,
				allowBlank:true,
				renderer: function (value, p, record){return String.format('{0}', record.data['desc_funcionario']);}
				},
			type:'ComboRec',
			filters:{
				pfiltro:'f.desc_funcionario1',
				type:'string'
			},
			grid:true,
			form:true
		},
		{
			config : {
				name : 'tipo',
				fieldLabel : 'Tipo',
				typeAhead : true,
				allowBlank : false,
				triggerAction : 'all',
				emptyText : 'Seleccione Opcion...',
				selectOnFocus : true,
				width : 250,
				mode : 'local',
				store : new Ext.data.ArrayStore({
					fields : ['ID', 'valor'],
					data : [['insertar', 'Insertar sin eliminar'], ['sobreescribir', 'Sobreescribir(antiguo)']],
				}),
				valueField : 'ID',
				displayField : 'valor'
			},
			type : 'ComboBox',
			grid:true,
			form:true
		},
		{
			config:{
				fieldLabel: "Transacciones",
				width : 250,
				inputType: 'file',
				name: 'archivo',
				allowBlank: false,
				buttonText: '',
				maxLength: 150,
			},
			type:'Field',
			form:true
		}
	],
	title:'Subir Archivo',
	fileUpload:true,
	onSubmit: function(o) {
		var me = this;
		var msg = '';
		if(this.Cmp.tipo.getValue()=='insertar'){
			msg= 'Desea insertar sin eliminar ningun registro?';
		}else{
			if(this.Cmp.tipo.getValue()=='sobreescribir'){
				msg= 'Desea sobreescribir los registros?';
			}
		}
		if(this.Cmp.id_funcionario && this.Cmp.archivo && this.Cmp.id_gestion && this.Cmp.tipo){
			if(confirm(msg, " ¿Desea continuar?")){
				if(confirm(msg, " ¿Desea continuar?")){
					Phx.vista.SubirArchivoPre.superclass.onSubmit.call(this,o,undefined, true);
				}
			}
		}
		else{
			Ext.Msg.alert('Alerta', 'Error');
		}
	},
	//
}
)
</script>
