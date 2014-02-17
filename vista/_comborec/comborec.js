Ext.namespace('Phx','Phx.comborec.sis_presupuestos');		

Phx.comborec.sis_presupuestos.configini = function (config){
	
	if (config.origen == 'PARTIDA') {
		
		this.tpl = new Ext.XTemplate([
		     '<tpl for=".">',
		     '<div class="x-combo-list-item">',
		     	'<tpl if="sw_movimiento == \'flujo\'">',
		     	'<font color="red"><p>Nombre:{nombre_partida}</p></font>',
		     	'</tpl>',
		     	'<tpl if="sw_movimiento == \'presupuestaria\'">',
		     	'<font color="green"><p>Nombre:{nombre_partida}</p></font>',
		     	'</tpl>',
		     '<p>{codigo}</p> <p>Tipo: {sw_movimiento} <p>Rubro: {tipo}</p>',
		     '</div>',
		     '</tpl>'
		     
		   ]);
		   
		  // tpl:'<tpl for="."><div class="x-combo-list-item"><p>{codigo}</p><p>Nombre:{nombre_partida}</p> </div></tpl>',
				
		
		
		return {
			 origen: 'PARTIDA',
			 tinit:false,
			 tasignacion:true,
			  resizable:true,
			 tname:'id_partida',
			 tdisplayField:'nombre_partida',
			 pid:this.idContenedor,
			 name:'id_partida',
 				fieldLabel:'Partida',
 				allowBlank:true,
 				emptyText:'Partida...',
				store: new Ext.data.JsonStore({
						 url: '../../sis_presupuestos/control/Partida/listarPartida',
						 id: 'id_partida',
						 root: 'datos',
						 sortInfo:{
							field: 'nombre_partida',
							direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_partida','codigo','nombre_partida','tipo','sw_movimiento'],
					// turn on remote sorting
					remoteSort: true,
					baseParams:{par_filtro:'codigo#nombre_partida',sw_transaccional:'movimiento'}
					}),
				valueField: 'id_partida',
 				displayField: 'nombre_partida',
 				hiddenName: 'id_partida',
				//tpl:'<tpl for=".">'<tpl if="STREET2.length &gt; 0">',<div class="x-combo-list-item"><p>{codigo}</p><p>Nombre:{nombre_partida}</p> </div></tpl>',
				tpl:this.tpl,
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
	
}
	    		

	    