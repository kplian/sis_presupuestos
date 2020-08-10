/***********************************I-DAT-RAC-PRE-0-31/12/2012*****************************************/

/*
*	Author: RAC
*	Date: 21/12/2012
*	Description: Build the menu definition and the composition
*/
/*

Para  definir la la metadata, menus, roles, etc

1) sincronize ls funciones y procedimientos del sistema
2)  verifique que la primera linea de los datos sea la insercion del sistema correspondiente
3)  exporte los datos a archivo SQL (desde la interface de sistema en sis_seguridad), 
    verifique que la codificacion  se mantenga en UTF8 para no distorcionar los caracteres especiales
4)  remplaze los sectores correspondientes en este archivo en su totalidad:  (el orden es importante)  
                             menu, 
                             funciones, 
                             procedimietnos

*/

insert into segu.tsubsistema(codigo,nombre,prefijo,nombre_carpeta) values
('PRE','Sistema de presupuesto','PRE','presupuestos');
	
-------------------------------------
--DEFINICION DE INTERFACES
-----------------------------------

select pxp.f_insert_tgui ('SISTEMA DE PRESUPUESTO', '', 'PRE', 'si', 1, '', 1, '', '', 'PRE');
select pxp.f_insert_tgui ('Catálogos', 'Catálogos varios', 'PRE.1', 'si', 1, '', 2, '', '', 'PRE');
select pxp.f_insert_tgui ('Presupuestos', 'Presupuestos varios', 'PRE.2', 'si', 2, '', 2, '', '', 'PRE');
select pxp.f_insert_tgui ('Partidas', 'Registro de partidas', 'PRE.1.1', 'si', 1, 'sis_presupuestos/vista/partida/Partida.php', 3, '', 'Partida', 'PRE');
select pxp.f_insert_tgui ('Presupuestos', 'Registro de presupuestos', 'PRE.2.1', 'si', 1, 'sis_presupuestos/vista/presupuesto/Presupuesto.php', 3, '', 'Presupuesto', 'PRE');

select pxp.f_insert_testructura_gui ('PRE', 'SISTEMA');
select pxp.f_insert_testructura_gui ('PRE.1', 'PRE');
select pxp.f_insert_testructura_gui ('PRE.2', 'PRE');
select pxp.f_insert_testructura_gui ('PRE.1.1', 'PRE.1');
select pxp.f_insert_testructura_gui ('PRE.2.1', 'PRE.2');

----------------------------------------------
--  DEF DE FUNCIONES
--------------------------------------------------
select pxp.f_insert_tfuncion ('pre.ft_presupuesto_ime', 'Funcion para tabla     ', 'PRE');
select pxp.f_insert_tfuncion ('pre.ft_partida_ime', 'Funcion para tabla     ', 'PRE');
select pxp.f_insert_tfuncion ('pre.ft_partida_sel', 'Funcion para tabla     ', 'PRE');
select pxp.f_insert_tfuncion ('pre.ft_presupuesto_sel', 'Funcion para tabla     ', 'PRE');
select pxp.f_insert_tfuncion ('pre.ft_presup_partida_ime', 'Funcion para tabla     ', 'PRE');
select pxp.f_insert_tfuncion ('pre.ft_presup_partida_sel', 'Funcion para tabla     ', 'PRE');



---------------------------------
--DEF DE PROCEDIMIETOS
---------------------------------



select pxp.f_insert_tprocedimiento ('PRE_PAR_ELI', '	Eliminacion de registros
 	', 'si', '', '', 'pre.ft_partida_ime');
select pxp.f_insert_tprocedimiento ('PRE_PAR_MOD', '	Modificacion de registros
 	', 'si', '', '', 'pre.ft_partida_ime');
select pxp.f_insert_tprocedimiento ('PRE_PAR_INS', '	Insercion de registros
 	', 'si', '', '', 'pre.ft_partida_ime');
select pxp.f_insert_tprocedimiento ('PRE_PAR_CONT', '	Conteo de registros
 	', 'si', '', '', 'pre.ft_partida_sel');
select pxp.f_insert_tprocedimiento ('PRE_PAR_ARB_SEL', 'Consulta de datos
', 'si', '', '', 'pre.ft_partida_sel');
select pxp.f_insert_tprocedimiento ('PRE_PAR_SEL', '	Consulta de datos
 	', 'si', '', '', 'pre.ft_partida_sel');
select pxp.f_insert_tprocedimiento ('PRE_SALPRE_SEL', 'CODIGO NO DOCUMENTADO', 'si', '', '', 'pre.ft_presupuesto_sel');
select pxp.f_insert_tprocedimiento ('PRE_PRE_CONT', '	Conteo de registros
 	', 'si', '', '', 'pre.ft_presupuesto_sel');
select pxp.f_insert_tprocedimiento ('PRE_PRE_SEL', '	Consulta de datos
 	', 'si', '', '', 'pre.ft_presupuesto_sel');
select pxp.f_insert_tprocedimiento ('PRE_PREPAR_ELI', '	Eliminacion de registros
 	', 'si', '', '', 'pre.ft_presup_partida_ime');
select pxp.f_insert_tprocedimiento ('PRE_PREPAR_MOD', '	Modificacion de registros
 	', 'si', '', '', 'pre.ft_presup_partida_ime');
select pxp.f_insert_tprocedimiento ('PRE_PREPAR_INS', '	Insercion de registros
 	', 'si', '', '', 'pre.ft_presup_partida_ime');
select pxp.f_insert_tprocedimiento ('PRE_PREPAR_CONT', '	Conteo de registros
 	', 'si', '', '', 'pre.ft_presup_partida_sel');
select pxp.f_insert_tprocedimiento ('PRE_PREPAR_SEL', '	Consulta de datos
 	', 'si', '', '', 'pre.ft_presup_partida_sel');
select pxp.f_insert_tprocedimiento ('PRE_PRE_ELI', '	Eliminacion de registros
 	', 'si', '', '', 'pre.ft_presupuesto_ime');
select pxp.f_insert_tprocedimiento ('PRE_PRE_MOD', '	Modificacion de registros
 	', 'si', '', '', 'pre.ft_presupuesto_ime');
select pxp.f_insert_tprocedimiento ('PRE_PRE_INS', '	Insercion de registros
 	', 'si', '', '', 'pre.ft_presupuesto_ime');




-------------------------------------
--DEFINICION DE OTROS DATOS
-----------------------------------



/***********************************F-DAT-RAC-PRE-0-31/12/2012*****************************************/

/***********************************I-DAT-GSS-PRE-38-18/02/2013*****************************************/

select pxp.f_insert_tgui ('Concepto Cuenta', 'concepto cuenta', 'CCTA', 'si', 3, 'sis_presupuestos/vista/concepto_cta/ConceptoCta.php', 3, '', 'ConceptoCta', 'PRE');


select pxp.f_insert_tfuncion ('pre.f_concepto_cta_sel', 'Funcion para tabla     ', 'PRE');
select pxp.f_insert_tfuncion ('pre.f_concepto_cta_ime', 'Funcion para tabla     ', 'PRE');

select pxp.f_insert_tgui ('Concepto Ingas', 'concepto ingreso gasto', 'CINGAS', 'si', 2, 'sis_presupuestos/vista/concepto_ingas/ConceptoIngasDir.php', 3, '', 'ConceptoIngasDir', 'PRE');


select pxp.f_insert_tprocedimiento ('PRE_CCTA_SEL', 'Consulta de datos', 'si', '', '', 'pre.f_concepto_cta_sel');
select pxp.f_insert_tprocedimiento ('PRE_CCTA_CONT', 'Conteo de registros', 'si', '', '', 'pre.f_concepto_cta_sel');
select pxp.f_insert_tprocedimiento ('PRE_CCTA_INS', 'Insercion de registros', 'si', '', '', 'pre.f_concepto_cta_ime');
select pxp.f_insert_tprocedimiento ('PRE_CCTA_MOD', 'Modificacion de registros', 'si', '', '', 'pre.f_concepto_cta_ime');
select pxp.f_insert_tprocedimiento ('PRE_CCTA_ELI', 'Eliminacion de registros', 'si', '', '', 'pre.f_concepto_cta_ime');

select pxp.f_insert_testructura_gui ('CCTA', 'PRE.1');
select pxp.f_insert_testructura_gui ('CINGAS', 'PRE.1');

/***********************************F-DAT-GSS-PRE-38-18/02/2013*****************************************/

/***********************************I-DAT-JRR-PRE-0-24/04/2014*****************************************/
select pxp.f_insert_tgui ('Partidas', 'Partidas', 'CINGAS.1', 'no', 0, 'sis_presupuestos/vista/concepto_partida/ConceptoPartida.php', 4, '', '50%', 'PRE');
select pxp.f_insert_tgui ('Hijos', 'Hijos', 'CINGAS.2', 'no', 0, 'sis_presupuestos/vista/concepto_cta/ConceptoCta.php', 4, '', '50%', 'PRE');
select pxp.f_insert_tgui ('Catálogo', 'Catálogo', 'CINGAS.3', 'no', 0, 'sis_parametros/vista/catalogo/Catalogo.php', 4, '', 'Catalogo', 'PRE');
select pxp.f_insert_tfuncion ('pre.f_gestionar_presupuesto', 'Funcion para tabla     ', 'PRE');
select pxp.f_insert_tfuncion ('pre.f_verificar_presupuesto_partida', 'Funcion para tabla     ', 'PRE');
select pxp.f_insert_tfuncion ('pre.f_verificar_com_eje_pag', 'Funcion para tabla     ', 'PRE');
select pxp.f_insert_tfuncion ('pre.f_concepto_partida_sel', 'Funcion para tabla     ', 'PRE');
select pxp.f_insert_tfuncion ('pre.f_obtener_partida_cuenta_cig', 'Funcion para tabla     ', 'PRE');
select pxp.f_insert_tfuncion ('pre.f_get_partida_ids', 'Funcion para tabla     ', 'PRE');
select pxp.f_insert_tfuncion ('pre.f_verificacion_presup_sel', 'Funcion para tabla     ', 'PRE');
select pxp.f_insert_tfuncion ('pre.f_concepto_partida_ime', 'Funcion para tabla     ', 'PRE');
select pxp.f_insert_tprocedimiento ('PRE_PAR_ELI', 'Eliminacion de registros', 'si', '', '', 'pre.ft_partida_ime');
select pxp.f_insert_tprocedimiento ('PRE_PAR_MOD', 'Modificacion de registros', 'si', '', '', 'pre.ft_partida_ime');
select pxp.f_insert_tprocedimiento ('PRE_PAR_INS', 'Insercion de registros', 'si', '', '', 'pre.ft_partida_ime');
select pxp.f_insert_tprocedimiento ('PRE_PAR_CONT', 'Conteo de registros', 'si', '', '', 'pre.ft_partida_sel');
select pxp.f_insert_tprocedimiento ('PRE_PAR_ARB_SEL', 'Consulta de datos', 'si', '', '', 'pre.ft_partida_sel');
select pxp.f_insert_tprocedimiento ('PRE_PAR_SEL', 'Consulta de datos', 'si', '', '', 'pre.ft_partida_sel');
select pxp.f_insert_tprocedimiento ('PRE_PRE_CONT', 'Conteo de registros', 'si', '', '', 'pre.ft_presupuesto_sel');
select pxp.f_insert_tprocedimiento ('PRE_PRE_SEL', 'Consulta de datos', 'si', '', '', 'pre.ft_presupuesto_sel');
select pxp.f_insert_tprocedimiento ('PRE_PREPAR_ELI', 'Eliminacion de registros', 'si', '', '', 'pre.ft_presup_partida_ime');
select pxp.f_insert_tprocedimiento ('PRE_PREPAR_MOD', 'Modificacion de registros', 'si', '', '', 'pre.ft_presup_partida_ime');
select pxp.f_insert_tprocedimiento ('PRE_PREPAR_INS', 'Insercion de registros', 'si', '', '', 'pre.ft_presup_partida_ime');
select pxp.f_insert_tprocedimiento ('PRE_PREPAR_CONT', 'Conteo de registros', 'si', '', '', 'pre.ft_presup_partida_sel');
select pxp.f_insert_tprocedimiento ('PRE_PREPAR_SEL', 'Consulta de datos', 'si', '', '', 'pre.ft_presup_partida_sel');
select pxp.f_insert_tprocedimiento ('PRE_PRE_ELI', 'Eliminacion de registros', 'si', '', '', 'pre.ft_presupuesto_ime');
select pxp.f_insert_tprocedimiento ('PRE_PRE_MOD', 'Modificacion de registros', 'si', '', '', 'pre.ft_presupuesto_ime');
select pxp.f_insert_tprocedimiento ('PRE_PRE_INS', 'Insercion de registros', 'si', '', '', 'pre.ft_presupuesto_ime');
select pxp.f_insert_tprocedimiento ('PRE_CONP_SEL', 'Consulta de datos', 'si', '', '', 'pre.f_concepto_partida_sel');
select pxp.f_insert_tprocedimiento ('PRE_CONP_CONT', 'Conteo de registros', 'si', '', '', 'pre.f_concepto_partida_sel');
select pxp.f_insert_tprocedimiento ('PRE_VERPRE_SEL', 'Verifica la disponibilidad presupuestaria, consultando el saldo por comprometer', 'si', '', '', 'pre.f_verificacion_presup_sel');
select pxp.f_insert_tprocedimiento ('PRE_VERPRE_IME', 'Interface para Verificar Presupuesto', 'si', '', '', 'pre.ft_presup_partida_ime');
select pxp.f_insert_tprocedimiento ('PRE_CONP_INS', 'Insercion de registros', 'si', '', '', 'pre.f_concepto_partida_ime');
select pxp.f_insert_tprocedimiento ('PRE_CONP_MOD', 'Modificacion de registros', 'si', '', '', 'pre.f_concepto_partida_ime');
select pxp.f_insert_tprocedimiento ('PRE_CONP_ELI', 'Eliminacion de registros', 'si', '', '', 'pre.f_concepto_partida_ime');


/***********************************F-DAT-JRR-PRE-0-24/04/2014*****************************************/






/***********************************I-DAT-RAC-PRE-0-25/06/2014*****************************************/

INSERT INTO pxp.variable_global ("variable", "valor", "descripcion")
VALUES ('error_presupuesto', E'0.02', 'error mas menos en la ejecucion de presupuesto');

/***********************************F-DAT-RAC-PRE-0-25/06/2014*****************************************/



/***********************************I-DAT-RAC-PRE-0-17/08/2015*****************************************/


INSERT INTO pxp.variable_global ("variable", "valor", "descripcion")
VALUES (E'pre_integrar_presupuestos', E'true', E'integrar con el sistema de presupeustos, realizar ejecucion y comprometer presupeusto');


/***********************************F-DAT-RAC-PRE-0-17/08/2015*****************************************/






/***********************************I-DAT-RAC-PRE-0-26/02/2016*****************************************/

INSERT INTO pre.tclase_gasto ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_usuario_ai", "usuario_ai", "codigo", "nombre")
VALUES 
  (1, NULL, E'2015-08-18 18:51:57.821', NULL, E'Activo', NULL, NULL, E'1', E'SERVICIOS PERSONALES'),
  (1, NULL, E'2015-08-18 18:51:57.821', NULL, E'Activo', NULL, NULL, E'2', E'OTROS SERVICIOS PERSONALES'),
  (1, NULL, E'2015-08-18 18:51:57.821', NULL, E'Activo', NULL, NULL, E'4', E'BIENES Y SERVICIOS'),
  (1, NULL, E'2015-08-18 18:51:57.821', NULL, E'Activo', NULL, NULL, E'5', E'SERVICIOS BASICOS'),
  (1, NULL, E'2015-08-18 18:51:57.821', NULL, E'Activo', NULL, NULL, E'7', E'CONSTRUCCIONES'),
  (1, NULL, E'2015-08-18 18:51:57.821', NULL, E'Activo', NULL, NULL, E'6', E'BIENES DE USO'),
  (1, NULL, E'2015-08-18 18:51:57.821', NULL, E'Activo', NULL, NULL, E'8', E'OTRAS DEUDAS'),
  (1, NULL, E'2015-08-18 18:51:57.821', NULL, E'Activo', NULL, NULL, E'9', E'DEUDA PUBLICA'),
  (1, NULL, E'2015-08-18 18:51:57.821', NULL, E'Activo', NULL, NULL, E'10', E'TRANSFERENCIAS CORRIENTES'),
  (1, NULL, E'2015-08-18 18:51:57.821', NULL, E'Activo', NULL, NULL, E'12', E'TRANSFERENCIAS DE CAPITAL'),
  (1, NULL, E'2015-08-18 18:51:57.821', NULL, E'Activo', NULL, NULL, E'11', E'OTROS'),
  (1, NULL, E'2015-08-18 18:51:57.821', NULL, E'Activo', NULL, NULL, E'13', E'ACTIVOS FIJOS');



/***********************************F-DAT-RAC-PRE-0-26/02/2016*****************************************/




/***********************************I-DAT-RAC-PRE-1-26/02/2016*****************************************/

select pxp.f_insert_tgui ('Tipo de Presupuesto', 'Tipos de presupuesto', 'TIPR', 'si', 5, 'sis_presupuestos/vista/tipo_presupuesto/TipoPresupuesto.php', 3, '', 'TipoPresupuesto', 'PRE');
select pxp.f_insert_testructura_gui ('TIPR', 'PRE.1');

/***********************************F-DAT-RAC-PRE-1-26/02/2016*****************************************/




/***********************************I-DAT-RAC-PRE-0-02/03/2016*****************************************/

/* Data for the 'pxp.variable_global' table  (Records 1 - 1) */

INSERT INTO pxp.variable_global ("variable", "valor", "descripcion") VALUES (E'pre_wf_codigo', E'PRE', E'codigo de proceso work flow para la formualcion de presupuesto');


select pxp.f_insert_tgui ('Presupuestos', 'Registro de presupuestos', 'PRE.2.1', 'si', 1, 'sis_presupuestos/vista/presupuesto/PresupuestoInicio.php', 3, '', 'PresupuestoInicio', 'PRE');
select pxp.f_insert_tgui ('Presupuesto VoBo', 'VoBo de presupuestos', 'PREVB', 'si', 3, 'sis_presupuestos/vista/presupuesto/PresupuestoVb.php', 3, '', 'PresupuestoVb', 'PRE');
select pxp.f_insert_tgui ('Presupuesto Formulación', 'Formulación de presupuesto ', 'PRESFR', 'si', 2, 'sis_presupuestos/vista/presupuesto/PresupuestoFor.php', 3, '', 'PresupuestoFor', 'PRE');
select pxp.f_insert_testructura_gui ('PRESFR', 'PRE.2');
select pxp.f_insert_testructura_gui ('PREVB', 'PRE.2');
select pxp.f_insert_tgui ('Autorización de Presupuesto', 'Autorización de Presupuesto', 'AUTPRE', 'si', 4, 'sis_presupuestos/vista/presupuesto/PresupuestoAprobacion.php', 3, '', 'PresupuestoAprobacion', 'PRE');
select pxp.f_insert_testructura_gui ('AUTPRE', 'PRE.2');

/***********************************F-DAT-RAC-PRE-0-02/03/2016*****************************************/



/***********************************I-DAT-RAC-PRE-0-13/03/2016*****************************************/

select pxp.f_insert_tgui ('Estado de Presupuesto', 'Estado del presupuesto', 'ESTPRE', 'si', 6, 'sis_presupuestos/vista/presupuesto/PresupuestoReporte.php', 3, '', 'PresupuestoReporte', 'PRE');

select pxp.f_insert_testructura_gui ('ESTPRE', 'PRE.2');

/***********************************F-DAT-RAC-PRE-0-13/03/2016*****************************************/



/***********************************I-DAT-RAC-PRE-0-16/03/2016*****************************************/

/* Data for the 'pre.ttipo_presupuesto' table  (Records 1 - 6) */

INSERT INTO pre.ttipo_presupuesto ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_usuario_ai", "usuario_ai", "codigo", "nombre", "descripcion", "movimiento")
VALUES 
  (1, 1, E'2016-02-29 01:49:48.610', E'2016-02-29 22:14:52.536', E'activo', NULL, E'NULL', E'1', E'Recursos', E'este presupuesto se utiliza para el registro de ingresos', E'recurso'),
  (1, NULL, E'2016-02-29 01:50:08.136', NULL, E'activo', NULL, E'NULL', E'2', E'Gasto', E'Presupuesto para gasto comunes', E'gasto'),
  (1, NULL, E'2016-02-29 01:52:47.610', NULL, E'activo', NULL, E'NULL', E'3', E'Inversión', E'Presupuesto de Inversión', E'gasto'),
  (1, NULL, E'2016-02-29 01:53:06.651', NULL, E'activo', NULL, E'NULL', E'4', E'Recursos Formulación', E'Recursos Formulación', E'recurso'),
  (1, NULL, E'2016-02-29 01:53:42.606', NULL, E'activo', NULL, E'NULL', E'5', E'gasto formulación', E'gasto formulación', E'gasto'),
  (1, NULL, E'2016-02-29 01:54:06.199', NULL, E'activo', NULL, E'NULL', E'6', E'inversión formulación', E'Inversión formulación', E'gasto');

/***********************************F-DAT-RAC-PRE-0-16/03/2016*****************************************/


/***********************************I-DAT-RAC-PRE-2-16/03/2016*****************************************/


select pxp.f_insert_tgui ('Clases de Gasto', 'Clases Gastos', 'CLAGAS', 'si', 4, 'sis_presupuestos/vista/clase_gasto/ClaseGasto.php', 3, '', 'ClaseGasto', 'PRE');
select pxp.f_insert_testructura_gui ('CLAGAS', 'PRE.1');

select pxp.f_insert_tgui ('Tipo de Presupuesto', 'Tipos de presupuesto', 'TIPR', 'si', 5, 'sis_presupuestos/vista/tipo_presupuesto/TipoPresupuesto.php', 3, '', 'TipoPresupuesto', 'PRE');
select pxp.f_insert_testructura_gui ('TIPR', 'PRE.1');


/***********************************F-DAT-RAC-PRE-2-16/03/2016*****************************************/




/***********************************I-DAT-RAC-PRE-3-16/03/2016*****************************************/



----------------------------------
--COPY LINES TO SUBSYSTEM data.sql FILE  
---------------------------------

select wf.f_import_tproceso_macro ('insert','FP', 'PRE', 'Formulación presupuestaria','si');
select wf.f_import_tcategoria_documento ('insert','legales', 'Legales');
select wf.f_import_tcategoria_documento ('insert','proceso', 'Proceso');
select wf.f_import_ttipo_proceso ('insert','PRE',NULL,NULL,'FP','Presupuesto','pre.tpresupuesto','id_presupuesto','si','','opcional','','PRE',NULL);
select wf.f_import_ttipo_estado ('insert','borrador','PRE','Borrador','si','no','no','ninguno','','ninguno','','','no','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Aviso WF ,  {PROCESO_MACRO}  ({NUM_TRAMITE})','','no','','','','','','','',NULL);
select wf.f_import_ttipo_estado ('insert','formulacion','PRE','Formulación','no','no','no','funcion_listado','pre.f_lista_resp_presupuesto','ninguno','','','si','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Aviso WF ,  {PROCESO_MACRO}  ({NUM_TRAMITE})','','no','','','','','','','',NULL);
select wf.f_import_ttipo_estado ('insert','revision','PRE','Renvisión','no','no','no','funcion_listado','pre.f_lista_aprobador_presupuesto','ninguno','','','si','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Aviso WF ,  {PROCESO_MACRO}  ({NUM_TRAMITE})','','no','','','','','','','',NULL);
select wf.f_import_ttipo_estado ('insert','aprobado','PRE','Aprobado','no','no','si','ninguno','','ninguno','','','no','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Aviso WF ,  {PROCESO_MACRO}  ({NUM_TRAMITE})','','no','','','','','','','',NULL);
select wf.f_import_ttipo_estado ('insert','vobopre','PRE','VoBo Presupuestos','no','no','no','listado','','ninguno','','','si','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Aviso WF ,  {PROCESO_MACRO}  ({NUM_TRAMITE})','','no','','','','','','','',NULL);
select wf.f_import_testructura_estado ('insert','borrador','formulacion','PRE',1,'');
select wf.f_import_testructura_estado ('insert','formulacion','revision','PRE',1,'');
select wf.f_import_testructura_estado ('delete','revision','aprobado','PRE',NULL,NULL);
select wf.f_import_testructura_estado ('insert','revision','vobopre','PRE',1,'');
select wf.f_import_testructura_estado ('insert','vobopre','aprobado','PRE',1,'');


/***********************************F-DAT-RAC-PRE-3-16/03/2016*****************************************/



/*******************************************I-DAT-RAC-PRE-0-13/04/2016***********************************************/



select wf.f_import_tproceso_macro ('insert','AJT', 'PRE', 'Ajustes Presupuestarios','si');
select wf.f_import_tcategoria_documento ('insert','legales', 'Legales');
select wf.f_import_tcategoria_documento ('insert','proceso', 'Proceso');
select wf.f_import_ttipo_proceso ('insert','AJUSTE',NULL,NULL,'AJT','Ajuste Presupuestario','','','','','','','AJUSTE',NULL);
select wf.f_import_ttipo_estado ('insert','borrador','AJUSTE','Borrador','si','no','no','ninguno','','ninguno','','','no','si',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Aviso WF ,  {PROCESO_MACRO}  ({NUM_TRAMITE})','','no','','','','','','','',NULL);
select wf.f_import_ttipo_estado ('insert','revision','AJUSTE','Revisión','no','no','no','todos','','depto_listado','','','si','si',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Aviso WF ,  {PROCESO_MACRO}  ({NUM_TRAMITE})','','no','','','','','','','',NULL);
select wf.f_import_ttipo_estado ('insert','aprobado','AJUSTE','Aprobado','no','no','no','anterior','','anterior','','','no','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Aviso WF ,  {PROCESO_MACRO}  ({NUM_TRAMITE})','','no','','','','','','','',NULL);
select wf.f_import_testructura_estado ('insert','borrador','revision','AJUSTE',1,'');
select wf.f_import_testructura_estado ('insert','revision','aprobado','AJUSTE',1,'');



/*******************************************F-DAT-RAC-PRE-0-13/04/2016***********************************************/



/*******************************************I-DAT-RAC-PRE-0-21/04/2016***********************************************/


select param.f_import_tcatalogo_tipo ('insert','unidad_medida','PRE','tmemoria_calculo');
select param.f_import_tcatalogo ('insert','PRE','unidad','unidad','unidad_medida');
select param.f_import_tcatalogo ('insert','PRE','meses','meses','unidad_medida');
select param.f_import_tcatalogo ('insert','PRE','global','global','unidad_medida');
select param.f_import_tcatalogo ('insert','PRE','pieza','pieza','unidad_medida');



/*******************************************F-DAT-RAC-PRE-0-21/04/2016***********************************************/




/*******************************************I-DAT-RAC-PRE-0-27/04/2016***********************************************/

select pxp.f_insert_tgui ('<i class="fa fa-line-chart fa-2x"></i> PRESUPUESTOS', '', 'PRE', 'si', 6, '', 1, '', '', 'PRE');
select pxp.f_insert_tgui ('Catálogos', 'Catálogos varios', 'PRE.1', 'si', 1, '', 2, '', '', 'PRE');
select pxp.f_insert_tgui ('Presupuestos', 'Presupuestos varios', 'PRE.2', 'si', 2, '', 2, '', '', 'PRE');
select pxp.f_insert_tgui ('Partidas', 'Registro de partidas', 'PRE.1.1', 'si', 1, 'sis_presupuestos/vista/partida/Partida.php', 3, '', 'Partida', 'PRE');
select pxp.f_insert_tgui ('Presupuestos', 'Registro de presupuestos', 'PRE.2.1', 'si', 1, 'sis_presupuestos/vista/presupuesto/PresupuestoInicio.php', 3, '', 'PresupuestoInicio', 'PRE');
select pxp.f_insert_tgui ('Concepto Cuenta', 'concepto cuenta', 'CCTA', 'no', 3, 'sis_presupuestos/vista/concepto_cta/ConceptoCta.php', 3, '', 'ConceptoCta', 'PRE');
select pxp.f_insert_tgui ('Concepto Ingas', 'concepto ingreso gasto', 'CINGAS', 'si', 2, 'sis_presupuestos/vista/concepto_ingas/ConceptoIngasDir.php', 3, '', 'ConceptoIngasDir', 'PRE');
select pxp.f_insert_tgui ('Partidas', 'Partidas', 'CINGAS.1', 'no', 0, 'sis_presupuestos/vista/concepto_partida/ConceptoPartida.php', 4, '', '50%', 'PRE');
select pxp.f_insert_tgui ('Hijos', 'Hijos', 'CINGAS.2', 'no', 0, 'sis_presupuestos/vista/concepto_cta/ConceptoCta.php', 4, '', '50%', 'PRE');
select pxp.f_insert_tgui ('Catálogo', 'Catálogo', 'CINGAS.3', 'no', 0, 'sis_parametros/vista/catalogo/Catalogo.php', 4, '', 'Catalogo', 'PRE');
select pxp.f_insert_tgui ('Tipo de Presupuesto', 'Tipos de presupuesto', 'TIPR', 'si', 5, 'sis_presupuestos/vista/tipo_presupuesto/TipoPresupuesto.php', 3, '', 'TipoPresupuesto', 'PRE');
select pxp.f_insert_tgui ('Presupuesto VoBo', 'VoBo de presupuestos', 'PREVB', 'si', 3, 'sis_presupuestos/vista/presupuesto/PresupuestoVb.php', 3, '', 'PresupuestoVb', 'PRE');
select pxp.f_insert_tgui ('Presupuesto Formulación', 'Formulación de presupuesto ', 'PRESFR', 'si', 2, 'sis_presupuestos/vista/presupuesto/PresupuestoFor.php', 3, '', 'PresupuestoFor', 'PRE');
select pxp.f_insert_tgui ('Autorización de Presupuesto', 'Autorización de Presupuesto', 'AUTPRE', 'si', 4, 'sis_presupuestos/vista/presupuesto/PresupuestoAprobacion.php', 3, '', 'PresupuestoAprobacion', 'PRE');
select pxp.f_insert_tgui ('Estado de Presupuesto', 'Estado del presupuesto', 'ESTPRE', 'si', 6, 'sis_presupuestos/vista/presupuesto/PresupuestoReporte.php', 3, '', 'PresupuestoReporte', 'PRE');
select pxp.f_insert_tgui ('Clases de Gasto', 'Clases Gastos', 'CLAGAS', 'si', 4, 'sis_presupuestos/vista/clase_gasto/ClaseGasto.php', 3, '', 'ClaseGasto', 'PRE');
select pxp.f_insert_tgui ('Ajustes Presupuestarios', 'Ajustes al presupuesto', 'AJTPRE', 'si', 1, 'sis_presupuestos/vista/ajuste/AjusteInicio.php', 3, '', 'AjusteInicio', 'PRE');
select pxp.f_insert_tgui ('Formulación', 'Formulación', 'FORMU', 'si', 1, '', 3, '', '', 'PRE');
select pxp.f_insert_tgui ('Ajustes', 'Ajustes de presupuesto', 'AJUSTE', 'si', 2, '', 3, '', '', 'PRE');
select pxp.f_insert_tgui ('VoBo Ajustes', 'VoBo Ajustes', 'VBAJT', 'si', 2, 'sis_presupuestos/vista/ajuste/AjusteVb.php', 4, '', 'AjusteVb', 'PRE');
select pxp.f_insert_tgui ('Categoría Programatica', 'Categoría Programatica', 'CCTPR', 'si', 20, '', 3, '', '', 'PRE');
select pxp.f_insert_tgui ('Programa', 'Programa', 'CPP', 'si', 1, 'sis_presupuestos/vista/cp_programa/CpPrograma.php', 4, '', 'CpPrograma', 'PRE');
select pxp.f_insert_tgui ('Proyecto', 'Proyecto', 'CPPR', 'si', 2, 'sis_presupuestos/vista/cp_proyecto/CpProyecto.php', 4, '', 'CpProyecto', 'PRE');
select pxp.f_insert_tgui ('Actividad', 'Actividad', 'CPAC', 'si', 3, 'sis_presupuestos/vista/cp_actividad/CpActividad.php', 4, '', 'CpActividad', 'PRE');
select pxp.f_insert_tgui ('Organismo Financiador', 'Organismo Financiador', 'ORFI', 'si', 4, 'sis_presupuestos/vista/cp_organismo_fin/CpOrganismoFin.php', 4, '', 'CpOrganismoFin', 'PRE');
select pxp.f_insert_tgui ('Fuentes de Financiamiento', 'Fuentes de Financiamiento', 'CPFF', 'si', 5, 'sis_presupuestos/vista/cp_fuente_fin/CpFuenteFin.php', 4, '', 'CpFuenteFin', 'PRE');
select pxp.f_insert_tgui ('Categoria Programatica', 'Categoria Programatica', 'CATPRO', 'si', 8, 'sis_presupuestos/vista/categoria_programatica/CategoriaProgramatica.php', 4, '', 'CategoriaProgramatica', 'PRE');
select pxp.f_insert_tgui ('Reportes', 'Reportes de Presupeustos', 'REPPRE', 'si', 10, '', 2, '', '', 'PRE');
select pxp.f_insert_tgui ('Memoria de Calculo', 'Memoria de Calculo', 'MEMCAL', 'si', 1, 'sis_presupuestos/vista/memoria_calculo/FormRepMemoria.php', 3, '', 'FormRepMemoria', 'PRE');
select pxp.f_insert_tgui ('Programación Presupuesto', 'Programación', 'PROGPRE', 'si', 2, 'sis_presupuestos/vista/memoria_calculo/FormRepProgramacion.php', 3, '', 'FormRepProgramacion', 'PRE');
select pxp.f_insert_tgui ('Ejecución Presupuestaria', 'Ejecución Presupuestaria', 'EJEPRE', 'si', 3, 'sis_presupuestos/vista/presup_partida/FormRepEjecucion.php', 3, '', 'FormRepEjecucion', 'PRE');
select pxp.f_insert_tgui ('Ejecución por Partida', 'Ejecución por Partida', 'EJEPAR', 'si', 4, 'sis_presupuestos/vista/presup_partida/FormRepEjecucionPorPartida.php', 3, '', 'FormRepEjecucionPorPartida', 'PRE');
select pxp.f_insert_tgui ('Partida Ejecucion', 'Partida Ejecucion', 'PAREJE', 'si', 6, 'sis_presupuestos/vista/partida_ejecucion/FormFiltro.php', 3, '', 'FormFiltro', 'PRE');
select pxp.f_insert_tgui ('Composición del Presupuesto', 'Composición del Presupuesto', 'PRE.2.1.1', 'no', 0, 'sis_presupuestos/vista/rel_pre/RelPre.php', 4, '', '60%', 'PRE');
select pxp.f_insert_tgui ('Partidas', 'Partidas', 'PRE.2.1.2', 'no', 0, 'sis_presupuestos/vista/presup_partida/PresupPartidaInicio.php', 4, '', '60%', 'PRE');
select pxp.f_insert_tgui ('Funcionarios', 'Funcionarios', 'PRE.2.1.3', 'no', 0, 'sis_presupuestos/vista/presupuesto_funcionario/PresupuestoFuncionario.php', 4, '', '60%', 'PRE');
select pxp.f_insert_tgui ('Composición', 'Composición', 'PRE.2.1.4', 'no', 0, 'sis_presupuestos/vista/rel_pre/RelPreInicio.php', 4, '', '60%', 'PRE');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'PRE.2.1.5', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 4, '', 'FormEstadoWf', 'PRE');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'PRE.2.1.6', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 4, '', '90%', 'PRE');
select pxp.f_insert_tgui ('Observaciones del WF', 'Observaciones del WF', 'PRE.2.1.7', 'no', 0, 'sis_workflow/vista/obs/Obs.php', 4, '', '80%', 'PRE');
select pxp.f_insert_tgui ('Memoria de Calculo', 'Memoria de Calculo', 'PRE.2.1.8', 'no', 0, 'sis_presupuestos/vista/memoria_calculo/MemoriaCalculo.php', 4, '', '98%', 'PRE');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'PRE.2.1.9', 'no', 0, 'sis_workflow/vista/estado_wf/AntFormEstadoWf.php', 4, '', 'AntFormEstadoWf', 'PRE');
select pxp.f_insert_tgui ('Funcionarios', 'Funcionarios', 'PRE.2.1.3.1', 'no', 0, 'sis_organigrama/vista/funcionario/Funcionario.php', 5, '', 'funcionario', 'PRE');
select pxp.f_insert_tgui ('Cuenta Bancaria del Empleado', 'Cuenta Bancaria del Empleado', 'PRE.2.1.3.1.1', 'no', 0, 'sis_organigrama/vista/funcionario_cuenta_bancaria/FuncionarioCuentaBancaria.php', 6, '', 'FuncionarioCuentaBancaria', 'PRE');
select pxp.f_insert_tgui ('Especialidad del Empleado', 'Especialidad del Empleado', 'PRE.2.1.3.1.2', 'no', 0, 'sis_organigrama/vista/funcionario_especialidad/FuncionarioEspecialidad.php', 6, '', 'FuncionarioEspecialidad', 'PRE');
select pxp.f_insert_tgui ('Personas', 'Personas', 'PRE.2.1.3.1.3', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 6, '', 'persona', 'PRE');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'PRE.2.1.3.1.1.1', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 7, '', 'Institucion', 'PRE');
select pxp.f_insert_tgui ('Personas', 'Personas', 'PRE.2.1.3.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 8, '', 'persona', 'PRE');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'PRE.2.1.3.1.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 9, '', 'subirFotoPersona', 'PRE');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'PRE.2.1.3.1.1.1.1.2', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 9, '', 'Archivo', 'PRE');
select pxp.f_insert_tgui ('Interfaces', 'Interfaces', 'PRE.2.1.3.1.1.1.1.2.1', 'no', 0, 'sis_parametros/vista/archivo/upload.php', 10, '', 'subirArchivo', 'PRE');
select pxp.f_insert_tgui ('ArchivoHistorico', 'ArchivoHistorico', 'PRE.2.1.3.1.1.1.1.2.2', 'no', 0, 'sis_parametros/vista/archivo/ArchivoHistorico.php', 10, '', 'ArchivoHistorico', 'PRE');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'PRE.2.1.5.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 5, '', '90%', 'PRE');
select pxp.f_insert_tgui ('Subir ', 'Subir ', 'PRE.2.1.5.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/SubirArchivoWf.php', 6, '', 'SubirArchivoWf', 'PRE');
select pxp.f_insert_tgui ('Documentos de Origen', 'Documentos de Origen', 'PRE.2.1.5.1.2', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 6, '', '90%', 'PRE');
select pxp.f_insert_tgui ('Histórico', 'Histórico', 'PRE.2.1.5.1.3', 'no', 0, 'sis_workflow/vista/documento_historico_wf/DocumentoHistoricoWf.php', 6, '', '30%', 'PRE');
select pxp.f_insert_tgui ('Estados por momento', 'Estados por momento', 'PRE.2.1.5.1.4', 'no', 0, 'sis_workflow/vista/tipo_documento_estado/TipoDocumentoEstadoWF.php', 6, '', '40%', 'PRE');
select pxp.f_insert_tgui ('Pagos similares', 'Pagos similares', 'PRE.2.1.5.1.5', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepFilPlanPago.php', 6, '', '90%', 'PRE');
select pxp.f_insert_tgui ('73%', '73%', 'PRE.2.1.5.1.5.1', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepPlanPago.php', 7, '', 'RepPlanPago', 'PRE');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'PRE.2.1.5.1.5.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 8, '', '90%', 'PRE');
select pxp.f_insert_tgui ('Funcionarios', 'Funcionarios', 'PRE.2.1.7.1', 'no', 0, 'sis_organigrama/vista/funcionario/Funcionario.php', 5, '', 'funcionario', 'PRE');
select pxp.f_insert_tgui ('Distribución', 'Distribución', 'PRE.2.1.8.1', 'no', 0, 'sis_presupuestos/vista/memoria_det/MemoriaDet.php', 5, '', '50%', 'PRE');
select pxp.f_insert_tgui ('Catálogo', 'Catálogo', 'PRE.2.1.8.1.1', 'no', 0, 'sis_parametros/vista/catalogo/Catalogo.php', 6, '', 'Catalogo', 'PRE');
select pxp.f_insert_tgui ('Subir', 'Subir', 'CINGAS.4', 'no', 0, 'sis_parametros/vista/concepto_ingas/subirImagenConcepto.php', 4, '', 'subirImagenConcepto', 'PRE');
select pxp.f_insert_tgui ('Unidades de Medida', 'Unidades de Medida', 'CINGAS.5', 'no', 0, 'sis_parametros/vista/unidad_medida/UnidadMedida.php', 4, '', 'UnidadMedida', 'PRE');
select pxp.f_insert_tgui ('Catálogo', 'Catálogo', 'CINGAS.5.1', 'no', 0, 'sis_parametros/vista/catalogo/Catalogo.php', 5, '', 'Catalogo', 'PRE');
select pxp.f_insert_tgui ('Partidas', 'Partidas', 'PREVB.1', 'no', 0, 'sis_presupuestos/vista/presup_partida/PresupPartidaVb.php', 4, '', '60%', 'PRE');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'PREVB.2', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 4, '', 'FormEstadoWf', 'PRE');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'PREVB.3', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 4, '', '90%', 'PRE');
select pxp.f_insert_tgui ('Observaciones del WF', 'Observaciones del WF', 'PREVB.4', 'no', 0, 'sis_workflow/vista/obs/Obs.php', 4, '', '80%', 'PRE');
select pxp.f_insert_tgui ('Memoria de Calculo', 'Memoria de Calculo', 'PREVB.5', 'no', 0, 'sis_presupuestos/vista/memoria_calculo/MemoriaCalculo.php', 4, '', '98%', 'PRE');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'PREVB.6', 'no', 0, 'sis_workflow/vista/estado_wf/AntFormEstadoWf.php', 4, '', 'AntFormEstadoWf', 'PRE');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'PREVB.2.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 5, '', '90%', 'PRE');
select pxp.f_insert_tgui ('Subir ', 'Subir ', 'PREVB.2.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/SubirArchivoWf.php', 6, '', 'SubirArchivoWf', 'PRE');
select pxp.f_insert_tgui ('Documentos de Origen', 'Documentos de Origen', 'PREVB.2.1.2', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 6, '', '90%', 'PRE');
select pxp.f_insert_tgui ('Histórico', 'Histórico', 'PREVB.2.1.3', 'no', 0, 'sis_workflow/vista/documento_historico_wf/DocumentoHistoricoWf.php', 6, '', '30%', 'PRE');
select pxp.f_insert_tgui ('Estados por momento', 'Estados por momento', 'PREVB.2.1.4', 'no', 0, 'sis_workflow/vista/tipo_documento_estado/TipoDocumentoEstadoWF.php', 6, '', '40%', 'PRE');
select pxp.f_insert_tgui ('Pagos similares', 'Pagos similares', 'PREVB.2.1.5', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepFilPlanPago.php', 6, '', '90%', 'PRE');
select pxp.f_insert_tgui ('73%', '73%', 'PREVB.2.1.5.1', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepPlanPago.php', 7, '', 'RepPlanPago', 'PRE');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'PREVB.2.1.5.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 8, '', '90%', 'PRE');
select pxp.f_insert_tgui ('Funcionarios', 'Funcionarios', 'PREVB.4.1', 'no', 0, 'sis_organigrama/vista/funcionario/Funcionario.php', 5, '', 'funcionario', 'PRE');
select pxp.f_insert_tgui ('Cuenta Bancaria del Empleado', 'Cuenta Bancaria del Empleado', 'PREVB.4.1.1', 'no', 0, 'sis_organigrama/vista/funcionario_cuenta_bancaria/FuncionarioCuentaBancaria.php', 6, '', 'FuncionarioCuentaBancaria', 'PRE');
select pxp.f_insert_tgui ('Especialidad del Empleado', 'Especialidad del Empleado', 'PREVB.4.1.2', 'no', 0, 'sis_organigrama/vista/funcionario_especialidad/FuncionarioEspecialidad.php', 6, '', 'FuncionarioEspecialidad', 'PRE');
select pxp.f_insert_tgui ('Personas', 'Personas', 'PREVB.4.1.3', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 6, '', 'persona', 'PRE');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'PREVB.4.1.1.1', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 7, '', 'Institucion', 'PRE');
select pxp.f_insert_tgui ('Personas', 'Personas', 'PREVB.4.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 8, '', 'persona', 'PRE');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'PREVB.4.1.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 9, '', 'subirFotoPersona', 'PRE');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'PREVB.4.1.1.1.1.2', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 9, '', 'Archivo', 'PRE');
select pxp.f_insert_tgui ('Interfaces', 'Interfaces', 'PREVB.4.1.1.1.1.2.1', 'no', 0, 'sis_parametros/vista/archivo/upload.php', 10, '', 'subirArchivo', 'PRE');
select pxp.f_insert_tgui ('ArchivoHistorico', 'ArchivoHistorico', 'PREVB.4.1.1.1.1.2.2', 'no', 0, 'sis_parametros/vista/archivo/ArchivoHistorico.php', 10, '', 'ArchivoHistorico', 'PRE');
select pxp.f_insert_tgui ('Distribución', 'Distribución', 'PREVB.5.1', 'no', 0, 'sis_presupuestos/vista/memoria_det/MemoriaDet.php', 5, '', '50%', 'PRE');
select pxp.f_insert_tgui ('Catálogo', 'Catálogo', 'PREVB.5.1.1', 'no', 0, 'sis_parametros/vista/catalogo/Catalogo.php', 6, '', 'Catalogo', 'PRE');
select pxp.f_insert_tgui ('Partidas', 'Partidas', 'PRESFR.1', 'no', 0, 'sis_presupuestos/vista/presup_partida/PresupPartidaForm.php', 4, '', '60%', 'PRE');
select pxp.f_insert_tgui ('Composición', 'Composición', 'PRESFR.2', 'no', 0, 'sis_presupuestos/vista/rel_pre/RelPreFor.php', 4, '', '60%', 'PRE');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'PRESFR.3', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 4, '', 'FormEstadoWf', 'PRE');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'PRESFR.4', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 4, '', '90%', 'PRE');
select pxp.f_insert_tgui ('Observaciones del WF', 'Observaciones del WF', 'PRESFR.5', 'no', 0, 'sis_workflow/vista/obs/Obs.php', 4, '', '80%', 'PRE');
select pxp.f_insert_tgui ('Memoria de Calculo', 'Memoria de Calculo', 'PRESFR.6', 'no', 0, 'sis_presupuestos/vista/memoria_calculo/MemoriaCalculo.php', 4, '', '98%', 'PRE');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'PRESFR.7', 'no', 0, 'sis_workflow/vista/estado_wf/AntFormEstadoWf.php', 4, '', 'AntFormEstadoWf', 'PRE');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'PRESFR.3.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 5, '', '90%', 'PRE');
select pxp.f_insert_tgui ('Subir ', 'Subir ', 'PRESFR.3.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/SubirArchivoWf.php', 6, '', 'SubirArchivoWf', 'PRE');
select pxp.f_insert_tgui ('Documentos de Origen', 'Documentos de Origen', 'PRESFR.3.1.2', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 6, '', '90%', 'PRE');
select pxp.f_insert_tgui ('Histórico', 'Histórico', 'PRESFR.3.1.3', 'no', 0, 'sis_workflow/vista/documento_historico_wf/DocumentoHistoricoWf.php', 6, '', '30%', 'PRE');
select pxp.f_insert_tgui ('Estados por momento', 'Estados por momento', 'PRESFR.3.1.4', 'no', 0, 'sis_workflow/vista/tipo_documento_estado/TipoDocumentoEstadoWF.php', 6, '', '40%', 'PRE');
select pxp.f_insert_tgui ('Pagos similares', 'Pagos similares', 'PRESFR.3.1.5', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepFilPlanPago.php', 6, '', '90%', 'PRE');
select pxp.f_insert_tgui ('73%', '73%', 'PRESFR.3.1.5.1', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepPlanPago.php', 7, '', 'RepPlanPago', 'PRE');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'PRESFR.3.1.5.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 8, '', '90%', 'PRE');
select pxp.f_insert_tgui ('Funcionarios', 'Funcionarios', 'PRESFR.5.1', 'no', 0, 'sis_organigrama/vista/funcionario/Funcionario.php', 5, '', 'funcionario', 'PRE');
select pxp.f_insert_tgui ('Cuenta Bancaria del Empleado', 'Cuenta Bancaria del Empleado', 'PRESFR.5.1.1', 'no', 0, 'sis_organigrama/vista/funcionario_cuenta_bancaria/FuncionarioCuentaBancaria.php', 6, '', 'FuncionarioCuentaBancaria', 'PRE');
select pxp.f_insert_tgui ('Especialidad del Empleado', 'Especialidad del Empleado', 'PRESFR.5.1.2', 'no', 0, 'sis_organigrama/vista/funcionario_especialidad/FuncionarioEspecialidad.php', 6, '', 'FuncionarioEspecialidad', 'PRE');
select pxp.f_insert_tgui ('Personas', 'Personas', 'PRESFR.5.1.3', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 6, '', 'persona', 'PRE');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'PRESFR.5.1.1.1', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 7, '', 'Institucion', 'PRE');
select pxp.f_insert_tgui ('Personas', 'Personas', 'PRESFR.5.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 8, '', 'persona', 'PRE');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'PRESFR.5.1.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 9, '', 'subirFotoPersona', 'PRE');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'PRESFR.5.1.1.1.1.2', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 9, '', 'Archivo', 'PRE');
select pxp.f_insert_tgui ('Interfaces', 'Interfaces', 'PRESFR.5.1.1.1.1.2.1', 'no', 0, 'sis_parametros/vista/archivo/upload.php', 10, '', 'subirArchivo', 'PRE');
select pxp.f_insert_tgui ('ArchivoHistorico', 'ArchivoHistorico', 'PRESFR.5.1.1.1.1.2.2', 'no', 0, 'sis_parametros/vista/archivo/ArchivoHistorico.php', 10, '', 'ArchivoHistorico', 'PRE');
select pxp.f_insert_tgui ('Distribución', 'Distribución', 'PRESFR.6.1', 'no', 0, 'sis_presupuestos/vista/memoria_det/MemoriaDet.php', 5, '', '50%', 'PRE');
select pxp.f_insert_tgui ('Catálogo', 'Catálogo', 'PRESFR.6.1.1', 'no', 0, 'sis_parametros/vista/catalogo/Catalogo.php', 6, '', 'Catalogo', 'PRE');
select pxp.f_insert_tgui ('Partidas', 'Partidas', 'AUTPRE.1', 'no', 0, 'sis_presupuestos/vista/presup_partida/PresupPartidaAprobacion.php', 4, '', '60%', 'PRE');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'AUTPRE.2', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 4, '', 'FormEstadoWf', 'PRE');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'AUTPRE.3', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 4, '', '90%', 'PRE');
select pxp.f_insert_tgui ('Observaciones del WF', 'Observaciones del WF', 'AUTPRE.4', 'no', 0, 'sis_workflow/vista/obs/Obs.php', 4, '', '80%', 'PRE');
select pxp.f_insert_tgui ('Memoria de Calculo', 'Memoria de Calculo', 'AUTPRE.5', 'no', 0, 'sis_presupuestos/vista/memoria_calculo/MemoriaCalculo.php', 4, '', '98%', 'PRE');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'AUTPRE.6', 'no', 0, 'sis_workflow/vista/estado_wf/AntFormEstadoWf.php', 4, '', 'AntFormEstadoWf', 'PRE');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'AUTPRE.2.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 5, '', '90%', 'PRE');
select pxp.f_insert_tgui ('Subir ', 'Subir ', 'AUTPRE.2.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/SubirArchivoWf.php', 6, '', 'SubirArchivoWf', 'PRE');
select pxp.f_insert_tgui ('Documentos de Origen', 'Documentos de Origen', 'AUTPRE.2.1.2', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 6, '', '90%', 'PRE');
select pxp.f_insert_tgui ('Histórico', 'Histórico', 'AUTPRE.2.1.3', 'no', 0, 'sis_workflow/vista/documento_historico_wf/DocumentoHistoricoWf.php', 6, '', '30%', 'PRE');
select pxp.f_insert_tgui ('Estados por momento', 'Estados por momento', 'AUTPRE.2.1.4', 'no', 0, 'sis_workflow/vista/tipo_documento_estado/TipoDocumentoEstadoWF.php', 6, '', '40%', 'PRE');
select pxp.f_insert_tgui ('Pagos similares', 'Pagos similares', 'AUTPRE.2.1.5', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepFilPlanPago.php', 6, '', '90%', 'PRE');
select pxp.f_insert_tgui ('73%', '73%', 'AUTPRE.2.1.5.1', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepPlanPago.php', 7, '', 'RepPlanPago', 'PRE');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'AUTPRE.2.1.5.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 8, '', '90%', 'PRE');
select pxp.f_insert_tgui ('Funcionarios', 'Funcionarios', 'AUTPRE.4.1', 'no', 0, 'sis_organigrama/vista/funcionario/Funcionario.php', 5, '', 'funcionario', 'PRE');
select pxp.f_insert_tgui ('Cuenta Bancaria del Empleado', 'Cuenta Bancaria del Empleado', 'AUTPRE.4.1.1', 'no', 0, 'sis_organigrama/vista/funcionario_cuenta_bancaria/FuncionarioCuentaBancaria.php', 6, '', 'FuncionarioCuentaBancaria', 'PRE');
select pxp.f_insert_tgui ('Especialidad del Empleado', 'Especialidad del Empleado', 'AUTPRE.4.1.2', 'no', 0, 'sis_organigrama/vista/funcionario_especialidad/FuncionarioEspecialidad.php', 6, '', 'FuncionarioEspecialidad', 'PRE');
select pxp.f_insert_tgui ('Personas', 'Personas', 'AUTPRE.4.1.3', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 6, '', 'persona', 'PRE');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'AUTPRE.4.1.1.1', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 7, '', 'Institucion', 'PRE');
select pxp.f_insert_tgui ('Personas', 'Personas', 'AUTPRE.4.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 8, '', 'persona', 'PRE');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'AUTPRE.4.1.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 9, '', 'subirFotoPersona', 'PRE');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'AUTPRE.4.1.1.1.1.2', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 9, '', 'Archivo', 'PRE');
select pxp.f_insert_tgui ('Interfaces', 'Interfaces', 'AUTPRE.4.1.1.1.1.2.1', 'no', 0, 'sis_parametros/vista/archivo/upload.php', 10, '', 'subirArchivo', 'PRE');
select pxp.f_insert_tgui ('ArchivoHistorico', 'ArchivoHistorico', 'AUTPRE.4.1.1.1.1.2.2', 'no', 0, 'sis_parametros/vista/archivo/ArchivoHistorico.php', 10, '', 'ArchivoHistorico', 'PRE');
select pxp.f_insert_tgui ('Distribución', 'Distribución', 'AUTPRE.5.1', 'no', 0, 'sis_presupuestos/vista/memoria_det/MemoriaDet.php', 5, '', '50%', 'PRE');
select pxp.f_insert_tgui ('Catálogo', 'Catálogo', 'AUTPRE.5.1.1', 'no', 0, 'sis_parametros/vista/catalogo/Catalogo.php', 6, '', 'Catalogo', 'PRE');
select pxp.f_insert_tgui ('Partidas', 'Partidas', 'ESTPRE.1', 'no', 0, 'sis_presupuestos/vista/presup_partida/PresupPartidaEstado.php', 4, '', '70%', 'PRE');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'ESTPRE.2', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 4, '', 'FormEstadoWf', 'PRE');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'ESTPRE.3', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 4, '', '90%', 'PRE');
select pxp.f_insert_tgui ('Observaciones del WF', 'Observaciones del WF', 'ESTPRE.4', 'no', 0, 'sis_workflow/vista/obs/Obs.php', 4, '', '80%', 'PRE');
select pxp.f_insert_tgui ('Memoria de Calculo', 'Memoria de Calculo', 'ESTPRE.5', 'no', 0, 'sis_presupuestos/vista/memoria_calculo/MemoriaCalculo.php', 4, '', '98%', 'PRE');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'ESTPRE.6', 'no', 0, 'sis_workflow/vista/estado_wf/AntFormEstadoWf.php', 4, '', 'AntFormEstadoWf', 'PRE');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'ESTPRE.2.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 5, '', '90%', 'PRE');
select pxp.f_insert_tgui ('Subir ', 'Subir ', 'ESTPRE.2.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/SubirArchivoWf.php', 6, '', 'SubirArchivoWf', 'PRE');
select pxp.f_insert_tgui ('Documentos de Origen', 'Documentos de Origen', 'ESTPRE.2.1.2', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 6, '', '90%', 'PRE');
select pxp.f_insert_tgui ('Histórico', 'Histórico', 'ESTPRE.2.1.3', 'no', 0, 'sis_workflow/vista/documento_historico_wf/DocumentoHistoricoWf.php', 6, '', '30%', 'PRE');
select pxp.f_insert_tgui ('Estados por momento', 'Estados por momento', 'ESTPRE.2.1.4', 'no', 0, 'sis_workflow/vista/tipo_documento_estado/TipoDocumentoEstadoWF.php', 6, '', '40%', 'PRE');
select pxp.f_insert_tgui ('Pagos similares', 'Pagos similares', 'ESTPRE.2.1.5', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepFilPlanPago.php', 6, '', '90%', 'PRE');
select pxp.f_insert_tgui ('73%', '73%', 'ESTPRE.2.1.5.1', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepPlanPago.php', 7, '', 'RepPlanPago', 'PRE');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'ESTPRE.2.1.5.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 8, '', '90%', 'PRE');
select pxp.f_insert_tgui ('Funcionarios', 'Funcionarios', 'ESTPRE.4.1', 'no', 0, 'sis_organigrama/vista/funcionario/Funcionario.php', 5, '', 'funcionario', 'PRE');
select pxp.f_insert_tgui ('Cuenta Bancaria del Empleado', 'Cuenta Bancaria del Empleado', 'ESTPRE.4.1.1', 'no', 0, 'sis_organigrama/vista/funcionario_cuenta_bancaria/FuncionarioCuentaBancaria.php', 6, '', 'FuncionarioCuentaBancaria', 'PRE');
select pxp.f_insert_tgui ('Especialidad del Empleado', 'Especialidad del Empleado', 'ESTPRE.4.1.2', 'no', 0, 'sis_organigrama/vista/funcionario_especialidad/FuncionarioEspecialidad.php', 6, '', 'FuncionarioEspecialidad', 'PRE');
select pxp.f_insert_tgui ('Personas', 'Personas', 'ESTPRE.4.1.3', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 6, '', 'persona', 'PRE');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'ESTPRE.4.1.1.1', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 7, '', 'Institucion', 'PRE');
select pxp.f_insert_tgui ('Personas', 'Personas', 'ESTPRE.4.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 8, '', 'persona', 'PRE');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'ESTPRE.4.1.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 9, '', 'subirFotoPersona', 'PRE');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'ESTPRE.4.1.1.1.1.2', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 9, '', 'Archivo', 'PRE');
select pxp.f_insert_tgui ('Interfaces', 'Interfaces', 'ESTPRE.4.1.1.1.1.2.1', 'no', 0, 'sis_parametros/vista/archivo/upload.php', 10, '', 'subirArchivo', 'PRE');
select pxp.f_insert_tgui ('ArchivoHistorico', 'ArchivoHistorico', 'ESTPRE.4.1.1.1.1.2.2', 'no', 0, 'sis_parametros/vista/archivo/ArchivoHistorico.php', 10, '', 'ArchivoHistorico', 'PRE');
select pxp.f_insert_tgui ('Distribución', 'Distribución', 'ESTPRE.5.1', 'no', 0, 'sis_presupuestos/vista/memoria_det/MemoriaDet.php', 5, '', '50%', 'PRE');
select pxp.f_insert_tgui ('Catálogo', 'Catálogo', 'ESTPRE.5.1.1', 'no', 0, 'sis_parametros/vista/catalogo/Catalogo.php', 6, '', 'Catalogo', 'PRE');
select pxp.f_insert_tgui ('Partidas', 'Partidas', 'CLAGAS.1', 'no', 0, 'sis_presupuestos/vista/clase_gasto_partida/ClaseGastoPartida.php', 4, '', '60%', 'PRE');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'AJTPRE.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 4, '', '90%', 'PRE');
select pxp.f_insert_tgui ('Observaciones del WF', 'Observaciones del WF', 'AJTPRE.2', 'no', 0, 'sis_workflow/vista/obs/Obs.php', 4, '', '80%', 'PRE');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'AJTPRE.3', 'no', 0, 'sis_workflow/vista/estado_wf/AntFormEstadoWf.php', 4, '', 'AntFormEstadoWf', 'PRE');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'AJTPRE.4', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 4, '', 'FormEstadoWf', 'PRE');
select pxp.f_insert_tgui ('Decrementos (-)', 'Decrementos (-)', 'AJTPRE.5', 'no', 0, 'sis_presupuestos/vista/ajuste_det/AjusteDetDec.php', 4, '', '60%', 'PRE');
select pxp.f_insert_tgui ('Incrementos (+)', 'Incrementos (+)', 'AJTPRE.6', 'no', 0, 'sis_presupuestos/vista/ajuste_det/AjusteDetInc.php', 4, '', '60%', 'PRE');
select pxp.f_insert_tgui ('Subir ', 'Subir ', 'AJTPRE.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/SubirArchivoWf.php', 5, '', 'SubirArchivoWf', 'PRE');
select pxp.f_insert_tgui ('Documentos de Origen', 'Documentos de Origen', 'AJTPRE.1.2', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 5, '', '90%', 'PRE');
select pxp.f_insert_tgui ('Histórico', 'Histórico', 'AJTPRE.1.3', 'no', 0, 'sis_workflow/vista/documento_historico_wf/DocumentoHistoricoWf.php', 5, '', '30%', 'PRE');
select pxp.f_insert_tgui ('Estados por momento', 'Estados por momento', 'AJTPRE.1.4', 'no', 0, 'sis_workflow/vista/tipo_documento_estado/TipoDocumentoEstadoWF.php', 5, '', '40%', 'PRE');
select pxp.f_insert_tgui ('Pagos similares', 'Pagos similares', 'AJTPRE.1.5', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepFilPlanPago.php', 5, '', '90%', 'PRE');
select pxp.f_insert_tgui ('73%', '73%', 'AJTPRE.1.5.1', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepPlanPago.php', 6, '', 'RepPlanPago', 'PRE');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'AJTPRE.1.5.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 7, '', '90%', 'PRE');
select pxp.f_insert_tgui ('Funcionarios', 'Funcionarios', 'AJTPRE.2.1', 'no', 0, 'sis_organigrama/vista/funcionario/Funcionario.php', 5, '', 'funcionario', 'PRE');
select pxp.f_insert_tgui ('Cuenta Bancaria del Empleado', 'Cuenta Bancaria del Empleado', 'AJTPRE.2.1.1', 'no', 0, 'sis_organigrama/vista/funcionario_cuenta_bancaria/FuncionarioCuentaBancaria.php', 6, '', 'FuncionarioCuentaBancaria', 'PRE');
select pxp.f_insert_tgui ('Especialidad del Empleado', 'Especialidad del Empleado', 'AJTPRE.2.1.2', 'no', 0, 'sis_organigrama/vista/funcionario_especialidad/FuncionarioEspecialidad.php', 6, '', 'FuncionarioEspecialidad', 'PRE');
select pxp.f_insert_tgui ('Personas', 'Personas', 'AJTPRE.2.1.3', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 6, '', 'persona', 'PRE');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'AJTPRE.2.1.1.1', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 7, '', 'Institucion', 'PRE');
select pxp.f_insert_tgui ('Personas', 'Personas', 'AJTPRE.2.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 8, '', 'persona', 'PRE');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'AJTPRE.2.1.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 9, '', 'subirFotoPersona', 'PRE');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'AJTPRE.2.1.1.1.1.2', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 9, '', 'Archivo', 'PRE');
select pxp.f_insert_tgui ('Interfaces', 'Interfaces', 'AJTPRE.2.1.1.1.1.2.1', 'no', 0, 'sis_parametros/vista/archivo/upload.php', 10, '', 'subirArchivo', 'PRE');
select pxp.f_insert_tgui ('ArchivoHistorico', 'ArchivoHistorico', 'AJTPRE.2.1.1.1.1.2.2', 'no', 0, 'sis_parametros/vista/archivo/ArchivoHistorico.php', 10, '', 'ArchivoHistorico', 'PRE');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'AJTPRE.4.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 5, '', '90%', 'PRE');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'VBAJT.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 5, '', '90%', 'PRE');
select pxp.f_insert_tgui ('Observaciones del WF', 'Observaciones del WF', 'VBAJT.2', 'no', 0, 'sis_workflow/vista/obs/Obs.php', 5, '', '80%', 'PRE');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'VBAJT.3', 'no', 0, 'sis_workflow/vista/estado_wf/AntFormEstadoWf.php', 5, '', 'AntFormEstadoWf', 'PRE');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'VBAJT.4', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 5, '', 'FormEstadoWf', 'PRE');
select pxp.f_insert_tgui ('Decrementos (-)', 'Decrementos (-)', 'VBAJT.5', 'no', 0, 'sis_presupuestos/vista/ajuste_det/AjusteDetDec.php', 5, '', '60%', 'PRE');
select pxp.f_insert_tgui ('Incrementos (+)', 'Incrementos (+)', 'VBAJT.6', 'no', 0, 'sis_presupuestos/vista/ajuste_det/AjusteDetInc.php', 5, '', '60%', 'PRE');
select pxp.f_insert_tgui ('Subir ', 'Subir ', 'VBAJT.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/SubirArchivoWf.php', 6, '', 'SubirArchivoWf', 'PRE');
select pxp.f_insert_tgui ('Documentos de Origen', 'Documentos de Origen', 'VBAJT.1.2', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 6, '', '90%', 'PRE');
select pxp.f_insert_tgui ('Histórico', 'Histórico', 'VBAJT.1.3', 'no', 0, 'sis_workflow/vista/documento_historico_wf/DocumentoHistoricoWf.php', 6, '', '30%', 'PRE');
select pxp.f_insert_tgui ('Estados por momento', 'Estados por momento', 'VBAJT.1.4', 'no', 0, 'sis_workflow/vista/tipo_documento_estado/TipoDocumentoEstadoWF.php', 6, '', '40%', 'PRE');
select pxp.f_insert_tgui ('Pagos similares', 'Pagos similares', 'VBAJT.1.5', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepFilPlanPago.php', 6, '', '90%', 'PRE');
select pxp.f_insert_tgui ('73%', '73%', 'VBAJT.1.5.1', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepPlanPago.php', 7, '', 'RepPlanPago', 'PRE');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'VBAJT.1.5.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 8, '', '90%', 'PRE');
select pxp.f_insert_tgui ('Funcionarios', 'Funcionarios', 'VBAJT.2.1', 'no', 0, 'sis_organigrama/vista/funcionario/Funcionario.php', 6, '', 'funcionario', 'PRE');
select pxp.f_insert_tgui ('Cuenta Bancaria del Empleado', 'Cuenta Bancaria del Empleado', 'VBAJT.2.1.1', 'no', 0, 'sis_organigrama/vista/funcionario_cuenta_bancaria/FuncionarioCuentaBancaria.php', 7, '', 'FuncionarioCuentaBancaria', 'PRE');
select pxp.f_insert_tgui ('Especialidad del Empleado', 'Especialidad del Empleado', 'VBAJT.2.1.2', 'no', 0, 'sis_organigrama/vista/funcionario_especialidad/FuncionarioEspecialidad.php', 7, '', 'FuncionarioEspecialidad', 'PRE');
select pxp.f_insert_tgui ('Personas', 'Personas', 'VBAJT.2.1.3', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 7, '', 'persona', 'PRE');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'VBAJT.2.1.1.1', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 8, '', 'Institucion', 'PRE');
select pxp.f_insert_tgui ('Personas', 'Personas', 'VBAJT.2.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 9, '', 'persona', 'PRE');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'VBAJT.2.1.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 10, '', 'subirFotoPersona', 'PRE');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'VBAJT.2.1.1.1.1.2', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 10, '', 'Archivo', 'PRE');
select pxp.f_insert_tgui ('Interfaces', 'Interfaces', 'VBAJT.2.1.1.1.1.2.1', 'no', 0, 'sis_parametros/vista/archivo/upload.php', 11, '', 'subirArchivo', 'PRE');
select pxp.f_insert_tgui ('ArchivoHistorico', 'ArchivoHistorico', 'VBAJT.2.1.1.1.1.2.2', 'no', 0, 'sis_parametros/vista/archivo/ArchivoHistorico.php', 11, '', 'ArchivoHistorico', 'PRE');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'VBAJT.4.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 6, '', '90%', 'PRE');
select pxp.f_insert_tgui ('Detalle Ejecucion', 'Detalle Ejecucion', 'PAREJE.1', 'no', 0, 'sis_presupuestos/vista/partida_ejecucion/PartidaEjecucion.php', 4, '', '70%', 'PRE');
select pxp.f_insert_tgui ('<i class="fa fa-search fa-2x"></i>Consulta Concepto Ingas', 'Consulta Concepto Ingas', 'CON_INGAS', 'si', 14, 'sis_presupuestos/vista/concepto_ingas/ConsultaConceptoIngas.php', 3, '', 'ConsultaConceptoIngas', 'PRE');
select pxp.f_insert_tgui ('Consulta de Procesos de Ajustes', 'Consulta de Ajustes', 'CONAJU', 'si', 3, 'sis_presupuestos/vista/ajuste/AjusteConsulta.php', 4, '', 'AjusteConsulta', 'PRE');
select pxp.f_insert_tgui ('Evaluación Ejecución', 'Evaluación Ejecución', 'EPE', 'si', 6, 'sis_presupuestos/vista/partida_ejecutado/FormPartidaEjecutado.php', 3, '', 'FormPartidaEjecutado', 'PRE');
select pxp.f_insert_tgui ('Objetivos', 'Objetivos', 'PRE.2.1.10', 'no', 0, 'sis_presupuestos/vista/presupuesto_objetivo/PresupuestoObjetivo.php', 4, '', '50%', 'PRE');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'PRE.2.1.3.1.4', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 6, '', 'Archivo', 'PRE');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'PREVB.4.1.4', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 6, '', 'Archivo', 'PRE');
select pxp.f_insert_tgui ('Objetivos', 'Objetivos', 'PRESFR.8', 'no', 0, 'sis_presupuestos/vista/presupuesto_objetivo/PresupuestoObjetivoForm.php', 4, '', '50%', 'PRE');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'PRESFR.5.1.4', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 6, '', 'Archivo', 'PRE');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'AUTPRE.4.1.4', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 6, '', 'Archivo', 'PRE');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'ESTPRE.4.1.4', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 6, '', 'Archivo', 'PRE');
select pxp.f_insert_tgui ('Estado del Presupuesto', 'Estado del Presupuesto', 'AJTPRE.7', 'no', 0, 'sis_presupuestos/vista/presup_partida/ChkPresupuesto.php', 4, '', 'ChkPresupuesto', 'PRE');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'AJTPRE.2.1.4', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 6, '', 'Archivo', 'PRE');
select pxp.f_insert_tgui ('Estado del Presupuesto', 'Estado del Presupuesto', 'VBAJT.7', 'no', 0, 'sis_presupuestos/vista/presup_partida/ChkPresupuesto.php', 5, '', 'ChkPresupuesto', 'PRE');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'VBAJT.2.1.4', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 7, '', 'Archivo', 'PRE');
select pxp.f_insert_tgui ('Decrementos (-)', 'Decrementos (-)', 'CONAJU.1', 'no', 0, 'sis_presupuestos/vista/ajuste_det/AjusteDetDecConsulta.php', 5, '', '60%', 'PRE');
select pxp.f_insert_tgui ('Incrementos (+)', 'Incrementos (+)', 'CONAJU.2', 'no', 0, 'sis_presupuestos/vista/ajuste_det/AjusteDetIncConsulta.php', 5, '', '60%', 'PRE');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'CONAJU.3', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 5, '', '90%', 'PRE');
select pxp.f_insert_tgui ('Observaciones del WF', 'Observaciones del WF', 'CONAJU.4', 'no', 0, 'sis_workflow/vista/obs/Obs.php', 5, '', '80%', 'PRE');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'CONAJU.5', 'no', 0, 'sis_workflow/vista/estado_wf/AntFormEstadoWf.php', 5, '', 'AntFormEstadoWf', 'PRE');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'CONAJU.6', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 5, '', 'FormEstadoWf', 'PRE');
select pxp.f_insert_tgui ('Estado del Presupuesto', 'Estado del Presupuesto', 'CONAJU.7', 'no', 0, 'sis_presupuestos/vista/presup_partida/ChkPresupuesto.php', 5, '', 'ChkPresupuesto', 'PRE');
select pxp.f_insert_tgui ('Decrementos (-)', 'Decrementos (-)', 'CONAJU.8', 'no', 0, 'sis_presupuestos/vista/ajuste_det/AjusteDetDec.php', 5, '', '60%', 'PRE');
select pxp.f_insert_tgui ('Incrementos (+)', 'Incrementos (+)', 'CONAJU.9', 'no', 0, 'sis_presupuestos/vista/ajuste_det/AjusteDetInc.php', 5, '', '60%', 'PRE');
select pxp.f_insert_tgui ('Subir ', 'Subir ', 'CONAJU.3.1', 'no', 0, 'sis_workflow/vista/documento_wf/SubirArchivoWf.php', 6, '', 'SubirArchivoWf', 'PRE');
select pxp.f_insert_tgui ('Documentos de Origen', 'Documentos de Origen', 'CONAJU.3.2', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 6, '', '90%', 'PRE');
select pxp.f_insert_tgui ('Histórico', 'Histórico', 'CONAJU.3.3', 'no', 0, 'sis_workflow/vista/documento_historico_wf/DocumentoHistoricoWf.php', 6, '', '30%', 'PRE');
select pxp.f_insert_tgui ('Estados por momento', 'Estados por momento', 'CONAJU.3.4', 'no', 0, 'sis_workflow/vista/tipo_documento_estado/TipoDocumentoEstadoWF.php', 6, '', '40%', 'PRE');
select pxp.f_insert_tgui ('Pagos similares', 'Pagos similares', 'CONAJU.3.5', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepFilPlanPago.php', 6, '', '90%', 'PRE');
select pxp.f_insert_tgui ('73%', '73%', 'CONAJU.3.5.1', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepPlanPago.php', 7, '', 'RepPlanPago', 'PRE');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'CONAJU.3.5.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 8, '', '90%', 'PRE');
select pxp.f_insert_tgui ('Funcionarios', 'Funcionarios', 'CONAJU.4.1', 'no', 0, 'sis_organigrama/vista/funcionario/Funcionario.php', 6, '', 'funcionario', 'PRE');
select pxp.f_insert_tgui ('Cuenta Bancaria del Empleado', 'Cuenta Bancaria del Empleado', 'CONAJU.4.1.1', 'no', 0, 'sis_organigrama/vista/funcionario_cuenta_bancaria/FuncionarioCuentaBancaria.php', 7, '', 'FuncionarioCuentaBancaria', 'PRE');
select pxp.f_insert_tgui ('Especialidad del Empleado', 'Especialidad del Empleado', 'CONAJU.4.1.2', 'no', 0, 'sis_organigrama/vista/funcionario_especialidad/FuncionarioEspecialidad.php', 7, '', 'FuncionarioEspecialidad', 'PRE');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'CONAJU.4.1.3', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 7, '', 'Archivo', 'PRE');
select pxp.f_insert_tgui ('Personas', 'Personas', 'CONAJU.4.1.4', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 7, '', 'persona', 'PRE');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'CONAJU.4.1.1.1', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 8, '', 'Institucion', 'PRE');
select pxp.f_insert_tgui ('Personas', 'Personas', 'CONAJU.4.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 9, '', 'persona', 'PRE');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'CONAJU.4.1.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 10, '', 'subirFotoPersona', 'PRE');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'CONAJU.4.1.1.1.1.2', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 10, '', 'Archivo', 'PRE');
select pxp.f_insert_tgui ('Interfaces', 'Interfaces', 'CONAJU.4.1.1.1.1.2.1', 'no', 0, 'sis_parametros/vista/archivo/upload.php', 11, '', 'subirArchivo', 'PRE');
select pxp.f_insert_tgui ('ArchivoHistorico', 'ArchivoHistorico', 'CONAJU.4.1.1.1.1.2.2', 'no', 0, 'sis_parametros/vista/archivo/ArchivoHistorico.php', 11, '', 'ArchivoHistorico', 'PRE');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'CONAJU.6.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 6, '', '90%', 'PRE');
select pxp.f_insert_tgui ('InstitucionPersona', 'InstitucionPersona', 'PRE.2.1.3.1.1.1.2', 'no', 0, 'sis_parametros/vista/institucion_persona/InstitucionPersona.php', 8, '', 'Persona Institucion', 'PRE');
select pxp.f_insert_tgui ('Personas', 'Personas', 'PRE.2.1.3.1.1.1.2.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 9, '', 'persona', 'PRE');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'PRE.2.1.3.1.1.1.2.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 10, '', 'subirFotoPersona', 'PRE');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'PRE.2.1.3.1.1.1.2.1.2', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 10, '', 'Archivo', 'PRE');
select pxp.f_insert_tgui ('Interfaces', 'Interfaces', 'PRE.2.1.3.1.1.1.2.1.2.1', 'no', 0, 'sis_parametros/vista/archivo/upload.php', 11, '', 'subirArchivo', 'PRE');
select pxp.f_insert_tgui ('ArchivoHistorico', 'ArchivoHistorico', 'PRE.2.1.3.1.1.1.2.1.2.2', 'no', 0, 'sis_parametros/vista/archivo/ArchivoHistorico.php', 11, '', 'ArchivoHistorico', 'PRE');
select pxp.f_insert_tgui ('InstitucionPersona', 'InstitucionPersona', 'PREVB.4.1.1.1.2', 'no', 0, 'sis_parametros/vista/institucion_persona/InstitucionPersona.php', 8, '', 'Persona Institucion', 'PRE');
select pxp.f_insert_tgui ('Personas', 'Personas', 'PREVB.4.1.1.1.2.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 9, '', 'persona', 'PRE');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'PREVB.4.1.1.1.2.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 10, '', 'subirFotoPersona', 'PRE');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'PREVB.4.1.1.1.2.1.2', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 10, '', 'Archivo', 'PRE');
select pxp.f_insert_tgui ('Interfaces', 'Interfaces', 'PREVB.4.1.1.1.2.1.2.1', 'no', 0, 'sis_parametros/vista/archivo/upload.php', 11, '', 'subirArchivo', 'PRE');
select pxp.f_insert_tgui ('ArchivoHistorico', 'ArchivoHistorico', 'PREVB.4.1.1.1.2.1.2.2', 'no', 0, 'sis_parametros/vista/archivo/ArchivoHistorico.php', 11, '', 'ArchivoHistorico', 'PRE');
select pxp.f_insert_tgui ('InstitucionPersona', 'InstitucionPersona', 'PRESFR.5.1.1.1.2', 'no', 0, 'sis_parametros/vista/institucion_persona/InstitucionPersona.php', 8, '', 'Persona Institucion', 'PRE');
select pxp.f_insert_tgui ('Personas', 'Personas', 'PRESFR.5.1.1.1.2.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 9, '', 'persona', 'PRE');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'PRESFR.5.1.1.1.2.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 10, '', 'subirFotoPersona', 'PRE');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'PRESFR.5.1.1.1.2.1.2', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 10, '', 'Archivo', 'PRE');
select pxp.f_insert_tgui ('Interfaces', 'Interfaces', 'PRESFR.5.1.1.1.2.1.2.1', 'no', 0, 'sis_parametros/vista/archivo/upload.php', 11, '', 'subirArchivo', 'PRE');
select pxp.f_insert_tgui ('ArchivoHistorico', 'ArchivoHistorico', 'PRESFR.5.1.1.1.2.1.2.2', 'no', 0, 'sis_parametros/vista/archivo/ArchivoHistorico.php', 11, '', 'ArchivoHistorico', 'PRE');
select pxp.f_insert_tgui ('InstitucionPersona', 'InstitucionPersona', 'AUTPRE.4.1.1.1.2', 'no', 0, 'sis_parametros/vista/institucion_persona/InstitucionPersona.php', 8, '', 'Persona Institucion', 'PRE');
select pxp.f_insert_tgui ('Personas', 'Personas', 'AUTPRE.4.1.1.1.2.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 9, '', 'persona', 'PRE');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'AUTPRE.4.1.1.1.2.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 10, '', 'subirFotoPersona', 'PRE');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'AUTPRE.4.1.1.1.2.1.2', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 10, '', 'Archivo', 'PRE');
select pxp.f_insert_tgui ('Interfaces', 'Interfaces', 'AUTPRE.4.1.1.1.2.1.2.1', 'no', 0, 'sis_parametros/vista/archivo/upload.php', 11, '', 'subirArchivo', 'PRE');
select pxp.f_insert_tgui ('ArchivoHistorico', 'ArchivoHistorico', 'AUTPRE.4.1.1.1.2.1.2.2', 'no', 0, 'sis_parametros/vista/archivo/ArchivoHistorico.php', 11, '', 'ArchivoHistorico', 'PRE');
select pxp.f_insert_tgui ('InstitucionPersona', 'InstitucionPersona', 'ESTPRE.4.1.1.1.2', 'no', 0, 'sis_parametros/vista/institucion_persona/InstitucionPersona.php', 8, '', 'Persona Institucion', 'PRE');
select pxp.f_insert_tgui ('Personas', 'Personas', 'ESTPRE.4.1.1.1.2.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 9, '', 'persona', 'PRE');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'ESTPRE.4.1.1.1.2.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 10, '', 'subirFotoPersona', 'PRE');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'ESTPRE.4.1.1.1.2.1.2', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 10, '', 'Archivo', 'PRE');
select pxp.f_insert_tgui ('Interfaces', 'Interfaces', 'ESTPRE.4.1.1.1.2.1.2.1', 'no', 0, 'sis_parametros/vista/archivo/upload.php', 11, '', 'subirArchivo', 'PRE');
select pxp.f_insert_tgui ('ArchivoHistorico', 'ArchivoHistorico', 'ESTPRE.4.1.1.1.2.1.2.2', 'no', 0, 'sis_parametros/vista/archivo/ArchivoHistorico.php', 11, '', 'ArchivoHistorico', 'PRE');
select pxp.f_insert_tgui ('InstitucionPersona', 'InstitucionPersona', 'AJTPRE.2.1.1.1.2', 'no', 0, 'sis_parametros/vista/institucion_persona/InstitucionPersona.php', 8, '', 'Persona Institucion', 'PRE');
select pxp.f_insert_tgui ('Personas', 'Personas', 'AJTPRE.2.1.1.1.2.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 9, '', 'persona', 'PRE');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'AJTPRE.2.1.1.1.2.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 10, '', 'subirFotoPersona', 'PRE');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'AJTPRE.2.1.1.1.2.1.2', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 10, '', 'Archivo', 'PRE');
select pxp.f_insert_tgui ('Interfaces', 'Interfaces', 'AJTPRE.2.1.1.1.2.1.2.1', 'no', 0, 'sis_parametros/vista/archivo/upload.php', 11, '', 'subirArchivo', 'PRE');
select pxp.f_insert_tgui ('ArchivoHistorico', 'ArchivoHistorico', 'AJTPRE.2.1.1.1.2.1.2.2', 'no', 0, 'sis_parametros/vista/archivo/ArchivoHistorico.php', 11, '', 'ArchivoHistorico', 'PRE');
select pxp.f_insert_tgui ('InstitucionPersona', 'InstitucionPersona', 'VBAJT.2.1.1.1.2', 'no', 0, 'sis_parametros/vista/institucion_persona/InstitucionPersona.php', 9, '', 'Persona Institucion', 'PRE');
select pxp.f_insert_tgui ('Personas', 'Personas', 'VBAJT.2.1.1.1.2.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 10, '', 'persona', 'PRE');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'VBAJT.2.1.1.1.2.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 11, '', 'subirFotoPersona', 'PRE');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'VBAJT.2.1.1.1.2.1.2', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 11, '', 'Archivo', 'PRE');
select pxp.f_insert_tgui ('Interfaces', 'Interfaces', 'VBAJT.2.1.1.1.2.1.2.1', 'no', 0, 'sis_parametros/vista/archivo/upload.php', 12, '', 'subirArchivo', 'PRE');
select pxp.f_insert_tgui ('ArchivoHistorico', 'ArchivoHistorico', 'VBAJT.2.1.1.1.2.1.2.2', 'no', 0, 'sis_parametros/vista/archivo/ArchivoHistorico.php', 12, '', 'ArchivoHistorico', 'PRE');
select pxp.f_insert_tgui ('InstitucionPersona', 'InstitucionPersona', 'CONAJU.4.1.1.1.2', 'no', 0, 'sis_parametros/vista/institucion_persona/InstitucionPersona.php', 9, '', 'Persona Institucion', 'PRE');
select pxp.f_insert_tgui ('Personas', 'Personas', 'CONAJU.4.1.1.1.2.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 10, '', 'persona', 'PRE');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'CONAJU.4.1.1.1.2.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 11, '', 'subirFotoPersona', 'PRE');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'CONAJU.4.1.1.1.2.1.2', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 11, '', 'Archivo', 'PRE');
select pxp.f_insert_tgui ('Interfaces', 'Interfaces', 'CONAJU.4.1.1.1.2.1.2.1', 'no', 0, 'sis_parametros/vista/archivo/upload.php', 12, '', 'subirArchivo', 'PRE');
select pxp.f_insert_tgui ('ArchivoHistorico', 'ArchivoHistorico', 'CONAJU.4.1.1.1.2.1.2.2', 'no', 0, 'sis_parametros/vista/archivo/ArchivoHistorico.php', 12, '', 'ArchivoHistorico', 'PRE');
select pxp.f_insert_tgui ('Subir Presupuestos', 'Subir Presupuestos', 'PRESFR.9', 'no', 0, 'sis_presupuestos/vista/memoria_calculo/SubirArchivoPre.php', 4, '', 'SubirArchivoPre', 'PRE');
select pxp.f_insert_tgui ('Funcionarios', 'Funcionarios', 'PRESFR.9.1', 'no', 0, 'sis_organigrama/vista/funcionario/Funcionario.php', 5, '', 'funcionario', 'PRE');
select pxp.f_insert_tgui ('Cuenta Bancaria del Empleado', 'Cuenta Bancaria del Empleado', 'PRESFR.9.1.1', 'no', 0, 'sis_organigrama/vista/funcionario_cuenta_bancaria/FuncionarioCuentaBancaria.php', 6, '', 'FuncionarioCuentaBancaria', 'PRE');
select pxp.f_insert_tgui ('Especialidad del Empleado', 'Especialidad del Empleado', 'PRESFR.9.1.2', 'no', 0, 'sis_organigrama/vista/funcionario_especialidad/FuncionarioEspecialidad.php', 6, '', 'FuncionarioEspecialidad', 'PRE');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'PRESFR.9.1.3', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 6, '', 'Archivo', 'PRE');
select pxp.f_insert_tgui ('Personas', 'Personas', 'PRESFR.9.1.4', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 6, '', 'persona', 'PRE');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'PRESFR.9.1.1.1', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 7, '', 'Institucion', 'PRE');
select pxp.f_insert_tgui ('InstitucionPersona', 'InstitucionPersona', 'PRESFR.9.1.1.1.1', 'no', 0, 'sis_parametros/vista/institucion_persona/InstitucionPersona.php', 8, '', 'Persona Institucion', 'PRE');
select pxp.f_insert_tgui ('Personas', 'Personas', 'PRESFR.9.1.1.1.2', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 8, '', 'persona', 'PRE');
select pxp.f_insert_tgui ('Personas', 'Personas', 'PRESFR.9.1.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 9, '', 'persona', 'PRE');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'PRESFR.9.1.1.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 10, '', 'subirFotoPersona', 'PRE');
select pxp.f_insert_tgui ('Archivo', 'Archivo', 'PRESFR.9.1.1.1.1.1.2', 'no', 0, 'sis_parametros/vista/archivo/Archivo.php', 10, '', 'Archivo', 'PRE');
select pxp.f_insert_tgui ('Interfaces', 'Interfaces', 'PRESFR.9.1.1.1.1.1.2.1', 'no', 0, 'sis_parametros/vista/archivo/upload.php', 11, '', 'subirArchivo', 'PRE');
select pxp.f_insert_tgui ('ArchivoHistorico', 'ArchivoHistorico', 'PRESFR.9.1.1.1.1.1.2.2', 'no', 0, 'sis_parametros/vista/archivo/ArchivoHistorico.php', 11, '', 'ArchivoHistorico', 'PRE');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'PAREJE.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 5, '', '90%', 'PRE');
select pxp.f_insert_tgui ('Estado del Presupuesto', 'Estado del Presupuesto', 'PAREJE.1.2', 'no', 0, 'sis_presupuestos/vista/presup_partida/ChkPresupuesto.php', 5, '', 'ChkPresupuesto', 'PRE');
select pxp.f_insert_tgui ('Subir ', 'Subir ', 'PAREJE.1.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/SubirArchivoWf.php', 6, '', 'SubirArchivoWf', 'PRE');
select pxp.f_insert_tgui ('Documentos de Origen', 'Documentos de Origen', 'PAREJE.1.1.2', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 6, '', '90%', 'PRE');
select pxp.f_insert_tgui ('Histórico', 'Histórico', 'PAREJE.1.1.3', 'no', 0, 'sis_workflow/vista/documento_historico_wf/DocumentoHistoricoWf.php', 6, '', '30%', 'PRE');
select pxp.f_insert_tgui ('Estados por momento', 'Estados por momento', 'PAREJE.1.1.4', 'no', 0, 'sis_workflow/vista/tipo_documento_estado/TipoDocumentoEstadoWF.php', 6, '', '40%', 'PRE');
select pxp.f_insert_tgui ('Pagos similares', 'Pagos similares', 'PAREJE.1.1.5', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepFilPlanPago.php', 6, '', '90%', 'PRE');
select pxp.f_insert_tgui ('73%', '73%', 'PAREJE.1.1.5.1', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepPlanPago.php', 7, '', 'RepPlanPago', 'PRE');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'PAREJE.1.1.5.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 8, '', '90%', 'PRE');
select pxp.f_insert_tgui ('Pendientes de ejecución', 'Pendientes de ejecución', 'PENEJE', 'si', 6, 'sis_presupuestos/reportes/RPendienteEjecucion.php', 3, '', 'RPendienteEjecucion', 'PRE');
/*******************************************F-DAT-RAC-PRE-0-27/04/2016***********************************************/


/*******************************************I-DAT-RAC-PRE-0-16/11/2016***********************************************/
select pxp.f_insert_tgui ('Partida Ejecucion', 'Partida Ejecucion', 'PAREJE', 'si', 6, 'sis_presupuestos/vista/partida_ejecucion/FormFiltro.php', 3, '', 'FormFiltro', 'PRE');

/*******************************************F-DAT-RAC-PRE-0-16/11/2016***********************************************/


/*******************************************I-DAT-RAC-PRE-0-29/06/2017***********************************************/

/* Data for the 'pxp.variable_global' table  (Records 1 - 1) */

INSERT INTO pxp.variable_global ("variable", "valor", "descripcion")
VALUES 
  (E'pre_verificar_tipo_cc', E'no', E'si o no, verificacion presupeustaria por el arbol de tipo_cc, el valor depende del valor de  pre_verificar_categoria, solo se osnidera si es igual a no');


/*******************************************F-DAT-RAC-PRE-0-29/06/2017***********************************************/





/***********************************I-DAT-RAC-PARAM-1-11/10/2017*****************************************/


INSERT INTO pxp.variable_global ("variable", "valor", "descripcion")
VALUES 
  (E'pre_codigo_proc_macajsutable', E'''TES-PD'',''PU'',''CINTPD'',''CNAPD''', E'codigo de preocesos macro que pueden ajustarce desde la interface de  modificaciones presupuestarias');


/***********************************F-DAT-RAC-PARAM-1-11/10/2017*****************************************/

/*******************************************I-DAT-MMV-PRE-2-20/12/2018***********************************************/
select pxp.f_insert_tgui ('Replicacion Partidas', 'Replicacion Partidas', 'RPS', 'si', 11, 'sis_presupuestos/vista/partida_ids/PartidaIds.php', 3, '', 'PartidaIds', 'PRE');
select pxp.f_insert_testructura_gui ('RPS', 'PRE.1');
select pxp.f_insert_tgui ('Replicacion Presupuesto', 'Replicacion Presupuesto', 'RPP', 'si', 12, 'sis_presupuestos/vista/presupuesto_ids/PresupuestoIds.php', 3, '', 'PresupuestoIds', 'PRE');
select pxp.f_insert_testructura_gui ('RPP', 'PRE.1');
/*******************************************F-DAT-MMV-PRE-2-20/12/2018***********************************************/
/*******************************************I-DAT-MMV-PRE-11-12/02/2018***********************************************/
select pxp.f_insert_tgui ('Integridad Presupuestaria', 'Integridad Presupuestaria', 'IPR', 'si', 15, 'sis_presupuestos/vista/integridad_presupuestaria/IntegridadPresupuestaria.php', 3, '', 'IntegridadPresupuestaria', 'PRE');
select pxp.f_insert_testructura_gui ('IPR', 'REPPRE');
/*******************************************F-DAT-MMV-PRE-1-12/02/2018***********************************************/

/*******************************************I-DAT-JJA-PRE-11-31/03/2020***********************************************/
select pxp.f_insert_tgui ('Ejecución proyectos', 'Ejecución proyectos', 'EJEPRO', 'si', 16, 'sis_presupuestos/reportes/formulario/Partida_ejecucion_proveedor.php', 3, '', 'Partida_ejecucion_proveedor', 'PRE'); --#37
/*******************************************F-DAT-JJA-PRE-1-31/03/2020***********************************************/

/*******************************************I-DAT-JJA-PRE-11-09/07/2020***********************************************/
select param.f_import_tcatalogo_tipo ('insert','tipo_ajuste_formulacion','PRE','tajuste'); --#39
select param.f_import_tcatalogo ('insert','PRE','Formulación','FORM','tipo_ajuste_formulacion');--#39
select param.f_import_tcatalogo ('insert','PRE','Reformulación','REF','tipo_ajuste_formulacion');--#39
select param.f_import_tcatalogo ('insert','PRE','Traspaso','TRA','tipo_ajuste_formulacion');--#39
select param.f_import_tcatalogo ('insert','PRE','Ajuste','AJU','tipo_ajuste_formulacion');--#39
/*******************************************F-DAT-JJA-PRE-1-09/07/2020***********************************************/

/*******************************************I-DAT-JJA-PRE-11-17/07/2020***********************************************/
select pxp.f_insert_tgui ('Tipo centro de costo', 'Tipo centro de costo', 'TIPCENCOS', 'si', 17, 'sis_presupuestos/reportes/formulario/Tipo_centro_costo.php', 3, '', 'Tipo_centro_costo', 'PRE'); --#42
/*******************************************F-DAT-JJA-PRE-1-17/07/2020***********************************************/

/*******************************************I-DAT-JJA-PRE-11-06/08/2020***********************************************/
select pxp.f_insert_tgui ('Partida', 'Partida', 'PART', 'si', 18, 'sis_presupuestos/reportes/formulario/Partida.php', 3, '', 'Partida', 'PRE'); --#46
/*******************************************F-DAT-JJA-PRE-1-06/08/2020***********************************************/
