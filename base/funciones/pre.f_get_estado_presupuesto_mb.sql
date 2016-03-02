
CREATE OR REPLACE FUNCTION pre.f_get_estado_presupuesto_mb (
  p_id_presupuesto integer,
  p_id_partida integer,
  p_tipo_movimiento varchar,
  p_nro_tramite varchar = 'TODOS'::character varying
)
RETURNS numeric AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Presupuesto
 FUNCION: 		pre.f_get_estado_presupuesto_mb
 DESCRIPCION:    
 AUTOR: 		 RAC (KPLIAN)
 FECHA:	        29-02-2016 19:40:34
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:	
 AUTOR:			
 FECHA:		
***************************************************************************/

DECLARE

v_resp				varchar;
v_nombre_funcion	varchar;
v_importe			numeric;
 

BEGIN

      v_nombre_funcion = 'pre.f_get_estado_presupuesto_mb';

     

   
     -- si no tenemos numero de tramite
     IF  COALESCE(p_nro_tramite,'TODOS')  = 'TODOS' THEN
          
            select
                 sum(COALESCE(pe.monto_mb,0))
            into
                v_importe     
            from pre.tpartida_ejecucion pe
            where pe.id_presupuesto = p_id_presupuesto
                  and pe.id_partida = p_id_partida
                  and pe.tipo_movimiento = p_tipo_movimiento
                  and pe.estado_reg = 'activo';
      
      ELSE          
             select
                 sum(COALESCE(pe.monto_mb,0))
            into
                v_importe     
            from pre.tpartida_ejecucion pe
            where pe.id_presupuesto = p_id_presupuesto
                  and pe.id_partida = p_id_partida
                  and pe.tipo_movimiento = p_tipo_movimiento
                  and pe.nro_tramite = p_nro_tramite
                  and pe.estado_reg = 'activo';
      END IF;
      
      return COALESCE(v_importe,0);
      
      
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
STABLE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;