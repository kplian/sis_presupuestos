--------------- SQL ---------------

CREATE OR REPLACE FUNCTION pre.ft_partida_ejecucion_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:   Sistema de Presupuesto
 FUNCION:     pre.ft_partida_ejecucion_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'pre.tpartida_ejecucion'
 AUTOR:      (gvelasquez)
 FECHA:         03-10-2016 15:47:23
 COMENTARIOS:
***************************************************************************
  HISTORIAL DE MODIFICACIONES:

    
 ISSUE            FECHA:          AUTOR       DESCRIPCION
 0                10/10/2017           RAC         Agrgar trasaccion para listado de nro de tramite
 #11 ETR      12/02/2019       MMV Kplian Reporte Integridad presupuestaria   
 #14 ENDETR       12/06/2019           JUAN        Incremento de columnas (Total pago, Contrato, Justificación) en reporte partida ejecución
 #31 ETR          07/01/2019        RAC KPLIAN     listado de tramties para ajuste de presupeusto ordenado por fecha
 #37 ENDETR      31/03/2020       JUAN            Reporte ejecución de proyectos con proveedor
 #138 ENDETR     25/06/2020           JUAN          Mejora de filtros de gestión en partida ejecución con tipo_cc
 #40  ENDETR     09/07/2020           JUAN         Agregar Numero Tramite a reporte Ejecución de proyectos
 #41 ENDETR     12/07/2020        JJA               Agregar columna tipo_ajuste_formulacion en la tabla de partida ejecucion
 #42  ENDETR    17/07/2020        JJA          Interface que muestre la información de "tipo centro de costo" con todos los parámetros
 #44  ENDETR    23/07/2020        JJA          Mejoras en reporte tipo centro de costo de presupuesto
 #45 ENDETR      26/07/2020       JJA             Agregado de filtros en el reporte de Ejecución de proyectos
 #46 ENDETR     06/08/2020        JJA             Reporte partida en presupuesto
 #PRES-5  ENDETR      10/08/2020       JJA            Mejoras en reporte partida con centros de costo de presupuestos
 #PRES-6  ENDETR      28/09/2020       JJA            Reporte formulacion presupuestaria
 #PRES-7  ENDETR      29/09/2020       JJA         Reporte ejecucion inversion
 #ETR-1599 ENDETR     03/11/2021       JJA         Agregar tipo movimiento comprometido 
 #ETR-1632 ENDETR     04/11/2020       JJA         Agregado de tramite y proveedor con movimiento comprometido en el reporte de ejecucion de inversiones
 #ETR-1673 ENDETR     05/11/2020       JJA         Agregado de tramite y proveedor con movimiento ejecutado en el reporte de ejecucion de inversiones
 #PRES-8          13/11/2020      JJA         Reporte partida ejecucion con adquisiciones
 #ETR-1823    ENDETR  17/11/2020     JJA     añadir una vista al detalle con trámites 
 #ETR-1815    ENDETR  18/11/2020     JJA     Reporte ejecucion Presupuestaria
 #ETR-1890          13/11/2020      JJA         Reporte partida ejecucion presupuestaria
***************************************************************************/

DECLARE

  v_consulta        varchar;
  v_parametros      record;
  v_nombre_funcion    text;
  v_resp        varchar;
    v_pre_codigo_proc_macajsutable   varchar;
    v_id_gestion           integer;
    v_filtro_tipo_cc  varchar;
    v_tipo_cc  varchar;
    v_filtro    varchar;
    v_bandera varchar; --#ETR-1673

    v_filtro_tipo_reporte varchar; --#ETR-1815
BEGIN

  v_nombre_funcion = 'pre.ft_partida_ejecucion_sel';
    v_parametros = pxp.f_get_record(p_tabla);

  /*********************************
  #TRANSACCION:  'PRE_PAREJE_SEL'
  #DESCRIPCION: Consulta de datos
  #AUTOR:   gvelasquez
  #FECHA:   03-10-2016 15:47:23
  ***********************************/

  if(p_transaccion='PRE_PAREJE_SEL')then

      begin
        
             v_filtro_tipo_cc = ' 0=0  and ';
        
        
             IF  pxp.f_existe_parametro(p_tabla,'id_tipo_cc')  THEN
                 
                      IF v_parametros.id_tipo_cc is not NULL THEN
                    
                          WITH RECURSIVE tipo_cc_rec (id_tipo_cc, id_tipo_cc_fk) AS (
                            SELECT tcc.id_tipo_cc, tcc.id_tipo_cc_fk
                            FROM param.ttipo_cc tcc
                            WHERE tcc.id_tipo_cc = v_parametros.id_tipo_cc and tcc.estado_reg = 'activo'
                          UNION ALL
                            SELECT tcc2.id_tipo_cc, tcc2.id_tipo_cc_fk
                            FROM tipo_cc_rec lrec 
                            INNER JOIN param.ttipo_cc tcc2 ON lrec.id_tipo_cc = tcc2.id_tipo_cc_fk
                            where tcc2.estado_reg = 'activo'
                          )
                        SELECT  pxp.list(id_tipo_cc::varchar) 
                          into 
                            v_tipo_cc
                        FROM tipo_cc_rec;
                        
                        
                        --se agrego el alias vpe al tipo cc #138
                        v_filtro_tipo_cc = ' vpe.id_tipo_cc in ('||v_tipo_cc||') and ';
                    END IF;
                 END IF;
                 
                 
        -- #14
            v_consulta:='with obligacionPago AS(                   
                        SELECT 
                        DISTINCT ON (od.id_partida_ejecucion_com)
                        COALESCE(obpg.total_pago,0) as total_pago, 
                        con.tipo||'' - ''||con.numero::varchar as desc_contrato, 
                        obpg.obs,mn.moneda,od.id_partida_ejecucion_com
                        FROM tes.tobligacion_pago  obpg 
                        inner join param.tdepto dep on dep.id_depto=obpg.id_depto
                        left join leg.tcontrato con on con.id_contrato = obpg.id_contrato
                        inner join param.tmoneda mn on mn.id_moneda=obpg.id_moneda
                        join tes.tobligacion_det od on od.id_obligacion_pago=obpg.id_obligacion_pago
                        )'; -- #14
            
      v_consulta:=v_consulta||'select
                                  vpe.id_partida_ejecucion,
                                  vpe.id_int_comprobante,
                                  vpe.id_moneda,
                                  vpe.moneda,
                                  vpe.id_presupuesto,
                                  vpe.desc_pres,
                                  vpe.codigo_categoria,
                                  vpe.id_partida,
                                  vpe.codigo,
                                  vpe.nombre_partida,
                                  vpe.nro_tramite,
                                  vpe.tipo_cambio,
                                  vpe.columna_origen,
                                  vpe.tipo_movimiento,
                                  vpe.id_partida_ejecucion_fk,
                                  vpe.estado_reg,
                                  vpe.fecha,
                                  vpe.egreso_mb, 
                                  vpe.ingreso_mb,
                                  vpe.monto_mb,
                                  vpe.monto,
                                  vpe.valor_id_origen,
                                  vpe.id_usuario_reg,
                                  vpe.fecha_reg,
                                  vpe.usuario_ai,
                                  vpe.id_usuario_ai,
                                  vpe.fecha_mod,
                                  vpe.id_usuario_mod,
                                  vpe.usr_reg,
                                  vpe.usr_mod,
                                  vpe.id_tipo_cc,
                                  vpe.desc_tipo_cc,
                                  vpe.nro_cbte,
                                  vpe.id_proceso_wf,
                                  vpe.monto_anticipo_mb,
                                  vpe.monto_desc_anticipo_mb,
                                  vpe.monto_iva_revertido_mb,
                                  vpe.glosa1,
                                  vpe.glosa,
                                  vpe.cantidad_descripcion,
                                  
                                  obpg.total_pago::numeric as total_pago, -- #14
                                  obpg.desc_contrato::VARCHAR, -- #14
                                  obpg.obs::VARCHAR, -- #14
                                  vpe.tipo_ajuste_formulacion --#41
                          from pre.vpartida_ejecucion vpe
                          JOIN param.tcentro_costo cc ON cc.id_centro_costo = vpe.id_presupuesto --#38
                          LEFT join obligacionPago obpg on obpg.id_partida_ejecucion_com=vpe.id_partida_ejecucion -- #14
                          where  '||v_filtro_tipo_cc;

      --Definicion de la respuesta
      v_consulta:=v_consulta||v_parametros.filtro;
                    
      v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

      raise notice 'La consulta es:  %', v_consulta;
            --raise exception 'error %',v_consulta;
      --Devuelve la respuesta
      return v_consulta;

    end;

  /*********************************
  #TRANSACCION:  'PRE_PAREJE_CONT'
  #DESCRIPCION: Conteo de registros
  #AUTOR:   gvelasquez
  #FECHA:   03-10-2016 15:47:23
  ***********************************/

  elsif(p_transaccion='PRE_PAREJE_CONT')then

    begin
        
             v_filtro_tipo_cc = ' 0=0 and ';
        
        
             IF  pxp.f_existe_parametro(p_tabla,'id_tipo_cc')  THEN
                 
                      IF v_parametros.id_tipo_cc is not NULL THEN
                    
                          WITH RECURSIVE tipo_cc_rec (id_tipo_cc, id_tipo_cc_fk) AS (
                            SELECT tcc.id_tipo_cc, tcc.id_tipo_cc_fk
                            FROM param.ttipo_cc tcc
                            WHERE tcc.id_tipo_cc = v_parametros.id_tipo_cc and tcc.estado_reg = 'activo'
                          UNION ALL
                            SELECT tcc2.id_tipo_cc, tcc2.id_tipo_cc_fk
                            FROM tipo_cc_rec lrec 
                            INNER JOIN param.ttipo_cc tcc2 ON lrec.id_tipo_cc = tcc2.id_tipo_cc_fk
                            where tcc2.estado_reg = 'activo'
                          )
                        SELECT  pxp.list(id_tipo_cc::varchar) 
                          into 
                            v_tipo_cc
                        FROM tipo_cc_rec;
                        
                        
                        --se agrego el alias vpe al tipo cc #138
                        v_filtro_tipo_cc = ' vpe.id_tipo_cc in ('||v_tipo_cc||')  and ';
                    END IF;
                 END IF;
                 
                 
      --Sentencia de la consulta de conteo de registros
      v_consulta:='select             
                           count(vpe.id_partida_ejecucion),
                           sum(vpe.egreso_mb) as total_egreso_mb,
                           sum(vpe.ingreso_mb) as total_ingreso_mb,
                           sum(vpe.monto_anticipo_mb) as total_monto_anticipo_mb ,
                           sum(vpe.monto_desc_anticipo_mb) as  total_monto_desc_anticipo_mb,
                           sum(vpe.monto_iva_revertido_mb) as  total_monto_iva_revertido_mb
                        from pre.vpartida_ejecucion vpe
                        JOIN param.tcentro_costo cc ON cc.id_centro_costo = vpe.id_presupuesto --#38


              where '||v_filtro_tipo_cc;

      --Definicion de la respuesta
      v_consulta:=v_consulta||v_parametros.filtro;

      --Devuelve la respuesta
      return v_consulta;

    end;

    /*********************************
  #TRANSACCION:  'PRE_TCENCOS_SEL'
  #DESCRIPCION: Interface que muestre la información de tipo centro de costo con todos los parámetros
  #AUTOR:   JUAN
  #FECHA:   17/07/2020   
  ***********************************/

  ELSEIF(p_transaccion='PRE_TCENCOS_SEL')then --#42

      begin
        
        
     v_filtro_tipo_cc = ' 0=0  and ';
        
        
     IF  pxp.f_existe_parametro(p_tabla,'id_tipo_cc')  THEN
                 
              IF v_parametros.id_tipo_cc is not NULL THEN
                    
                  WITH RECURSIVE tipo_cc_rec (id_tipo_cc, id_tipo_cc_fk) AS (
                    SELECT tcc.id_tipo_cc, tcc.id_tipo_cc_fk
                    FROM param.ttipo_cc tcc
                    WHERE tcc.id_tipo_cc = v_parametros.id_tipo_cc and tcc.estado_reg = 'activo'
                  UNION ALL
                    SELECT tcc2.id_tipo_cc, tcc2.id_tipo_cc_fk
                    FROM tipo_cc_rec lrec 
                    INNER JOIN param.ttipo_cc tcc2 ON lrec.id_tipo_cc = tcc2.id_tipo_cc_fk
                    where tcc2.estado_reg = 'activo'
                  )
                SELECT  pxp.list(id_tipo_cc::varchar) 
                  into 
                    v_tipo_cc
                FROM tipo_cc_rec;
                        
                        
                --se agrego el alias vpe al tipo cc #138
                v_filtro_tipo_cc = ' tcc.id_tipo_cc in ('||v_tipo_cc||') and ';
            END IF;
         END IF;
           --  raise EXCEPTION ' ver %',v_filtro_tipo_cc;
        --Sentencia de la consulta
      v_consulta:='WITH RECURSIVE tipo_cc as (
                  select 
                  tcc.id_tipo_cc,
                  tcc.id_tipo_cc_fk,
                  (tcc.codigo||'' - ''||tcc.descripcion)::varchar as ceco,
                  (tcc.id_tipo_cc)::text as orden,
                  ''*  ''::VARCHAR as nivel,
                  tcc.fecha_inicio,tcc.fecha_final,tcc.operativo,
                    tcc.movimiento,
                    tcc.tipo,
                     case when tcc.mov_pres[1] = ''ingreso'' or tcc.mov_pres[2] = ''ingreso'' then
                     ''si''
                     ELSE
                     ''no''
                     end::VARCHAR as mov_ingreso, 
                     case when tcc.mov_pres[1] = ''egreso'' or tcc.mov_pres[2] = ''egreso'' then
                     ''si''
                     ELSE
                     ''no''
                     end::VARCHAR as mov_egreso, 
                    tcc.control_partida,
                    tcc.control_techo,
                    tcc.momento_pres, 
                    case when tcc.autorizacion[1]=''sueldos_planta'' or tcc.autorizacion[2]=''sueldos_planta'' then
                    ''si''
                    else
                    ''no''
                    end::VARCHAR as sueldo_planta,
                    case when tcc.autorizacion[1]=''sueldos_obradet'' or tcc.autorizacion[2]=''sueldos_obradet'' then
                    ''si''
                    else
                    ''no''
                    end::VARCHAR as sueldo_obradet,
                    tcc.id_usuario_reg,
                    tcc.id_usuario_mod,
                    tcc.fecha_reg,
                    tcc.fecha_mod,
                    tcc.id_ep, --#44
                    
                    prog.nombre_programa, --#44
                    proy.nombre_proyecto, --#44
                    act.nombre_actividad, --#44
                    reg.nombre_regional,  --#44
                    finan.nombre_financiador --#44
                  from param.ttipo_cc tcc
                  left join param.tep ep on ep.id_ep = tcc.id_ep --#44
                  left join param.tprograma_proyecto_acttividad pra on pra.id_prog_pory_acti=ep.id_prog_pory_acti --#44
                  left join param.tactividad act on act.id_actividad=pra.id_actividad --#44
                  left join param.tprograma prog on prog.id_programa=pra.id_programa --#44
                  left join param.tproyecto proy on proy.id_proyecto=pra.id_proyecto --#44
                  left join param.tregional reg on reg.id_regional=ep.id_regional --#44
                  left join param.tfinanciador finan on finan.id_financiador=ep.id_financiador --#44
                  where tcc.id_tipo_cc_fk is null and tcc.codigo not like ''X_%''
                 
                  union all
                  select 
                  tcc.id_tipo_cc,
                  tcc.id_tipo_cc_fk,
                  (tcc.codigo||'' - ''||tcc.descripcion)::varchar as ceco,
                  (tcc1.orden||'' -> ''||tcc.id_tipo_cc)::text as orden,
                  (tcc1.nivel||''  *  '')::text as nivel,
                  tcc.fecha_inicio,tcc.fecha_final,tcc.operativo,
                    tcc.movimiento,
                    tcc.tipo,
                     case when tcc.mov_pres[1] = ''ingreso'' or tcc.mov_pres[2] = ''ingreso'' then
                     ''si''
                     ELSE
                     ''no''
                     end::VARCHAR as mov_ingreso, --ocultar
                     case when tcc.mov_pres[1] = ''egreso'' or tcc.mov_pres[2] = ''egreso'' then
                     ''si''
                     ELSE
                     ''no''
                     end::VARCHAR as mov_egreso, --ocultar
                    tcc.control_partida,
                    tcc.control_techo,
                    tcc.momento_pres,
                    case when tcc.autorizacion[1]=''sueldos_planta'' or tcc.autorizacion[2]=''sueldos_planta'' then
                    ''si''
                    else
                    ''no''
                    end::VARCHAR as sueldo_planta,
                    case when tcc.autorizacion[1]=''sueldos_obradet'' or tcc.autorizacion[2]=''sueldos_obradet'' then
                    ''si''
                    else
                    ''no''
                    end::VARCHAR as sueldo_obradet,
                    tcc.id_usuario_reg,
                    tcc.id_usuario_mod,
                    tcc.fecha_reg,
                    tcc.fecha_mod,
                    tcc.id_ep, --#44
                    
                    prog.nombre_programa, --#44
                    proy.nombre_proyecto, --#44
                    act.nombre_actividad, --#44
                    reg.nombre_regional,  --#44
                    finan.nombre_financiador --#44
                  from param.ttipo_cc tcc
                  join tipo_cc tcc1 on tcc1.id_tipo_cc=tcc.id_tipo_cc_fk
                  
                  left join param.tep ep on ep.id_ep = tcc.id_ep --#44
                  left join param.tprograma_proyecto_acttividad pra on pra.id_prog_pory_acti=ep.id_prog_pory_acti --#44
                  left join param.tactividad act on act.id_actividad=pra.id_actividad --#44
                  left join param.tprograma prog on prog.id_programa=pra.id_programa --#44
                  left join param.tproyecto proy on proy.id_proyecto=pra.id_proyecto --#44
                  left join param.tregional reg on reg.id_regional=ep.id_regional --#44
                  left join param.tfinanciador finan on finan.id_financiador=ep.id_financiador --#44
                  where tcc.codigo not like ''X_%''
                  )
                  select 
                  (replace(tcc.nivel,''*'','' '')||'' ''||tcc.ceco)::varchar as ceco,
                  to_char(tcc.fecha_inicio::DATE,''DD/MM/YYYY'')::DATE AS fecha_inicio,
                  to_char(tcc.fecha_final::DATE,''DD/MM/YYYY'')::DATE AS fecha_final,
                  tcc.operativo::varchar,
                  length(replace(tcc.nivel,'' '',''''))::integer as nivel,
                  sum(vpe.egreso_mb)::numeric as formulacion_egreso_mb,
                  sum(vpe.ingreso_mb)::numeric as formulacion_ingreso_mb,
                  (case when tcc.movimiento = ''si'' then ''transaccional'' else ''agrupador'' end)::varchar as tipo_nodo,
                    tcc.mov_ingreso::varchar,
                    tcc.mov_egreso::varchar,
                     
                    tcc.control_partida::varchar,
                    tcc.control_techo::varchar,
                    tcc.sueldo_planta::varchar,
                    tcc.sueldo_obradet::varchar,
                    
                    ur.cuenta::varchar as usuario_reg,
                    um.cuenta::varchar as usuario_mod,
                    tcc.fecha_reg::date,
                    tcc.fecha_mod::date,
                    g.gestion::integer,
                    tcc.id_tipo_cc,
                    
                    tcc.nombre_programa, --#44
                    tcc.nombre_proyecto, --#44
                    tcc.nombre_actividad, --#44
                    tcc.nombre_regional,  --#44
                    tcc.nombre_financiador --#44
                  
                  from tipo_cc tcc
                  left join param.tcentro_costo cc on cc.id_tipo_cc = tcc.id_tipo_cc
                  left join pre.vpartida_ejecucion vpe on vpe.id_centro_costo=cc.id_centro_costo
                  and vpe.tipo_movimiento=''formulado''
                  left join segu.tusuario ur on ur.id_usuario = tcc.id_usuario_reg
                  left join segu.tusuario um on um.id_usuario = tcc.id_usuario_mod
                  left join param.tgestion g on g.id_gestion=cc.id_gestion

                  where 0=0
                 
                  AND '||v_filtro_tipo_cc||' ';

      v_consulta:=v_consulta||v_parametros.filtro;
      v_consulta:=v_consulta||' group by 
                                tcc.id_tipo_cc,
                                tcc.ceco,
                                tcc.nivel,
                                tcc.fecha_inicio,
                                tcc.fecha_final,
                                tcc.operativo,
                                tcc.movimiento,
                                tcc.mov_ingreso, 
                                tcc.mov_egreso,
                                tcc.control_partida,
                                tcc.control_techo,
                                tcc.sueldo_planta,
                                tcc.sueldo_obradet,
                                ur.cuenta,
                                um.cuenta,
                                tcc.fecha_reg,
                                tcc.fecha_mod,
                                tcc.orden,
                                g.gestion,
                                tcc.nombre_programa, --#44
                                tcc.nombre_proyecto, --#44
                                tcc.nombre_actividad, --#44
                                tcc.nombre_regional,  --#44
                                tcc.nombre_financiador ';
                    
      v_consulta:=v_consulta||' order by tcc.orden asc  limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

      raise notice 'ver datos %',v_consulta;
      --raise exception 'lleog %',v_consulta;
          
      return v_consulta;

    end;
  /*********************************
  #TRANSACCION:  'PRE_TCENCOS_CONT'
  #DESCRIPCION: Conteo de registros
  #AUTOR:   JUAN
  #FECHA:   17-07-2020 15:47:23
  ***********************************/

  elsif(p_transaccion='PRE_TCENCOS_CONT')then --#42

    begin
     v_filtro_tipo_cc = ' 0=0  and ';
        
        
     IF  pxp.f_existe_parametro(p_tabla,'id_tipo_cc')  THEN
                 
              IF v_parametros.id_tipo_cc is not NULL THEN
                    
                  WITH RECURSIVE tipo_cc_rec (id_tipo_cc, id_tipo_cc_fk) AS (
                    SELECT tcc.id_tipo_cc, tcc.id_tipo_cc_fk
                    FROM param.ttipo_cc tcc
                    WHERE tcc.id_tipo_cc = v_parametros.id_tipo_cc and tcc.estado_reg = 'activo'
                  UNION ALL
                    SELECT tcc2.id_tipo_cc, tcc2.id_tipo_cc_fk
                    FROM tipo_cc_rec lrec 
                    INNER JOIN param.ttipo_cc tcc2 ON lrec.id_tipo_cc = tcc2.id_tipo_cc_fk
                    where tcc2.estado_reg = 'activo'
                  )
                SELECT  pxp.list(id_tipo_cc::varchar) 
                  into 
                    v_tipo_cc
                FROM tipo_cc_rec;
                        
                        
                --se agrego el alias vpe al tipo cc #138
                v_filtro_tipo_cc = ' tcc.id_tipo_cc in ('||v_tipo_cc||') and ';
            END IF;
         END IF; 
         
      v_consulta:='WITH RECURSIVE tipo_cc as (
                  select 
                  tcc.id_tipo_cc,
                  tcc.id_tipo_cc_fk,
                  (tcc.codigo||'' - ''||tcc.descripcion)::varchar as ceco,
                  (tcc.id_tipo_cc)::text as orden,
                  ''*  ''::VARCHAR as nivel,
                  tcc.fecha_inicio,tcc.fecha_final,tcc.operativo,
                    tcc.movimiento,
                    tcc.tipo,
                     case when tcc.mov_pres[1] = ''ingreso'' or tcc.mov_pres[2] = ''ingreso'' then
                     ''si''
                     ELSE
                     ''no''
                     end as mov_ingreso, 
                     case when tcc.mov_pres[1] = ''egreso'' or tcc.mov_pres[2] = ''egreso'' then
                     ''si''
                     ELSE
                     ''no''
                     end as mov_egreso, 
                    tcc.control_partida,
                    tcc.control_techo,
                    tcc.momento_pres, 
                    case when tcc.autorizacion[1]=''sueldos_planta'' or tcc.autorizacion[2]=''sueldos_planta'' then
                    ''si''
                    else
                    ''no''
                    end as sueldo_planta,
                    case when tcc.autorizacion[1]=''sueldos_obradet'' or tcc.autorizacion[2]=''sueldos_obradet'' then
                    ''si''
                    else
                    ''no''
                    end as sueldo_obradet,
                    tcc.id_usuario_reg,
                    tcc.id_usuario_mod,
                    tcc.fecha_reg,
                    tcc.fecha_mod,
                    
                    prog.nombre_programa, --#44
                    proy.nombre_proyecto, --#44 
                    act.nombre_actividad, --#44
                    reg.nombre_regional,  --#44
                    finan.nombre_financiador --#44
                  from param.ttipo_cc tcc
                  
                  left join param.tep ep on ep.id_ep = tcc.id_ep --#44
                  left join param.tprograma_proyecto_acttividad pra on pra.id_prog_pory_acti=ep.id_prog_pory_acti --#44
                  left join param.tactividad act on act.id_actividad=pra.id_actividad --#44
                  left join param.tprograma prog on prog.id_programa=pra.id_programa --#44
                  left join param.tproyecto proy on proy.id_proyecto=pra.id_proyecto --#44
                  left join param.tregional reg on reg.id_regional=ep.id_regional --#44
                  left join param.tfinanciador finan on finan.id_financiador=ep.id_financiador --#44
                  
                  where tcc.id_tipo_cc_fk is null and tcc.codigo not like ''X_%''
                  union all
                  select 
                  tcc.id_tipo_cc,
                  tcc.id_tipo_cc_fk,
                  (tcc.codigo||'' - ''||tcc.descripcion)::varchar as ceco,
                  (tcc1.orden||'' -> ''||tcc.id_tipo_cc)::text as orden,
                  (tcc1.nivel||''  *  '')::text as nivel,
                  tcc.fecha_inicio,tcc.fecha_final,tcc.operativo,
                    tcc.movimiento,
                    tcc.tipo,
                     case when tcc.mov_pres[1] = ''ingreso'' or tcc.mov_pres[2] = ''ingreso'' then
                     ''si''
                     ELSE
                     ''no''
                     end as mov_ingreso, --ocultar
                     case when tcc.mov_pres[1] = ''egreso'' or tcc.mov_pres[2] = ''egreso'' then
                     ''si''
                     ELSE
                     ''no''
                     end as mov_egreso, --ocultar
                    tcc.control_partida,
                    tcc.control_techo,
                    tcc.momento_pres,
                    case when tcc.autorizacion[1]=''sueldos_planta'' or tcc.autorizacion[2]=''sueldos_planta'' then
                    ''si''
                    else
                    ''no''
                    end as sueldo_planta,
                    case when tcc.autorizacion[1]=''sueldos_obradet'' or tcc.autorizacion[2]=''sueldos_obradet'' then
                    ''si''
                    else
                    ''no''
                    end as sueldo_obradet,
                    tcc.id_usuario_reg,
                    tcc.id_usuario_mod,
                    tcc.fecha_reg,
                    tcc.fecha_mod,
                    
                    prog.nombre_programa, --#44
                    proy.nombre_proyecto, --#44
                    act.nombre_actividad, --#44
                    reg.nombre_regional,  --#44
                    finan.nombre_financiador --#44
                    
                  from param.ttipo_cc tcc
                  join tipo_cc tcc1 on tcc1.id_tipo_cc=tcc.id_tipo_cc_fk
                  
                  left join param.tep ep on ep.id_ep = tcc.id_ep --#44
                  left join param.tprograma_proyecto_acttividad pra on pra.id_prog_pory_acti=ep.id_prog_pory_acti --#44
                  left join param.tactividad act on act.id_actividad=pra.id_actividad --#44
                  left join param.tprograma prog on prog.id_programa=pra.id_programa --#44
                  left join param.tproyecto proy on proy.id_proyecto=pra.id_proyecto --#44
                  left join param.tregional reg on reg.id_regional=ep.id_regional --#44
                  left join param.tfinanciador finan on finan.id_financiador=ep.id_financiador --#44
                  )
                  select 
                  COUNT(DISTINCT tcc.id_tipo_cc),
                  sum(vpe.egreso_mb) as total_mov_egreso_mb,
                  sum(vpe.ingreso_mb) as total_mov_ingreso_mb
                  from tipo_cc tcc
                  left join param.tcentro_costo cc on cc.id_tipo_cc = tcc.id_tipo_cc
                  left join pre.vpartida_ejecucion vpe on vpe.id_centro_costo=cc.id_centro_costo
                  and vpe.tipo_movimiento=''formulado''
                  
                  left join segu.tusuario ur on ur.id_usuario = tcc.id_usuario_reg --#44
                  left join segu.tusuario um on um.id_usuario = tcc.id_usuario_mod --#44
                  left join param.tgestion g on g.id_gestion=cc.id_gestion --#44
                  where 0=0
                  
                  AND '||v_filtro_tipo_cc||' ';

      v_consulta:=v_consulta||v_parametros.filtro;

      return v_consulta;

    end;

    /*********************************
  #TRANSACCION:  'PRE_AITCENCOS_SEL'
  #DESCRIPCION: Interface que muestre la información de tipo centro de costo con todos los parámetros
  #AUTOR:   JUAN
  #FECHA:   17/07/2020   
  ***********************************/

  ELSEIF(p_transaccion='PRE_AITCENCOS_SEL')then 
    --#PRES-5 
      begin
        
        
     v_filtro_tipo_cc = ' 0=0  and ';
        
        
     IF  pxp.f_existe_parametro(p_tabla,'id_tipo_cc')  THEN
                 
              IF v_parametros.id_tipo_cc is not NULL THEN
                    
                  WITH RECURSIVE tipo_cc_rec (id_tipo_cc, id_tipo_cc_fk) AS (
                    SELECT tcc.id_tipo_cc, tcc.id_tipo_cc_fk
                    FROM param.ttipo_cc tcc
                    WHERE tcc.id_tipo_cc = v_parametros.id_tipo_cc and tcc.estado_reg = 'activo'
                  UNION ALL
                    SELECT tcc2.id_tipo_cc, tcc2.id_tipo_cc_fk
                    FROM tipo_cc_rec lrec 
                    INNER JOIN param.ttipo_cc tcc2 ON lrec.id_tipo_cc = tcc2.id_tipo_cc_fk
                    where tcc2.estado_reg = 'activo'
                  )
                SELECT  pxp.list(id_tipo_cc::varchar) 
                  into 
                    v_tipo_cc
                FROM tipo_cc_rec;
                        
                        
                --se agrego el alias vpe al tipo cc #138
                v_filtro_tipo_cc = ' tcc.id_tipo_cc in ('||v_tipo_cc||') and ';
            END IF;
         END IF;
           --  raise EXCEPTION ' ver %',v_filtro_tipo_cc;
        --Sentencia de la consulta
      v_consulta:='WITH RECURSIVE tipo_cc as (
                  select 
                  tcc.id_tipo_cc,
                  tcc.id_tipo_cc_fk,
                  (tcc.codigo||'' - ''||tcc.descripcion)::varchar as ceco,
                  (tcc.id_tipo_cc)::text as orden,
                  ''*  ''::VARCHAR as nivel,
                  tcc.fecha_inicio,tcc.fecha_final,tcc.operativo,
                    tcc.movimiento,
                    tcc.tipo,
                     case when tcc.mov_pres[1] = ''ingreso'' or tcc.mov_pres[2] = ''ingreso'' then
                     ''si''
                     ELSE
                     ''no''
                     end::VARCHAR as mov_ingreso, 
                     case when tcc.mov_pres[1] = ''egreso'' or tcc.mov_pres[2] = ''egreso'' then
                     ''si''
                     ELSE
                     ''no''
                     end::VARCHAR as mov_egreso, 
                    tcc.control_partida,
                    tcc.control_techo,
                    tcc.momento_pres, 
                    case when tcc.autorizacion[1]=''sueldos_planta'' or tcc.autorizacion[2]=''sueldos_planta'' then
                    ''si''
                    else
                    ''no''
                    end::VARCHAR as sueldo_planta,
                    case when tcc.autorizacion[1]=''sueldos_obradet'' or tcc.autorizacion[2]=''sueldos_obradet'' then
                    ''si''
                    else
                    ''no''
                    end::VARCHAR as sueldo_obradet,
                    tcc.id_usuario_reg,
                    tcc.id_usuario_mod,
                    tcc.fecha_reg,
                    tcc.fecha_mod,
                    tcc.id_ep, 
                    
                    prog.nombre_programa, 
                    proy.nombre_proyecto, 
                    act.nombre_actividad, 
                    reg.nombre_regional,  
                    finan.nombre_financiador 
                  from param.ttipo_cc tcc
                  left join param.tep ep on ep.id_ep = tcc.id_ep 
                  left join param.tprograma_proyecto_acttividad pra on pra.id_prog_pory_acti=ep.id_prog_pory_acti 
                  left join param.tactividad act on act.id_actividad=pra.id_actividad 
                  left join param.tprograma prog on prog.id_programa=pra.id_programa 
                  left join param.tproyecto proy on proy.id_proyecto=pra.id_proyecto 
                  left join param.tregional reg on reg.id_regional=ep.id_regional 
                  left join param.tfinanciador finan on finan.id_financiador=ep.id_financiador 
                  where tcc.id_tipo_cc_fk is null and tcc.codigo not like ''X_%''
                 
                  union all
                  select 
                  tcc.id_tipo_cc,
                  tcc.id_tipo_cc_fk,
                  (tcc.codigo||'' - ''||tcc.descripcion)::varchar as ceco,
                  (tcc1.orden||'' -> ''||tcc.id_tipo_cc)::text as orden,
                  (tcc1.nivel||''  *  '')::text as nivel,
                  tcc.fecha_inicio,tcc.fecha_final,tcc.operativo,
                    tcc.movimiento,
                    tcc.tipo,
                     case when tcc.mov_pres[1] = ''ingreso'' or tcc.mov_pres[2] = ''ingreso'' then
                     ''si''
                     ELSE
                     ''no''
                     end::VARCHAR as mov_ingreso, --ocultar
                     case when tcc.mov_pres[1] = ''egreso'' or tcc.mov_pres[2] = ''egreso'' then
                     ''si''
                     ELSE
                     ''no''
                     end::VARCHAR as mov_egreso, --ocultar
                    tcc.control_partida,
                    tcc.control_techo,
                    tcc.momento_pres,
                    case when tcc.autorizacion[1]=''sueldos_planta'' or tcc.autorizacion[2]=''sueldos_planta'' then
                    ''si''
                    else
                    ''no''
                    end::VARCHAR as sueldo_planta,
                    case when tcc.autorizacion[1]=''sueldos_obradet'' or tcc.autorizacion[2]=''sueldos_obradet'' then
                    ''si''
                    else
                    ''no''
                    end::VARCHAR as sueldo_obradet,
                    tcc.id_usuario_reg,
                    tcc.id_usuario_mod,
                    tcc.fecha_reg,
                    tcc.fecha_mod,
                    tcc.id_ep, 
                    
                    prog.nombre_programa, 
                    proy.nombre_proyecto, 
                    act.nombre_actividad, 
                    reg.nombre_regional,  
                    finan.nombre_financiador 
                  from param.ttipo_cc tcc
                  join tipo_cc tcc1 on tcc1.id_tipo_cc=tcc.id_tipo_cc_fk
                  
                  left join param.tep ep on ep.id_ep = tcc.id_ep 
                  left join param.tprograma_proyecto_acttividad pra on pra.id_prog_pory_acti=ep.id_prog_pory_acti 
                  left join param.tactividad act on act.id_actividad=pra.id_actividad 
                  left join param.tprograma prog on prog.id_programa=pra.id_programa 
                  left join param.tproyecto proy on proy.id_proyecto=pra.id_proyecto 
                  left join param.tregional reg on reg.id_regional=ep.id_regional 
                  left join param.tfinanciador finan on finan.id_financiador=ep.id_financiador 
                  where tcc.codigo not like ''X_%''
                  )
                  select 
                  (replace(tcc.nivel,''*'','' '')||'' ''||tcc.ceco)::varchar as ceco,
                  to_char(tcc.fecha_inicio::DATE,''DD/MM/YYYY'')::DATE AS fecha_inicio,
                  to_char(tcc.fecha_final::DATE,''DD/MM/YYYY'')::DATE AS fecha_final,
                  tcc.operativo::varchar,
                  length(replace(tcc.nivel,'' '',''''))::integer as nivel,
                  sum(vpe.egreso_mb)::numeric as formulacion_egreso_mb,
                  sum(vpe.ingreso_mb)::numeric as formulacion_ingreso_mb,
                  (case when tcc.movimiento = ''si'' then ''transaccional'' else ''agrupador'' end)::varchar as tipo_nodo,
                    tcc.mov_ingreso::varchar,
                    tcc.mov_egreso::varchar,
                     
                    tcc.control_partida::varchar,
                    tcc.control_techo::varchar,
                    tcc.sueldo_planta::varchar,
                    tcc.sueldo_obradet::varchar,
                    
                    ur.cuenta::varchar as usuario_reg,
                    um.cuenta::varchar as usuario_mod,
                    tcc.fecha_reg::date,
                    tcc.fecha_mod::date,
                    g.gestion::integer,
                    tcc.id_tipo_cc,
                    
                    tcc.nombre_programa, 
                    tcc.nombre_proyecto, 
                    tcc.nombre_actividad, 
                    tcc.nombre_regional,  
                    tcc.nombre_financiador,

                    cc.id_centro_costo, --#PRES-5 
                    '|| v_parametros.id_gestion||'::integer as id_gestion  --#PRES-5
                  from tipo_cc tcc
                  left join param.tcentro_costo cc on cc.id_tipo_cc = tcc.id_tipo_cc
                  left join pre.vpartida_ejecucion vpe on vpe.id_centro_costo=cc.id_centro_costo
                  and vpe.tipo_movimiento=''formulado''
                  left join segu.tusuario ur on ur.id_usuario = tcc.id_usuario_reg
                  left join segu.tusuario um on um.id_usuario = tcc.id_usuario_mod
                  left join param.tgestion g on g.id_gestion=cc.id_gestion

                  where 0=0
                 
                  AND '||v_filtro_tipo_cc||' ';

      v_consulta:=v_consulta||v_parametros.filtro;
      v_consulta:=v_consulta||' group by 
                                tcc.id_tipo_cc,
                                tcc.ceco,
                                tcc.nivel,
                                tcc.fecha_inicio,
                                tcc.fecha_final,
                                tcc.operativo,
                                tcc.movimiento,
                                tcc.mov_ingreso, 
                                tcc.mov_egreso,
                                tcc.control_partida,
                                tcc.control_techo,
                                tcc.sueldo_planta,
                                tcc.sueldo_obradet,
                                ur.cuenta,
                                um.cuenta,
                                tcc.fecha_reg,
                                tcc.fecha_mod,
                                tcc.orden,
                                g.gestion,
                                tcc.nombre_programa, 
                                tcc.nombre_proyecto, 
                                tcc.nombre_actividad, 
                                tcc.nombre_regional,  
                                tcc.nombre_financiador,
                                cc.id_centro_costo, --#PRES-5
                                cc.id_gestion --#PRES-5 ';
                    
      v_consulta:=v_consulta||' order by tcc.orden asc  limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

      raise notice 'ver datos %',v_consulta;
      --raise exception 'lleog %',v_consulta;
          
      return v_consulta;

    end;
  /*********************************
  #TRANSACCION:  'PRE_AITCENCOS_CONT'
  #DESCRIPCION: Conteo de registros
  #AUTOR:   JUAN
  #FECHA:   17-07-2020 15:47:23
  ***********************************/

  elsif(p_transaccion='PRE_AITCENCOS_CONT')then  
    --#PRES-5 
    begin
     v_filtro_tipo_cc = ' 0=0  and ';
        
        
     IF  pxp.f_existe_parametro(p_tabla,'id_tipo_cc')  THEN
                 
              IF v_parametros.id_tipo_cc is not NULL THEN
                    
                  WITH RECURSIVE tipo_cc_rec (id_tipo_cc, id_tipo_cc_fk) AS (
                    SELECT tcc.id_tipo_cc, tcc.id_tipo_cc_fk
                    FROM param.ttipo_cc tcc
                    WHERE tcc.id_tipo_cc = v_parametros.id_tipo_cc and tcc.estado_reg = 'activo'
                  UNION ALL
                    SELECT tcc2.id_tipo_cc, tcc2.id_tipo_cc_fk
                    FROM tipo_cc_rec lrec 
                    INNER JOIN param.ttipo_cc tcc2 ON lrec.id_tipo_cc = tcc2.id_tipo_cc_fk
                    where tcc2.estado_reg = 'activo'
                  )
                SELECT  pxp.list(id_tipo_cc::varchar) 
                  into 
                    v_tipo_cc
                FROM tipo_cc_rec;
                        
                        
                --se agrego el alias vpe al tipo cc #138
                v_filtro_tipo_cc = ' tcc.id_tipo_cc in ('||v_tipo_cc||') and ';
            END IF;
         END IF; 
         
      v_consulta:='WITH RECURSIVE tipo_cc as (
                  select 
                  tcc.id_tipo_cc,
                  tcc.id_tipo_cc_fk,
                  (tcc.codigo||'' - ''||tcc.descripcion)::varchar as ceco,
                  (tcc.id_tipo_cc)::text as orden,
                  ''*  ''::VARCHAR as nivel,
                  tcc.fecha_inicio,tcc.fecha_final,tcc.operativo,
                    tcc.movimiento,
                    tcc.tipo,
                     case when tcc.mov_pres[1] = ''ingreso'' or tcc.mov_pres[2] = ''ingreso'' then
                     ''si''
                     ELSE
                     ''no''
                     end as mov_ingreso, 
                     case when tcc.mov_pres[1] = ''egreso'' or tcc.mov_pres[2] = ''egreso'' then
                     ''si''
                     ELSE
                     ''no''
                     end as mov_egreso, 
                    tcc.control_partida,
                    tcc.control_techo,
                    tcc.momento_pres, 
                    case when tcc.autorizacion[1]=''sueldos_planta'' or tcc.autorizacion[2]=''sueldos_planta'' then
                    ''si''
                    else
                    ''no''
                    end as sueldo_planta,
                    case when tcc.autorizacion[1]=''sueldos_obradet'' or tcc.autorizacion[2]=''sueldos_obradet'' then
                    ''si''
                    else
                    ''no''
                    end as sueldo_obradet,
                    tcc.id_usuario_reg,
                    tcc.id_usuario_mod,
                    tcc.fecha_reg,
                    tcc.fecha_mod,
                    
                    prog.nombre_programa, 
                    proy.nombre_proyecto, 
                    act.nombre_actividad, 
                    reg.nombre_regional,  
                    finan.nombre_financiador 
                  from param.ttipo_cc tcc
                  
                  left join param.tep ep on ep.id_ep = tcc.id_ep 
                  left join param.tprograma_proyecto_acttividad pra on pra.id_prog_pory_acti=ep.id_prog_pory_acti 
                  left join param.tactividad act on act.id_actividad=pra.id_actividad 
                  left join param.tprograma prog on prog.id_programa=pra.id_programa 
                  left join param.tproyecto proy on proy.id_proyecto=pra.id_proyecto 
                  left join param.tregional reg on reg.id_regional=ep.id_regional 
                  left join param.tfinanciador finan on finan.id_financiador=ep.id_financiador 
                  
                  where tcc.id_tipo_cc_fk is null and tcc.codigo not like ''X_%''
                  union all
                  select 
                  tcc.id_tipo_cc,
                  tcc.id_tipo_cc_fk,
                  (tcc.codigo||'' - ''||tcc.descripcion)::varchar as ceco,
                  (tcc1.orden||'' -> ''||tcc.id_tipo_cc)::text as orden,
                  (tcc1.nivel||''  *  '')::text as nivel,
                  tcc.fecha_inicio,tcc.fecha_final,tcc.operativo,
                    tcc.movimiento,
                    tcc.tipo,
                     case when tcc.mov_pres[1] = ''ingreso'' or tcc.mov_pres[2] = ''ingreso'' then
                     ''si''
                     ELSE
                     ''no''
                     end as mov_ingreso, --ocultar
                     case when tcc.mov_pres[1] = ''egreso'' or tcc.mov_pres[2] = ''egreso'' then
                     ''si''
                     ELSE
                     ''no''
                     end as mov_egreso, --ocultar
                    tcc.control_partida,
                    tcc.control_techo,
                    tcc.momento_pres,
                    case when tcc.autorizacion[1]=''sueldos_planta'' or tcc.autorizacion[2]=''sueldos_planta'' then
                    ''si''
                    else
                    ''no''
                    end as sueldo_planta,
                    case when tcc.autorizacion[1]=''sueldos_obradet'' or tcc.autorizacion[2]=''sueldos_obradet'' then
                    ''si''
                    else
                    ''no''
                    end as sueldo_obradet,
                    tcc.id_usuario_reg,
                    tcc.id_usuario_mod,
                    tcc.fecha_reg,
                    tcc.fecha_mod,
                    
                    prog.nombre_programa, 
                    proy.nombre_proyecto, 
                    act.nombre_actividad, 
                    reg.nombre_regional,  
                    finan.nombre_financiador 
                    
                  from param.ttipo_cc tcc
                  join tipo_cc tcc1 on tcc1.id_tipo_cc=tcc.id_tipo_cc_fk
                  
                  left join param.tep ep on ep.id_ep = tcc.id_ep 
                  left join param.tprograma_proyecto_acttividad pra on pra.id_prog_pory_acti=ep.id_prog_pory_acti 
                  left join param.tactividad act on act.id_actividad=pra.id_actividad 
                  left join param.tprograma prog on prog.id_programa=pra.id_programa 
                  left join param.tproyecto proy on proy.id_proyecto=pra.id_proyecto 
                  left join param.tregional reg on reg.id_regional=ep.id_regional 
                  left join param.tfinanciador finan on finan.id_financiador=ep.id_financiador 
                  )
                  select 
                  COUNT(DISTINCT tcc.id_tipo_cc),
                  sum(vpe.egreso_mb) as total_mov_egreso_mb,
                  sum(vpe.ingreso_mb) as total_mov_ingreso_mb
                  from tipo_cc tcc
                  left join param.tcentro_costo cc on cc.id_tipo_cc = tcc.id_tipo_cc
                  left join pre.vpartida_ejecucion vpe on vpe.id_centro_costo=cc.id_centro_costo
                  and vpe.tipo_movimiento=''formulado''
                  
                  left join segu.tusuario ur on ur.id_usuario = tcc.id_usuario_reg 
                  left join segu.tusuario um on um.id_usuario = tcc.id_usuario_mod 
                  left join param.tgestion g on g.id_gestion=cc.id_gestion 
                  where 0=0
                  
                  AND '||v_filtro_tipo_cc||' ';

      v_consulta:=v_consulta||v_parametros.filtro;

      return v_consulta;

    end;
        
    /*********************************
  #TRANSACCION:  'PRE_LISTRAPE_SEL'
  #DESCRIPCION: Lista nro de tramite para interface de ajustes, icnremetosy compromisos presupesutario
  #AUTOR:   rac
  #FECHA:   11/10/2017   
  ***********************************/

  ELSEIF(p_transaccion='PRE_LISTRAPE_SEL')then

      begin
        
          v_pre_codigo_proc_macajsutable =  pxp.f_get_variable_global('pre_codigo_proc_macajsutable');
            
          --recueerar la gestion de la fecha
            
          select 
             p.id_gestion
          into
            v_id_gestion
          from param.tperiodo p
          where  v_parametros.fecha_ajuste::Date BETWEEN p.fecha_ini::Date and p.fecha_fin::date;
            
          IF v_id_gestion is null  THEN
             raise exception 'no se encontro gestion para la fecha: %',v_parametros.fecha_ajuste;
          END IF;
            
          
            
             
        --Sentencia de la consulta
      v_consulta:='select
                             DISTINCT ON (pe.nro_tramite)
                             pr.id_gestion,
                             pe.nro_tramite,
                             pm.codigo,
                             pe.id_moneda,
                             mon.codigo as desc_moneda
                          from pre.tpartida_ejecucion pe
                          inner join wf.tproceso_wf pwf on pwf.nro_tramite = pe.nro_tramite
                          inner join wf.ttipo_proceso tp on tp.id_tipo_proceso = pwf.id_tipo_proceso
                          inner join wf.tproceso_macro pm on pm.id_proceso_macro = tp.id_proceso_macro
                          inner join param.tperiodo pr on pe.fecha BETWEEN pr.fecha_ini and pr.fecha_fin 
                          inner join param.tmoneda mon on mon.id_moneda = pe.id_moneda
                          where pm.codigo in ('||COALESCE(v_pre_codigo_proc_macajsutable,'''TEST''') ||') 
                          and  pr.id_gestion = '||v_id_gestion::Varchar|| ' and ';

      --Definicion de la respuesta
      v_consulta:=v_consulta||v_parametros.filtro;
      --#31 se fija la ordeacion por tramite y fecha de reg
      v_consulta:=v_consulta||' order by pe.nro_tramite asc , pe.fecha_reg asc limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

      --Devuelve la respuesta
      return v_consulta;

    end;

  /*********************************
  #TRANSACCION:  'PRE_LISTRAPE_CONT'
  #DESCRIPCION: Conteo de registros
  #AUTOR:   rac
  #FECHA:   11/10/2017 
  ***********************************/

  elsif(p_transaccion='PRE_LISTRAPE_CONT')then

    begin
        
            v_pre_codigo_proc_macajsutable =  pxp.f_get_variable_global('pre_codigo_proc_macajsutable');
           
            
            --recuperar  la gestion de la fecha            
            select 
               p.id_gestion
            into
              v_id_gestion
            from param.tperiodo p
            where  v_parametros.fecha_ajuste BETWEEN p.fecha_ini and p.fecha_fin;
            
            IF v_id_gestion is null  THEN
               raise exception 'no se encontro gestion para la fecha: %',v_parametros.fecha_ajuste;
            END IF;
            
          
            
      --Sentencia de la consulta de conteo de registros
      v_consulta:='select 
                             count( DISTINCT pe.nro_tramite)
              from pre.tpartida_ejecucion pe
                          inner join wf.tproceso_wf pwf on pwf.nro_tramite = pe.nro_tramite
                          inner join wf.ttipo_proceso tp on tp.id_tipo_proceso = pwf.id_tipo_proceso
                          inner join wf.tproceso_macro pm on pm.id_proceso_macro = tp.id_proceso_macro
                          inner join param.tperiodo pr on pe.fecha BETWEEN pr.fecha_ini and pr.fecha_fin 
                          inner join param.tmoneda mon on mon.id_moneda = pe.id_moneda
                        where pm.codigo in ('||COALESCE(v_pre_codigo_proc_macajsutable,'''TEST''') ||') 
                          and  pr.id_gestion = '||v_id_gestion::Varchar|| ' and ';

      --Definicion de la respuesta
      v_consulta:=v_consulta||v_parametros.filtro;

      --Devuelve la respuesta
      return v_consulta;

    end;    
    
    
    /*********************************
  #TRANSACCION:  'PRE_INPRE_SEL' #11
  #DESCRIPCION: Conteo de registros
  #AUTOR:   MMV Kplian
  #FECHA:   11/10/2017 
  ***********************************/

  elsif(p_transaccion='PRE_INPRE_SEL')then

    begin
        
        if (v_parametros.tipo_filtro = 'positivo' )then
          v_filtro = 'form.id_gestion = '||v_parametros.id_gestion||' and 0 = 0' ;
        else
          v_filtro = 'form.id_gestion = '||v_parametros.id_gestion||' and (form.total_formulado - total_comprometido) < 0 
                                          or (form.total_formulado - eje.total_ejecutado ) < 0 ' ;
        end if;
      --Sentencia de la consulta de conteo de registros
      v_consulta:='with formulado as (select  cc.id_gestion,
                                                   tcc.id_tipo_cc_techo,
                                                   tcc.codigo_techo,
                                                   tcc.control_partida,
                                                   tcc.descripcion_techo,
                                                   tcc.movimiento,
                                                   sum(pe.monto_mb) total_formulado
                                                 from pre.tpartida_ejecucion pe
                                                 inner join pre.tpresupuesto p on p.id_presupuesto = pe.id_presupuesto
                                                 inner join param.tcentro_costo cc on cc.id_centro_costo = p.id_centro_costo
                                                 inner join param.vtipo_cc_techo tcc on tcc.id_tipo_cc = cc.id_tipo_cc
                                                 where  pe.estado_reg = ''activo''
                                                       and pe.tipo_movimiento = ''formulado''
                                                  group by
                                                       cc.id_gestion,
                                                       tcc.id_tipo_cc_techo,
                                                       tcc.codigo_techo,
                                                       tcc.control_partida,
                                                       tcc.descripcion_techo,
                                                       tcc.movimiento),
                                            comprometido as (
                                                 select 
                                                       cc.id_gestion,
                                                       tcc.id_tipo_cc_techo,
                                                       tcc.codigo_techo,
                                                       tcc.control_partida,
                                                       tcc.descripcion_techo ,
                                                       tcc.movimiento,
                                                       sum(pe.monto_mb) as total_comprometido
                                                 from pre.tpartida_ejecucion pe
                                                 inner join pre.tpresupuesto p on p.id_presupuesto = pe.id_presupuesto
                                                 inner join param.tcentro_costo cc on cc.id_centro_costo = p.id_centro_costo
                                                 inner join param.vtipo_cc_techo tcc on tcc.id_tipo_cc = cc.id_tipo_cc
                                                 where  pe.estado_reg = ''activo''
                                                        and pe.tipo_movimiento = ''comprometido''
                                                  group by
                                                       cc.id_gestion,
                                                       tcc.id_tipo_cc_techo,
                                                       tcc.codigo_techo,
                                                       tcc.control_partida,
                                                       tcc.descripcion_techo,
                                                       tcc.movimiento) ,
                                                       
                                             ejecutado  as (
                                                 select 
                                                       cc.id_gestion,
                                                       tcc.id_tipo_cc_techo,
                                                       tcc.codigo_techo,
                                                       tcc.control_partida,
                                                       tcc.descripcion_techo ,
                                                       tcc.movimiento,
                                                       sum(pe.monto_mb) as total_ejecutado
                                                 from pre.tpartida_ejecucion pe
                                                 inner join pre.tpresupuesto p on p.id_presupuesto = pe.id_presupuesto
                                                 inner join param.tcentro_costo cc on cc.id_centro_costo = p.id_centro_costo
                                                 inner join param.vtipo_cc_techo tcc on tcc.id_tipo_cc = cc.id_tipo_cc
                                                 where  pe.estado_reg = ''activo''
                                                       and pe.tipo_movimiento = ''ejecutado''
                                                  group by
                                                       cc.id_gestion,
                                                       tcc.id_tipo_cc_techo,
                                                       tcc.codigo_techo,
                                                       tcc.control_partida,
                                                       tcc.descripcion_techo,
                                                       tcc.movimiento)
                                                       select  g.gestion,
                                                               form.codigo_techo,
                                                               form.control_partida,
                                                               form.descripcion_techo,
                                                               form.movimiento,
                                                               form.total_formulado,
                                                               com.total_comprometido,
                                                               (form.total_formulado - com.total_comprometido) saldo_por_comprometer,
                                                                eje.total_ejecutado,
                                                               (form.total_formulado - eje.total_ejecutado ) saldo_por_ejecutar
                                                            from   formulado form
                                                            inner join param.tgestion g on g.id_gestion =  form.id_gestion
                                                            left join comprometido com on com.id_tipo_cc_techo = form.id_tipo_cc_techo and form.id_gestion = com.id_gestion
                                                            left join ejecutado eje on eje.id_tipo_cc_techo = com.id_tipo_cc_techo and eje.id_gestion = com.id_gestion
                                                            where '||v_filtro;
      return v_consulta;
    end;     

    /*********************************
  #TRANSACCION:  'PRE_EJEPRO_SEL' #37
  #DESCRIPCION: Reporte de ejecucion de proyectos
  #AUTOR:   JUAN
  #FECHA:   31/03/2020
  ***********************************/

  elsif(p_transaccion='PRE_EJEPRO_SEL')then --#37

    begin

      --#45 consulta
      v_consulta:='with transaccion_proveedor as (
                    select DISTINCT  pep.id_int_comprobante,
                           pep.id_proveedor,
                           p.rotulo_comercial::varchar as proveedor
                    from pre.vpartida_ejecucion_proveedor pep
                    left join param.tproveedor p on p.id_proveedor = pep.id_proveedor ),
                    
                   ProyectoTransaccion as(
                   --#ETR-1599
                   select 
                    concat(te.codigo_techo,'' - '',te.descripcion_techo)::varchar as ceco_techo,
                    concat(te.codigo,'' - '',te.descripcion)::varchar as ceco,
                    concat(par.codigo, '' - '',par.nombre_partida)::varchar as partida,
                    concat(crr2.codigo, '' - '', crr2.descripcion)::varchar as clas_nivel_1,
                    concat(crr1.codigo, '' - '', crr1.descripcion)::varchar as clas_nivel_2,
                    concat(crr.codigo, '' - '', crr.descripcion)::varchar as clas_nivel_3,
                    pep.proveedor::varchar,
                    pep.tipo_costo::varchar,
                    pe.fecha::date,
                    pe.monto_mb::numeric,
                    pe.nro_tramite, 
                    cc.id_gestion,
                    te.id_tipo_cc_techo,
                    ''comprometido_proyectos''::varchar as origen
                    from pre.tpartida_ejecucion pe
                    inner join param.tcentro_costo cc on cc.id_centro_costo = pe.id_presupuesto
                    inner join param.ttipo_cc tcc on tcc.id_tipo_cc = cc.id_tipo_cc
                    inner join param.vtipo_cc_raiz ra on ra.id_tipo_cc = cc.id_tipo_cc
                    inner join param.vtipo_cc_techo te on te.id_tipo_cc = cc.id_tipo_cc
                    inner join pre.tpartida par on par.id_partida = pe.id_partida
                    inner join pre.tpresupuesto pres on pres.id_presupuesto = pe.id_presupuesto
                    left join pre.tpartida_reporte_ejecucion_dw pred on pred.id_partida = pe.id_partida and pred.id_tipo_presupuesto = pres.tipo_pres::integer
                    left join pre.tclasificacion_reporte_dw crr on crr.id_clasificacion_reporte_dw = pred.id_clasificacion_reporte_dw
                    left join pre.tclasificacion_reporte_dw crr1 on crr1.id_clasificacion_reporte_dw = crr.id_padre
                    left join pre.tclasificacion_reporte_dw crr2 on crr2.id_clasificacion_reporte_dw = crr1.id_padre
                    left join pre.vpartida_ejecucion_proveedor pep on pep.valor_id_origen = pe.valor_id_origen and pep.columna_origen = pe.columna_origen
                    where ra.ids::varchar like (''%{2568,1549%'')
                    and pe.tipo_movimiento in( ''comprometido'')
                   
                   union all
                   
                   select
                    concat(te.codigo_techo,'' - '',te.descripcion_techo)::varchar as ceco_techo,
                    concat(te.codigo,'' - '',te.descripcion)::varchar as ceco,
                    concat(par.codigo, '' - '',par.nombre_partida)::varchar as partida,
                    concat(crr2.codigo, '' - '', crr2.descripcion)::varchar as clas_nivel_1,
                    concat(crr1.codigo, '' - '', crr1.descripcion)::varchar as clas_nivel_2,
                    concat(crr.codigo, '' - '', crr.descripcion)::varchar as clas_nivel_3,
                    pep.proveedor::varchar,
                    pep.tipo_costo::varchar,
                    pe.fecha::date,
                    pe.monto_mb::numeric,
                    pe.nro_tramite, --#40
                    cc.id_gestion,
                    te.id_tipo_cc_techo,
                    ''ejecucion_proyectos''::varchar as origen
                    from pre.tpartida_ejecucion pe
                    inner join param.tcentro_costo cc on cc.id_centro_costo = pe.id_presupuesto
                    inner join param.ttipo_cc tcc on tcc.id_tipo_cc = cc.id_tipo_cc
                    inner join param.vtipo_cc_raiz ra on ra.id_tipo_cc = cc.id_tipo_cc
                    inner join param.vtipo_cc_techo te on te.id_tipo_cc = cc.id_tipo_cc
                    inner join pre.tpartida par on par.id_partida = pe.id_partida
                    inner join pre.tpresupuesto pres on pres.id_presupuesto = pe.id_presupuesto
                    left join pre.tpartida_reporte_ejecucion_dw pred on pred.id_partida = pe.id_partida and pred.id_tipo_presupuesto = pres.tipo_pres::integer
                    left join pre.tclasificacion_reporte_dw crr on crr.id_clasificacion_reporte_dw = pred.id_clasificacion_reporte_dw
                    left join pre.tclasificacion_reporte_dw crr1 on crr1.id_clasificacion_reporte_dw = crr.id_padre
                    left join pre.tclasificacion_reporte_dw crr2 on crr2.id_clasificacion_reporte_dw = crr1.id_padre
                    left join pre.vpartida_ejecucion_proveedor pep on pep.valor_id_origen = pe.valor_id_origen and pep.columna_origen = pe.columna_origen
                    where ra.ids::varchar like (''%{2568,1549%'')
                    and pe.tipo_movimiento = ''ejecutado'' 
                    
                    union all
                    

                    select 
                    concat(te.codigo_techo,'' - '',te.descripcion_techo)::varchar as ceco_techo,
                    concat(te.codigo,'' - '',te.descripcion)::varchar as ceco,
                    concat(par.codigo, '' - '',par.nombre_partida)::varchar as partida,
                    concat(crr2.codigo, '' - '', crr2.descripcion)::varchar as clas_nivel_1,
                    concat(crr1.codigo, '' - '', crr1.descripcion)::varchar as clas_nivel_2,
                    concat(crr.codigo, '' - '', crr.descripcion)::varchar as clas_nivel_3,
                    pep.proveedor::varchar,
                    ''''::varchar as tipo_costo, 
                    cbte.fecha::date, 
                    sum (trans.importe_debe_mb - trans.importe_haber_mb) as monto_mb,
                    trans.nro_tramite, 
                    cc.id_gestion,
                    te.id_tipo_cc_techo,
                    ''ejecucion_proyectos_con_iva'' as origen
                    from conta.tint_transaccion trans
                    inner join conta.tint_comprobante cbte on cbte.id_int_comprobante = trans.id_int_comprobante
                    inner join conta.tcuenta cta on cta.id_cuenta = trans.id_cuenta
                    inner join pre.tpartida par on par.id_partida = trans.id_partida
                    inner join param.tcentro_costo cc on cc.id_centro_costo = trans.id_centro_costo
                    inner join param.ttipo_cc tcc on tcc.id_tipo_cc = cc.id_tipo_cc
                    inner join param.vtipo_cc_raiz ra on ra.id_tipo_cc = cc.id_tipo_cc
                    inner join param.vtipo_cc_techo te on te.id_tipo_cc = cc.id_tipo_cc
                    inner join pre.tpresupuesto p on p.id_presupuesto = trans.id_centro_costo
                    left join transaccion_proveedor pep on pep.id_int_comprobante= cbte.id_int_comprobante
                    left join pre.tpartida_reporte_ejecucion_dw pred on pred.id_partida = par.id_partida and pred.id_tipo_presupuesto = p.tipo_pres::integer
                    left join pre.tclasificacion_reporte_dw crr on crr.id_clasificacion_reporte_dw = pred.id_clasificacion_reporte_dw
                    left join pre.tclasificacion_reporte_dw crr1 on crr1.id_clasificacion_reporte_dw = crr.id_padre
                    left join pre.tclasificacion_reporte_dw crr2 on crr2.id_clasificacion_reporte_dw = crr1.id_padre                 

                    group by 
                    te.codigo_techo,
                    te.descripcion_techo,
                    te.codigo,
                    te.descripcion,
                    crr2.codigo,
                    crr2.descripcion,
                    crr1.codigo,
                    crr1.descripcion,
                    crr.codigo,
                    crr.descripcion,
                    trans.nro_tramite,
                    cc.id_gestion,

                    par.codigo,
                    par.nombre_partida,
                    cbte.fecha,
                    cbte.estado_reg,
                    cta.nro_cuenta,
                    pep.proveedor,
                    te.id_tipo_cc_techo
                    having cbte.estado_reg=''validado''
                    AND cta.nro_cuenta like (''1.1.3.04%'') 


                    
                    
                    )  
                    select 
                    pt.ceco_techo::varchar,
                    pt.ceco::varchar,
                    pt.partida::varchar,
                    pt.clas_nivel_1::varchar,
                    pt.clas_nivel_2::varchar,
                    pt.clas_nivel_3::varchar,
                    pt.proveedor::varchar,
                    pt.tipo_costo::varchar,
                    pt.fecha::date,
                    pt.monto_mb::numeric,
                    pt.nro_tramite::varchar,
                    origen::varchar
                    
                    from ProyectoTransaccion pt
                    where  ';

    v_consulta:=v_consulta||v_parametros.filtro;
--raise notice 'notice %',v_parametros.filtro; raise exception 'error %',v_parametros.filtro;
      return v_consulta;
    end;
    /*********************************
  #TRANSACCION:  'PRE_PARCEN_SEL' #46
  #DESCRIPCION: Reporte de ejecucion de proyectos
  #AUTOR:   JUAN
  #FECHA:   31/03/2020
  ***********************************/

  elsif(p_transaccion='PRE_PARCEN_SEL')then 

    begin

      --#45 consulta
      v_consulta:='with RECURSIVE partida as(
                    select 
                    par.id_partida,
                    par.id_partida_fk,
                    (par.codigo||'' ''||par.nombre_partida)::varchar as parida,
                    (par.id_partida)::text as orden,
                    par.id_gestion,
                    ''*  ''::VARCHAR as nivel
                    from pre.tpartida par
                    where par.id_partida_fk is NULL and par.estado_reg=''activo'' 
                    UNION ALL
                    select
                    par.id_partida,
                    par.id_partida_fk,
                    (par.codigo||'' ''||par.nombre_partida)::varchar as parida,
                    (par1.orden||'' -> ''||par.id_partida)::text as orden,
                    par.id_gestion,
                    (par1.nivel||''*    '')::text as nivel
                    from pre.tpartida par
                    join partida par1 on par1.id_partida=par.id_partida_fk
                    where par.id_partida_fk is not NULL and par.estado_reg=''activo''
                    ),
                    partida_ejecucion as(
                      select 
                      (replace(par.nivel,''*'','' '')||par.parida)::varchar as partida,
                      (tcc.codigo||'' ''||tcc.descripcion)::varchar as ceco,
                      length(replace(par.nivel,'' '',''''))::integer as nivel,
                      case when pe.tipo_movimiento=''ejecutado''then sum(pe.monto_mb) end as ejecutado,
                      case when pe.tipo_movimiento=''comprometido''then sum(pe.monto_mb) end as comprometido,
                      case when pe.tipo_movimiento=''formulado''then sum(pe.monto_mb) end as formulado,
                      par.orden,
                      pe.nro_tramite,
                      par.id_gestion,
                      pe.tipo_ajuste_formulacion
                      ,prov.rotulo_comercial as proveedor,
                      cc.id_centro_costo --#PRES-5
                      from partida par
                      left join pre.tpartida_ejecucion pe on pe.id_partida=par.id_partida  and pe.monto::numeric <> 0::numeric

                      left join pre.tpresupuesto pre on pre.id_presupuesto=pe.id_presupuesto
                      left join param.tcentro_costo cc on cc.id_centro_costo = pre.id_presupuesto
                      left join param.ttipo_cc tcc on tcc.id_tipo_cc=cc.id_tipo_cc  

                      left join pre.vpartida_ejecucion_proveedor pep on pep.valor_id_origen = pe.valor_id_origen and pep.columna_origen = pe.columna_origen
                      left join param.tproveedor prov on prov.id_proveedor = pep.id_proveedor

                      GROUP BY par.nivel,par.parida,par.orden
                      ,pe.tipo_movimiento
                      ,tcc.codigo,tcc.descripcion,pe.nro_tramite,par.id_gestion,pe.tipo_ajuste_formulacion
                      ,prov.rotulo_comercial
                      ,cc.id_centro_costo --#PRES-5
                      order by orden asc
                    )
                    select
                    case when pe.nivel = 1 then pe.partida  end as partida_1, --#PRES-5
                    case when pe.nivel = 2 then pe.partida  end as partida_2, --#PRES-5
                    case when pe.nivel = 3 then pe.partida  end as partida_3, --#PRES-5
                    case when pe.nivel = 4 then pe.partida  end as partida_4, --#PRES-5
                    
                    pe.ceco::varchar,
                    pe.nivel::integer,
                    (case when pe.nro_tramite like ''%FP%'' OR  pe.tipo_ajuste_formulacion = ''Formulación'' then
                    pe.formulado end)::numeric as formulado,
                    (case when pe.tipo_ajuste_formulacion = ''Reformulación'' then
                    pe.formulado end)::numeric as reformulado,
                    (case when pe.tipo_ajuste_formulacion = ''Ajuste'' then
                    pe.formulado end)::numeric  as ajuste,
                    pe.formulado::numeric as vigente,
                    pe.comprometido::numeric,
                    pe.ejecutado::numeric,
                    (pe.comprometido/pe.formulado)::numeric as desviacion_comprometido,
                    (pe.ejecutado/pe.formulado)::numeric as desviacion_ejecutado,
                    pe.proveedor::varchar,
                    pe.nro_tramite::varchar
                    from partida_ejecucion pe
                     WHERE  ';

    v_consulta:=v_consulta||v_parametros.filtro;
        
      return v_consulta;
    end;  
    /*********************************
  #TRANSACCION:  'PRE_AJUIMPPART_SEL' #46
  #DESCRIPCION: Reporte detalle de ajuste de imputacion
  #AUTOR:   JUAN
  #FECHA:   31/03/2020
  ***********************************/

  elsif(p_transaccion='PRE_AJUIMPPART_SEL')then 

    begin

       v_filtro_tipo_cc = ' 0 = 0 and ';
       IF  pxp.f_existe_parametro(p_tabla,'id_tipo_cc')  THEN
                   
                IF v_parametros.id_tipo_cc is not NULL THEN
                      
                    WITH RECURSIVE tipo_cc_rec (id_tipo_cc, id_tipo_cc_fk) AS (
                      SELECT tcc.id_tipo_cc, tcc.id_tipo_cc_fk
                      FROM param.ttipo_cc tcc
                      WHERE tcc.id_tipo_cc = v_parametros.id_tipo_cc and tcc.estado_reg = 'activo'
                    UNION ALL
                      SELECT tcc2.id_tipo_cc, tcc2.id_tipo_cc_fk
                      FROM tipo_cc_rec lrec 
                      INNER JOIN param.ttipo_cc tcc2 ON lrec.id_tipo_cc = tcc2.id_tipo_cc_fk
                      where tcc2.estado_reg = 'activo'
                    )
                  SELECT  pxp.list(id_tipo_cc::varchar) 
                    into 
                      v_tipo_cc
                  FROM tipo_cc_rec;
                          
                          
                  --se agrego el alias vpe al tipo cc #138
                  v_filtro_tipo_cc = ' p.id_tipo_cc in ('||v_tipo_cc||') and ';
              END IF;
       END IF;
       
      
      IF   COALESCE(v_parametros.id_gestion,0)=0  THEN
          v_parametros.id_gestion=0;
      end if;
        
      v_consulta:='';
         
      v_consulta:='with RECURSIVE partida as(
                    select 
                    par.id_partida,
                    par.id_partida_fk,
                    (par.codigo||'' ''||par.nombre_partida)::varchar as partida,
                    (par.id_partida)::text as orden,
                    par.id_gestion,
                    ''*  ''::VARCHAR as nivel
                    from pre.tpartida par
                    where par.id_partida_fk is NULL and par.estado_reg=''activo'' 
                    UNION ALL
                    select
                    par.id_partida,
                    par.id_partida_fk,
                    (par.codigo||'' ''||par.nombre_partida)::varchar as parida,
                    (par1.orden||'' -> ''||par.id_partida)::text as orden,
                    par.id_gestion,
                    (par1.nivel||''*    '')::text as nivel
                    from pre.tpartida par
                    join partida par1 on par1.id_partida=par.id_partida_fk
                    where par.id_partida_fk is not NULL and par.estado_reg=''activo''
                    ),
                    partida2 as(
                    select 
                    p.id_partida,
                    (replace(p.nivel,''*'','' '')||p.partida)::varchar as partida,
                    length(replace(p.nivel,'' '',''''))::integer as nivel,
                    (case when pe.tipo_movimiento = ''formulado'' then sum(pe.monto_mb) end)::numeric as formulado,
                    (case when pe.tipo_movimiento = ''comprometido'' then sum(pe.monto_mb) end)::numeric as comprometido,
                    (case when pe.tipo_movimiento = ''ejecutado'' then sum(pe.monto_mb) end)::numeric as ejecutado,
                    p.id_gestion,
                    p.orden,
                    (tcc.codigo||'' ''||tcc.descripcion)::varchar as ceco,
                    tcc.id_tipo_cc
                    from partida p
                    left join pre.tpartida_ejecucion pe on pe.id_partida=p.id_partida   
                      
                    left join pre.tpresupuesto pre on pre.id_presupuesto=pe.id_presupuesto
                    left join param.tcentro_costo cc on cc.id_centro_costo = pre.id_presupuesto
                    left join param.ttipo_cc tcc on tcc.id_tipo_cc=cc.id_tipo_cc  
                                                  
                    group by p.id_partida,p.nivel,p.partida,pe.tipo_movimiento,p.orden,p.id_gestion
                    ,tcc.codigo,tcc.descripcion,tcc.id_tipo_cc
                    order by p.orden asc )
                      
                    select
                    p.id_partida::integer,
                    p.partida::varchar,
                    p.nivel::integer,
                    '''||COALESCE(v_tipo_cc,'''')||'''::varchar as filtro_tipo_cc, --#ETR-1823
                    '||v_parametros.id_gestion||'::integer as id_gestion, --#ETR-1823
                    sum(p.formulado)::numeric as formulado ,
                    sum(p.comprometido)::numeric as comprometido,
                    (sum(p.formulado)-sum(p.comprometido))::numeric  as por_comprometer,
                    sum(p.ejecutado)::numeric as ejecutado,
                    (sum(p.comprometido)-sum(p.ejecutado))::numeric as por_ejecutar
                    from partida2 p
                    where  '||v_filtro_tipo_cc||'  p.id_gestion= '||v_parametros.id_gestion||' and ';
       
      v_consulta:=v_consulta||v_parametros.filtro;
      v_consulta:=v_consulta||' group by  p.id_partida,p.partida,p.nivel,p.orden ';
                    
      v_consulta:=v_consulta||' order by  p.orden asc  limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;


      return v_consulta;
    end;     
    /*********************************
  #TRANSACCION:  'PRE_AIMPPARTDET_SEL' #ETR-1823
  #DESCRIPCION: Reporte detalle de ajuste de imputacion
  #AUTOR:   JUAN
  #FECHA:   31/03/2020
  ***********************************/

  elsif(p_transaccion='PRE_AIMPPARTDET_SEL')then 

    begin

      v_filtro_tipo_cc = ' 0 = 0 and ';

      v_consulta:='';
         
      v_consulta:=' with RECURSIVE partida as(
  select
    par.id_partida,
    par.id_partida_fk,
    (par.codigo||'' ''||par.nombre_partida)::varchar as partida,
    (par.id_partida)::text as orden,
    par.id_gestion,
    ''*  ''::VARCHAR as nivel
  from pre.tpartida par
  where par.id_partida_fk is NULL and par.estado_reg=''activo''
  UNION ALL
  select
    par.id_partida,
    par.id_partida_fk,
    (par.codigo||'' ''||par.nombre_partida)::varchar as parida,
    (par1.orden||'' -> ''||par.id_partida)::text as orden,
    par.id_gestion,
    (par1.nivel||''*    '')::text as nivel
  from pre.tpartida par
         join partida par1 on par1.id_partida=par.id_partida_fk
  where par.id_partida_fk is not NULL and par.estado_reg=''activo''
),
     partida2 as(
       select
         p.id_partida,
         (replace(p.nivel,''*'','' '')||p.partida)::varchar as partida,
         length(replace(p.nivel,'' '',''''))::integer as nivel,
         (case when pe.tipo_movimiento = ''formulado'' then sum(pe.monto_mb) end)::numeric as formulado,
         (case when pe.tipo_movimiento = ''comprometido'' then sum(pe.monto_mb) end)::numeric as comprometido,
         (case when pe.tipo_movimiento = ''ejecutado'' then sum(pe.monto_mb) end)::numeric as ejecutado,
         p.id_gestion,
         p.orden,
         (tcc.codigo||'' ''||tcc.descripcion)::varchar as ceco,
         tcc.id_tipo_cc,
         pe.nro_tramite
       from partida p
              left join pre.tpartida_ejecucion pe on pe.id_partida=p.id_partida

              left join pre.tpresupuesto pre on pre.id_presupuesto=pe.id_presupuesto
              left join param.tcentro_costo cc on cc.id_centro_costo = pre.id_presupuesto
              left join param.ttipo_cc tcc on tcc.id_tipo_cc=cc.id_tipo_cc

       group by p.id_partida,p.nivel,p.partida,pe.tipo_movimiento,p.orden,p.id_gestion
              ,tcc.codigo,tcc.descripcion,tcc.id_tipo_cc,pe.nro_tramite
       order by p.orden asc )

select
  p.id_partida::integer,
  p.partida::varchar,
  p.nivel::integer,
  p.nro_tramite::varchar,
  sum(p.formulado)::numeric as formulado ,
  sum(p.comprometido)::numeric as comprometido,
  (sum(p.formulado)-sum(p.comprometido))::numeric  as por_comprometer,
  sum(p.ejecutado)::numeric as ejecutado,
  (sum(p.comprometido)-sum(p.ejecutado))::numeric as por_ejecutar
from partida2 p

where  0 = 0 and   p.id_gestion= '||v_parametros.id_gestion||' and  p.id_partida= '||v_parametros.id_partida||' and  0 = 0  and p.id_tipo_cc in ('||v_parametros.filtro_tipo_cc||')
 and ';
       
      v_consulta:=v_consulta||v_parametros.filtro;
      v_consulta:=v_consulta||'group by  p.id_partida,p.partida,p.nivel,p.orden,p.nro_tramite ';
                    
      v_consulta:=v_consulta||' order by  p.orden asc  limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

raise notice 'notice % ',v_consulta;
      return v_consulta;
    end;     
    /*********************************
  #TRANSACCION:  'PRE_AIMPPARTDET_CONT' #ETR-1823
  #DESCRIPCION: Reporte detalle de ajuste de imputacion
  #AUTOR:   JUAN
  #FECHA:   31/03/2020
  ***********************************/

  elsif(p_transaccion='PRE_AIMPPARTDET_CONT')then 

    begin

      v_filtro_tipo_cc = ' 0 = 0 and ';

      v_consulta:='';
         
      v_consulta:='with RECURSIVE partida as(
  select
    par.id_partida,
    par.id_partida_fk,
    (par.codigo||'' ''||par.nombre_partida)::varchar as partida,
    (par.id_partida)::text as orden,
    par.id_gestion,
    ''*  ''::VARCHAR as nivel
  from pre.tpartida par
  where par.id_partida_fk is NULL and par.estado_reg=''activo''
  UNION ALL
  select
    par.id_partida,
    par.id_partida_fk,
    (par.codigo||'' ''||par.nombre_partida)::varchar as parida,
    (par1.orden||'' -> ''||par.id_partida)::text as orden,
    par.id_gestion,
    (par1.nivel||''*    '')::text as nivel
  from pre.tpartida par
         join partida par1 on par1.id_partida=par.id_partida_fk
  where par.id_partida_fk is not NULL and par.estado_reg=''activo''
),
     partida2 as(
       select
         p.id_partida,
         (replace(p.nivel,''*'','' '')||p.partida)::varchar as partida,
         length(replace(p.nivel,'' '',''''))::integer as nivel,
         (case when pe.tipo_movimiento = ''formulado'' then sum(pe.monto_mb) end)::numeric as formulado,
         (case when pe.tipo_movimiento = ''comprometido'' then sum(pe.monto_mb) end)::numeric as comprometido,
         (case when pe.tipo_movimiento = ''ejecutado'' then sum(pe.monto_mb) end)::numeric as ejecutado,
         p.id_gestion,
         p.orden,
         (tcc.codigo||'' ''||tcc.descripcion)::varchar as ceco,
         tcc.id_tipo_cc,
         pe.nro_tramite
       from partida p
              left join pre.tpartida_ejecucion pe on pe.id_partida=p.id_partida

              left join pre.tpresupuesto pre on pre.id_presupuesto=pe.id_presupuesto
              left join param.tcentro_costo cc on cc.id_centro_costo = pre.id_presupuesto
              left join param.ttipo_cc tcc on tcc.id_tipo_cc=cc.id_tipo_cc

       group by p.id_partida,p.nivel,p.partida,pe.tipo_movimiento,p.orden,p.id_gestion
              ,tcc.codigo,tcc.descripcion,tcc.id_tipo_cc,pe.nro_tramite
       order by p.orden asc ),
       
  partida3 as(
  select
  p.id_partida::integer,
  p.partida::varchar,
  p.nivel::integer,
  p.nro_tramite::varchar,
  sum(p.formulado)::numeric as formulado ,
  sum(p.comprometido)::numeric as comprometido,
  (sum(p.formulado)-sum(p.comprometido))::numeric  as por_comprometer,
  sum(p.ejecutado)::numeric as ejecutado,
  (sum(p.comprometido)-sum(p.ejecutado))::numeric as por_ejecutar,
  p.id_gestion,
  p.id_tipo_cc
from partida2 p
group by  p.id_partida,p.partida,p.nivel,p.orden,p.nro_tramite  ,p.id_gestion,p.id_tipo_cc
)
select 
count(*)
from partida3 p
where  0 = 0 and   p.id_gestion= '||v_parametros.id_gestion||' and  p.id_partida= '||v_parametros.id_partida||' and  0 = 0  and p.id_tipo_cc in ('||v_parametros.filtro_tipo_cc||')
                     and ';
       
      v_consulta:=v_consulta||v_parametros.filtro;
    
      return v_consulta;
    end; 
    /*********************************
  #TRANSACCION:  'PRE_AJUIMPPART_CONT' #46
  #DESCRIPCION: Reporte detalle de ajuste de imputacion
  #AUTOR:   JUAN
  #FECHA:   31/03/2020
  ***********************************/

  elsif(p_transaccion='PRE_AJUIMPPART_CONT')then 

    begin

     v_filtro_tipo_cc = ' 0 = 0 and ';

     IF  pxp.f_existe_parametro(p_tabla,'id_tipo_cc')  THEN
                 
              IF v_parametros.id_tipo_cc is not NULL THEN
                    
                  WITH RECURSIVE tipo_cc_rec (id_tipo_cc, id_tipo_cc_fk) AS (
                    SELECT tcc.id_tipo_cc, tcc.id_tipo_cc_fk
                    FROM param.ttipo_cc tcc
                    WHERE tcc.id_tipo_cc = v_parametros.id_tipo_cc and tcc.estado_reg = 'activo'
                  UNION ALL
                    SELECT tcc2.id_tipo_cc, tcc2.id_tipo_cc_fk
                    FROM tipo_cc_rec lrec 
                    INNER JOIN param.ttipo_cc tcc2 ON lrec.id_tipo_cc = tcc2.id_tipo_cc_fk
                    where tcc2.estado_reg = 'activo'
                  )
                SELECT  pxp.list(id_tipo_cc::varchar) 
                  into 
                    v_tipo_cc
                FROM tipo_cc_rec;
                        
                        
                --se agrego el alias vpe al tipo cc #138
                v_filtro_tipo_cc = ' p.id_tipo_cc in ('||v_tipo_cc||') and ';
            END IF;
     END IF;
      
      IF   COALESCE(v_parametros.id_gestion,0)=0  THEN
          v_parametros.id_gestion=0;
      end if;  
      v_consulta:='with RECURSIVE partida as(
                    select 
                    par.id_partida,
                    par.id_partida_fk,
                    (par.codigo||'' ''||par.nombre_partida)::varchar as partida,
                    (par.id_partida)::text as orden,
                    par.id_gestion,
                    ''*  ''::VARCHAR as nivel
                    from pre.tpartida par
                    where par.id_partida_fk is NULL and par.estado_reg=''activo'' 
                    UNION ALL
                    select
                    par.id_partida,
                    par.id_partida_fk,
                    (par.codigo||'' ''||par.nombre_partida)::varchar as parida,
                    (par1.orden||'' -> ''||par.id_partida)::text as orden,
                    par.id_gestion,
                    (par1.nivel||''*    '')::text as nivel
                    from pre.tpartida par
                    join partida par1 on par1.id_partida=par.id_partida_fk
                    where par.id_partida_fk is not NULL and par.estado_reg=''activo''
                    ),
                    partida2 as(
                    select 
                    p.id_partida,
                    (replace(p.nivel,''*'','' '')||p.partida)::varchar as partida,
                    (case when pe.tipo_movimiento = ''formulado'' then sum(pe.monto_mb) end)::numeric as formulado,
                    (case when pe.tipo_movimiento = ''comprometido'' then sum(pe.monto_mb) end)::numeric as comprometido,
                    (case when pe.tipo_movimiento = ''ejecutado'' then sum(pe.monto_mb) end)::numeric as ejecutado,
                    p.id_gestion,
                    p.orden,
                    p.nivel,
                    tcc.id_tipo_cc
                    from partida p
                    left join pre.tpartida_ejecucion pe on pe.id_partida=p.id_partida   
                      
                    left join pre.tpresupuesto pre on pre.id_presupuesto=pe.id_presupuesto
                    left join param.tcentro_costo cc on cc.id_centro_costo = pre.id_presupuesto
                    left join param.ttipo_cc tcc on tcc.id_tipo_cc=cc.id_tipo_cc  
                                                  
                    group by p.id_partida,p.partida,pe.tipo_movimiento,p.orden,p.id_gestion,
                    tcc.id_tipo_cc,p.nivel
                    order by p.orden asc )
                      
                    select
                    count(*)
                    from partida2 p
                    where  '||v_filtro_tipo_cc||'  p.id_gestion= '||v_parametros.id_gestion||' and ';

      v_consulta:=v_consulta||v_parametros.filtro;
      v_consulta:=v_consulta||' group by  p.id_partida,p.partida,p.orden  ';
                    
        
      return v_consulta;
    end;  

    /*********************************
 
  #TRANSACCION:  'PRE_STPARCEN_SEL' #PRES-5
  #DESCRIPCION: Reporte partida centro de coso
  #AUTOR:   JUAN
  #FECHA:   31/03/2020
  ***********************************/

  elsif(p_transaccion='PRE_STPARCEN_SEL')then 

    begin

      --#45 consulta
      v_consulta:='with RECURSIVE partida as(
                    select 
                    par.id_partida,
                    par.id_partida_fk,
                    (par.codigo||'' ''||par.nombre_partida)::varchar as parida,
                    (par.id_partida)::text as orden,
                    par.id_gestion,
                    ''*  ''::VARCHAR as nivel
                    from pre.tpartida par
                    where par.id_partida_fk is NULL and par.estado_reg=''activo'' 
                    UNION ALL
                    select
                    par.id_partida,
                    par.id_partida_fk,
                    (par.codigo||'' ''||par.nombre_partida)::varchar as parida,
                    (par1.orden||'' -> ''||par.id_partida)::text as orden,
                    par.id_gestion,
                    (par1.nivel||''*    '')::text as nivel
                    from pre.tpartida par
                    join partida par1 on par1.id_partida=par.id_partida_fk
                    where par.id_partida_fk is not NULL and par.estado_reg=''activo''
                    ),
                    partida_ejecucion as(
                      select 
                      (replace(par.nivel,''*'','' '')||par.parida)::varchar as partida,
                      (tcc.codigo||'' ''||tcc.descripcion)::varchar as ceco,
                      length(replace(par.nivel,'' '',''''))::integer as nivel,
                      case when pe.tipo_movimiento=''ejecutado''then sum(pe.monto_mb) end as ejecutado,
                      case when pe.tipo_movimiento=''comprometido''then sum(pe.monto_mb) end as comprometido,
                      case when pe.tipo_movimiento=''formulado''then sum(pe.monto_mb) end as formulado,
                      par.orden,
                      pe.nro_tramite,
                      par.id_gestion,
                      pe.tipo_ajuste_formulacion
                      ,prov.rotulo_comercial as proveedor,
                      cc.id_centro_costo --#PRES-5
                      from partida par
                      left join pre.tpartida_ejecucion pe on pe.id_partida=par.id_partida  and pe.monto::numeric <> 0::numeric

                      left join pre.tpresupuesto pre on pre.id_presupuesto=pe.id_presupuesto
                      left join param.tcentro_costo cc on cc.id_centro_costo = pre.id_presupuesto
                      left join param.ttipo_cc tcc on tcc.id_tipo_cc=cc.id_tipo_cc  

                      left join pre.vpartida_ejecucion_proveedor pep on pep.valor_id_origen = pe.valor_id_origen and pep.columna_origen = pe.columna_origen
                      left join param.tproveedor prov on prov.id_proveedor = pep.id_proveedor

                      GROUP BY par.nivel,par.parida,par.orden
                      ,pe.tipo_movimiento
                      ,tcc.codigo,tcc.descripcion,pe.nro_tramite,par.id_gestion,pe.tipo_ajuste_formulacion
                      ,prov.rotulo_comercial
                      ,cc.id_centro_costo --#PRES-5
                      order by orden asc
                    ),
                    partida_ejecucion2 as (
                    select
                    case when pe.nivel = 1 then pe.partida  end as partida_1, --#PRES-5
                    case when pe.nivel = 2 then pe.partida  end as partida_2, --#PRES-5
                    case when pe.nivel = 3 then pe.partida  end as partida_3, --#PRES-5
                    case when pe.nivel = 4 then pe.partida  end as partida_4, --#PRES-5
                    
                    pe.ceco::varchar,
                    pe.nivel::integer,
                    
                    (case when pe.nro_tramite like ''%FP%'' OR  pe.tipo_ajuste_formulacion = ''Formulación'' then
                    pe.formulado end)::numeric as formulado,
                    
                    (case when pe.tipo_ajuste_formulacion = ''Reformulación'' then
                    pe.formulado end)::numeric as reformulado,
                    
                    (case when pe.tipo_ajuste_formulacion = ''Ajuste'' then
                    pe.formulado end)::numeric  as ajuste,
                    
                    pe.formulado::numeric as vigente,
                    
                    pe.comprometido::numeric,
                    
                    pe.ejecutado::numeric,
                    
                    (pe.comprometido/pe.formulado)::numeric as desviacion_comprometido,
                    
                    (pe.ejecutado/pe.formulado)::numeric as desviacion_ejecutado,
                    
                    pe.proveedor::varchar,
                    pe.nro_tramite::varchar,
                    pe.id_gestion,
                    pe.id_centro_costo,
                    pe.orden
                    from partida_ejecucion pe
                    )
                    
                    select 
                    partida_1::varchar,
                    partida_2::varchar,
                    partida_3::varchar,
                    partida_4::varchar,
                    pe.ceco::varchar,
                    pe.nivel::integer,
                    sum(pe.formulado)::numeric as formulado,
                    sum(pe.reformulado)::numeric as reformulado,
                    sum(pe.ajuste)::numeric as ajuste,
                    sum(pe.vigente)::numeric as vigente,
                    sum(pe.comprometido)::numeric as comprometido,
                    sum(pe.ejecutado)::numeric as ejecutado,
                    sum(pe.desviacion_comprometido)::numeric as desviacion_comprometido,
                    sum(pe.desviacion_ejecutado)::numeric as desviacion_ejecutado,
                    pe.proveedor::varchar
                     
                    from partida_ejecucion2 pe
                    WHERE   ';

    v_consulta:=v_consulta||v_parametros.filtro;
        v_consulta:=v_consulta||' GROUP BY 
                    partida_1,
                    partida_2,
                    partida_3,
                    partida_4,
                    pe.ceco,
                    pe.nivel,
                    pe.proveedor,
                    pe.orden 
                    order by pe.orden asc ';
        
      return v_consulta;
    end;  
    /*********************************
  #TRANSACCION:  'PRE_CETECHO_SEL' 
  #DESCRIPCION: Reporte de ejecucion de proyectos
  #AUTOR:   JUAN
  #FECHA:   26/07/2020
  ***********************************/

  elsif(p_transaccion='PRE_CETECHO_SEL')then --#45

    begin

      v_consulta:='with ceco_techo as(
                    select 
                    DISTINCT
                    te.id_tipo_cc_techo, 
                    concat(te.codigo_techo,'' - '',te.descripcion_techo)::varchar as ceco_techo
                    from  param.vtipo_cc_techo te
                    join param.vtipo_cc_raiz ra on ra.id_tipo_cc=te.id_tipo_cc 
                    where ra.ids::varchar like (''%{2568,1549%'')
                    )
                    select ct.id_tipo_cc_techo,ct.ceco_techo from ceco_techo ct
                    where ';

      v_consulta:=v_consulta||v_parametros.filtro;           
      v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

      return v_consulta;
      
    end;
    /*********************************
  #TRANSACCION:  'PRE_CETECHO_CONT' 
  #DESCRIPCION: Reporte de ejecucion de proyectos
  #AUTOR:   JUAN
  #FECHA:   26/07/2020
  ***********************************/

  elsif(p_transaccion='PRE_CETECHO_CONT')then --#45

    begin
                    
      v_consulta:='with ceco_techo as(
                    select 
                    DISTINCT
                    te.id_tipo_cc_techo, 
                    concat(te.codigo_techo,'' - '',te.descripcion_techo)::varchar as ceco_techo
                    from  param.vtipo_cc_techo te
                    join param.vtipo_cc_raiz ra on ra.id_tipo_cc=te.id_tipo_cc 
                    where ra.ids::varchar like (''%{2568,1549%'')
                    )    
                    select 
                    count(ct.id_tipo_cc_techo) 
                    from ceco_techo  ct         
                    where '; 

      v_consulta:=v_consulta||v_parametros.filtro;    
  
      return v_consulta;
      
    end;

    /*********************************
  #TRANSACCION:  'PRE_RFORPRESUP_SEL' 
  #DESCRIPCION: Reporte formulacion presupuestaria
  #AUTOR:   JUAN
  #FECHA:   28/09/2020
  ***********************************/

  elsif(p_transaccion='PRE_RFORPRESUP_SEL')then --#PRES-6 

    begin
    
     v_filtro_tipo_cc = ' 0=0 and ';
     IF v_parametros.id_tipo_cc is not NULL THEN
          WITH RECURSIVE tipo_cc_rec (id_tipo_cc, id_tipo_cc_fk) AS (
            SELECT tcc.id_tipo_cc, tcc.id_tipo_cc_fk
            FROM param.ttipo_cc tcc
            WHERE tcc.id_tipo_cc = v_parametros.id_tipo_cc and tcc.estado_reg = 'activo'
          UNION ALL
            SELECT tcc2.id_tipo_cc, tcc2.id_tipo_cc_fk
            FROM tipo_cc_rec lrec 
            INNER JOIN param.ttipo_cc tcc2 ON lrec.id_tipo_cc = tcc2.id_tipo_cc_fk
            where tcc2.estado_reg = 'activo'
          )
        SELECT  pxp.list(id_tipo_cc::varchar) 
          into 
            v_tipo_cc
        FROM tipo_cc_rec;
        
        v_filtro_tipo_cc = ' f.id_tipo_cc in ('||v_tipo_cc||')  and ';        
     END IF;
     
      v_consulta:=' with formulacion as(
                    select 
                    
                    case when tcc.control_techo=''si'' then tcc.id_tipo_cc else te.id_tipo_cc_techo end as id_tipo_cc_techo,
                    per.periodo,
                    par.tipo,
                    case when tcc.control_techo=''si'' then tcc.codigo||'' - ''||tcc.descripcion else te.codigo_techo||'' - ''||te.descripcion_techo end as ceco_techo,
                    sum(mcd.importe)::NUMERIC as importe,
                    pres.estado as estado_presupuesto,
                    ''Formulación'' as tipo_formulacion,
                    '''' as estado_ajuste,
                    g.gestion,
                    ''memoria de calculo''::varchar as origen,
                    g.id_gestion,
                    tcc.id_tipo_cc
                    from pre.tmemoria_calculo mc
                    join pre.tmemoria_det mcd on mcd.id_memoria_calculo=mc.id_memoria_calculo 
                    join pre.tpartida par on par.id_partida=mc.id_partida
                    join pre.tpresupuesto pres on pres.id_presupuesto=mc.id_presupuesto
                    join param.tcentro_costo cc on cc.id_centro_costo=pres.id_presupuesto
                    join param.ttipo_cc tcc on tcc.id_tipo_cc=cc.id_tipo_cc
                    join param.vtipo_cc_raiz ra on ra.id_tipo_cc=tcc.id_tipo_cc
                    join param.vtipo_cc_techo te on te.id_tipo_cc=tcc.id_tipo_cc
                    join param.tgestion g on g.id_gestion = cc.id_gestion
                    join param.tperiodo per on per.id_periodo=mcd.id_periodo
                    where mcd.importe != 0
                    group by 
                    per.periodo,
                    par.tipo,
                    tcc.control_techo,
                    tcc.id_tipo_cc,
                    te.id_tipo_cc_techo,
                    te.codigo_techo,
                    te.descripcion_techo,
                    pres.estado,
                    g.gestion,
                    g.id_gestion

                    union all

                    select 
                    case when tcc.control_techo=''si'' then tcc.id_tipo_cc else te.id_tipo_cc_techo end as id_tipo_cc_techo,
                    per.periodo,
                    par.tipo,
                    case when tcc.control_techo=''si'' then tcc.codigo||'' - ''||tcc.descripcion else te.codigo_techo||'' - ''||te.descripcion_techo end as ceco_techo,
                    sum(ajd.importe)::NUMERIC as importe,
                    pres.estado as estado_presupuesto,
                    case when aj.tipo_ajuste=''incremento'' or aj.tipo_ajuste=''decremento'' then  aj.tipo_ajuste_formulacion 
                        when aj.tipo_ajuste=''reformulacion'' then ''reformulacion''
                        when aj.tipo_ajuste=''traspaso'' then ''traspaso'' else '''' end as tipo_formulacion,
                    aj.estado as  estado_ajuste,
                    g.gestion,
                    ''Ajuste presupuestario''::varchar as origen,
                    g.id_gestion,
                    tcc.id_tipo_cc
                    from pre.tajuste aj
                    join pre.tajuste_det ajd on ajd.id_ajuste=aj.id_ajuste 
                    join pre.tpartida par on par.id_partida=ajd.id_partida
                    join pre.tpresupuesto pres on pres.id_presupuesto=ajd.id_presupuesto
                    join param.tcentro_costo cc on cc.id_centro_costo=pres.id_presupuesto
                    join param.ttipo_cc tcc on tcc.id_tipo_cc=cc.id_tipo_cc
                    join param.vtipo_cc_raiz ra on ra.id_tipo_cc=tcc.id_tipo_cc
                    join param.vtipo_cc_techo te on te.id_tipo_cc=tcc.id_tipo_cc
                    join param.tgestion g on g.id_gestion = cc.id_gestion
                    join param.tperiodo per on per.id_gestion=cc.id_gestion and per.periodo::integer=EXTRACT(MONTH from aj.fecha)::integer
                    where aj.tipo_ajuste not IN(''rev_comprometido'',''inc_comprometido'')
                    group by 
                    per.periodo,
                    par.tipo,
                    tcc.control_techo,
                    tcc.id_tipo_cc,
                    te.id_tipo_cc_techo,
                    te.codigo_techo,
                    te.descripcion_techo,
                    pres.estado,
                    aj.tipo_ajuste,
                    aj.tipo_ajuste_formulacion,
                    aj.estado,
                    g.gestion,
                    g.id_gestion)
                    
                    ';
             
           if(v_parametros.tipo_formulacion='presform')then   --#PRES-6  
             v_consulta:=v_consulta||' select 
                      f.id_tipo_cc_techo::integer,
                      f.periodo::varchar,
                      f.tipo::varchar,
                      f.ceco_techo::varchar,
                      f.importe::numeric,
                      f.estado_presupuesto::varchar,
                      f.tipo_formulacion::varchar,
                      f.estado_ajuste::varchar,
                      f.gestion::varchar,
                      f.origen::varchar
                      from formulacion f
                      where '||v_filtro_tipo_cc;
                      
             v_consulta:=v_consulta||v_parametros.filtro;   
                      
           end if;     
           
           if(v_parametros.tipo_formulacion='resform')then  --#PRES-6 
           
                v_consulta:=v_consulta||' ,formulacion2 AS(
                            select 
                            f.id_tipo_cc_techo::integer,
                            f.periodo::varchar,
                            f.tipo::varchar,
                            f.ceco_techo::varchar,
                            f.estado_presupuesto::varchar,
                            case when f.tipo_formulacion=''Formulación'' or f.tipo_formulacion=''formulacion'' then f.importe else 0 end formulacion,
                            case when f.tipo_formulacion=''reformulacion'' or f.tipo_formulacion=''Reformulación''  then f.importe else 0 end as reformulacion,
                            case when f.tipo_formulacion=''Traspaso'' then f.importe else 0 end traspaso,
                            case when f.tipo_formulacion = '''' or f.tipo_formulacion is null then f.importe else 0 end en_blanco,
                            f.tipo_formulacion::varchar,
                            f.estado_ajuste::varchar,
                            f.gestion::varchar,
                            f.origen::varchar,
                            f.id_tipo_cc,
                            f.id_gestion
                            from formulacion f
                          )
                          select 
                          f.ceco_techo::varchar,
                          sum(formulacion)::numeric formulacion,
                          sum(reformulacion)::NUMERIC as reformulacion,
                          sum(traspaso)::NUMERIC  as traspaso,
                          sum(en_blanco)::NUMERIC::NUMERIC as en_blanco

                          from formulacion2 f 
                          
                          where f.estado_ajuste in ('''',''aprobado'') and
                                f.estado_presupuesto in(''aprobado'') and
                                '||v_filtro_tipo_cc;
                
               v_consulta:=v_consulta||v_parametros.filtro;     
               v_consulta:=v_consulta||' group by f.ceco_techo ' ;        
               
                raise notice 'notice %',v_consulta;
  
            END IF;

              
    
      
      return v_consulta;
      
    end;
    /*********************************
  #TRANSACCION:  'PRE_REJEINVER_SEL' 
  #DESCRIPCION: Reporte EJECUCION INVERSION
  #AUTOR:   JUAN
  #FECHA:   29/09/2020
  ***********************************/

   elsif(p_transaccion='PRE_REJEINVER_SEL')then --#PRES-7 

    begin
      --#ETR-1673
      v_consulta:='with proveedor as(
                     select DISTINCT p.id_proveedor,p.id_int_comprobante 
                     from pre.vpartida_ejecucion_proveedor p
                     )';
      
 
      IF  EXISTS(with origen AS(SELECT v_parametros.origen::varchar as origen)
                SELECT * from origen orig
                where orig.origen::varchar like '%ejecucion%')  THEN
          v_bandera:='1'; --#ETR-1673       
          v_consulta:=v_consulta||' select 
                      (ct.codigo_techo||'' - ''||ct.descripcion_techo)::varchar as ceco_techo,
                      g.gestion::integer,
                      pxp.f_obtener_literal_periodo(p.periodo,-1)::varchar as periodo,
                      ''Ejecucion''::varchar as origen,
                      sum(pe.monto_mb)::numeric as monto_mb,
                      act.nombre_actividad::varchar,
                      proy.nombre_proyecto::varchar,
                      pe.nro_tramite::varchar,
                      prov.rotulo_comercial::varchar as proveedor

                      from pre.tpartida_ejecucion pe
                      join param.tcentro_costo cc on cc.id_centro_costo=pe.id_presupuesto
                      join param.ttipo_cc tcc on tcc.id_tipo_cc=cc.id_tipo_cc
                      join param.tgestion g on g.id_gestion=cc.id_gestion
                      join param.tperiodo p on p.id_gestion=cc.id_gestion and p.periodo=extract(MONTH from pe.fecha)
                      join param.tep ep on ep.id_ep=cc.id_ep
                      join param.tprograma_proyecto_acttividad ppa ON ppa.id_prog_pory_acti = ep.id_prog_pory_acti
                      join param.tprograma prog ON prog.id_programa = ppa.id_programa
                      join param.tproyecto proy ON proy.id_proyecto = ppa.id_proyecto
                      join param.tactividad act ON act.id_actividad = ppa.id_actividad
                      join param.tregional reg ON reg.id_regional = ep.id_regional
                      join param.vtipo_cc_raiz ra on ra.id_tipo_cc=tcc.id_tipo_cc
                      join param.vtipo_cc_techo ct on ct.id_tipo_cc=tcc.id_tipo_cc
                      left join pre.vpartida_ejecucion_proveedor pep on pep.valor_id_origen = pe.valor_id_origen and pep.columna_origen = pe.columna_origen
                      left join param.tproveedor prov on prov.id_proveedor=pep.id_proveedor 
                      where act.codigo_actividad in (''IA'',''PE'')
                      and pe.tipo_movimiento = ''ejecutado''
                      
                      and ';

          v_consulta:=v_consulta||v_parametros.filtro;                 
          v_consulta:=v_consulta||' group by ct.codigo_techo,ct.descripcion_techo,g.gestion,p.periodo, act.codigo_actividad,
                      act.nombre_actividad,
                      proy.nombre_proyecto,
                      pe.nro_tramite,
                      prov.rotulo_comercial ';
                  
      end if;   
      IF  EXISTS(with origen AS(SELECT v_parametros.origen::varchar as origen) --#ETR-1632


                SELECT * from origen orig
                where orig.origen::varchar like '%comprometido%')  THEN
                
          if(v_bandera ='1')THEN --#ETR-1673
            v_consulta:=v_consulta||' union all ';
          end if;
          v_bandera:='1';          
          v_consulta:=v_consulta||' select 
                      (ct.codigo_techo||'' - ''||ct.descripcion_techo)::varchar as ceco_techo,
                      g.gestion::integer,
                      pxp.f_obtener_literal_periodo(p.periodo,-1)::varchar as periodo,
                      ''Comprometido''::varchar as origen,
                      sum(pe.monto_mb)::numeric as monto_mb,
                      act.nombre_actividad::varchar,
                      proy.nombre_proyecto::varchar,
                      pe.nro_tramite::varchar,
                      prov.rotulo_comercial::varchar as proveedor

                      from pre.tpartida_ejecucion pe
                      join param.tcentro_costo cc on cc.id_centro_costo=pe.id_presupuesto
                      join param.ttipo_cc tcc on tcc.id_tipo_cc=cc.id_tipo_cc
                      join param.tgestion g on g.id_gestion=cc.id_gestion
                      join param.tperiodo p on p.id_gestion=cc.id_gestion and p.periodo=extract(MONTH from pe.fecha)
                      join param.tep ep on ep.id_ep=cc.id_ep
                      join param.tprograma_proyecto_acttividad ppa ON ppa.id_prog_pory_acti = ep.id_prog_pory_acti
                      join param.tprograma prog ON prog.id_programa = ppa.id_programa
                      join param.tproyecto proy ON proy.id_proyecto = ppa.id_proyecto
                      join param.tactividad act ON act.id_actividad = ppa.id_actividad
                      join param.tregional reg ON reg.id_regional = ep.id_regional
                      join param.vtipo_cc_raiz ra on ra.id_tipo_cc=tcc.id_tipo_cc
                      join param.vtipo_cc_techo ct on ct.id_tipo_cc=tcc.id_tipo_cc
                      left join pre.vpartida_ejecucion_proveedor pep on pep.valor_id_origen = pe.valor_id_origen and pep.columna_origen = pe.columna_origen
                      left join param.tproveedor prov on prov.id_proveedor=pep.id_proveedor 
                      where act.codigo_actividad in (''IA'',''PE'')
                      and pe.tipo_movimiento = ''comprometido''
                      
                      and ';

          v_consulta:=v_consulta||v_parametros.filtro;                 
          v_consulta:=v_consulta||' group by ct.codigo_techo,ct.descripcion_techo,g.gestion,p.periodo, act.codigo_actividad,
                      act.nombre_actividad,
                      proy.nombre_proyecto,
                      pe.nro_tramite,
                      prov.rotulo_comercial ';
                  
      end if; 
      
      IF  EXISTS(with origen AS(SELECT v_parametros.origen::varchar as origen)
                SELECT * from origen orig
                where orig.origen::varchar like '%iva%')  THEN
                
          if(v_bandera ='1')THEN --#ETR-1673
            v_consulta:=v_consulta||' union all ';
          end if;
          v_bandera:='1';          
          v_consulta:=v_consulta||' select 
                        (ct.codigo_techo||'' - ''||ct.descripcion_techo)::varchar as ceco_techo,
                        g.gestion,
                        (pxp.f_obtener_literal_periodo(p.periodo,-1))::varchar as periodo,
                        ''IVA''::varchar as origen,
                        sum(tra.importe_debe_mb-tra.importe_haber_mb)::numeric as monto_mb,
                        act.nombre_actividad::varchar,
                        proy.nombre_proyecto::varchar,
                        tra.nro_tramite::varchar,
                        prov.rotulo_comercial::varchar as proveedor
                        from conta.tint_transaccion tra  
                        join conta.tint_comprobante comp on comp.id_int_comprobante=tra.id_int_comprobante
                        join param.tcentro_costo cc on cc.id_centro_costo=tra.id_centro_costo
                        join param.ttipo_cc tcc on tcc.id_tipo_cc=cc.id_tipo_cc
                        join param.tgestion g on g.id_gestion=cc.id_gestion
                        join param.tperiodo p on p.id_periodo=comp.id_periodo
                        join param.tep ep on ep.id_ep=cc.id_ep
                        join param.tprograma_proyecto_acttividad ppa ON ppa.id_prog_pory_acti = ep.id_prog_pory_acti
                        join param.tprograma prog ON prog.id_programa = ppa.id_programa
                        join param.tproyecto proy ON proy.id_proyecto = ppa.id_proyecto
                        join param.tactividad act ON act.id_actividad = ppa.id_actividad
                        join param.tregional reg ON reg.id_regional = ep.id_regional
                        join param.vtipo_cc_raiz ra on ra.id_tipo_cc=tcc.id_tipo_cc
                        join param.vtipo_cc_techo ct on ct.id_tipo_cc=tcc.id_tipo_cc
                        join conta.tcuenta cta on cta.id_cuenta=tra.id_cuenta
                        left join proveedor pep on pep.id_int_comprobante=comp.id_int_comprobante --#ETR-1673
                        left join param.tproveedor prov on prov.id_proveedor=pep.id_proveedor
                        where act.codigo_actividad in (''IA'',''PE'') 
                        and comp.estado_reg=''validado''
                        and cta.nro_cuenta like ''1.1.3.04%''
                        and
                         ';

          v_consulta:=v_consulta||v_parametros.filtro;
          v_consulta:=v_consulta||' group by ct.codigo_techo,ct.descripcion_techo,g.gestion,p.periodo, act.codigo_actividad,comp.estado_reg,
                                  act.nombre_actividad,
                                  proy.nombre_proyecto,prov.rotulo_comercial,tra.nro_tramite ';
                  
      end if; 
      
      IF  EXISTS(with origen AS(SELECT v_parametros.origen::varchar as origen)
                SELECT * from origen orig
                where orig.origen::varchar like '%inflacion%')  THEN
                
          if(v_bandera='1')THEN --#ETR-1673
            v_consulta:=v_consulta||' union all ';
          end if;
          v_bandera:='1';          
          v_consulta:=v_consulta||' select 
                      (ct.codigo_techo||'' - ''||ct.descripcion_techo)::varchar as ceco_techo,
                      g.gestion,
                      (pxp.f_obtener_literal_periodo(p.periodo,-1))::varchar as periodo,
                      ''Inflacion''::varchar as origen,
                      sum(tra.importe_debe_mb-tra.importe_haber_mb)::numeric as monto_mb,
                      act.nombre_actividad::varchar,
                      proy.nombre_proyecto::varchar,
                      tra.nro_tramite::varchar,
                      prov.rotulo_comercial::varchar as proveedor
                      from conta.tint_transaccion tra  
                      join conta.tint_comprobante comp on comp.id_int_comprobante=tra.id_int_comprobante
                      join param.tcentro_costo cc on cc.id_centro_costo=tra.id_centro_costo
                      join param.ttipo_cc tcc on tcc.id_tipo_cc=cc.id_tipo_cc
                      join param.tgestion g on g.id_gestion=cc.id_gestion
                      join param.tperiodo p on p.id_periodo=comp.id_periodo
                      join param.tep ep on ep.id_ep=cc.id_ep
                      join param.tprograma_proyecto_acttividad ppa ON ppa.id_prog_pory_acti = ep.id_prog_pory_acti
                      join param.tprograma prog ON prog.id_programa = ppa.id_programa
                      join param.tproyecto proy ON proy.id_proyecto = ppa.id_proyecto
                      join param.tactividad act ON act.id_actividad = ppa.id_actividad
                      join param.tregional reg ON reg.id_regional = ep.id_regional
                      join param.vtipo_cc_raiz ra on ra.id_tipo_cc=tcc.id_tipo_cc
                      join param.vtipo_cc_techo ct on ct.id_tipo_cc=tcc.id_tipo_cc
                      join pre.tpartida par on par.id_partida=tra.id_partida
                      left join pre.vpartida_ejecucion_proveedor pep on pep.id_int_comprobante=comp.id_int_comprobante
                      left join param.tproveedor prov on prov.id_proveedor=pep.id_proveedor 
                      where act.codigo_actividad in (''IA'',''PE'') and comp.estado_reg=''validado''
                      and par.codigo = ''25400''
                      and ';

          v_consulta:=v_consulta||v_parametros.filtro;  
                
          v_consulta:=v_consulta||' group by ct.codigo_techo,ct.descripcion_techo,g.gestion,p.periodo, act.codigo_actividad,comp.estado_reg,
                      act.nombre_actividad,
                      proy.nombre_proyecto,
                      tra.nro_tramite,
                      prov.rotulo_comercial ';
                  
      end if;               
  
    
      return v_consulta;
      
  end; 
    /*********************************
  #TRANSACCION:  'PRE_REJECUPRES_SEL' 
  #DESCRIPCION: Reporte EJECUCION PRESUPUESTARIA CON PERIODOS
  #AUTOR:   JUAN
  #FECHA:   18/11/2020
  ***********************************/

   elsif(p_transaccion='PRE_REJECUPRES_SEL')then --##ETR-1815 

    begin
    
    
v_filtro_tipo_cc = ' 0=0 and ';
     IF v_parametros.id_tipo_cc is not NULL THEN
          WITH RECURSIVE tipo_cc_rec (id_tipo_cc, id_tipo_cc_fk) AS (
            SELECT tcc.id_tipo_cc, tcc.id_tipo_cc_fk
            FROM param.ttipo_cc tcc
            WHERE tcc.id_tipo_cc = v_parametros.id_tipo_cc and tcc.estado_reg = 'activo'
          UNION ALL
            SELECT tcc2.id_tipo_cc, tcc2.id_tipo_cc_fk
            FROM tipo_cc_rec lrec 
            INNER JOIN param.ttipo_cc tcc2 ON lrec.id_tipo_cc = tcc2.id_tipo_cc_fk
            where tcc2.estado_reg = 'activo'
          )
        SELECT  pxp.list(id_tipo_cc::varchar) 
          into 
            v_tipo_cc
        FROM tipo_cc_rec;
        
        if(v_parametros.tipo_reporte='movimiento')THEN
          v_filtro_tipo_reporte := '';
        else
          v_filtro_tipo_reporte := ' or cc.id_tipo_cc is null ';
        end if;
        
        v_filtro_tipo_cc = ' (cc.id_tipo_cc in('||v_tipo_cc||') '||v_filtro_tipo_reporte||'   ) AND   ';        
     END IF;            
     
          v_consulta:='  with RECURSIVE partida as(
  select
    par.id_partida,
    par.id_partida_fk,
    (par.codigo||'' - ''||par.nombre_partida)::varchar as partida,
    (par.id_partida)::text as orden,
    par.id_gestion,
    ''   ''::VARCHAR as nivel,
    par.sw_transaccional,
        1 as nivel2
  from pre.tpartida par
  where par.id_partida_fk is NULL and par.estado_reg=''activo''
  UNION ALL
  select
    par.id_partida,
    par.id_partida_fk,
    (par.codigo||'' - ''||par.nombre_partida)::varchar as parida,
    (par1.orden||'' -> ''||par.id_partida)::text as orden,
    par.id_gestion,
    (par1.nivel||''    '')::VARCHAR as nivel,
    par.sw_transaccional,
    par1.nivel2+1 as nivel2
  from pre.tpartida par
         join partida par1 on par1.id_partida=par.id_partida_fk
  where par.id_partida_fk is not NULL and par.estado_reg=''activo''
  and par.sw_movimiento = ''presupuestaria''
), 

p_ejecucion as (
 select
         pe.id_partida,
         pe.id_presupuesto,
         par.id_partida_fk,
         pe.nro_tramite,
         (case when pe.tipo_movimiento = ''formulado'' then sum(pe.monto_mb) end)::numeric as formulado,
         (case when pe.tipo_movimiento = ''comprometido'' then sum(pe.monto_mb) end)::numeric as comprometido,
          case when  extract(MONTH from  pe.fecha)::integer = 1 and pe.tipo_movimiento = ''ejecutado'' then sum(pe.monto_mb) else 0 end as enero,
          case when  extract(MONTH from  pe.fecha)::integer = 2 and pe.tipo_movimiento = ''ejecutado'' then sum(pe.monto_mb) else 0 end as febrero,
          case when  extract(MONTH from  pe.fecha)::integer = 3 and pe.tipo_movimiento = ''ejecutado'' then sum(pe.monto_mb) else 0 end as marzo,
          case when  extract(MONTH from  pe.fecha)::integer = 4 and pe.tipo_movimiento = ''ejecutado'' then sum(pe.monto_mb) else 0 end as abril,
          case when  extract(MONTH from  pe.fecha)::integer = 5 and pe.tipo_movimiento = ''ejecutado'' then sum(pe.monto_mb) else 0 end as mayo,
          case when  extract(MONTH from  pe.fecha)::integer = 6 and pe.tipo_movimiento = ''ejecutado'' then sum(pe.monto_mb) else 0 end as junio,
          case when  extract(MONTH from  pe.fecha)::integer = 7 and pe.tipo_movimiento = ''ejecutado'' then sum(pe.monto_mb) else 0 end as julio,
          case when  extract(MONTH from  pe.fecha)::integer = 8 and pe.tipo_movimiento = ''ejecutado'' then sum(pe.monto_mb) else 0 end as agosto,
          case when  extract(MONTH from  pe.fecha)::integer = 9 and pe.tipo_movimiento = ''ejecutado'' then sum(pe.monto_mb) else 0 end as septiembre,
          case when  extract(MONTH from  pe.fecha)::integer = 10 and pe.tipo_movimiento = ''ejecutado'' then sum(pe.monto_mb) else 0 end as octubre,
          case when  extract(MONTH from  pe.fecha)::integer = 11 and pe.tipo_movimiento = ''ejecutado'' then sum(pe.monto_mb) else 0 end as noviembre,
          case when  extract(MONTH from  pe.fecha)::integer = 12 and pe.tipo_movimiento = ''ejecutado'' then sum(pe.monto_mb) else 0 end as diciembre,
         (case when pe.tipo_movimiento = ''ejecutado'' then sum(pe.monto_mb) end)::numeric as ejecutado
       
         from pre.tpartida_ejecucion pe 
         inner join pre.tpartida par on par.id_partida = pe.id_partida
         inner join param.tcentro_costo cc on cc.id_centro_costo = pe.id_presupuesto
      
         where  cc.id_gestion='||v_parametros.id_gestion||' and '||v_filtro_tipo_cc||'
       
          
         case when pe.fecha::date > coalesce ('''||v_parametros.fecha_ini||''',''01-01-1991'' )::date   then 0=0 else pe.fecha::date >= '''||v_parametros.fecha_ini||'''::date  end
         and 
         case when pe.fecha::date < coalesce ('''||v_parametros.fecha_fin||''',''31-12-2050'' )::date   then 0=0 else pe.fecha::date <= '''||v_parametros.fecha_fin||'''::date  end
         

       
       
       group by pe.id_partida,pe.tipo_movimiento,pe.nro_tramite,pe.fecha,pe.id_presupuesto,par.id_partida_fk
 ), 
 
 
 eje_agrup as (
 
 select 
      pe.id_presupuesto,
      pe.id_partida_fk,
      sum(pe.formulado) as formulado,
      sum(pe.comprometido) as comprometido,
      sum(pe.enero) as enero,
      sum(pe.febrero) as febrero,
      sum(pe.marzo) as marzo,
      sum(pe.abril) as abril,
      sum(pe.mayo) as mayo,
      sum(pe.junio) as junio,
      sum(pe.julio) as julio,
      sum(pe.agosto) as agosto,
      sum(pe.septiembre) as septiembre,
      sum(pe.octubre) as octubre,
      sum(pe.noviembre) as noviembre,
      sum(pe.diciembre) as diciembre,
      sum(pe.ejecutado) as ejecutado
 from p_ejecucion pe 
 group by   
      pe.id_presupuesto,
      pe.id_partida_fk
 ),
 partida2 as (
 
  select 
  par.orden,
  par.nivel||par.partida as partida,
  par.sw_transaccional,
  pe.nro_tramite,
  case when par.sw_transaccional=''movimiento'' then pe.formulado else pe1.formulado end as formulado,
  case when par.sw_transaccional=''movimiento'' then pe.comprometido else pe1.comprometido end as comprometido,
  case when par.sw_transaccional=''movimiento'' then pe.enero else pe1.enero end as enero,
  case when par.sw_transaccional=''movimiento'' then pe.febrero else pe1.febrero end as febrero,
  case when par.sw_transaccional=''movimiento'' then pe.marzo else pe1.marzo end as marzo,
  case when par.sw_transaccional=''movimiento'' then pe.abril else pe1.abril end as abril,
  case when par.sw_transaccional=''movimiento'' then pe.mayo else pe1.mayo end as mayo,
  case when par.sw_transaccional=''movimiento'' then pe.junio else pe1.junio end as junio,
  case when par.sw_transaccional=''movimiento'' then pe.julio else pe1.julio end as julio,
  case when par.sw_transaccional=''movimiento'' then pe.agosto else pe1.agosto end as agosto,
  case when par.sw_transaccional=''movimiento'' then pe.septiembre else pe1.septiembre end as septiembre,
  case when par.sw_transaccional=''movimiento'' then pe.octubre else pe1.octubre end as octubre,
  case when par.sw_transaccional=''movimiento'' then pe.noviembre else pe1.noviembre end as noviembre,
  case when par.sw_transaccional=''movimiento'' then pe.diciembre else pe1.diciembre end as diciembre, 
  case when par.sw_transaccional=''movimiento'' then pe.ejecutado else pe1.ejecutado end as ejecutado
  from partida par 

  left join p_ejecucion pe on pe.id_partida = par.id_partida and par.sw_transaccional=''movimiento''
  left join eje_agrup pe1 on pe1.id_partida_fk = par.id_partida and par.sw_transaccional=''titular''
  where --par.id_gestion = 4 and
  case when par.sw_transaccional=''movimiento'' then pe.formulado is not null  else pe1.formulado is not null end  or 
  case when par.sw_transaccional=''movimiento'' then pe.comprometido is not null else pe1.comprometido  is not null end  or
  case when par.sw_transaccional=''movimiento'' then pe.ejecutado is not null else pe1.ejecutado is not null end  
  order by par.orden asc
  )
  select 
  par.partida::varchar as partida,
  par.nro_tramite::varchar  as nro_tramite,
  
  sum(par.formulado)::numeric as formulado,
  sum(par.comprometido)::numeric as comprometido,
  
  sum(par.enero)::numeric as enero,
  sum(par.febrero)::numeric as febrero,
  sum(par.marzo)::numeric as marzo,
  sum(par.abril)::numeric as abril,
  sum(par.mayo)::numeric as mayo,
  sum(par.junio)::numeric as junio,
  sum(par.julio)::numeric as julio,
  sum(par.agosto)::numeric as agosto,
  sum(par.septiembre)::numeric as septiembre,
  sum(par.octubre)::numeric as octubre,
  sum(par.noviembre)::numeric as noviembre,
  sum(par.diciembre)::numeric as diciembre,
  
  sum(par.ejecutado)::numeric as ejecutado,
  
  case when sum(par.formulado) > 0 and  par.sw_transaccional = ''titular'' then   sum(par.ejecutado)/sum(par.formulado) else NULL end::numeric porcentaje_eje_form,
  case when sum(par.comprometido) > 0 then   sum(par.ejecutado)/sum(par.comprometido) else NULL end::numeric porcentaje_eje_comp,
  par.sw_transaccional::varchar as sw_transaccional
  from partida2 par
  where ';

        v_consulta:=v_consulta||v_parametros.filtro||'   group by 
        par.orden,
        par.partida,
        par.sw_transaccional,
        par.nro_tramite order by par.orden asc';  
                
                  
      --raise NOTICE 'notice % ',v_consulta;
      --raise EXCEPTION 'exception juan % ',v_consulta;
      return v_consulta;
      
  end;
  
     /*********************************
  #TRANSACCION:  'PRE_REJPREAGR_SEL' 
  #DESCRIPCION: Reporte EJECUCION PRESUPUESTARIA CON PERIODOS
  #AUTOR:   JUAN
  #FECHA:   18/11/2020
  ***********************************/

   elsif(p_transaccion='PRE_REJPREAGR_SEL')then --#ETR-1890


    begin
    
    
v_filtro_tipo_cc = ' 0=0 and ';
     IF v_parametros.id_tipo_cc is not NULL THEN
          WITH RECURSIVE tipo_cc_rec (id_tipo_cc, id_tipo_cc_fk) AS (
            SELECT tcc.id_tipo_cc, tcc.id_tipo_cc_fk
            FROM param.ttipo_cc tcc
            WHERE tcc.id_tipo_cc = v_parametros.id_tipo_cc and tcc.estado_reg = 'activo'
          UNION ALL
            SELECT tcc2.id_tipo_cc, tcc2.id_tipo_cc_fk
            FROM tipo_cc_rec lrec 
            INNER JOIN param.ttipo_cc tcc2 ON lrec.id_tipo_cc = tcc2.id_tipo_cc_fk
            where tcc2.estado_reg = 'activo'
          )
        SELECT  pxp.list(id_tipo_cc::varchar) 
          into 
            v_tipo_cc
        FROM tipo_cc_rec;
        
        if(v_parametros.tipo_reporte='movimiento')THEN
          v_filtro_tipo_reporte := '';
        else
          v_filtro_tipo_reporte := ' or cc.id_tipo_cc is null ';
        end if;
        
        v_filtro_tipo_cc = ' (cc.id_tipo_cc in('||v_tipo_cc||') '||v_filtro_tipo_reporte||'   ) AND   ';        
     END IF;            
     
          v_consulta:='  with RECURSIVE partida as(
  select
    par.id_partida,
    par.id_partida_fk,
    (par.codigo||'' - ''||par.nombre_partida)::varchar as partida,
    (par.id_partida)::text as orden,
    par.id_gestion,
    ''   ''::VARCHAR as nivel,
    par.sw_transaccional,
        1 as nivel2
  from pre.tpartida par
  where par.id_partida_fk is NULL and par.estado_reg=''activo''
  UNION ALL
  select
    par.id_partida,
    par.id_partida_fk,
    (par.codigo||'' - ''||par.nombre_partida)::varchar as parida,
    (par1.orden||'' -> ''||par.id_partida)::text as orden,
    par.id_gestion,
    (par1.nivel||''    '')::VARCHAR as nivel,
    par.sw_transaccional,
    par1.nivel2+1 as nivel2
  from pre.tpartida par
         join partida par1 on par1.id_partida=par.id_partida_fk
  where par.id_partida_fk is not NULL and par.estado_reg=''activo''
  and par.sw_movimiento = ''presupuestaria''
), 

p_ejecucion as (
 select
         pe.id_partida,
         pe.id_presupuesto,
         par.id_partida_fk,
         pe.nro_tramite,
         (case when pe.tipo_movimiento = ''formulado'' then sum(pe.monto_mb) end)::numeric as formulado,
         (case when pe.tipo_movimiento = ''comprometido'' then sum(pe.monto_mb) end)::numeric as comprometido,
          case when  extract(MONTH from  pe.fecha)::integer = 1 and pe.tipo_movimiento = ''ejecutado'' then sum(pe.monto_mb) else 0 end as enero,
          case when  extract(MONTH from  pe.fecha)::integer = 2 and pe.tipo_movimiento = ''ejecutado'' then sum(pe.monto_mb) else 0 end as febrero,
          case when  extract(MONTH from  pe.fecha)::integer = 3 and pe.tipo_movimiento = ''ejecutado'' then sum(pe.monto_mb) else 0 end as marzo,
          case when  extract(MONTH from  pe.fecha)::integer = 4 and pe.tipo_movimiento = ''ejecutado'' then sum(pe.monto_mb) else 0 end as abril,
          case when  extract(MONTH from  pe.fecha)::integer = 5 and pe.tipo_movimiento = ''ejecutado'' then sum(pe.monto_mb) else 0 end as mayo,
          case when  extract(MONTH from  pe.fecha)::integer = 6 and pe.tipo_movimiento = ''ejecutado'' then sum(pe.monto_mb) else 0 end as junio,
          case when  extract(MONTH from  pe.fecha)::integer = 7 and pe.tipo_movimiento = ''ejecutado'' then sum(pe.monto_mb) else 0 end as julio,
          case when  extract(MONTH from  pe.fecha)::integer = 8 and pe.tipo_movimiento = ''ejecutado'' then sum(pe.monto_mb) else 0 end as agosto,
          case when  extract(MONTH from  pe.fecha)::integer = 9 and pe.tipo_movimiento = ''ejecutado'' then sum(pe.monto_mb) else 0 end as septiembre,
          case when  extract(MONTH from  pe.fecha)::integer = 10 and pe.tipo_movimiento = ''ejecutado'' then sum(pe.monto_mb) else 0 end as octubre,
          case when  extract(MONTH from  pe.fecha)::integer = 11 and pe.tipo_movimiento = ''ejecutado'' then sum(pe.monto_mb) else 0 end as noviembre,
          case when  extract(MONTH from  pe.fecha)::integer = 12 and pe.tipo_movimiento = ''ejecutado'' then sum(pe.monto_mb) else 0 end as diciembre,
         (case when pe.tipo_movimiento = ''ejecutado'' then sum(pe.monto_mb) end)::numeric as ejecutado
       
         from pre.tpartida_ejecucion pe 
         inner join pre.tpartida par on par.id_partida = pe.id_partida
         inner join param.tcentro_costo cc on cc.id_centro_costo = pe.id_presupuesto
      
         where  cc.id_gestion='||v_parametros.id_gestion||' and '||v_filtro_tipo_cc||'
       
          
         case when pe.fecha::date > coalesce ('''||v_parametros.fecha_ini||''',''01-01-1991'' )::date   then 0=0 else pe.fecha::date >= '''||v_parametros.fecha_ini||'''::date  end
         and 
         case when pe.fecha::date < coalesce ('''||v_parametros.fecha_fin||''',''31-12-2050'' )::date   then 0=0 else pe.fecha::date <= '''||v_parametros.fecha_fin||'''::date  end
         

       
       
       group by pe.id_partida,pe.tipo_movimiento,pe.nro_tramite,pe.fecha,pe.id_presupuesto,par.id_partida_fk
 ), 
 
 
 eje_agrup as (
 
 select 
      pe.id_presupuesto,
      pe.id_partida_fk,
      sum(pe.formulado) as formulado,
      sum(pe.comprometido) as comprometido,
      sum(pe.enero) as enero,
      sum(pe.febrero) as febrero,
      sum(pe.marzo) as marzo,
      sum(pe.abril) as abril,
      sum(pe.mayo) as mayo,
      sum(pe.junio) as junio,
      sum(pe.julio) as julio,
      sum(pe.agosto) as agosto,
      sum(pe.septiembre) as septiembre,
      sum(pe.octubre) as octubre,
      sum(pe.noviembre) as noviembre,
      sum(pe.diciembre) as diciembre,
      sum(pe.ejecutado) as ejecutado
 from p_ejecucion pe 
 group by   
      pe.id_presupuesto,
      pe.id_partida_fk
 ),
 partida2 as (
 
  select 
  par.orden,
  par.nivel||par.partida as partida,
  par.sw_transaccional,
  pe.nro_tramite,
  case when par.sw_transaccional=''movimiento'' then pe.formulado else pe1.formulado end as formulado,
  case when par.sw_transaccional=''movimiento'' then pe.comprometido else pe1.comprometido end as comprometido,
  case when par.sw_transaccional=''movimiento'' then pe.enero else pe1.enero end as enero,
  case when par.sw_transaccional=''movimiento'' then pe.febrero else pe1.febrero end as febrero,
  case when par.sw_transaccional=''movimiento'' then pe.marzo else pe1.marzo end as marzo,
  case when par.sw_transaccional=''movimiento'' then pe.abril else pe1.abril end as abril,
  case when par.sw_transaccional=''movimiento'' then pe.mayo else pe1.mayo end as mayo,
  case when par.sw_transaccional=''movimiento'' then pe.junio else pe1.junio end as junio,
  case when par.sw_transaccional=''movimiento'' then pe.julio else pe1.julio end as julio,
  case when par.sw_transaccional=''movimiento'' then pe.agosto else pe1.agosto end as agosto,
  case when par.sw_transaccional=''movimiento'' then pe.septiembre else pe1.septiembre end as septiembre,
  case when par.sw_transaccional=''movimiento'' then pe.octubre else pe1.octubre end as octubre,
  case when par.sw_transaccional=''movimiento'' then pe.noviembre else pe1.noviembre end as noviembre,
  case when par.sw_transaccional=''movimiento'' then pe.diciembre else pe1.diciembre end as diciembre, 
  case when par.sw_transaccional=''movimiento'' then pe.ejecutado else pe1.ejecutado end as ejecutado
  from partida par 

  left join p_ejecucion pe on pe.id_partida = par.id_partida and par.sw_transaccional=''movimiento''
  left join eje_agrup pe1 on pe1.id_partida_fk = par.id_partida and par.sw_transaccional=''titular''
  where --par.id_gestion = 4 and
  case when par.sw_transaccional=''movimiento'' then pe.formulado is not null  else pe1.formulado is not null end  or 
  case when par.sw_transaccional=''movimiento'' then pe.comprometido is not null else pe1.comprometido  is not null end  or
  case when par.sw_transaccional=''movimiento'' then pe.ejecutado is not null else pe1.ejecutado is not null end  
  order by par.orden asc
  )
  select 
  par.partida::varchar as partida,
  
  sum(par.formulado)::numeric as formulado,
  sum(par.comprometido)::numeric as comprometido,
  
  sum(par.enero)::numeric as enero,
  sum(par.febrero)::numeric as febrero,
  sum(par.marzo)::numeric as marzo,
  sum(par.abril)::numeric as abril,
  sum(par.mayo)::numeric as mayo,
  sum(par.junio)::numeric as junio,
  sum(par.julio)::numeric as julio,
  sum(par.agosto)::numeric as agosto,
  sum(par.septiembre)::numeric as septiembre,
  sum(par.octubre)::numeric as octubre,
  sum(par.noviembre)::numeric as noviembre,
  sum(par.diciembre)::numeric as diciembre,
  
  sum(par.ejecutado)::numeric as ejecutado,
  
  case when sum(par.formulado) > 0 and  par.sw_transaccional = ''titular'' then   sum(par.ejecutado)/sum(par.formulado) else NULL end::numeric porcentaje_eje_form,
  case when sum(par.comprometido) > 0 then   sum(par.ejecutado)/sum(par.comprometido) else NULL end::numeric porcentaje_eje_comp,
  par.sw_transaccional::varchar as sw_transaccional
  from partida2 par
  where ';

        v_consulta:=v_consulta||v_parametros.filtro||'   group by 
        par.orden,
        par.partida,
        par.sw_transaccional
        order by par.orden asc';  
                
                  
      --raise NOTICE 'notice % ',v_consulta;
      --raise EXCEPTION 'exception juan % ',v_consulta;
      return v_consulta;
      
  end;
   /*********************************
  #TRANSACCION:  'PRE_REJEDETCOMP_SEL' 
  #DESCRIPCION: Reporte partida ejecucion con adquisiciones
  #AUTOR:   JUAN
  #FECHA:   13/11/2020
  ***********************************/

   elsif(p_transaccion='PRE_REJEDETCOMP_SEL')then --#PRES-8 

    begin
             
          v_consulta:='select 
              pe.monto_mb::NUMERIC,
              pe.partida_homologada::VARCHAR,
              pe.codigo_proceso::VARCHAR,
              pe.ceco::VARCHAR,
              pe.cantidad_adju::numeric,
              pe.unidad_medida::VARCHAR,
              pe.proveedor::VARCHAR,
              pe.proveedor_costo_indirecto::VARCHAR,
              pe.id_gestion::int4,
              pe.gestion::VARCHAR,
              pe.periodo::VARCHAR,
              pe.tipo_costo::VARCHAR,
              pe.descripcion::VARCHAR,
              pe.nro_tramite::VARCHAR,
              pe.tipo_tramite::VARCHAR,
              pe.tipo_partida::VARCHAR,
              pe.id_tipo_cc_techo::integer  
              from pre.partida_ejecucion_detalle_cotizacion pe where ';

          v_consulta:=v_consulta||v_parametros.filtro;  
                
      return v_consulta;
      
    end;
  else

    raise exception 'Transaccion inexistente';

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