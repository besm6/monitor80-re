 MON*ITOR:  , NAME,
c
с программа "Mонитор-80" ИAЭ
с
 PLBEG   :  , SUBP,
 PLCLO   :  , SUBP,
 *1      :  ,BLOCК,M1,M2,M3,M4,M5,M6,M7,M8,M9
            , CONT,M10,M11,M12,M13,M14,M15
c
c выделение буфера
c
 MON*ITO1  :M1, VZM ,MON*ITO2 .пио
          M1, UTM ,-1 .слиа
          M7, VTM ,40B .уиа
            , ITA ,M7 .счи
            , UJ  ,MON*ITO3
 MON*ITO2  :M4, VZM ,MON*ITO4 .пио
         M13, VJM ,PLBEG .пв
 MON*ITO3:M14,UTC, .мода
         M13, VJM ,
         M13, VJM ,PLCLO
 MON*ITO4  :M4, VLM ,MON*ITO1 .цикл
         M12, UJ  ,
C======================================
 PLBEG   :  ,ENTRУ,
C======================================
          M5, V1M ,PLBE1G
          M5, VTM ,60B
            , ITA ,M3
          M2, AEX ,
          M3, UTM ,1
         M12, UZA ,
 PLBE1G  :M5, UTM ,-8
          M3, XTA ,-1
          M5, ASN ,64-40
            , ASN ,64+40
         M13, UJ  ,
C======================================
 PLCLO   :  ,ENTRУ,
C======================================
         M10, V1M ,PLCL1O
         M10, VTM ,-48
          M9, UTM ,1
            , XTS ,
          M9, STX ,-1
 PLCL1O:M10,UTM,10B
         M10, ASN ,64
          M9, AOX ,-1
          M9, ATX ,-1
         M13, UJ  ,
C======================================
 ASAVE*  :  ,ENTRУ,
C======================================
 ASAVE1  :M2, MTJ ,M15
         M15, UTM ,20B
         M15, XTA ,
          M1, VTM ,15B
 ASAVE2  :M1, STI ,M1
          M1, UTM ,-1
          M1, V1M ,ASAVE2
         M15, UTM ,-3
            , STI ,M1
         M13, UJ  ,
C======================================
 SAVE*НID:  ,ENTRУ,
C======================================
         M15, ATX ,15B
            , ITA ,M1
          M1, VTM ,-12
 SAVE*НID1  :M1, ITS ,M14
          M1, VLM ,SAVE*НID1
         M15, UTM ,1
         M15, XTA ,-17
            , ATI ,M3
         M15, MTJ ,M2
          M2, UTM ,-16
          M2, XTA ,
            , UTC ,B1  .=1
            , ARX ,
          M2, ATX ,
         M15, XTA ,-15
            , ATI ,M1
         M15, MTJ ,M8
          M8, UTM ,12B
          M8, MTJ ,M9
          M5, VTM ,
         M10, VTM ,
          M8, MTJ ,M6
         M11, VTM ,-56
          M6, UTM ,1
         M14, UJ  ,
C======================================
 FOR*ALL :  ,ENTRУ,
C======================================
            , ITA ,M7
         M13, VJM ,PLCLO
         M13, VTM ,ASAVE1
         M14, UJ  ,
C======================================
 OН*     :  ,ENTRУ,
C======================================
            , ATI ,M7
          M7, UTM ,-10
         M12, UTC ,
          M7, VZM ,
          M7, UTM ,-22
          M7, VZM ,OH*A
         M10, MTJ ,M11
          M9, MTJ ,M6
 OH*A:M14,UJ,
C======================================
 OН*1    :  ,ENTRУ,
C======================================
         M11, VZM ,OH*1A
         M11, UTM ,10B
         M11, V1M ,OH*1B
         M11, VTM ,-8
 OH*1A  :M6, UTM ,1
         M11, UTM ,-40
 OH*1B:M11,UTM,10B
            , ITA ,M7
         M11, ASN ,64
          M6, AEX ,-1
          M6, ATX ,-1
         M14, UJ  ,
 B1  :  , LOG ,1
            , END ,
