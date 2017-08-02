--------------- SQL ---------------

CREATE OR REPLACE FUNCTION pre.f_verificacion_presup_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS SETOF record AS
$body$
/**************************************************************************
PXP
***************************************************************************
 SCRIPT: 		pre.f_verificacion_presup_sel
 DESCRIPCIÓN: 	Verificación de disponibilidad presupuestaria sea en sistema de PXP o endesis si esta sincronizado para despliegue en ventana de consulta
 AUTOR: 		RCM
 FECHA:			19/12/2013
 COMENTARIOS:	
***************************************************************************
 HISTORIA DE MODIFICACIONES:

 DESCRIPCIÓN:
 AUTOR:       
 FECHA:      

***************************************************************************/
--------------------------
-- CUERPO DE LA FUNCIÓN --
--------------------------

-- PARÁMETROS FIJOS
/*
pm_id_usuario                               integer (si))
pm_ip_origen                                varchar(40) (si)
pm_mac_maquina                              macaddr (si)
pm_log_error                                varchar -- log -- error //variable interna (si)
pm_codigo_procedimiento                     varchar  // valor que identifica el tipo
                                                        de operacion a realizar
                                                        insert  (insertar)
                                                        delete  (eliminar)
                                                        update  (actualizar)
                                                        select  (visualizar)
pm_proc_almacenado                          varchar  // para colocar el nombre del procedimiento en caso de ser llamado
                                                        por otro procedimiento
*/

DECLARE

	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;
    v_rec  				record;  -- PARA ALMACENAR EL CONJUNTO DE DATOS RESULTADO DEL SELECT
    pm_criterio_filtro 	varchar;
    v_sql				varchar;
    v_cadena_cnx		varchar;
    v_res_cone  		varchar;
    
    v_dat 				record;
    v_cont 				integer;
    va_id_centro_costo 	integer[];
    va_id_partida 		integer[];
    va_id_moneda 		integer[];
    va_importe 			numeric[];
    v_sincronizar 		varchar;

BEGIN


    v_nombre_funcion = 'pre.f_verificacion_presup_sel';
    v_parametros = pxp.f_get_record(p_tabla);
    
	/*********************************    
 	#TRANSACCION:  'PRE_VERPRE_SEL'
 	#DESCRIPCION:	Verifica la disponibilidad presupuestaria, consultando el saldo por comprometer
 	#AUTOR:			RCM	
 	#FECHA:			27/12/2013
	***********************************/

	if(p_transaccion='PRE_VERPRE_SEL')then
     				
    	begin
        
        	--Verificación de bandera de sincronización
            v_sincronizar = pxp.f_get_variable_global('sincronizar');    
            
            if v_sincronizar='true' then
                --------------------------------------------
                --(1)PERSONALIZACION DE CONSULTA POR TABLA
                --------------------------------------------
                if v_parametros.tabla = 'tes.tplan_pago' then
            	
                    --Verificación de existencia de ID
                    if not exists(select 1 from tes.tplan_pago
                                where id_plan_pago = v_parametros.id) then
                        raise exception 'Cuota inexistente';
                    end if;
        		    
                    --Define la consulta que debe devolver estos campos: id_partida, id_centro_costo,id_moneda,importe
                    v_sql = 'select
                              obl.id_partida,
                              obl.id_centro_costo,
                              param.f_get_moneda_base() as id_moneda,
                              sum(pro.monto_ejecutar_mb) as importe
                              from tes.tplan_pago pla
                              inner join tes.tprorrateo pro on pro.id_plan_pago = pla.id_plan_pago
                              inner join tes.tobligacion_det obl on obl.id_obligacion_det = pro.id_obligacion_det
                              where pla.id_plan_pago = ' || v_parametros.id || '
                              group by obl.id_partida,obl.id_centro_costo';
            	
                elsif v_parametros.tabla = 'tes.tobligacion_pago' then
                
                    v_sql = 'select
                            od.id_partida,
                            od.id_centro_costo,
                            op.id_moneda,
                            sum(od.monto_pago_mo) as importe
                            from tes.tobligacion_pago op
                            inner join tes.tobligacion_det od
                            on od.id_obligacion_pago = op.id_obligacion_pago
                            where op.id_obligacion_pago = ' || v_parametros.id || '
                            group by od.id_partida, od.id_centro_costo, op.id_moneda';
                            
                            --raise exception '%',v_sql;
            	
                else
            	
                    raise exception 'Verificación presupuestaria para % no implementada',v_parametros.tabla;
            	
                end if;
            	
                -----------------------------------------------------
                --(2)OBTENCION DE LOS DATOS DE LA CONSULTA POR TABLA
                -----------------------------------------------------
                v_cont = 1;
                for v_dat in execute(v_sql) loop
                                
                    va_id_partida[v_cont]=v_dat.id_partida;
                    va_id_centro_costo[v_cont]=v_dat.id_centro_costo;
                    va_id_moneda[v_cont]=v_dat.id_moneda;
                    va_importe[v_cont]=v_dat.importe;
                    v_cont = v_cont + 1;
                      
                end loop;
                
                ------------------------------------------------
                --(3)VERIFICACION DE DISPONIBILIDAD EN ENDESIS
                ------------------------------------------------
                --Forma la llamada para enviar los datos al servidor destino
                v_sql:='select 
                        id_partida,
                        id_presupuesto,
                        id_moneda,
                        importe,
                        disponibilidad
                        from migracion.f_pxp_verificar_presup('||
                            COALESCE(('array['|| array_to_string(va_id_partida, ',')||']::integer[]')::varchar,'NULL::integer[]')||',
                            '||COALESCE(('array['|| array_to_string(va_id_centro_costo, ',')||']::integer[]')::varchar,'NULL::integer[]')||',
                            '||COALESCE(('array['|| array_to_string(va_id_moneda, ',')||']::integer[]')::varchar,'NULL::integer[]')||',
                            '||COALESCE(('array['|| array_to_string(va_importe, ',')||']::numeric[]')::varchar,'NULL::numeric[]')||')
                        as (id_partida integer,
                        id_presupuesto integer,
                        id_moneda integer,
                        importe numeric,
                        disponibilidad varchar)';
                              

                --Obtención de cadana de conexión
                v_cadena_cnx =  migra.f_obtener_cadena_conexion();
                  
                --Abrir conexión
                v_resp = dblink_connect(v_cadena_cnx);

                IF v_resp!='OK' THEN
                    raise exception 'FALLO LA CONEXION A LA BASE DE DATOS CON DBLINK';
                END IF;
                
                --Crear una tabla temporal
                create temp table tt_result_verif(
                    id_partida integer,
                    id_presupuesto integer,
                    id_moneda integer,
                    importe numeric,
                    disponibilidad varchar
                ) on commit drop;
                
                --Ejecuta la función remotamente e inserta en la tabla temporal
                insert into tt_result_verif
                select
                id_partida,
                id_presupuesto,
                id_moneda,
                importe,
                disponibilidad
                from dblink(v_sql, true)
                as (id_partida integer,id_presupuesto integer,id_moneda integer,importe numeric,disponibilidad varchar);
                                
               
                ------------------------------------------------------------
                --(4)RESPUESTA DEL LISTADO CON LA COLUMNA DE DISPONIBLIDAD
                ------------------------------------------------------------
                for v_rec in execute ('select
                            rv.id_partida, rv.id_presupuesto,rv.id_moneda,
                            rv.importe,rv.disponibilidad,
                            pa.codigo || '' - '' || pa.nombre_partida as desc_partida,
                            cc.codigo_cc || '' - '' || cc.nombre_uo as desc_cc
                            from tt_result_verif rv
                            inner join pre.tpartida pa on pa.id_partida = rv.id_partida
                            inner join param.vcentro_costo cc on cc.id_centro_costo = rv.id_presupuesto 
                            order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion) loop        
                    return next v_rec;
                end loop;
                
                --Cierra la conexión abierta
                perform dblink_disconnect();
                
                --Respuesta
                return;
                
            else
            
                --TODO, implementar verificacion presupuestaria en PXP
                raise exception 'Gestion  presupuestaria en PXP no implementada';
            
            end if;
						
		end;
    
    
 END IF;


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
COST 100 ROWS 1000;