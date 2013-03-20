/* Data for the 'pre.tpartida' table  (Records 1 - 4) */

INSERT INTO pre.tpartida ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_partida_fk", "id_gestion", "id_parametros", "codigo", "nombre_partida", "descripcion", "nivel_partida", "sw_transaccional", "tipo", "sw_movimiento", "cod_trans", "cod_ascii", "cod_excel", "ent_trf")
VALUES (1, NULL, E'2013-03-20 13:48:01.781', NULL, E'activo', NULL, 1, NULL, E'PARGAS', E'Partidas de Gasto', E'', NULL, E'titular', E'gasto', E'presupuestario', NULL, NULL, NULL, NULL);

INSERT INTO pre.tpartida ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_partida_fk", "id_gestion", "id_parametros", "codigo", "nombre_partida", "descripcion", "nivel_partida", "sw_transaccional", "tipo", "sw_movimiento", "cod_trans", "cod_ascii", "cod_excel", "ent_trf")
VALUES (1, NULL, E'2013-03-20 13:48:21.696', NULL, E'activo', 1, 1, NULL, E'43120', E'Equipos de computacion', E'', NULL, E'movimiento', E'gasto', E'presupuestario', NULL, NULL, NULL, NULL);

INSERT INTO pre.tpartida ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_partida_fk", "id_gestion", "id_parametros", "codigo", "nombre_partida", "descripcion", "nivel_partida", "sw_transaccional", "tipo", "sw_movimiento", "cod_trans", "cod_ascii", "cod_excel", "ent_trf")
VALUES (1, NULL, E'2013-03-20 13:48:59.562', NULL, E'activo', 1, 1, NULL, E'123', E'Muesbles y Enseres', E'', NULL, E'movimiento', E'gasto', E'presupuestario', NULL, NULL, NULL, NULL);

INSERT INTO pre.tpartida ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_partida_fk", "id_gestion", "id_parametros", "codigo", "nombre_partida", "descripcion", "nivel_partida", "sw_transaccional", "tipo", "sw_movimiento", "cod_trans", "cod_ascii", "cod_excel", "ent_trf")
VALUES (1, NULL, E'2013-03-20 13:49:17.137', NULL, E'activo', 1, 1, NULL, E'4321', E'Servicios', E'', NULL, E'movimiento', E'gasto', E'presupuestario', NULL, NULL, NULL, NULL);



------------------------------------
-- CONCEPTO CUENTA
---------------------------------

/* Data for the 'pre.tconcepto_cta' table  (Records 1 - 7) */

INSERT INTO pre.tconcepto_cta ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_centro_costo", "id_concepto_ingas", "id_cuenta", "id_auxiliar", "id_partida")
VALUES (1, NULL, E'2013-03-20 14:10:29.106', NULL, E'activo', NULL, 1, 18, 1, 2);

INSERT INTO pre.tconcepto_cta ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_centro_costo", "id_concepto_ingas", "id_cuenta", "id_auxiliar", "id_partida")
VALUES (1, NULL, E'2013-03-20 14:10:45.495', NULL, E'activo', NULL, 2, 18, 1, 2);

INSERT INTO pre.tconcepto_cta ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_centro_costo", "id_concepto_ingas", "id_cuenta", "id_auxiliar", "id_partida")
VALUES (1, NULL, E'2013-03-20 14:11:01.559', NULL, E'activo', NULL, 3, 18, 1, 3);

INSERT INTO pre.tconcepto_cta ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_centro_costo", "id_concepto_ingas", "id_cuenta", "id_auxiliar", "id_partida")
VALUES (1, NULL, E'2013-03-20 14:11:21.579', NULL, E'activo', NULL, 4, 18, 1, 3);

INSERT INTO pre.tconcepto_cta ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_centro_costo", "id_concepto_ingas", "id_cuenta", "id_auxiliar", "id_partida")
VALUES (1, NULL, E'2013-03-20 14:11:35.968', NULL, E'activo', NULL, 5, 18, 2, 4);

INSERT INTO pre.tconcepto_cta ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_centro_costo", "id_concepto_ingas", "id_cuenta", "id_auxiliar", "id_partida")
VALUES (1, NULL, E'2013-03-20 14:11:51.915', NULL, E'activo', NULL, 6, 18, 2, 4);

INSERT INTO pre.tconcepto_cta ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_centro_costo", "id_concepto_ingas", "id_cuenta", "id_auxiliar", "id_partida")
VALUES (1, NULL, E'2013-03-20 14:12:02.102', NULL, E'activo', NULL, 7, 18, 2, 4);