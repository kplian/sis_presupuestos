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




/***********************************I-DAT-RAC-PRE-0-26/02/2016*****************************************/

select pxp.f_insert_tgui ('Tipo de Presupuesto', 'Tipos de presupuesto', 'TIPR', 'si', 5, 'sis_presupuestos/vista/tipo_presupuesto/TipoPresupuesto.php', 3, '', 'TipoPresupuesto', 'PRE');
select pxp.f_insert_testructura_gui ('TIPR', 'PRE.1');

/***********************************F-DAT-RAC-PRE-0-26/02/2016*****************************************/




/***********************************I-DAT-RAC-PRE-0-02/03/2016*****************************************/

/* Data for the 'pxp.variable_global' table  (Records 1 - 1) */

INSERT INTO pxp.variable_global ("variable", "valor", "descripcion") VALUES (E'pre_wf_codigo', E'PRE', E'codigo de proceso work flow para la formualcion de presupuesto');


/***********************************F-DAT-RAC-PRE-0-02/03/2016*****************************************/




