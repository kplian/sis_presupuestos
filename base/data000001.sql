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

/***********************************F-DAT-JRR-PRE-0-24/04/2014*****************************************/