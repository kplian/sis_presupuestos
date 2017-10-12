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


/***********************************I-DEP-RAC-PRE-0-05/04/2016*****************************************/

--------------- SQL ---------------

CREATE INDEX tpartida_ejecucion__id_partida_ejecucion_fk ON pre.tpartida_ejecucion
  USING btree (id_partida_ejecucion_fk);
  


--------------- SQL ---------------

CREATE OR REPLACE VIEW pre.vestado_presupuesto_por_tramite(
    id_presup_partida,
    id_partida,
    id_presupuesto,
    desc_partida,
    id_centro_costo,
    codigo_cc,
    id_gestion,
    id_uo,
    id_ep,
    tipo_pres,
    nro_tramite,
    comprometido,
    ejecutado,
    pagado)
AS
  SELECT DISTINCT pp.id_presup_partida,
         pe.id_partida,
         pe.id_presupuesto,
         (('('::text || par.codigo::text) || ') '::text) || par.nombre_partida::
           text AS desc_partida,
         cc.id_centro_costo,
         cc.codigo_cc,
         cc.id_gestion,
         cc.id_uo,
         cc.id_ep,
         cc.tipo_pres,
         pe.nro_tramite,
         pre.f_get_estado_presupuesto_mb(pe.id_presupuesto, pe.id_partida,
           'comprometido'::character varying, pe.nro_tramite) AS comprometido,
         pre.f_get_estado_presupuesto_mb(pe.id_presupuesto, pe.id_partida,
           'ejecutado'::character varying, pe.nro_tramite) AS ejecutado,
         pre.f_get_estado_presupuesto_mb(pe.id_presupuesto, pe.id_partida,
           'pagado'::character varying, pe.nro_tramite) AS pagado
  FROM pre.tpartida_ejecucion pe
       JOIN pre.tpartida par ON par.id_partida = pe.id_partida
       JOIN pre.vpresupuesto_cc cc ON cc.id_centro_costo = pe.id_presupuesto
       JOIN pre.tpresup_partida pp ON pp.id_partida = pe.id_partida AND
         pp.id_presupuesto = pe.id_presupuesto;
  
/***********************************F-DEP-RAC-PRE-0-05/04/2016*****************************************/

  
  
/***********************************I-DEP-RAC-PRE-0-14/04/2016*****************************************/


--------------- SQL ---------------

DROP VIEW pre.vestado_presupuesto_por_tramite;



  
  CREATE OR REPLACE VIEW pre.vpresupuesto(
    id_presupuesto,
    id_centro_costo,
    codigo_cc,
    tipo_pres,
    estado_pres,
    estado_reg,
    id_usuario_reg,
    fecha_reg,
    fecha_mod,
    id_usuario_mod,
    estado,
    id_estado_wf,
    nro_tramite,
    id_proceso_wf,
    desc_tipo_presupuesto,
    descripcion,
    movimiento_tipo_pres,
    id_gestion)
AS
  SELECT pre.id_presupuesto,
         pre.id_centro_costo,
         vcc.codigo_cc,
         pre.tipo_pres,
         pre.estado_pres,
         pre.estado_reg,
         pre.id_usuario_reg,
         pre.fecha_reg,
         pre.fecha_mod,
         pre.id_usuario_mod,
         pre.estado,
         pre.id_estado_wf,
         pre.nro_tramite,
         pre.id_proceso_wf,
         ((('('::text || tp.codigo::text) || ') '::text) || tp.nombre::text)::
           character varying AS desc_tipo_presupuesto,
         pre.descripcion,
         tp.movimiento AS movimiento_tipo_pres,
         vcc.id_gestion
  FROM pre.tpresupuesto pre
       JOIN pre.ttipo_presupuesto tp ON tp.codigo::text = pre.tipo_pres::text
       JOIN param.vcentro_costo vcc ON vcc.id_centro_costo = pre.id_centro_costo;
  

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
    estado_pres,
    estado,
    id_presupuesto,
    id_estado_wf,
    nro_tramite,
    id_proceso_wf,
    movimiento_tipo_pres,
    desc_tipo_presupuesto,
    sw_oficial,
    sw_consolidado)
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
           WHEN cp.descripcion IS NOT NULL THEN (((((COALESCE(uo.codigo, 's/c'::
             character varying)::text || ' - '::text) || cp.descripcion) ||
             '- ('::text) || ges.gestion) || ') Id: '::text) ||
             cec.id_centro_costo::text
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
         pre.estado_pres,
         pre.estado,
         pre.id_presupuesto,
         pre.id_estado_wf,
         pre.nro_tramite,
         pre.id_proceso_wf,
         tp.movimiento AS movimiento_tipo_pres,
         ((('('::text || tp.codigo::text) || ') '::text) || tp.nombre::text)::
           character varying AS desc_tipo_presupuesto,
         tp.sw_oficial,
         pre.sw_consolidado
  FROM param.tcentro_costo cec
       JOIN segu.tusuario usu1 ON usu1.id_usuario = cec.id_usuario_reg
       LEFT JOIN segu.tusuario usu2 ON usu2.id_usuario = cec.id_usuario_mod
       JOIN param.vep ep ON ep.id_ep = cec.id_ep
       JOIN param.tgestion ges ON ges.id_gestion = cec.id_gestion
       JOIN orga.tuo uo ON uo.id_uo = cec.id_uo
       JOIN pre.tpresupuesto pre ON pre.id_centro_costo = cec.id_centro_costo
       LEFT JOIN pre.tcategoria_programatica cp ON cp.id_categoria_programatica
         = pre.id_categoria_prog
       JOIN pre.ttipo_presupuesto tp ON tp.codigo::text = pre.tipo_pres::text
       JOIN param.vcentro_costo vcc ON vcc.id_centro_costo = pre.id_centro_costo
         ;

CREATE OR REPLACE VIEW pre.vestado_presupuesto_por_tramite(
    id_presup_partida,
    id_partida,
    id_presupuesto,
    desc_partida,
    id_centro_costo,
    codigo_cc,
    id_gestion,
    id_uo,
    id_ep,
    tipo_pres,
    nro_tramite,
    comprometido,
    ejecutado,
    pagado)
AS
  SELECT DISTINCT pp.id_presup_partida,
         pe.id_partida,
         pe.id_presupuesto,
         (('('::text || par.codigo::text) || ') '::text) || par.nombre_partida::
           text AS desc_partida,
         cc.id_centro_costo,
         cc.codigo_cc,
         cc.id_gestion,
         cc.id_uo,
         cc.id_ep,
         cc.tipo_pres,
         pe.nro_tramite,
         pre.f_get_estado_presupuesto_mb(pe.id_presupuesto, pe.id_partida,
           'comprometido'::character varying, pe.nro_tramite) AS comprometido,
         pre.f_get_estado_presupuesto_mb(pe.id_presupuesto, pe.id_partida,
           'ejecutado'::character varying, pe.nro_tramite) AS ejecutado,
         pre.f_get_estado_presupuesto_mb(pe.id_presupuesto, pe.id_partida,
           'pagado'::character varying, pe.nro_tramite) AS pagado
  FROM pre.tpartida_ejecucion pe
       JOIN pre.tpartida par ON par.id_partida = pe.id_partida
       JOIN pre.vpresupuesto_cc cc ON cc.id_centro_costo = pe.id_presupuesto
       JOIN pre.tpresup_partida pp ON pp.id_partida = pe.id_partida AND
         pp.id_presupuesto = pe.id_presupuesto;
           
/***********************************F-DEP-RAC-PRE-0-14/04/2016*****************************************/

  
  
/***********************************I-DEP-RAC-PRE-0-19/04/2016*****************************************/

 
 CREATE OR REPLACE VIEW pre.vcategoria_programatica(
    id_categoria_programatica,
    id_cp_actividad,
    id_gestion,
    id_cp_organismo_fin,
    descripcion,
    id_cp_programa,
    id_cp_fuente_fin,
    estado_reg,
    id_cp_proyecto,
    id_usuario_ai,
    fecha_reg,
    usuario_ai,
    id_usuario_reg,
    fecha_mod,
    id_usuario_mod,
    usr_reg,
    usr_mod,
    codigo_programa,
    codigo_proyecto,
    codigo_actividad,
    codigo_fuente_fin,
    codigo_origen_fin,
    desc_programa,
    desc_proyecto,
    desc_actividad,
    desc_fuente_fin,
    desc_origen_fin,
    codigo_categoria,
    gestion)
AS
  SELECT cpr.id_categoria_programatica,
         cpr.id_cp_actividad,
         cpr.id_gestion,
         cpr.id_cp_organismo_fin,
         cpr.descripcion,
         cpr.id_cp_programa,
         cpr.id_cp_fuente_fin,
         cpr.estado_reg,
         cpr.id_cp_proyecto,
         cpr.id_usuario_ai,
         cpr.fecha_reg,
         cpr.usuario_ai,
         cpr.id_usuario_reg,
         cpr.fecha_mod,
         cpr.id_usuario_mod,
         usu1.cuenta AS usr_reg,
         usu2.cuenta AS usr_mod,
         pro.codigo AS codigo_programa,
         pry.codigo AS codigo_proyecto,
         act.codigo AS codigo_actividad,
         ffi.codigo AS codigo_fuente_fin,
         ofi.codigo AS codigo_origen_fin,
         pro.descripcion AS desc_programa,
         pry.descripcion AS desc_proyecto,
         act.descripcion AS desc_actividad,
         ffi.descripcion AS desc_fuente_fin,
         ofi.descripcion AS desc_origen_fin,
         ((((((((pro.codigo::text || ' - '::text) || pry.codigo::text) || ' - '
           ::text) || act.codigo::text) || ' - '::text) || ffi.codigo::text) ||
           ' - '::text) || ofi.codigo::text)::character varying AS
           codigo_categoria,
         ges.gestion
  FROM pre.tcategoria_programatica cpr
       JOIN param.tgestion ges ON ges.id_gestion = cpr.id_gestion
       JOIN segu.tusuario usu1 ON usu1.id_usuario = cpr.id_usuario_reg
       JOIN pre.tcp_programa pro ON pro.id_cp_programa = cpr.id_cp_programa
       JOIN pre.tcp_proyecto pry ON pry.id_cp_proyecto = cpr.id_cp_proyecto
       JOIN pre.tcp_actividad act ON act.id_cp_actividad = cpr.id_cp_actividad
       JOIN pre.tcp_fuente_fin ffi ON ffi.id_cp_fuente_fin =
         cpr.id_cp_fuente_fin
       JOIN pre.tcp_organismo_fin ofi ON ofi.id_cp_organismo_fin =
         cpr.id_cp_organismo_fin
       LEFT JOIN segu.tusuario usu2 ON usu2.id_usuario = cpr.id_usuario_mod;


  
/***********************************F-DEP-RAC-PRE-0-19/04/2016*****************************************/
 
  
 /***********************************I-DEP-RAC-PRE-0-20/04/2016*****************************************/
 
   
  
--------------- SQL ---------------

DROP VIEW pre.vcategoria_programatica;
DROP VIEW pre.vestado_presupuesto_por_tramite;
DROP VIEW pre.vpresupuesto_cc;



--------------- SQL ---------------

CREATE SEQUENCE pre.tcategoria_programatica_id_categoria_programatica_seq
MAXVALUE 2147483647;

ALTER TABLE pre.tcategoria_programatica
  ALTER COLUMN id_categoria_programatica TYPE INTEGER;

ALTER TABLE pre.tcategoria_programatica
  ALTER COLUMN id_categoria_programatica SET DEFAULT nextval('pre.tcategoria_programatica_id_categoria_programatica_seq'::text);






CREATE OR REPLACE VIEW pre.vcategoria_programatica(
    id_categoria_programatica,
    id_cp_actividad,
    id_gestion,
    id_cp_organismo_fin,
    descripcion,
    id_cp_programa,
    id_cp_fuente_fin,
    estado_reg,
    id_cp_proyecto,
    id_usuario_ai,
    fecha_reg,
    usuario_ai,
    id_usuario_reg,
    fecha_mod,
    id_usuario_mod,
    usr_reg,
    usr_mod,
    codigo_programa,
    codigo_proyecto,
    codigo_actividad,
    codigo_fuente_fin,
    codigo_origen_fin,
    desc_programa,
    desc_proyecto,
    desc_actividad,
    desc_fuente_fin,
    desc_origen_fin,
    codigo_categoria,
    gestion)
AS
  SELECT cpr.id_categoria_programatica,
         cpr.id_cp_actividad,
         cpr.id_gestion,
         cpr.id_cp_organismo_fin,
         cpr.descripcion,
         cpr.id_cp_programa,
         cpr.id_cp_fuente_fin,
         cpr.estado_reg,
         cpr.id_cp_proyecto,
         cpr.id_usuario_ai,
         cpr.fecha_reg,
         cpr.usuario_ai,
         cpr.id_usuario_reg,
         cpr.fecha_mod,
         cpr.id_usuario_mod,
         usu1.cuenta AS usr_reg,
         usu2.cuenta AS usr_mod,
         pro.codigo AS codigo_programa,
         pry.codigo AS codigo_proyecto,
         act.codigo AS codigo_actividad,
         ffi.codigo AS codigo_fuente_fin,
         ofi.codigo AS codigo_origen_fin,
         pro.descripcion AS desc_programa,
         pry.descripcion AS desc_proyecto,
         act.descripcion AS desc_actividad,
         ffi.descripcion AS desc_fuente_fin,
         ofi.descripcion AS desc_origen_fin,
         ((((((((pro.codigo::text || ' - '::text) || pry.codigo::text) || ' - '
           ::text) || act.codigo::text) || ' - '::text) || ffi.codigo::text) ||
           ' - '::text) || ofi.codigo::text)::character varying AS
           codigo_categoria,
         ges.gestion
  FROM pre.tcategoria_programatica cpr
       JOIN param.tgestion ges ON ges.id_gestion = cpr.id_gestion
       JOIN segu.tusuario usu1 ON usu1.id_usuario = cpr.id_usuario_reg
       JOIN pre.tcp_programa pro ON pro.id_cp_programa = cpr.id_cp_programa
       JOIN pre.tcp_proyecto pry ON pry.id_cp_proyecto = cpr.id_cp_proyecto
       JOIN pre.tcp_actividad act ON act.id_cp_actividad = cpr.id_cp_actividad
       JOIN pre.tcp_fuente_fin ffi ON ffi.id_cp_fuente_fin =
         cpr.id_cp_fuente_fin
       JOIN pre.tcp_organismo_fin ofi ON ofi.id_cp_organismo_fin =
         cpr.id_cp_organismo_fin
       LEFT JOIN segu.tusuario usu2 ON usu2.id_usuario = cpr.id_usuario_mod;
       
       
       
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
    estado_pres,
    estado,
    id_presupuesto,
    id_estado_wf,
    nro_tramite,
    id_proceso_wf,
    movimiento_tipo_pres,
    desc_tipo_presupuesto,
    sw_oficial,
    sw_consolidado)
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
           WHEN cp.descripcion IS NOT NULL THEN (((((COALESCE(uo.codigo, 's/c'::
             character varying)::text || ' - '::text) || cp.descripcion) ||
             '- ('::text) || ges.gestion) || ') Id: '::text) ||
             cec.id_centro_costo::text
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
         pre.estado_pres,
         pre.estado,
         pre.id_presupuesto,
         pre.id_estado_wf,
         pre.nro_tramite,
         pre.id_proceso_wf,
         tp.movimiento AS movimiento_tipo_pres,
         ((('('::text || tp.codigo::text) || ') '::text) || tp.nombre::text)::
           character varying AS desc_tipo_presupuesto,
         tp.sw_oficial,
         pre.sw_consolidado
  FROM param.tcentro_costo cec
       JOIN segu.tusuario usu1 ON usu1.id_usuario = cec.id_usuario_reg
       LEFT JOIN segu.tusuario usu2 ON usu2.id_usuario = cec.id_usuario_mod
       JOIN param.vep ep ON ep.id_ep = cec.id_ep
       JOIN param.tgestion ges ON ges.id_gestion = cec.id_gestion
       JOIN orga.tuo uo ON uo.id_uo = cec.id_uo
       JOIN pre.tpresupuesto pre ON pre.id_centro_costo = cec.id_centro_costo
       LEFT JOIN pre.tcategoria_programatica cp ON cp.id_categoria_programatica
         = pre.id_categoria_prog
       JOIN pre.ttipo_presupuesto tp ON tp.codigo::text = pre.tipo_pres::text
       JOIN param.vcentro_costo vcc ON vcc.id_centro_costo = pre.id_centro_costo
         ;
       
       

CREATE OR REPLACE VIEW pre.vestado_presupuesto_por_tramite(
    id_presup_partida,
    id_partida,
    id_presupuesto,
    desc_partida,
    id_centro_costo,
    codigo_cc,
    id_gestion,
    id_uo,
    id_ep,
    tipo_pres,
    nro_tramite,
    comprometido,
    ejecutado,
    pagado)
AS
  SELECT DISTINCT pp.id_presup_partida,
         pe.id_partida,
         pe.id_presupuesto,
         (('('::text || par.codigo::text) || ') '::text) || par.nombre_partida::
           text AS desc_partida,
         cc.id_centro_costo,
         cc.codigo_cc,
         cc.id_gestion,
         cc.id_uo,
         cc.id_ep,
         cc.tipo_pres,
         pe.nro_tramite,
         pre.f_get_estado_presupuesto_mb(pe.id_presupuesto, pe.id_partida,
           'comprometido'::character varying, pe.nro_tramite) AS comprometido,
         pre.f_get_estado_presupuesto_mb(pe.id_presupuesto, pe.id_partida,
           'ejecutado'::character varying, pe.nro_tramite) AS ejecutado,
         pre.f_get_estado_presupuesto_mb(pe.id_presupuesto, pe.id_partida,
           'pagado'::character varying, pe.nro_tramite) AS pagado
  FROM pre.tpartida_ejecucion pe
       JOIN pre.tpartida par ON par.id_partida = pe.id_partida
       JOIN pre.vpresupuesto_cc cc ON cc.id_centro_costo = pe.id_presupuesto
       JOIN pre.tpresup_partida pp ON pp.id_partida = pe.id_partida AND
         pp.id_presupuesto = pe.id_presupuesto;


/***********************************F-DEP-RAC-PRE-0-20/04/2016*****************************************/
 
     
  
/***********************************I-DEP-RAC-PRE-0-21/04/2016*****************************************/
 
 

--------------- SQL ---------------

DROP VIEW pre.vestado_presupuesto_por_tramite;

--------------- SQL ---------------

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
    estado_pres,
    estado,
    id_presupuesto,
    id_estado_wf,
    nro_tramite,
    id_proceso_wf,
    movimiento_tipo_pres,
    desc_tipo_presupuesto,
    sw_oficial,
    sw_consolidado)
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
           WHEN cp.descripcion IS NOT NULL THEN (((((COALESCE(uo.codigo, 's/c'::
             character varying)::text || ' - '::text) || cp.descripcion) ||
             '- ('::text) || ges.gestion) || ') Id: '::text) ||
             cec.id_centro_costo::text
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
         pre.estado_pres,
         pre.estado,
         pre.id_presupuesto,
         pre.id_estado_wf,
         pre.nro_tramite,
         pre.id_proceso_wf,
         tp.movimiento AS movimiento_tipo_pres,
         ((('('::text || tp.codigo::text) || ') '::text) || tp.nombre::text)::
           character varying AS desc_tipo_presupuesto,
         tp.sw_oficial,
         pre.sw_consolidado,
         pre.id_categoria_prog
  FROM param.tcentro_costo cec
       JOIN segu.tusuario usu1 ON usu1.id_usuario = cec.id_usuario_reg
       LEFT JOIN segu.tusuario usu2 ON usu2.id_usuario = cec.id_usuario_mod
       JOIN param.vep ep ON ep.id_ep = cec.id_ep
       JOIN param.tgestion ges ON ges.id_gestion = cec.id_gestion
       JOIN orga.tuo uo ON uo.id_uo = cec.id_uo
       JOIN pre.tpresupuesto pre ON pre.id_centro_costo = cec.id_centro_costo
       LEFT JOIN pre.tcategoria_programatica cp ON cp.id_categoria_programatica
         = pre.id_categoria_prog
       JOIN pre.ttipo_presupuesto tp ON tp.codigo::text = pre.tipo_pres::text
       JOIN param.vcentro_costo vcc ON vcc.id_centro_costo = pre.id_centro_costo
         ;

CREATE OR REPLACE VIEW pre.vestado_presupuesto_por_tramite(
    id_presup_partida,
    id_partida,
    id_presupuesto,
    desc_partida,
    id_centro_costo,
    codigo_cc,
    id_gestion,
    id_uo,
    id_ep,
    tipo_pres,
    nro_tramite,
    comprometido,
    ejecutado,
    pagado)
AS
  SELECT DISTINCT pp.id_presup_partida,
         pe.id_partida,
         pe.id_presupuesto,
         (('('::text || par.codigo::text) || ') '::text) || par.nombre_partida::
           text AS desc_partida,
         cc.id_centro_costo,
         cc.codigo_cc,
         cc.id_gestion,
         cc.id_uo,
         cc.id_ep,
         cc.tipo_pres,
         pe.nro_tramite,
         pre.f_get_estado_presupuesto_mb(pe.id_presupuesto, pe.id_partida,
           'comprometido'::character varying, pe.nro_tramite) AS comprometido,
         pre.f_get_estado_presupuesto_mb(pe.id_presupuesto, pe.id_partida,
           'ejecutado'::character varying, pe.nro_tramite) AS ejecutado,
         pre.f_get_estado_presupuesto_mb(pe.id_presupuesto, pe.id_partida,
           'pagado'::character varying, pe.nro_tramite) AS pagado
  FROM pre.tpartida_ejecucion pe
       JOIN pre.tpartida par ON par.id_partida = pe.id_partida
       JOIN pre.vpresupuesto_cc cc ON cc.id_centro_costo = pe.id_presupuesto
       JOIN pre.tpresup_partida pp ON pp.id_partida = pe.id_partida AND
         pp.id_presupuesto = pe.id_presupuesto;
         
 
 ------------- SQL ---------------

CREATE OR REPLACE VIEW pre.vmemoria_por_presupuesto(
    id_presupuesto,
    id_gestion,
    id_concepto_ingas,
    id_memoria_calculo,
    codigo_cc,
    codigo_uo,
    tipo_pres,
    nombre_tipo_pres,
    id_partida,
    codigo_partida,
    nombre_partida,
    desc_ingas,
    justificacion,
    cantidad_mem,
    unidad_medida,
    importe_unitario,
    importe,
    id_categoria_prog)
AS
  SELECT p.id_presupuesto,
         p.id_gestion,
         cig.id_concepto_ingas,
         mc.id_memoria_calculo,
         p.codigo_cc,
         p.codigo_uo,
         p.tipo_pres,
         tp.nombre AS nombre_tipo_pres,
         par.id_partida,
         par.codigo AS codigo_partida,
         par.nombre_partida,
         cig.desc_ingas,
         mc.obs AS justificacion,
         sum(md.cantidad_mem) AS cantidad_mem,
         md.unidad_medida,
         md.importe_unitario,
         sum(md.importe) AS importe,
         p.id_categoria_prog
  FROM pre.vpresupuesto_cc p
       JOIN pre.ttipo_presupuesto tp ON tp.codigo::text = p.tipo_pres::text
       JOIN pre.vmemoria_calculo mc ON mc.id_presupuesto = p.id_presupuesto
       JOIN param.tconcepto_ingas cig ON cig.id_concepto_ingas =
         mc.id_concepto_ingas
       JOIN pre.tpartida par ON par.id_partida = mc.id_partida
       JOIN pre.tmemoria_det md ON md.id_memoria_calculo = mc.id_memoria_calculo
  GROUP BY p.id_presupuesto,
           p.id_gestion,
           cig.id_concepto_ingas,
           mc.id_memoria_calculo,
           p.id_categoria_prog,
           p.codigo_cc,
           p.codigo_uo,
           p.tipo_pres,
           tp.nombre,
           par.id_partida,
           par.codigo,
           par.nombre_partida,
           cig.desc_ingas,
           mc.obs,
           md.importe_unitario,
           md.unidad_medida;
  
 --------------- SQL ---------------

CREATE OR REPLACE VIEW pre.vmemoria_por_categoria (
    id_categoria_programatica,
    id_cp_programa,
    desc_programa,
    id_gestion,
    descripcion,
    codigo_categoria,
    id_presupuesto,
    codigo_cc,
    id_concepto_ingas,
    id_memoria_calculo,
    codigo_tipo_pres,
    nombre_tipo_pres,
    id_partida,
    codigo_partida,
    nombre_partida,
    desc_ingas,
    justificacion,
    unidad_medida,
    importe_unitario,
    cantidad_mem,
    importe)
AS
 SELECT cp.id_categoria_programatica,
        cp.id_cp_programa,
        cp.desc_programa,
        cp.id_gestion,
        cp.descripcion,
        cp.codigo_categoria,
        p.id_presupuesto,
        p.codigo_cc,
        cig.id_concepto_ingas,
        mc.id_memoria_calculo,
        tp.codigo AS codigo_tipo_pres,
        tp.nombre AS nombre_tipo_pres,
        par.id_partida,
        par.codigo AS codigo_partida,
        par.nombre_partida,
        cig.desc_ingas,
        mc.obs AS justificacion,
        md.unidad_medida,
        md.importe_unitario,
        sum(md.cantidad_mem) AS cantidad_mem,
        sum(md.importe) AS importe
 FROM pre.vpresupuesto_cc p
      JOIN pre.ttipo_presupuesto tp ON tp.codigo::text = p.tipo_pres::text
      JOIN pre.vmemoria_calculo mc ON mc.id_presupuesto = p.id_presupuesto
      JOIN param.tconcepto_ingas cig ON cig.id_concepto_ingas =
        mc.id_concepto_ingas
      JOIN pre.tpartida par ON par.id_partida = mc.id_partida
      JOIN pre.tmemoria_det md ON md.id_memoria_calculo = mc.id_memoria_calculo
      JOIN pre.vcategoria_programatica cp ON cp.id_categoria_programatica =
        p.id_categoria_prog
 GROUP BY cp.id_categoria_programatica,
          cp.id_gestion,
          cp.id_cp_programa,
          cp.desc_programa,
          cp.descripcion,
          cp.codigo_categoria,
          p.id_presupuesto,
          p.codigo_cc,
          cig.id_concepto_ingas,
          mc.id_memoria_calculo,
          tp.codigo,
          tp.nombre,
          par.id_partida,
          par.codigo,
          par.nombre_partida,
          cig.desc_ingas,
          mc.obs,
          md.unidad_medida,
          md.importe_unitario;
          
/***********************************F-DEP-RAC-PRE-0-21/04/2016*****************************************/
 
 

/***********************************I-DEP-RAC-PRE-0-26/04/2016*****************************************/
 

--------------- SQL ---------------

ALTER TABLE pre.tmemoria_det
  ADD CONSTRAINT tmemoria_det_fk FOREIGN KEY (id_periodo)
    REFERENCES param.tperiodo(id_periodo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
--------------- SQL ---------------

ALTER TABLE pre.tmemoria_det
  ADD CONSTRAINT tmemoria_det_fk1 FOREIGN KEY (id_memoria_calculo)
    REFERENCES pre.tmemoria_calculo(id_memoria_calculo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
--------------- SQL ---------------

ALTER TABLE pre.tmemoria_calculo
  ADD CONSTRAINT tmemoria_calculo_fk FOREIGN KEY (id_presupuesto)
    REFERENCES pre.tpresupuesto(id_presupuesto)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;    


--------------- SQL ---------------

ALTER TABLE pre.tmemoria_calculo
  ADD CONSTRAINT tmemoria_calculo_fk1 FOREIGN KEY (id_concepto_ingas)
    REFERENCES param.tconcepto_ingas(id_concepto_ingas)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
    
--------------- SQL ---------------

ALTER TABLE pre.tpresup_partida
  ADD CONSTRAINT tpresup_partida_fk FOREIGN KEY (id_centro_costo)
    REFERENCES param.tcentro_costo(id_centro_costo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;    

--------------- SQL ---------------

ALTER TABLE pre.tpresupuesto
  ADD CONSTRAINT tpresupuesto_fk FOREIGN KEY (id_categoria_prog)
    REFERENCES pre.tcategoria_programatica(id_categoria_programatica)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE; 
    
--------------- SQL ---------------

ALTER TABLE pre.tcategoria_programatica
  ADD CONSTRAINT tcategoria_programatica_fk FOREIGN KEY (id_cp_programa)
    REFERENCES pre.tcp_programa(id_cp_programa)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE; 

--------------- SQL ---------------

ALTER TABLE pre.tcategoria_programatica
  ADD CONSTRAINT tcategoria_programatica_fk1 FOREIGN KEY (id_gestion)
    REFERENCES param.tgestion(id_gestion)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

--------------- SQL ---------------

ALTER TABLE pre.tcategoria_programatica
  ADD CONSTRAINT tcategoria_programatica_fk2 FOREIGN KEY (id_cp_proyecto)
    REFERENCES pre.tcp_proyecto(id_cp_proyecto)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
 
--------------- SQL ---------------

ALTER TABLE pre.tcategoria_programatica
  ADD CONSTRAINT tcategoria_programatica_fk3 FOREIGN KEY (id_cp_actividad)
    REFERENCES pre.tcp_actividad(id_cp_actividad)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;    

--------------- SQL ---------------

ALTER TABLE pre.tcategoria_programatica
  ADD CONSTRAINT tcategoria_programatica_fk4 FOREIGN KEY (id_cp_fuente_fin)
    REFERENCES pre.tcp_fuente_fin(id_cp_fuente_fin)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

--------------- SQL ---------------

ALTER TABLE pre.tcategoria_programatica
  ADD CONSTRAINT tcategoria_programatica_fk5 FOREIGN KEY (id_cp_organismo_fin)
    REFERENCES pre.tcp_organismo_fin(id_cp_organismo_fin)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE; 
    
--------------- SQL ---------------

CREATE INDEX tpartida_idx ON pre.tpartida
  USING btree (id_partida_fk);  
  
  --------------- SQL ---------------

CREATE INDEX tmemoria_calculo_idx ON pre.tmemoria_calculo
  USING btree (id_presupuesto);
  
--------------- SQL ---------------

CREATE INDEX tmemoria_calculo_idx1 ON pre.tmemoria_calculo
  USING btree (id_concepto_ingas);
  
--------------- SQL ---------------

CREATE INDEX tpresupuesto_idx ON pre.tpresupuesto
  USING btree (id_centro_costo); 
  
--------------- SQL ---------------

CREATE INDEX tmemoria_det_idx ON pre.tmemoria_det
  USING btree (id_periodo);
  
--------------- SQL ---------------

CREATE INDEX tmemoria_det_idx1 ON pre.tmemoria_det
  USING btree (id_memoria_calculo);
    
--------------- SQL ---------------

CREATE UNIQUE INDEX tmemoria_det_idx2 ON pre.tmemoria_det
  USING btree (id_periodo, id_memoria_calculo);
  
--------------- SQL ---------------

ALTER TABLE pre.tmemoria_calculo
  ADD CONSTRAINT tmemoria_calculo_fk2 FOREIGN KEY (id_partida)
    REFERENCES pre.tpartida(id_partida)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;    
    
/***********************************F-DEP-RAC-PRE-0-26/04/2016*****************************************/
 

/***********************************I-DEP-GSS-PRE-0-05/08/2016*****************************************/

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
    estado_pres,
    estado,
    id_presupuesto,
    id_estado_wf,
    nro_tramite,
    id_proceso_wf,
    movimiento_tipo_pres,
    desc_tipo_presupuesto,
    sw_oficial,
    sw_consolidado,
    id_categoria_prog,
    descripcion)
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
           WHEN cp.descripcion IS NOT NULL THEN (('Id: ' ::text ||
             cec.id_centro_costo::text) || ' ' ::text) ||(((((COALESCE(
             uo.codigo, 's/c' ::character varying) ::text || ' - ' ::text) ||
             cp.descripcion) || '- (' ::text) || ges.gestion) || ')' ::text)
           ELSE (((uo.codigo::text || '-(' ::text) || ep.ep) || ') Id: ' ::text)
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
         pre.estado_pres,
         pre.estado,
         pre.id_presupuesto,
         pre.id_estado_wf,
         pre.nro_tramite,
         pre.id_proceso_wf,
         tp.movimiento AS movimiento_tipo_pres,
         ((('(' ::text || tp.codigo::text) || ') ' ::text) || tp.nombre::text)
           ::character varying AS desc_tipo_presupuesto,
         tp.sw_oficial,
         pre.sw_consolidado,
         pre.id_categoria_prog,
         pre.descripcion
  FROM param.tcentro_costo cec
       JOIN segu.tusuario usu1 ON usu1.id_usuario = cec.id_usuario_reg
       LEFT JOIN segu.tusuario usu2 ON usu2.id_usuario = cec.id_usuario_mod
       JOIN param.vep ep ON ep.id_ep = cec.id_ep
       JOIN param.tgestion ges ON ges.id_gestion = cec.id_gestion
       JOIN orga.tuo uo ON uo.id_uo = cec.id_uo
       JOIN pre.tpresupuesto pre ON pre.id_centro_costo = cec.id_centro_costo
       LEFT JOIN pre.tcategoria_programatica cp ON cp.id_categoria_programatica
         = pre.id_categoria_prog
       JOIN pre.ttipo_presupuesto tp ON tp.codigo::text = pre.tipo_pres::text
       JOIN param.vcentro_costo vcc ON vcc.id_centro_costo = pre.id_centro_costo
         ; 
 
/***********************************F-DEP-GSS-PRE-0-05/08/2016*****************************************/

/***********************************I-DEP-GVC-PRE-0-10/08/2016*****************************************/
DROP VIEW pre.vestado_presupuesto_por_tramite;
DROP VIEW pre.vmemoria_por_presupuesto;
DROP VIEW pre.vmemoria_por_categoria;

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
    estado_pres,
    estado,
    id_presupuesto,
    id_estado_wf,
    nro_tramite,
    id_proceso_wf,
    movimiento_tipo_pres,
    desc_tipo_presupuesto,
    sw_oficial,
    sw_consolidado,
    id_categoria_prog,
    descripcion)
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
           WHEN pre.descripcion IS NOT NULL THEN (('Id: ' ::text ||
             cec.id_centro_costo::text) || ' ' ::text) ||((((' - ' ::text ||
             pre.descripcion::text) || ' - (' ::text) || ges.gestion) || ')'
             ::text)
           ELSE (((uo.codigo::text || ' - (' ::text) || ep.ep) || ') Id: '
             ::text) || cec.id_centro_costo::text
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
         pre.estado_pres,
         pre.estado,
         pre.id_presupuesto,
         pre.id_estado_wf,
         pre.nro_tramite,
         pre.id_proceso_wf,
         tp.movimiento AS movimiento_tipo_pres,
         ((('(' ::text || tp.codigo::text) || ') ' ::text) || tp.nombre::text)
           ::character varying AS desc_tipo_presupuesto,
         tp.sw_oficial,
         pre.sw_consolidado,
         pre.id_categoria_prog,
         pre.descripcion
  FROM param.tcentro_costo cec
       JOIN segu.tusuario usu1 ON usu1.id_usuario = cec.id_usuario_reg
       LEFT JOIN segu.tusuario usu2 ON usu2.id_usuario = cec.id_usuario_mod
       JOIN param.vep ep ON ep.id_ep = cec.id_ep
       JOIN param.tgestion ges ON ges.id_gestion = cec.id_gestion
       JOIN orga.tuo uo ON uo.id_uo = cec.id_uo
       JOIN pre.tpresupuesto pre ON pre.id_centro_costo = cec.id_centro_costo
       LEFT JOIN pre.tcategoria_programatica cp ON cp.id_categoria_programatica
         = pre.id_categoria_prog
       JOIN pre.ttipo_presupuesto tp ON tp.codigo::text = pre.tipo_pres::text
       JOIN param.vcentro_costo vcc ON vcc.id_centro_costo = pre.id_centro_costo
         ;
		 
		CREATE VIEW pre.vmemoria_por_categoria (
    id_categoria_programatica,
    id_cp_programa,
    desc_programa,
    id_gestion,
    descripcion_cat,
    codigo_categoria,
    id_presupuesto,
    codigo_cc,
    id_concepto_ingas,
    id_memoria_calculo,
    codigo_tipo_pres,
    nombre_tipo_pres,
    id_partida,
    codigo_partida,
    nombre_partida,
    desc_ingas,
    justificacion,
    unidad_medida,
    importe_unitario,
    cantidad_mem,
    importe,
    descripcion_pres)
AS
SELECT cp.id_categoria_programatica,
    cp.id_cp_programa,
    (((cp.codigo_programa::text || ' - '::text) ||
        cp.desc_programa::text))::character varying(500) AS desc_programa,
    cp.id_gestion,
    cp.descripcion AS descripcion_cat,
    ((cp.codigo_categoria::text || '  '::text) || cp.descripcion)::character
        varying AS codigo_categoria,
    p.id_presupuesto,
    p.codigo_cc,
    cig.id_concepto_ingas,
    mc.id_memoria_calculo,
    tp.codigo AS codigo_tipo_pres,
    tp.nombre AS nombre_tipo_pres,
    par.id_partida,
    par.codigo AS codigo_partida,
    par.nombre_partida,
    cig.desc_ingas,
    mc.obs AS justificacion,
    md.unidad_medida,
    md.importe_unitario,
    sum(md.cantidad_mem) AS cantidad_mem,
    sum(md.importe) AS importe,
    p.descripcion AS descripcion_pres
FROM pre.vpresupuesto_cc p
   JOIN pre.ttipo_presupuesto tp ON tp.codigo::text = p.tipo_pres::text
   JOIN pre.vmemoria_calculo mc ON mc.id_presupuesto = p.id_presupuesto
   JOIN param.tconcepto_ingas cig ON cig.id_concepto_ingas = mc.id_concepto_ingas
   JOIN pre.tpartida par ON par.id_partida = mc.id_partida
   JOIN pre.tmemoria_det md ON md.id_memoria_calculo = mc.id_memoria_calculo
       AND md.importe <> 0::numeric
   JOIN pre.vcategoria_programatica cp ON cp.id_categoria_programatica =
       p.id_categoria_prog
GROUP BY cp.id_categoria_programatica, cp.id_gestion, cp.id_cp_programa,
    cp.desc_programa, cp.descripcion, cp.codigo_categoria, p.id_presupuesto, p.codigo_cc, cig.id_concepto_ingas, mc.id_memoria_calculo, tp.codigo, tp.nombre, par.id_partida, par.codigo, par.nombre_partida, cig.desc_ingas, mc.obs, md.unidad_medida, md.importe_unitario, p.descripcion, cp.codigo_programa;
	
	
	
	CREATE VIEW pre.vmemoria_por_presupuesto (
    id_presupuesto,
    id_gestion,
    id_concepto_ingas,
    id_memoria_calculo,
    codigo_cc,
    codigo_uo,
    tipo_pres,
    nombre_tipo_pres,
    id_partida,
    codigo_partida,
    nombre_partida,
    desc_ingas,
    justificacion,
    cantidad_mem,
    unidad_medida,
    importe_unitario,
    importe,
    id_categoria_prog)
AS
SELECT p.id_presupuesto,
    p.id_gestion,
    cig.id_concepto_ingas,
    mc.id_memoria_calculo,
    p.codigo_cc,
    p.codigo_uo,
    p.tipo_pres,
    tp.nombre AS nombre_tipo_pres,
    par.id_partida,
    par.codigo AS codigo_partida,
    par.nombre_partida,
    cig.desc_ingas,
    mc.obs AS justificacion,
    sum(md.cantidad_mem) AS cantidad_mem,
    md.unidad_medida,
    md.importe_unitario,
    sum(md.importe) AS importe,
    p.id_categoria_prog
FROM pre.vpresupuesto_cc p
   JOIN pre.ttipo_presupuesto tp ON tp.codigo::text = p.tipo_pres::text
   JOIN pre.vmemoria_calculo mc ON mc.id_presupuesto = p.id_presupuesto
   JOIN param.tconcepto_ingas cig ON cig.id_concepto_ingas = mc.id_concepto_ingas
   JOIN pre.tpartida par ON par.id_partida = mc.id_partida
   JOIN pre.tmemoria_det md ON md.id_memoria_calculo = mc.id_memoria_calculo
GROUP BY p.id_presupuesto, p.id_gestion, cig.id_concepto_ingas,
    mc.id_memoria_calculo, p.id_categoria_prog, p.codigo_cc, p.codigo_uo, p.tipo_pres, tp.nombre, par.id_partida, par.codigo, par.nombre_partida, cig.desc_ingas, mc.obs, md.importe_unitario, md.unidad_medida;
	
	
CREATE VIEW pre.vestado_presupuesto_por_tramite (
    id_presup_partida,
    id_partida,
    id_presupuesto,
    desc_partida,
    id_centro_costo,
    codigo_cc,
    id_gestion,
    id_uo,
    id_ep,
    tipo_pres,
    nro_tramite,
    comprometido,
    ejecutado,
    pagado)
AS
SELECT DISTINCT pp.id_presup_partida,
    pe.id_partida,
    pe.id_presupuesto,
    (('('::text || par.codigo::text) || ') '::text) || par.nombre_partida::text
        AS desc_partida,
    cc.id_centro_costo,
    cc.codigo_cc,
    cc.id_gestion,
    cc.id_uo,
    cc.id_ep,
    cc.tipo_pres,
    pe.nro_tramite,
    pre.f_get_estado_presupuesto_mb(pe.id_presupuesto, pe.id_partida,
        'comprometido'::character varying, pe.nro_tramite) AS comprometido,
    pre.f_get_estado_presupuesto_mb(pe.id_presupuesto, pe.id_partida,
        'ejecutado'::character varying, pe.nro_tramite) AS ejecutado,
    pre.f_get_estado_presupuesto_mb(pe.id_presupuesto, pe.id_partida,
        'pagado'::character varying, pe.nro_tramite) AS pagado
FROM pre.tpartida_ejecucion pe
   JOIN pre.tpartida par ON par.id_partida = pe.id_partida
   JOIN pre.vpresupuesto_cc cc ON cc.id_centro_costo = pe.id_presupuesto
   JOIN pre.tpresup_partida pp ON pp.id_partida = pe.id_partida AND
       pp.id_presupuesto = pe.id_presupuesto;
	   
	   

/***********************************F-DEP-GVC-PRE-0-10/08/2016*****************************************/

/***********************************I-DEP-GVC-PRE-0-10/08/2016*****************************************/
ALTER TABLE pre.tmemoria_calculo
  ADD CONSTRAINT fk_tobjetivo__id_objetivo_fk FOREIGN KEY (id_objetivo_fk)
    REFERENCES pre.tobjetivo(id_objetivo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

/***********************************F-DEP-GVC-PRE-0-10/08/2016*****************************************/

/***********************************I-DEP-GVC-PRE-0-16/11/2016*****************************************/
select pxp.f_insert_testructura_gui ('PAREJE', 'REPPRE');

/***********************************F-DEP-GVC-PRE-0-16/11/2016*****************************************/

/***********************************I-DEP-MMV-PRE-0-31/05/2017*****************************************/
CREATE VIEW pre.vprogramando_memoria_por_periodo (
    id_presup_partida,
    id_partida,
    id_presupuesto,
    descripcion,
    id_categoria_programatica,
    id_cp_programa,
    importe_enero,
    importe_febrero,
    importe_marzo,
    importe_abril,
    importe_mayo,
    importe_junio,
    importe_julio,
    importe_agosto,
    importe_septiembre,
    importe_octubre,
    importe_noviembre,
    importe_diciembre)
AS
SELECT pp.id_presup_partida,
    pp.id_partida,
    pp.id_presupuesto,
    p.descripcion,
    cp.id_categoria_programatica,
    cp.id_cp_programa,
    sum(pre.f_get_total_programado_memoria_x_periodo(pp.id_partida,
        pp.id_presupuesto, 120::numeric)) AS importe_enero,
    sum(pre.f_get_total_programado_memoria_x_periodo(pp.id_partida,
        pp.id_presupuesto, 121::numeric)) AS importe_febrero,
    sum(pre.f_get_total_programado_memoria_x_periodo(pp.id_partida,
        pp.id_presupuesto, 122::numeric)) AS importe_marzo,
    sum(pre.f_get_total_programado_memoria_x_periodo(pp.id_partida,
        pp.id_presupuesto, 123::numeric)) AS importe_abril,
    sum(pre.f_get_total_programado_memoria_x_periodo(pp.id_partida,
        pp.id_presupuesto, 124::numeric)) AS importe_mayo,
    sum(pre.f_get_total_programado_memoria_x_periodo(pp.id_partida,
        pp.id_presupuesto, 125::numeric)) AS importe_junio,
    sum(pre.f_get_total_programado_memoria_x_periodo(pp.id_partida,
        pp.id_presupuesto, 126::numeric)) AS importe_julio,
    sum(pre.f_get_total_programado_memoria_x_periodo(pp.id_partida,
        pp.id_presupuesto, 127::numeric)) AS importe_agosto,
    sum(pre.f_get_total_programado_memoria_x_periodo(pp.id_partida,
        pp.id_presupuesto, 128::numeric)) AS importe_septiembre,
    sum(pre.f_get_total_programado_memoria_x_periodo(pp.id_partida,
        pp.id_presupuesto, 129::numeric)) AS importe_octubre,
    sum(pre.f_get_total_programado_memoria_x_periodo(pp.id_partida,
        pp.id_presupuesto, 130::numeric)) AS importe_noviembre,
    sum(pre.f_get_total_programado_memoria_x_periodo(pp.id_partida,
        pp.id_presupuesto, 131::numeric)) AS importe_diciembre
FROM pre.tpresup_partida pp
     JOIN pre.tpresupuesto p ON p.id_presupuesto = pp.id_presupuesto
     JOIN pre.tcategoria_programatica cp ON cp.id_categoria_programatica =
         p.id_categoria_prog
GROUP BY pp.id_partida, pp.id_presup_partida, pp.id_presupuesto, p.descripcion,
    cp.id_categoria_programatica, cp.id_cp_programa;

    CREATE VIEW pre.vpartida_comprometido_por_periodos (
    id_presup_partida,
    id_partida,
    id_presupuesto,
    descripcion,
    id_categoria_programatica,
    id_cp_programa,
    importe_enero,
    importe_febrero,
    importe_marzo,
    importe_abril,
    importe_mayo,
    importe_junio,
    importe_julio,
    importe_agosto,
    importe_septiembre,
    importe_octubre,
    importe_noviembre,
    importe_diciembre)
AS
SELECT pp.id_presup_partida,
    pp.id_partida,
    pp.id_presupuesto,
    p.descripcion,
    cp.id_categoria_programatica,
    cp.id_cp_programa,
    sum(pre.f_get_ejecutado_por_periodo(pp.id_partida, pp.id_presupuesto, 15,
        1, 'comprometido'::character varying)) AS importe_enero,
    sum(pre.f_get_ejecutado_por_periodo(pp.id_partida, pp.id_presupuesto, 15,
        2, 'comprometido'::character varying)) AS importe_febrero,
    sum(pre.f_get_ejecutado_por_periodo(pp.id_partida, pp.id_presupuesto, 15,
        3, 'comprometido'::character varying)) AS importe_marzo,
    sum(pre.f_get_ejecutado_por_periodo(pp.id_partida, pp.id_presupuesto, 15,
        4, 'comprometido'::character varying)) AS importe_abril,
    sum(pre.f_get_ejecutado_por_periodo(pp.id_partida, pp.id_presupuesto, 15,
        5, 'comprometido'::character varying)) AS importe_mayo,
    sum(pre.f_get_ejecutado_por_periodo(pp.id_partida, pp.id_presupuesto, 15,
        6, 'comprometido'::character varying)) AS importe_junio,
    sum(pre.f_get_ejecutado_por_periodo(pp.id_partida, pp.id_presupuesto, 15,
        7, 'comprometido'::character varying)) AS importe_julio,
    sum(pre.f_get_ejecutado_por_periodo(pp.id_partida, pp.id_presupuesto, 15,
        8, 'comprometido'::character varying)) AS importe_agosto,
    sum(pre.f_get_ejecutado_por_periodo(pp.id_partida, pp.id_presupuesto, 15,
        9, 'comprometido'::character varying)) AS importe_septiembre,
    sum(pre.f_get_ejecutado_por_periodo(pp.id_partida, pp.id_presupuesto, 15,
        10, 'comprometido'::character varying)) AS importe_octubre,
    sum(pre.f_get_ejecutado_por_periodo(pp.id_partida, pp.id_presupuesto, 15,
        11, 'comprometido'::character varying)) AS importe_noviembre,
    sum(pre.f_get_ejecutado_por_periodo(pp.id_partida, pp.id_presupuesto, 15,
        12, 'comprometido'::character varying)) AS importe_diciembre
FROM pre.tpresup_partida pp
     JOIN pre.tpresupuesto p ON p.id_presupuesto = pp.id_presupuesto
     JOIN pre.tcategoria_programatica cp ON cp.id_categoria_programatica =
         p.id_categoria_prog
GROUP BY pp.id_partida, pp.id_presup_partida, pp.id_presupuesto, p.descripcion,
    cp.id_categoria_programatica, cp.id_cp_programa;

    CREATE VIEW pre.vpartida_ejecutado_por_periodos (
    id_presup_partida,
    id_partida,
    id_presupuesto,
    descripcion,
    id_categoria_programatica,
    id_cp_programa,
    importe_enero,
    importe_febrero,
    importe_marzo,
    importe_abril,
    importe_mayo,
    importe_junio,
    importe_julio,
    importe_agosto,
    importe_septiembre,
    importe_octubre,
    importe_noviembre,
    importe_diciembre)
AS
SELECT pp.id_presup_partida,
    pp.id_partida,
    pp.id_presupuesto,
    p.descripcion,
    cp.id_categoria_programatica,
    cp.id_cp_programa,
    sum(pre.f_get_ejecutado_por_periodo(pp.id_partida, pp.id_presupuesto, 15,
        1, 'ejecutado'::character varying)) AS importe_enero,
    sum(pre.f_get_ejecutado_por_periodo(pp.id_partida, pp.id_presupuesto, 15,
        2, 'ejecutado'::character varying)) AS importe_febrero,
    sum(pre.f_get_ejecutado_por_periodo(pp.id_partida, pp.id_presupuesto, 15,
        3, 'ejecutado'::character varying)) AS importe_marzo,
    sum(pre.f_get_ejecutado_por_periodo(pp.id_partida, pp.id_presupuesto, 15,
        4, 'ejecutado'::character varying)) AS importe_abril,
    sum(pre.f_get_ejecutado_por_periodo(pp.id_partida, pp.id_presupuesto, 15,
        5, 'ejecutado'::character varying)) AS importe_mayo,
    sum(pre.f_get_ejecutado_por_periodo(pp.id_partida, pp.id_presupuesto, 15,
        6, 'ejecutado'::character varying)) AS importe_junio,
    sum(pre.f_get_ejecutado_por_periodo(pp.id_partida, pp.id_presupuesto, 15,
        7, 'ejecutado'::character varying)) AS importe_julio,
    sum(pre.f_get_ejecutado_por_periodo(pp.id_partida, pp.id_presupuesto, 15,
        8, 'ejecutado'::character varying)) AS importe_agosto,
    sum(pre.f_get_ejecutado_por_periodo(pp.id_partida, pp.id_presupuesto, 15,
        9, 'ejecutado'::character varying)) AS importe_septiembre,
    sum(pre.f_get_ejecutado_por_periodo(pp.id_partida, pp.id_presupuesto, 15,
        10, 'ejecutado'::character varying)) AS importe_octubre,
    sum(pre.f_get_ejecutado_por_periodo(pp.id_partida, pp.id_presupuesto, 15,
        11, 'ejecutado'::character varying)) AS importe_noviembre,
    sum(pre.f_get_ejecutado_por_periodo(pp.id_partida, pp.id_presupuesto, 15,
        12, 'ejecutado'::character varying)) AS importe_diciembre
FROM pre.tpresup_partida pp
     JOIN pre.tpresupuesto p ON p.id_presupuesto = pp.id_presupuesto
     JOIN pre.tcategoria_programatica cp ON cp.id_categoria_programatica =
         p.id_categoria_prog
GROUP BY pp.id_partida, pp.id_presup_partida, pp.id_presupuesto, p.descripcion,
    cp.id_categoria_programatica, cp.id_cp_programa;
/***********************************F-DEP-MMV-PRE-0-31/05/2017*****************************************/



/***********************************I-DEP-RAC-PRE-0-05/06/2017*****************************************/
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
    estado_pres,
    estado,
    id_presupuesto,
    id_estado_wf,
    nro_tramite,
    id_proceso_wf,
    movimiento_tipo_pres,
    desc_tipo_presupuesto,
    sw_oficial,
    sw_consolidado,
    id_categoria_prog,
    descripcion)
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
           WHEN pre.descripcion IS NOT NULL THEN (('Id: '::text ||
             cec.id_centro_costo::text) || ' '::text) ||((((' - '::text ||
             pre.descripcion::text) || ' - ('::text) || ges.gestion) || ')'::
             text)
           ELSE (((uo.codigo::text || ' - ('::text) || ep.ep) || ') Id: '::text)
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
         pre.estado_pres,
         pre.estado,
         pre.id_presupuesto,
         pre.id_estado_wf,
         pre.nro_tramite,
         pre.id_proceso_wf,
         tp.movimiento AS movimiento_tipo_pres,
         ((('('::text || tp.codigo::text) || ') '::text) || tp.nombre::text)::
           character varying AS desc_tipo_presupuesto,
         tp.sw_oficial,
         pre.sw_consolidado,
         pre.id_categoria_prog,
         ((('('::text || vcc.codigo_tcc::text) || ') '::text) ||
           vcc.descripcion_tcc::text)::character varying AS descripcion
  FROM param.tcentro_costo cec
       JOIN segu.tusuario usu1 ON usu1.id_usuario = cec.id_usuario_reg
       LEFT JOIN segu.tusuario usu2 ON usu2.id_usuario = cec.id_usuario_mod
       JOIN param.vep ep ON ep.id_ep = cec.id_ep
       JOIN param.tgestion ges ON ges.id_gestion = cec.id_gestion
       JOIN orga.tuo uo ON uo.id_uo = cec.id_uo
       JOIN pre.tpresupuesto pre ON pre.id_centro_costo = cec.id_centro_costo
       LEFT JOIN pre.tcategoria_programatica cp ON cp.id_categoria_programatica
         = pre.id_categoria_prog
       JOIN pre.ttipo_presupuesto tp ON tp.codigo::text = pre.tipo_pres::text
       JOIN param.vcentro_costo vcc ON vcc.id_centro_costo = pre.id_centro_costo
         ;
         
     
/***********************************F-DEP-RAC-PRE-0-05/06/2017*****************************************/
         
   
/***********************************I-DEP-RAC-PRE-0-09/06/2017*****************************************/
    
CREATE OR REPLACE  VIEW pre.vpresupuesto
AS
  SELECT pre.id_presupuesto,
         pre.id_centro_costo,
         vcc.codigo_cc,
         pre.tipo_pres,
         pre.estado_pres,
         pre.estado_reg,
         pre.id_usuario_reg,
         pre.fecha_reg,
         pre.fecha_mod,
         pre.id_usuario_mod,
         pre.estado,
         pre.id_estado_wf,
         pre.nro_tramite,
         pre.id_proceso_wf,
         ((('('::text || tp.codigo::text) || ') '::text) || tp.nombre::text)::
           character varying AS desc_tipo_presupuesto,
         ('('|| vcc.codigo_tcc || ') ' ||vcc.descripcion_tcc)::character varying AS descripcion,        
         tp.movimiento AS movimiento_tipo_pres,
         vcc.id_gestion
  FROM pre.tpresupuesto pre
       JOIN pre.ttipo_presupuesto tp ON tp.codigo::text = pre.tipo_pres::text
       JOIN param.vcentro_costo vcc ON vcc.id_centro_costo = pre.id_centro_costo;  
       
       
-----------------

CREATE OR REPLACE VIEW pre.vpresupuesto_cc
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
         cec.codigo_cc,
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
         pre.estado_pres,
         pre.estado,
         pre.id_presupuesto,
         pre.id_estado_wf,
         pre.nro_tramite,
         pre.id_proceso_wf,
         tp.movimiento AS movimiento_tipo_pres,
         ((('('::text || tp.codigo::text) || ') '::text) || tp.nombre::text)::
           character varying AS desc_tipo_presupuesto,
         tp.sw_oficial,
         pre.sw_consolidado,
         pre.id_categoria_prog,
         CASE
           WHEN cec.id_tipo_cc IS NOT NULL THEN ((('('::text || cec.codigo_tcc::
             text) || ') '::text) || cec.descripcion_tcc::text)::character
             varying
           ELSE pre.descripcion
         END AS descripcion
  FROM param.vcentro_costo cec
       JOIN segu.tusuario usu1 ON usu1.id_usuario = cec.id_usuario_reg
       LEFT JOIN segu.tusuario usu2 ON usu2.id_usuario = cec.id_usuario_mod
       JOIN param.vep ep ON ep.id_ep = cec.id_ep
       JOIN param.tgestion ges ON ges.id_gestion = cec.id_gestion
       JOIN orga.tuo uo ON uo.id_uo = cec.id_uo
       JOIN pre.tpresupuesto pre ON pre.id_centro_costo = cec.id_centro_costo
       LEFT JOIN pre.tcategoria_programatica cp ON cp.id_categoria_programatica
         = pre.id_categoria_prog
       JOIN pre.ttipo_presupuesto tp ON tp.codigo::text = pre.tipo_pres::text;
           

/***********************************F-DEP-RAC-PRE-0-09/06/2017*****************************************/
   

/***********************************I-DEP-RAC-PRE-0-25/07/2017*****************************************/
  

CREATE TRIGGER trig_tpartida_ejecucion
  AFTER INSERT 
  ON pre.tpartida_ejecucion FOR EACH ROW 
  EXECUTE PROCEDURE pre.trig_tpartida_ejecucion();


/***********************************F-DEP-RAC-PRE-0-25/07/2017*****************************************/

/***********************************I-DEP-MMV-PRE-0-04/08/2017*****************************************/
CREATE OR REPLACE VIEW pre.vformulacion_mensual (
    id_partida,
    id_partida_fk,
    codigo_partida,
    nombre_partida,
    id_presupuesto,
    id_proceso_wf,
    descripcion,
    gestion,
    id_gestion,
    nivel_partida,
    sw_transaccional,
    importe_enero,
    importe_febrero,
    importe_marzo,
    importe_abril,
    importe_mayo,
    importe_junio,
    importe_julio,
    importe_agosto,
    importe_septiembre,
    importe_octubre,
    importe_noviembre,
    importe_diciembre)
AS
 SELECT pp.id_partida,
    par.id_partida_fk,
    par.codigo AS codigo_partida,
    par.nombre_partida,
    pp.id_presupuesto,
    p.id_proceso_wf,
    p.descripcion,
    g.gestion,
    g.id_gestion,
    par.nivel_partida,
    par.sw_transaccional,
    sum(pre.f_get_total_programado_memoria_x_periodo(pp.id_partida, pp.id_presupuesto,
        CASE
            WHEN o.periodo = 1 THEN o.id_periodo
            ELSE NULL::integer
        END::numeric)) AS importe_enero,
    sum(pre.f_get_total_programado_memoria_x_periodo(pp.id_partida, pp.id_presupuesto,
        CASE
            WHEN o.periodo = 2 THEN o.id_periodo
            ELSE NULL::integer
        END::numeric)) AS importe_febrero,
    sum(pre.f_get_total_programado_memoria_x_periodo(pp.id_partida, pp.id_presupuesto,
        CASE
            WHEN o.periodo = 3 THEN o.id_periodo
            ELSE NULL::integer
        END::numeric)) AS importe_marzo,
    sum(pre.f_get_total_programado_memoria_x_periodo(pp.id_partida, pp.id_presupuesto,
        CASE
            WHEN o.periodo = 4 THEN o.id_periodo
            ELSE NULL::integer
        END::numeric)) AS importe_abril,
    sum(pre.f_get_total_programado_memoria_x_periodo(pp.id_partida, pp.id_presupuesto,
        CASE
            WHEN o.periodo = 5 THEN o.id_periodo
            ELSE NULL::integer
        END::numeric)) AS importe_mayo,
    sum(pre.f_get_total_programado_memoria_x_periodo(pp.id_partida, pp.id_presupuesto,
        CASE
            WHEN o.periodo = 6 THEN o.id_periodo
            ELSE NULL::integer
        END::numeric)) AS importe_junio,
    sum(pre.f_get_total_programado_memoria_x_periodo(pp.id_partida, pp.id_presupuesto,
        CASE
            WHEN o.periodo = 7 THEN o.id_periodo
            ELSE NULL::integer
        END::numeric)) AS importe_julio,
    sum(pre.f_get_total_programado_memoria_x_periodo(pp.id_partida, pp.id_presupuesto,
        CASE
            WHEN o.periodo = 8 THEN o.id_periodo
            ELSE NULL::integer
        END::numeric)) AS importe_agosto,
    sum(pre.f_get_total_programado_memoria_x_periodo(pp.id_partida, pp.id_presupuesto,
        CASE
            WHEN o.periodo = 9 THEN o.id_periodo
            ELSE NULL::integer
        END::numeric)) AS importe_septiembre,
    sum(pre.f_get_total_programado_memoria_x_periodo(pp.id_partida, pp.id_presupuesto,
        CASE
            WHEN o.periodo = 10 THEN o.id_periodo
            ELSE NULL::integer
        END::numeric)) AS importe_octubre,
    sum(pre.f_get_total_programado_memoria_x_periodo(pp.id_partida, pp.id_presupuesto,
        CASE
            WHEN o.periodo = 11 THEN o.id_periodo
            ELSE NULL::integer
        END::numeric)) AS importe_noviembre,
    sum(pre.f_get_total_programado_memoria_x_periodo(pp.id_partida, pp.id_presupuesto,
        CASE
            WHEN o.periodo = 12 THEN o.id_periodo
            ELSE NULL::integer
        END::numeric)) AS importe_diciembre
   FROM pre.tpresup_partida pp
     JOIN pre.tpartida par ON par.id_partida = pp.id_partida
     JOIN pre.tpresupuesto p ON p.id_presupuesto = pp.id_presupuesto
     JOIN param.tgestion g ON g.id_gestion = par.id_gestion
     JOIN param.tperiodo o ON o.id_gestion = g.id_gestion
  GROUP BY pp.id_partida, par.id_partida_fk, par.codigo, par.nombre_partida, pp.id_presupuesto, par.nivel_partida, p.id_proceso_wf, par.sw_transaccional, p.descripcion, g.gestion, g.id_gestion;

CREATE OR REPLACE VIEW pre.vpartida_comprometido_por_periodos (
    id_presup_partida,
    id_partida,
    id_presupuesto,
    descripcion,
    id_categoria_programatica,
    id_cp_programa,
    importe_enero,
    importe_febrero,
    importe_marzo,
    importe_abril,
    importe_mayo,
    importe_junio,
    importe_julio,
    importe_agosto,
    importe_septiembre,
    importe_octubre,
    importe_noviembre,
    importe_diciembre)
AS
 SELECT pp.id_presup_partida,
    pp.id_partida,
    pp.id_presupuesto,
    p.descripcion,
    cp.id_categoria_programatica,
    cp.id_cp_programa,
    sum(pre.f_get_ejecutado_por_periodo(pp.id_partida, pp.id_presupuesto, g.id_gestion, 1, 'comprometido'::character varying)) AS importe_enero,
    sum(pre.f_get_ejecutado_por_periodo(pp.id_partida, pp.id_presupuesto, g.id_gestion, 2, 'comprometido'::character varying)) AS importe_febrero,
    sum(pre.f_get_ejecutado_por_periodo(pp.id_partida, pp.id_presupuesto, g.id_gestion, 3, 'comprometido'::character varying)) AS importe_marzo,
    sum(pre.f_get_ejecutado_por_periodo(pp.id_partida, pp.id_presupuesto, g.id_gestion, 4, 'comprometido'::character varying)) AS importe_abril,
    sum(pre.f_get_ejecutado_por_periodo(pp.id_partida, pp.id_presupuesto, g.id_gestion, 5, 'comprometido'::character varying)) AS importe_mayo,
    sum(pre.f_get_ejecutado_por_periodo(pp.id_partida, pp.id_presupuesto, g.id_gestion, 6, 'comprometido'::character varying)) AS importe_junio,
    sum(pre.f_get_ejecutado_por_periodo(pp.id_partida, pp.id_presupuesto, g.id_gestion, 7, 'comprometido'::character varying)) AS importe_julio,
    sum(pre.f_get_ejecutado_por_periodo(pp.id_partida, pp.id_presupuesto, g.id_gestion, 8, 'comprometido'::character varying)) AS importe_agosto,
    sum(pre.f_get_ejecutado_por_periodo(pp.id_partida, pp.id_presupuesto, g.id_gestion, 9, 'comprometido'::character varying)) AS importe_septiembre,
    sum(pre.f_get_ejecutado_por_periodo(pp.id_partida, pp.id_presupuesto, g.id_gestion, 10, 'comprometido'::character varying)) AS importe_octubre,
    sum(pre.f_get_ejecutado_por_periodo(pp.id_partida, pp.id_presupuesto, g.id_gestion, 11, 'comprometido'::character varying)) AS importe_noviembre,
    sum(pre.f_get_ejecutado_por_periodo(pp.id_partida, pp.id_presupuesto, g.id_gestion, 12, 'comprometido'::character varying)) AS importe_diciembre
   FROM pre.tpresup_partida pp
     JOIN pre.tpresupuesto p ON p.id_presupuesto = pp.id_presupuesto
     JOIN pre.tcategoria_programatica cp ON cp.id_categoria_programatica = p.id_categoria_prog
     JOIN param.tgestion g ON g.id_gestion = cp.id_gestion
  GROUP BY pp.id_partida, pp.id_presup_partida, pp.id_presupuesto, p.descripcion, cp.id_categoria_programatica, cp.id_cp_programa;

CREATE OR REPLACE VIEW pre.vpartida_ejecutado_por_periodos (
    id_presup_partida,
    id_partida,
    id_presupuesto,
    descripcion,
    id_categoria_programatica,
    id_cp_programa,
    importe_enero,
    importe_febrero,
    importe_marzo,
    importe_abril,
    importe_mayo,
    importe_junio,
    importe_julio,
    importe_agosto,
    importe_septiembre,
    importe_octubre,
    importe_noviembre,
    importe_diciembre,
    id_proceso_wf,
    id_gestion)
AS
 SELECT pp.id_presup_partida,
    pp.id_partida,
    pp.id_presupuesto,
    p.descripcion,
    cp.id_categoria_programatica,
    cp.id_cp_programa,
    sum(pre.f_get_ejecutado_por_periodo(pp.id_partida, pp.id_presupuesto, cp.id_gestion, 1, 'ejecutado'::character varying)) AS importe_enero,
    sum(pre.f_get_ejecutado_por_periodo(pp.id_partida, pp.id_presupuesto, cp.id_gestion, 2, 'ejecutado'::character varying)) AS importe_febrero,
    sum(pre.f_get_ejecutado_por_periodo(pp.id_partida, pp.id_presupuesto, cp.id_gestion, 3, 'ejecutado'::character varying)) AS importe_marzo,
    sum(pre.f_get_ejecutado_por_periodo(pp.id_partida, pp.id_presupuesto, cp.id_gestion, 4, 'ejecutado'::character varying)) AS importe_abril,
    sum(pre.f_get_ejecutado_por_periodo(pp.id_partida, pp.id_presupuesto, cp.id_gestion, 5, 'ejecutado'::character varying)) AS importe_mayo,
    sum(pre.f_get_ejecutado_por_periodo(pp.id_partida, pp.id_presupuesto, cp.id_gestion, 6, 'ejecutado'::character varying)) AS importe_junio,
    sum(pre.f_get_ejecutado_por_periodo(pp.id_partida, pp.id_presupuesto, cp.id_gestion, 7, 'ejecutado'::character varying)) AS importe_julio,
    sum(pre.f_get_ejecutado_por_periodo(pp.id_partida, pp.id_presupuesto, cp.id_gestion, 8, 'ejecutado'::character varying)) AS importe_agosto,
    sum(pre.f_get_ejecutado_por_periodo(pp.id_partida, pp.id_presupuesto, cp.id_gestion, 9, 'ejecutado'::character varying)) AS importe_septiembre,
    sum(pre.f_get_ejecutado_por_periodo(pp.id_partida, pp.id_presupuesto, cp.id_gestion, 10, 'ejecutado'::character varying)) AS importe_octubre,
    sum(pre.f_get_ejecutado_por_periodo(pp.id_partida, pp.id_presupuesto, cp.id_gestion, 11, 'ejecutado'::character varying)) AS importe_noviembre,
    sum(pre.f_get_ejecutado_por_periodo(pp.id_partida, pp.id_presupuesto, cp.id_gestion, 12, 'ejecutado'::character varying)) AS importe_diciembre,
    p.id_proceso_wf,
    cp.id_gestion
   FROM pre.tpresup_partida pp
     JOIN pre.tpresupuesto p ON p.id_presupuesto = pp.id_presupuesto
     JOIN pre.tcategoria_programatica cp ON cp.id_categoria_programatica = p.id_categoria_prog
  GROUP BY pp.id_partida, pp.id_presup_partida, pp.id_presupuesto, p.descripcion, cp.id_categoria_programatica, cp.id_cp_programa, p.id_proceso_wf;

  CREATE OR REPLACE VIEW pre.vprogramando_memoria_por_periodo (
    id_presup_partida,
    id_partida,
    id_presupuesto,
    descripcion,
    id_categoria_programatica,
    id_cp_programa,
    importe_enero,
    importe_febrero,
    importe_marzo,
    importe_abril,
    importe_mayo,
    importe_junio,
    importe_julio,
    importe_agosto,
    importe_septiembre,
    importe_octubre,
    importe_noviembre,
    importe_diciembre,
    id_proceso_wf)
AS
 SELECT pp.id_presup_partida,
    pp.id_partida,
    pp.id_presupuesto,
    p.descripcion,
    cp.id_categoria_programatica,
    cp.id_cp_programa,
    sum(pre.f_get_total_programado_memoria_x_periodo(pp.id_partida, pp.id_presupuesto, per.id_periodo::numeric)) AS importe_enero,
    sum(pre.f_get_total_programado_memoria_x_periodo(pp.id_partida, pp.id_presupuesto, per.id_periodo::numeric)) AS importe_febrero,
    sum(pre.f_get_total_programado_memoria_x_periodo(pp.id_partida, pp.id_presupuesto, per.id_periodo::numeric)) AS importe_marzo,
    sum(pre.f_get_total_programado_memoria_x_periodo(pp.id_partida, pp.id_presupuesto, per.id_periodo::numeric)) AS importe_abril,
    sum(pre.f_get_total_programado_memoria_x_periodo(pp.id_partida, pp.id_presupuesto, per.id_periodo::numeric)) AS importe_mayo,
    sum(pre.f_get_total_programado_memoria_x_periodo(pp.id_partida, pp.id_presupuesto, per.id_periodo::numeric)) AS importe_junio,
    sum(pre.f_get_total_programado_memoria_x_periodo(pp.id_partida, pp.id_presupuesto, per.id_periodo::numeric)) AS importe_julio,
    sum(pre.f_get_total_programado_memoria_x_periodo(pp.id_partida, pp.id_presupuesto, per.id_periodo::numeric)) AS importe_agosto,
    sum(pre.f_get_total_programado_memoria_x_periodo(pp.id_partida, pp.id_presupuesto, per.id_periodo::numeric)) AS importe_septiembre,
    sum(pre.f_get_total_programado_memoria_x_periodo(pp.id_partida, pp.id_presupuesto, per.id_periodo::numeric)) AS importe_octubre,
    sum(pre.f_get_total_programado_memoria_x_periodo(pp.id_partida, pp.id_presupuesto, per.id_periodo::numeric)) AS importe_noviembre,
    sum(pre.f_get_total_programado_memoria_x_periodo(pp.id_partida, pp.id_presupuesto, per.id_periodo::numeric)) AS importe_diciembre,
    p.id_proceso_wf
   FROM pre.tpresup_partida pp
     JOIN pre.tpresupuesto p ON p.id_presupuesto = pp.id_presupuesto
     JOIN pre.tcategoria_programatica cp ON cp.id_categoria_programatica = p.id_categoria_prog
     JOIN param.tgestion g ON g.id_gestion = cp.id_gestion
     JOIN param.tperiodo per ON per.id_gestion = g.id_gestion
  GROUP BY pp.id_partida, pp.id_presup_partida, pp.id_presupuesto, p.descripcion, cp.id_categoria_programatica, cp.id_cp_programa, p.id_proceso_wf;
/***********************************F-DEP-MMV-PRE-0-04/08/2017*****************************************/
  



/***********************************I-DEP-RAC-PRE-0-12/10/2017*****************************************/
  


CREATE OR REPLACE VIEW pre.vpe_check_partida(
    id_gestion,
    nro_tramite,
    id_moneda,
    id_presupuesto,
    id_partida)
AS
  SELECT DISTINCT pr.id_gestion,
         pe.nro_tramite,
         pe.id_moneda,
         pe.id_presupuesto,
         pe.id_partida
  FROM pre.tpartida_ejecucion pe
       JOIN param.tperiodo pr ON pe.fecha >= pr.fecha_ini AND pe.fecha <=
         pr.fecha_fin;
         
         
CREATE OR REPLACE VIEW pre.vpartida_ejecucion_check(
    id_gestion,
    nro_tramite,
    id_moneda,
    id_presupuesto)
AS
  SELECT DISTINCT pr.id_gestion,
         pe.nro_tramite,
         pe.id_moneda,
         pe.id_presupuesto
  FROM pre.tpartida_ejecucion pe
       JOIN param.tperiodo pr ON pe.fecha >= pr.fecha_ini AND pe.fecha <=
         pr.fecha_fin;         
         
         
/***********************************F-DEP-RAC-PRE-0-12/10/2017*****************************************/
  
