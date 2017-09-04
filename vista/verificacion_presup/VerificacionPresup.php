<?php
/**
 *@package   pXP
 *@file      VerificacionPresup.php
 *@author    RCM
 *@date      20/12/2013
 *@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
 */
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.VerificacionPresup = Ext.extend(Phx.gridInterfaz, {
		constructor: function(config) {
			this.maestro = config;
			Phx.vista.VerificacionPresup.superclass.constructor.call(this, config);
			this.init();
			this.title2 = this.num_tramite;
			var id = this.maestro[this.tabla_id];
			
			this.load({
				params : {
					start : 0,
					limit : this.tam_pag,
					tabla: this.tabla,
					id: this.tabla_id
				}
			});
		},
		
		Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_ver'
			},
			type:'Field',
			form:false 
		},
		{
			config:{
				name: 'descripcion',
				fieldLabel: 'Categoria/Presupuesto/Tipo Centro',
				allowBlank: true,
				anchor: '80%',
				gwidth: 300,
				maxLength:300,
				renderer:function (value,p,record){
						if(record.data.pre_verificar_categoria=='si'){
							return  String.format('({0}) - {1}', record.data.codigo_categoria, record.data.desc_cp);
						}
						else{
							if(record.data.pre_verificar_tipo_cc=='si'){
							    return  String.format('({0}) - {1}', record.data.codigo_tcc, record.data.desc_tcc);
						    }
						    else{
						    	return  String.format('{0} ', record.data.desc_tipo_presupuesto);
						    }
						
						}
						
				}
			},
				type:'TextField',
				bottom_filter: true,
				
   			    //filters:{pfiltro:'pcc.descripcion',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'nombre_partida',
				fieldLabel: 'Partida',
				allowBlank: true,
				anchor: '80%',
				gwidth: 200,
				maxLength:300,
				renderer:function (value,p,record){
					if(record.data.pre_verificar_tipo_cc=='si' && record.data.control_partida=='no'){
						return 'No considera partidas ';
					}
					else{
						return  String.format('{0} - {1}', record.data.codigo_partida, value);
					}
						
				}
			},
				type:'TextField',
				bottom_filter: true,
				id_grupo:1,
				grid:true,
				form:false
		},
	   	
		
		{
			config:{
				name: 'monto_mb',
				fieldLabel: 'Monto MB (Necesario)',
				gwidth: 100,
				renderer:function (value,p,record){
						return  String.format('<b><font size=2 >{0}</font><b>', Ext.util.Format.number(value,'0,000.00'));
				}
			},
				type: 'NumberField',
				id_grupo: 1,
				grid: true,
				form: false
		},
		{
			config:{
				name: 'verificacion',
				fieldLabel: 'Disponibilidad',
				gwidth: 100,
				renderer:function (value,p,record){
						if(value == 'true'){
							return  '<b><font size=2 color="green">SI</font><b>';
						}
						else{
							return '<b><font size=2 color="red">NO</font><b>';
						}
						
						
					}
			},
				type: 'NumberField',
				id_grupo: 1,
				grid: true,
				form: false
		},
		{
			config:{
				name: 'saldo',
				fieldLabel: 'Saldo',
				gwidth: 100,
				renderer:function (value,p,record){
					return  String.format('<b><font size=2 >{0}</font><b>', Ext.util.Format.number(value,'0,000.00'));
						
				}
			},
				type: 'NumberField',
				id_grupo: 1,
				grid: true,
				form: false
		}
		
		
	    ],
		title : 'Verificación presupuestaria',
		ActList : '../../sis_presupuestos/control/VerificacionPresup/verificarPresup',
		fields: [
		 'id_ver', 'control_partida','id_par',
          'id_agrupador','importe_debe', 'importe_haber','movimiento',
          'id_presupuesto','tipo_cambio', 'monto_mb','verificacion', 'saldo',
          'codigo_partida', 'nombre_partida','desc_tipo_presupuesto', 'descripcion',
          'desc_cp','codigo_categoria','codigo_tcc','desc_tcc','pre_verificar_categoria','pre_verificar_tipo_cc'
          
          
		
	    ],
		sortInfo : {
			field : 'id_ver',
			direction : 'ASC'
		},
		bdel : false,
		bsave : false,
		bnew: false,
		bedit:false,
		tam_pag:1000
	}); 
</script>