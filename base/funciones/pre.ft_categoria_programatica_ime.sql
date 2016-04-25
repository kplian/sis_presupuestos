--------------- SQL ---------------

CREATE OR REPLACE FUNCTION pre.ft_categoria_programatica_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Presupuesto
 FUNCION: 		pre.ft_categoria_programatica_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'pre.tcategoria_programatica'
 AUTOR: 		 (admin)
 FECHA:	        19-04-2016 15:30:34
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
	v_mensaje_error         text;
	v_id_categoria_programatica	integer;
			    
BEGIN

    v_nombre_funcion = 'pre.ft_categoria_programatica_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PRE_CPR_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		19-04-2016 15:30:34
	***********************************/

	if(p_transaccion='PRE_CPR_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into pre.tcategoria_programatica(
			id_cp_actividad,
			id_gestion,
			id_cp_organismo_fin,
			descripcion,
			id_cp_programa,
			id_cp_fuente_fin,
			estado_reg,
			id_cp_proyecto,
			id_usuario_ai,
			fecha_reg,
			usuario_ai,
			id_usuario_reg,
			fecha_mod,
			id_usuario_mod
          	) values(
			v_parametros.id_cp_actividad,
			v_parametros.id_gestion,
			v_parametros.id_cp_organismo_fin,
			v_parametros.descripcion,
			v_parametros.id_cp_programa,
			v_parametros.id_cp_fuente_fin,
			'activo',
			v_parametros.id_cp_proyecto,
			v_parametros._id_usuario_ai,
			now(),
			v_parametros._nombre_usuario_ai,
			p_id_usuario,
			null,
			null
							
			
			
			)RETURNING id_categoria_programatica into v_id_categoria_programatica;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Categoría Programatica almacenado(a) con exito (id_categoria_programatica'||v_id_categoria_programatica||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_categoria_programatica',v_id_categoria_programatica::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'PRE_CPR_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		19-04-2016 15:30:34
	***********************************/

	elsif(p_transaccion='PRE_CPR_MOD')then

		begin
			--Sentencia de la modificacion
			update pre.tcategoria_programatica set
			id_cp_actividad = v_parametros.id_cp_actividad,
			id_gestion = v_parametros.id_gestion,
			id_cp_organismo_fin = v_parametros.id_cp_organismo_fin,
			descripcion = v_parametros.descripcion,
			id_cp_programa = v_parametros.id_cp_programa,
			id_cp_fuente_fin = v_parametros.id_cp_fuente_fin,
			id_cp_proyecto = v_parametros.id_cp_proyecto,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario,
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_categoria_programatica=v_parametros.id_categoria_programatica;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Categoría Programatica modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_categoria_programatica',v_parametros.id_categoria_programatica::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'PRE_CPR_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		19-04-2016 15:30:34
	***********************************/

	elsif(p_transaccion='PRE_CPR_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from pre.tcategoria_programatica
            where id_categoria_programatica=v_parametros.id_categoria_programatica;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Categoría Programatica eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_categoria_programatica',v_parametros.id_categoria_programatica::varchar);
              
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