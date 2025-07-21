 ERRIOM  :  , NAME,
 LUN*MON :  , SUBP,
 STOP*   :  , SUBP,
 SDEC*   :  , SUBP,
 *1      :  ,BLOCK,M1,M2,M3,M4,M5,M6,M7,M8,M9
            , CONT,M10,M11,M12,M13,M14,M15
c
 база*м8  :M8, VTM ,база*м8
            , NTR ,3
          M8, ATX ,135B
         M13, MTJ ,M10
          M8, AEX ,130B
            , U1A ,errio1m
          M1, XTA ,3
          M8, AEX ,130B
            , UZA ,перекл*ERRIOM
          M8, ATX ,135B
 errio1m  :M8, XTA ,135B
            , ATI ,M14
          M9, VTM ,перекл*ERRIOM
          M8, A-X ,130B
            , U1A ,err1iom
            , WTC ,п377
         M14, VTM ,
          M9, VTM ,в*STOP
            , UJ  ,выд*TO1ШIOM
 err1iom  :M8, XTA ,135B
          M8, A-X ,133B
            , U1A ,выд*TOШIOM
          M8, XTA ,133B
          M8, ATX ,135B
 выд*TOШIOM  :M8, XTA ,135B
         M15, ATX ,
            , ASN ,64-1
         M15, A+X ,
            , ATI ,M14
         M14, UTM ,TOШIOM  .=6H ФAHTA
 выд*TO1ШIOM  :  , ITS ,M14
         M14, UTM ,2
            , ITS ,M14
         M14, VTM ,4
            , ITS ,M14
         M13, VJM ,LUN*MON
          M9, UJ  ,
 в*STOP:M13,VJM,STOP*
            , SJ  ,
 TНETКAН  :  , ISO ,12H HET KAHAЛA
 TLUN  :  , ISO ,6H’’ LUN
 TRETDEV  :  , ISO ,6H’’’’’’’’’’’’
            , ISO ,6H ’’’’RET
            , ISO ,6H’’’’’’’’’’’’
            , ISO ,6H’’ DEV
            , ISO ,6H’’’’’’’’’’’’
            , ISO ,6H’’ CZ ’’
            , ISO ,6H’’’’’’’’’’’’
            , ISO ,6H  POIN
            , ISO ,6HT ’’’’’’
c
 раб*ERRIOM  :  , BSS ,1
 перекл*ERRIOM  :M1, XTA ,
          M1, XTS ,-13
          M1, XTS ,4
          M1, XTS ,10B
          M1, XTS ,6
         M13, VJM ,errl1un
          M8, STX ,42B
         M13, VJM ,errl1un
          M8, STX ,37B
         M13, VJM ,errl1un
          M8, STX ,35B
         M13, VJM ,errl1un
          M8, STX ,33B
         M13, VJM ,в*SDEC
          M8, ATX ,31B
         M13, VTM ,TLUN
         M14, VTM ,раб*ERRIOM
 вых*ERRIOM  :  , ITS ,M13
            , ITS ,M14
         M14, VTM ,1
            , ITS ,M14
         M13, VJM ,LUN*MON
            , UJ  ,в*STOP
C======================================
 ERRLUN  :  ,ENTRY,
C======================================
          M8, VTM ,база*м8
            , NTR ,3
         M13, MTJ ,M10
         M13, VJM ,в*SDEC
          M8, ATX ,31B
         M13, VTM ,TНETКAН  .=6H HET K
         M14, VTM ,TRETDEV
            , UJ  ,вых*ERRIOM
 в*SDEC  :M8, AAX ,134B
            , UJ  ,SDEC*
 errl1un  :  , ASN ,64-33
          M8, AUX ,132B
          M8, AOX ,131B
         M13, UJ  ,
 TOШIOM  :  , ISO ,24H ФAHTACMAГOPИЯ     ИCПOP
            , ISO ,24HЧEH PEKOPД  ЧTEHИE END R
            , ISO ,12HECORD ЧTEHИE
            , ISO ,6H ’42’END
            , ISO ,6HFILE’42’
            , ISO ,24HHE TOT TИП ЗAПИCИ CБOЙ K
            , ISO ,24HAHAЛA       ЗAПPEЩEHHЫЙ
            , ISO ,24HPEЖИM HE ЗAГPYЖ. ДPAЙBEP
            , ISO ,24HBЫXOД ИЗ ДИAПAЗOHAMHOГO
            , ISO ,24HKAHAЛOB     ДЛИHHЫЙ PEKO
            , ISO ,6HPД ЗAП
            , LOG ,20
            , ISO ,6H 00000
            , ISO ,6H’’’7’’7’’7’’7’’7’
            , LOG ,12
            , LOG ,177
 п377  :  , BSS ,1
            , END ,
