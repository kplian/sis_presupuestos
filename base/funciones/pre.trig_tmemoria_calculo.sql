
CREATE OR REPLACE FUNCTION pre.trig_tmemoria_calculo ()
RETURNS trigger AS
$body$
DECLARE
     v_reg_pres_par 			record;
     v_reg_pres_par_new			record;
     v_reg						record;
     v_id_partida_new			integer;
     v_id_partida_old			integer;
BEGIN
   --     select (current_database()::text)||'_'||NEW.cuenta into g_new_login;
   --   select (current_database()::text)||'_'||OLD.cuenta into g_old_login;
   
   
  
   
   
    IF TG_OP = 'INSERT' THEN
    
           select 
                mc.id_partida
           into
               v_id_partida_new
           FROM pre.vmemoria_calculo mc where mc.id_memoria_calculo = NEW.id_memoria_calculo;
    
   
           select 
             pp.importe,
             pp.id_presup_partida
           into
             v_reg_pres_par
           from pre.tpresup_partida pp
           where pp.id_presupuesto = NEW.id_presupuesto and pp.id_partida = v_id_partida_new;
       
           update pre.tpresup_partida pp set      
              importe = COALESCE(importe,0)  + NEW.importe_total        
           where id_presup_partida = v_reg_pres_par.id_presup_partida;
   
   
   ELSIF TG_OP = 'UPDATE' THEN
   
            select 
                mc.id_partida
           into
               v_id_partida_new
           FROM pre.vmemoria_calculo mc where mc.id_memoria_calculo = NEW.id_memoria_calculo;
           
           
           IF v_id_partida_new is null THEN
             raise exception 'no se encontro la nueva partida ';
           END IF;
           
           select 
                mc.id_partida
           into
               v_id_partida_old
           FROM pre.vmemoria_calculo mc where mc.id_memoria_calculo = OLD.id_memoria_calculo;
           
            IF v_id_partida_old is null THEN
             raise exception 'no se encontro la vieja partida ';
           END IF;
   
           select 
             pp.importe,
             pp.id_presup_partida
           into
             v_reg_pres_par
           from pre.tpresup_partida pp
           where pp.id_presupuesto = OLD.id_presupuesto and pp.id_partida = v_id_partida_old;
           
           IF v_reg_pres_par is null THEN
             raise exception 'no se encontro el la relacion presupuesto partida % , %',OLD.id_presupuesto ,v_id_partida_old ;
           END IF;
           
           
           select 
             pp.importe,
             pp.id_presup_partida
           into
             v_reg_pres_par_new
           from pre.tpresup_partida pp
           where pp.id_presupuesto = NEW.id_presupuesto and pp.id_partida = v_id_partida_new;
       
          update pre.tpresup_partida pp set      
            importe = COALESCE(importe,0) - COALESCE(OLD.importe_total,0)       
          where id_presup_partida = v_reg_pres_par.id_presup_partida;
          
          update pre.tpresup_partida pp set      
            importe = COALESCE(importe,0) + COALESCE(NEW.importe_total,0)       
          where id_presup_partida = v_reg_pres_par_new.id_presup_partida;
      
        
   
   
   ELSEIF TG_OP = 'DELETE' THEN
    
  
          SELECT pre.id_centro_costo,
                 par.id_partida
           into
                v_reg
          FROM pre.tpresupuesto pre 
               JOIN param.tcentro_costo cc ON cc.id_centro_costo = pre.id_centro_costo
               JOIN pre.tconcepto_partida cp ON cp.id_concepto_ingas = OLD.id_concepto_ingas
               JOIN param.tgestion ges ON ges.id_gestion = cc.id_gestion
               JOIN pre.tpartida par ON par.id_partida = cp.id_partida AND par.id_gestion = cc.id_gestion
          WHERE 
               pre.id_presupuesto = OLD.id_presupuesto;
         
           v_id_partida_old = v_reg.id_partida;
    
           
           IF v_id_partida_old is null THEN
             raise exception 'no se encontro la  partida para la memoria %, concepto % y presupuesto %', OLD.id_memoria_calculo, OLD.id_concepto_ingas,OLD.id_presupuesto;
           END IF;
   
           select 
             pp.importe,
             pp.id_presup_partida
           into
             v_reg_pres_par
           from pre.tpresup_partida pp
           where pp.id_presupuesto = OLD.id_presupuesto and pp.id_partida = v_id_partida_old;
           
            IF v_reg_pres_par is null THEN
             raise exception 'no se encontro a relacion partida presupuesto ';
           END IF;
           
          update pre.tpresup_partida pp set      
            importe = COALESCE(importe,0) - COALESCE(OLD.importe_total,0)       
          where id_presup_partida = v_reg_pres_par.id_presup_partida;
         
   END IF;   
 
   
   RETURN NULL;
   
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;