--------------- SQL ---------------

CREATE OR REPLACE FUNCTION pre.f_verificar_com_eje_pag (
  p_id_partida_ejecucion integer,
  p_id_moneda integer,
  out ps_comprometido numeric,
  out ps_ejecutado numeric,
  out ps_pagado numeric
)
RETURNS SETOF record AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Presupuestos
 FUNCION: 		pre.f_verificar_com_eje_pag
 DESCRIPCION:   Funcion que verifica:
                   el saldo comprometido,
                   monto ejecutado
                   monto pagado 
                   
 AUTOR: 		Rensi Aarteaga Copari
 FECHA:	        04-07-2013
 COMENTARIOS:	
***************************************************************************/


DECLARE
  verificado  record;
  v_consulta varchar;
  v_conexion varchar;
  v_resp	varchar;
  v_sincronizar varchar;
 
  
  v_nombre_funcion  varchar;
BEGIN

v_nombre_funcion = 'pre.f_verificar_com_eje_pag';

  v_sincronizar=pxp.f_get_variable_global('sincronizar');
  
  IF(v_sincronizar='true')THEN
  	
    --si la sincronizacion esta activa busca lso datos en endesis
    v_conexion:=migra.f_obtener_cadena_conexion();
  	
    v_consulta:='select  p_comprometido, p_ejecutado, p_pagado from   presto."f_pr_verificar_comprometido3" ('||COALESCE(p_id_partida_ejecucion::varchar,'NULL')||','||COALESCE(p_id_moneda::varchar,'NULL')||')';
  	select  * into verificado from dblink(v_conexion,v_consulta,true) as (p_comprometido numeric, p_ejecutado numeric, p_pagado numeric);
  
  
  --raise exception '% %',v_consulta,v_conexion;
  
  
  ELSE 
    --TO DO,   si la sincronizacion no esta activa busca en el sistema de presupeusto local en PXP
  
     raise exception 'Verificacion   presupuestaria en PXP no implementada';
  
  
  
  END IF;
  
 

   ps_comprometido= verificado.p_comprometido;
   ps_ejecutado= verificado.p_ejecutado;
   ps_pagado= verificado.p_pagado;

  
  return NEXT;
  return;


EXCEPTION
					
	WHEN OTHERS THEN
			v_resp='';
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje',SQLERRM);
			v_resp = pxp.f_agrega_clave(v_resp,'codigo_error',SQLSTATE);
			v_resp = pxp.f_agrega_clave(v_resp,'procedimientos',v_nombre_funcion);
			raise exception '%',v_resp;
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100 ROWS 1000;