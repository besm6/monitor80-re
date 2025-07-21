 LIBDRUM :  , NAME,
C*******************************
C****PEAЛИЗAЦИЯ ФYHKЦИЙ*********
C**** COMMON LIBRARY***********
C****PERSONAL LIBRARY**********
C****MOCKBA  ИAЭ ИM. KYPЧATOBA**
C****ГOЛYБEB A.C. BECHA 1973.***
C*******************************
 SYSLIST*:  , SUBP,
 INFLOAD*:  , LC  ,4
cINFLOAD*:LC,BLOCK,ALOAD,INFLOA,INFMD,INFDM
 INFMD   :  , EQU ,INFLOAD*+3
 NEWCAT  :  , PC  ,2048
 OLDCAT  :  , PC  ,2048
 NCL   :  , P/P ,(NEWCAT)16
 OCL   :  , P/P ,(OLDCAT)16
 TABL    :  , PC  ,2048
 *MONCRD*:  , LC  ,12
 *REGIM//:  , LC  ,1
 PARAMT* :  , SUBP,
 PRINT8  :  , SUBP,
 PT6     :  , SUBP,
 LWW   :  , EQU ,NCL+64
 SAV   :  , EQU ,NCL+65
 SAV1   :  , EQU ,NCL+67
 *1      :  ,BLOCK,M1,M2,M3,M4,M5,M6,M7,M8,M9
            , CONT,M10,M11,M12,M13,M14,M15
c
 M1базовый  :M1, VTM ,M1базовый
            , ITA ,M13
            , XTS ,
          M1, ATX ,INF
          M1, ATX ,ERROR
         M14, VTM ,TИСПOPЧ  .=6HИCПOPЧ
            , ITA ,M14
          M1, ATX ,D
          M1, XTA ,TOZPER
          M1, ATX ,TOZERO
            , XTA ,
          M1, ATX ,SHIFT
          M1, XTA ,л1042 .=:001042
          M1, ATX ,BOUND
C---KOHEЦ HAЧAЛЬHЫX YCTAHOBOK----
         M10, VTM ,
         M13, VJM ,PARAMT*
          M1, XTA ,е18п13о16 .=670000
          M1, ATX ,PLACE
         M10, VTM ,4
          M9, VTM ,PLACE
         M13, VJM ,PARAMT* .MEСTO НA ЛEНTE
         M10, VTM ,2
          M1, XTA ,TCONT
         M13, VJM ,PARAMT* .PEЖИM ДOПИСИ
          M1, ATX ,FLAG
         M14, V1M ,RET.OШИБКИ B ПAPAMETPAX
          M1, XTA ,п2
          M1, ATX ,shif1t
         M10, VTM ,5
          M9, VTM ,shif1t
         M13, VJM ,PARAMT*
          M1, XTA ,shif1t
          M1, ARX ,e15п2
          M1, AAX ,е15п1
          M1, ATX ,shif1t
          M1, ATX ,shi1ft
            , ASN ,64-30
          M1, AEX ,FULWORD
          M1, ARX ,TOZERO
          M1, ATX ,TOZERO
          M2, VTM ,OLDCAT+2
          M4, VTM ,NEWCAT-2
          M1, XTA ,RW
          M1, AOX ,PLACE
          M1, ARX ,SHIFT
          M1, ATX ,WRW
          M1, *70 ,WRW
          M1, XTA ,WRW
          M1, ATX ,WC
          M1, ARX ,e31e1
          M1, ATX ,WRW
          M1, *70 ,WRW.ЧTEНИE КATAЛOГA
          M1, XTA ,D
          M1, ATX ,DGN
C---YKAЗATEЛИ ДЛЯ БЛOKA KOHTPOЛЯ--
         M14, VTM ,NEWCAT+1
         M13, VTM ,TABL
          M1, XTA ,shif1t
            , ASN ,64-30
          M1, AEX ,e42п31
          M1, ARX ,e31
          M1, ATX ,sh1ift
 контроль:M14,UTM,2
         M12, VTM ,SYSLIST*.Дополнительно
 контрол1ь:M12,XTA,
            , UZA ,контро1ль
         M14, AEX ,-1
         M12, UTM ,1
            , U1A ,контрол1ь
         M10, VJM ,KAPU2T
            , UJ  ,контрол1ь
 контро1ль:M14,XTA,
          M1, AEX ,FULWORD
            , UZA ,CON*
         M14, XTA ,
          M1, AAX ,e47
            , UZA ,контроль
         M14, XTA ,
          M1, AAX ,e41п19
          M1, ARX ,sh1ift
          M1, AAX ,e41п19
         M13, ATX ,
         M14, XTA ,
          M1, AUX ,о46п8о2п1
          M1, AAX ,е15п1
         M13, AOX ,
         M13, ATX ,
         M14, XTA ,-1
         M13, ATX ,1
         M13, UTM ,2
            , UJ  ,контроль
c
C---ПPOBEPKA HOBOГO KATAЛOГA---
 CON*:M13,ATX,
          M4, XTA ,2
          M1, AAX ,e20
            , UZA ,KAPUT
          M4, XTA ,2
          M1, AAX ,e18п16
            , UZA ,KAPUT
          M4, XTA ,2
          M1, AAX ,о21п6
            , U1A ,KAPUT
          M4, XTA ,3
            , U1A ,KAPUT
          M1, XTA ,FLAG
            , UZA ,READCAT.PEЖИM ДOЗAПИСИ
C---KATAЛOГ PERMANENT LIBRARY----
            , XTA ,INFMD
          M1, AOX ,e35п31
          M1, AEX ,e35п31
          M1, AOX ,PCAT
          M1, ATX ,pca1t
          M1, *70 ,pca1t
          M1, XTA ,pca1t
          M1, ARX ,e31e1
          M1, ATX ,HEAD
          M1, *70 ,HEAD
          M1, XTA ,STCAT
          M2, ATX ,-2
          M1, XTA ,SHIFT
            , U1A ,NOREAD
            , XTA ,*REGIM//
          M1, AOX ,e18e17 .БЫЛA *PERSONAL
          M1, AEX ,e18e17 .B PEЖИME OБНOBЛEНИЯ
            , ATX ,*REGIM//
            , UJ  ,NOREAD
C---KATAЛOГ TEMPORARY LIBRARY----
 READCAT  :M1, *70 ,OCRW
          M1, XTA ,OCRW
          M1, ARX ,e31e1
          M1, ATX ,OCRWC
          M1, *70 ,OCRWC
         M14, VTM ,TИСПКAT  .=6HИCПOPЧ
            , ITA ,M14
          M1, ATX ,DGN
          M2, XTA ,-2
          M1, AAX ,e20
            , UZA ,KAPUT
          M2, XTA ,-2
          M1, AAX ,e18п16
            , UZA ,KAPUT
          M2, XTA ,-2
          M1, AAX ,о21п6
            , U1A ,KAPUT
          M2, XTA ,-1
            , U1A ,KAPUT
            , XTA ,54B.СBOБ. MEСTO
          M2, ATX ,-2.НAДEЖНEE
C--KOHCTAHTA ПPИBEДEHИЯ K HYЛЮ--
C-------YKAЗATEЛEЙ--------------
 NOREAD  :M2, XTA ,-2
          M1, ARX ,e10п6
          M1, APX ,е24п11
          M1, ATX ,WRW
          M1, AUX ,e18п13е5п1
          M1, AOX ,lw1w
          M1, ATX ,LWWC
          M1, XTA ,WRW
            , ASN ,64+7
          M1, ARX ,TOZERO
          M1, ATX ,TOZERO
C--KOHEЦ HOBOГO KATAЛOГA-----
C---KOPPEKTИPOBKA YKAЗATEЛEЙ---------
          M1, XTA ,D
          M1, ATX ,DGN
 COUNT  :M4, XTA ,2
          M4, UTM ,2
          M4, MTJ ,M14
         M14, UTM ,-NEWCAT+30720
         M14, VZM ,KAPUT
            , UZA ,CON**
          M4, XTA ,1
          M1, AAX ,e47
            , UZA ,COUNT
          M4, XTA ,1
          M1, ARX ,TOZERO
          M4, ATX ,1
            , UJ  ,COUNT
 CON**  :M4, XTA ,1
          M1, AEX ,FULWORD
            , U1A ,KAPUT
          M4, MTJ ,M3
          M4, MTJ ,M14
C----ПEЧATЬ KOMMEHTAPИЯ----------
         M14, UTM ,2
            , ITS ,M14
         M14, UTM ,14B
            , ITS ,M14
          M1, XTS ,п1
         M13, VJM ,PRINT8
            , ITA ,M4
          M1, AEX ,е15п1
            , ATI ,M4
          M4, UTM ,-1
C---OБ'EДИHEHИE KATAЛOГOB---
 BJOIN  :M2, XTA ,
            , UZA ,*END
          M2, XTA ,1
          M1, AAX ,e47
            , UZA ,BJOI1N
          M2, XTA ,1
          M1, AAX ,е33п1
          M1, ATX ,HEAD
 BJOI1N  :M5, VJM ,ISTHEAR
          M2, UTM ,2
          M3, MTJ ,M14
         M14, UTM ,-NEWCAT+30720
         M14, VZM ,MAT
            , UJ  ,BJOIN
C---HET ЛИ YЖE TAKOГO ИMEHИ-----
 ISTHEAR:M14,VTM,NEWCAT+2
 BSEEK:M14,XTA,
          M2, AEX ,
         M14, UTM ,2
         M14, MTJ ,M12
          M4, J+M ,M12
         M12, VZM ,WRITE
            , U1A ,BSEEK
          M5, UJ  ,
C---ЗAПИCЬ ИMEHИ B KATAЛOГ----
 WRITE  :M2, XTA ,
          M3, ATX ,
          M2, XTA ,1
          M1, AAX ,е15п1
          M1, AOX ,HEAD
          M3, ATX ,1
          M3, UTM ,2
            , XTA ,
          M1, ATX ,HEAD
          M5, UJ  ,
C---ДЛИHA HOBOЙ ЧACTИ БИБЛИOTEKИ--
 *END  :M2, VTM ,NEWCAT
            , XTA ,
          M3, ATX ,
          M1, XTA ,FULWORD
          M3, ATX ,1
          M2, XTA ,
          M1, ARX ,e10п6
          M1, APX ,е24п11
            , ASN ,64-11
            , YTA ,
          M1, AEX ,е15п1
          M1, ARX ,shif1t
          M1, ARX ,SHIFT
            , ATI ,M12
         M12, UTM ,1044B
C--YKAЗATEЛЬ CBOБOДHOГO MECTA--
          M1, XTA ,WRW.Было WC+1
          M1, ARX ,л5674
          M1, ATX ,TOZERO.ЧИСЛO НOBЫX TPAКTOB
          M1, AUX ,е24п11
          M1, XTS ,shi1ft
            , ASN ,64-10
          M1, AEX ,FULWORD
         M15, ARX ,
          M2, ARX ,
          M2, ATX ,
          M1, ATX ,OCRWC
            , ATX ,54B
C---KATAЛOГ TEMPORARY-------
          M1, *70 ,WW
          M1, XTA ,WW
          M1, ARX ,e31e1
          M1, ATX ,537B
          M1, *70 ,537B
         M12, MTJ ,M14
         M14, UTM ,-1
         M14, VZM ,ZEROLENG
          M1, XTA ,WRW
          M1, ARX ,shif1t
          M1, ATX ,WRW
C++++ПEPEПИCЬ БИБЛИOTEKИ++++++++
 RWL  :M1, XTA ,WRW
          M1, ARX ,п1
          M1, ATX ,WRW
          M1, *70 ,WRW
          M1, *70 ,LWWC
C---ПPOBEPKA HA ПOПAДAHИE B ЗOHY--
         M14, VTM ,TABL-2
 CHECK*:M14,UTM,2
         M14, XTA ,
            , UZA ,*0227B
          M1, AAX ,e41п31
          M1, AEX ,BOUND
            , U1A ,CHECK*
         M14, WTC ,
            , UTC ,NEWCAT+1026
            , XTA ,
            , ATI ,M13
            , ASN ,64+15
            , ATI ,M2
          M2, J+M ,M13
            , ASN ,64+15
            , ITS ,M13
         M15, ARX ,
            , ASN ,64-15
          M1, ATX ,WC
         M14, XTA ,
          M1, AAX ,e30п19
          M1, AEX ,WC
            , U1A ,KAPUT1
            , UJ  ,CHECK*
 *0227B  :M1, XTA ,BOUND
          M1, ARX ,e31
          M1, ATX ,BOUND
          M1, XTA ,LWWC
          M1, ARX ,e12п1о5п6
          M1, AAX ,CONST
          M1, ATX ,LWWC
         M12, VLM ,RWL
 ZEROLENG  :M1, XTA ,SHIFT
            , UZA ,RET
         M14, VTM ,TMAЛOMEСTA  .=6HMAЛO M
            , ITA ,M14
          M1, ATX ,DGN
          M1, XTA ,544B
            , UZA ,RET
          M1, APX ,е26п16
          M1, ARX ,e47e43
          M1, ATX ,ENDOV
            , UTC ,NEWCAT
            , XTA ,
          M1, AAX ,e10п6
            , ATI ,M4
          M7, VTM ,2000B
          M4, VZM ,BROV
          M7, VTM ,
          M6, VTM ,
            , ASN ,64+5
            , ATI ,M5
C   ПOДBOД K HAЧAЛY
 TOB:M11,VJM,RW40
          M5, UTM ,-1
          M5, V1M ,TOB
 BROV  :M1, XTA ,TOZERO
            , ASN ,64+2
          M1, AEX ,FULWORD
          M1, ARX ,e38п36
          M1, ARX ,544B
            , UZA ,KAPUT
            , ASN ,64+25
          M1, ARX ,OCRWC
            , ASN ,64-27
          M1, ATX ,WC
          M1, AUX ,e18п13е5п1
          M1, AOX ,LWW1
          M1, ATX ,LWWC
          M1, XTA ,WC
            , ASN ,64+27
          M1, AAX ,e10п6
            , ATI ,M6
          M1, XTA ,WC
          M1, AEX ,FULWORD
          M1, ARX ,ENDOV
            , ASN ,64+32
            , ATI ,M5
 ROV:M11,VJM,RW40
          M5, UTM ,-1
          M5, V1M ,ROV
C---ДOCБPOC БYФEPA-------
          M6, VTM ,2000B
         M13, VJM ,WRITW
          M1, XTA ,e17.БЫЛ OVERLAY
            , AOX ,*REGIM//
            , ATX ,*REGIM//
 RET:M15,WTC,
            , UJ  ,
 MAT:M14,VTM,TПEPEП.=6HПEPEПO
            , ITS ,M14
            , ITS ,
          M1, XTS ,п1
         M13, VJM ,PRINT8
         M15, WTC ,
            , UJ  ,
 KAPUT  :M1, XTS ,DGN
         M15, ATX ,
          M1, ARX ,e3e1
          M1, XTS ,п1
         M13, VJM ,PRINT8
         M15, WTC ,
            , UJ  ,
 RW40:M12,VTM,1-32
 R*W:M13,VJM,READW
         M13, VJM ,WRITW
         M12, VLM ,R*W
         M11, UJ  ,
 READW  :M7, MTJ ,M14
         M14, UTM ,76000B
         M14, V1M ,ROLDTR
          M1, XTA ,WRW
          M1, ARX ,п1
          M1, ATX ,WRW
          M1, *70 ,WRW
          M7, VTM ,
 ROLDTR  :M7, UTC ,NEWCAT+1024
            , XTA ,
          M7, UTM ,1
         M13, UJ  ,
 WRITW  :M6, MTJ ,M14
         M14, UTM ,76000B
         M14, V1M ,WOLDTR
            , XTS ,
          M1, *70 ,LWWC
          M1, XTA ,LWWC
          M1, ARX ,e12п1о5п6
          M1, AAX ,CONST
          M1, ATX ,LWWC
            , STX ,
          M6, VTM ,
 WOLDTR  :M6, UTC ,NEWCAT
            , ATX ,
          M6, UTM ,1
         M13, UJ  ,
 LWW1:   , ATX ,NCL
            , ATX ,
 KAPUT1:M14,MTJ,M4
         M14, VTM ,1-5
 KAPU1T1:M14,ITS,M12
         M14, VLM ,KAPU1T1
          M1, XTS ,INF
            , U1A ,NOHEAD
         M14, VTM ,TИСПППPOГ  .=6HИCПOPЧ
            , ITS ,M14
         M14, UTM ,3
            , ITS ,M14
         M14, VTM ,22B
            , ITS ,M14
         M13, VJM ,PRINT8
 NOHEAD  :M4, XTA ,1
         M14, VTM ,32B
            , ITS ,M14
          M1, ATX ,INF
         M13, VJM ,PT6
         M14, VTM ,1-5
         M13, VTM ,
 NOHEA1D:M13,STI,M12
         M13, UTM ,-1
         M14, VLM ,NOHEA1D
          M4, MTJ ,M14
            , UJ  ,CHECK*
 KAPU2T  :  , ITA ,M13
            , ITS ,M14
          M1, XTS ,ERROR
            , U1A ,KAP2UT
         M13, VTM ,TДЛЯПPAB  .=6H*** ДЛ
            , ITS ,M13
          M1, ATX ,ERROR
            , XTS ,
          M1, XTS ,п1
         M13, VJM ,PRINT8
         M13, VTM ,TИЗЛИЧБИБ  .=6H*** ИЗ
            , ITS ,M13
            , XTS ,
          M1, XTS ,п1
         M13, VJM ,PRINT8
 KAP2UT:M12,XTA,-1
         M13, VTM ,24B
            , ITS ,M13
         M13, VJM ,PT6
            , STI ,M14
            , ATI ,M13
         M10, UJ  ,
        RW :  , XTA ,NCL
            , ATX ,
        WW :   , ATX ,NCL
            , AUX ,
        OCRW :   , XTA ,OCL
            , AUX ,
        lw1w:    , ATX ,LWW
            , ATX ,
 FULWORD:,LOG,7777 7777 7777 7777
 TOZPER:,LOG,776735 77777 77777
 TOZCOM:,LOG,776726 77777 77777
 CONST:,LOG,7777 7777   7777 0037
 TПEPEП  :  , ISO ,24HПEPEПOЛHEH KATAЛOГ BPEME
            , ISO ,24HHHOЙ БИБЛИOTEKИ,ИCПOЛЬЗ
            , ISO ,18HYЙTE ЗAГPYЗЧИK  И
            , ISO ,6HT M ’41’’12’
            , ISO ,6H
 TИСПППPOГ  :  , ISO ,24HИCПOPЧEHЫ ПOДПPOГPAMMЫ:
 TИСПКAT  :  , ISO ,24HИCПOPЧEH KATAЛOГ TEMPORA
            , ISO ,12HRY LIBRARY
 TMAЛOMEСTA  :  , ISO ,36HMAЛO MECTA ДЛЯ OVERLAY
            , ISO ,6H’266’’373’’251’’322’’374’’212’
            , ISO ,24HИCПOPЧEH KATAЛOГ COMMON
            , ISO ,12HLIBRARY
 TИСПOPЧ  :  , ISO ,24HИCПOPЧEH KATAЛOГ PERSONA
            , ISO ,12HL LIBRARY
 TДЛЯПPAB  :  , ISO ,24H*** ДЛЯ ПPABИЛЬHOЙ PAБOT
            , ISO ,18HЫ CИCTEMЫ ИCKЛЮЧИT
            , ISO ,6HE ’12’
 TИЗЛИЧБИБ  :  , ISO ,24H*** ИЗ ЛИЧHOЙ БИБЛИOTEKИ
            , ISO ,18H CЛEД. ПOДПPOГPAMM
            , ISO ,6HЫ:   ’12’
  PCAT:           , ATX ,OCL
            , ATX ,
 STCAT:,LOG,2104000
cнет перед упр. на участок ниже
сисключено для Mонитора-80
          M8, ATX ,SAV
            , ATX ,201B
          M8, ATX ,SAV1
            , ATX ,301B
c-------------------------------
  е41п31:   , OCT ,0037 77
  e26п16:   , LOG ,3 7770 0000
  е17   :   , LOG ,20 0000
  е18е17:   , LOG ,60 0000
  e18п16:   , LOG ,70 0000
  e41п19:   , OCT ,0037 7777 777
  е30п19:    , LOG ,77 7770 0000
  e42п31:          , OCT ,0077 77
  е31 :     , OCT ,0000 01
        e20:    , LOG ,200 0000
  e10п6:          , LOG ,1740
         п1:   , LOG ,1
   e31e1:   , LOG ,100 0000 0001
   п2   :      , LOG ,2
   е12п1о5п6 :        , LOG ,7741
  e35п31 : , OCT ,0000 37
       e47:     , OCT ,2
     e47e43:       , OCT ,21
  л1042:    , OCT ,0010 42
        e3e1: , LOG ,5
  TСONT:          , ISO ,6HCONT
   л5674    :  , OCT ,5674
        e38п36:    , OCT ,0003 4
    о46п8о2п1:   , OCT ,6000 0000 0000 174
   e18п13е5п1 :        , LOG ,77 0037
           е15п2: , LOG ,7 7776
    е18п13о16:    , LOG ,67 0000
   о21п6:         , LOG ,7777 7777 7000 0037
      е15п1:      , LOG ,7 7777
    е33п1:       , OCT ,7777 7777 777
         е24п11:   , LOG ,777 6000
 WC:   , BSS ,2
 WRW:   , BSS ,1
 pca1t:   , BSS ,1
 OCRWC:   , BSS ,1
 LWWC:   , BSS ,1  .LWWC
 TOZERO:   , BSS ,1
 HEAD:   , BSS ,1 .532.B
 SHIFT:   , BSS ,1
 shif1t  :  , BSS ,1
 sh1ift:, BSS ,1
 shi1ft:, BSS ,1
 , BSS ,1
 PLACE  :  , BSS ,1
 FLAG:   , BSS ,1
 DGN:   , BSS ,1
 D:   , BSS ,1
    , BSS ,1
 ENDOV:   , BSS ,1
 BOUND:   , BSS ,1
 INF:   , BSS ,1
 ERROR:   , BSS ,1
            , END ,
