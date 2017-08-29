<?php
/**
*@package pXP
*@file gen-MemoriaDet.php
*@author  (admin)
*@date 01-03-2016 14:23:08
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.MemoriaDet=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.MemoriaDet.superclass.constructor.call(this,config);
		this.init();
		this.bloquearMenus();   
		this.iniciarEventos();
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_memoria_det'
			},
			type:'Field',
			form:true 
		},
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
			config:{
				name: 'desc_periodo',
				fieldLabel: 'Periodo',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4,
				sortable: false,
				renderer:function (value, p, record){
                	    var dato='';
                        dato = (value=='1')?'Enero':dato;
                        dato = (dato==''&&value=='2')?'Febrero':dato;
                        dato = (dato==''&&value=='3')?'Marzo':dato;
                        dato = (dato==''&&value=='4')?'Abril':dato;
                        dato = (dato==''&&value=='5')?'Mayo':dato;
                        dato = (dato==''&&value=='6')?'Junio':dato;
                        dato = (dato==''&&value=='7')?'Julio':dato;
						dato = (dato==''&&value=='8')?'Agosto':dato;
						dato = (dato==''&&value=='9')?'Septiembre':dato;
						dato = (dato==''&&value=='10')?'Octubre':dato;
						dato = (dato==''&&value=='11')?'Noviembre':dato;
						dato = (dato==''&&value=='12')?'Diciembre':dato;
                        return String.format('{0}', dato);
                    },
                
                store:new Ext.data.ArrayStore({
                            fields :['variable','valor'],
                            data :  []}),
               
                valueField: 'variable',
                displayField: 'valor'
			},
				type:'ComboBox',
				filters:{pfiltro:'p.periodo',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
				
		},
		{
		   config : {
			     name : 'unidad_medida',
			     fieldLabel : 'Unidad de Medida',
			     anchor : '90%',
			     tinit : false,
			     allowBlank : false,
			     origen : 'CATALOGO',
			     gdisplayField : 'unidad_medida',
			     gwidth : 100,
			     anchor : '100%',
				 sortable: false,
			     baseParams : {
			     cod_subsistema : 'PRE',
			     catalogo_tipo : 'unidad_medida'},
			     renderer : function(value, p, record) {
					return String.format('{0}',record.data['unidad_medida']);
				}
		   },
		   type : 'ComboRec',
		   id_grupo : 0,
		   filters : {pfiltro : 'mdt.unidad_medida',type : 'string'},
		   egrid: true,
		   grid : true,
		   form : true
		},
		
		{
			config:{
				name: 'cantidad_mem',
				fieldLabel: 'Cantidad',
				selectOnFocus: true,
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				sortable: false,
				maxLength:1179650,
                renderer:function (value,p,record){
                    return  String.format('<div style="vertical-align:middle;text-align:center;"><span ><b>{0}</b></span></div>',value);
                },
                validateValue: function(pw){
                        function tiene_punto(pw)
                        {
                            var expreg=/^([A-Za-z0-9_ ]+)$/;
                            if(expreg.test(pw))
                                return 1;
                            return 0;
                        }

                        var x = '';
                        var seguridad = 0;

                        if(tiene_punto(pw)==1)
                            seguridad += 18;
                        else
                            x += 'No se permite el caracter puntos.<br>';



                        this.markInvalid(x);

                        if(pw.length == 0)
                            seguridad = 0;

                        if(x=='')
                            return true
                        else
                            return false
                    }
			},
				type:'NumberField',
				filters:{pfiltro:'mdt.cantidad_mem',type:'numeric'},
				id_grupo:1,
				egrid: true,
				grid:true,
				form:true
		},
		
		{
			config:{
				name: 'importe_unitario',
				fieldLabel: 'P. Unitario',
				selectOnFocus: true,
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				sortable: false,
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

					if(record.data.tipo_reg != 'summary'){

						return  String.format('<div style="vertical-align:middle;text-align:right;"><span >{0}</span></div>',(parseFloat(value)).formatDinero(2, ',', '.'));
					}
					else{

						//return  String.format('<div style="vertical-align:middle;text-align:right;"><span ><b>{0}</b></span></div>',(parseFloat(value)).formatDinero(2, ',', '.'));

					}

				}
			},
				type:'NumberField',
				filters:{pfiltro:'mdt.importe_unitario',type:'numeric'},
				id_grupo:1,
				egrid: true,
				grid:true,
				form:true
		},
		
		{
			config:{
				name: 'importe',
				fieldLabel: 'TOTAL',
				selectOnFocus: true,
				allowBlank: false,
				anchor: '80%',
				sortable: false,
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

					if(record.data.tipo_reg != 'summary'){

						return  String.format('<div style="vertical-align:middle;text-align:right;"><span >{0}</span></div>',(parseFloat(value)).formatDinero(2, ',', '.'));
					}
					else{

						return  String.format('<div style="vertical-align:middle;text-align:right;"><span ><b>{0}</b></span></div>',(parseFloat(value)).formatDinero(2, ',', '.'));

					}

				}
			},
				type:'NumberField',
				filters:{pfiltro:'mdt.importe',type:'numeric'},
				bottom_filter: true,
				id_grupo:1,
				egrid: false,
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
				sortable: false,
				maxLength:10
			},
				type:'TextField',
				filters:{pfiltro:'mdt.estado_reg',type:'string'},
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
				filters:{pfiltro:'mdt.usuario_ai',type:'string'},
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
				sortable: false,
				gwidth: 100,
							format: 'd/m/Y', 
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
			},
				type:'DateField',
				filters:{pfiltro:'mdt.fecha_reg',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'usr_reg',
				fieldLabel: 'Creado por',
				sortable: false,
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
				name: 'id_usuario_ai',
				fieldLabel: 'Creado por',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
				type:'Field',
				filters:{pfiltro:'mdt.id_usuario_ai',type:'numeric'},
				id_grupo:1,
				grid:false,
				form:false
		},
		{
			config:{
				name: 'fecha_mod',
				fieldLabel: 'Fecha Modif.',
				allowBlank: true,
				sortable: false,
				anchor: '80%',
				gwidth: 100,
							format: 'd/m/Y', 
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
			},
				type:'DateField',
				filters:{pfiltro:'mdt.fecha_mod',type:'date'},
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
				sortable: false,
				gwidth: 100,
				maxLength:4
			},
				type:'Field',
				filters:{pfiltro:'usu2.cuenta',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		}
	],
	tam_pag:50,	
	title:'Detalle de Memoria',
	ActSave:'../../sis_presupuestos/control/MemoriaDet/insertarMemoriaDet',
	ActDel:'../../sis_presupuestos/control/MemoriaDet/eliminarMemoriaDet',
	ActList:'../../sis_presupuestos/control/MemoriaDet/listarMemoriaDet',
	id_store:'id_memoria_det',
	fields: [
		{name:'id_memoria_det', type: 'numeric'},
		{name:'importe', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'id_periodo', type: 'numeric'},
		{name:'id_memoria_calculo', type: 'numeric'},
		{name:'usuario_ai', type: 'string'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		'desc_periodo',
		{name:'cantidad_mem', type: 'numeric'},
		{name:'importe_unitario', type: 'numeric'},'unidad_medida','tipo_reg'

		
	],
	sortInfo:{
		field: 'id_memoria_det',
		direction: 'ASC'
	},
	onReloadPage:function(m){
		this.maestro=m;
        this.store.baseParams={id_memoria_calculo:this.maestro.id_memoria_calculo};
        this.load({params:{start:0, limit:50}});  
    },
    loadValoresIniciales:function()
    {
        Phx.vista.MemoriaDet.superclass.loadValoresIniciales.call(this);
        this.Cmp.id_memoria_calculo.setValue(this.maestro.id_memoria_calculo);       
    },
    successSave:function(resp){

    	 Phx.vista.MemoriaDet.superclass.successSave.call(this,resp);
    	 Phx.CP.getPagina(this.idContenedorPadre).reload();
		 Phx.CP.getPagina(Phx.CP.getPagina(this.idContenedorPadre).idContenedorPadre).reload();
    },
    
    iniciarEventos:function(){
    	this.grid.on('afteredit',function(e){
			 e.record.set( 'cantidad_mem', parseInt(e.record.data.cantidad_mem));
			 e.record.set( 'importe_unitario', parseInt(e.record.data.importe_unitario));
    		 this.calculaTotal(e);
    	}, this);
    	
    },
    
    calculaTotal: function(e){
		console.log('IMPORTE: ',e.record.data.cantidad_mem, e.record.data.importe_unitario);
    	var tot = Number(e.record.data.cantidad_mem) * Number(e.record.data.importe_unitario);
    	e.record.set( 'importe', tot );
    	e.record.markDirty();
    },
    
    bnew: false,
    bedit: false,
	bdel: false,
	bsave: true
	}
)
</script>
		
		