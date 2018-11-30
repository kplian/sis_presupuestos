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
				allowBlank : false				
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
                fieldLabel: "Transacciones",
                gwidth: 130,
                inputType: 'file',
                name: 'archivo',
                allowBlank: false,
                buttonText: '', 
                maxLength: 150,
                anchor:'100%'
            },
            type:'Field',
            form:true 
        }
    ],
    title:'Subir Archivo',    
    fileUpload:true,
    
    
}
)    
</script>
