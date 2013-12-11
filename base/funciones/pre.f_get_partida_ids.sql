CREATE OR REPLACE FUNCTION pre.f_get_partida_ids (
  p_id_partida integer,
  p_tipo varchar = 'siguiente'::character varying
)
RETURNS integer AS
$body$
/*
Autor: RCM
Fecha: 09/12/2013
Descripción: Función que devuelve el id_partida equivalente anterior o siguiente de la tabla pre.tpartida_ids
*/

DECLARE

	v_id_partida integer;

BEGIN
	
	if p_id_partida is null then
    	return null;
    end if;
	--1.Verificación de existencia de la partida
    if not exists(select 1 from pre.tpartida
    			where id_partida = p_id_partida) then
    	raise exception 'Partida inexistente';
    end if;
    
    --Se verifica si se busca la cuenta anterior o la siguiente
    if p_tipo = 'siguiente' then
    	--Obtiene la cuenta de la siguiente gestión
        select p.id_partida_dos
        into v_id_partida
        from pre.tpartida_ids p
        where p.id_partida_uno = p_id_partida;
    else
    	--Obtiene la cuenta anterior
        select p.id_partida_uno
        into v_id_partida
        from pre.tpartida_ids p
        where p.id_partida_dos = p_id_partida;
    end if;
    
    return v_id_partida;

END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;