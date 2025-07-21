  IDENT6  :  , NAME,
c
c Cтандартная программ MC Дубна.
с
 *1      :  ,BLOCК,M1,M2,M3,M4,M5,M6,M7,M8,M9
            , CONT,M10,M11,M12,M13,M14,M15
            , ISO ,6Н’2’’’’12’’312’’177’’370’
         M11, VTM ,-10
            , XTA ,
            , ATX ,IDI
 CYCY:M10,UTC,
         M11, XTA ,12B
            , ATX ,RR1
 CYC  :  , XTA ,RR1
            , UZA ,CYFE
            , ASN ,64-8
            , ATX ,RR1
            , УTA ,
            , ATI ,M14
         M14, UTM ,-32
         M14, VZM ,CYC
            , ITA ,M14
         M15, ATX ,
            , ASN ,64+3
            , ATI ,M14
            , ASN ,64-3
         M15, AEX ,
            , ATX ,RR2
         M14, XTA ,IS/TE
            , WTC ,RR2
         M14, VTM ,
 CYK:M14,VZM,CYKI
            , ASN ,64-6
         M14, UTM ,-1
            , UJ  ,CYK
 CYKI  :  , ASN ,64+42
            , UZA ,CY
            , XTS ,IDI
            , ASN ,64-6
         M15, AOX ,
            , ATX ,IDI
         M12, UTM ,1
         M12, V1M ,CYC
 CY  :  , XTA ,IDI
            , UZA ,WRUSE
            , AAX ,п77
            , U1A ,CYFI
            , XTA ,IDI
            , ASN ,64-6
            , ATX ,IDI
            , UJ  ,CY+1
 CYFI  :  , XTA ,IDI
         M14, VTM ,
         M13, UJ  ,
 CYFE:M11,VLM,CYCY
            , UJ  ,CY
 WRUSE:M14,VTM,1
         M13, UJ  ,
 IS/TE  :  , BSS ,
 ,TEXT,8H
 ,TEXT,8H  *    /
 ,TEXT,8H01234567
 ,TEXT,8H89
 ,TEXT,8H ABCDEFG
 ,TEXT,8HHIJKLMNO
 ,TEXT,8HPQRSTUVW
 ,TEXT,8HXYZ
 ,TEXT,8HЮ БЦД ФГ
 ,TEXT,8H ИЙ Л
 ,TEXT,8HПЯ    Ж
 ,TEXT,8HЬЫЗШЭЩЧ
c
 п77  :  , OCT ,77
c
 IDI  :  , BSS ,1
 RR1  :  , BSS ,1
 RR2  :  , BSS ,1
            , END ,
