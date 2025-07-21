            LOADANGO:  , NAME,
c
c Cтандартная программ MC Дубна.
с Mинимальные модификации в части исп. Э70
с
            INFLOAD*:  LC,BLOCK,ALOAD,INFLOA
    *1      :  ,BLOCК,M1,M2,M3,M4,M5,M6,M7,M8,M9
            , CONT,M10,M11,M12,M13,M14,M15
 LNGO  :  , ATX ,NAME
            , XTA ,17B
            , ATI ,M14
         M14, ATX ,2
            , ATX ,AP
            , ARX ,п10
            , ATX ,17B
            , ITA ,M13
         M14, ATX ,3
         M14, XTA ,
            , AEX ,NAME
            , UZA ,INMEM
            , XTA ,NAME
         M14, ATX ,
            , ITA ,M14
            , ASN ,64-24
            , AOX ,CRETN
         M14, UTC ,
            , CTX ,4
            , *70 ,46B
            , XTA ,ALOAD
            , U1A ,CONT
            , *70 ,61B
            , XTA ,NAME
            , WTC ,43B
         M13, VJM ,2
 GOAFLOAD  :  , WTC ,AP .TOЧКA ДЛЯ EXECUT
         M14, VTM ,
 GO:M14,UTC,4
         M13, VTM ,
         M14, WTC ,7
            , UJ  ,
 CONT:M13,VTM,CON1T
            , XTA ,NAME
            , WTC ,ALOAD
            , UJ  ,
 CON1T  :  , STX ,
            , UJ  ,GOAFLOAD
 RETN:M14,XTS,1
            , ATX ,16B
         M14, XTA ,2
            , ATX ,17B
         M14, XTA ,3
            , STI ,M13
         M13, UJ  ,
 INMEM:M14,XTA,5
            , ATX ,16B
         M14, XTA ,6
            , STX ,17B
            , UJ  ,GO
 CRETN:M14,VTM,
            , UJ  ,RETN
C======================================
 LOADGO  :  ,ENTRУ,
C======================================
            , ATI ,M14
         M14, XTA ,
            , APX ,CPACK
            , UJ  ,LNGO
C======================================
 LOADCALL:  ,ENTRУ,
C======================================
            , XTA ,
            , WTC ,17B
            , STX ,
            , UJ  ,LNGO
 п10  :  , LOG ,10
 CPACK  :  , OCT ,2765 7537 2765 7537
 NAME  :  , OCT ,
 AP  :  , OCT ,
            , END ,
