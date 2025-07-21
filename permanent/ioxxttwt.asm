 IOXXTTWT:  , NAME,
c
с программа "Mонитор-80" ИAЭ
с
 SAVE*НID:  , SUBP,
 MON*ITOR:  , SUBP,
 ISO/GOST:  , SUBP,
 ASAVE*  :  , SUBP,
 OН*     :  , SUBP,
 OН*1    :  , SUBP,
 FOR*ALL :  , SUBP,
 TSTATE* :  , LC  ,1
 *1      :  ,BLOCК,M1,M2,M3,M4,M5,M6,M7,M8,M9
            , CONT,M10,M11,M12,M13,M14,M15
         M15, XTA ,-3
         M15, XTS ,-3
         M15, ATX ,-4
         M15, XTA ,-2
         M15, ATX ,-3
            , XTA ,
         M15, STX ,-2
            , UJ  ,TTPRIN1T
C======================================
 TTPRINTD:  ,ENTRУ,
C======================================
 TTPRINT :  ,ENTRУ,
C======================================
C   П/П HИЖHEГO YPOBHЯ ДЛЯ BЫBOДA HA TEPMИ-
C   HAЛ ПO ФOPTPAHHOMY OПEPATOPY WRITE(54,)
c
            , XTS ,
 TTPRIN1T  :  , UTC ,RABOCH
            , STX ,
            , ITS ,M14
         M14, VJM ,SAVE*НID
         M12, VTM ,TTPRIN3T
         M14, VTM ,TTPRIN2T
          M4, VTM ,77560B
            , UJ  ,MON*ITOR
 TTPRIN2T  :  , UZA ,MON*ITOR
         M14, VJM ,OН*
         M14, VTM ,TTPRIN2T
            , UJ  ,ISO/GOST
 TTPRIN3T  :M7, VTM ,17B
         M14, VJM ,FOR*ALL
          M7, VTM ,165B
         M14, VJM ,OН*1
         M13, VTM ,TTPRIK2S
          M1, VTM ,TSTATE*
C======================================
 TTPRIКS :  ,ENTRУ,
C======================================
 TTPRIK1S:M12,VTM,TTPRIK1S
         :  , UTC ,
 :M12,*71,56B
            , ANX ,
         M15, ATX ,
            , ASN ,64-12
         M15, ATX ,
         M12, AOX ,46B
         M12, ATX ,46B
         M12, AOX ,52B
         M12, STX ,52B
         M12, AOX ,47B
         M12, STX ,47B
         M15, ATX ,
         M12, AOX ,50B
         M12, STX ,50B
         M12, AOX ,51B
         M12, ATX ,51B
         M13, UJ  ,
 TTPRIK2S  :M1, XTA ,
            , UZA ,TTPRIK3S
         M12, AEX ,60B
            , UZA ,TTPRIK4S
 TTPRIK3S  :M3, UTM ,-1
         M12, *71 ,47B
            , ASN ,64-22
            , ASN ,64+45
         M12, AEX ,55B
          M1, ATX ,
 TTPRIK4S  :  , WTC ,B16  .=16
         M14, VTM ,-1
         M14, VZM ,TTPRIK5S
            , ITA ,M14
         M12, ATX ,53B
            , UJ  ,TTPRIK8S
 TTPRIK5S  :  , XTA ,
          M1, ATX ,
          M8, MTJ ,M3
         M12, XTA ,45B
          M3, ATX ,
         M12, *71 ,52B
         M12, *71 ,50B
          M3, XTA ,
            , ASN ,64+40
            , ATI ,M14
         M14, UTM ,-37
         M14, VZM ,20B
         M14, UTM ,3
         M14, V1M ,TTPRIK6S
         M12, *71 ,51B
          M7, VTM ,5
            , ITA ,M7
          M1, ATX ,
            , UJ  ,TTPRIK8S
 TTPRIK6S:M14,UTM,77443B
         M12, XTA ,54B
         M14, VZM ,TTPRIK7S
         M14, UTM ,377B .абзац?
            , ITA ,M14
         M12, AAX ,57B
 TTPRIK7S:M12,ATX,54B
         M12, ATX ,53B
 TTPRIK8S  :M1, XTA ,
         M12, ATX ,60B
            , WTC ,RABOCH
         M14, VTM ,
         M14, VZM ,ASAVE*
         M14, ATX ,3
            , UJ  ,ASAVE*
            , GOST,6НCONT’136’’377’
C======================================
 /IP*    :  ,ENTRУ,
C======================================
          M3, RTE ,
          M3, 100 ,27B
          M8, APX ,
          M9, ATX ,
            , 120 ,
            , ATX ,
            , 120 ,2
            , ATX ,
          M3, E+N ,
          M3, 100 ,27B
 B16  :  , LOG ,16
            , LOG ,16
            , LOG ,4
            , LOG ,7777 7777 7777 7777
            , LOG ,17
            , BSS ,1
 RABOCH  :  , BSS ,1
            , END ,
