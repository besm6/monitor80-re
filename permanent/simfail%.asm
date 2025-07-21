 SIMFAIL*:  , NAME,
C**************************************************************
C*                                                            *
C*       HAБOP ПPOЦEДYP ДЛЯ PAБOTЫ CO CTPOKAMИ CИMBOЛOB       *
C*       ----------------------------------------------       *
C*    HAЗOBEM CTPOKOЙ CИMBOЛOB ПOCЛEДOBATEЛЬHOCTЬ:            *
C*     S(1),S(2),...,S(N)                                     *
C*  ГДE: S(I)  -  BOCЬMИPAЗPЯДHЫE CИMBOЛЫ (000..377B),        *
C*       N=6*L -  ДЛИHA CTPOKИ (KPATHAЯ ШECTИ).               *
C*  ПPEДПOЛAГAETCЯ, ЧTO ПOCЛEДOBATEЛЬHOCTЬ YПAKOBAHA  (B ПO-  *
C*  PЯДKE CЛEДOBAHИЯ CИMBOЛOB) B MACCИBE  A  ИЗ  L  CЛOB, ПO  *
C*  ШECTЬ CИMBOЛOB B CЛOBE, HAЧИHAЯ CO CTAPШИX PAЗPЯДOB.      *
C*    ДЛЯ PAБOTЫ CO CTPOKOЙ HEOБXOДИMO TAKЖE BЫДEЛИTЬ MACCИB  *
C*  X  ИЗ ЧETЫPEX CЛOB (XAPAKTEPИCTИKA),  B KOTOPOM XPAHЯTCЯ  *
C*  ПAPAMETPЫ, OПИCЫBAЮЩИE COCTOЯHИE CTPOKИ.                  *
C*      EГO CTPYKTYPA TAKOBA:                                 *
C*  CЛOBO  PAЗPЯДЫ  COДEPЖИMOE                                *
C*    0     15-1     A                                        *
C*                   HAЧAЛЬHЫЙ AДPEC CTPOKИ                   *
C*    1     15-1     K=(I-1)/6                                *
C*                   OTHOCИTEЛЬHЫЙ AДPEC CЛOBA, COДEPЖAЩEГO   *
C*                   TEKYЩИЙ CИMBOЛ                           *
C*    2      7-1     ((K+1)*6-I)*8                            *
C*                   KOHCTAHTA ДЛЯ CДBИГA TEKYЩEГO CИMBOЛA B  *
C*                   B MЛAДШИE PAЗPЯДЫ CЛOBA (0..50B)         *
C*    3     15-1     A+L                                      *
C*                   KOHEЧHЫЙ AДPEC CTPOKИ+1                  *
C*  ГДE: I  -  YKAЗATEЛЬ TEKYЩEЙ ПOЗИЦИИ B CTPOKE (1..N)      *
C*                                                            *
C*                      OПИCAHИE ПPOЦEДYP                     *
C*                      -----------------                     *
C*    B BЫЗЫBAЮЩEЙ ПPOГPAMME ЭTИ ПPOЦEДYPЫ MOЖHO OПИCATЬ      *
C*  CЛEДYЮЩИM OБPAЗOM:                                        *
C*    SIMFAIL*: , SUBP,                                       *
C*    SIMFAIL*:I,BLOCK,DO*LENT  ,P1  ,M1                      *
C*              , CONT,W*P1,R*P1,W*M1,R*M1                    *
C*              , CONT,P1*W,P1*R,M1*W,M1*R                    *
C*              , CONT,L1*TO*L2 ,R   ,W                       *
C*              , CONT,L2*TO*L1                               *
C*  OБPAЩEHИE K HИM ПPOИЗBOДИTCЯ C BOЗBPATOM ПO I13,          *
C*  ПAPAMETPЫ ЗAДAЮTCЯ HA ИHДEKC-PEГИCTPAX,                   *
C*  ПPИЧEM B I8 BCEГДA ЗAДAETCЯ AДPEC XAPAKTEPИCTИKИ.         *
C*  BCEГДA COXPAHЯETCЯ CYMMATOP И XPAHЯЩИE PAЗPЯДЫ PAY,       *
C*  YCTAHABЛИBAETCЯ ПPИЗHAK ЛOГИЧECKOЙ ГPYППЫ.                *
C*  ECЛИ CПEЦИAЛЬHO HE OГOBOPEHO, ПOPTИTCЯ I12.               *
C*    1. DO*LENT  -  YCTAHOBOЧHOE OБPAЩEHИE                   *
C*  ФOPMИPYET XAPAKTEPИCTИKY CTPOKИ ПEPEД HAЧAЛOM PAБOTЫ,     *
C*  YCTAHABЛИBAET I=1.                                        *
C*  B I9   -  ЗAДAETCЯ A                                      *
C*    I10  -  ЗAДAETCЯ L                                      *
C*  ПPИMEP OБPAЩEHИЯ:                                         *
C*             8, VTM ,X                                      *
C*             9, VTM ,A                                      *
C*            10, VTM ,L                                      *
C*            13, VJM ,DO*LENT                                *
C*    2. KOПИPOBAHИE XAPAKTEPИCTИK                            *
C*  B I9   -  ЗAДAETCЯ AДPEC XAPAKTEPИCTИKИ  X2               *
C*  COXPAHЯETCЯ I12.                                          *
C*    2.1. L1*TO*L2  -  KOПИPYET X B X2                       *
C*  ПPИMEP OБPAЩEHИЯ:                                         *
C*             8, VTM ,X                                      *
C*             9, VTM ,X2                                     *
C*            13, VJM ,L1*TO*L2                               *
C*    2.2. L2*TO*L1  -  KOПИPYET X2 B X                       *
C*  ПPИMEP OБPAЩEHИЯ:                                         *
C*             8, VTM ,X                                      *
C*             9, VTM ,X2                                     *
C*            13, VJM ,L2*TO*L1                               *
C*    3. ЧTEHИE И ЗAПИCЬ TEKYЩEГO CИMBOЛA                     *
C*  B I14  -  CИMBOЛ                                          *
C*  ПOPTЯTCЯ I9,I10                                           *
C*    3.1. R  -  ЧTEHИE CИMBOЛA ИЗ TEKYЩEЙ ПOЗИЦИИ            *
C*               И ЗAПИCЬ B I14                               *
C*    3.2. W  -  ЗAПИCЬ CИMBOЛA ИЗ I14 B TEKYЩYЮ ПOЗИЦИЮ      *
C*    4. ИЗMEHEHИE YKAЗATEЛЯ TEKYЩEЙ ПOЗИЦИИ                  *
C*  ПPИ ПOПЫTKE BЫЙTИ ЗA ГPAHИЦЫ CTPOKИ YCTAHABЛИBAETCЯ       *
C*  I11=1 (ИHAЧE I11=0)                                       *
C*  ПOPTИTCЯ I9                                               *
C*    4.1. P1  -  YBEЛИЧEHИE YKAЗATEЛЯ HA EДИHИЦY             *
C*  ECЛИ B PEЗYЛЬTATE I CTAЛ PABHЫM N+1, BЫXOД C I11=1        *
C*    4.2. M1  -  YMEHЬШEHИE YKAЗATEЛЯ HA EДИHИЦY             *
C*  ECЛИ I БЫЛ PABEH 1, YCTAHABЛИBAET I=6, И BЫXOД C I11=1    *
C*    5. KOMПOЗИЦИИ OПEPAЦИЙ TИПA 3 И 4                       *
C*    5.1. R*P1  -  BЫПOЛHЯET  R  , A ЗATEM  P1               *
C*    5.2. R*M1  -  BЫПOЛHЯET  R  , A ЗATEM  M1               *
C*    5.3. W*P1  -  BЫПOЛHЯET  W  , A ЗATEM  P1               *
C*    5.4. W*M1  -  BЫПOЛHЯET  W  , A ЗATEM  M1               *
C*    5.5. P1*R  -  BЫПOЛHЯET  P1 , A ЗATEM  R                *
C*    5.6. M1*R  -  BЫПOЛHЯET  M1 , A ЗATEM  R                *
C*    5.7. P1*W  -  BЫПOЛHЯET  P1 , И ECЛИ I11=0 , TO  W      *
C*    5.8. M1*W  -  BЫПOЛHЯET  M1 , И ECЛИ I11=0 , TO  W      *
C*                                                            *
C**************************************************************
C      XAPAKTEPИCTИKA
 *0:,BLOCK,A*,K*,H*,L*
c сдвиги 1-4.
c----------------------
 *1      :  ,BLOCK,M1,M2,M3,M4,M5,M6,M7,M8,M9
            , CONT,M10,M11,M12,M13,M14,M15
c
            , UJ  ,DO*LENT
c
         :  , UJ  ,P1*
c
         :  , UJ  ,M1*
c
         :  , UJ  ,W*P1
c
         :  , UJ  ,R*P1
c
         :  , UJ  ,W*M1
c
         :  , UJ  ,R*M1
c
         :  , UJ  ,P1*W
c
         :  , UJ  ,P1*R
c
         :  , UJ  ,M1*W
c
         :  , UJ  ,M1*R
c
         :  , UJ  ,L1*TO*L2
c
         :  , UJ  ,read*sim
c
         :  , UJ  ,write*sim
c
         :  , UJ  ,l2*to*l1
c
 DO*LENT:M12,VTM,п377.=377
            , ITS ,M9
          M8, ATX ,
            , XTA ,
          M8, ATX ,1
         M12, XTA ,2
          M8, ATX ,2
            , ITA ,M10
          M8, ARX ,
          M8, STX ,3
         M13, UJ  ,
 P1*:M12,VTM,п377.=377
          M8, XTS ,2
            , U1A ,*0034B
         M12, XTA ,2
          M8, ATX ,2
          M8, XTA ,1
         M12, ARX ,1
          M8, ATX ,1
          M8, ARX ,
          M8, AEX ,3
            , UZA ,*0116B
            , STX ,
         M11, VTM ,
         M13, UJ  ,
c
 *0034B  :  , ATI ,M9
          M9, UTM ,-8
 *0035B  :  , ITA ,M9
          M8, STX ,2
         M11, VTM ,
         M13, UJ  ,
c
 M1*:M12,VTM,п377.=377
          M8, XTS ,2
         M12, AEX ,2
            , U1A ,*0045B
          M8, ATX ,2
          M8, AEX ,1
            , UZA ,*0116B
         M12, ARX ,3
         M12, AAX ,3
          M8, STX ,1
         M11, VTM ,
         M13, UJ  ,
c
 *0045B  :M8, XTA ,2
            , ATI ,M9
          M9, UTM ,10B
            , UJ  ,*0035B
 W*P1  :  , ITS ,M13
         M13, VJM ,write*sim
 *0050B  :  , STI ,M13
            , UJ  ,P1*
 R*P1  :  , ITS ,M13
         M13, VJM ,read*sim
            , UJ  ,*0050B
 W*M1  :  , ITS ,M13
         M13, VJM ,write*sim
 *0054B  :  , STI ,M13
            , UJ  ,M1*
 R*M1  :  , ITS ,M13
         M13, VJM ,read*sim
            , UJ  ,*0054B
 P1*W  :  , ITS ,M13
         M13, VJM ,P1*
         M11, V1M ,b*P1*W
 a*P1*W  :  , STI ,M13
            , UJ  ,write*sim
 P1*R  :  , ITS ,M13
         M13, VJM ,P1*
 a*P1*R  :  , STI ,M13
            , UJ  ,read*sim
 M1*W  :  , ITS ,M13
         M13, VJM ,M1*
         M11, V1M ,b*P1*W
            , UJ  ,a*P1*W
c
 b*P1*W  :  , STI ,M13
         M13, UJ  ,
c
 M1*R  :  , ITS ,M13
         M13, VJM ,M1*
            , UJ  ,a*P1*R
 L1*TO*L2:M10,VTM,-3 .счетчик
            , XTS ,
 *0072B:M10,UTC,3
          M8, XTA ,
         M10, UTC ,3
          M9, ATX ,
         M10, VLM ,*0072B
            , STX ,
         M13, UJ  ,
 read*sim:M10,VJM,GET*KH
            , ATI ,M10
          M9, XTA ,
         M10, ASN ,64
         M12, AAX ,
            , STI ,M14
         M13, UJ  ,
 write*sim:M10,VJM,GET*KH
         M12, AEX ,3
            , ATI ,M10
         M12, XTA ,
         M10, ASN ,64+1
          M9, AAX ,
          M9, AEX ,
            , ITS ,M14
         M10, ASN ,64+1
         M15, AEX ,
          M9, STX ,
         M13, UJ  ,
 l2*to*l1:M10,VTM,-3
            , XTS ,
 *0112B:M10,UTC,3
          M9, XTA ,
         M10, UTC ,3
          M8, ATX ,
         M10, VLM ,*0112B
            , STX ,
         M13, UJ  ,
 *0116B:M11,VTM,1
            , STX ,
         M13, UJ  ,
 GET*KH:M12,VTM,п377.=377
          M8, XTS ,
          M8, ARX ,1
            , ATI ,M9
          M8, XTA ,2
         M10, UJ  ,
 п377  :  , LOG ,377
            , LOG ,1
            , LOG ,50
            , LOG ,7 7777
            , END ,
