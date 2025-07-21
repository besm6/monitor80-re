 IOXRCB  :  , NAME,
c
c Программа "Mонитор-80" ИAЭ
c
 IOXXRPCK:  , SUBP,
 IOXXUPCK:  , SUBP,
 *IOXLCB*:  , LC  ,1
 IODCB*  :  , LC  ,0
 GIVEMASK:  , SUBP,
 STOP*   :  , SUBP,
 LUN*MON :  , SUBP,
 *1      :  ,BLOCK,M1,M2,M3,M4,M5,M6,M7,M8,M9
            , CONT,M10,M11,M12,M13,M14,M15
c
 ioxrc1b:M12,VJM,ioxw1cb
            , XTA ,
          M9, ATX ,
          M9, ATX ,1
         M12, VJM ,io1xwcb
            , UZA ,iox1wcb
         M11, VTM ,IOXXRPCK
         M12, VJM ,в*IOXXUPCK
            , UJ  ,iox1wcb
C======================================
 IOXWCB  :  ,ENTRY,
C======================================
         M12, VJM ,ioxw1cb
         M10, XTA ,
            , UZA ,ioxwc1b
         M10, XTA ,
          M8, AOX ,56B
          M9, ATX ,2
         M12, VJM ,io1xwcb
            , UZA ,iox1wcb*вых
          M9, AEX ,3
            , U1A ,iox1wcb*вых
 ioxwc1b:M11,VTM,IOXXUPCK
         M12, VJM ,в*IOXXUPCK
            , UJ  ,iox1wcb
 ioxw1cb  :  , STI ,M9
            , ATI ,M10
            , ITA ,M13
            , XTS ,
          M8, VTM ,ioxrc1b
         M12, UJ  ,
 iox1wcb  :  , STX ,
            , STI ,M13
         M13, UJ  ,
 io1xwcb:M11,VTM,IODCB*
            , WTC ,*IOXLCB*
         M14, VTM ,
 i1oxwcb:M11,XTA,
            , UZA ,io2xwcb
            , ARX ,
            , U1A ,i2oxwcb
            , ASN ,64+40
         M10, AEX ,
          M8, AAX ,60B
            , UZA ,в*GIVEMASK
 i2oxwcb:M14,UTM,-1
         M11, UTM ,1
         M14, V1M ,i1oxwcb
         M11, VTM ,
 io2xwcb  :  , ITA ,M11
          M9, ATX ,
            , XTA ,
         M12, UJ  ,
 в*GIVEMASK:M11,XTA,
            , ASN ,64+36
          M8, AAX ,57B
         M15, ATX ,
         M13, VJM ,GIVEMASK
          M9, ATX ,1
            , ITA ,M11
          M9, STX ,
         M12, UJ  ,
 в*IOXXUPCK  :M9, MTJ ,M14
         M14, UTM ,2
            , ITA ,M14
          M9, XTS ,
            , UZA ,iox1wcb*вых
         M14, UTM ,-1
            , ITS ,M14
         M12, MTJ ,M13
         M11, UJ  ,
 iox1wcb*вых:M14,VTM,TOШBИНФ.=6HOШ. B
            , ITS ,M14
         M14, UTM ,3
            , ITS ,M14
            , XTS ,
         M13, VTM ,STOP*
            , UJ  ,LUN*MON
 TOШBИНФ  :  , ISO ,18HOШ. B ИHФ. IOXR-WC
            , LOG ,200
            , LOG ,17
            , LOG ,177
            , END ,
