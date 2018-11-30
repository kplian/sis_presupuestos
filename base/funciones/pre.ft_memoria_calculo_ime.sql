CREATE OR REPLACE FUNCTION pre.ft_memoria_calculo_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:       Sistema de Presupuesto
 FUNCION:       pre.ft_memoria_calculo_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'pre.tmemoria_calculo'
 AUTOR:          (admin)
 FECHA:         01-03-2016 14:22:24
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:
 AUTOR:
 FECHA:
***************************************************************************/

DECLARE

    v_nro_requerimiento     integer;
    v_parametros            record;
    v_id_requerimiento      integer;
    v_resp                  varchar;
    v_nombre_funcion        text;
    v_mensaje_error         text;
    v_id_memoria_calculo    integer;
    v_id_gestion            integer;
    v_registros             record;
    v_estado                varchar;
    v_codigo                varchar;    
    v_gestion               integer;
    v_id_partida            integer;
    v_id_conceto_ingas      integer;
    v_id_centro_costo       integer;
    v_total_memoria         numeric;    
    v_id                    integer;  
    v_id_presup_partida     integer;
    v_id_mes                integer;     
    v_id_mes_ene            integer;    
    v_id_mes_feb            integer;
    v_id_mes_mar            integer;    
    v_id_mes_abr            integer;
    v_id_mes_may            integer;    
    v_id_mes_jun            integer;
    v_id_mes_jul            integer;    
    v_id_mes_ago            integer;
    v_id_mes_sep            integer;    
    v_id_mes_oct            integer;
    v_id_mes_nov            integer;    
    v_id_mes_dic            integer;
    v_id_presupuesto        integer;  
    v_aux                   varchar;  
    v_consulta              integer; 
    v_valor                 varchar;
    v_id_presupuesto_funcionario integer; 
BEGIN

    v_nombre_funcion = 'pre.ft_memoria_calculo_ime';
    v_parametros = pxp.f_get_record(p_tabla);

    /*********************************
    #TRANSACCION:  'PRE_MCA_INS'
    #DESCRIPCION:   Insercion de registros
    #AUTOR:     admin
    #FECHA:     01-03-2016 14:22:24
    ***********************************/

    if(p_transaccion='PRE_MCA_INS')then

        begin

            select
              cc.id_gestion,
              pre.estado,
              ges.gestion
            into
              v_id_gestion,
              v_estado,
              v_gestion
            from pre.tpresupuesto pre
            inner join param.tcentro_costo cc on cc.id_centro_costo = pre.id_centro_costo
            inner join param.tgestion ges on ges.id_gestion = cc.id_gestion
            where pre.id_presupuesto = v_parametros.id_presupuesto;

            --raise exception 'v_gestion %', v_gestion;

            IF v_estado = 'aprobado' THEN
               raise exception 'No puede agregar conceptos a la memoria de calculo de un presupuesto aprobado';
            END IF;

            --recuperar gestion de lpresupeusto
            /*
            SELECT
                par.id_partida
            into
               v_id_partida
            FROM pre.tpresupuesto pre
               JOIN param.tcentro_costo cc ON cc.id_centro_costo = pre.id_centro_costo
               JOIN param.tconcepto_ingas cig ON cig.id_concepto_ingas =
                 mca.id_concepto_ingas
               JOIN pre.tconcepto_partida cp ON cp.id_concepto_ingas =
                 mca.id_concepto_ingas
               JOIN param.tgestion ges ON ges.id_gestion = cc.id_gestion
               JOIN pre.tpartida par ON par.id_partida = cp.id_partida AND
                 par.id_gestion = cc.id_gestion
           where pre.id_presupuesto = v_parametros.id_presupuesto
                 and cig.id_concepto_ingas  = v_parametros.id_concepto_ingas;
            */
           --recupera partida a partir del presupuesto y concepto de gasto
           SELECT
                par.id_partida
           into
                v_id_partida
           FROM pre.tpresupuesto pre
               JOIN param.tcentro_costo cc ON cc.id_centro_costo = pre.id_centro_costo
               JOIN param.tgestion ges ON ges.id_gestion = cc.id_gestion
               JOIN pre.tpartida par ON par.id_gestion = cc.id_gestion
               JOIN pre.tconcepto_partida cp ON cp.id_partida = par.id_partida
              JOIN param.tconcepto_ingas cig ON cig.id_concepto_ingas = cp.id_concepto_ingas
           where pre.id_presupuesto = v_parametros.id_presupuesto and
                cig.id_concepto_ingas = v_parametros.id_concepto_ingas;

           IF NOT EXISTS (select 1 from pre.tpresup_partida
                    where id_partida=v_id_partida and id_presupuesto = v_parametros.id_presupuesto) THEN
                INSERT INTO pre.tpresup_partida
                (id_presupuesto, id_partida, id_centro_costo,id_usuario_reg)
                VALUES
                (v_parametros.id_presupuesto, v_id_partida, v_parametros.id_presupuesto,p_id_usuario);

           END IF;

            --Sentencia de la insercion
            insert into pre.tmemoria_calculo(
              id_concepto_ingas,
              importe_total,
              obs,
              id_presupuesto,
              estado_reg,
              id_usuario_ai,
              fecha_reg,
              usuario_ai,
              id_usuario_reg,
              fecha_mod,
              id_usuario_mod,
              id_partida
            ) values(
              v_parametros.id_concepto_ingas,
              0,
              replace(v_parametros.obs, '\n', ' '),
              v_parametros.id_presupuesto,
              'activo',
              v_parametros._id_usuario_ai,
              now(),
              v_parametros._nombre_usuario_ai,
              p_id_usuario,
              null,
              null,
              v_id_partida

            )RETURNING id_memoria_calculo into v_id_memoria_calculo;


           -- inserta valores para todos los periodos de la gestion con valor 0

           FOR v_registros in (select
                                   per.id_periodo
                                from param.tperiodo per
                                where per.id_gestion = v_id_gestion
                                      and per.estado_reg = 'activo'
                                order by per.fecha_ini) LOOP

                            insert into pre.tmemoria_det(
                                importe,
                                estado_reg,
                                id_periodo,
                                id_memoria_calculo,
                                usuario_ai,
                                fecha_reg,
                                id_usuario_reg,
                                id_usuario_ai
                              )
                              values
                              (
                                0,
                                'activo',
                                v_registros.id_periodo,
                                v_id_memoria_calculo,
                                v_parametros._nombre_usuario_ai,
                                now(),
                                p_id_usuario,
                                v_parametros._id_usuario_ai);

            END LOOP;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','MEMCAL almacenado(a) con exito (id_memoria_calculo'||v_id_memoria_calculo||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_memoria_calculo',v_id_memoria_calculo::varchar);

            --Devuelve la respuesta
            return v_resp;

        end;
        
    /*********************************    
    #TRANSACCION:  'PRE_MEMOXLS_INS'
    #DESCRIPCION:  Actualizacion de registros desde excel
    #AUTOR:    manuel guerra  
    #FECHA:    01-09-2013 18:10:12
    ***********************************/

    ELSIF(p_transaccion='PRE_MEMOXLS_INS')THEN
              
   BEGIN

        v_total_memoria=0;
                INSERT INTO pre.tformulacion_tmp(
                codigo,
                tipo1,
                carga,
                descripcion,
                m1,
                m2,
                m3,
                m4,
                m5,
                m6,
                m7,
                m8,
                m9,
                m10,
                m11,
                m12,
                migrado
                )
                VALUES(
                v_parametros.cod_presupuesto,
                v_parametros.desc_pre,
                v_parametros.cod_partida,
                v_parametros.desc_partida,
                v_parametros.enero,
                v_parametros.febrero,
                v_parametros.marzo,
                v_parametros.abril,
                v_parametros.mayo,
                v_parametros.junio,
                v_parametros.julio,
                v_parametros.agosto,
                v_parametros.septiembre,
                v_parametros.octubre,
                v_parametros.noviembre,
                v_parametros.diciembre,        
                'no'
                )RETURNING id into v_id;
                
         v_total_memoria=v_parametros.enero+v_parametros.febrero+v_parametros.marzo+v_parametros.abril+
                         v_parametros.mayo+v_parametros.junio+v_parametros.julio+v_parametros.agosto+
                         v_parametros.septiembre+v_parametros.octubre+v_parametros.noviembre+v_parametros.diciembre;
                                
        
        --obteniendo el id_presupuesto         
        SELECT tp.id_presupuesto 
        INTO v_id_centro_costo
        FROM param.ttipo_cc t
        JOIN param.tcentro_costo tcc ON t.id_tipo_cc=tcc.id_tipo_cc
        INNER JOIN pre.tpresupuesto tp ON tp.id_centro_costo =tcc.id_centro_costo
        INNER JOIN param.tgestion g ON g.id_gestion =tcc.id_gestion
        WHERE t.codigo = v_parametros.cod_presupuesto  
        AND t.estado_reg='activo' 
        AND tcc.estado_reg='activo' 
        and tp.estado IN('borrador','formulacion')
        AND tp.estado_reg='activo'
        AND g.id_gestion=v_parametros.id_gestion;
                
        --verificar que el id, devuelva un resultado
        IF v_id_centro_costo is null THEN
            raise exception 'No existe el codigo de presupuesto o el estado de presupuesto ya esta finalizado%',v_parametros.cod_presupuesto;
        ELSE               
            --obteniendo el id_concepto_ingas
           
            v_codigo=v_parametros.cod_partida||'-F';           
            
            SELECT cp.id_concepto_ingas,p.id_partida 
            INTO v_id_conceto_ingas,v_id_partida
            FROM pre.tconcepto_partida cp
            JOIN pre.tpartida p ON p.id_partida=cp.id_partida
            WHERE p.codigo like v_codigo
            AND p.sw_transaccional='movimiento'
            AND p.id_gestion=v_parametros.id_gestion;

            --verificar que el id, devuelva un resultado                         
            IF v_id_conceto_ingas IS NULL THEN
                raise exception 'No existe el codigo de partida %',v_parametros.cod_partida;
            ELSE      
                                
                SELECT id_presup_partida,id_presupuesto 
                INTO v_id_presup_partida,v_id_presupuesto
                FROM pre.tpresup_partida
                WHERE id_presupuesto = v_id_centro_costo AND id_partida=v_id_partida;
                 
                IF(v_id_presup_partida is null)THEN             
                    INSERT INTO pre.tpresup_partida
                    (id_presupuesto,id_centro_costo,id_partida,fecha_reg,importe,id_usuario_reg)
                    VALUES
                    (v_id_centro_costo,v_id_centro_costo,v_id_partida,now(),v_total_memoria,v_parametros.id_sesion);	
                end if;
                /*
                UPDATE pre.tpresup_partida
                SET importe=v_total_memoria
                WHERE id_presupuesto=v_id_centro_costo AND id_partida=v_id_partida;
                    
                UPDATE pre.tmemoria_calculo
                SET importe_total=v_total_memoria
                WHERE id_presupuesto=v_id_centro_costo AND id_partida=v_id_partida AND id_concepto_ingas = v_id_conceto_ingas
                RETURNING id_memoria_calculo into v_id_memoria_calculo;   
                   */                                                                                                                 
                  SELECT id_memoria_calculo
                INTO v_id_memoria_calculo
                FROM pre.tmemoria_calculo
                WHERE id_presupuesto = v_id_centro_costo AND id_concepto_ingas=v_id_conceto_ingas and id_partida=v_id_partida;
                                         
                if v_id_memoria_calculo is null THEN                                                                                       
                    INSERT INTO pre.tmemoria_calculo
                    (id_usuario_reg,id_presupuesto,id_concepto_ingas,id_partida,fecha_reg,importe_total,obs)
                    VALUES
                    (v_parametros.id_sesion,v_id_centro_costo,v_id_conceto_ingas,v_id_partida,now(),v_total_memoria,'-')
                    RETURNING id_memoria_calculo into v_id_memoria_calculo;    
                ELSE
                --update
				end if;    
                                
	    		
                select id_presupuesto_funcionario
                into v_id_presupuesto_funcionario
                FROM pre.tpresupuesto_funcionario 
                where id_presupuesto=v_id_centro_costo and id_funcionario=v_parametros.id_funcionario;
                
                IF v_id_presupuesto_funcionario is null THEN                
                    INSERT INTO pre.tpresupuesto_funcionario (accion,id_presupuesto,fecha_reg,id_usuario_reg,id_funcionario)
                    VALUES ('formulacion',v_id_centro_costo,now(),v_parametros.id_sesion,v_parametros.id_funcionario)                
                    RETURNING id_presupuesto_funcionario into v_consulta;                 
                END if;                
                /*INSERT INTO pre.tpresupuesto_funcionario (accion,id_presupuesto,fecha_reg,id_usuario_reg,id_funcionario)
                VALUES ('formulacion',v_id_centro_costo,now(),v_parametros.id_sesion,v_parametros.id_funcionario)
                RETURNING id_presupuesto_funcionario into v_consulta;   */
                              
                /*INSERT INTO pre.tpresupuesto_funcionario (accion,id_presupuesto,fecha_reg,id_usuario_reg,id_funcionario)
                VALUES ('responsable',v_id_centro_costo,now(),450,v_parametros.id_usuario);*/
                
                --raise exception '%,%,%',v_id_centro_costo,v_parametros.id_sesion,v_parametros.id_funcionario;
                UPDATE pre.tformulacion_tmp
                SET migrado ='si'
                WHERE id = v_id;                     
                
               /* UPDATE pre.tpresupuesto
                SET estado='borrador'
                WHERE id_presupuesto=v_id_centro_costo AND id_centro_costo=v_id_centro_costo;*/
               -- if v_id_memoria_calculo is null THEN
                    SELECT t.id_periodo
                    INTO v_id_mes_ene
                    FROM param.tperiodo t
                    WHERE t.id_gestion = v_parametros.id_gestion and t.periodo=1;
                        
                    INSERT INTO pre.tmemoria_det
                    (id_usuario_reg,id_periodo,id_memoria_calculo,fecha_reg,importe,importe_unitario)
                    VALUES
                    (v_parametros.id_sesion,v_id_mes_ene,v_id_memoria_calculo,now(),v_parametros.enero,v_parametros.enero);   
                    
                    SELECT t.id_periodo
                    INTO v_id_mes_feb
                    FROM param.tperiodo t
                    WHERE t.id_gestion = v_parametros.id_gestion and t.periodo=2;
                        
                    INSERT INTO pre.tmemoria_det
                    (id_usuario_reg,id_periodo,id_memoria_calculo,fecha_reg,importe,importe_unitario)
                    VALUES
                    (v_parametros.id_sesion,v_id_mes_feb,v_id_memoria_calculo,now(),v_parametros.febrero,v_parametros.febrero);  
                                     
                    SELECT t.id_periodo
                    INTO v_id_mes_mar
                    FROM param.tperiodo t
                    WHERE t.id_gestion = v_parametros.id_gestion and t.periodo=3;
                        
                    INSERT INTO pre.tmemoria_det
                    (id_usuario_reg,id_periodo,id_memoria_calculo,fecha_reg,importe,importe_unitario)
                    VALUES
                    (v_parametros.id_sesion,v_id_mes_mar,v_id_memoria_calculo,now(),v_parametros.marzo,v_parametros.marzo);   
                    
                    SELECT t.id_periodo
                    INTO v_id_mes_abr
                    FROM param.tperiodo t
                    WHERE t.id_gestion = v_parametros.id_gestion and t.periodo=4;
                        
                    INSERT INTO pre.tmemoria_det
                    (id_usuario_reg,id_periodo,id_memoria_calculo,fecha_reg,importe,importe_unitario)
                    VALUES
                    (v_parametros.id_sesion,v_id_mes_abr,v_id_memoria_calculo,now(),v_parametros.abril,v_parametros.abril); 
                    
                     SELECT t.id_periodo
                    INTO v_id_mes_may
                    FROM param.tperiodo t
                    WHERE t.id_gestion = v_parametros.id_gestion and t.periodo=5;
                        
                    INSERT INTO pre.tmemoria_det
                    (id_usuario_reg,id_periodo,id_memoria_calculo,fecha_reg,importe,importe_unitario)
                    VALUES
                    (v_parametros.id_sesion,v_id_mes_may,v_id_memoria_calculo,now(),v_parametros.mayo,v_parametros.mayo);   
                    
                    SELECT t.id_periodo
                    INTO v_id_mes_jun
                    FROM param.tperiodo t
                    WHERE t.id_gestion = v_parametros.id_gestion and t.periodo=6;
                        
                    INSERT INTO pre.tmemoria_det
                    (id_usuario_reg,id_periodo,id_memoria_calculo,fecha_reg,importe,importe_unitario)
                    VALUES
                    (v_parametros.id_sesion,v_id_mes_jun,v_id_memoria_calculo,now(),v_parametros.junio,v_parametros.junio);  
                                     
                    SELECT t.id_periodo
                    INTO v_id_mes_jul
                    FROM param.tperiodo t
                    WHERE t.id_gestion = v_parametros.id_gestion and t.periodo=7;
                        
                    INSERT INTO pre.tmemoria_det
                    (id_usuario_reg,id_periodo,id_memoria_calculo,fecha_reg,importe,importe_unitario)
                    VALUES
                    (v_parametros.id_sesion,v_id_mes_jul,v_id_memoria_calculo,now(),v_parametros.julio,v_parametros.julio);   
                    
                    SELECT t.id_periodo
                    INTO v_id_mes_ago
                    FROM param.tperiodo t
                    WHERE t.id_gestion = v_parametros.id_gestion and t.periodo=8;
                        
                    INSERT INTO pre.tmemoria_det
                    (id_usuario_reg,id_periodo,id_memoria_calculo,fecha_reg,importe,importe_unitario)
                    VALUES
                    (v_parametros.id_sesion,v_id_mes_ago,v_id_memoria_calculo,now(),v_parametros.agosto,v_parametros.agosto);                                 
                    
                    SELECT t.id_periodo
                    INTO v_id_mes_sep
                    FROM param.tperiodo t
                    WHERE t.id_gestion = v_parametros.id_gestion and t.periodo=9;
                        
                    INSERT INTO pre.tmemoria_det
                    (id_usuario_reg,id_periodo,id_memoria_calculo,fecha_reg,importe,importe_unitario)
                    VALUES
                    (v_parametros.id_sesion,v_id_mes_sep,v_id_memoria_calculo,now(),v_parametros.septiembre,v_parametros.septiembre);  
                                     
                    SELECT t.id_periodo
                    INTO v_id_mes_oct
                    FROM param.tperiodo t
                    WHERE t.id_gestion = v_parametros.id_gestion and t.periodo=10;
                        
                    INSERT INTO pre.tmemoria_det
                    (id_usuario_reg,id_periodo,id_memoria_calculo,fecha_reg,importe,importe_unitario)
                    VALUES
                    (v_parametros.id_sesion,v_id_mes_oct,v_id_memoria_calculo,now(),v_parametros.octubre,v_parametros.octubre);   
                    
                    SELECT t.id_periodo
                    INTO v_id_mes_nov
                    FROM param.tperiodo t
                    WHERE t.id_gestion = v_parametros.id_gestion and t.periodo=11;
                        
                    INSERT INTO pre.tmemoria_det
                    (id_usuario_reg,id_periodo,id_memoria_calculo,fecha_reg,importe,importe_unitario)
                    VALUES
                    (v_parametros.id_sesion,v_id_mes_nov,v_id_memoria_calculo,now(),v_parametros.noviembre,v_parametros.noviembre); 
                   
                    SELECT t.id_periodo
                    INTO v_id_mes_dic
                    FROM param.tperiodo t
                    WHERE t.id_gestion = v_parametros.id_gestion and t.periodo=12;
                        
                    INSERT INTO pre.tmemoria_det
                    (id_usuario_reg,id_periodo,id_memoria_calculo,fecha_reg,importe,importe_unitario)
                    VALUES
                    (v_parametros.id_sesion,v_id_mes_dic,v_id_memoria_calculo,now(),v_parametros.diciembre,v_parametros.diciembre); 
                --end if;
            END IF;                                    
        END IF;    
  
        
        --Definicion de la respuesta
        v_resp = pxp.f_agrega_clave(v_resp,'mensaje','archivo existosamente cargado'); 
        v_resp = pxp.f_agrega_clave(v_resp,'memoria_calculo',v_id_memoria_calculo::varchar);
        --Devuelve la respuesta
        return v_resp;
     END;
    /*********************************
    #TRANSACCION:  'PRE_MCA_MOD'
    #DESCRIPCION:   Modificacion de registros
    #AUTOR:     admin
    #FECHA:     01-03-2016 14:22:24
    ***********************************/

    elsif(p_transaccion='PRE_MCA_MOD')then

        begin
            select
              cc.id_gestion,
              pre.estado
            into
              v_registros
            from pre.tpresupuesto pre
            inner join param.tcentro_costo cc on cc.id_centro_costo = pre.id_centro_costo
            where pre.id_presupuesto = v_parametros.id_presupuesto;


            IF v_registros.estado = 'aprobado' THEN
              --raise exception 'no puede editar  conceptos de un presupuesto aprobado';
            END IF;

            SELECT
                par.id_partida
            into
               v_id_partida
            FROM pre.vpresupuesto pre
               JOIN param.tconcepto_ingas cig ON cig.id_concepto_ingas = v_parametros.id_concepto_ingas
               JOIN pre.tconcepto_partida cp ON cp.id_concepto_ingas = v_parametros.id_concepto_ingas
             JOIN pre.tpartida par ON par.id_partida = cp.id_partida AND
                 par.id_gestion = pre.id_gestion
           where pre.id_presupuesto = v_parametros.id_presupuesto
                 and cig.id_concepto_ingas  = v_parametros.id_concepto_ingas;


            --Sentencia de la modificacion
            update pre.tmemoria_calculo set
              id_concepto_ingas = v_parametros.id_concepto_ingas,
              obs = replace(v_parametros.obs, '\n', ' '),
              id_presupuesto = v_parametros.id_presupuesto,
              fecha_mod = now(),
              id_usuario_mod = p_id_usuario,
              id_usuario_ai = v_parametros._id_usuario_ai,
              usuario_ai = v_parametros._nombre_usuario_ai,
              id_partida = v_id_partida
            where id_memoria_calculo = v_parametros.id_memoria_calculo;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','MEMCAL modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_memoria_calculo',v_parametros.id_memoria_calculo::varchar);

            --Devuelve la respuesta
            return v_resp;

        end;

    /*********************************
    #TRANSACCION:  'PRE_MCA_ELI'
    #DESCRIPCION:   Eliminacion de registros
    #AUTOR:     admin
    #FECHA:     01-03-2016 14:22:24
    ***********************************/

    elsif(p_transaccion='PRE_MCA_ELI')then

        begin

            select
              cc.id_gestion,
              pre.estado
            into
              v_registros
            from pre.tpresupuesto pre
            inner join param.tcentro_costo cc on cc.id_centro_costo = pre.id_centro_costo
            inner join pre.tmemoria_calculo m on m.id_presupuesto = pre.id_presupuesto
            where m.id_memoria_calculo=v_parametros.id_memoria_calculo;


            IF v_registros.estado = 'aprobado' THEN
              raise exception 'no puede eliminar concpetos de un presupuesto aprobado';
            END IF;

             --Sentencia de la eliminacion
            delete from pre.tmemoria_det
            where id_memoria_calculo=v_parametros.id_memoria_calculo;

            --Sentencia de la eliminacion
            delete from pre.tmemoria_calculo
            where id_memoria_calculo=v_parametros.id_memoria_calculo;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','MEMCAL eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_memoria_calculo',v_parametros.id_memoria_calculo::varchar);

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