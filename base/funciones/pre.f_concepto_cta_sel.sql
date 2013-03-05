--------------- SQL ---------------

CREATE OR REPLACE FUNCTION pre.f_concepto_cta_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de presupuesto
 FUNCION: 		pre.f_concepto_cta_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'pre.tconcepto_cta'
 AUTOR: 		Gonzalo Sarmiento Sejas
 FECHA:	        18-02-2013 22:57:58
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:	
 AUTOR:			
 FECHA:		
***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;
			    
BEGIN

	v_nombre_funcion = 'pre.f_concepto_cta_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PRE_CCTA_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		Gonzalo Sarmiento Sejas	
 	#FECHA:		18-02-2013 22:57:58
	***********************************/

	if(p_transaccion='PRE_CCTA_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						 ccta.id_concepto_cta,
                          ccta.estado_reg,
                          ccta.id_auxiliar,
                          ccta.id_cuenta,
                          ccta.id_concepto_ingas,
                          ccta.id_centro_costo,
                          ccta.fecha_reg,
                          ccta.id_usuario_reg,
                          ccta.fecha_mod,
                          ccta.id_usuario_mod,
                          usu1.cuenta as usr_reg,
                          usu2.cuenta as usr_mod,
                          cta.nro_cuenta,
                          cta.nombre_cuenta,
                          ges.gestion as desc_gestion,
                          ges.id_gestion,
                          cc.codigo_cc as desc_centro_costo,
                          aux.codigo_auxiliar ||'' -''||aux.nombre_auxiliar as desc_auxiliar,
                          cta.nro_cuenta ||'' -''||cta.nombre_cuenta as desc_cuenta,
                          par.codigo as codigo_partida,
                          par.nombre_partida as nombre_parida,
                          par.codigo||''-''||ges.gestion as desc_partida	
                          
                          from pre.tconcepto_cta ccta
                          inner join segu.tusuario usu1 on usu1.id_usuario = ccta.id_usuario_reg
                          inner join conta.tcuenta cta on cta.id_cuenta = ccta.id_cuenta
                          inner join param.tgestion ges on ges.id_gestion = cta.id_gestion
                          left join param.vcentro_costo cc on cc.id_centro_costo = ccta.id_centro_costo
                          inner join conta.tauxiliar aux on aux.id_auxiliar = ccta.id_auxiliar 
                          inner join pre.tpartida par on par.id_partida = ccta.id_partida 
                          left join segu.tusuario usu2 on usu2.id_usuario = ccta.id_usuario_mod
    					 where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;


           -- raise exception 'v_consulta';
			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'PRE_CCTA_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		Gonzalo Sarmiento Sejas	
 	#FECHA:		18-02-2013 22:57:58
	***********************************/

	elsif(p_transaccion='PRE_CCTA_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_concepto_cta)
			              from pre.tconcepto_cta ccta
                          inner join segu.tusuario usu1 on usu1.id_usuario = ccta.id_usuario_reg
                          inner join conta.tcuenta cta on cta.id_cuenta = ccta.id_cuenta
                          inner join param.tgestion ges on ges.id_gestion = cta.id_gestion
                          left join param.vcentro_costo cc on cc.id_centro_costo = ccta.id_centro_costo
                          inner join conta.tauxiliar aux on aux.id_auxiliar = ccta.id_auxiliar 
                          inner join pre.tpartida par on par.id_partida = ccta.id_partida 
                          left join segu.tusuario usu2 on usu2.id_usuario = ccta.id_usuario_mod
    					 where ';
			
			--Definicion de la respuesta		    
			v_consulta:=v_consulta||v_parametros.filtro;

			--Devuelve la respuesta
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