/***********************************I-SCP-GSS-PRE-31-23/11/2012****************************************/

/**	Author: Gonzalo Sarmiento Sejas
*	Date: 11/2012
*	Description: Build the menu definition and composition
*/
 
/* (1) Tables creation */

--Presupuestos

CREATE TABLE pre.tpresupuesto (
  id_presupuesto  SERIAL NOT NULL,
  codigo varchar(20),
  descripcion varchar(200),
  gestion integer,
  estado varchar(15),
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



CREATE TABLE pre.tconcepto_ingas(
  id_concepto_ingas SERIAL NOT NULL, 
  desc_ingas varchar(150), 
  tipo varchar(255), 
  sw_tesoro int4, 
  id_oec int4, 
  id_item int4, 
  id_servicio int4, 
  CONSTRAINT pk_tconcepto_ingas__id_concepto_ingas PRIMARY  KEY(id_concepto_ingas)
)INHERITS (pxp.tbase);



DROP TABLE pre.tpartida;  --elimina tabla creada para mantenimiento


CREATE TABLE pre.tpartida(
  id_partida SERIAL NOT NULL, 
  id_partida_fk int4 NOT NULL, 
  id_gestion int4,
  id_parametros int4, 
  codigo varchar(30), 
  nombre_partida varchar(150), 
  descripcion varchar(1000), 
  nivel_partida int4, 
  sw_trasacional varchar(2), 
  tipo varchar(20), --endesis tipo_partida
  sw_movimiento varchar(10), 
  cod_trans varchar(40), 
  cod_ascii varchar(2),
  cod_excel varchar(2), 
  ent_trf varchar(4),
  CONSTRAINT pk_tpartida__id_partida PRIMARY KEY(id_partida)
) INHERITS (pxp.tbase);

CREATE TABLE pre.tconcepto_cta(
  id_concepto_cta SERIAL NOT NULL, 
  id_centro_costo int4 NOT NULL, 
  id_concepto_ingas int4 NOT NULL, 
  id_partida int4, 
  id_cuenta int4, 
  id_auxiliar int4, 
  CONSTRAINT pk_tconcepto_cta__id_concepto_cta PRIMARY KEY(id_concepto_cta)
) INHERITS (pxp.tbase);

/***********************************F-SCP-RAC-PRE-0-07/01/2013*****************************************/


