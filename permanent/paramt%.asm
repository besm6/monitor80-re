 PARAMT*:,NAME,
 ,SPACE,62
C**************************************************************
C*                                                            *
C*     BЫДEЛEHИE И OБPAБOTKA ПAPAMETPOB  C TEKCTOBЫX KAPT     *
C*     --------------------------------------------------     *
C*    ИCXOДHAЯ TEKCTOBAЯ KAPTA (B ПPOГPAMME  PACCMATPИBAЮTCЯ  *
C*  TOЛЬKO ПEPBЫE 72 CИMBOЛA) ДOЛЖHA БЫTЬ ПOMEЩEHA B MACCИB:  *
C*      MONCARD/:,LC,14                                       *
C*  ДЛЯ YПPABЛЯЮЩИX KAPT MOHИTOPHOЙ CИCTEMЫ ЭTA PAБOTA BЫПO-  *
C*  ЛHЯETCЯ PAЗДEЛOM   STAR* , A ДЛЯ ПPOЧИX CЛYЧAEB ЗAПИCЬ B  *
C*  MONCARD/   HYЖHO ПPEДYCMOTPETЬ B BЫЗЫBAЮЩEЙ ПPOГPAMME.    *
C*    XAPAKTEP OБPAБOTKИ ЗABИCИT OT COДEPЖИMOГO I10 , ЗAДAH-  *
C*  HOГO ПPИ OБPAЩEHИИ (TИП PAБOTЫ):                          *
C*  0  - HAЧAЛЬHAЯ YCTAHOBKA ЗA ПEPBЫЙ PAЗДEЛИTEЛЬ (9+6);     *
C*  1  - BЫДEЛEHИE TEKCTOBOГO  ПAPAMETPA  (ПPOБEЛ - ЗHAЧAЩИЙ  *
C*       CИMBOЛ);                                             *
C*  2  - CPABHEHИE C ЭTAЛOHOM;                                *
C*  3  - OБPAБOTKA ИДEHTИФИKATOPA;                            *
C*  4  - OБPAБOTKA YKAЗATEЛЯ MЛ/MД/MБ;                        *
C*  5  - OБPAБOTKA ЦEЛOГO BOCЬMEPИЧHOГO ЧИCЛA;                *
C*  6  - BЫДEЛEHИE TEKCTOBOГO  ПAPAMETPA (CTAHДAPTHЫЙ PEЖИM,  *
C*       ПPOБEЛЫ ИГHOPИPYЮTCЯ);                               *
C*  7  - OБPAБOTKA ЦEЛOГO ДECЯTИЧHOГO ЧИCЛA;                  *
C*  8  - BЫДEЛEHИE TEKCTOBOГO  ПAPAMETPA ДO ЗAДAHHOГO PAЗДE-  *
C*       ЛИTEЛЯ (ПPOБEЛЫ ИГHOPИPYЮTCЯ);                       *
C*  9  - HAЧAЛЬHAЯ YCTAHOBKA K ПEPBOMY CИMBOЛY KAPTЫ;         *
C*  10 - BOЗBPAT K ПOCЛEДHEMY OБPAБOTAHHOMY ПAPAMETPY;        *
C*    BЫДEЛEHHЫЙ  ПAPAMETP B KOДE ISO  (БEЗ ПPOБEЛOB,  KPOME  *
C*  TИП=1) ПOMEЩAETCЯ B MACCИB:                               *
C*      *MONCRD*:,LC,12                                       *
C*  OCTATOK MACCИBA ЗAПOЛHЯETCЯ ПPOБEЛAMИ.                    *
C*    ДOПOЛHИTEЛЬHAЯ ИHФOPMAЦИЯ ПOMEЩAETCЯ (B ФOPMATE LOG) B  *
C*  MACCИB:                                                   *
C*      MIST10*:LC,BLOCK,MIS,CODE,NUMB                        *
C*  A TAKЖE ДYБЛИPYETCЯ B ИHДEKC-PEГИCTPAX:                   *
C*  CЛOBO ИP COДEPЖИMOE                                       *
C*   MIS  14  1 - OШИБKA B TEKYЩEM ПAPAMETPE                  *
C*            0 - HET OШИБOK                                  *
C*   CODE 11  KOД PAЗДEЛИTEЛЯ (ISO), ИЛИ HYЛЬ ПPИ BЫXOДE HA   *
C*            KOHEЦ KAPTЫ (72-Я ПOЗИЦИЯ), ПPИ ЭTOM TEPЯETCЯ   *
C*            ИHФOPMAЦИЯ O KOДE И HAЛИЧИИ PAЗДEЛИTEЛЯ B ПO-   *
C*            CЛEДHEЙ ПOЗИЦИИ KAPTЫ.                          *
C*   NUMB 12  KOЛИЧECTBO CИMBOЛOB ПAPAMETPA, ПEPEПИCAHHЫX B   *
C*            *MONCRD*                                        *
C*    ПPИ OБHAPYЖEHИИ OШИБKИ B ПAPAMETPE ПEЧATAETCЯ ДИAГHOC-  *
C*  TИKA:                                                     *
C*      'OШИБKA B ЗAДAHИИ ПAPAMETPA'                          *
C*  И ЗATEM ПEPBOE CЛOBO MACCИBA  *MONCRD*. ЭTY ПEЧATЬ MOЖHO  *
C*  ЗAБЛOKИPOBATЬ, ЗAДAB HEHYЛEBOЙ KOД B MACCИBE:             *
C*      OUT*OUT:,LC,1                                         *
C*    KOГДA PEЗYЛЬTAT OБPAБOTKИ YMEЩAETCЯ B OДHO CЛOBO (TИП=  *
C*  2,3,4,5,7),  OH  BЫДAETCЯ  HA  CYMMATOP.  KPOME TOГO ДЛЯ  *
C*  TИП=4,5,7  PEЗYЛЬTAT  ЗAПИCЫBAETCЯ ПO AДPECY,  ЗAДAHHOMY  *
C*  ПPИ OБPAЩEHИИ B I9.                                       *
C*    ECЛИ ПPИ OБPAЩEHИИ ЗAДAH HEHYЛEBOЙ KOД B MACCИBE:       *
C*      STARSTA:,LC,1                                         *
C*  TO KAЖДЫЙ CИMBOЛ ПAPAMETPA B ИCXOДHOЙ KAPTE, ЗA ИCKЛЮЧE-  *
C*  HИEM HEЗHAЧAЩИX ПPOБEЛOB, ЗAMEHЯETCЯ CИMBOЛOM '*'.        *
C*    BOЗBPAT ИЗ ПOДПPOГPAMMЫ ПPOИЗBOДИTCЯ ПO I13. ECЛИ CYM-  *
C*  MATOP HE ИCПOЛЬЗYETCЯ ДЛЯ BЫДAЧИ PEЗYЛЬTATA,  OH OБHYЛЯ-  *
C*  ETCЯ. ECЛИ HE БЫЛO ПEЧATИ ДИAГHOCTИKИ,  TO XPAHЯЩИE PAЗ-  *
C*  PЯДЫ PAY COXPAHЯЮTCЯ, ИHAЧE PRINT8 YCTAHOBИT CTAHДAPTHЫЙ  *
 ,SPACE,63
C*  PAY. YCTAHABЛИBAETCЯ ПPИЗHAK ЛOГИЧECKOЙ ГPYППЫ.  BCE ИH-  *
C*  ДEKCHЫE PEГИCTPЫ, HE ИCПOЛЬЗYЮЩИECЯ ДЛЯ BЫДAЧИ PEЗYЛЬTA-  *
C*  TOB, COXPAHЯЮTCЯ.                                         *
C*                                                            *
C*                     ПOДPOБHOE OПИCAHИE                     *
C*                     ------------------                     *
C*    1. HAЧAЛЬHAЯ YCTAHOBKA (TИП=9).                         *
C*  C ПOMOЩЬЮ П/П SIMFAIL* B MACCИBE:                         *
C*      XPARAMT*:,LC,4                                        *
C*  ФOPMИPYETCЯ  XAPAKTEPИCTИKA MACCИBA  MONCARD/  (ПPИ ЭTOM  *
C*  YKAЗATEЛЬ TEKYЩEЙ ПOЗИЦИИ  YCTAHABЛИBAETCЯ B HAЧAЛO KAP-  *
C*  TЫ), YCTAHABЛИBAЮTCЯ:                                     *
C*      CODE=1 , NUMB=MIS=0 .                                 *
C*    2. ПAPAMETP-TEKCT (TИП=0,1,2,3,6,8).                    *
C*    2.1. TИП=6.                                             *
C*  ECЛИ HA BXOДE CODE=0 (БЫЛ KOHEЦ KAPTЫ), BЫXOД C NUMB=0 ,  *
C*  ИHAЧE  ПOCЛEДOBATEЛЬHO  ПPOCMATPИBAЮTCЯ CИMBOЛЫ ИCXOДHOЙ  *
C*  KAPTЫ HAЧИHAЯ C TEKYЩEЙ ПOЗИЦИИ ДO ПEPBOГO  PAЗДEЛИTEЛЯ,  *
C*  A ECЛИ EГO HET, TO ДO KOHЦA KAPTЫ, И ПEPEПИCЫBAЮTCЯ, ИC-  *
C*  KЛЮЧAЯ ПPOБEЛЫ, B  *MONCRD* . YKAЗATEЛЬ  TEKYЩEЙ ПOЗИЦИИ  *
C*  YCTAHABЛИBAETCЯ ЗA PAЗДEЛИTEЛЬ. PAЗДEЛИTEЛЬ OПPEДEЛЯETCЯ  *
C*  ПO ИHФOPMAЦИИ ЗAДAHHOЙ B ПOДПPOГPAMME-TAБЛИЦE TABSIMIS .  *
C*    2.2. TИП=0.                                             *
C*  BЫПOЛHЯETCЯ (1.), A ЗATEM (2.1.).                         *
C*    2.3. TИП=1.                                             *
C*  TO ЖE, ЧTO И (2.1.), HO B  *MONCRD* ПEPEПИCЫBAЮTCЯ TAKЖE  *
C*  И ПPOБEЛЫ.                                                *
C*    2.4. TИП=2.                                             *
C*  ПPИ OБPAЩEHИИ  HA CYMMATOPE HYЖHO  ЗAДATЬ ЭTAЛOH  (ШECTЬ  *
C*  CИMBOЛOB B KOДE ISO). BЫПOЛHЯETCЯ (2.1.), И ECЛИ  NUMB=0  *
C*  ИЛИ NUMB>6, BЫXOД C CYMMATOPOM PABHЫM 1 (ПPИ NUMB>6 ФИK-  *
C*  CИPYETCЯ OШИБKA), ИHAЧE  OШИБKA ФИKCИPYETCЯ ПPИ HECOBПA-  *
C*  ДEHИИ ПAPAMETPA C ЭTAЛOHOM, A PEЗYЛЬTAT  CPABHEHИЯ BЫДA-  *
C*  ETCЯ HA CYMMATOP.                                         *
C*    2.5. TИП=3.                                             *
C*  BЫПOЛHЯETCЯ (2.1.). ECЛИ NUMB>8  ИЛИ ПEPBЫЙ CИMBOЛ ПAPA-  *
C*  METPA HE БYKBA, ФИKCИPYETCЯ OШИБKA. ПEPBЫE BOCEMЬ CИMBO-  *
C*  ЛOB ПAPAMETPA B KOДE TEXT BЫДAЮTCЯ HA CYMMATOP.           *
C*    2.6. TИП=8.                                             *
C*  ПPИ OБPAЩEHИИ ДOПOЛHИTEЛЬHO HYЖHO ЗAДATЬ B I11 KOД OДHO-  *
C*  ГO ИЗ PAЗДEЛИTEЛEЙ, A HA CYMMATOPE  ПPEДEЛЬHYЮ ДЛИHY ПA-  *
C*  PAMETPA  (B  ФOPMATE  LOG).  BЫПOЛHЯETCЯ  PAБOTA  KAK  B  *
C*  (2.1.), HO PAЗДEЛИTEЛEM CЧИTAETCЯ TOЛЬKO ЗAДAHHЫЙ. KPOME  *
C*  TOГO, ПPИ ДЛИHE ПAPAMETPA БOЛЬШEЙ ПPEДEЛЬHOЙ ФИKCИPYETCЯ  *
C*  OШИБKA.                                                   *
C*    3. ПAPAMETP-ЧИCЛO (TИП=4,5,7).                          *
C*  ПPИ OБPAЩEHИИ B I9 ЗAДAETCЯ AДPEC ДЛЯ ЗAПИCИ PEЗYЛЬTATA.  *
C*  BЫПOЛHЯETCЯ (2.1.), И ECЛИ  NUMB=0 ИЛИ  NUMB>6 , BЫXOД C  *
C*  HYЛEBЫM  CYMMATOPOM  (ПPИ  NUMB>6  ФИKCИPKETCЯ  OШИБKA),  *
C*  ИHAЧE BЫПOЛHЯETCЯ ПPEOБPAЗOBAHИE ПAPAMETPA B ФOPMAT LOG,  *
C*  И ECЛИ ПPИ ЭTOM HE ЗAФИKCИPOBAHO OШИБOK, PEЗYЛЬTAT BЫДA-  *
C*  ETCЯ HA CYMMATOP И ЗAПИCЫBAETCЯ ПO ЗAДAHHOMY AДPECY. ПPИ  *
C*  HAЛИЧИИ OШИБOK BЫXOД C HYЛEBЫM CYMMATOPOM.                *
C*    3.1. TИП=4.                                             *
C*  YKAЗATEЛИ MЛ/MД/MБ ПPEOБPAЗYЮTCЯ B EДИHЫЙ ФOPMAT:         *
C*  PAЗPЯДЫ COДEPЖИMOE                                        *
C*   18-13  M = M2 M1                                         *
C*          MATEMATИЧECKИЙ HOMEP YCTPOЙCTBA                   *
C*   12-1   Z = Z4 Z3 Z2 Z1                                   *
C*          HOMEP ЗOHЫ/TPAKTA                                 *
C*  ГДE: MI ,ZI - ЦИФPЫ BOCЬMEPИЧHOЙ ЗAПИCИ.                  *
 ,SPACE,35
C*  ДOПYCKAЮTCЯ CЛEДYЮЩИE TИПЫ YKAЗATEЛEЙ:                    *
C*  NUMB   ПAPAMETP              ПPEOБPAЗOBAHИE  OГPAHИЧEHИЯ  *
C*   6  <M2><M1><Z4><Z3><Z2><Z1>                  Z4<4        *
C*   5  <M2><M1><Z3><Z2><Z1>     Z4=0                         *
C*   3  F<F2><F1>                M=F2*10+F1+40B   M>40B       *
C*                               Z=0              M<60B       *
C*   2  F<F1>                    M=F1+40B , Z=0   M>40B       *
C*      <M2><M1>                 Z=0                          *
C*   1  1                        M=3 , Z=0                    *
C*      2                        M=5 , Z=0                    *
C*  ЗДECЬ: <MI> , <ZI>  - TEKCTOBЫE ПPEДCTABЛEHИЯ BOCЬMEPИЧ-  *
C*  HЫX, <FI>  - ДECЯTИЧHЫX ЦИФP.                             *
C*  ECЛИ ПAPAMETP HE OTHOCИTCЯ K OДHOMY ИЗ ПEPEЧИCЛEHHЫX TИ-  *
C*  ПOB ИЛИ HE YДOBЛETBOPЯET YKAЗAHHЫM OГPAHИЧEHИЯM,  ФИKCИ-  *
C*  PYETCЯ OШИБKA.                                            *
C*    3.2. TИП=5.                                             *
C*  ECЛИ HE BCE CИMBOЛЫ ПAPAMETPA - BOCЬMEPИЧHЫE ЦИФPЫ, ФИK-  *
C*  CИPYETCЯ OШИБKA.  PEЗYЛЬTAT - MAШИHHOE ПPEДCTABЛEHИE BЫ-  *
C*  ДEЛEHOOГO BOCЬMEPИЧHOГO ЧИCЛA.                            *
C*    3.3. TИП=7.                                             *
C*  ECЛИ HE BCE CИMBOЛЫ ПAPAMETPA - ЦИФPЫ, ФИKCИPYETCЯ OШИБ-  *
C*  KA. PEЗYЛЬTAT - MAШИHHOE ПPEДCTABЛEHИE BЫДEЛEHHOГO ДECЯ-  *
C*  TИЧHOГO ЧИCЛA.                                            *
C*    4. TИП=10.                                              *
C*  ПEPEД BЫДEЛEHИEM KAЖДOГO ПAPAMETPA XAPAKTEPИCTИKA MACCИ-  *
C*  BA  MONCARD/  KOПИPYETCЯ B MACИИB:                        *
C*      XPARAMT/:,LC,4                                        *
C*  ПPИ OБPAЩEHИИ C TИП=10  ПPOИCXOДИT BOCCTAHOBЛEHИE XAPAK-  *
C*  TEPИCTИKИ ИЗ ЭTOГO MACCИBA,  ЧTO ПOЗBOЛЯET  ЗATEM ПOBTO-  *
C*  PИTЬ OБPAБOTKY ЭTOГO ПAPAMETPA, ECЛИ ДOПYCKAЮTCЯ AЛЬTEP-  *
C*  HATИBHЫE TИПЫ. OДHAKO   MIST10*  HE BOCCTAHABЛИBAETCЯ, И  *
C*  ЭTO, B ЧACTHOCTИ, HE ПOЗBOЛЯET ПOBTOPИTЬ  OБPAБOTKY ПOC-  *
C*  ЛEДHEГO ПAPAMETPA HA KAPTE.                               *
C*                                                            *
C**************************************************************
 TABSIMIS:,SUBP,
 SIMFAIL*:,SUBP,
 SIMFAIL*:I,BLOCK,DO*LENT,(1),M1,W*P1,R*P1
 ,CONT,(6),L1*TO*L2
 STARSTA:,LC,1
 OUT*OUT:,LC,1
 MONCARD/:,LC,14
 *MONCRD*:LC,BLOCK,MK(12)
 MIST10*:,LC,3
 *0:,BLOCK,MIS,CODE,NUMB
 XPARAMT*:LC,BLOCK,PX(4)
 XPARAMT/:LC,BLOCK,PX/(4).KOПИЯ XAP-KИ
C
C          OПИCAHИЯ PEГИCTPOB
C      ЛOKAЛЬHЫE +
C      ИHTEPФEЙC C ПOЛЬЗOBATEЛEM
  *3:,BLOCK,B,I,P,H,R
 *10:,BLOCK,T,(1),N,J,M,S
C      ИHTEPФEЙC C SIMFAIL*
  *8:,BLOCK,X,A,L,F,(2),C
C
C      ЯЧEЙKИ MAГAЗИHA
 S*AC:,EQU,B-M-2
 S*AC:I,BLOCK,(1),S*M,(1),S*N
       ,CONT ,S*D,S*T,S*V
C
C------------
C
 BEG:,ITS,M
 M,VTM,M-B
 :M,UTM,-1
 M,ITS,B
 M,V1M,*-1
 B,BASE,BEG
 I,VTM,MIST10*
 P,VTM,1
 H,VTM,
 S,XTS,S*AC
 S,ATX,S*M
 T,MTJ,M
 M,UTM,15-ESWI+SWIT
  ,ITA,M
 S,AOX,S*T
  ,ASN,64+4
 I,ATX,MIS
 I,ATX,NUMB
 S,ATX,S*AC
 T,UZA,SWIT
 M,VTM,TEXA
  ,ITS,M
 M,UTM,5
  ,ITS,M
  ,XTS,=1
  ,CALL,PRINT8
  ,SJ ,
 SWIT:J,VTM,HOL.TИП=0
   ,UJ ,INIT.HACTPOЙKA
 :P,VTM,0.TИП=1
   ,UJ ,HOL.TEKCT C ПPOБ.
 :R,VTM,AEX.TИП=2
   ,UJ ,TEXT.CPABHEHИE
 :H,VTM,-48.TИП=3
   ,UJ ,IDE.ИДEHTИФИKATOP
 :R,VTM,MЛMБ.TИП=4
   ,UJ ,TEXT.YKAЗATEЛЬ
 :R,VTM,OCT.TИП=5
   ,UJ ,TEXT.BOCЬM.ЧИCЛO
 HOL:R,VTM,RET.TИП=6
   ,UJ ,TEXT.TEKCT БEЗ ПP.
 :R,VTM,INT.TИП=7
   ,UJ ,TEXT.ЦEЛOE
 :P,VTM,2.TИП=8
   ,UJ ,HOLS.ПOИCK CИMBOЛA
 :J,VTM,RET.TИП=9
   ,UJ ,INIT.HAЧ.YCTAHOBKA
 ESWI:X,VTM,PX/.TИП=10
 A,VTM,PX.BOЗBPAT HA 1 ПAP
 J,VTM,RET
  ,UJ ,L1*TO*L2
C------
 INIT:,XTA,=1
 I,ATX,CODE
 X,VTM,PX
 A,VTM,MONCARD/
 L,VTM,12
  ,UJ ,DO*LENT
C------
 TEXT:,BSS,
 X,VTM,PXX
 A,VTM,MK
 L,VTM,12
 J,VJM,DO*LENT
 M,VTM,-11
  ,XTA,=6H
 :A,ATX,
 A,UTM,1
 M,VLM,*-1
 X,VTM,PX.KOПИP.
 A,VTM,PX/.XAP-KИ
 J,VJM,L1*TO*L2
 I,XTA,CODE
  ,UZA,TERET
 TE1:X,VTM,PX
 J,VJM,R*P1
  ,ITA,F
 S,ATX,S*N
 J,VTM,TERET
 C,UTC,TABSIMIS
  ,XTA,
  ,ASN,64+45
  ,AEX,=1
  ,U1A,TEB
 P,MTJ,N
 N,UTM,-2
 N,V1M,TED
  ,ITA,C
 S,AEX,S*D
  ,UZA,TED
 TEB:P,VZM,TEP
 C,MTJ,N
 N,UTM,-40B
 N,VZM,TEN
 TEP:H,VZM,TEW
 C,UTC,TABSIMIS
  ,XTA,
  ,ASN,64-3
 H,ASN,64+48
 H,UTM,6
 S,AEX,S*AC
 S,ATX,S*AC
 TEW:X,VTM,PXX
 J,VJM,W*P1
  ,XTA,=1
 I,ARX,NUMB
 I,ATX,NUMB
  ,UTC,STARSTA
  ,XTA,
  ,UZA,TEN
 X,VTM,PX
 J,VJM,M1
 C,VTM,52B.*
 J,VJM,W*P1
 TEN:J,VTM,TE1
  ,UJ ,TEE
 TED:,ITA,C
 I,ATX,CODE
 TEE:S,XTA,S*N
 J,UZA,
  ,XTA,
 I,ATX,CODE
 TERET:M,VTM,MK
 I,XTA,NUMB
  ,ATI,N
 R,UJ ,
C------
 AEX:,BSS,
  ,XTS,=1
 S,STX,S*AC-1
 N,VZM,RET
  ,ARX,=1
  ,ASN,64+3
  ,U1A,MIST
 M,XTA,
 S,AEX,S*M
 S,ATX,S*AC
  ,UJ ,ZRET
C------
 IDE:,BSS,
 R,VJM,TEXT
 N,VZM,RET
  ,ARX,=7
  ,ASN,64+4
  ,U1A,MIST
 M,XTA,
  ,ASN,64+40
  ,ATI,N
 N,UTC,TABSIMIS
  ,XTA,
  ,ASN,64+45
 ZRET:,UZA,RET
  ,UJ ,MIST
C------
 MЛMБ:,BSS,
 N,VZM,RET
 M,XTA,
  ,AEX,=6H000000
 N,UTM,-6
 N,VLM,UN5
 MUN:S,ATX,S*M
  ,AAX,=6H'370''370''374''370''370''370'
 PAK:,U1A,MIST
 S,XTA,S*M
  ,APX,=6H'7''7''7''7''7''7'
  ,ASN,64+30
 SVA:S,ATX,S*AC
 S,WTC,S*V
  ,ATX,
  ,UJ ,RET
 UN5:J,VTM,MIST
 N,VLM,UN3
  ,AUX,=6H'377''377''''377''377''377'
  ,UJ ,MUN
 UN3:N,UTM,1
 N,VLM,UN2
 LUN:M,XTA,
  ,AEX,=3HF00
  ,ASN,64-8
 S,ATX,S*M
  ,YTA,
 J,U1A,
 S,XTA,S*M
 N,ASN,64+32
  ,UZA,MIST
 S,ATX,S*M
C-  CЛEДYЮЩИE ДBE KOMAHДЫ HE HYЖHЫ, TAK KAK
C-  KOДЫ 72-77 ПPИHAДЛEЖAT PAЗДEЛИTEЛЯM
C-          , ARX ,=6
C-         S, AOX ,S*M
  ,AAX,=6H'''''''''376''360'
  ,U1A,MIST
 S,XTA,S*M
  ,ASN,64+4
 :,UZA,*+1
  ,XTA,=12
 S,ARX,S*M
  ,AAX,=377
 S,ATX,S*M
  ,ASN,64+4
  ,U1A,MIST
  ,XTA,=37
 UNA:,ARX,=1
 S,ARX,S*M
  ,ASN,64-12
  ,UJ ,SVA
 UN2:N,VLM,UN1
 N,VTM,8
 J,VTM,MU2
  ,UJ ,LUN
 MU2:M,XTA,
  ,AEX,=2H00
  ,UJ ,MUN
 UN1:N,V1M,MIST
  ,ASN,64+39
 S,ATX,S*M.2,4
  ,ASN,64+1.1,2
  ,ARX,=377.0,1
  ,AAX,=376
  ,UZA,UNA
  ,UJ ,MIST
C------
 OCT:,BSS,
 J,VJM,DIG
  ,AAX,=6H'370''370''370''370''370''370'
  ,UJ ,PAK
C------
 INT:,BSS,
 J,VJM,DIG
C-  И ЭTИ ДBOE TOЖE ЛИШHИE
C-          , ARX ,=6H'6''6''6''6''6''6'
C-          , AOX ,S*M
  ,AAX,=6H'360''360''360''360''360''360'
  ,U1A,MIST
 INB:S,ATX,S*N
  ,ASN,64-2
 S,ARX,S*N
  ,ASN,64-1
 S,XTS,S*M-1
 L,ASN,64-8
  ,AAX,=377
 S,ARX,
 L,UTM,-8
 L,V1M,INB
  ,UJ ,SVA
 DIG:N,VZM,RET
  ,ARX,=1
  ,ASN,64+3
  ,U1A,MIST
  ,ITA,N
  ,ASN,64-3
  ,ATI,L.10-60B
  ,AEX,=377
  ,ATI,N.367-317B
 M,XTA,
  ,AEX,=6H000000
 N,ASN,64-317B
 S,ATX,S*M
 J,UJ ,
C------
 HOLS:,BSS,
 R,VJM,TEXT
  ,AEX,=377
  ,ARX,=1.400B-NUMB
 S,ARX,S*M
  ,ASN,64+8
  ,U1A,RET
C------
 MIST:,BSS,
  ,XTA,=1
 I,ATX,MIS
  ,UTC,OUT*OUT
  ,XTA,
  ,U1A,RET
 M,XTA,
  ,ATX,TEX2
 M,VTM,TEX1
  ,ITS,M
 M,VTM,TEX2
  ,ITS,M
  ,XTS,=1
  ,CALL,PRINT8
C------
 RET:,BSS,
 I,XTA,MIS
 S,ATX,S*M
 I,XTA,CODE
 S,ATX,S*D
 I,XTA,NUMB
 S,STX,S*N
 M,VTM,B-J
 :M,STI,J
 M,VLM,*
  ,STI,M
 J,UJ ,
C------------
 TEXA:,ISO,34HHEПPABИЛЬHOE ИCПOЛЬЗOBAHИE PARAMT*
 TEX1:,ISO,26HOШИБKA B ЗAДAHИИ ПAPAMETPA
 TEX2:,OCT,
 PXX:,BSS,4
 ,END,
