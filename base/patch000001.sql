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

