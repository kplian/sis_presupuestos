CREATE OR REPLACE FUNCTION pre.ft_objetivo_partida_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Presupuesto
 FUNCION: 		pre.ft_objetivo_partida_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'pre.tobjetivo_partida'
 AUTOR: 		 (franklin.espinoza)
 FECHA:	        24-07-2017 13:34:28
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:
 AUTOR:
 FECHA:
***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
    v_record				record;

	v_mensaje_error         text;
	v_id_objetivo_partida	integer;
    v_index					integer;
    v_arr_ids_hijos			integer[];
	v_ids_hijos_count		integer;
    v_codigo_obj			varchar;
    v_index2				integer;

    v_arr_ids_partida		integer[];
    v_count_existe			integer;

    v_obj_part_existe		INTEGER[];
    v_cont_obj_part_existe		integer=1;
    v_partida_existe		INTEGER[];

    v_cadena_duplicados			varchar;
    v_tam_cadena				integer;
BEGIN

    v_nombre_funcion = 'pre.ft_objetivo_partida_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'PRE_OBJ_PART_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		24-07-2017 13:34:28
	***********************************/

	if(p_transaccion='PRE_OBJ_PART_INS')then

        begin
        	--RAISE EXCEPTION 'v_count_existe: %',v_parametros.id_partida;
        	SELECT tob.codigo
            INTO v_codigo_obj
            FROM pre.tobjetivo tob
            WHERE tob.id_objetivo = v_parametros.id_objetivo;

            --array de partidas
            v_arr_ids_partida = string_to_array(v_parametros.id_partida,',');

            --si tiene hijos el nodo padre
        	IF(pre.f_get_arbol(v_parametros.id_objetivo, 'CONT_HIJOS')::INTEGER >= 1)THEN
            	v_arr_ids_hijos = string_to_array(trim (both ',' from pre.f_get_arbol(v_parametros.id_objetivo, 'IDS_HIJOS')), ',');
        		v_ids_hijos_count = array_length(v_arr_ids_hijos,1);
                FOR v_index IN 1..v_ids_hijos_count LOOP

                      FOR v_index2 IN 1..array_length(v_arr_ids_partida,1) LOOP
                      	SELECT count(top.id_partida)
            		  	INTO v_count_existe
            		  	FROM pre.tobjetivo_partida top
            		  	WHERE top.id_partida = v_arr_ids_partida[v_index2] AND top.id_objetivo = v_arr_ids_hijos[v_index];


                        IF(v_count_existe>=1)THEN
                        	RAISE NOTICE 'El objetivo ya cuenta con esta partida';
                            v_obj_part_existe[v_cont_obj_part_existe] = v_arr_ids_hijos[v_index];
                            IF(v_arr_ids_partida[v_index2] = any(v_partida_existe))THEN
                            	RAISE NOTICE 'PARTIDA YA EXISTE EN EL ARRAY';
                            ELSE
                            	v_partida_existe[v_cont_obj_part_existe] = v_arr_ids_partida[v_index2];
                            END IF;

                            v_cont_obj_part_existe = v_cont_obj_part_existe + 1;
                        ELSE
                        --insertamos partidas en los hijos
                         INSERT INTO pre.tobjetivo_partida(
                          id_objetivo,
                          estado_reg,
                          id_partida,
                          id_usuario_reg,
                          usuario_ai,
                          fecha_reg,
                          id_usuario_ai,
                          fecha_mod,
                          id_usuario_mod,
                          estado
                          ) VALUES(
                          v_arr_ids_hijos[v_index],
                          'activo',
                          v_arr_ids_partida[v_index2],
                          p_id_usuario,
                          v_parametros._nombre_usuario_ai,
                          now(),
                          v_parametros._id_usuario_ai,
                          null,
                          null,
                          v_codigo_obj||' --> [HEREDADO]');
                        END IF;
                      END LOOP;
                END LOOP;
            END IF;


              --Sentencia de la insercion en el padre
              FOR v_index2 IN 1..array_length(v_arr_ids_partida,1) LOOP

              	SELECT count(top.id_partida)
            	INTO v_count_existe
            	FROM pre.tobjetivo_partida top
            	WHERE top.id_partida = v_arr_ids_partida[v_index2] AND top.id_objetivo = v_parametros.id_objetivo;

              	IF(v_count_existe>=1)THEN
            		RAISE NOTICE 'El objetivo ya cuenta con esta partida';
                    v_obj_part_existe[v_cont_obj_part_existe] = v_parametros.id_objetivo;
                    IF(v_arr_ids_partida[v_index2] = any(v_partida_existe))THEN
                            	RAISE NOTICE 'PARTIDA YA EXISTE EN EL ARRAY';
                    ELSE
                    	v_partida_existe[v_cont_obj_part_existe] = v_arr_ids_partida[v_index2];
                	END IF;
                    v_cont_obj_part_existe = v_cont_obj_part_existe + 1;
            	ELSE
                  insert into pre.tobjetivo_partida(
                  id_objetivo,
                  estado_reg,
                  id_partida,
                  id_usuario_reg,
                  usuario_ai,
                  fecha_reg,
                  id_usuario_ai,
                  fecha_mod,
                  id_usuario_mod,
                  estado
                  ) values(
                  v_parametros.id_objetivo,
                  'activo',
                  v_arr_ids_partida[v_index2],
                  p_id_usuario,
                  v_parametros._nombre_usuario_ai,
                  now(),
                  v_parametros._id_usuario_ai,
                  null,
                  null,
                  'PROPIO'
                  )RETURNING id_objetivo_partida into v_id_objetivo_partida;

                  --Definicion de la respuesta
                  v_resp = pxp.f_agrega_clave(v_resp,'mensaje','ObjetivoPartida almacenado(a) con exito (id_objetivo_partida'||v_id_objetivo_partida||')');
                  v_resp = pxp.f_agrega_clave(v_resp,'id_objetivo_partida',v_id_objetivo_partida::varchar);
                END IF;
              END LOOP;

            v_tam_cadena = COALESCE(array_length(v_obj_part_existe,1),0);
            IF(v_tam_cadena>=1)THEN
              v_cadena_duplicados = 'Estimado usuario, darle a conocer que la partida ';

              FOR v_index IN 1..array_length(v_partida_existe,1) LOOP
                SELECT tp.codigo, tp.nombre_partida
                INTO v_record
                FROM pre.tpartida tp
                WHERE tp.id_partida = v_partida_existe[v_index];
                  v_cadena_duplicados = v_cadena_duplicados ||'<b style="color:green;">('||v_record.codigo ||')-'||v_record.nombre_partida||'</b> ; ';
              END LOOP;

              v_cadena_duplicados = v_cadena_duplicados ||'<br> ya se tiene registrado en los siguientes objetivos:<br><br>';
              FOR v_index IN 1..array_length(v_obj_part_existe,1) LOOP

                SELECT tob.codigo, tob.nivel_objetivo, tob.descripcion
                  INTO v_record
                  FROM pre.tobjetivo tob
                  WHERE tob.id_objetivo = v_obj_part_existe[v_index];

                  v_cadena_duplicados = v_cadena_duplicados||'<b>'||v_index||'.</b>  <b style="color:green;">('||v_record.codigo||' -> Nivel: '||v_record.nivel_objetivo||')</b>-'||v_record.descripcion||'.<br>';

              END LOOP;
              v_cadena_duplicados = v_cadena_duplicados||'<br> Verifique y defina de acuerdo a sus necesidades.';
              v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Partidas guardadas con Exito.'::varchar);
              v_resp = pxp.f_agrega_clave(v_resp,'v_mensaje',v_cadena_duplicados::varchar);
            END IF;
            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'PRE_OBJ_PART_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		24-07-2017 13:34:28
	***********************************/

	elsif(p_transaccion='PRE_OBJ_PART_MOD')then

		begin
			--Sentencia de la modificacion
			update pre.tobjetivo_partida set
			id_objetivo = v_parametros.id_objetivo,
			id_partida = v_parametros.id_partida,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario,
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_objetivo_partida=v_parametros.id_objetivo_partida;

			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','ObjetivoPartida modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_objetivo_partida',v_parametros.id_objetivo_partida::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'PRE_OBJ_PART_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		24-07-2017 13:34:28
	***********************************/

	elsif(p_transaccion='PRE_OBJ_PART_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from pre.tobjetivo_partida
            where id_objetivo_partida=v_parametros.id_objetivo_partida;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','ObjetivoPartida eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_objetivo_partida',v_parametros.id_objetivo_partida::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	else

    	raise exception 'Transaccion inexistente: %',p_transaccion;

	end if;

EXCEPTION

	WHEN OTHERS THEN
		v_resp='';
		v_resp = pxp.f_agrega_clave(v_resp,'mensaje',SQLERRM);
		v_resp = pxp.f_agrega_clave(v_resp,'codigo_error',SQLSTATE);
		v_resp = pxp.f_agrega_clave(v_resp,'procedimientos',v_nombre_funcion);
		raise exception '%',v_resp;

END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;