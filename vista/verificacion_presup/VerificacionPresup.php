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
			
			var id = this.maestro[this.tabla_id];
			
			this.load({
				params : {
					start : 0,
					limit : this.tam_pag,
					tabla: this.tabla,
					id: id
				}
			});
		},
		
		Atributos : [
		 {
			config : {
				name : 'id_partida',
				fieldLabel : 'Partida',
				gwidth : 200,
				renderer: function(value, p, record){
					return String.format('{0}', record.data.desc_partida);
				}
			},
			type : 'TextField',
			/*filters : {
				pfiltro : 'desc_partida',
				type : 'string'
			},*/
			id_grupo : 1,
			grid : true,
			form : false
		}, {
			config : {
				name : 'id_presupuesto',
				fieldLabel : 'Presupuesto',
				gwidth : 200,
				renderer: function(value, p, record){
					return String.format('{0}', record.data.desc_cc);
				}
			},
			type : 'TextField',
			/*filters : {
				pfiltro : 'desc_cc',
				type : 'string'
			},*/
			id_grupo : 1,
			grid : true,
			form : false
		},{
			config : {
				name : 'importe',
				fieldLabel : 'Importe',
				gwidth : 100
			},
			type : 'TextField',
			/*filters : {
				pfiltro : 'importe',
				type : 'string'
			},*/
			id_grupo : 1,
			grid : true,
			form : false
		},{
			config : {
				name : 'id_moneda',
				fieldLabel : 'Moneda',
				gwidth : 100,
				renderer: function(value, p, record){
					return String.format('{0}', record.data.desc_moneda);
				}
			},
			type : 'TextField',
			/*filters : {
				pfiltro : 'desc_moneda',
				type : 'string'
			},*/
			id_grupo : 1,
			grid : true,
			form : false
		}, {
			config : {
				name : 'disponibilidad',
				fieldLabel : 'Disponibilidad Presup.',
				allowBlank : true,
				anchor : '80%',
				gwidth : 130,
				maxLength : 10
			},
			type : 'TextField',
			/*filters : {
				pfiltro : 'disponibilidad',
				type : 'string'
			},*/
			id_grupo : 1,
			grid : true,
			form : false
		}],
		title : 'Verificación presupuestaria',
		ActList : '../../sis_presupuestos/control/VerificacionPresup/verificarPresup',
		fields : [{
			name : 'id_partida',
			type : 'numeric'
		}, {
			name : 'id_presupuesto',
			type : 'numeric'
		}, {
			name : 'id_moneda',
			type : 'numeric'
		}, {
			name : 'importe',
			type : 'numeric'
		}, {
			name : 'disponibilidad',
			type : 'string'
		}, {
			name : 'desc_partida',
			type : 'string'
		}, {
			name : 'desc_cc',
			type : 'string'
		}, {
			name : 'desc_moneda',
			type : 'string'
		}],
		sortInfo : {
			field : 'desc_partida',
			direction : 'ASC'
		},
		bdel : false,
		bsave : false,
		bnew: false,
		bedit:false,
		tam_pag:1000
	}); 
</script>