    PRINT8  :  , NAME,
c
c Cтандартная программа MC Дубна.
с Полностью изменена в версии для Mонитора-80
с
   MON*ITOR:  , SUBP,
   SAVE*НID:  , SUBP,
   OН*     :  , SUBP,
   PLBEG   :  , SUBP,
   ISO/GOST:  , SUBP,
   PLCLO   :  , SUBP,
   ASAVE*  :  , SUBP,
   FOR*ALL :  , SUBP,
    *1      :  ,BLOCК,M1,M2,M3,M4,M5,M6,M7,M8,M9
            , CONT,M10,M11,M12,M13,M14,M15
C======================================
               PRINT80 :  ,ENTRУ,
C======================================
            , ITS ,M14 .м14 - базовый?
            , WTC ,72B
         M14, VTM ,
         M14, UTC ,1
         M14, V1M ,
         M14, VJM ,SAVE*НID
         M14, VTM ,PRINT80a
         M12, VTM ,uhod
          M4, VTM ,-128 .сч. символов в строке?
            , UJ  ,MON*ITOR
 PRINT80a:M15,ATX,
          M6, VTM ,-2
 PRINT80b:M11,VTM,-48
         M14, VTM ,PERECOD
 PRINTDIAG  :  , UTC ,TPRINT  .=:2474 4012 3643 006
          M6, XTA ,
         M11, ASN ,64+56
         M14, AAX ,13B
         M15, AEX ,-1
            , UZA ,PRINT80d
         M11, UTM ,20B
         M11, V1M ,PRINTDIAG
          M6, VLM ,PRINT80b
         M15, XTA ,
            , UJ  ,PERECOD
 PRINT80d  :M7, VTM ,17B
            , ITA ,M7
         M13, MTJ ,M7
         M13, VJM ,PLCLO
         M15, UTM ,-1
            , UTC ,TPRINT  .=:2474 4012 3643 006
          M6, XTA ,
         M11, ASN ,64+48
         M14, AAX ,13B
          M7, UJ  ,
 PERECOD  :  , UZA ,MON*ITOR
         M14, VJM ,OН*
         M14, VTM ,PERECOD
            , UJ  ,ISO/GOST
 uhod:M14,VTM,pechat
          M7, VTM ,172B
            , UJ  ,FOR*ALL
 pechat:M14,VTM,pechat
         M14, *64 ,2
         M13, UJ  ,
         :M8, ATX ,
          M8, Z00 ,-1
            , ATX ,
          M8, ATX ,
            , LOG ,1410 6061 4023 2204
            , LOG ,1530 2466 4142 5612
c TPRINT  :  , iso,6h'012'ы'002'of'003'
 TPRINT  :  , OCT ,2474 4012 3643 006
            , LOG ,377
            , END ,
