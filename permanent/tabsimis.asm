 TABSIMIS:  , NAME,
 *1      :  ,BLOCK,M1,M2,M3,M4,M5,M6,M7,M8,M9
            , CONT,M10,M11,M12,M13,M14,M15
C**************************************************************
C*                                                            *
C*      TAБЛИЦA XAPAKTEPИCTИK CИMBOЛOB ДЛЯ KOДИPOBKИ ISO      *
C*      ------------------------------------------------      *
C*   XAPAKTEPИCTИKA CИMBOЛA C KOДOM I (0..177B) COДEPЖИTCЯ B  *
C*  I-TOM CЛOBE TAБЛИЦЫ, B CЛEДYЮЩEM ФOPMATE:                 *
C*  PAЗPЯДЫ  COДEPЖИMOE                                       *
C*   48-46    TИП CИMBOЛA:                                    *
C*            0 - БYKBA ( + CИMBOЛЫ '*' ,'/' И ПPOБEЛ)        *
C*            2 - BOCЬMEPИЧHAЯ ЦИФPA (0..7)                   *
C*            3 - ДECЯTИЧHAЯ ЦИФPA (8,9)                      *
C*            1 - PAЗДEЛИTEЛЬ (BCE OCTAЛЬHЫE CИMBOЛЫ)         *
C*   45-40    KOД TEXT, ECЛИ OH CYЩECTBYET ДЛЯ ДAHHOГO CИM-   *
C*            BOЛA, ИHAЧE HYЛЬ                                *
C*   39-1     HYЛЬ (И ЭTO CYЩECTBEHHO)                        *
C*                                                            *
C**************************************************************
C-------------------------------------------
C        KOД  :     :KOД  :
C        ISO  :  TИП:TEXT : CИMBOЛ
C-------------------------------------------
c
 00,OCT,1
 01,OCT,1
 02,OCT,1
 03,OCT,1
 04,OCT,1
 05,OCT,1
 06,OCT,1
 07,OCT,1
 10,OCT,1
 11,OCT,1
 12,OCT,1
 13,OCT,1
 14,OCT,1
 15,OCT,1
 16,OCT,1
 17,OCT,1
 20,OCT,1
 21,OCT,1
 22,OCT,1
 23,OCT,1
 24,OCT,1
 25,OCT,1
 26,OCT,1
 27,OCT,1
 30,OCT,1
 31,OCT,1
 32,OCT,1
 33,OCT,1
 34,OCT,1
 35,OCT,1
 36,OCT,1
 37,OCT,1
 TABSIM:40,OCT,.ПPOБEЛ
 41,OCT,1.BOCKЛ.ЗH
 42,OCT,1.KABЫЧKA
 43,OCT,1.HEPABHO
 44,OCT,1.ДOЛЛAP
 45,OCT,1.%
 46,OCT,1.&
 47,OCT,1.' (AПOCTPOФ)
 50,OCT,1.(
 51,OCT,1.)
C-------------------------------------------
C        KOД  :     :KOД  :
C        ISO  :  TИП:TEXT : CИMBOЛ
C-------------------------------------------
 SIM*:52,OCT,0 12.*
 53,OCT,1 36.+
 54,OCT,1.,
 55,OCT,1 35.-
 56,OCT,1.TOЧKA
 SIM/:57,OCT,0 17./
 60,OCT,2 20.0
 61,OCT,2 21.1
 62,OCT,2 22.2
 63,OCT,2 23.3
 64,OCT,2 24.4
 65,OCT,2 25.5
 66,OCT,2 26.6
 67,OCT,2 27.7
 70,OCT,3 30.8
 71,OCT,3 31.9
 72,OCT,1.:
 73,OCT,1.;
 74,OCT,1.<
 75,OCT,1.=
 76,OCT,1.>
 77,OCT,1.BOПP.ЗH
 100,OCT,1.@ (AT)
 101,OCT,0 41.A
 102,OCT,0 42.B
 103,OCT,0 43.C
 104,OCT,0 44.D
 105,OCT,0 45.E
 106,OCT,0 46.F
 107,OCT,0 47.G
 110,OCT,0 50.H
 111,OCT,0 51.I
 112,OCT,0 52.J
 113,OCT,0 53.K
 114,OCT,0 54.L
 115,OCT,0 55.M
 116,OCT,0 56.N
 117,OCT,0 57.O
 120,OCT,0 60.P
 121,OCT,0 61.Q
 122,OCT,0 62.R
 123,OCT,0 63.S
 124,OCT,0 64.T
 125,OCT,0 65.U
 126,OCT,0 66.V
 127,OCT,0 67.W
 130,OCT,0 70.X
 131,OCT,0 71.Y
 132,OCT,0 72.Z
 133,OCT,1.[
 134,OCT,1.OБP.KOCAЯ
 135,OCT,1.]
 136,OCT,1.HAДЧEPK.
 137,OCT,1.ПOДЧEPK.
 140,OCT,0 77.Ю
 141,OCT,1
 142,OCT,0 02.Б
 143,OCT,0 03.Ц
 144,OCT,0 04.Д
 145,OCT,1
C-------------------------------------------
C        KOД  :     :KOД  :
C        ISO  :  TИП:TEXT : CИMBOЛ
C-------------------------------------------
 146,OCT,0 05.Ф
 147,OCT,0 06.Г
 150,OCT,1
 151,OCT,0 07.И
 152,OCT,0 13.Й
 153,OCT,1
 154,OCT,0 14.Л
 155,OCT,1
 156,OCT,1
 157,OCT,1
 160,OCT,0 34.П
 161,OCT,0 15.Я
 162,OCT,1
 163,OCT,1
 164,OCT,1
 165,OCT,1
 166,OCT,0 16.Ж
 167,OCT,1
 170,OCT,0 32.Ь
 171,OCT,0 37.Ы
 172,OCT,0 40.З
 173,OCT,0 73.Ш
 174,OCT,0 74.Э
 175,OCT,0 75.Щ
 176,OCT,0 76.Ч
 177,OCT,1
   , END ,
