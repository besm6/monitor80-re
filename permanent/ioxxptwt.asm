 IOXXPTWT:  , NAME,
 SAVE*HID:  , SUBP,
 MON*ITOR:  , SUBP,
 OH*     :  , SUBP,
 OH*1    :  , SUBP,
 FOR*ALL :  , SUBP,
 ASAVE*  :  , SUBP,
 *1      :  ,BLOCK,M1,M2,M3,M4,M5,M6,M7,M8,M9
            , CONT,M10,M11,M12,M13,M14,M15
c
         M15, XTA ,-2
         M15, STX ,-3
         M15, ATX ,-1
            , XTA ,
C======================================
 PT8PUN  :  ,ENTRY,
C======================================
            , ITS ,M14
         M14, VJM ,SAVE*HID
         M14, VTM ,*0005B
         M12, VTM ,*0012B
          M4, VTM ,77553B
            , UJ  ,MON*ITOR
 *0005B  :  , UZA ,MON*ITOR
         M14, VJM ,OH*
         M14, VTM ,*0005B
         M15, ATX ,
            , ACX ,
            , ASN ,64-47
            , ASN ,64+40
         M15, AOX ,
         M13, UJ  ,
 *0012B  :M7, VTM ,240B
         M14, VJM ,FOR*ALL
          M7, VTM ,240B
         M14, VJM ,FOR*ALL
          M7, VTM ,55B
         M14, VJM ,OH*1
          M7, VTM ,252B
            , UJ  ,*0016B
 *0016B:M11,UTM,-8
         M14, VJM ,OH*1
          M6, XTA ,-1
            , UTC ,всеед
            , XTS ,
         M11, ASN ,64
         M15, AAX ,
          M6, ATX ,-1
 *0022B  :  , UTC ,*0024B
            , *71 ,
         M13, UJ  ,
 *0024B  :M8, ATX ,
          M6, Z00 ,-1
C======================================
 IOXXPTWB:  ,ENTRY,
C======================================
            , ATI ,M14
         M14, XTA ,
         M15, UTM ,-4
            , UTC ,TADD  .=6HADD
            , AEX ,
         M13, U1A ,
         M15, XTS ,1
         M15, XTS ,1
C======================================
 PT8BNP  :  ,ENTRY,
C======================================
            , ITS ,
            , ITS ,M14
         M14, VJM ,SAVE*HID
          M3, MTJ ,M8
          M2, XTA ,
            , ATI ,M6
         M13, VTM ,ASAVE*
            , UJ  ,*0022B
 TADD  :  , ISO ,6HADD
 всеед  :  , LOG ,7777 7777 7777 7777
            , END ,
