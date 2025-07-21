 STOP*   :  , NAME,
с стандартная программ MC ДУБНA
c модифицирована для Mонитора-80
с
 IODCB*  :  , LC  ,0
 STOP**  :  , SUBP,
 RESTOP* :  , LC  ,1
 TAPELIST:  , LC  ,25
 RM*     :  , LC  ,5
 RFMRTFLG:  , LC  ,1
 INFLOAD*:  , LC  ,1
 LOADANGO:  , SUBP,
 *1      :  ,BLOCК,M1,M2,M3,M4,M5,M6,M7,M8,M9
            , CONT,M10,M11,M12,M13,M14,M15
c
 м67:M12,VTM,м67
            , WTC ,RM*+2
         M15, VTM ,
         M12, *67 ,20B .имеется в оригинальном тексте
с но в ДИCПAКе смысл отличается?
 EXIT  :  , ITA ,M13
            , XTS ,
            , WTC ,RESTOP*
         M13, VTM ,
         M13, V1M ,TOSTOP
         M13, VTM ,STOP**
            , XTS ,RM*
            , ATX ,16B
            , XTA ,772B
            , ATX ,17B
            , XTA ,
            , STX ,INFLOAD*
 TOSTOP  :  , ATX ,RESTOP*
            , XTA ,RFMRTFLG
            , UZA ,возврат
            , ASN ,64-8
            , ARX ,
            , U1A ,возвра1т
 возврат  :  , XTA ,TAPELIST+24
            , ASN ,64-47
            , ARX ,
            , UZA ,возвра1т
            , STX ,
         M13, UJ  ,
c
 возвра1т:M12,XTS,17B
            , UJ  ,LOADANGO
c нет передачи упр.
с на уч. далее ?
            , TEXT,8НIOXNSWAP
            , Z00 ,EXIT
          M9, ATX ,
            , END ,
