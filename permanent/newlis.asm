 NEWLIS  :  , NAME,
c
с программа "Mонитор-80" ИAЭ
с
с
 *1      :  ,BLOCK,M1,M2,M3,M4,M5,M6,M7,M8,M9
            , CONT,M10,M11,M12,M13,M14,M15
c
            , XTS ,
         :  , UTC ,aконтек
            , *64 ,
 продолж  :  , STX ,
         M13, UJ  ,
 aконтек  :  , Z00 ,контек
            , Z00 ,контек
            , ATX ,
          M8, ATX ,
 контек  :  , GOST,6H’201’’172’
C======================================
 NOTLIS  :  ,ENTRY,
C======================================
            , XTS ,
            , *64 ,
            , UJ  ,продолж
C======================================
 YESLIS  :  ,ENTRY,
C======================================
            , XTS ,
            , *64 ,1
            , UJ  ,продолж
            , END ,
