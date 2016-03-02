<?php
/**
*@package pXP
*@file gen-SistemaDist.php
*@author  (fprudencio)
*@date 20-09-2011 10:22:05
*@description Archivo con la interfaz de usuario que permite 
*dar el visto a solicitudes de compra
*
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.PresupuestoReporte = {
    bedit:true,
    bnew:false,
    bsave:false,
    bdel:true,
	require:'../../../sis_presupuestos/vista/presupuesto/Presupuesto.php',
	requireclase:'Phx.vista.Presupuesto',
	title:'Presupuesto',
	nombreVista: 'PresupuestoReporte',
	
	swEstado : 'borrador',
    
	
	constructor: function(config) {
	   this.initButtons=[this.cmbGestion, this.cmbTipoPres];
	   Phx.vista.PresupuestoReporte.superclass.constructor.call(this,config);
       this.bloquearOrdenamientoGrid();
	   this.cmbGestion.on('select', function(){
		    
		    if(this.validarFiltros()){
                  this.capturaFiltros();
           }
		    
		    
		},this);
		
		this.bloquearOrdenamientoGrid();

		this.cmbTipoPres.on('clearcmb', function() {
				this.DisableSelect();
				this.store.removeAll();
			}, this);

		this.cmbTipoPres.on('valid', function() {
				this.capturaFiltros();

			}, this);
			
		this.init();
   },
   cmbGestion: new Ext.form.ComboBox({
				fieldLabel: 'Gestion',
				grupo:[0,1,2],
				allowBlank: false,
				emptyText:'Gestion...',
				store:new Ext.data.JsonStore(
				{
					url: '../../sis_parametros/control/Gestion/listarGestion',
					id: 'id_gestion',
					root: 'datos',
					sortInfo:{
						field: 'gestion',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_gestion','gestion'],
					// turn on remote sorting
					remoteSort: true,
					baseParams:{par_filtro:'gestion'}
				}),
				valueField: 'id_gestion',
				triggerAction: 'all',
				displayField: 'gestion',
			    hiddenName: 'id_gestion',
    			mode:'remote',
				pageSize:50,
				queryDelay:500,
				listWidth:'280',
				width:80
			}),	
	
	cmbTipoPres: new Ext.form.AwesomeCombo({
				fieldLabel: 'Tipo',
				grupo:[0,1,2],
				allowBlank: false,
				emptyText:'Filtro...',
				store : new Ext.data.JsonStore({
							url:'../../sis_presupuestos/control/TipoPresupuesto/listarTipoPresupuesto',
							id : 'codigo',
							root: 'datos',
							sortInfo:{
									field: 'codigo',
									direction: 'ASC'
							},
							totalProperty: 'total',
							fields: ['codigo', 'nombre', 'movimiento'],
							remoteSort: true,
							baseParams: { par_filtro:'nombre' }
				}),
				valueField : 'codigo',
			    displayField : 'nombre',
			    hiddenName : 'codigo',
				enableMultiSelect : true,
				triggerAction : 'all',
				lazyRender : true,
				mode : 'remote',
				pageSize : 20,
				width : 150,
				anchor : '80%',
				listWidth : '280',
				resizable : true,
				minChars : 2
			}),	
	
	validarFiltros:function(){
        if(this.cmbGestion.isValid() && this.cmbTipoPres.validate()){
            return true;
        }
        else{
            return false;
        }
        
    },
    
    getParametrosFiltro: function(){
    	this.store.baseParams.id_gestion=this.cmbGestion.getValue();
        this.store.baseParams.codigos_tipo_pres = this.cmbTipoPres.getValue();
        this.store.baseParams.tipo_interfaz = this.nombreVista;
    },
	
	capturaFiltros:function(combo, record, index){
		
		this.desbloquearOrdenamientoGrid();
        this.getParametrosFiltro();
        this.load({params:{start:0, limit:50}});
	},
	
	
	
	onButtonAct:function(){
        if(!this.validarFiltros()){
            alert('Especifique los filtros antes')
         }
        else{
            this.getParametrosFiltro();
            Phx.vista.Presupuesto.superclass.onButtonAct.call(this);
        }
    },
    
   
	
   
    
    tabeast:[
          {
    		  url:'../../../sis_presupuestos/vista/presup_partida/PresupPartidaEstado.php',
    		  title:'Partidas', 
    		  width:'70%',
    		  cls:'PresupPartidaEstado'
		  }],
	
    
   
    
};
</script>
