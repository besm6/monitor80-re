 GIVCALL*:  , NAME,
c
c Программа "Mонитор-80" ИAЭ
с Составлено из нескольких программ MС Дубна
с Pанее CALL - процедура в STAR*
c
 MONCARD*:  , LC  ,25
 MONITOR*:  , SUBP,
 LOADANGO:  , SUBP,
 IDENT6  :  , SUBP,
 MONREAD*:  , SUBP,
 *1      :  ,BLOCK,M1,M2,M3,M4,M5,M6,M7,M8,M9
            , CONT,M10,M11,M12,M13,M14,M15
c
            , ITA ,M13
            , ATX ,RRR2
         M14, VTM ,MONCARD*+1
            , ITA ,M14
         M13, VJM ,IDENT6
            , WTC ,RRR2
         M14, V1M ,
            , ATX ,card
         M13, VJM ,MONREAD*
            , XTA ,card
            , AEX ,TPASCAL
            , UZA ,pascal
            , XTA ,card
            , AEX ,TOVERLAY
            , UZA ,call
            , XTA ,card
            , AEX ,TEXECUTE
            , UZA ,call
            , XTA ,card
            , AEX ,TOCATALOG
            , UZA ,call
            , XTA ,card
            , AEX ,TSOVCATAL .пишет "старый overlay"
            , U1A ,sovcatal
 call  :  , XTA ,73B
            , ATX ,RRR1
            , ASN ,64-6
            , AOX ,п2
            , ATX ,73B
            , XTS ,card
         M13, VJM ,LOADANGO
            , XTA ,RRR1
            , ATX ,73B
            , UJ  ,cal1l
 sovcatal  :  , XTS ,card
         M13, VJM ,LOADANGO
 cal1l:M14,VTM,
            , WTC ,RRR2
            , UJ  ,
 pascal:M13,VJM,MONITOR*+4
         M13, VTM ,MONITOR*+1
            , XTS ,card
            , UJ  ,LOADANGO
 TOVERLAY  :  , TEXT,8HOVERLAY
 TEXECUTE  :  , TEXT,8HEXECUTE
 TOCATALOG  :  , TEXT,8HOCATALOG
 TSOVCATAL  :  , TEXT,8HSOVCATAL
 TPASCAL  :  , TEXT,8H*PASCAL
 п2  :  , LOG ,2
 card  :  , BSS ,1
 RRR1  :  , BSS ,1
 RRR2  :  , BSS ,1
            , END ,
