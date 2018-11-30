CREATE OR REPLACE FUNCTION pre.f_rep_define_nivel (
  p_id_gestion integer,
  p_nivel integer,
  p_id_partida_fk integer
)
RETURNS void AS
$body$
  DECLARE


    v_parametros  		record;
    v_registros 		record;
    v_nombre_funcion   	text;
    v_resp				varchar;
    v_nivel				integer;
    v_suma				numeric;
    v_mayor				numeric;
    va_mayor			numeric[];
    v_id_gestion  		integer;
    va_tipo_cuenta		varchar[];
    v_gestion 			integer;
    v_sw_force			boolean;


  BEGIN
    
  
     IF p_id_partida_fk is null THEN
  
      for v_registros in ( select           
                *           
           from pre.tpartida par
           where     par.id_gestion = p_id_gestion
                 and par.id_partida_fk is null) LOOP
                 
                update pre.tpartida set 
                    nivel_partida = 1 
                where id_partida = v_registros.id_partida;  
                
                PERFORM  pre.f_rep_define_nivel(p_id_gestion, 2,v_registros.id_partida );
                 
                 
        end loop;
           
    ELSE
    
         for v_registros in ( select           
                *           
           from pre.tpartida par
           where     par.id_gestion = p_id_gestion
                 and par.id_partida_fk = p_id_partida_fk ) LOOP
                 
                update pre.tpartida set 
                    nivel_partida = p_nivel 
                where id_partida = v_registros.id_partida;  
                
                 PERFORM pre.f_rep_define_nivel(p_id_gestion, p_nivel + 1,v_registros.id_partida );
                 
                 
        end loop;
    
    END If;
           
             

      


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