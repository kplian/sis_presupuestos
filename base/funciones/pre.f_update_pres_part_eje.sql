--------------- SQL ---------------

CREATE OR REPLACE FUNCTION pre.f_update_pres_part_eje (
  p_id_gestion numeric
)
RETURNS numeric AS
$body$
DECLARE
  verificado  					record;
  v_consulta 					varchar;
  v_conexion 					varchar;
  v_resp						varchar;
  v_sincronizar 				varchar; 
  v_nombre_funcion  			varchar;
  v_total						numeric;
  v_datos						record;
  v_part_eje 				    record;
  v_part_eje_fin 				record;
  v_sw							numeric;
  v_sw_1						numeric;
  v_aux							record;
  v_id_caja						numeric[];
  v_id_caja_v2					numeric[];
BEGIN
	v_nombre_funcion = 'pre.f_update_pres_part_eje';
    v_total = 0;
    v_sw = 0;     
	v_sw_1 = 0; 
     
    FOR v_datos IN (
    	WITH datos as(
            SELECT 
            mc.id_memoria_calculo,
            0::NUMERIC AS id_presup_partida,
            0::NUMERIC AS id_partida_ejecucion,
            cc.codigo_tcc,
            mc.id_presupuesto as id_centro_costo,
            p.codigo,
            mc.id_partida,
            cc.gestion,
            mc.importe_total as total_MC,
            0::NUMERIC as total_PP,
            0::NUMERIC as total_PE
            FROM pre.tmemoria_calculo mc
            JOIN param.vcentro_costo cc on cc.id_centro_costo=mc.id_presupuesto
            JOIN pre.tpresupuesto pres on pres.id_presupuesto=mc.id_presupuesto
            JOIN pre.tpartida p on p.id_partida=mc.id_partida
            WHERE 
            cc.gestion=p_id_gestion and pres.estado='borrador' and mc.importe_total>0
            AND cc.id_centro_costo!=11396
            
            union 

            SELECT 
            0::NUMERIC AS id_memoria_calculo,
            pp.id_presup_partida,
            0::NUMERIC AS id_partida_ejecucion,
            cc.codigo_tcc,
            cc.id_centro_costo,
            p.codigo,
            p.id_partida,
            cc.gestion,
            0::NUMERIC as total_MC,
            pp.importe as total_PP,
            0::NUMERIC as total_PE
            FROM pre.tpresup_partida pp
            JOIN param.vcentro_costo cc on cc.id_centro_costo=pp.id_presupuesto
            JOIN pre.tpresupuesto pres on pres.id_presupuesto=pp.id_presupuesto
            JOIN pre.tpartida p on p.id_partida=pp.id_partida
            where 
            cc.gestion=p_id_gestion  and pres.estado='borrador' and pp.importe>0
            AND cc.id_centro_costo!=11396

            union

            select 
            0::NUMERIC AS id_memoria_calculo,
            0::NUMERIC AS id_presup_partida,
            pe.id_partida_ejecucion,
            cc.codigo_tcc,
            cc.id_centro_costo,
            p.codigo,
            p.id_partida,
            cc.gestion,
            0::NUMERIC as total_MC,
            0::NUMERIC as total_PP,
            pe.monto as total_PE
            from pre.tpartida_ejecucion pe
            JOIN param.vcentro_costo cc on cc.id_centro_costo=pe.id_presupuesto
            JOIN pre.tpartida p on p.id_partida=pe.id_partida
            where 
            pe.tipo_movimiento='formulado'
            and cc.gestion=p_id_gestion AND pe.nro_tramite like '%FP%'
            and pe.monto>0
            AND cc.id_centro_costo!=11396
            )

      select 
      datos.id_memoria_calculo,
      datos.id_presup_partida,
      datos.id_partida_ejecucion,
      datos.codigo_tcc,
      datos.id_centro_costo,
      datos.codigo,
      datos.id_partida,
      datos.gestion,
      datos.total_MC,
      datos.total_PP,
      datos.total_PE
      from datos
      where datos.id_memoria_calculo!=0
      order by datos.id_centro_costo,datos.id_partida,datos.id_memoria_calculo


    ) LOOP
        v_id_caja[v_total] = v_datos.total_MC;
        v_id_caja_v2[v_total]=v_datos.total_MC;
        v_total=v_total+1;
	END LOOP;
    
    FOR v_part_eje IN (
    	SELECT        
        pp.id_presup_partida,
        cc.codigo_tcc,
        cc.id_centro_costo,
        p.codigo,
        p.id_partida,
        cc.gestion,
        pp.importe as total_PP
        FROM pre.tpresup_partida pp
        JOIN param.vcentro_costo cc on cc.id_centro_costo=pp.id_presupuesto
        JOIN pre.tpresupuesto pres on pres.id_presupuesto=pp.id_presupuesto
        JOIN pre.tpartida p on p.id_partida=pp.id_partida
        where 
        cc.gestion=p_id_gestion and pres.estado='borrador' and pp.importe>0
        AND cc.id_centro_costo!=11396        
        order by cc.id_centro_costo,p.id_partida,pp.id_presup_partida
    ) LOOP
    
        UPDATE pre.tpresup_partida
        SET importe=v_id_caja[v_sw]::numeric,importe_aprobado=v_id_caja[v_sw]::numeric
        WHERE id_presup_partida=v_part_eje.id_presup_partida;
        v_sw=v_sw+1;
        raise notice 'total==>>%,%,%,%',v_part_eje.id_presup_partida,v_part_eje.id_centro_costo,v_part_eje.id_partida,v_id_caja[v_sw];
	END LOOP;
    
    
    /* FOR v_part_eje_fin IN (
    	select 
        pe.id_partida_ejecucion,
        cc.codigo_tcc,
        cc.id_centro_costo,
        p.codigo,
        p.id_partida,
        cc.gestion,
        pe.monto as total_PE
        from pre.tpartida_ejecucion pe
        JOIN param.vcentro_costo cc on cc.id_centro_costo=pe.id_presupuesto
        JOIN pre.tpartida p on p.id_partida=pe.id_partida
        where 
        pe.tipo_movimiento='formulado'
        and cc.gestion=p_id_gestion AND pe.nro_tramite like '%FP%'
        and pe.monto>0
        AND cc.id_centro_costo!=11396        
        order by cc.id_centro_costo,p.id_partida,pe.id_partida_ejecucion
    ) LOOP
    
        UPDATE pre.tpartida_ejecucion
        SET monto=v_id_caja_v2[v_sw_1]::numeric,monto_mb=v_id_caja_v2[v_sw_1]::numeric
        WHERE id_partida_ejecucion=v_part_eje_fin.id_partida_ejecucion;
        v_sw_1=v_sw_1+1;
        raise notice '=%, =%, = %, = %, =%, =%,  = %, ',
        v_part_eje_fin.codigo_tcc,
        v_part_eje_fin.id_centro_costo,
        v_part_eje_fin.codigo,
        v_part_eje_fin.id_partida,
        v_sw_1,v_id_caja_v2[v_sw_1],v_part_eje_fin.id_partida_ejecucion;
        
	END LOOP;*/
    --raise notice 'total==>>%,%',v_part_eje.id_presup_partida,v_part_eje.id_centro_costo,v_part_eje.id_partida,;
	RETURN v_total;


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
PARALLEL UNSAFE
COST 100;