 IOXXFMR*:  , NAME,
C
C*******************************************
C*                                         *
C*                                         *
C*  ПOДПPOГPAMMA HИЖHEГO YPOBHЯ ДЛЯ        *
C*  ФOPTPAHHЫX OПEPATOPOB  READ/WRITE.     *
C*                                         *
C*  '1' B 48 PAЗPЯДE  A C    - ПPИЗHAK     *
C*  BЫXOДA HA HAЧAЛO HOBOГO PEKOPДA        *
C*  ПPИ ЭTOM OCTAЛЬHЫE PAЗPЯДЫ ACC TAKOBЫ: *
C*       1 - 6  ЛOГ. HOMEP YCTPOЙCTBA      *
C*        47    END FILE                   *
C*        46    REWIND                     *
C*        45    BACKSPACE                  *
C*        44    WRITE /YCTAHOBOЧHЫЙ BXOД/  *
C*        43    READ  /YCTAHOBOЧHЫЙ BXOД/  *
C*        42    SCHEOF                     *
C*                                         *
C*  '0' B 48 P.  A C   - ПPИЗHAK PAБOTЫ    *
C*  C MACCИBOM ИЗ TEKYЩEГO PEKOPДA.        *
C*  ПPИ ЭTOM OCTAЛЬHЫE PAЗPЯДЫ ACC TAKOBЫ: *
C*      1 - 15  AДPEC HAЧAЛA MACCИBA       *
C*     25 - 39  AДPEC KOHЦA  MACCИBA       *
C*       40     OБMEH ИHФOPMAЦИEЙ          *
C*       41     C ПPOBEPKOЙ HA KOД  012    *
C*       42     C ЗAKPЫTИEM PEKOPДA        *
C*                                         *
C*  '0' BO BCEX PAЗPЯДAX  A C    - BXOД    *
C*      ИЗ  STOP*  /ДOCБPOC БYФEPOB/.      *
C*                                         *
C*******************************************
c
 LEX:    ,equ,43B .обм.лист
 AC:     ,equ,10B .сумматор
с
 A/I0    :  , LC  ,1
 *ICHECK*:LC,BLOCK,I0,I1),I2(2),I4,I5
c  *0:B,BLOCK,CONTROL.PEAKЦИЯ HA OШИБKИ
c  ,CONT,ZONE.TEKYЩAЯ ЗOHA
c  ,CONT,FLER.HOMEP OШИБKИ
c  ,CONT,BAD READ.ЧTEHИE ПO 'KO'
 RFMRTFLG:  , LC  ,1.BЛAДEЛEЦ OБM.ЛИCTA
 SAVELEXX:  , SUBP,
 STOP*   :  , SUBP,
 GIVELEXX:  , SUBP,
 RD/BT   :  , SUBP,
 WR/BT   :  , SUBP,
C
C
C****** ИHДEKC-PEГИCTPЫ ******
C
c  *1:B,BLOCK,B.БAЗOBЫЙ
c  ,CONT,C.*ICHECK*
c  ,CONT,Z.TEK.ЗOHA
c  ,CONT,LR(0)
c  ,CONT,REC.TEK.PEKOPД /0,1,../
c  ,CONT,AR .AДP.ПO ФИЗ.PEK./-23,..,0/
c  ,CONT,FR .ФЛAГ ЧTEHИЯ ЗOHЫ+1
c  ,CONT,FW .ФЛAГ ЗAПИCИ TEK.ЗOHЫ
c  ,CONT,A.AДPEC ПO БYФEPY /10,36,..,998/
c  ,CONT,T.HOMEP YCTPOЙCTBA
c  ,CONT,E.HOMEP OШИБKИ
c  ,CONT,ER(0).N OШ.ДЛЯ П/П ДИAГHOCTИKИ
c  ,CONT,AM.TEK.AДP.ПO MACCИBY
c  ,CONT,RR
c  ,CONT,R
 *1      :  ,BLOCK,M1,M2,M3,M4,M5,M6,M7,M8,M9
            , CONT,M10,M11,M12,M13,M14,M15
c
C
C*** PEГИCTPЫ  Z-T  XPAHЯTCЯ B HAЧAЛE ЛИCTA ***
C
C=====================================
            , UTC ,AC
C======================================
 IOXXFMW*:  ,ENTRY,
C======================================
          M3, VTM ,
          M2, VTM ,п20  .=20
            , ITS ,M13
         M15, WTC ,-1
            , XTS ,
            , UZA ,*0241B
          M6, VTM ,-6
 PRINTERR  :  , UTC ,TRWN  .=6HRWN
          M6, AEX ,
            , UZA ,*0026B
            , UTC ,TRWN  .=6HRWN
          M6, AEX ,
          M6, VLM ,PRINTERR
         M13, VJM ,STOP*
 *0011B  :  , WTC ,LEX
          M4, XTA ,
          M2, AEX ,6
         M14, VTM ,3
            , UZA ,*0016B
          M2, AEX ,6
          M2, AEX ,7
         M14, VTM ,
            , UZA ,*0016B
         M14, VTM ,1
 *0016B  :  , ITA ,M14
          M1, ATX ,3
          M6, UJ  ,
 *0020B  :M6, VJM ,*0011B
          M1, XTA ,AC
            , AOX ,A/I0
            , UTC ,*ICHECK*+1
            , ATX ,
 *0023B  :M4, J+M ,M5
            , ITA ,M5
          M1, STX ,6
            , STI ,M13
         M15, UTM ,-4
         M13, UJ  ,
 *0026B  :M6, VZM ,*0160B
          M3, J+M ,M6
          M1, XTA ,AC
         M13, VJM ,в*GIVELEXX
          M6, UTM ,AC
         M13, VJM ,*0163B
         M13, VTM ,*0023B
            , ITA ,M6
            , ASN ,64+1
            , ATI ,M6
            , YTA ,
          M6, U1A ,*0035B
 *0034B  :M6, WTC ,*0034B
            , UJ  ,
 *0035B  :  , ATX ,
            , UJ  ,*0045B
            , UJ  ,*0173B
            , UJ  ,*0200B
            , UJ  ,*0206B
            , UJ  ,*0213B
            , UJ  ,*0231B
            , UJ  ,*0160B
            , ATX ,
            , UJ  ,*0045B
            , UJ  ,*0173B
            , UJ  ,*0200B
            , UJ  ,*0060B
            , UJ  ,*0107B
            , UJ  ,*0134B
            , UJ  ,*0160B
 *0045B  :M4, MTJ ,M14
         M14, UTM ,-10
          M4, UTM ,-26
         M14, V1M ,*0054B
          M1, WTC ,AC
         M14, VTM ,
          M4, VTM ,12B
          M5, VTM ,
         M14, VZM ,*0020B
         M14, UTM ,-1
            , ITA ,M14
         M13, VJM ,в*GIVELEXX
          M4, VTM ,1746B
 *0054B  :  , WTC ,LEX
          M4, XTA ,
          M2, AEX ,7
            , UZA ,*0020B
          M2, AEX ,7
          M2, AEX ,6
            , U1A ,*0045B
            , UJ  ,*0020B
 *0060B  :M6, VJM ,*0011B
          M6, VTM ,*ICHECK*
            , XTA ,
          M6, ATX ,4
          M6, XTA ,
          M6, AAX ,2
          M2, AAX ,3
         M14, VTM ,3
            , U1A ,*0075B
            , XTA ,A/I0
          M6, ATX ,2
          M1, WTC ,3
         M14, VTM ,-3
         M14, V1M ,*0073B
          M2, AOX ,3
          M6, ATX ,2
          M6, XTA ,
          M2, AAX ,3
         M14, VTM ,3
            , UZA ,*0075B
            , UJ  ,*0074B
 *0073B:M14,UTM,3
         M14, V1M ,*0075B
 *0074B:M13,UJ,
 *0075B  :M2, XTA ,3
            , AOX ,A/I0
          M6, ATX ,2
            , ITA ,M14
            , UJ  ,*0100B
 *0100B  :M1, XTS ,17B
            , U1A ,*0103B
            , STX ,
          M2, AOX ,
          M1, ATX ,3
            , UJ  ,*0023B
 *0103B:M15,XTA,
            , AOX ,A/I0
            , UTC ,*ICHECK*+4
            , ATX ,
         M14, VTM ,12B
            , ITA ,M14
          M1, ATX ,3
            , UJ  ,*0023B
 *0107B  :  , UTC ,*ICHECK*+2
            , XTA ,
          M2, AAX ,3
            , U1A ,*0023B
         M14, VTM ,30B
            , WTC ,LEX
          M4, XTA ,31B
            , UZA ,*0120B
            , AOX ,A/I0
         M15, ATX ,
            , NTR ,3
          M2, A*X ,20B
            , NTR ,6
          M2, A*X ,23B
            , NTR ,3
            , A+X ,A/I0
         M15, X-A ,
            , ATI ,M14
 *0120B  :  , ITA ,M14
            , ITS ,M5
         M15, AEX ,
            , U1A ,*0125B
            , WTC ,LEX
          M4, XTA ,31B
          M6, VTM ,*0107B
            , UZA ,*0152B
          M2, XTA ,17B
            , UJ  ,*0100B
 *0125B  :M5, UTM ,1
            , WTC ,LEX
          M4, UTC ,
          M5, XTA ,
         M15, WTC ,-4
            , ATX ,
         M15, XTA ,-4
         M15, AEX ,-3
            , UZA ,*0023B
         M13, VTM ,*0120B
 *0132B:M15,XTA,-4
          M2, ARX ,3
         M15, ATX ,-4
         M13, UJ  ,
 *0134B  :  , WTC ,LEX
          M4, XTA ,31B
         M15, ATX ,
            , AOX ,A/I0
            , UTC ,*ICHECK*+5
            , STX ,
          M6, VTM ,*0020B
            , U1A ,*0152B
          M6, VJM ,*0152B
            , WTC ,LEX
          M4, XTA ,
            , U1A ,*0020B
            , UJ  ,*0134B
 в*GIVELEXX:M15,MTJ,M14
            , ITS ,M14
            , ITS ,M1
            , UJ  ,GIVELEXX
 *0145B  :M2, XTA ,3
          M1, ATX ,13B
            , ASN ,64-39
            , AAX ,RFMRTFLG
            , AEX ,RFMRTFLG
            , ATX ,RFMRTFLG
         M14, UJ  ,
 *0151B:M14,VJM,*0145B
 *0152B  :M4, MTJ ,M14
         M14, UTM ,76032B
         M14, V1M ,*0157B
          M1, XTA ,AC
          M2, ARX ,3
         M13, VJM ,в*GIVELEXX
          M4, VTM ,12B
 *0156B  :M5, VTM ,
          M6, UJ  ,
 *0157B  :M4, UTM ,32B
            , UJ  ,*0156B
 *0160B  :M4, VTM ,12B
          M5, VTM ,
            , XTA ,
         M13, VJM ,в*GIVELEXX
            , UJ  ,*0020B
 *0163B  :M1, WTC ,6
         M14, VTM ,-10
            , ITA ,M14
            , AOX ,A/I0
         M15, ATX ,
            , NTR ,3
          M2, A*X ,21B
            , NTR ,6
          M2, A*X ,22B
            , NTR ,3
            , A+X ,A/I0
            , ATI ,M4
          M4, UTM ,12B
         M15, X-A ,
            , ATI ,M5
         M13, UJ  ,
 *0173B  :M2, XTA ,6
            , WTC ,LEX
          M4, ATX ,
         M14, VJM ,*0145B
          M6, VJM ,*0151B
         M13, VTM ,*0020B
            , ITS ,M1
            , UJ  ,SAVELEXX
 *0200B  :M6, VTM ,*0200B
            , WTC ,LEX
          M4, XTA ,
            , UZA ,*0152B
          M2, AEX ,7
            , UZA ,*0152B
          M2, AEX ,7
          M2, AEX ,6
         M14, VTM ,1
            , U1A ,*0075B
          M6, VTM ,*0020B
            , UJ  ,*0152B
 *0206B  :M2, XTA ,7
            , WTC ,LEX
          M4, ATX ,
            , XTA ,
         M14, VTM ,*ICHECK*
         M14, ATX ,5
         M14, ATX ,4
         M14, VJM ,*0145B
         M13, UJ  ,
 *0213B  :M5, MTJ ,M14
         M14, UTM ,-24
         M14, V1M ,*0221B
            , XTA ,
            , WTC ,LEX
          M4, ATX ,31B
          M6, VJM ,*0151B
            , XTA ,
            , WTC ,LEX
          M4, ATX ,
 *0221B:M15,WTC,-4
            , XTA ,
          M5, UTM ,1
            , WTC ,LEX
          M4, UTC ,
          M5, ATX ,
          M2, XTA ,3
            , UTC ,*ICHECK*+5
            , ARX ,
            , UTC ,*ICHECK*+5
            , ATX ,
         M15, XTA ,-4
         M15, AEX ,-3
            , UZA ,*0023B
         M13, VTM ,*0213B
            , UJ  ,*0132B
 *0231B:M14,VTM,*ICHECK*+5
         M14, XTA ,
            , WTC ,LEX
          M4, ATX ,31B
            , AOX ,A/I0
         M14, ATX ,
          M6, VJM ,*0151B
          M1, XTA ,16B
            , U1A ,*0020B
          M2, XTA ,6
            , WTC ,LEX
          M4, ATX ,
         M14, VTM ,*0020B
            , UJ  ,*0145B
 *0241B  :M1, XTA ,AC
         M13, VJM ,в*GIVELEXX
         M13, VJM ,*0163B
          M3, VZM ,*0301B
         M13, VJM ,*0060B
            , UTC ,*ICHECK*+2
            , XTA ,
          M2, AAX ,3
            , U1A ,*0134B
         M14, VTM ,-23
         M15, WTC ,-4
         M13, VTM ,
          M2, XTA ,24B
 *0250B:M13,UTC,
         M14, ATX ,27B
         M14, VLM ,*0250B
          M2, XTA ,25B
         M13, ATX ,30B
          M6, VTM ,30B
          M3, VTM ,6
          M7, VTM ,77553B
 *0254B  :M3, UTM ,-6
          M3, V1M ,*0262B
          M3, VTM ,-6
            , ITA ,M6
            , ITS ,M5
         M15, AEX ,
          M5, UTM ,1
            , U1A ,*0262B
          M6, VJM ,*0152B
          M6, VTM ,1
          M5, VTM ,1
 *0262B  :M3, UTM ,7
            , WTC ,LEX
          M9, VTM ,
          M4, J+M ,M9
          M5, J+M ,M9
          M3, MTJ ,M10
         M13, VJM ,RD/BT
          M1, ATX ,20B
            , ASN ,64-8
            , YTA ,
            , ATI ,M14
            , ASN ,64+7
            , UZA ,*0273B
         M14, J+M ,M7
          M7, UTM ,-128
            , UJ  ,*0254B
 *0273B:M14,UTM,-10
         M14, VZM ,*0134B
         M15, XTA ,-4
            , ATI ,M9
          M7, UTM ,226B
          M7, MTJ ,M10
          M1, XTA ,20B
         M13, VJM ,WR/BT
          M7, UTM ,77553B
          M7, V1M ,*0254B
            , UJ  ,*0134B
 *0301B:M13,VJM,*0206B
          M6, VTM ,
          M7, VTM ,6
          M3, VTM ,
 *0304B  :M3, MTJ ,M14
         M14, UTM ,-6
         M14, V1M ,*0313B
         M15, XTA ,-4
         M15, AEX ,-3
            , ATI ,M14
          M2, XTA ,4
          M3, VTM ,7
         M14, VZM ,*0316B
         M15, XTA ,-4
          M2, ARX ,3
         M15, ATX ,-4
          M3, VTM ,
 *0313B  :M3, UTM ,1
         M15, WTC ,-4
          M9, VTM ,
          M3, MTJ ,M10
         M13, VJM ,RD/BT
 *0316B  :M1, ATX ,20B
          M2, AEX ,5
          M6, UTM ,1
            , UZA ,*0304B
          M6, UTM ,-1
          M6, VZM ,*0324B
          M3, UTM ,-1
          M6, UTM ,200B
            , ITA ,M6
            , ASN ,64-40
          M1, ATX ,20B
          M6, VTM ,
 *0324B  :M7, MTJ ,M14
         M14, UTM ,-6
         M14, V1M ,*0340B
          M5, UTM ,-24
          M5, V1M ,*0334B
            , XTA ,
            , WTC ,LEX
          M4, ATX ,31B
          M6, VJM ,*0151B
          M6, VTM ,
            , XTA ,
            , WTC ,LEX
          M4, ATX ,
          M5, VTM ,-24
 *0334B  :M2, XTA ,3
            , UTC ,*ICHECK*+5
            , ARX ,
            , UTC ,*ICHECK*+5
            , ATX ,
          M5, UTM ,31B
          M7, VTM ,
 *0340B  :M7, UTM ,1
            , WTC ,LEX
          M9, VTM ,
          M4, J+M ,M9
          M5, J+M ,M9
          M7, MTJ ,M10
          M1, XTA ,20B
         M13, VJM ,WR/BT
          M1, XTA ,20B
          M2, AEX ,4
            , U1A ,*0304B
          M7, UTM ,-6
            , ITA ,M7
          M7, VTM ,5
            , U1A ,*0340B
            , UJ  ,*0231B
 п20  :  , LOG ,20
            , LOG ,177
            , LOG ,3
            , LOG ,1
            , OCT ,024
            , OCT ,1
            , OCT ,3
            , OCT ,6
            , ISO ,24HBSP   EOF   SEF   REC
            , ISO ,12HADD   END
 TRWN  :  , ISO ,6HRWN
            , LOG ,2
            , LOG ,4000 5252 5252 5252
            , LOG ,4000 4730 4730 4731
            , INT ,26
            , INT ,24
            , ISO ,6H
            , ISO ,6H     ’12’
            , END ,
