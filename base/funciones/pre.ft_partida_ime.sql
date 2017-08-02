--------------- SQL ---------------

CREATE OR REPLACE FUNCTION pre.ft_partida_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de presupuesto
 FUNCION: 		pre.ft_partida_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'pre.tpartida'
 AUTOR: 		 (admin)
 FECHA:	        23-11-2012 20:06:53
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
	v_id_partida			integer;
    
    v_id_partida_fk 		integer;
    v_registros_ges			record;
    v_registros_partida		record;
    v_conta					integer;
    v_id_gestion_destino	integer;
    v_id_partida_fk_des		integer;
    v_reg_partida_ori 		record;
			    
BEGIN

    v_nombre_funcion = 'pre.ft_partida_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PRE_PAR_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		23-11-2012 20:06:53
	***********************************/

	if(p_transaccion='PRE_PAR_INS')then
					
        begin
            if v_parametros.id_partida_fk != 'id' and v_parametros.id_partida_fk !=''  then
            
            v_id_partida_fk = v_parametros.id_partida_fk::integer;
            end if;
        
    
        
        
        	--Sentencia de la insercion
        	insert into pre.tpartida(
			estado_reg,
			id_partida_fk,
			tipo,
			descripcion,
			codigo,
			id_usuario_reg,
			fecha_reg,
			id_usuario_mod,
			fecha_mod,
            id_gestion,
            sw_transaccional,
            sw_movimiento,
            nombre_partida
            
          	) values(
			'activo',
			v_id_partida_fk,
			v_parametros.tipo,
			v_parametros.descripcion,
			v_parametros.codigo,
			p_id_usuario,
			now(),
			null,
			null,
            v_parametros.id_gestion,
            v_parametros.sw_transaccional,
            v_parametros.sw_movimiento,
            v_parametros.nombre_partida
			)RETURNING id_partida into v_id_partida;
               
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Partida almacenado(a) con exito (id_partida'||v_id_partida||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_partida',v_id_partida::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'PRE_PAR_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		23-11-2012 20:06:53
	***********************************/

	elsif(p_transaccion='PRE_PAR_MOD')then

		begin
        
        if v_parametros.id_partida_fk != 'id' and v_parametros.id_partida_fk != '' then
            
            v_id_partida_fk = v_parametros.id_partida_fk::integer;
        end if;
        
			--Sentencia de la modificacion
			update pre.tpartida set
			id_partida_fk = v_id_partida_fk,
			tipo = v_parametros.tipo,
			descripcion = v_parametros.descripcion,
			codigo = v_parametros.codigo,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
            id_gestion=v_parametros.id_gestion,
            sw_transaccional=v_parametros.sw_transaccional,
            sw_movimiento=v_parametros.sw_movimiento,
            nombre_partida=v_parametros.nombre_partida
			where id_partida=v_parametros.id_partida;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Partida modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_partida',v_parametros.id_partida::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'PRE_PAR_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		23-11-2012 20:06:53
	***********************************/

	elsif(p_transaccion='PRE_PAR_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from pre.tpartida
            where id_partida=v_parametros.id_partida;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Partida eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_partida',v_parametros.id_partida::varchar);
              
            --Devuelve la respuesta
            return v_resp;

		end;
    /*********************************    
 	#TRANSACCION:  'PRE_CLONAR_IME'
 	#DESCRIPCION:	Clona las partidas presupeustarias para la gestion siguiente
 	#AUTOR:	    Rensi Arteaga Copari
 	#FECHA:		04-08-2015 15:04:03
	***********************************/

	elsif(p_transaccion='PRE_CLONAR_IME')then

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
                   raise exception 'no se encontró una siguiente gestión preparada (primero cree la gestión)';
          END IF;
          v_conta = 0;
          --  consulta recursiva de cuentas de partidas origen
          FOR v_registros_partida in  (
                     WITH RECURSIVE partida_inf(id_partida, id_partida_fk) AS (
                          select 
                            p.id_partida,
                            p.id_partida_fk
                          from pre.tpartida p  
                          where  p.id_gestion = v_parametros.id_gestion and p.id_partida_fk is NULL and p.estado_reg = 'activo'
                                 
                        UNION
                          SELECT
                            p2.id_partida,
                            p2.id_partida_fk
                          from pre.tpartida p2, partida_inf pc
                          WHERE p2.id_partida_fk = pc.id_partida  and p2.estado_reg = 'activo'
                        )
                       SELECT * FROM partida_inf) LOOP
         
            
            
               --  busca si ya existe la relacion en la tablas de cuentas ids
                  IF NOT EXISTS(select 1 from pre.tpartida_ids i where i.id_partida_uno =  v_registros_partida.id_partida) THEN
                     IF v_registros_partida.id_partida_fk is not null THEN
                        --  busca la cuenta del padre en cuetaids
                         v_id_partida_fk_des  = NULL;
                        
                         select
                           cid.id_partida_dos
                         into
                           v_id_partida_fk_des
                         from pre.tpartida_ids cid
                         where  cid.id_partida_uno = v_registros_partida.id_partida_fk;
                     END IF;
                     --obtiene los dastos de la cuenta origen
                     v_reg_partida_ori = NULL;
                     select * into v_reg_partida_ori from pre.tpartida p where p.id_partida = v_registros_partida.id_partida;
                     --  inserta la cuenta para la nueva gestion
                    INSERT INTO pre.tpartida
                                (
                                  id_usuario_reg,
                                  fecha_reg,
                                  estado_reg,
                                  id_partida_fk,
                                  id_gestion,
                                  id_parametros,
                                  codigo,
                                  nombre_partida,
                                  descripcion,
                                  nivel_partida,
                                  sw_transaccional,
                                  tipo,
                                  sw_movimiento,
                                  cod_trans,
                                  cod_ascii,
                                  cod_excel,
                                  ent_trf
                                )
                                VALUES (
                                  p_id_usuario,
                                  now(),
                                  'activo',
                                  v_id_partida_fk_des,
                                  v_id_gestion_destino,
                                  v_reg_partida_ori.id_parametros,
                                  v_reg_partida_ori.codigo,
                                  v_reg_partida_ori.nombre_partida,
                                  v_reg_partida_ori.descripcion,
                                  v_reg_partida_ori.nivel_partida,
                                  v_reg_partida_ori.sw_transaccional,
                                  v_reg_partida_ori.tipo,
                                  v_reg_partida_ori.sw_movimiento,
                                  v_reg_partida_ori.cod_trans,
                                  v_reg_partida_ori.cod_ascii,
                                  v_reg_partida_ori.cod_excel,
                                  v_reg_partida_ori.ent_trf
                                )RETURNING id_partida into v_id_partida;
                   
                      
                      --insertar relacion en tre ambas gestion
                      INSERT INTO pre.tpartida_ids (id_partida_uno,id_partida_dos, sw_cambio_gestion ) VALUES ( v_registros_partida.id_partida,v_id_partida, 'gestion');
                      v_conta = v_conta + 1;
                  END IF; 
            
               
           
        
             --Definicion de la respuesta
        
        
        
        
           END LOOP;
            
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Plan de cuentas clonado para la gestion: '||v_registros_ges.gestion::varchar); 
            v_resp = pxp.f_agrega_clave(v_resp,'observaciones','Se insertaron cuentas: '|| v_conta::varchar);
              
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