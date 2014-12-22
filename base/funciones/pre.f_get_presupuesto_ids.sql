--------------- SQL ---------------

CREATE OR REPLACE FUNCTION pre.f_get_presupuesto_ids (
  p_id_presupuesto integer,
  p_tipo varchar = 'siguiente'::character varying
)
RETURNS integer AS
$body$
/*
Autor: RAC
Fecha: 03/12/2014
Descripción: Función que devuelve el v_id_presupuesto equivalente anterior o siguiente de la tabla pre.tpresupuestos_ids
*/

DECLARE
    v_resp varchar;
    v_nombre_funcion varchar;
	v_id_presupuesto integer;

BEGIN

   v_nombre_funcion = 'conta.f_get_presupuesto_ids';
   
	
	if p_id_presupuesto is null then
    	return null;
    end if;
	--1.Verificación de existencia de la partida
    if not exists(select 1 from pre.tpresupuesto
    			where id_presupuesto = p_id_presupuesto) then
    	raise exception 'Partida inexistente';
    end if;
    
    --Se verifica si se busca la cuenta anterior o la siguiente
    if p_tipo = 'siguiente' then
    	--Obtiene la cuenta de la siguiente gestión
        select p.id_presupuesto_dos
        into v_id_presupuesto
        from pre.tpresupuesto_ids p
        where p.id_presupuesto_uno = p_id_presupuesto;
    else
    	--Obtiene la cuenta anterior
        select p.id_presupuesto_uno
        into v_id_presupuesto
        from pre.tpresupuesto_ids p
        where p.id_presupuesto_dos = p_id_presupuesto;
    end if;
    
    return v_id_presupuesto;
    
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