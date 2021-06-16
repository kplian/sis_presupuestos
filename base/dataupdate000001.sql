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
--rollback
--"id_partida_ejecucion"	"fecha"
--"1743428"	"05/01/2021"
--"1743429"	"05/01/2021"
--"1743435"	"08/01/2021"
--"1743436"	"08/01/2021"
--"1743437"	"08/01/2021"
--"1743438"	"08/01/2021"
--"1743453"	"14/01/2021"
--"1743454"	"14/01/2021"
--"1743459"	"24/01/2021"
--"1743460"	"24/01/2021"
--"1743461"	"24/01/2021"
--"1743462"	"24/01/2021"
--"1743664"	"31/01/2021"
--"1743665"	"31/01/2021"
--"1743666"	"31/01/2021"
--"1743667"	"31/01/2021"
--"1743677"	"31/01/2021"
--"1743678"	"31/01/2021"
--"1743679"	"31/01/2021"
--"1743680"	"31/01/2021"
--"1743681"	"31/01/2021"
--"1743682"	"31/01/2021"
--"1743683"	"31/01/2021"
--"1743684"	"31/01/2021"
--"1743685"	"31/01/2021"
--"1743686"	"31/01/2021"
--"1743687"	"31/01/2021"
--"1743688"	"31/01/2021"
--"1743689"	"31/01/2021"
--"1743690"	"31/01/2021"
--"1743692"	"31/01/2021"
--"1743693"	"31/01/2021"
--"1743694"	"31/01/2021"
--"1743695"	"31/01/2021"
--"1743696"	"31/01/2021"
--"1743697"	"31/01/2021"
--"1743698"	"31/01/2021"
--"1743699"	"31/01/2021"
--"1743700"	"31/01/2021"
--"1743702"	"31/01/2021"
--"1743703"	"31/01/2021"
--"1743704"	"31/01/2021"
--"1743705"	"31/01/2021"
--"1743706"	"31/01/2021"
--"1743708"	"31/01/2021"
--"1743709"	"31/01/2021"
--"1743712"	"31/01/2021"
--"1743715"	"31/01/2021"
--"1743716"	"31/01/2021"
--"1743719"	"31/01/2021"
--"1743722"	"31/01/2021"
--"1743725"	"31/01/2021"
--"1743728"	"31/01/2021"
--"1743731"	"31/01/2021"
--"1743737"	"31/01/2021"
--"1743739"	"31/01/2021"
--"1743740"	"31/01/2021"
--"1743741"	"31/01/2021"
--"1743742"	"31/01/2021"
--"1743743"	"31/01/2021"
--"1743744"	"31/01/2021"
--"1743746"	"31/01/2021"
--"1743747"	"31/01/2021"
--"1743748"	"31/01/2021"
--"1743749"	"31/01/2021"
--"1743750"	"31/01/2021"
--"1743751"	"31/01/2021"
--"1743752"	"31/01/2021"
--"1743753"	"31/01/2021"
--"1743755"	"31/01/2021"
--"1743756"	"31/01/2021"
--"1743757"	"31/01/2021"
--"1743759"	"31/01/2021"
--"1743760"	"31/01/2021"
--"1743761"	"31/01/2021"
--"1743762"	"31/01/2021"
--"1743763"	"31/01/2021"
--"1743764"	"31/01/2021"
--"1743765"	"31/01/2021"
--"1743766"	"31/01/2021"
--"1743767"	"31/01/2021"
--"1743768"	"31/01/2021"
--"1743769"	"31/01/2021"
--"1743770"	"31/01/2021"
--"1743771"	"31/01/2021"
--"1743772"	"31/01/2021"
--"1743774"	"31/01/2021"
--"1743775"	"31/01/2021"
--"1743776"	"31/01/2021"
--"1743777"	"31/01/2021"
--"1743778"	"31/01/2021"
--"1743779"	"31/01/2021"
--"1743780"	"31/01/2021"
--"1743781"	"31/01/2021"
--"1743782"	"31/01/2021"
--"1743783"	"31/01/2021"
--"1743784"	"31/01/2021"
--"1743785"	"31/01/2021"
--"1743786"	"31/01/2021"
--"1743787"	"31/01/2021"
--"1743788"	"31/01/2021"
--"1743789"	"31/01/2021"
--"1743790"	"31/01/2021"
--"1743791"	"31/01/2021"
--"1743793"	"31/01/2021"
--"1743794"	"31/01/2021"
--"1743795"	"31/01/2021"
--"1743796"	"31/01/2021"
--"1743797"	"31/01/2021"
--"1743798"	"31/01/2021"
--"1743799"	"31/01/2021"
--"1743800"	"31/01/2021"
--"1743801"	"31/01/2021"
--"1743803"	"31/01/2021"
--"1743804"	"31/01/2021"
--"1743805"	"31/01/2021"
--"1743806"	"31/01/2021"
--"1743807"	"31/01/2021"
--"1743809"	"31/01/2021"
--"1743810"	"31/01/2021"
--"1743811"	"31/01/2021"
--"1743812"	"31/01/2021"
--"1743813"	"31/01/2021"
--"1743814"	"31/01/2021"
--"1743815"	"31/01/2021"
--"1743816"	"31/01/2021"
--"1743817"	"31/01/2021"
--"1743818"	"31/01/2021"
--"1743820"	"31/01/2021"
--"1743822"	"31/01/2021"
--"1743823"	"31/01/2021"
--"1743824"	"31/01/2021"
--"1743825"	"31/01/2021"
--"1743826"	"31/01/2021"
--"1743827"	"31/01/2021"
--"1743829"	"31/01/2021"
--"1743830"	"31/01/2021"
--"1743831"	"31/01/2021"
--"1743832"	"31/01/2021"
--"1743833"	"31/01/2021"
--"1743834"	"31/01/2021"
--"1743835"	"31/01/2021"
--"1743836"	"31/01/2021"
--"1743838"	"31/01/2021"
--"1743839"	"31/01/2021"
--"1743840"	"31/01/2021"
--"1743842"	"31/01/2021"
--"1743843"	"31/01/2021"
--"1743844"	"31/01/2021"
--"1743845"	"31/01/2021"
--"1743846"	"31/01/2021"
--"1743847"	"31/01/2021"
--"1743848"	"31/01/2021"
--"1743849"	"31/01/2021"
--"1743850"	"31/01/2021"
--"1743851"	"31/01/2021"
--"1743852"	"31/01/2021"
--"1743853"	"31/01/2021"
--"1743854"	"31/01/2021"
--"1743855"	"31/01/2021"
--"1743892"	"01/02/2021"
--"1743893"	"01/02/2021"
--"1743918"	"10/02/2021"
--"1743919"	"10/02/2021"
--"1743920"	"10/02/2021"
--"1743921"	"10/02/2021"
--"1743922"	"10/02/2021"
--"1743923"	"10/02/2021"
--"1743924"	"10/02/2021"
--"1743925"	"10/02/2021"
--"1743982"	"14/02/2021"
--"1743983"	"14/02/2021"
--"1743984"	"14/02/2021"
--"1743985"	"14/02/2021"
--"1743986"	"14/02/2021"
--"1743987"	"14/02/2021"
--"1743988"	"14/02/2021"
--"1743989"	"14/02/2021"
--"1744014"	"23/02/2021"
--"1744015"	"23/02/2021"
--"1744016"	"23/02/2021"
--"1744017"	"23/02/2021"
--"1744018"	"23/02/2021"
--"1744019"	"23/02/2021"
--"1744020"	"23/02/2021"
--"1744021"	"23/02/2021"
--"1744022"	"23/02/2021"
--"1744023"	"23/02/2021"
--"1744024"	"23/02/2021"
--"1744025"	"23/02/2021"
--"1744026"	"23/02/2021"
--"1744027"	"23/02/2021"
--"1744028"	"23/02/2021"
--"1744029"	"23/02/2021"
--"1744030"	"23/02/2021"
--"1744031"	"23/02/2021"
--"1744032"	"23/02/2021"
--"1744033"	"23/02/2021"
--"1744034"	"23/02/2021"
--"1744035"	"23/02/2021"
--"1744036"	"23/02/2021"
--"1744037"	"23/02/2021"
--"1744082"	"25/02/2021"
--"1744083"	"25/02/2021"
--"1744084"	"25/02/2021"
--"1744085"	"25/02/2021"
--"1744086"	"25/02/2021"
--"1744087"	"25/02/2021"
--"1744088"	"25/02/2021"
--"1744089"	"25/02/2021"
--"1744252"	"28/02/2021"
--"1744253"	"28/02/2021"
--"1744254"	"28/02/2021"
--"1744255"	"28/02/2021"
--"1744256"	"28/02/2021"
--"1744257"	"28/02/2021"
--"1744258"	"28/02/2021"
--"1744259"	"28/02/2021"
--"1744260"	"28/02/2021"
--"1744261"	"28/02/2021"
--"1744262"	"28/02/2021"
--"1744263"	"28/02/2021"
--"1744264"	"28/02/2021"
--"1744265"	"28/02/2021"
--"1744266"	"28/02/2021"
--"1744267"	"28/02/2021"
--"1744268"	"28/02/2021"
--"1744269"	"28/02/2021"
--"1744270"	"28/02/2021"
--"1744271"	"28/02/2021"
--"1744272"	"28/02/2021"
--"1744273"	"28/02/2021"
--"1744274"	"28/02/2021"
--"1744275"	"28/02/2021"
--"1744276"	"28/02/2021"
--"1744277"	"28/02/2021"
--"1744278"	"28/02/2021"
--"1744279"	"28/02/2021"
--"1744280"	"28/02/2021"
--"1744281"	"28/02/2021"
--"1744282"	"28/02/2021"
--"1744283"	"28/02/2021"
--"1744284"	"28/02/2021"
--"1744286"	"28/02/2021"
--"1744287"	"28/02/2021"
--"1744288"	"28/02/2021"
--"1744289"	"28/02/2021"
--"1744290"	"28/02/2021"
--"1744291"	"28/02/2021"
--"1744292"	"28/02/2021"
--"1744293"	"28/02/2021"
--"1744295"	"28/02/2021"
--"1744296"	"28/02/2021"
--"1744298"	"28/02/2021"
--"1744299"	"28/02/2021"
--"1744300"	"28/02/2021"
--"1744302"	"28/02/2021"
--"1744303"	"28/02/2021"
--"1744304"	"28/02/2021"
--"1744305"	"28/02/2021"
--"1744307"	"28/02/2021"
--"1744308"	"28/02/2021"
--"1744309"	"28/02/2021"
--"1744310"	"28/02/2021"
--"1744311"	"28/02/2021"
--"1744312"	"28/02/2021"
--"1744313"	"28/02/2021"
--"1744315"	"28/02/2021"
--"1744316"	"28/02/2021"
--"1744317"	"28/02/2021"
--"1744318"	"28/02/2021"
--"1744319"	"28/02/2021"
--"1744320"	"28/02/2021"
--"1744321"	"28/02/2021"
--"1744322"	"28/02/2021"
--"1744323"	"28/02/2021"
--"1744325"	"28/02/2021"
--"1744326"	"28/02/2021"
--"1744327"	"28/02/2021"
--"1744328"	"28/02/2021"
--"1744329"	"28/02/2021"
--"1744330"	"28/02/2021"
--"1744331"	"28/02/2021"
--"1744333"	"28/02/2021"
--"1744334"	"28/02/2021"
--"1744335"	"28/02/2021"
--"1744336"	"28/02/2021"
--"1744337"	"28/02/2021"
--"1744338"	"28/02/2021"
--"1744339"	"28/02/2021"
--"1744340"	"28/02/2021"
--"1744341"	"28/02/2021"
--"1744342"	"28/02/2021"
--"1744343"	"28/02/2021"
--"1744344"	"28/02/2021"
--"1744345"	"28/02/2021"
--"1744346"	"28/02/2021"
--"1744347"	"28/02/2021"
--"1744348"	"28/02/2021"
--"1744349"	"28/02/2021"
--"1744350"	"28/02/2021"
--"1744351"	"28/02/2021"
--"1744352"	"28/02/2021"
--"1744353"	"28/02/2021"
--"1744354"	"28/02/2021"
--"1744355"	"28/02/2021"
--"1744356"	"28/02/2021"
--"1744357"	"28/02/2021"
--"1744358"	"28/02/2021"
--"1744359"	"28/02/2021"
--"1744360"	"28/02/2021"
--"1744361"	"28/02/2021"
--"1744362"	"28/02/2021"
--"1744363"	"28/02/2021"
--"1744364"	"28/02/2021"
--"1744365"	"28/02/2021"
--"1744367"	"28/02/2021"
--"1744368"	"28/02/2021"
--"1744369"	"28/02/2021"
--"1744370"	"28/02/2021"
--"1744371"	"28/02/2021"
--"1744372"	"28/02/2021"
--"1744373"	"28/02/2021"
--"1744374"	"28/02/2021"
--"1744376"	"28/02/2021"
--"1744377"	"28/02/2021"
--"1744379"	"28/02/2021"
--"1744380"	"28/02/2021"
--"1744381"	"28/02/2021"
--"1744383"	"28/02/2021"
--"1744384"	"28/02/2021"
--"1744385"	"28/02/2021"
--"1744386"	"28/02/2021"
--"1744388"	"28/02/2021"
--"1744389"	"28/02/2021"
--"1744390"	"28/02/2021"
--"1744391"	"28/02/2021"
--"1744392"	"28/02/2021"
--"1744393"	"28/02/2021"
--"1744394"	"28/02/2021"
--"1744396"	"28/02/2021"
--"1744397"	"28/02/2021"
--"1744398"	"28/02/2021"
--"1744399"	"28/02/2021"
--"1744400"	"28/02/2021"
--"1744401"	"28/02/2021"
--"1744402"	"28/02/2021"
--"1744403"	"28/02/2021"
--"1744404"	"28/02/2021"
--"1744406"	"28/02/2021"
--"1744407"	"28/02/2021"
--"1744408"	"28/02/2021"
--"1744409"	"28/02/2021"
--"1744410"	"28/02/2021"
--"1744411"	"28/02/2021"
--"1744412"	"28/02/2021"
--commit

UPDATE pre.tpartida_ejecucion
set fecha = '31/03/2021'::Date
where id_partida_ejecucion in (1743832, 1743749, 1743810, 1743760, 1743709,
  1743843, 1743748, 1743759, 1743831, 1743842, 1743708, 1743809, 1743798,
  1743697, 1743770, 1743853, 1743796, 1743695, 1743769, 1743694, 1743799,
  1743795, 1743698, 1743852, 1743829, 1743827, 1743722, 1743744, 1743815,
  1743746, 1743826, 1743725, 1743743, 1743830, 1743816, 1743747, 1743741,
  1743715, 1743756, 1743824, 1743839, 1743812, 1743811, 1743712, 1743757,
  1743825, 1743742, 1743840, 1743776, 1743690, 1743666, 1743775, 1743791,
  1743774, 1743783, 1743689, 1743665, 1743664, 1743790, 1743682, 1743750,
  1743805, 1743777, 1743817, 1743704, 1743667, 1743728, 1743685, 1743778,
  1743677, 1743786, 1743833, 1743787, 1743679, 1743678, 1743780, 1743834,
  1743779, 1743751, 1743703, 1743804, 1743686, 1743818, 1743731, 1743739,
  1743807, 1743835, 1743782, 1743784, 1743822, 1743752, 1743688, 1743706,
  1743681, 1743789, 1743683, 1743740, 1743785, 1743680, 1743705, 1743788,
  1743806, 1743753, 1743823, 1743687, 1743836, 1743684, 1743781, 1743459,
  1743461, 1743462, 1743460, 1743435, 1743437, 1743436, 1743438, 1743453,
  1743454, 1743768, 1743851, 1743429, 1743428, 1743766, 1743719, 1743797,
  1743814, 1743849, 1743696, 1743838, 1743755, 1743844, 1743820, 1743761,
  1743700, 1743850, 1743767, 1743737, 1743801, 1743716, 1743772, 1743848,
  1743854, 1743813, 1743765, 1743771, 1743855, 1743846, 1743763, 1743803,
  1743702, 1743699, 1743800, 1743693, 1743794, 1743793, 1743692, 1743762,
  1743845, 1743764, 1743847, 1744407, 1744326, 1743985, 1743982, 1743984,
  1743986, 1743988, 1743989, 1743987, 1743983, 1743892, 1743893, 1744412,
  1744331, 1744290, 1744371, 1744289, 1744370, 1743920, 1743923, 1743918,
  1743921, 1743925, 1743919, 1743924, 1743922, 1744411, 1744330, 1744409,
  1744328, 1744085, 1744088, 1744087, 1744089, 1744084, 1744082, 1744086,
  1744083, 1744390, 1744401, 1744259, 1744309, 1744376, 1744295, 1744262,
  1744352, 1744390, 1744401, 1744271, 1744320, 1744344, 1744270, 1744260,
  1744308, 1744341, 1744377, 1744351, 1744296, 1744389, 1744263, 1744402,
  1744321, 1744338, 1744350, 1744372, 1744291, 1744399, 1744257, 1744258,
  1744305, 1744386, 1744269, 1744339, 1744318, 1744304, 1744255, 1744349,
  1744292, 1744373, 1744319, 1744268, 1744336, 1744385, 1744256, 1744400,
  1744337, 1744362, 1744252, 1744253, 1744335, 1744358, 1744254, 1744334,
  1744354, 1744273, 1744333, 1744277, 1744281, 1744392, 1744404, 1744380,
  1744311, 1744299, 1744323, 1744300, 1744403, 1744381, 1744322, 1744310,
  1744391, 1744313, 1744394, 1744302, 1744315, 1744383, 1744396, 1744384,
  1744397, 1744393, 1744303, 1744312, 1744316, 1744026, 1744024, 1744028,
  1744014, 1744016, 1744036, 1744029, 1744015, 1744027, 1744025, 1744017,
  1744037, 1744022, 1744032, 1744020, 1744034, 1744030, 1744018, 1744035,
  1744031, 1744021, 1744033, 1744019, 1744023, 1744388, 1744307, 1744288,
  1744363, 1744298, 1744379, 1744369, 1744282, 1744327, 1744408, 1744406,
  1744317, 1744325, 1744329, 1744293, 1744374, 1744410, 1744398, 1744359,
  1744342, 1744261, 1744276, 1744278, 1744353, 1744272, 1744357, 1744368,
  1744266, 1744346, 1744265, 1744347, 1744287, 1744264, 1744267, 1744286,
  1744345, 1744367, 1744348, 1744283, 1744274, 1744355, 1744360, 1744279,
  1744364, 1744284, 1744365, 1744275, 1744361, 1744356, 1744280,1744340,1744343);

/********************************************F-DAUP-MGM-PRE-ETR-3598-12/04/2021********************************************/

/********************************************I-DAUP-MMV-PRE-ETR-3405-19/04/2021********************************************/
/*select c.id_tipo_cc, c.id_tipo_cc_fk
from param.ttipo_cc c
where c.id_tipo_cc in (4064);*/

update param.ttipo_cc set
id_tipo_cc_fk = 1045
where id_tipo_cc in (4064);
/********************************************F-DAUP-MMV-PRE-ETR-3405-19/04/2021********************************************/

/********************************************I-DAUP-EGS-PRE-ETR-3813-30/04/2021********************************************/
-- Se ejecuto directo en base de datos por el apuro
-- update pre.tajuste_det set id_ajuste = 3659 where id_ajuste = 3658;
/********************************************F-DAUP-EGS-PRE-ETR-3813-30/04/2021********************************************/
/********************************************I-DAUP-MGM-PRE-ETR-4270-15/06/2021********************************************/
select from pre.f_update_pres_part_eje(2021);
/********************************************F-DAUP-MGM-PRE-ETR-4270-15/06/2021********************************************/
/********************************************I-DAUP-MGM-PRE-ETR-4289-16/06/2021********************************************/
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11731,4420,-167754.874499999,'decremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11730,4420,-75258.9255000025,'decremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11729,4420,-36128.6399999994,'decremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,10452,4420,666.530000000027,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,10434,4420,1836.83000000013,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,9975,4420,1094.36999999998,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,10438,4420,869.29999999993,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,9972,4420,425.490000000005,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,10020,4420,241.279999999955,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,10019,4420,583.890000000043,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,10436,4420,1984.01999999996,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11239,4420,262.859999999986,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11240,4420,3594.69999999984,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11241,4420,0.0200000000186265,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11245,4420,201.369999999966,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11246,4420,734.170000000006,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,10456,4420,457.080000000074,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,10070,4420,1109.08999999971,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11242,4420,154.799999999967,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,10435,4420,366.789999999994,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11248,4420,824.300000000003,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11250,4420,554.890000000014,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,10433,4420,557.320000000022,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,10453,4420,2551.76000000013,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,10437,4420,526.959999999919,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11690,4420,1707.05999999998,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,10442,4420,245.74,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,10027,4420,175.280000000013,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,10021,4420,2262.38999999996,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,10443,4420,383.159999999989,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,10447,4420,149.150000000001,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,10125,4420,213.489999999947,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,10446,4420,350.470000000001,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,9977,4420,455.660000000033,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,10941,4420,302.87999999999,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,10449,4420,0.0199999999822467,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,10450,4420,101.639999999998,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,10451,4420,1844.76999999999,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11234,4420,402.25999999998,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,10411,4420,168.189999999995,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11233,4420,1030.65999999997,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,10943,4420,47.9400000000041,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11016,4420,80.2499999999927,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11259,4420,146.559999999983,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11257,4420,340.379999999917,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11261,4420,163.819999999996,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11262,4420,147.829999999998,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11251,4420,582.850000000006,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,10330,4420,47.96,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11263,4420,415.78999999995,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11253,4420,31.1500000000087,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11256,4420,1283.70000000001,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11254,4420,955.520000000077,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11264,4420,985.959999999948,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11255,4420,1041.62000000005,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11265,4420,232.62,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11249,4420,234.039999999994,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11508,4420,0.0100000000093132,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,9803,4420,641.460000000283,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,10077,4420,992.06000000007,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,10323,4420,6665.19999999995,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11069,4420,916.249999999942,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11086,4420,2480.06,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11091,4420,354.77000000003,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11081,4420,86.1100000000006,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11068,4420,1892.86999999994,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,9899,4420,683.539999999979,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,9902,4420,1734.85000000003,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11097,4420,251.649999999972,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11098,4420,40.95999999997,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,9969,4420,66.3100000000268,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11102,4420,809.86000000003,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11104,4420,0.00999999998748535,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11109,4420,0.0100000000020373,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11110,4420,162.269999999997,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11111,4420,949.079999999987,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,10119,4420,1910.81,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,9843,4420,1086.55000000002,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11002,4420,0.019999999972697,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11122,4420,0.00999999998748535,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11125,4420,104.609999999961,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11100,4420,86.3300000000345,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,10121,4420,698.219999999965,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11085,4420,591.149999999994,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11072,4420,511.180000000167,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11087,4420,192.789999999921,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11079,4420,903.440000000497,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11070,4420,424.939999999886,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11094,4420,399.659999999974,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11071,4420,212.129999999968,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11082,4420,26.9800000000014,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11073,4420,63.96000000001,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11083,4420,0.0100000000002183,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,10354,4420,147.130000000092,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,10355,4420,284.089999999935,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11084,4420,250.789999999979,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,10357,4420,57.8300000000781,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,10320,4420,126.35999999995,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,10321,4420,55.6499999998914,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,10356,4420,98.8899999999958,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,9842,4420,141.450000000084,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,10358,4420,523.12999999999,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11078,4420,59.3499999999995,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,9938,4420,422.240000000016,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11089,4420,5.45696821063757E-11,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11077,4420,60.7100000000082,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11006,4420,74.0500000000002,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,10364,4420,690.810000000005,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11126,4420,46.809999999994,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11127,4420,0.0299999999915599,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11128,4420,0.0299999999842839,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,10371,4420,2256.28000000001,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11130,4420,620.669999999925,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,10361,4420,46.8400000000256,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,10372,4420,81.9400000000169,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,9939,4420,1206.98,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,9943,4420,1903.29000000001,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,9940,4420,140.449999999968,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11143,4420,0.0500000000320142,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11009,4420,102.060000000003,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11134,4420,2228.14000000004,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11140,4420,495.669999999809,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11147,4420,0.00999999999476131,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,10362,4420,0.0399999999790452,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11148,4420,160.829999999998,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11149,4420,50.2400000000307,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11150,4420,78.7899999999863,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11151,4420,24.5599999999777,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,10390,4420,129.670000000075,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11152,4420,0.0200000000331784,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,9973,4420,363.339999999986,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11153,4420,65.1300000000083,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11141,4420,0.0500000000974978,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11157,4420,33.1800000000294,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11163,4420,382.200000000041,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11165,4420,0.00999999999476131,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11173,4420,47.1699999999655,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11184,4420,615.779999999984,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11192,4420,0.0200000000022555,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,10412,4420,99.530000000017,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,10406,4420,56.010000000053,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,10409,4420,206.690000000021,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11176,4420,76.6899999999987,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,9944,4420,5.00222085975111E-11,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,10013,4420,45.9600000000055,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,10166,4420,1630.88,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,10366,4420,183.700000000048,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11187,4420,136.740000000289,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11188,4420,116.039999999972,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11182,4420,0.00999999996020051,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11183,4420,37.2499999999982,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,10391,4420,102.069999999949,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,10167,4420,279.300000000003,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,10394,4420,555.940000000002,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,10400,4420,0.0399999999608553,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,10393,4420,349.690000000068,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,10414,4420,24.0200000000004,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,10415,4420,109.820000000058,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11190,4420,0.0200000000077125,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,9941,4420,0.0200000000095315,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,9942,4420,145.880000000016,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,10407,4420,503.599999999969,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11179,4420,0.0399999999899592,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11199,4420,33.1699999999673,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11200,4420,0.029999999980646,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,10404,4420,0.0199999999640568,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,10216,4420,163.640000000032,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11178,4420,1116.67000000015,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11196,4420,0.0200000000022555,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,10405,4420,1922.12000000017,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,10392,4420,1379.61000000002,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,9945,4420,792.48999999999,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,10408,4420,1374.78000000017,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,10897,4420,789.000000000015,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,10017,4420,535.26999999996,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11574,4420,0.0199999999999818,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,10342,4420,137.140000000001,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11202,4420,2130.52999999979,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,9602,4420,1099.12999999996,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11204,4420,189.300000000192,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11207,4420,258.139999999963,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,10432,4420,1341.7300000002,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11208,4420,1317.89999999979,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11205,4420,0.0099999999620195,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,9951,4420,1333.52999999997,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,9780,4420,82378.0299999989,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,9912,4420,2477.76000000088,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,9810,4420,4168.70999999926,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11216,4420,1038.37999999998,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,9809,4420,5544.95000000007,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11602,4420,959.01999999999,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,10478,4420,999.72999999969,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,10477,4420,95.54,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,9660,4420,713.589999999997,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,10018,4420,488.429999999934,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,10985,4420,307.920000000042,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11053,4420,7809.02000000316,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11026,4420,4175.94999999984,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,10892,4420,9797.43999999947,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11062,4420,11227.3099999998,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,9799,4420,4091.62000000023,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11041,4420,9059,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,10893,4420,733.379999999976,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11042,4420,3189.09999999986,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11054,4420,7127.87000000023,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11526,4420,2633.08000000007,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,9839,4420,5037.59999999974,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11025,4420,906.510000000228,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11093,4420,792.460000000006,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11407,4420,1077.35999999999,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,10969,4420,984.069999999585,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11032,4420,215.860000000077,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11044,4420,78.5600000000049,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11050,4420,78.560000000014,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,9991,4420,1380.71999999994,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11391,4420,1353.11000000002,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,9796,4420,4130.62999999931,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11057,4420,1799.59999999998,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11436,4420,1703.30999999998,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11058,4420,810.360000000292,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,9634,4420,1056.51999999983,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11027,4420,1632.79000000003,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);
insert into pre.tajuste_det (id_usuario_reg,fecha_reg,estado_reg,id_presupuesto,id_partida,importe,tipo_ajuste,id_ajuste) values(1, '15/06/2021 15:00:00'::TIMESTAMP,'activo'::varchar,11059,4420,372.889999999963,'incremento', (select aj.id_ajuste from pre.tajuste aj where aj.nro_tramite='AJT-000230-2021')::integer);

/********************************************F-DAUP-MGM-PRE-ETR-4289-16/06/2021********************************************/