 MONREAD*:  , NAME,
c
с стандартная программ MC ДУБНA
с исходный текст утрачен.
с Имеются дополнительные подпрограммы
с Mонитора-80
c
 RFMRTFLG:  , LC  ,1
 STOP*   :  , SUBP,
 MONCARD*:  , LC  ,25
 LUN*MON :  , SUBP,
 КCOUNT* :  , LC  ,4
 *REGIM//:  , LC  ,0
 CLEARLEX:  , SUBP,
 DRUMTAP*:  , SUBP,
 COZУTISO:  , SUBP,
 *1 :  ,BLOCК,M1,M2,M3,M4,M5,M6,M7,M8,M9
    , CONT,M10,M11,M12,M13,M14,M15
c
         M14, VTM ,-12 .13 раз
 mnread:M14,ITS,M13
         M14, VLM ,mnread
 mnrea1d  :M8, VTM ,
          M7, VTM ,
         M10, VTM ,КCOUNT*
         M11, VTM ,mnrea1d
            , XTS ,RFMRTFLG
            , UZA ,ноль*RFMRTFLG
         M13, VJM ,CLEARLEX
            , XTA ,43B
            , ASN ,64-20
         M11, AOX ,70B
         M15, ATX ,1
         M15, *70 ,1
            , XTA ,
            , ATX ,RFMRTFLG
 ноль*RFMRTFLG:M10,XTA,
            , ATI ,M9
 NO*END  :M6, VTM ,TNO*END  .=6НNO *EN
          M9, V1M ,м9*неноль
 в*DRUMTAP:M10,XTA,1
         M13, VJM ,DRUMTAP*
         M10, ATX ,1
          M9, VTM ,76000B
            , UJ  ,обмен
 м9*неноль:M10,XTA,2
            , UZA ,разбор
 обмен  :  , ITA ,
         M10, ATX ,2
         M10, XTA ,3
            , ASN ,64-20
         M10, ARX ,1
         M15, ATX ,1
         M15, *70 ,1
 разбор:M10,WTC,3
          M9, XTA ,2000B .лист?
          M8, ATX ,MONCARD*
          M8, VZM ,разб1ор
 разбо1р  :M8, UTM ,1
          M8, MTJ ,M14
         M14, UTM ,-27
         M14, VZM ,BAD*MON
          M9, UTM ,1
          M7, V1M ,NO*EN1D
         M14, UTM ,13B
         M14, VZM ,NON*TEXT
          M8, XTA ,MONCARD*-1
         M11, AEX ,57B
         M11, AAX ,60B
            , U1A ,NO*END
         M14, VTM ,MONCARD*
            , ITS ,M14
         M13, VJM ,COZУTISO .перекод.
 продолж  :  , ITA ,M9
         M10, ATX ,
            , STI ,
         M14, VTM ,15B
 продол1ж:M14,STI,
         M14, UTM ,-1
         M14, V1M ,продол1ж
         M13, UJ  , .продолжить или нет
c
 разб1ор  :  , XTA ,MONCARD*
         M11, AEX ,57B
            , UZA ,вMOНИTOP
          M8, XTA ,MONCARD*
         M11, AAX ,61B
         M11, AEX ,61B
            , UZA ,в*DRUMTAP
          M8, XTA ,MONCARD*
         M11, AAX ,61B
            , U1A ,разбо1р
          M7, VTM ,1
            , WTC ,MONCARD*
         M12, VTM ,-1 .2 раза
            , UJ  ,разбо1р
 NO*EN1D:M12,VLM,NO*END
            , UJ  ,продолж
 вMOНИTOP  :  , ITS ,M6
          M6, UTM ,1
            , ITS ,M6
            , ITS ,
         M13, VTM ,STOP*
            , UJ  ,LUN*MON
C======================================
 READ*ERR:  ,ENTRУ,
C======================================
 NON*TEXT  :M6, VTM ,TNON*TEXT  .=6НNONTEX
            , WTC ,*REGIM//
         M14, VTM ,
         M14, VZM ,вMOНИTOP
         M13, VTM ,вMOНИTOP
         M14, UJ  ,
 BAD*MON  :M6, VTM ,TBAD*MON  .=6НBAD MO
            , UJ  ,вMOНИTOP
            , LOG ,7760 0000 0000 0012
            , LOG ,377
            , OCT ,776
 TNO*END  :  , ISO ,12НNO *END FILE
 TNON*TEXT  :  , ISO ,12НNONTEXT CARD
 TBAD*MON  :  , ISO ,12НBAD MON CARD
            , OCT ,0010 0000 0007
            , END ,
