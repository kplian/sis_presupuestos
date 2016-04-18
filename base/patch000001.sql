/***********************************I-SCP-GSS-PRE-31-23/11/2012****************************************/

/**	Author: Gonzalo Sarmiento Sejas
*	Date: 11/2012
*	Description: Build the menu definition and composition
*/
 
/* (1) Tables creation */

--Presupuestos

CREATE TABLE pre.tpresupuesto (
  id_presupuesto  SERIAL NOT NULL,
  id_centro_costo INTEGER NOT NULL,
  tipo_pres VARCHAR(30), 
  estado_pres VARCHAR(30), 
  id_categoria_prog INTEGER, 
  id_parametro INTEGER, 
  id_fuente_financiamiento INTEGER, 
  id_concepto_colectivo INTEGER, 
  cod_fin VARCHAR(10), 
  cod_prg VARCHAR(10), 
  cod_pry VARCHAR(10), 
  cod_act VARCHAR(10), 
  CONSTRAINT pk_tpresupuesto__id_presupuesto PRIMARY KEY (id_presupuesto)
) INHERITS (pxp.tbase)
WITH (
  OIDS=TRUE
);
ALTER TABLE pre.tpresupuesto OWNER TO postgres;


CREATE TABLE pre.tpartida (
  id_partida SERIAL, 
  id_partida_fk integer, 
  codigo VARCHAR(20), 
  descripcion VARCHAR(200), 
  tipo varchar(15),
  CONSTRAINT tpartida__id_partida PRIMARY KEY(id_partida),
  CONSTRAINT chk_tpartida__tipo check (tipo in ('trans','no_trans'))
) INHERITS (pxp.tbase)
WITH OIDS;
ALTER TABLE pre.tpartida OWNER TO postgres;


CREATE TABLE pre.tpresup_partida (
  id_presup_partida  SERIAL NOT NULL,
  id_presupuesto integer,
  id_partida integer,
  id_centro_costo integer,
  id_moneda integer,
  fecha_hora timestamp,
  importe numeric(18,2),
  tipo varchar(15),
  CONSTRAINT tpresup_partida__id_presup_partida PRIMARY KEY (id_presup_partida),
  CONSTRAINT chk_tpresup_partida__tipo check (tipo in ('presupuestado','ejecutado'))
) INHERITS (pxp.tbase)
WITH (
  OIDS=TRUE
);
ALTER TABLE pre.tpresup_partida OWNER TO postgres;

/***********************************F-SCP-GSS-PRE-31-23/11/2012*****************************************/



/***********************************I-SCP-RAC-PRE-0-07/01/2013*****************************************/

DROP TABLE pre.tpartida;  --elimina tabla creada para mantenimiento

CREATE TABLE pre.tpartida (
  id_partida SERIAL, 
  id_partida_fk INTEGER, 
  id_gestion INTEGER, 
  id_parametros INTEGER, 
  codigo VARCHAR(30), 
  nombre_partida VARCHAR(150), 
  descripcion VARCHAR(1000), 
  nivel_partida INTEGER, 
  sw_transaccional VARCHAR(20), 
  tipo VARCHAR(20), 
  sw_movimiento VARCHAR(20), 
  cod_trans VARCHAR(40), 
  cod_ascii VARCHAR(2), 
  cod_excel VARCHAR(2), 
  ent_trf VARCHAR(4), 
  CONSTRAINT pk_tpartida__id_partida PRIMARY KEY(id_partida)
) INHERITS (pxp.tbase)
WITHOUT OIDS;

COMMENT ON COLUMN pre.tpartida.sw_transaccional
IS 'movimiento, titular';

COMMENT ON COLUMN pre.tpartida.tipo
IS 'recurso o gasto';

COMMENT ON COLUMN pre.tpartida.sw_movimiento
IS 'flujo, presupuestaria';

CREATE TABLE pre.tconcepto_cta(
  id_concepto_cta SERIAL NOT NULL, 
  id_centro_costo int4, 
  id_concepto_ingas int4 NOT NULL, 
  id_cuenta int4, 
  id_auxiliar int4,
  id_partida int4, 
  CONSTRAINT pk_tconcepto_cta__id_concepto_cta PRIMARY KEY(id_concepto_cta)
) INHERITS (pxp.tbase);


CREATE TABLE pre.tconcepto_partida(
    id_concepto_partida SERIAL NOT NULL,
    id_concepto_ingas int4 NOT NULL,
    id_partida int4 NOT NULL,
    PRIMARY KEY (id_concepto_partida))
    INHERITS (pxp.tbase);


/***********************************F-SCP-RAC-PRE-0-07/01/2013*****************************************/


/***********************************I-SCP-RCM-PRE-0-18/12/2013*****************************************/
CREATE TABLE pre.tpartida_ids (
  id_partida_uno INTEGER NOT NULL, 
  id_partida_dos INTEGER NOT NULL, 
  sw_cambio_gestion VARCHAR(10) DEFAULT 'gestion'::character varying, 
  CONSTRAINT tpartida_ids_pkey PRIMARY KEY(id_partida_uno)
) WITHOUT OIDS;
/***********************************F-SCP-RCM-PRE-0-18/12/2013*****************************************/

/***********************************I-SCP-JRR-PRE-0-29/05/2014*****************************************/
CREATE TABLE pre.tpresupuesto_ids (
  id_presupuesto_uno INTEGER NOT NULL, 
  id_presupuesto_dos INTEGER NOT NULL, 
  sw_cambio_gestion VARCHAR(10) DEFAULT 'gestion'::character varying NOT NULL, 
  CONSTRAINT tpresupuesto_ids_pkey PRIMARY KEY(id_presupuesto_uno)  
) WITH OIDS;

/***********************************F-SCP-JRR-PRE-0-29/05/2014*****************************************/



/***********************************I-SCP-RAC-PRE-0-09/10/2014*****************************************/

--------------- SQL ---------------

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
         (((((('('::text || uo.codigo::text) || ')-('::text) || ep.ep) || ')-('
           ::text) || ges.gestion) || ') id:'::text) || cec.id_centro_costo::
           text AS codigo_cc,
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
       JOIN pre.tpresupuesto pre on pre.id_centro_costo = cec.id_centro_costo;
       
/***********************************F-SCP-RAC-PRE-0-09/10/2014*****************************************/


/***********************************I-SCP-JRR-PRE-0-02/01/2015*****************************************/
CREATE TABLE pre.tcategoria_programatica (
  id_categoria_programatica INTEGER NOT NULL, 
  id_gestion INTEGER NOT NULL, 
  descripcion TEXT NOT NULL, 
  CONSTRAINT tcategoria_programatica_pkey PRIMARY KEY(id_categoria_programatica)) 
INHERITS (pxp.tbase); 


/***********************************F-SCP-JRR-PRE-0-02/01/2015*****************************************/

/***********************************I-SCP-RAC-PRE-0-16/01/2015*****************************************/

--------------- SQL ---------------

COMMENT ON COLUMN pre.tpresupuesto.tipo_pres
IS '1 presupuesto de recursos,
2 presupuesto de gasto,
3 presupuesto de inversion,
4 presupuesto de recursos no oficial,
5 presupuesto de gastos no oficial
6 presupuesto de inversio no oficial';

/***********************************F-SCP-RAC-PRE-0-16/01/2015*****************************************/


/***********************************I-SCP-RAC-PRE-0-01/12/2015*****************************************/


--------------- SQL ---------------

CREATE TABLE pre.tpartida_ejecucion (
  id_partida_ejecucion SERIAL,
  nro_tramite VARCHAR,
  monto NUMERIC,
  monto_mb NUMERIC,
  id_moneda INTEGER,
  id_presupuesto INTEGER,
  id_partida INTEGER,
  tipo_movimiento VARCHAR(30) NOT NULL,
  tipo_cambio NUMERIC,
  PRIMARY KEY(id_partida_ejecucion)
) INHERITS (pxp.tbase)
;

COMMENT ON COLUMN pre.tpartida_ejecucion.tipo_movimiento
IS 'formulado, comprometido, devengado, pagao, traspaso, modificacion (los revertidos son numeros negativos)';


--------------- SQL ---------------

ALTER TABLE pre.tpartida_ejecucion
  ADD COLUMN fecha DATE DEFAULT now() NOT NULL;

COMMENT ON COLUMN pre.tpartida_ejecucion.fecha
IS 'fecha de ejecucion , no necesariamente igual a la fecha de registro';


--------------- SQL ---------------

ALTER TABLE pre.tpartida_ejecucion
  ADD COLUMN id_int_comprobante INTEGER;

COMMENT ON COLUMN pre.tpartida_ejecucion.id_int_comprobante
IS 'identifica el cbte si existe';
/***********************************F-SCP-RAC-PRE-0-01/12/2015*****************************************/



/***********************************I-SCP-RAC-PRE-0-26/02/2016*****************************************/



CREATE TABLE pre.tclase_gasto (
  id_clase_gasto SERIAL,
  codigo VARCHAR(5),
  nombre VARCHAR(200),
  CONSTRAINT tclase_gasto_pkey PRIMARY KEY(id_clase_gasto)
) INHERITS (pxp.tbase)

WITH (oids = false);



CREATE TABLE pre.tclase_gasto_partida (
  id_clase_gasto_partida SERIAL,
  id_clase_gasto INTEGER,
  id_partida INTEGER,
  CONSTRAINT tclase_gasto_partida_pkey PRIMARY KEY(id_clase_gasto_partida)
) INHERITS (pxp.tbase)

WITH (oids = false);


/***********************************F-SCP-RAC-PRE-0-26/02/2016*****************************************/


/***********************************I-SCP-RAC-PRE-1-26/02/2016*****************************************/

--------------- SQL ---------------

CREATE TABLE pre.tpresupuesto_funcionario (
  id_presupuesto_funcionario SERIAL,
  id_presupuesto INTEGER NOT NULL,
  id_funcionario INTEGER,
  accion VARCHAR(50) DEFAULT 'responsable'::character varying NOT NULL,
  CONSTRAINT tpresupuesto_funcionario_pkey PRIMARY KEY(id_presupuesto_funcionario)
) INHERITS (pxp.tbase)

WITH (oids = false);

ALTER TABLE pre.tpresupuesto_funcionario
  ALTER COLUMN id_funcionario SET STATISTICS 0;

COMMENT ON COLUMN pre.tpresupuesto_funcionario.accion
IS 'responsable, aprobacion, formulacion';

--------------- SQL ---------------

CREATE TABLE pre.ttipo_presupuesto (
  id_tipo_presupuesto SERIAL NOT NULL,
  codigo VARCHAR(30),
  nombre VARCHAR,
  descripcion VARCHAR,
  movimiento VARCHAR(15) DEFAULT 'gasto' NOT NULL,
  PRIMARY KEY(id_tipo_presupuesto)
) INHERITS (pxp.tbase)

WITH (oids = false);

COMMENT ON COLUMN pre.ttipo_presupuesto.movimiento
IS 'gasto o recurso';


--------------- SQL ---------------

ALTER TABLE pre.tpresupuesto
  ADD COLUMN estado VARCHAR DEFAULT 'borrador' NOT NULL;
  
--------------- SQL ---------------

ALTER TABLE pre.tpresupuesto
  ADD COLUMN nro_tramite VARCHAR;
  
--------------- SQL ---------------

ALTER TABLE pre.tpresupuesto
  ADD COLUMN id_proceso_wf INTEGER;  
  

--------------- SQL ---------------

ALTER TABLE pre.tpresupuesto
  ADD COLUMN descripcion VARCHAR;
  
/***********************************F-SCP-RAC-PRE-1-26/02/2016*****************************************/


/***********************************I-SCP-RAC-PRE-0-07/03/2016*****************************************/

CREATE TABLE pre.tmemoria_calculo (
  id_memoria_calculo SERIAL,
  id_concepto_ingas INTEGER NOT NULL,
  obs VARCHAR NOT NULL,
  importe_total NUMERIC(18,2) DEFAULT 0.00 NOT NULL,
  id_presupuesto INTEGER NOT NULL,
  CONSTRAINT tmemoria_calculo_pkey PRIMARY KEY(id_memoria_calculo)
) INHERITS (pxp.tbase)

WITH (oids = false);

COMMENT ON COLUMN pre.tmemoria_calculo.obs
IS 'justificación del concepto';

COMMENT ON COLUMN pre.tmemoria_calculo.importe_total
IS 'importe totalen moneda base';

--------------- SQL ---------------

CREATE TABLE pre.tmemoria_det (
  id_memoria_det SERIAL NOT NULL,
  importe NUMERIC(18,2) DEFAULT 0 NOT NULL,
  id_periodo INTEGER NOT NULL,
  id_memoria_calculo INTEGER NOT NULL,
  PRIMARY KEY(id_memoria_det)
) INHERITS (pxp.tbase)

WITH (oids = false);

COMMENT ON COLUMN pre.tmemoria_det.importe
IS 'importe para el periodo en moneda base';

COMMENT ON COLUMN pre.tmemoria_det.id_periodo
IS 'periodo de la gestión al que corresponde el importe';


/***********************************F-SCP-RAC-PRE-0-07/03/2016*****************************************/


/***********************************I-SCP-RAC-PRE-0-11/03/2016*****************************************/


ALTER TABLE pre.tpresup_partida
  ADD COLUMN importe_aprobado NUMERIC(18,2) DEFAULT 0.0 NOT NULL;

COMMENT ON COLUMN pre.tpresup_partida.importe_aprobado
IS 'este es el importe final que se traduce a partida ejecucion como formulado, segun WF en el estado vobopre, se determina el monto';

update pre.tpresup_partida pp set
 importe = 0.00 
 where importe is null;
 
--------------- SQL ---------------

ALTER TABLE pre.tpresup_partida
  ALTER COLUMN importe SET DEFAULT 0.00;

ALTER TABLE pre.tpresup_partida
  ALTER COLUMN importe SET NOT NULL;

/***********************************F-SCP-RAC-PRE-0-11/03/2016*****************************************/



/***********************************I-SCP-RAC-PRE-0-16/03/2016*****************************************/

--------------- SQL ---------------

ALTER TABLE pre.tpresupuesto
  ADD COLUMN id_estado_wf INTEGER; 
  
   
  
/***********************************F-SCP-RAC-PRE-0-16/03/2016*****************************************/




/***********************************I-SCP-RAC-PRE-0-23/03/2016*****************************************/

------------ SQL ---------------

COMMENT ON COLUMN pre.tpartida_ejecucion.tipo_movimiento
IS 'formulado, comprometido, ejecutado, pagado (los revertidos son numeros negativos)';

/***********************************F-SCP-RAC-PRE-0-23/03/2016*****************************************/



/***********************************I-SCP-RAC-PRE-0-31/03/2016*****************************************/
--------------- SQL ---------------

ALTER TABLE pre.tpartida_ejecucion
  ADD COLUMN columna_origen VARCHAR;

COMMENT ON COLUMN pre.tpartida_ejecucion.columna_origen
IS 'columna origen donde se hizo la llamada para la ejecucion';


--------------- SQL ---------------

ALTER TABLE pre.tpartida_ejecucion
  ADD COLUMN valor_id_origen INTEGER;

/***********************************F-SCP-RAC-PRE-0-31/03/2016*****************************************/



/*****************************I-SCP-RAC-PRE-0-04/04/2016*************/

--------------- SQL ---------------

ALTER TABLE pre.tpartida_ejecucion
  ADD COLUMN id_partida_ejecucion_fk INTEGER;

COMMENT ON COLUMN pre.tpartida_ejecucion.id_partida_ejecucion_fk
IS 'id partida ejecuon referencial';

/*****************************F-SCP-RAC-PRE-0-04/04/2016*************/



/*****************************I-SCP-RAC-PRE-0-13/04/2016*************/

--------------- SQL ---------------

CREATE TABLE pre.tajuste (
  id_ajuste SERIAL,
  nro_tramite VARCHAR(300),
  justificacion VARCHAR,
  estado VARCHAR(50),
  id_proceso_wf INTEGER,
  id_estado_wf INTEGER,
  tipo_ajuste VARCHAR(50) DEFAULT 'traspaso' NOT NULL,
  PRIMARY KEY(id_ajuste)
) INHERITS (pxp.tbase)

WITH (oids = false);

COMMENT ON COLUMN pre.tajuste.tipo_ajuste
IS '(traspaso) - de una partida a la misma de otro presupuesto pero del mismo tipo
(reformulación) - te permite llevar de una partida a otra diferente, incluso inversión a gasto
(incremento) - solo aumenta en una partida
(disminución) -  solo disminuye';


  
--------------- SQL ---------------

CREATE TABLE pre.tajuste_det (
  id_ajuste_det SERIAL,
  id_presupuesto INTEGER,
  id_partida INTEGER,
  id_partida_ejecucion INTEGER,
  importe NUMERIC(20,2) DEFAULT 0 NOT NULL,
  PRIMARY KEY(id_ajuste_det)
) INHERITS (pxp.tbase)

WITH (oids = false);

ALTER TABLE pre.tajuste_det
  OWNER TO postgres;

COMMENT ON COLUMN pre.tajuste_det.importe
IS 'los ajuste siempre se realizan en siempre en moneda base';


--------------- SQL ---------------

ALTER TABLE pre.tajuste_det
  ADD COLUMN tipo_ajuste VARCHAR(30) DEFAULT 'incremento' NOT NULL;

COMMENT ON COLUMN pre.tajuste_det.tipo_ajuste
IS 'incremento o decremento';

--------------- SQL ---------------

ALTER TABLE pre.tajuste
  ADD COLUMN fecha DATE DEFAULT now() NOT NULL;
  
--------------- SQL ---------------

ALTER TABLE pre.tajuste
  ADD COLUMN "id_gestion" INTEGER;

/*****************************F-SCP-RAC-PRE-0-13/04/2016*************/




/*****************************I-SCP-RAC-PRE-0-14/04/2016*************/

--------------- SQL ---------------

ALTER TABLE pre.tajuste
  ADD COLUMN importe_ajuste NUMERIC(18,2) DEFAULT 0 NOT NULL;


--------------- SQL ---------------

ALTER TABLE pre.tajuste
  ADD COLUMN movimiento VARCHAR(30) DEFAULT 'gasto' NOT NULL;

COMMENT ON COLUMN pre.tajuste.movimiento
IS 'recuros o gasto, este campo es para evitar que mexclen lso tipo de presupuesto';

--------------- SQL ---------------

ALTER TABLE pre.tajuste_det
  ADD COLUMN id_ajuste INTEGER NOT NULL;

/*****************************F-SCP-RAC-PRE-0-14/04/2016*************/


/*****************************I-SCP-RAC-PRE-0-15/04/2016*************/

ALTER TABLE pre.ttipo_presupuesto
  ADD COLUMN sw_oficial VARCHAR(4) DEFAULT 'si' NOT NULL;

COMMENT ON COLUMN pre.ttipo_presupuesto.sw_oficial
IS 'si es oficial o no';


--------------- SQL ---------------

ALTER TABLE pre.tpresupuesto
  ADD COLUMN sw_consolidado VARCHAR(3) DEFAULT 'no' NOT NULL;

COMMENT ON COLUMN pre.tpresupuesto.sw_consolidado
IS 'si el presupeusto es consolidado se base en presupuestos parte, si el presupuesto no es consolidado  se base en su propia memoria de calculo solamente';


--------------- SQL ---------------

CREATE TABLE pre.trel_pre (
  id_rel_pre SERIAL,
  id_presupuesto_padre INTEGER,
  id_presupuesto_hijo INTEGER,
  estado VARCHAR(30) DEFAULT 'borrador' NOT NULL,
  fecha_union DATE,
  PRIMARY KEY(id_rel_pre)
) INHERITS (pxp.tbase)

WITH (oids = false);

COMMENT ON COLUMN pre.trel_pre.estado
IS 'borrador o procesado';

/*****************************F-SCP-RAC-PRE-0-15/04/2016*************/





/*****************************I-SCP-RAC-PRE-0-18/04/2016*************/


--------------- SQL ---------------

ALTER TABLE pre.tmemoria_calculo
  ADD COLUMN id_memoria_calculo_original INTEGER;

COMMENT ON COLUMN pre.tmemoria_calculo.id_memoria_calculo_original
IS 'hace referencia a la memoria calculo del presupuesto no oficial consolidado';


--------------- SQL ---------------

ALTER TABLE pre.tmemoria_calculo
  ADD COLUMN id_rel_pre INTEGER;

COMMENT ON COLUMN pre.tmemoria_calculo.id_rel_pre
IS 'hace referencia al la relacion de consolidado desde la que se origino la memoria consolidada, si es distinto de null sabemos que esta memoria es consolidada';

/*****************************F-SCP-RAC-PRE-0-18/04/2016*************/



