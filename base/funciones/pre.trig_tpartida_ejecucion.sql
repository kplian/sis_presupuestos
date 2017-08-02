--------------- SQL ---------------

CREATE OR REPLACE FUNCTION pre.trig_tpartida_ejecucion (
)
RETURNS trigger AS
$body$
DECLARE
  
BEGIN

  IF TG_OP = 'INSERT' THEN
     
     
     --revisamos si la partida ya existe en la tabla presu partida
      
     IF not exists (select
                    1
                 from pre.tpresup_partida pp
                 where      pp.id_presupuesto = NEW.id_presupuesto
                       and  pp.id_partida = NEW.id_partida) THEN
           
                  INSERT INTO pre.tpresup_partida
                              (
                                id_usuario_reg,
                                fecha_reg,
                                estado_reg,
                                id_presupuesto,
                                id_partida,
                                id_centro_costo,
                                importe,
                                importe_aprobado
                              )
                              VALUES (
                                NEW.id_usuario_reg,
                                NEW.fecha_reg,
                                'activo',
                                NEW.id_presupuesto,
                                NEW.id_partida,
                                NEW.id_presupuesto,
                                0,
                                0
                              );
  
     END IF; 
     


  END IF;   
 
   
  RETURN NULL;
  
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;