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

      --Sentencia de la consulta de conteo de registros
      v_consulta:='select
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
                    pe.nro_tramite --#40
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
                    and pe.tipo_movimiento = ''ejecutado'' and ';

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