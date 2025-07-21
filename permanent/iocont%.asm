c IOCONT* :  , NAME,
C
C** FPACK-IOCONT*(A,E)
C      ПOЛЬЗOBATEЛЬСКAЯ ПPOЦEДУPA ДЛЯ
c      ПPOДOЛЖEНИЯ BBOДA-BЫBOДA
c
 *0      :   , EQUAL ,
 *0: , BLOCK , A1, A13,A17, A1750,A17700, A20077, A377
 ,CONT,A5,A60,A77777,BIT1/6,BIT1/7,BIT2/48  .06
 , CONT, BIT1/40,BIT1/41,BIT10/11,BIT10/14,BIT1/48
 , CONT, BIT12,BIT10,BIT12/14, BIT12/15, BIT14
 , CONT, BIT15,  BIT16,  BIT17,  BIT13/48, BIT16/41,
 , CONT, BIT3/4,BIT37/48, BIT41/48                      .03
 , CONT, BIT43/48, BIT48(0), EXP64, BIT7,               .03
 , CONT, BIT8, BIT8/15,BIT9/48,VGR0,EX640(0),VGR(6).10
 ,CONT,CT(64),REAL1(0),DEINS(2)                         .66
 ,CONT,E1(0),D10(2),R1/2(0),D1/2(2),REAL5/4,R5/4H13
 ,CONT,EKSPO(19),
 , CONT  , SECHS,  Z1/10,  D1/10(2), D10E40(2),         .06
 , CONT  , D10E*40(2),EOR,                              .03
 , CONT  , VMASKE1,VMASKE2,VW1, VW2,VH, VP              .06
 , CONT  , SPACE,  EX645,  K3HREC, K3HADD,              .04
 , CONT  , MAXEXNZ,FTXT(14), GRZAHL, ISOSP,NBIT45,BIT46 .19
 , CONT  , BIT45,  BIT2/47,NZL, KRECORD,A4, BIT46/48,   .06
 *0:, BLOCK,SYMB,ENDE,KUSP/USP,KNEXTLET,PW,KWSY, SFAKT,
 , CONT  , AUSG2,D,NSP, CENC,NSYMB                       .05
 , CONT  , II13,   ER/AB,  ADCONT, ADR/W,  ADEND,  FORMAT, LUN,
 , CONT  , I/O, GLREG(7),BEGREC, ADNBPROG,(1)            .11
 , CONT  , RECORD(25),     GWF(5), EAD(5), FTT, SWUEBERL, WF .38
 , CONT  , W,      NIW,    KBASP,  STLUN,  AC,               .05
 , CONT  , INOUT,  LUN*,   L/NLGLRE,       KOFSPEC,        TRWADR,
 , CONT  , FNR,    II15,   NSP3,   ZHLR,   FTBE/SONST,        .05
 , CONT  , LASP                .LAENGE DES ARBEITSSPEICHERS    01
 LUNMUN  :  , LC  ,1
 CHECKFL*:  , LC  ,1
  KLUN    :   , EQU   , FTXT + 6
  KADDRESS:   , EQU   , FTXT + 12
  KFORMAT :   , EQU   , FTXT + 10
  KSPEC   :   , EQU   , FTXT + 7
  MAG     :   , EQU   , 10
  X       :   , EQU   , 6
  NWO     :   , EQUAL ,  2
  NSG     :   , EQUAL ,  6
  NSY     :   , EQUAL ,  7
  R2      :   , EQUAL , 12
  S       :   , EQUAL , 15
  R4      :   , EQUAL , 14
  A       :   , EQUAL ,  8
  C       :   , EQUAL , 1
  I       :   , EQUAL , 13
  R3      :   , EQUAL , 13
  SY      :   , EQUAL ,  14
  RR      :   , EQU   , 5
  K       :   , EQUAL , 13
  L       :   , EQUAL , 11
  STOP*   :   , SUBP  ,
C     ПEPEXBAT OШИБKИ BBOДA
  I11     :   , EQU   , 11
  LMU     :   , EQU   , 14
  I1      :   , EQUAL ,  1
  I3      :   , EQUAL , 3
  I4      :   , EQUAL , 4
  I8      :   , EQUAL , 8
  I12     :   , EQUAL , 12
  I14     :   , EQUAL , 14
 LUN*MON :  , SUBP,
 SUBPERR*:  , SUBP,
 OCTTDEC :  , SUBP,
 *1      :  ,BLOCK,M1,M2,M3,M4,M5,M6,M7,M8,M9
            , CONT,M10,M11,M12,M13,M14,M15
c
 IOCONT*:M14,VTM,IOC1
            , UJ  ,RGTRI13*
          M1, XTA ,           . ENTRY: IOEND*1
            , UJ  ,IO1
            , UJ  ,FPF*ABBR
         :  , UJ  ,FPF*ABBR+2
 :M14,VTM,LUNMUN-1
            , UJ  ,SETLUN*
            , UJ  ,READSY2
         :  , UJ  ,READSY2F
         :  , UJ  ,*0312B
 :M15,ATX,
            , UJ  ,*0345B
         M11, VTM ,*0346B
            , UJ  ,*0354B
            , UJ  ,RGTRI13*
         :  , UJ  ,*0371B
         :  , UJ  ,*0366B
         :  , UJ  ,*0316B
         :  , UJ  ,*0334B
         :  , UJ  ,*0341B
 IOC1  :M8, STX ,1
            , ATI ,M3
            , NTR ,3
          M8, A-X ,1
            , ATI ,M4
         M13, VJM ,*0371B
         M12, VTM ,*0047B
          M1, A-X ,
            , UZA ,*0042B
            , XTA ,
 *0025B  :M8, ATX ,110B
            , ITA ,M12
          M8, ATX ,34B
            , NTR ,2
          M8, XTA ,106B
            , U1A ,*0366B
          M8, XTA ,15B
            , UZA ,*0040B
          M8, WTC ,16B
            , UJ  ,
C======================================
 IOAC*   :  ,ENTRY,
C======================================
         M15, ATX ,
         M14, VJM ,RGTRI13*
          M8, ATX ,111B
          M8, UTC ,111B
          M3, VTM ,
            , ITA ,M3
          M8, ATX ,1
          M4, VTM ,
         M12, VTM ,*0051B
          M1, XTA ,
         M13, VTM ,*0025B
            , UJ  ,*0371B
 *0040B:M12,Z31,FPF*ABBR
            , UTC ,216B
            , UJ  ,*0366B
 *0042B  :  , ITA ,M12
          M8, ATX ,34B
         M12, Z31 ,FPF*ABBR
            , UTC ,1225B
            , UJ  ,*0366B
C======================================
 FT*002  :  ,ENTRY,
C======================================
 *0045B  :  , ITS ,M14
            , UJ  ,IOCONT*
C======================================
 FD*642  :  ,ENTRY,
C======================================
 FD*722  :  ,ENTRY,
C======================================
 FC*722  :  ,ENTRY,
C======================================
 FC*642  :  ,ENTRY,
C======================================
 FC*002  :  ,ENTRY,
C======================================
         M14, UTM ,1
            , UJ  ,*0045B
 *0047B  :M2, A+X ,4517B
          M4, *64 ,7516B
          M5, 102 ,5040B
            , ATX ,
 *0051B  :M2, A+X ,4517B
          M4, E+X ,1452B
          M2, ATX ,
            , ATX ,
C======================================
 IOEND*  :  ,ENTRY,
C======================================
 FT*003  :  ,ENTRY,
C======================================
         M14, VJM ,RGTRI13*
            , XTS ,
 IO1  :M8, ATX ,114B
         M14, VTM ,
          M8, XTA ,15B
            , UZA ,*0064B
          M8, XTA ,106B
            , ANX ,
            , ATI ,M14
            , XTA ,
          M8, ATX ,15B
          M8, ATX ,21B
          M8, ATX ,106B
          M8, WTC ,20B
         M14, VZM ,
 *0064B  :M8, XTA ,114B
         M13, U1A ,
            , UJ  ,*0345B
 *0066B  :  , ITA ,M5
          M5, VJM ,*0127B
          M5, VTM ,*0217B
            , UJ  ,*0134B
 FPF*ABBR  :  , ITA ,M5
          M5, VJM ,*0127B
          M5, VTM ,*0113B
            , UJ  ,*0134B
         :  , ITA ,M5
          M5, VJM ,*0127B
          M5, VJM ,*0134B
          M5, VTM ,*0113B
          M8, XTA ,12B
            , U1A ,*0103B
          M8, UTC ,35B
         M13, VTM ,
          M1, XTA ,252B
         M13, ATX ,
            , ITS ,M13
         M13, UTM ,30B
            , ITS ,M13
            , XTS ,
          M5, MTJ ,M13
            , UJ  ,LUN*MON
 *0103B  :M8, WTC ,33B
          M2, VTM ,-1
          M2, XTA ,
          M1, XTS ,252B
          M2, ATX ,
            , ITA ,M2
          M8, WTC ,22B
         M13, VTM ,-1
            , ITS ,M13
            , XTS ,
         M13, VJM ,LUN*MON
          M2, CTX ,
          M5, UJ  ,
 *0113B  :M8, XTA ,117B
          M1, AAX ,27B
            , U1A ,*0117B
          M8, XTA ,117B
          M1, AAX ,30B
            , AOX ,CHECKFL*
            , U1A ,*0217B
 *0117B:M13,VTM,*0121B
            , ITA ,M13
         M15, ATX ,-6
            , UJ  ,*0217B
 *0121B  :M8, WTC ,14B
         M13, VTM ,
          M8, WTC ,120B
         M15, VTM ,
         M11, VJM ,*0354B
         M14, VJM ,SUBPERR*
            , BSS ,1
            , UJ  ,STOP*
 *0127B  :  , ITS ,M2
          M2, VTM ,-8
 *0130B  :M2, ITS ,M14
          M2, VLM ,*0130B
          M8, XTS ,
          M8, XTS ,121B
          M8, XTS ,122B
         M15, ATX ,
          M5, UJ  ,
 *0134B:M15,MTJ,M10
          M1, XTA ,225B
          M1, XTS ,226B
         M15, ATX ,
         M10, WTC ,-6
            , XTA ,-1
          M8, ATX ,117B
          M1, AAX ,6
          M1, ATX ,77530B
            , ASN ,64-39
          M1, AUX ,212B
          M1, AOX ,214B
          M1, XTS ,227B
          M1, XTS ,230B
          M8, WTC ,34B
          M6, VTM ,
          M6, XTS ,
          M6, XTS ,1
          M1, XTS ,231B
          M1, XTS ,232B
          M8, XTS ,14B
          M1, ARX ,11B
            , ASN ,64-33
          M1, AUX ,213B
          M1, AOX ,215B
          M8, XTS ,15B
            , UZA ,*0167B
          M8, XTA ,12B
            , U1A ,*0155B
          M1, XTA ,233B
          M8, XTS ,22B
         M13, VJM ,OCTTDEC
            , ASN ,64-32
         M15, ATX ,
 *0155B  :M8, XTA ,115B
            , U1A ,*0225B
          M8, XTA ,117B
          M1, AAX ,24B
          M8, AOX ,110B
            , U1A ,*0164B
          M1, XTA ,241B
          M1, XTS ,242B
          M8, XTS ,116B
            , ASN ,64-33
          M1, AUX ,213B
          M1, AOX ,215B
         M15, ATX ,
 *0164B  :M8, XTA ,21B
            , UZA ,*0167B
          M1, XTA ,237B
          M1, XTS ,240B
         M15, ATX ,
 *0167B  :M1, XTA ,211B
          M8, XTS ,21B
 *0170B  :  , ITS ,M10
            , ITS ,M15
            , XTS ,
         M13, VJM ,LUN*MON
         M10, MTJ ,M15
          M5, UZA ,
          M8, XTA ,21B
          M1, AOX ,254B
          M8, ATX ,122B
         M13, VTM ,1
         M11, VTM ,175B
            , XTA ,
          M8, ATX ,121B
         M15, ATX ,
          M6, VTM ,-5
 *0200B:M12,VJM,*0316B
            , ATI ,M14
         M14, V1M ,*0203B
         M14, VTM ,36B
 *0203B:M15,XTA,
            , ASN ,64-8
            , ITS ,M14
          M1, AAX ,6
         M15, AEX ,
         M15, ATX ,
          M6, VLM ,*0210B
            , XTA ,
         M15, ATX ,
          M6, VTM ,-5
 *0210B:M11,UTM,-1
         M11, VZM ,*0214B
         M14, UTM ,-40
         M14, VZM ,*0216B
         M14, UTM ,-1
         M14, V1M ,*0200B
         M13, VLM ,*0200B
 *0214B  :M1, XTA ,211B
            , XTS ,
            , UJ  ,*0170B
 *0216B:M13,UTM,-1
            , UJ  ,*0200B
 *0217B:M15,XTA,
          M8, STX ,122B
          M8, STX ,121B
          M8, STX ,
          M5, VTM ,11B
 *0222B  :M5, STI ,M5
          M5, UTM ,-1
          M5, V1M ,*0222B
            , STI ,M2
            , ATI ,M5
         M12, UJ  ,
 *0225B  :M1, XTA ,234B
          M1, XTS ,235B
          M1, XTS ,236B
         M15, ATX ,
          M8, XTA ,115B
          M8, ATX ,122B
         M13, VTM ,-5
         M12, VTM ,*0233B
            , UJ  ,*0334B
 *0232B:M12,VJM,*0316B
 *0233B  :M1, AAX ,6
            , U1A ,*0235B
         M14, VTM ,36B
            , ITA ,M14
 *0235B:M15,ATX,
         M13, VLM ,*0232B
            , UJ  ,*0164B
 SETLUN*  :M8, XTA ,22B
          M8, ATX ,113B
            , XTA ,
          M8, ATX ,107B
         M13, UJ  ,
 READSY2  :M6, VZM ,*0257B
          M6, UTM ,-1
          M8, XTA ,11B
            , U1A ,*0260B
          M7, VZM ,*0263B
          M7, UTM ,1
 *0245B  :M2, XTA ,
          M1, UTC ,47B
          M7, ASX ,5
          M1, AAX ,6
          M8, ATX ,
          M8, XTA ,12B
            , U1A ,*0265B
          M8, XTA ,
          M1, AEX ,211B
            , UZA ,*0270B
 *0252B  :M8, XTA ,
          M1, AAX ,43B
            , U1A ,*0277B
          M8, XTA ,
 *0254B  :M1, AAX ,42B
            , U1A ,*0301B
          M8, WTC ,
          M1, XTA ,70B
 *0256B  :M8, ATX ,
         M12, UJ  ,
 *0257B  :M8, WTC ,7
            , UJ  ,
 *0260B  :M1, ARX ,11B
          M1, AAX ,11B
          M8, ATX ,11B
          M1, XTA ,130B
          M8, ATX ,
         M12, UJ  ,
 *0263B  :M2, UTM ,1
 *0264B  :M7, VTM ,-5
            , UJ  ,*0245B
 *0265B  :M8, XTA ,13B
            , UZA ,*0270B
          M1, ARX ,11B
          M1, AAX ,11B
          M8, ATX ,13B
            , UJ  ,*0252B
 *0270B:M12,MTJ,M7
 :M12,Z31,*0066B
            , UTC ,40204B
          M7, MTJ ,M12
            , ITA ,M13
         M15, ATX ,
          M8, WTC ,17B
         M13, VJM ,
         M15, XTA ,
            , ATI ,M13
            , UJ  ,*0264B
 *0277B  :M8, XTA ,
          M1, AAX ,13B
            , U1A ,*0260B
            , UJ  ,READSY2
 *0301B  :M8, XTA ,
          M1, AAX ,12B
          M8, ATX ,
          M8, WTC ,
          M1, XTA ,70B
            , ASN ,64+24
            , UJ  ,*0256B
 READSY2F  :  , ITA ,M12
         M15, ATX ,
 *0306B  :M6, VZM ,*0315B
         M12, VJM ,READSY2
          M1, AEX ,130B
            , UZA ,*0306B
          M8, XTA ,
         M15, WTC ,
            , UJ  ,
 *0312B  :M7, UTM ,5
          M7, VZM ,*0314B
          M7, UTM ,-6
         M12, UJ  ,
 *0314B  :M2, UTM ,-1
         M12, UJ  ,
 *0315B:M15,XTA,
            , UJ  ,*0257B
 *0316B  :M8, XTA ,121B
            , U1A ,*0331B
          M8, XTA ,122B
          M1, ARX ,245B
            , U1A ,*0326B
 *0321B  :M8, ATX ,122B
          M8, WTC ,122B
            , XTA ,
          M8, ASX ,122B
          M1, AAX ,6
          M8, ATX ,
          M1, AAX ,43B
            , U1A ,*0327B
          M8, XTA ,
            , UJ  ,*0254B
 *0326B  :M1, ARX ,251B
            , UJ  ,*0321B
 *0327B  :M8, XTA ,
          M1, AAX ,13B
            , UZA ,*0316B
 *0331B  :M1, ARX ,6
          M1, AAX ,6
          M8, ATX ,121B
          M1, XTA ,130B
          M8, ATX ,
         M12, UJ  ,
 *0334B  :  , ITA ,M12
         M15, ATX ,
 *0335B:M12,VJM,*0316B
          M1, AEX ,130B
            , UZA ,*0335B
          M8, XTA ,
         M15, WTC ,
            , UJ  ,
 *0341B  :M8, XTA ,122B
          M1, ARX ,247B
          M8, ATX ,122B
          M1, ARX ,246B
         M12, UZA ,
          M1, ARX ,250B
          M8, ATX ,122B
         M12, UJ  ,
 *0345B:M11,VJM,*0354B
 *0346B:M15,XTA,
            , NTR ,2
          M8, WTC ,14B
            , UJ  ,
 RGTRI13*  :  , WTC ,*0361B
          M8, VTM ,
         M15, ATX ,
         M11, VJM ,*0354B
            , ITA ,M13
          M8, STX ,14B
          M1, VTM ,CONS  .=1
         M14, UJ  ,
 *0354B  :M9, VTM ,-6
 *0355B  :M8, UTC ,24B
          M9, XTA ,6
          M9, ITS ,M7
          M8, UTC ,24B
          M9, STX ,6
          M9, ATI ,M7
          M9, VLM ,*0355B
         M11, UJ  ,
 *0361B:M13,ATX,
            , Z00 ,ASP
C======================================
 IOSVFR  :  ,ENTRY,
C======================================
            , ATI ,M14
            , UTC ,*0361B
            , XTA ,
         M14, XTS ,
            , UTC ,*0361B
            , STX ,
            , NTR ,6
         M13, UJ  ,
 *0366B  :M8, WTC ,120B
         M15, VTM ,
         M11, VJM ,*0354B
          M8, WTC ,14B
            , UJ  ,
 *0371B:M15,ATX,
         M15, UTM ,-2
            , ITA ,M15
         M15, UTM ,2
          M8, STX ,120B
         M13, UJ  ,
C======================================
 SUBPERR*:  ,ENTRY,
C======================================
         M14, UJ  ,1
 CONS  :  ,bss,
c
 ,  LOG  , 1                   A1
 , LOG   , 13                 A13
 ,  LOG  , 17                  A17
 , LOG   , 1750                A1750 = 1000
 ,  LOG  , 1770 0             A17700
 ,  LOG  , 2007 7             A20077
 ,  LOG  , 377                 A377
 , LOG   , 5                   A5
 , LOG   , 60                 A60
 ,  LOG  , 77777               A77777
 , LOG   , 77                  BIT1/6
 , LOG   , 177                 BIT1/7
 , OCT   , 7777 7777 7777 7776 BIT2/48
 ,  LOG  , 1777 7777 7777 77   BIT1/40
 , LOG   , 3777 7777 7777 77  BIT1/41
 ,  LOG  , 3000                BIT10/11
 , LOG   , 3700 0              BIT10/14
 ,  OCT  , 7777 7777 7777 7777 BIT1/48
 ,  LOG  , 4000                BIT12
 ,  LOG  , 1000               BIT10
 , LOG   , 3400 0              BIT12/14
 , LOG   , 7400 0              BIT12/15
 ,  LOG  , 2 0000             BIT14
 , LOG   , 4000 0              BIT15
 , LOG   , 1000 00             BIT16
 , LOG   , 2000 00            BIT17
 , OCT   , 7777 7777 7777      BIT13/48
 , OCT   , 0037 7777 777      BIT16/41
 ,  LOG  , 14                  BIT3/4
 ,  OCT  , 7777                BIT37/48
 ,  OCT  , 776                 BIT41/48
 , OCT   , 77                  BIT43/48
 ,  OCT  , 4                   BIT48
 , LOG   , 100                 BIT7
 , LOG   , 200                 BIT8
 , LOG   , 7760 0             BIT8/15
 , OCT   , 7777 7777 7777 74   BIT9/48
 , OCT   , 40                 VGR(-1) = VGR0
 , OCT   , 64                 VGR(0)
 ,  OCT  , 60                  VGR(1)
 ,  OCT  , 54                  VGR(2)
 ,  OCT  , 50                  VGR(3)
 ,  OCT  , 44                  VGR(4)
 ,  OCT  , 40                  VGR(5)
 ,  OCT  , 00000 100 00000 000 HAERTEZ.       FREI
 ,  OCT  , 11020 101 00000 001 A              FREI
 ,  OCT  , 00000 102 00000 002 B              FREI
 ,  OCT  , 00000 103 00000 003 C              FREI
 , OCT   , 06004 104 00000 004 D              FREI
 ,  OCT  , 04004 105 00000 005 E              FREI
 ,  OCT  , 05010 106 00000 006 F              FREI
 ,  OCT  , 00000 107 00000 007 G              FREI
 ,  OCT  , 02040 110 00000 010 H              FREI
 ,  OCT  , 07020 111 00000 011 I              FREI
 ,  OCT  , 00000 112 00000 012 J              END OF RECORD
 ,  OCT  , 00000 113 00000 013 K              FREI
 ,  OCT  , 12020 114 00000 014 L              FREI
 ,  OCT  , 00000 115 00000 015 M              FREI
 ,  OCT  , 00000 116 00000 016 N              FREI
 ,  OCT  , 10020 117 00000 017 O              FREI
 ,  OCT  , 03040 120 00000 020 P              OR
 ,  OCT  , 00000 121 00000 021 Q              AND
 ,  OCT  , 00000 122 00000 022 R              IMPLIKATION
 ,  OCT  , 00000 123 00000 023 S              NEGATION
 ,  OCT  , 00000 124 00000 024 T              INEGERDIVISION
 ,  OCT  , 00000 125 00000 025 U              IDENTITAET
 ,  OCT  , 00000 126 02100 026 V              '(APOSTROPH)
 ,  OCT  , 00000 127 00000 027 W              BASIS-ZEHN
 ,  OCT  , 01040 130 00000 030 X              UNGLEICH
 ,  OCT  , 00000 131 00000 031 Y              KLEINER-GLEICH
 ,  OCT  , 00000 132 00000 032 Z              GROESSERGLEICH
 ,  OCT  , 00000 133 00000 033 ECKIGE KL. AUF STRICH OBEN
 ,  OCT  , 00000 134 00000 034                STRICH UNTEN
 ,  OCT  , 00000 135 00000 035 ECKIGE KL. ZU
 ,  OCT  , 00000 136 02100 036 POTENZ (PFEIL) '(APOSTROPH)
 ,  OCT  , 00000 137 00000 037 STRICH         GRAD
 , OCT   , 00000 140 00000 040 JU             SPACE
 ,  OCT  , 00000 141 00000 041 A              AUSRUFEZEICHEN
 ,  OCT  , 00000 142 00000 042 B RUSS         ANFUEHRUNGSZ.
 ,  OCT  , 00000 143 00000 043 Z RUSS         NUMMER
 ,  OCT  , 00000 144 00000 044 D RUSS         DOLLAR
 ,  OCT  , 00000 145 00000 045 E              PROZENT
 ,  OCT  , 00000 146 00000 046 F RUSS         STRICH SENKR.
 ,  OCT  , 00000 147 02100 047 G RUSS         '(APOSTROPH)
 ,  OCT  , 00000 150 40000 050 X              (
 ,  OCT  , 00000 151 13000 051 I RUSS         )
 ,  OCT  , 00000 152 00000 052 I KURZ         *
 ,  OCT  , 00000 153 03200 053 K              +
 ,  OCT  , 00000 154 00000 054 L RUSS         , (KOMMA)
 ,  OCT  , 00000 155 03200 055 M              - (MINUS)
 ,  OCT  , 00000 156 00000 056 H              .
 ,  OCT  , 00000 157 00000 057 O              /
 ,  OCT  , 00000 160 00001 060 P RUSS         0
 ,  OCT  , 00000 161 00001 061 JA             1
 ,  OCT  , 00000 162 00001 062 P              2
 ,  OCT  , 00000 163 00001 063 C              3
 ,  OCT  , 00000 164 00001 064 T              4
 ,  OCT  , 00000 165 00001 065 Y              5
 ,  OCT  , 00000 166 00001 066 DSCH           6
 ,  OCT  , 00000 167 00001 067 B              7
 ,  OCT  , 00000 170 00002 070 WEICHHEITSZ.   8
 ,  OCT  , 00000 171 00002 071 UI             9.
 ,  OCT  , 00000 172 00000 072 SE             :
 ,  OCT  , 00000 173 00000 073 SCHA           SEMIKOLON
 ,  OCT  , 00000 174 00000 074 E KURZ OFFEN   KLEINER
 ,  OCT  , 00000 175 00000 075 SCHTSCH        =
 ,  OCT  , 00000 176 00000 076 TSCH           GROESSER
 ,  OCT  , 00000 177 00000 077 ERASE          FRAGEZEICHEN
 , REAL  , 1.                  DEINS
 , OCT   ,
 , REAL  , 10.                 D10
 , OCT   ,
 , REAL  , 0.5                 D1/2
 , OCT   ,
 , REAL  , 1.25               REAL5/4
 , OCT   , 4310 7033 6233 7404R5/4H16
 ,REAL,1.E-18
 ,REAL,1.E-16
 ,REAL,1.E-14
 ,REAL,1.E-12
 ,REAL,1.E-10
 ,REAL,1.E-8
 ,REAL,1.E-6
 ,REAL,1.E-4
 ,REAL,1.E-2
 ,REAL,1.
 ,REAL,1.E2
 ,REAL,1.E4
 ,REAL,1.E6
 ,REAL,1.E8
 ,REAL,1.E10
 ,REAL,1.E12
 ,REAL,1.E14
 ,REAL,1.E16
 ,REAL,1.E18
 , REAL  , 6.                 SECHS
 ,  REAL , .1                 Z1/10
 , OCT   , 3654 6314 6314 6314 D1/10
 , OCT   , 0014 6314 6314 6316
 , OCT   , 4256 5431 2370 7032 D10E40
 , OCT   , 0116 2445 7725 6717 E40 TEIL 2
 , OCT   , 3610 5541 1423 5672 D10E*40 = 10E-40
 , OCT   , 0113 6342 6142 1450 E-40 TEIL 2
 ,  LOG  , 12                  EOR
 ,  ISO  , 6H'7''7''7'''''''   VMASKE1
 ,  ISO  , 6H'7''7''7''7''7''' VMASKE2
 ,  ISO  , 6H000''''''         VW1
 ,  ISO  , 6H00000B            VW2
 ,  LOG  , 02040 110           VH
 ,  LOG  , 03040 120           VP
 ,  LOG  , 40                  SPACE
 , OCT   , 645                EX645
 ,  ISO  , 6HREC              K3HREC
 , ISO   , 6HADD              K3HADD
 , LOG   , 100                MAXEXNZ
 , ISO   , 12HI/O-ERROR ''''  FTXT
 , ISO   , 12H DETECTED IN
 , ISO   , 12HCALLED FROM
 , ISO   , 6H LUN ''
 , ISO   , 18H SPECIFICATION ''''''
 , ISO   , 12H FORMAT'12'     KFORMAT
 , ISO   , 12H ADDRESS ''''''
 , OCT   , 7757 7777 7777 7777 GRZAHL
 , ISO   , 6H   '311''311''12'  ISOSP   149SPACES + EOR
 , OCT   , 7377 7777 7777 7777 NBIT45
 , OCT   , 1                   BIT46
 , OCT   , 04                  BIT45
 , OCT   , 3777 7777 7777 7776 BIT2/47
 , OCT   , 3000 0000 0000 0001 NZL
 , ISO   , 6HRECORD           KRECORD
 , LOG   , 4                   A4
 , OCT   , 7                   BIT46/48
 ASP  :  , BSS ,84 .LASP?
 , END ,
