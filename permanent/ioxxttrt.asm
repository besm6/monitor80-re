 IOXXTTRT:  , NAME,
с*
с*** Программа "Mонитор-80" ИAЭ
с*
 SAVE*HID:  , SUBP,
 MON*ITOR:  , SUBP,
 GOST/ISO:  , SUBP,
 ASAVE*  :  , SUBP,
 FOR*ALL :  , SUBP,
 TTPRIKS :  , SUBP,
 /IP*    :  , SUBP,
  TSTATE* :  , LC  ,1
 IOSKIP* :  , LC  ,1
 *1      :  ,BLOCK,M1,M2,M3,M4,M5,M6,M7,M8,M9
            , CONT,M10,M11,M12,M13,M14,M15
c
 начало  :  , ITA ,M14
         M15, XTS ,-4
         M15, XTS ,-4
         M15, STX ,-5
         M15, STX ,-3
         M14, VTM ,77560B
            , UJ  ,устбуф
C======================================
 TTREAD* :  ,ENTRY,
C======================================
 TTREAD*D:  ,ENTRY,
C======================================
C   П/П  HИЖHEГO YPOBHЯ ДЛЯ BBOДA ПO
C   ФOPTPAHHOMY OПEPATOPY READ C TEP-
C   MИHAЛA.
            , ITS ,
            , ITS ,
            , ITS ,M14
         M14, VTM ,-80 .длина буфера = 80 симв.?
 устбуф  :  , ITS ,M14
         M15, STX ,-2
         M14, VJM ,SAVE*HID
            , ITA ,M8
          M3, MTJ ,M8 .БУФEP BBOДA!
          M3, MTJ ,M9 .AНAЧ.!
            , ATI ,M3
         M13, VJM ,TTPRIKS
C   BBOД CTPOKИ C TEPMИHAЛA
          M1, MTJ ,M4
          M1, VTM ,
         M11, VTM ,TSTATE*
          M6, VTM ,начало
            , UTC ,/IP*+6
            , XTA ,
            , UTC ,/IP*+5
            , ATX ,
 вводстр  :  , UTC ,/IP*
            , *71 ,
            , UTC ,/IP*+2
            , *71 ,
            , ASN ,64-22
            , ASN ,64+45
          M6, AEX ,60B .= "0"(ISO)
         M11, ATX ,
          M3, XTA ,
          M6, AEX ,54B.= ","(ISO)
            , U1A ,пригл
          M6, XTA ,57B.= "/"(ISO)
         M11, ATX ,
            , UJ  ,выход
C--------------------------
 пригл  :M3, XTA ,
          M6, AEX ,55B.= "-"(ISO)
            , U1A ,разбрREAD
          M8, VTM ,TFREE  .=GOST FREE
          M9, VTM ,TFREE  .=GOST FREE
            , UTC ,/IP*+1
            , *71 ,
            , UTC ,/IP*+3
            , *71 ,
          M6, XTA ,61B .RLOAD или код отв.= "1"(ISO)
         M11, ATX ,
            , UJ  ,выход
 разбрREAD  :M3, XTA ,
            , ASN ,64+40
            , ATI ,M7
          M7, UTM ,77401B .почему больше 324B?
          M7, VZM ,вводстр
         M11, XTA ,
          M6, AEX ,62B.= "2"(ISO)
            , UZA ,выход
         M14, VTM ,перекод
         M12, VTM ,выход
            , UJ  ,MON*ITOR
 перекод  :  , ATI ,M7
          M7, UTM ,77401B .=-376B?
          M7, VZM ,выход
            , UJ  ,GOST/ISO
c
 выход  :M7, VTM ,40B
         M14, VTM ,выход
          M4, VLM ,FOR*ALL
          M2, WTC ,
         M12, VTM ,-1
          M7, VTM ,12B
         M14, VTM ,ASAVE*
         M12, VZM ,FOR*ALL
         M11, XTA ,
         M12, ATX ,3
            , UTC ,IOSKIP*
            , ATX ,
            , UJ  ,FOR*ALL
            , GOST,6HSKIP’377’0
            , GOST,6HBREAK’377’
 TFREE  :  , GOST,6H FREE
            , LOG ,3
            , LOG ,4
            , LOG ,5
            , LOG ,6
            , END ,
