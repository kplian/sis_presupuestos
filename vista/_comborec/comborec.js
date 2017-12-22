Ext.namespace('Phx','Phx.comborec.sis_presupuestos');		

Phx.comborec.sis_presupuestos.configini = function (config){
	
	if (config.origen == 'PARTIDA') {
		
		var tpl = new Ext.XTemplate([
		     '<tpl for=".">',
		     '<div class="x-combo-list-item">',
		     	'<tpl if="sw_movimiento == \'flujo\'">',
		     	'<font color="red"><p>{nombre_partida} ({codigo})</p></font>',
		     	'</tpl>',
		     	'<tpl if="sw_movimiento == \'presupuestaria\'">',
		     	'<font color="green"><p>{nombre_partida} ({codigo})</p></font>',
		     	'</tpl>',
		     '<p>Tipo: {sw_movimiento} </p>Rubro: {tipo}</p>',
		     '</div>',
		     '</tpl>'
		     
		   ]);
		   
		
		return {
			 origen: 'PARTIDA',
			 tinit: false,
			 tasignacion: true,
			 resizable: true,
			 tname:'id_partida',
			 tdisplayField:'nombre_partida',
			 pid: this.idContenedor,
			 name:'id_partida',
 				fieldLabel:'Partida',
 				allowBlank:true,
 				emptyText:'Partida...',
				store: new Ext.data.JsonStore({
						 url: '../../sis_presupuestos/control/Partida/listarPartida',
						 id: 'id_partida',
						 root: 'datos',
						 sortInfo:{
							field: 'codigo',
							direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_partida','codigo','nombre_partida','tipo','sw_movimiento'],
					// turn on remote sorting
					remoteSort: true,
					baseParams: Ext.apply({par_filtro:'codigo#nombre_partida',sw_transaccional:'movimiento'}, config.baseParams)
					}),
				valueField: 'id_partida',
 				displayField: 'nombre_partida',
 				hiddenName: 'id_partida',
				//tpl:'<tpl for=".">'<tpl if="STREET2.length &gt; 0">',<div class="x-combo-list-item"><p>{codigo}</p><p>Nombre:{nombre_partida}</p> </div></tpl>',
				tpl: tpl,
				forceSelection:true,
 				typeAhead: false,
                triggerAction: 'all',
                lazyRender:true,
 				mode:'remote',
 				pageSize:10,
 				queryDelay:1000,
 				width:250,
				listWidth:'280',
				minChars:2
		}
		
	}
	
	if(config.origen=='PRESUPUESTO'){    		
		    	
		    var tpl = new Ext.XTemplate([
		     '<tpl for=".">',
		     '<div class="x-combo-list-item">',
		     	'<tpl if="movimiento_tipo_pres == \'gasto\'">',
		     	'<font color="red"><p>{codigo_cc}</p></font>',
		     	'</tpl>',
		     	 '<tpl if="movimiento_tipo_pres == \'ingreso_egreso\'">',
		    		      '<p><b><font color="blue">{codigo_cc}</font></b></p>',
		    	'</tpl>',
		     	'<tpl if="movimiento_tipo_pres == \'recurso\'">',
		     	'<font color="green"><p>{codigo_cc}</p></font>',
		     	'</tpl>',
		     	'<tpl if="movimiento_tipo_pres == \'administrativo\'">',
		     	'<font color="blue"><p>{codigo_cc}</p></font>',
		     	'</tpl>',
		     '<p>Tipo: {desc_tipo_presupuesto}</p> <p> Estado: {estado}</p>',
		     '</div>',
		     '</tpl>'
		     
		   ]);
		  
	
		   
		    
		    return {
		    			 origen:'PRESUPUESTO',
		    			 tinit:false,
		    			 resizable:true,
		    			 tasignacion:false,
				         name:'id_presupuesto',
			   			 fieldLabel:'Presupuesto',
			   				allowBlank:false,
			   				emptyText:'Presupuestos...',
			   				store: new Ext.data.JsonStore({
		
		    					url: config.url?config.url:'../../sis_presupuestos/control/Presupuesto/listarPresupuestoCmb',
		    					id: 'id_presupuesto',
		    					root: 'datos',
		    					sortInfo:{field: 'codigo_cc',direction: 'ASC'},
		    					totalProperty: 'total',
		    					fields: ['id_centro_costo','id_presupuesto','desc_tipo_presupuesto','descripcion','codigo_cc','tipo_pres',
		    					          'desc_tipo_presupuesto','movimiento_tipo_pres','nro_tramite','id_gestion',
		    					         'movimiento_tipo_pres','estado'],
		    					// turn on remote sorting
		    					remoteSort: true,
		    					baseParams:Ext.apply({tipo_pres:"gasto",par_filtro:'id_centro_costo#codigo_cc#desc_tipo_presupuesto#movimiento_tipo_pres'},config.baseParams)
		    					
		    				}), 
		    				tpl: tpl,		
		    				valueField: 'id_presupuesto',
		       				displayField: 'codigo_cc',
		       				gdisplayField: 'desc_presupuesto',
		       				hiddenName: 'id_presupuesto',
		       				forceSelection: true,
		       				typeAhead: false,
		           			triggerAction: 'all',
		           			lazyRender: true,
		       				mode: 'remote',
		       				pageSize: 10,
		       				queryDelay: 1000,
		       				listWidth: '320',
		       				width: 290,
		       				minChars: 2
		    		}
		    		
		
		    	}
	
}
	    		

	    