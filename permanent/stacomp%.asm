  STACOMP*:  , NAME,
c
с программа "Mонитор-80" ИAЭ
с
  INFLOAD*:,LC,4
c INFLOAD*:LC,BLOCK,ALOAD,INFLOA,INFMD,INFDM
  STLOAD* :  , SUBP,
  TRNAME* :  , LC  ,0
  TRCAT*  :  , LC  ,17
  STCAT*  :  , LC  ,1
  ASTL*   :  , LC  ,1
  LUN*MON :  , SUBP,
c :,EQU,TRCAT* - ошибка dtran
 *1      :  ,BLOCК,M1,M2,M3,M4,M5,M6,M7,M8,M9
 , CONT,M10,M11,M12,M13,M14,M15
                   M9, VTM ,по*м9
 есть*ли*трн  :  , UZA ,не*задан
            , ATX ,TRNAME*
 не*задан  :  , ITA ,M13
            , XTS ,17B
            , ASN ,64+10
            , ASN ,64-10
            , ATI ,M11
         M11, UTM ,2000B
         M11, MTJ ,M12
         M10, VTM ,TRCAT*
            , ITA ,M11
            , ASN ,64-20
            , AOX ,INFLOAD*+2 .INFMD
         M15, ATX ,1
         M15, *70 ,1
         M14, VTM ,TWRLIB  .=TEXTWRITLIB*
         M13, VJM ,dncomp
            , UZA ,НET*WRITLIB
         M14, VTM ,TSPUNCH  .=TEXTSTPUNCН*
         M13, VJM ,dncomp
            , U1A ,STPUNCH
         M14, VTM ,TНET*STPUNCH  .=6ННET ST
         M13, VJM ,уход
 STPUNCH  :M9, UJ  ,
 по*м9  :  , XTA ,77B
            , AEX ,INFLOAD*+2 .INFMD
            , UTC ,е18п1  .=77 7777
            , AAX ,
            , UZA ,TRNAME
            , ITA ,M12
            , ASN ,64-20
            , AOX ,77B
         M15, ATX ,1
         M15, *70 ,1
 TRNAME:M14,VTM,TRNAME*
         M13, VJM ,dncomp
            , UZA ,обнули
         M14, VTM ,STLOAD*
            , ITA ,M14
            , ATX ,ASTL*
         M14, VTM ,
            , UJ  ,обнул1и
c
 обнули  :  , XTA ,
            , ATX ,ASTL*
         M14, VTM ,1
            , UJ  ,обнул1и
c
 обнул1и  :  , XTA ,
         M10, ATX ,
         M15, WTC ,
            , UJ  ,
C======================================
 DINCOMP*:  ,ENTRУ,
C======================================
          M9, VTM ,обнули
            , UJ  ,есть*ли*трн
 dncomp:M12,MTJ,M11
 dncom1p:M11,XTA,
         M13, UZA ,
         M14, AEX ,
            , UZA ,dnco1mp
         M11, UTM ,2
            , UJ  ,dncom1p
c
 dnco1mp:M11,XTA,1
            , UTC ,е15п1  .=7 7777
            , AAX ,
         M15, ATX ,1
 dnc1omp:M11,XTA,
         M10, ATX ,
         M11, XTA ,1
         M10, ATX ,1
         M11, UTM ,2 .слиа
         M10, UTM ,2
         M11, XTA ,
            , UZA ,продолжен
         M11, XTA ,1
            , UTC ,е15п1  .=7 7777
            , AAX ,
         M15, AEX ,1 .нтж
            , UZA ,продолжен
         M15, AEX ,1
         M11, AEX ,1
            , UZA ,продолжен
         M10, MTJ ,M14
         M14, UTM ,-16
         M14, V1M ,dnc1omp .пино
         M14, VTM ,TКAT*ПEPEП  .=6НКAT ПE
         M13, VJM ,уход
            , SJ  ,
 продолжен:M15,XTA,1
         M13, UJ  , .внешняя процедура?
 уход  :  , ITS ,M14
         M14, UTM ,2
            , ITS ,M14
         M14, VTM ,2
            , ITS ,M14
            , UJ  ,LUN*MON
 НET*WRITLIB:M14,VTM,TНET*WRITLIB.=6ННET WR
         M13, VJM ,уход
            , SJ  ,
 TWRLIB  :  , TEXT,8НWRITLIB*
 TSPUNCH  :  , TEXT,8НSTPUNCН*
 TКAT*ПEPEП  :  , ISO ,18НКAT ПEPEП.
 TНET*STPUNCH  :  , ISO ,18ННET STPUNCН
 TНET*WRITLIB  :  , ISO ,18ННET WRITLIB*
 е15п1  :  , LOG ,7 7777
 е18п1  :  , LOG ,77 7777
            , END ,
