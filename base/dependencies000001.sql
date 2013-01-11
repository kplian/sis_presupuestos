/***********************************I-DEP-RCM-PRE-0-11/01/2013*****************************************/

alter table pre.tpartida
add CONSTRAINT fk_tpartida__id_partida_fk FOREIGN KEY (id_partida_fk)
  	REFERENCES pre.tpartida (id_partida) MATCH SIMPLE
    ON UPDATE NO ACTION ON DELETE NO ACTION

alter table pre.tpresup_partida
add CONSTRAINT fk_tpresup_partida__id_presupuesto FOREIGN KEY (id_presupuesto)
    REFERENCES pre.tpresupuesto (id_presupuesto) MATCH SIMPLE
    ON UPDATE NO ACTION ON DELETE NO ACTION;

alter table pre.tpresup_partida
add CONSTRAINT fk_tpresup_partida__id_partida FOREIGN KEY (id_partida)
    REFERENCES pre.tpartida (id_partida) MATCH SIMPLE
    ON UPDATE NO ACTION ON DELETE NO ACTION;
    
/*alter table pre.tpresup_partida
add CONSTRAINT fk_tpresup_partida__id_centro_costo FOREIGN KEY (id_centro_costo)
    REFERENCES gem.tcentro_costo (id_centro_costo) MATCH SIMPLE
    ON UPDATE NO ACTION ON DELETE NO ACTION;*/
    
alter table pre.tpresup_partida
add CONSTRAINT fk_tpresup_partida__id_moneda FOREIGN KEY (id_moneda)
    REFERENCES param.tmoneda (id_moneda) MATCH SIMPLE
    ON UPDATE NO ACTION ON DELETE NO ACTION;

/***********************************F-DEP-RCM-PRE-0-11/01/2013*****************************************/
