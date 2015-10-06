--------------- SQL ---------------

CREATE OR REPLACE FUNCTION pre.f_verificar_presupuesto_partida (
  p_id_presupuesto integer,
  p_id_partida integer,
  p_id_moneda integer,
  p_monto_total numeric,
  p_resp_com varchar = 'no'::character varying
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Presupuestos
 FUNCION: 		pre.f_verificar_presupuesto_partida
 DESCRIPCION:   Funcion que llama a la funcion presto.f_i_ad_verificarPresupuestoPartida" mediante dblink
 AUTOR: 		Gonzalo Sarmiento Sejas
 FECHA:	        13-03-2013
 COMENTARIOS:	
***************************************************************************/


DECLARE
  verificado numeric[];
  v_consulta varchar;
  v_conexion varchar;
  v_resp	varchar;
  v_sincronizar varchar;
 
  
  v_nombre_funcion  varchar;
BEGIN

v_nombre_funcion = 'pre.f_verificar_presupuesto_partida';

  v_sincronizar=pxp.f_get_variable_global('sincronizar');
  
  IF(v_sincronizar='true')THEN
  	
      --si la sincronizacion esta activa busca lso datos en endesis
      v_conexion:=migra.f_obtener_cadena_conexion();
      v_consulta:='select presto."f_i_ad_verificarPresupuestoPartida" ('||p_id_presupuesto||','||p_id_partida||','||p_id_moneda||','||p_monto_total||')';
      select into verificado * from dblink(v_conexion,v_consulta,true) as (verificado numeric[]);
    
    
       --raise exception '% %',v_consulta,v_conexion;
  
  
  ELSE 
    --TO DO,   si la sincronizacion no esta activa busca en el sistema de presupeusto local en PXP
  
     raise exception 'Verificacion   presupuestaria en PXP no implementada';
  
  
  
  END IF;

  IF p_resp_com = 'no' THEN
    if verificado[1]=0 then
      v_resp:='false';
    else
     v_resp:='true'; 
    end if;
  ELSE
    if verificado[1]=0 then
      v_resp:='false'||','||verificado[2];
    else
     v_resp:='true'||','||verificado[2]; 
    end if;
  END IF;
  
  return v_resp;


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
COST 100;