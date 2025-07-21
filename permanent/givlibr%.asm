     GIVLIBR*:  , NAME,
      MONCARD*:  , LC  ,1
      RM*     :  , LC  ,5
      LTABLE* :  , SUBP,
      STABLE* :  , SUBP,
      LOADANGO:  , SUBP,
 *1:  ,BLOCК,M1,M2,M3,M4,M5,M6,M7,M8,M9
      , CONT,M10,M11,M12,M13,M14,M15
         M12, VTM ,LTABLE*
         M14, VTM ,обмен
 gvlbr:M12,XTA,
         M13, UZA ,
            , AEX ,MONCARD*
         M14, UZA ,
         M12, UTM ,2 .LTABLE+2=LIBDRUM
            , UJ  ,gvlbr
c
 обмен  :  , ITA ,M13
            , ATX ,для*M13
            , XTA ,47B
            , ATX ,адр47
            , XTA ,RM*+4
            , ATX ,47B
            , *70 ,46B
         M12, XTS ,1
         M13, VJM ,LOADANGO
            , *70 ,45B
            , XTA ,адр47
            , ATX ,47B
 снова:M14,VTM,
            , WTC ,для*M13
            , UJ  ,
C======================================
 GIVSERV*:  ,ENTRУ,
C======================================
         M12, VTM ,STABLE*
         M14, VTM ,чт*таблиц
            , UJ  ,gvlbr
 чт*таблиц  :  , ITA ,M13
            , ATX ,для*M13
         M12, XTS ,1 .чт. табл. с 1-й поз. по M12
         M13, VJM ,LOADANGO
            , UJ  ,снова
 адр47  :   , BSS ,1
 для*M13  : , BSS ,1
            , END ,
