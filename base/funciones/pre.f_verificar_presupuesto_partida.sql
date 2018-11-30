CREATE OR REPLACE FUNCTION pre.f_verificar_presupuesto_partida (
  p_id_presupuesto integer,
  p_id_partida integer,
  p_id_moneda integer,
  p_monto_total numeric,
  p_resp_com varchar = 'no'::character varying,
  p_tipo_cambio numeric = NULL::numeric
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
  v_id_moneda_base	integer;
  v_monto_mb  		numeric;
  v_verif_pres      varchar[];
  v_disponible		numeric;
  v_gestion			integer;
  
BEGIN

v_nombre_funcion = 'pre.f_verificar_presupuesto_partida';

  v_sincronizar=pxp.f_get_variable_global('sincronizar');
  
  
  select 
    p.gestion::integer
  into
    v_gestion
  from pre.vpresupuesto_cc p
  where p.id_presupuesto = p_id_presupuesto::integer ;
  
  IF(v_sincronizar='true' and v_gestion::integer <= 2016::integer)THEN
  	
      --si la sincronizacion esta activa busca lso datos en endesis
      v_conexion:=migra.f_obtener_cadena_conexion();
      v_consulta:='select presto."f_i_ad_verificarPresupuestoPartida" ('||p_id_presupuesto||','||p_id_partida||','||p_id_moneda||','||p_monto_total||')';
      select into verificado * from dblink(v_conexion,v_consulta,true) as (verificado numeric[]);
    
    
        
      
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
  
  
  
  ELSE 
    --  si la sincronizacion no esta activa busca en el sistema de presupeusto local en PXP
       
           v_id_moneda_base = param.f_get_moneda_base();
            
           IF  v_id_moneda_base != p_id_moneda THEN
                  -- tenemos tipo de cambio
                  -- si el tipo de cambio es null utilza el cambio oficial para la fecha
                  v_monto_mb  =   param.f_convertir_moneda (                             
                             p_id_moneda, 
                             v_id_moneda_base,  
                             p_monto_total, 
                             now()::date,
                             'CUS',50, 
                             p_tipo_cambio, 'no');
     
           ELSE
              v_monto_mb = p_monto_total;
           END IF;
      
      
    
          
                                         
                                            
                 IF p_monto_total = 121450.00 THEN
                  --  raise exception ' %  xx ... %, zz   % ,yy % ,xx %',p_id_moneda,  p_id_presupuesto, p_id_partida, v_monto_mb, p_monto_total;
                 END  IF;
            
         
    
            v_verif_pres  =  pre.f_verificar_presupuesto_individual(
                                NULL, 
                                NULL, 
                                p_id_presupuesto, 
                                p_id_partida, 
                                v_monto_mb, 
                                p_monto_total, 
                                'comprometido');
/*if p_id_presupuesto = 4606 then
	raise exception 'revisando presupuesto ....%, %, %, %',p_id_presupuesto, 
                                                          p_id_partida, 
                                                          v_monto_mb, 
                                                          p_monto_total;
end if;*/
                                
           IF p_resp_com = 'no' THEN
                if v_verif_pres[1]= 'true' then
                  v_resp:='true';
                else
                 v_resp:='false'; 
                end if;
          
           ELSE
            
                 IF  v_id_moneda_base != p_id_moneda THEN
                  
                     v_disponible  =   param.f_convertir_moneda (
                                           p_id_moneda,
                                           v_id_moneda_base,    
                                           v_verif_pres[2]::numeric, 
                                           now()::date,
                                           'O',50);
                                           
                 else
                    v_disponible   =  v_verif_pres[2]::numeric;                       
                 
                 END IF;
                 
                 
                 if v_verif_pres[1] = 'true' then
                   v_resp:='true'||','||v_disponible::varchar;
                 else
                   v_resp:='false'||','||v_disponible::varchar;
                 end if;
                 
            END IF;                   
          
  
  
  END IF;

   -- raise exception '...verifica %', v_monto_mb;
  
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