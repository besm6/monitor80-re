 IOXRPT  :  , NAME,
c
c Программа "Mонитор-80" ИAЭ
c
 A/I0    :  , LC  ,1
 GIVELEXX:  , SUBP,
 IOXWCB  :  , SUBP,
 IOXRCB  :  , SUBP,
 *1      :  ,BLOCK,M1,M2,M3,M4,M5,M6,M7,M8,M9
            , CONT,M10,M11,M12,M13,M14,M15
c
 ioxrp1t:M14,VJM,ioxw1pt
          M1, XTA ,17B
            , ASN ,64-10
          M1, ARX ,15B
          M1, WTC ,2
            , WTC ,
         M14, VTM ,
         M14, VZM ,ioxr1pt
            , ASN ,64-5
          M1, AOX ,24B
 ioxr1pt  :  , AOX ,A/I0
          M1, WTC ,1
            , ATX ,
            , UJ  ,io1xwpt
C======================================
 IOXWPT  :  ,ENTRY,
C======================================
         M14, VJM ,ioxw1pt
          M1, WTC ,1
            , XTA ,
            , ASN ,64-8
            , ASN ,64+8
          M1, ATX ,1
            , XTA ,
          M1, WTC ,2
            , WTC ,
         M14, VTM ,
         M14, VZM ,ioxwp1t
            , ASN ,64+5
          M1, ATX ,1
            , YTA ,
            , ASN ,64+43
 ioxwp1t  :M1, ATX ,24B
          M1, XTA ,1
            , ASN ,64+10
          M1, ATX ,1
            , YTA ,
            , ASN ,64+38
          M1, ATX ,15B
          M1, UTC ,1
         M14, VTM ,
            , ITS ,M14
          M1, UTC ,7
         M14, VTM ,
            , ITS ,M14
         M13, VJM ,GIVELEXX
            , XTS ,
          M1, UTC ,5
         M14, VTM ,
            , ITS ,M14
         M13, VJM ,IOXWCB
          M8, VTM ,ioxrp1t
         M14, VTM ,
            , UJ  ,io1xwpt
 ioxw1pt  :  , ITS ,M13
            , ITS ,M1
            , XTS ,
         M15, MTJ ,M1
          M1, UTM ,-5
         M15, UTM ,31B
            , ITA ,M14
          M1, XTS ,
          M1, UTC ,5
         M14, VTM ,
            , ITS ,M14
         M13, VJM ,IOXRCB
            , ATI ,M13
          M1, XTA ,5
         M14, VTM ,1
            , UZA ,io1xwpt
          M8, VTM ,ioxrp1t
          M1, XTA ,6
            , ASN ,64+24
          M8, AAX ,57B
            , ATI ,M10
         M10, UTM ,-3
         M10, V1M ,iox1wpt
          M1, WTC ,26B
         M10, VTM ,-3
 iox1wpt:M10,UTM,2
         M14, VTM ,2
         M10, V1M ,io1xwpt
         M13, UJ  ,
 io1xwpt  :M1, WTC ,3
         M13, VTM ,
            , ITA ,M14
            , AOX ,A/I0
          M1, MTJ ,M15
          M1, WTC ,4
          M1, VTM ,
         M13, UJ  ,
            , LOG ,17
            , END ,
