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
    v_id_dos				integer;
    v_id_gestion_destino	integer;
    v_registros         	record;
    v_registros_ges      	record;
    v_conta 				integer;
			    
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
     /*********************************    
 	#TRANSACCION:  'PRE_CLCARPRO_IME'
 	#DESCRIPCION:	Clona las categorias programaticas para la siguiente gestion
 	#AUTOR:	    Rensi Arteaga Copari
 	#FECHA:		24/07/2017
	***********************************/

	elsif(p_transaccion='PRE_CLCARPRO_IME')then

		begin
			
            --  definir id de la gestion siguiente
    
           select
              ges.id_gestion,
              ges.gestion,
              ges.id_empresa
           into 
              v_registros_ges
           from 
           param.tgestion ges
           where ges.id_gestion = v_parametros.id_gestion;
          
          
          
           select
              ges.id_gestion
           into 
              v_id_gestion_destino
           from 
           param.tgestion ges
           where       ges.gestion = v_registros_ges.gestion + 1 
                   and ges.id_empresa = v_registros_ges.id_empresa 
                   and ges.estado_reg = 'activo';
           
          IF v_id_gestion_destino is null THEN        
                   raise exception 'no se encontró una siguiente gestión preparada (primero cree  gestión siguiente)';
          END IF;
          v_conta = 0;
          
          -----------------------------------------------
          -- duplicar PROGRAMAS  pre.tcp_programa_ids 
          ---------------------------------------------
          
          
            FOR v_registros in (
                                  select 
                                      p.* 
                                  from pre.tcp_programa p 
                                  where  p.id_gestion = v_parametros.id_gestion   
                                        and p.estado_reg = 'activo') LOOP
                                        
                      -- preguntamos si ya existe en la tabla de ids                    
                     IF NOT EXISTS ( 
                                     select 1 from pre.tcp_programa_ids i 
                                     where i.id_cp_programa_uno = v_registros.id_cp_programa  )  THEN 
                                   
                                   INSERT INTO 
                                      pre.tcp_programa
                                    (
                                      id_usuario_reg,
                                      fecha_reg,
                                      estado_reg,
                                      codigo,
                                      descripcion,
                                      id_gestion
                                    )
                                    VALUES (
                                      p_id_usuario,
                                      now(),
                                      'activo',
                                      v_registros.codigo,
                                      v_registros.descripcion,
                                      v_id_gestion_destino
                                    ) RETURNING id_cp_programa into v_id_dos;
                                    
                                   INSERT INTO pre.tcp_programa_ids 
                                       (id_cp_programa_uno, id_cp_programa_dos, sw_cambio_gestion ) 
                                  VALUES 
                                       ( v_registros.id_cp_programa, v_id_dos, 'gestion');
                                 
                     
                     
                     END IF;              
          
        
        
           END LOOP;
          
          
          -----------------------------------------------
          -- duplicar PROYECTOS  pre.tcp_proyecto_ids 
          ---------------------------------------------
          
          
            FOR v_registros in (
                                  select 
                                      p.* 
                                  from pre.tcp_proyecto p 
                                  where  p.id_gestion = v_parametros.id_gestion   
                                        and p.estado_reg = 'activo') LOOP
                                        
                      -- preguntamos si ya existe en la tabla de ids                    
                     IF NOT EXISTS ( 
                                     select 1 from pre.tcp_proyecto_ids i 
                                     where i.id_cp_proyecto_uno = v_registros.id_cp_proyecto  )  THEN 
                                   
                                   INSERT INTO 
                                            pre.tcp_proyecto
                                          (
                                            id_usuario_reg,
                                            fecha_reg,
                                            estado_reg,
                                            codigo,
                                            descripcion,
                                            id_gestion,
                                            codigo_sisin
                                          )
                                          VALUES (
                                            p_id_usuario,
                                            now(),
                                            'activo',
                                            v_registros.codigo,
                                            v_registros.descripcion,
                                            v_id_gestion_destino,
                                            v_registros.codigo_sisin
                                          ) RETURNING id_cp_proyecto   into v_id_dos;
                                   
                                  
                                    
                                   INSERT INTO pre.tcp_proyecto_ids 
                                       (id_cp_proyecto_uno, id_cp_proyecto_dos, sw_cambio_gestion ) 
                                  VALUES 
                                       ( v_registros.id_cp_proyecto, v_id_dos, 'gestion');
                     END IF;              
           END LOOP;
           
           
          -----------------------------------------------
          -- duplicar ACTIVIDADES  pre.tcp_actividad_ids 
          ---------------------------------------------
          
          
            FOR v_registros in (
                                  select 
                                      p.* 
                                  from pre.tcp_actividad p 
                                  where  p.id_gestion = v_parametros.id_gestion   
                                        and p.estado_reg = 'activo') LOOP
                                        
                      -- preguntamos si ya existe en la tabla de ids                    
                     IF NOT EXISTS ( 
                                     select 1 from pre.tcp_actividad_ids i 
                                     where i.id_cp_actividad_uno = v_registros.id_cp_actividad  )  THEN 
                                   INSERT INTO 
                                            pre.tcp_actividad
                                          (
                                            id_usuario_reg,
                                            fecha_reg,
                                            estado_reg,
                                            codigo,
                                            descripcion,
                                            id_gestion
                                          )
                                          VALUES (
                                            p_id_usuario,
                                            now(),
                                            'activo',
                                            v_registros.codigo,
                                            v_registros.descripcion,
                                            v_id_gestion_destino
                                          ) RETURNING id_cp_actividad   into v_id_dos;
                                   
                                  
                                    
                                   INSERT INTO pre.tcp_actividad_ids 
                                       (id_cp_actividad_uno, id_cp_actividad_dos, sw_cambio_gestion ) 
                                  VALUES 
                                       ( v_registros.id_cp_actividad, v_id_dos, 'gestion');
                     END IF;              
           END LOOP;
           
           -----------------------------------------------
          -- duplicar FUENTE FIN  pre.tcp_fuente_fin_ids 
          ---------------------------------------------
          
          
            FOR v_registros in (
                                  select 
                                      p.* 
                                  from pre.tcp_fuente_fin p 
                                  where  p.id_gestion = v_parametros.id_gestion   
                                        and p.estado_reg = 'activo') LOOP
                                        
                      -- preguntamos si ya existe en la tabla de ids                    
                     IF NOT EXISTS ( 
                                     select 1 from pre.tcp_fuente_fin_ids i 
                                     where i.id_cp_fuente_fin_uno = v_registros.id_cp_fuente_fin  )  THEN 
                                   
                                   INSERT INTO 
                                            pre.tcp_fuente_fin
                                          (
                                            id_usuario_reg,
                                            fecha_reg,
                                            estado_reg,
                                            codigo,
                                            descripcion,
                                            id_gestion
                                          )
                                          VALUES (
                                            p_id_usuario,
                                            now(),
                                            'activo',
                                            v_registros.codigo,
                                            v_registros.descripcion,
                                            v_id_gestion_destino
                                          ) RETURNING id_cp_fuente_fin   into v_id_dos;
                                   
                                  
                                    
                                   INSERT INTO pre.tcp_fuente_fin_ids 
                                       (id_cp_fuente_fin_uno, id_cp_fuente_fin_dos, sw_cambio_gestion ) 
                                  VALUES 
                                       ( v_registros.id_cp_fuente_fin, v_id_dos, 'gestion');
                     END IF;              
           END LOOP;
           
     


          -----------------------------------------------
          -- duplicar ORGANISMO FIN  pre.tcp_organismo_fin_ids 
          ---------------------------------------------
          
          
            FOR v_registros in (
                                  select 
                                      p.* 
                                  from pre.tcp_organismo_fin p 
                                  where  p.id_gestion = v_parametros.id_gestion   
                                        and p.estado_reg = 'activo') LOOP
                                        
                      -- preguntamos si ya existe en la tabla de ids                    
                     IF NOT EXISTS ( 
                                     select 1 from pre.tcp_organismo_fin_ids i 
                                     where i.id_cp_organismo_fin_uno = v_registros.id_cp_organismo_fin  )  THEN 
                                   INSERT INTO 
                                              pre.tcp_organismo_fin
                                            (
                                              id_usuario_reg,
                                              fecha_reg,
                                              estado_reg,
                                              codigo,
                                              descripcion,
                                              id_gestion
                                            )
                                            VALUES (
                                              p_id_usuario,
                                              now(),
                                              'activo',
                                              v_registros.codigo,
                                              v_registros.descripcion,
                                              v_id_gestion_destino
                                            ) RETURNING id_cp_organismo_fin   into v_id_dos;
                                   
                                  
                                    
                                   INSERT INTO pre.tcp_organismo_fin_ids 
                                       (id_cp_organismo_fin_uno, id_cp_organismo_fin_dos, sw_cambio_gestion ) 
                                  VALUES 
                                       ( v_registros.id_cp_organismo_fin, v_id_dos, 'gestion');
                     END IF;              
           END LOOP;


          ----------------------------------
          --  CLONAR CATEGORIA PROGRAMATICA
          ---------------------------------
          
          
          
            
            --clonamos presupuestos y centros de costos
            FOR v_registros in (
                                  select 
                                      p.* ,
                                      pro.id_cp_programa_dos,
                                      py.id_cp_proyecto_dos,
                                      act.id_cp_actividad_dos,
                                      fue.id_cp_fuente_fin_dos,
                                      org.id_cp_organismo_fin_dos
                                      
                                  from pre.tcategoria_programatica p 
                                  inner join pre.tcp_programa_ids pro on pro.id_cp_programa_uno = p.id_cp_programa
                                  inner join pre.tcp_proyecto_ids py on py.id_cp_proyecto_uno = p.id_cp_proyecto
                                  inner join pre.tcp_actividad_ids act on act.id_cp_actividad_uno = p.id_cp_actividad
                                  inner join pre.tcp_fuente_fin_ids fue on fue.id_cp_fuente_fin_uno = p.id_cp_fuente_fin
                                  inner join pre.tcp_organismo_fin_ids org on org.id_cp_organismo_fin_uno = p.id_cp_organismo_fin
                                  where  p.id_gestion = v_parametros.id_gestion   
                                        and p.estado_reg = 'activo') LOOP
                                        
                        
                 
                              
                    -- preguntamos si ya existe en la tabla de ids                    
                     IF NOT EXISTS ( 
                     select 1 from pre.tcategoria_programatica_ids i 
                     where i.id_categoria_programatica_uno = v_registros.id_categoria_programatica  )  THEN
                       
                         -- clonamos el centro de costos
                         
                                  INSERT INTO 
                                          pre.tcategoria_programatica
                                        (
                                          id_usuario_reg,
                                          fecha_reg,
                                          estado_reg,
                                          id_gestion,
                                          descripcion,
                                          id_cp_programa,
                                          id_cp_proyecto,
                                          id_cp_actividad,
                                          id_cp_fuente_fin,
                                          id_cp_organismo_fin
                                        )
                                        VALUES (
                                          p_id_usuario,
                                          now(),
                                          'activo',
                                          v_id_gestion_destino,
                                          v_registros.descripcion,
                                          v_registros.id_cp_programa_dos,
                                          v_registros.id_cp_proyecto_dos,
                                          v_registros.id_cp_actividad_dos,
                                          v_registros.id_cp_fuente_fin_dos,
                                          v_registros.id_cp_organismo_fin_dos
                                        )RETURNING id_categoria_programatica   into v_id_dos;
                                        
                                  INSERT INTO pre.tcategoria_programatica_ids (id_categoria_programatica_uno, id_categoria_programatica_dos, sw_cambio_gestion ) 
                                  VALUES ( v_registros.id_categoria_programatica, v_id_dos, 'gestion');
                                  
                                  v_conta = v_conta + 1;
                                   
                     END IF;
                                       
            END LOOP;
        
        
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Categorias clonadas para la gestion: '||v_registros_ges.gestion::varchar); 
            v_resp = pxp.f_agrega_clave(v_resp,'observaciones','Se insertaron categorias: '|| v_conta::varchar);
              
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