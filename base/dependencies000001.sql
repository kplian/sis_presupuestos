/***********************************I-DEP-RCM-PRE-0-11/01/2013*****************************************/

alter table pre.tpartida
add CONSTRAINT fk_tpartida__id_partida_fk FOREIGN KEY (id_partida_fk)
  	REFERENCES pre.tpartida (id_partida) MATCH SIMPLE
    ON UPDATE NO ACTION ON DELETE NO ACTION;

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

/***********************************I-DEP-GSS-PRE-0-26/02/2013*****************************************/

ALTER TABLE pre.tpresupuesto
  ADD CONSTRAINT fk_tpresupuesto__id_centro_costo FOREIGN KEY (id_centro_costo)
    REFERENCES param.tcentro_costo(id_centro_costo) MATCH SIMPLE
    ON DELETE NO ACTION ON UPDATE NO ACTION;

/***********************************F-DEP-GSS-PRE-0-26/02/2013*****************************************/

/***********************************I-DEP-JRR-PRE-0-24/04/2014*****************************************/
select pxp.f_insert_testructura_gui ('CINGAS.1', 'CINGAS');
select pxp.f_insert_testructura_gui ('CINGAS.2', 'CINGAS');
select pxp.f_insert_testructura_gui ('CINGAS.3', 'CINGAS');
select pxp.f_insert_tprocedimiento_gui ('PRE_PAR_INS', 'PRE.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PRE_PAR_MOD', 'PRE.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PRE_PAR_ELI', 'PRE.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PRE_PAR_ARB_SEL', 'PRE.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_GES_SEL', 'PRE.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CEC_SEL', 'PRE.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CECCOM_SEL', 'PRE.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CECCOMFU_SEL', 'PRE.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CCFILDEP_SEL', 'PRE.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PRE_PRE_INS', 'PRE.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PRE_PRE_MOD', 'PRE.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PRE_PRE_ELI', 'PRE.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PRE_PRE_SEL', 'PRE.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PRE_PAR_SEL', 'CCTA', 'no');
select pxp.f_insert_tprocedimiento_gui ('PRE_PAR_ARB_SEL', 'CCTA', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_CTA_SEL', 'CCTA', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_CTA_ARB_SEL', 'CCTA', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_AUXCTA_SEL', 'CCTA', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CEC_SEL', 'CCTA', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CECCOM_SEL', 'CCTA', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CECCOMFU_SEL', 'CCTA', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CCFILDEP_SEL', 'CCTA', 'no');
select pxp.f_insert_tprocedimiento_gui ('PRE_CCTA_INS', 'CCTA', 'no');
select pxp.f_insert_tprocedimiento_gui ('PRE_CCTA_MOD', 'CCTA', 'no');
select pxp.f_insert_tprocedimiento_gui ('PRE_CCTA_ELI', 'CCTA', 'no');
select pxp.f_insert_tprocedimiento_gui ('PRE_CCTA_SEL', 'CCTA', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_GES_SEL', 'CCTA', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CONIG_INS', 'CINGAS', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CONIG_MOD', 'CINGAS', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CONIG_ELI', 'CINGAS', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CONIG_SEL', 'CINGAS', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CONIGPP_SEL', 'CINGAS', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CATCMB_SEL', 'CINGAS', 'no');
select pxp.f_insert_tprocedimiento_gui ('PRE_PAR_SEL', 'CINGAS.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PRE_PAR_ARB_SEL', 'CINGAS.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PRE_CONP_INS', 'CINGAS.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PRE_CONP_MOD', 'CINGAS.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PRE_CONP_ELI', 'CINGAS.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PRE_CONP_SEL', 'CINGAS.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PRE_PAR_SEL', 'CINGAS.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PRE_PAR_ARB_SEL', 'CINGAS.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_CTA_SEL', 'CINGAS.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_CTA_ARB_SEL', 'CINGAS.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_AUXCTA_SEL', 'CINGAS.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CEC_SEL', 'CINGAS.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CECCOM_SEL', 'CINGAS.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CECCOMFU_SEL', 'CINGAS.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CCFILDEP_SEL', 'CINGAS.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PRE_CCTA_INS', 'CINGAS.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PRE_CCTA_MOD', 'CINGAS.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PRE_CCTA_ELI', 'CINGAS.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PRE_CCTA_SEL', 'CINGAS.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_GES_SEL', 'CINGAS.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_SUBSIS_SEL', 'CINGAS.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PACATI_SEL', 'CINGAS.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CAT_INS', 'CINGAS.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CAT_MOD', 'CINGAS.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CAT_ELI', 'CINGAS.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CAT_SEL', 'CINGAS.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CATCMB_SEL', 'CINGAS.3', 'no');

/***********************************F-DEP-JRR-PRE-0-24/04/2014*****************************************/

/***********************************I-DEP-JRR-PRE-0-29/05/2014*****************************************/
ALTER TABLE pre.tpr_presupuesto_ids
  ADD  CONSTRAINT fk_tpr_presupuesto_ids__id_presupuesto_uno FOREIGN KEY (id_presupuesto_uno)
    REFERENCES pre.tpresupuesto(id_presupuesto)
    ON DELETE NO ACTION ON UPDATE NO ACTION;
    
ALTER TABLE pre.tpr_presupuesto_ids
  ADD  CONSTRAINT tpr_presupuesto_ids_fk FOREIGN KEY (id_presupuesto_dos)
    REFERENCES pre.tpresupuesto(id_presupuesto)
    ON DELETE NO ACTION  ON UPDATE NO ACTION;

/***********************************F-DEP-JRR-PRE-0-29/05/2014*****************************************/
