/********************************************I-DAUP-AUTOR-SCHEMA-0-31/02/2019********************************************/
--SHEMA : Esquema (CONTA) contabilidad         AUTHOR:Siglas del autor de los scripts' dataupdate000001.txt
/********************************************F-DAUP-AUTOR-SCHEMA-0-31/02/2019********************************************/

/********************************************I-DAUP-MGM-PRE-0-18/01/2021********************************************/
select from pre.f_update_pres_part_eje(2021);
/********************************************F-DAUP-MGM-PRE-0-18/01/2021********************************************/


/********************************************I-DAUP-MGM-PRE-1-18/01/2021********************************************/
select from pre.f_update_pres_part_eje(2021);
/********************************************F-DAUP-MGM-PRE-1-18/01/2021********************************************/

/********************************************I-DAUP-MGM-PRE-1-19/01/2021********************************************/
select from pre.f_update_pres_part_eje(2021);
/********************************************F-DAUP-MGM-PRE-1-19/01/2021********************************************/

/********************************************I-DAUP-YMR-PRE-2540-27/01/2021********************************************/
update pre.tpresupuesto as p
   set fecha_inicio_pres = TO_DATE('20210101', 'YYYYMMDD'),
       fecha_fin_pres    = TO_DATE('20211231', 'YYYYMMDD'),
       id_categoria_prog = 5
  from param.vcentro_costo as cc
 where p.id_centro_costo = cc.id_centro_costo
   and cc.gestion = 2021
   and p.id_categoria_prog is null;
/********************************************F-DAUP-YMR-PRE-2540-27/01/2021********************************************/

/********************************************I-DAUP-MGM-PRE-1-19/01/2021********************************************/
select from pre.f_update_pres_part_eje(2021);
/********************************************F-DAUP-MGM-PRE-1-19/01/2021********************************************/

/********************************************I-DAUP-MGM-PRE-1-28/01/2021********************************************/
select from pre.f_update_pres_part_eje(2021);
/********************************************F-DAUP-MGM-PRE-1-28/01/2021********************************************/

/********************************************I-DAUP-MGM-PRE-1-29/01/2021********************************************/
select from pre.f_update_pres_part_eje(2021);
/********************************************F-DAUP-MGM-PRE-1-29/01/2021********************************************/


/********************************************I-DAUP-MGM-PRE-ETR-3236-09/03/2021********************************************/
--rollback
--update pre.tpresup_partida set importe=793440,importe_aprobado=793440 where id_partida in (4166) and id_presupuesto in (11396) and id_presup_partida in (372401);
--commit
update pre.tpresup_partida set importe=0,importe_aprobado=0 where id_partida in (4166) and id_presupuesto in (11396) and id_presup_partida in (372401);
/********************************************F-DAUP-MGM-PRE-ETR-3236-09/03/2021********************************************/


/********************************************I-DAUP-MGM-PRE-ETR-3236-10/03/2021********************************************/
--rollback
--UPDATE pre.tpartida_ejecucion SET monto=793440,monto_mb=793440,estado_reg='activo' WHERE id_partida_ejecucion=1641507 and id_partida= 4166 and id_presupuesto= 11396;
--commit
UPDATE pre.tpartida_ejecucion SET monto=0,monto_mb=0,estado_reg='inactivo' WHERE id_partida_ejecucion=1641507 and id_partida= 4166 and id_presupuesto= 11396;

/********************************************F-DAUP-MGM-PRE-ETR-3236-10/03/2021********************************************/


/********************************************I-DAUP-MGM-PRE-ETR-3598-12/04/2021********************************************/
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743832;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743749;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743810;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743760;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743709;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743843;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743748;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743759;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743831;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743842;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743708;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743809;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743798;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743697;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743770;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743853;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743796;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743695;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743769;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743694;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743799;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743795;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743698;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743852;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743829;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743827;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743722;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743744;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743815;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743746;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743826;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743725;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743743;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743830;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743816;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743747;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743741;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743715;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743756;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743824;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743839;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743812;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743811;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743712;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743757;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743825;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743742;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743840;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743776;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743690;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743666;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743775;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743791;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743774;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743783;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743689;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743665;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743664;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743790;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743682;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743750;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743805;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743777;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743817;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743704;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743667;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743728;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743685;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743778;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743677;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743786;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743833;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743787;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743679;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743678;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743780;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743834;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743779;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743751;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743703;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743804;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743686;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743818;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743731;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743739;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743807;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743835;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743782;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743784;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743822;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743752;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743688;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743706;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743681;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743789;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743683;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743740;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743785;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743680;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743705;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743788;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743806;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743753;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743823;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743687;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743836;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743684;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743781;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743459;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743461;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743462;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743460;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743435;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743437;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743436;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743438;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743453;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743454;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743768;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743851;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743429;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743428;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743766;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743719;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743797;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743814;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743849;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743696;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743838;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743755;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743844;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743820;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743761;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743700;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743850;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743767;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743737;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743801;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743716;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743772;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743848;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743854;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743813;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743765;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743771;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743855;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743846;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743763;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743803;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743702;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743699;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743800;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743693;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743794;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743793;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743692;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743762;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743845;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743764;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743847;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744407;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744326;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743985;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743982;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743984;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743986;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743988;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743989;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743987;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743983;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743892;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743893;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744412;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744331;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744290;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744371;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744289;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744370;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743920;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743923;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743918;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743921;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743925;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743919;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743924;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1743922;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744411;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744330;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744409;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744328;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744085;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744088;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744087;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744089;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744084;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744082;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744086;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744083;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744390;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744401;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744259;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744309;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744376;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744295;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744262;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744352;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744390;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744401;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744271;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744320;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744344;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744270;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744260;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744308;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744341;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744377;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744351;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744296;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744389;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744263;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744402;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744321;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744338;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744350;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744372;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744291;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744399;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744257;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744258;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744305;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744386;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744269;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744339;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744318;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744304;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744255;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744349;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744292;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744373;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744319;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744268;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744336;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744385;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744256;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744400;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744337;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744362;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744252;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744253;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744335;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744358;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744254;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744334;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744354;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744273;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744333;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744277;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744281;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744392;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744404;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744380;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744311;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744299;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744323;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744300;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744403;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744381;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744322;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744310;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744391;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744313;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744394;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744302;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744315;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744383;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744396;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744384;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744397;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744393;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744303;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744312;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744316;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744026;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744024;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744028;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744014;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744016;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744036;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744029;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744015;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744027;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744025;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744017;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744037;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744022;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744032;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744020;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744034;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744030;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744018;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744035;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744031;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744021;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744033;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744019;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744023;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744388;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744307;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744288;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744363;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744298;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744379;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744369;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744282;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744327;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744408;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744406;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744317;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744325;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744329;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744293;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744374;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744410;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744398;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744359;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744342;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744261;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744276;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744278;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744353;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744272;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744357;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744368;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744266;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744346;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744265;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744347;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744287;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744264;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744267;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744286;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744345;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744367;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744348;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744283;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744274;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744355;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744360;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744279;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744364;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744284;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744365;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744275;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744361;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744356;
UPDATE pre.tpartida_ejecucion  SET fecha='31/03/2021' WHERE id_partida_ejecucion=1744280;

/********************************************F-DAUP-MGM-PRE-ETR-3598-12/04/2021********************************************/


