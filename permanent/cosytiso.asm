 COSYTISO:  , NAME,
c
с Стандартная программа MС Дубна
с Pазличия в сдвигах по адресам
c
 READ*ERR:  , SUBP,
 *1      :  ,BLOCK,M1,M2,M3,M4,M5,M6,M7,M8,M9
            , CONT,M10,M11,M12,M13,M14,M15
c
C======================================
 COZYTISO:  ,ENTRY,
C======================================
 C  :  , ATI ,M14 .RW
            , ITA ,M13 .S
            , ITS ,M12 .BL.
            , ITS ,M11 .WP.
            , ITS ,M10 .WC
            , ITS ,M9  .B
            , ITS ,M14 .RW
          M9, VTM ,C
          M9, ATX ,51B
            , XTS ,
         M12, VTM ,
         M11, VTM ,-5
         M10, VTM ,-13
 READW:M14,XTA,
         M14, UTM ,1
 READS  :  , ASN ,64-8
          M9, ATX ,52B
            , YTA ,
            , ATI ,M13
         M13, VZM ,READW
          M9, ATX ,53B
            , ASN ,64+7
            , UZA ,WRITS
            , ASN ,64-5
          M9, ATX ,53B
         M13, MTJ ,M12
         M12, UTM ,-200B
         M12, VZM ,NONTEXT
         M11, UTM ,5
         M11, VZM ,WRBLW
         M11, UTM ,-5
 WRITS:M15,XTA,-1
            , ASN ,64-8
          M9, AOX ,53B .=XS
         M15, ATX ,-1
         M12, VZM ,NONBLS
         M12, UTM ,-1
 TOWRITS:M12,VZM,NEXTRS
         M11, VLM ,WRITS
 NEXTWW:M15,UTM,1
         M10, VLM ,WRBLW
 NONTEXT  :  , UJ  ,READ*ERR
 WRBLW:M12,UTM,-6
            , ITA ,M12
            , ASN ,64+7
            , U1A ,NONBLW
          M9, XTA ,50B
         M15, ATX ,-1
            , UJ  ,NEXTWW
 NONBLW:M12,UTM,6
         M11, VTM ,-6
         M12, V1M ,TOWRITS
            , UJ  ,NEXTRS
 NONBLS:M13,UTM,-12B .=NL
         M13, VZM ,NEWLINE
 NEXTRS  :M9, XTA ,52B .=WORD
         M11, VLM ,READS
         M11, VTM ,-5
         M15, UTM ,1
         M10, VLM ,READS
            , UJ  ,NONTEXT
 NEWLINE:M10,UTM,14
            , WTC ,ARES
         M10, UTC ,-1
         M11, VTM ,
 MOVE:M15,XTA,
         M11, ATX ,
         M11, UTM ,-1
         M10, UTM ,-1
         M10, V1M ,MOVE
         M14, VTM ,-4
 RESI:M15,XTA,
         M14, ATI ,M13
         M14, VLM ,RESI
            , STX ,
         M13, UJ  ,
            , ISO ,6H
 ARES  :  , BSS ,3
            , END ,
