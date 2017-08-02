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
Phx.vista.RelPreInicio = {
   
	require: '../../../sis_presupuestos/vista/rel_pre/RelPre.php',
	requireclase: 'Phx.vista.RelPre',
	title: 'Compisición',
	nombreVista: 'RelPreInicio',
	
	constructor: function(config) {
	    Phx.vista.RelPreInicio.superclass.constructor.call(this,config);
        
     }
   
    
};
</script>
