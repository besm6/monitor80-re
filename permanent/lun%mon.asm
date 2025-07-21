 LUN*MON :  , NAME,
 PRINT80 :  , SUBP,
 TTPRINT :  , SUBP,
 *1      :  ,BLOCК,M1,M2,M3,M4,M5,M6,M7,M8,M9
           , CONT,M10,M11,M12,M13,M14,M15
           , XTS ,
           , *71 ,
           , UZA ,NE*VT .Tерминала нет или
с терм. не VT
           , ITS ,M13
        M15, XTS ,-5
        M15, XTS ,-5
        M15, XTS ,-5
        M13, VJM ,TTPRINT
           , STI ,M13
 NE*VT  :  , STX ,
           , UJ  ,PRINT80
           , END ,
