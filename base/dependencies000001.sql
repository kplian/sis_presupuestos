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
ALTER TABLE pre.tpresupuesto_ids
  ADD  CONSTRAINT fk_tpr_presupuesto_ids__id_presupuesto_uno FOREIGN KEY (id_presupuesto_uno)
    REFERENCES pre.tpresupuesto(id_presupuesto)
    ON DELETE NO ACTION ON UPDATE NO ACTION;
    
ALTER TABLE pre.tpresupuesto_ids
  ADD  CONSTRAINT tpr_presupuesto_ids_fk FOREIGN KEY (id_presupuesto_dos)
    REFERENCES pre.tpresupuesto(id_presupuesto)
    ON DELETE NO ACTION  ON UPDATE NO ACTION;

/***********************************F-DEP-JRR-PRE-0-29/05/2014*****************************************/


/***********************************I-DEP-JRR-PRE-0-05/01/2014*****************************************/
CREATE OR REPLACE VIEW pre.vpresupuesto_cc(
    id_centro_costo,
    estado_reg,
    id_ep,
    id_gestion,
    id_uo,
    id_usuario_reg,
    fecha_reg,
    id_usuario_mod,
    fecha_mod,
    usr_reg,
    usr_mod,
    codigo_uo,
    nombre_uo,
    ep,
    gestion,
    codigo_cc,
    nombre_programa,
    nombre_proyecto,
    nombre_actividad,
    nombre_financiador,
    nombre_regional,
    tipo_pres,
    cod_act,
    cod_fin,
    cod_prg,
    cod_pry,
    estado_pres)
AS
  SELECT cec.id_centro_costo,
         cec.estado_reg,
         cec.id_ep,
         cec.id_gestion,
         cec.id_uo,
         cec.id_usuario_reg,
         cec.fecha_reg,
         cec.id_usuario_mod,
         cec.fecha_mod,
         usu1.cuenta AS usr_reg,
         usu2.cuenta AS usr_mod,
         uo.codigo AS codigo_uo,
         uo.nombre_unidad AS nombre_uo,
         ep.ep,
         ges.gestion,
         (((cp.descripcion || '-(' ::text) || ges.gestion) || ') Id: ' ::text)
          || cec.id_centro_costo::text AS codigo_cc,
         ep.nombre_programa,
         ep.nombre_proyecto,
         ep.nombre_actividad,
         ep.nombre_financiador,
         ep.nombre_regional,
         pre.tipo_pres,
         pre.cod_act,
         pre.cod_fin,
         pre.cod_prg,
         pre.cod_pry,
         pre.estado_pres
  FROM param.tcentro_costo cec
       JOIN segu.tusuario usu1 ON usu1.id_usuario = cec.id_usuario_reg
       LEFT JOIN segu.tusuario usu2 ON usu2.id_usuario = cec.id_usuario_mod
       JOIN param.vep ep ON ep.id_ep = cec.id_ep
       JOIN param.tgestion ges ON ges.id_gestion = cec.id_gestion
       JOIN orga.tuo uo ON uo.id_uo = cec.id_uo
       JOIN pre.tpresupuesto pre ON pre.id_centro_costo = cec.id_centro_costo
       JOIN pre.tcategoria_programatica cp ON cp.id_categoria_programatica =
        pre.id_categoria_prog;
        
/***********************************F-DEP-JRR-PRE-0-05/01/2014*****************************************/



/***********************************I-DEP-JRR-PRE-0-30/05/2015*****************************************/



CREATE OR REPLACE VIEW pre.vpresupuesto_cc(
    id_centro_costo,
    estado_reg,
    id_ep,
    id_gestion,
    id_uo,
    id_usuario_reg,
    fecha_reg,
    id_usuario_mod,
    fecha_mod,
    usr_reg,
    usr_mod,
    codigo_uo,
    nombre_uo,
    ep,
    gestion,
    codigo_cc,
    nombre_programa,
    nombre_proyecto,
    nombre_actividad,
    nombre_financiador,
    nombre_regional,
    tipo_pres,
    cod_act,
    cod_fin,
    cod_prg,
    cod_pry,
    estado_pres)
AS
  SELECT cec.id_centro_costo,
         cec.estado_reg,
         cec.id_ep,
         cec.id_gestion,
         cec.id_uo,
         cec.id_usuario_reg,
         cec.fecha_reg,
         cec.id_usuario_mod,
         cec.fecha_mod,
         usu1.cuenta AS usr_reg,
         usu2.cuenta AS usr_mod,
         uo.codigo AS codigo_uo,
         uo.nombre_unidad AS nombre_uo,
         ep.ep,
         ges.gestion,
         CASE
           WHEN cp.descripcion IS NOT NULL THEN (((cp.descripcion || '-('::text)
             || ges.gestion) || ') Id: '::text) || cec.id_centro_costo::text
           ELSE (((uo.codigo::text || '-('::text) || ep.ep) || ') Id: '::text)
             || cec.id_centro_costo::text
         END AS codigo_cc,
         ep.nombre_programa,
         ep.nombre_proyecto,
         ep.nombre_actividad,
         ep.nombre_financiador,
         ep.nombre_regional,
         pre.tipo_pres,
         pre.cod_act,
         pre.cod_fin,
         pre.cod_prg,
         pre.cod_pry,
         pre.estado_pres
  FROM param.tcentro_costo cec
       JOIN segu.tusuario usu1 ON usu1.id_usuario = cec.id_usuario_reg
       LEFT JOIN segu.tusuario usu2 ON usu2.id_usuario = cec.id_usuario_mod
       JOIN param.vep ep ON ep.id_ep = cec.id_ep
       JOIN param.tgestion ges ON ges.id_gestion = cec.id_gestion
       JOIN orga.tuo uo ON uo.id_uo = cec.id_uo
       JOIN pre.tpresupuesto pre ON pre.id_centro_costo = cec.id_centro_costo
       LEFT JOIN pre.tcategoria_programatica cp ON cp.id_categoria_programatica
         = pre.id_categoria_prog;
         
/***********************************F-DEP-JRR-PRE-0-30/05/2015*****************************************/



/***********************************I-DEP-RAC-PRE-0-10/03/2016*****************************************/


CREATE VIEW pre.vmemoria_calculo (
    id_memoria_calculo,
    id_concepto_ingas,
    importe_total,
    obs,
    id_presupuesto,
    id_centro_costo,
    desc_ingas,
    id_partida,
    desc_partida,
    desc_gestion)
AS
SELECT mca.id_memoria_calculo,
    mca.id_concepto_ingas,
    mca.importe_total,
    mca.obs,
    mca.id_presupuesto,
    pre.id_centro_costo,
    cig.desc_ingas,
    par.id_partida,
    ((par.codigo::text || ' - '::text) || par.nombre_partida::text)::character
        varying AS desc_partida,
    ges.gestion::character varying AS desc_gestion
FROM pre.tmemoria_calculo mca
     JOIN pre.tpresupuesto pre ON pre.id_presupuesto = mca.id_presupuesto
     JOIN param.tcentro_costo cc ON cc.id_centro_costo = pre.id_centro_costo
     JOIN param.tconcepto_ingas cig ON cig.id_concepto_ingas = mca.id_concepto_ingas
     JOIN pre.tconcepto_partida cp ON cp.id_concepto_ingas = mca.id_concepto_ingas
     JOIN param.tgestion ges ON ges.id_gestion = cc.id_gestion
     JOIN pre.tpartida par ON par.id_partida = cp.id_partida AND par.id_gestion
         = cc.id_gestion;


CREATE TRIGGER trig_tmemoria_calculo
  AFTER INSERT OR UPDATE OF id_concepto_ingas, importe_total, id_presupuesto OR DELETE 
  ON pre.tmemoria_calculo FOR EACH ROW 
  EXECUTE PROCEDURE pre.trig_tmemoria_calculo();
  
  
/***********************************F-DEP-RAC-PRE-0-10/03/2016*****************************************/




/***********************************I-DEP-RAC-PRE-0-15/03/2016*****************************************/

ALTER TABLE pre.tpartida_ejecucion
  ADD CONSTRAINT tpartida_ejecucion__id_int_comprobante FOREIGN KEY (id_int_comprobante)
    REFERENCES conta.tint_comprobante(id_int_comprobante)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;


--------------- SQL ---------------

ALTER TABLE pre.tpartida_ejecucion
  ADD CONSTRAINT tpartida_ejecucion_fk FOREIGN KEY (id_partida)
    REFERENCES pre.tpartida(id_partida)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
--------------- SQL ---------------

ALTER TABLE pre.tpartida_ejecucion
  ADD CONSTRAINT tpartida_ejecucion__id_presupuesto_fk FOREIGN KEY (id_presupuesto)
    REFERENCES pre.tpresupuesto(id_presupuesto)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;    

--------------- SQL ---------------

ALTER TABLE pre.tpartida_ejecucion
  ADD CONSTRAINT tpartida_ejecucion__id_moenda_fk FOREIGN KEY (id_moneda)
    REFERENCES param.tmoneda(id_moneda)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
--------------- SQL ---------------

ALTER TABLE pre.tpartida_ejecucion
  ADD CONSTRAINT tpartida_ejecucion__id_usuario_ref_fk FOREIGN KEY (id_usuario_reg)
    REFERENCES segu.tusuario(id_usuario)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    

--------------- SQL ---------------

CREATE INDEX tpartida_ejecucion_idx ON pre.tpartida_ejecucion
  USING btree (nro_tramite);
  
--------------- SQL ---------------

CREATE INDEX tpartida_ejecucion__secundario ON pre.tpartida_ejecucion
  USING btree (id_presupuesto, id_partida);
  


--------------- SQL ---------------

ALTER TABLE pre.tpresup_partida
  ADD CONSTRAINT tpresup_partida__id_presupuesto FOREIGN KEY (id_presupuesto)
    REFERENCES pre.tpresupuesto(id_presupuesto)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
    
--------------- SQL ---------------

ALTER TABLE pre.tpresup_partida
  ADD CONSTRAINT tpresup_partida__id_partida_fk FOREIGN KEY (id_partida)
    REFERENCES pre.tpartida(id_partida)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
--------------- SQL ---------------

CREATE INDEX tpresup_partida_secuntdario ON pre.tpresup_partida
  USING btree (id_presupuesto, id_partida);
  
--------------- SQL ---------------

CREATE INDEX tpresup_partida__presupuesto ON pre.tpresup_partida
  USING btree (id_presupuesto);
  
 --------------- SQL ---------------

ALTER TABLE pre.tpresupuesto
  ADD CONSTRAINT tpresupuesto__id_proceso_ef_fk FOREIGN KEY (id_proceso_wf)
    REFERENCES wf.tproceso_wf(id_proceso_wf)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    


--------------- SQL ---------------
CREATE OR REPLACE VIEW pre.vpresup_partida(
    id_presup_partida,
    tipo,
    id_moneda,
    id_partida,
    id_centro_costo,
    fecha_hora,
    estado_reg,
    id_presupuesto,
    importe,
    desc_partida,
    desc_gestion,
    importe_aprobado,
    formulado,
    comprometido,
    ejecutado,
    pagado)
AS
  SELECT prpa.id_presup_partida,
         prpa.tipo,
         prpa.id_moneda,
         prpa.id_partida,
         prpa.id_centro_costo,
         prpa.fecha_hora,
         prpa.estado_reg,
         prpa.id_presupuesto,
         COALESCE(prpa.importe, 0::numeric) AS importe,
         ((('('::text || par.codigo::text) || ') '::text) || par.nombre_partida
           ::text)::character varying AS desc_partida,
         ges.gestion::character varying AS desc_gestion,
         prpa.importe_aprobado,
         pre.f_get_estado_presupuesto_mb(prpa.id_presupuesto, prpa.id_partida,
           'formulado'::character varying) AS formulado,
         pre.f_get_estado_presupuesto_mb(prpa.id_presupuesto, prpa.id_partida,
           'comprometido'::character varying) AS comprometido,
         pre.f_get_estado_presupuesto_mb(prpa.id_presupuesto, prpa.id_partida,
           'ejecutado'::character varying) AS ejecutado,
         pre.f_get_estado_presupuesto_mb(prpa.id_presupuesto, prpa.id_partida,
           'pagado'::character varying) AS pagado
  FROM pre.tpresup_partida prpa
       JOIN pre.tpartida par ON par.id_partida = prpa.id_partida
       JOIN pre.tpresupuesto p ON p.id_presupuesto = prpa.id_presupuesto
       JOIN param.tgestion ges ON ges.id_gestion = par.id_gestion;
         
/***********************************F-DEP-RAC-PRE-0-15/03/2016*****************************************/
