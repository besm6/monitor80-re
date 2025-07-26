 STAR*   :  , NAME, .НOBЫE TP-PЫ
c
c Cтандартная программа MC Дубна.
с Присутствуют модификации
с и доп. нерезиденты.
с
 LOADANGO:  , SUBP,
 MONITOR*: I, BLOCK,(1),(1)
 TSTATE* :  , LC  ,1
 /IP*    : I, BLOCK,(1),(1),(1),(1),(1),(1),(1)
 FLAGS   :  , LC  ,1
 *REGIM//:  , LC  ,1
 MAIN*   :  , LC  ,1
 MONCARD*:  , LC  ,14
 LOADLIS*:  , LC  ,1
 RM*     :  , LC  ,5
 INFLOAD*:LC,BLOCK,ALOAD,INFLOA
 TRCAT*  :  , LC  ,17
 КCOUNT* :  , LC  ,4
 NOLISFL*:  , LC  ,1
 FULISFL*:  , LC  ,1
 PUNCНFL*:  , LC  ,1
 LНEAP*  :  , LC  ,1
 CНECКFL*:  , LC  ,1
 MONCARD/:  , LC  ,15
 MACRO*  :  , LP  ,3
  LUN*MON :  , SUBP,
 GIVLIBR*:  , SUBP,
 GIVSERV*:  , SUBP,
 GIVTRAN*:  , SUBP,
 MONREAD*:  , SUBP, .Не исп. в Mониторе-80
 SETTRAN*:  , SUBP,
 IDENT6  :  , SUBP,
 LOADCALL:  , SUBP,
 GIVCALL*:  , SUBP,
 EXECUT  :  , SUBP,
 STOP*   :  , SUBP,
 NEWLIS  :  , SUBP,
 *1      :  ,BLOCК,M1,M2,M3,M4,M5,M6,M7,M8,M9
            , CONT,M10,M11,M12,M13,M14,M15
 вариант:M12,VTM,вариант
            , ITA ,M13
            , ATX ,RRR2
            , XTA ,TSTATE*
            , ATX ,RRR1
            , XTA ,72B
            , ASN ,64+45
            , AEX ,п3
            , U1A ,CHECKMORE+1
            , XTS ,TLDITM
         M13, VTM ,CHECKMORE+1
            , UJ  ,LOADANGO
c
 PRINT  :  , XTA ,RRR1
            , ATX ,TSTATE*
            , WTC ,RRR2
            , UJ  ,
 PRIN1T  :  , XTA ,RRR1
            , ATX ,TSTATE*
            , XTA ,MONCARD*+12
            , ATX ,MONCARD/
            , XTA ,MONCARD*+13
            , ASN ,64+32
            , ASN ,64-32
            , ATX ,MONCARD*+1
            , XTA ,л1002
            , ATX ,MONCARD*+2
         M14, VTM ,-11
 зп*крт*11:M14,XTA,MONCARD*+11
         M14, ATX ,MONCARD*+14
         M14, VLM ,зп*крт*11
         M14, VTM ,MONCARD/
            , ITS ,M14
         M14, UTM ,16B
            , ITS ,M14
            , XTS ,п1
         M13, VJM ,LUN*MON
            , XTA ,TSTATE*
            , ATX ,RRR1
            , XTA ,
            , ATX ,TSTATE*
            , XTA ,/IP*+6
            , ATX ,/IP*+5
         M14, VTM ,-13
 зп*карт*13:M14,XTA,MONCARD*+13
         M14, ATX ,MONCARD/+13
         M14, VLM ,зп*карт*13
         M14, VTM ,SWITCH
 ноль*м14:M14,XTA,
            , UZA ,типработы
            , AEX ,MONCARD*
         M14, UZA ,1
         M14, UTM ,2
            , UJ  ,ноль*м14
c
 типработы:M13,VJM,GIVLIBR*
         M14, VZM ,CHECKMORE
         M13, VJM ,GIVSERV*
         M14, VZM ,CHECKMORE
         M13, VJM ,GIVTRAN*
         M14, VZM ,CHECKMORE
         M14, UTM ,-1
         M14, VZM ,CHECKMORE
 непр*исп:M14,VTM,tillegal.=6НILLEGA
 втерм  :  , ITS ,M14
         M14, UTM ,3
            , ITS ,M14
            , XTS ,
         M13, VJM ,LUN*MON
 CHECKMORE:M13,VJM,MONREAD*
            , XTA ,MONCARD*
            , AAX ,MSMB
            , UZA ,WRLIB
            , AEX ,STAR
            , UZA ,PRIN1T
            , XTA ,TRCAT*
            , U1A ,PRINT
         M13, VJM ,SETTRAN*
            , UJ  ,PRINT
c
 станд*лист  :  , XTA ,*REGIM//
            , AAX ,о40п37
            , ATX ,*REGIM//
            , XTA ,п2
 SETLIST  :  , XTS ,FLAGS
            , AAX ,п7
            , AEX ,FLAGS
         M15, AOX ,
            , ATX ,FLAGS
            , AAX ,п1
            , ATX ,NOLISFL*
            , XTA ,FLAGS
            , ASN ,64+2
            , AAX ,п1
            , ATX ,FULISFL*
            , UJ  ,CHECKMORE
c
 NOLODL  :  , ATX ,LOADLIS*
            , UJ  ,CHECKMORE
 OPT  :  , XTS ,FLAGS
            , AOX ,е7
         M15, AEX ,
            , ATX ,FLAGS
            , AAX ,е7
            , AEX ,е7
            , ASN ,64+6
            , ATX ,CНECКFL*
            , UJ  ,CHECKMORE
c
 SYSTLODL  :  , XTA ,44B
            , AAX ,е47п1
            , ATX ,44B
            , UJ  ,CHECKMORE
c
 LHEAP  :  , ATX ,LНEAP*
         M10, VTM ,
         M13, VJM ,PARAMT
          M9, VTM ,LНEAP*
         M10, VTM ,5
         M13, VJM ,PARAMT
            , UJ  ,CHECKMORE
 PARAMT  :  , XTS ,TPARAMT
            , UJ  ,LOADANGO
c
 зп*REGIM  :  , AOX ,*REGIM//
            , ATX ,*REGIM//
            , UJ  ,CHECKMORE
 зп*REGI1M  :  , AEX ,всеед
            , AAX ,*REGIM//
            , ATX ,*REGIM//
            , UJ  ,CHECKMORE
c
 WRLIB  :  , XTS ,tstwrit
         M13, VJM ,LOADANGO
            , UJ  ,CHECKMORE+1
c
 SAVBLIST  :  , XTS ,47B
            , ATX ,пусто
            , XTA ,RM*+4
            , ATX ,47B
            , XTA ,е15е13
            , XTS ,43B
            , ASN ,64-20
         M15, AOX ,
            , ATX ,исэ70
            , *70 ,исэ70
            , STX ,
         M11, UJ  ,
c
 SAVBLIS1  :  , XTS ,47B
            , ATX ,пусто
            , XTA ,RM*+4
            , STX ,47B
         M11, UJ  ,
c
 RETBLIST  :  , XTA ,исэ70
            , AOX ,е40
            , ATX ,исэ70
            , *70 ,исэ70
 RETBLIS1  :  , XTA ,пусто
            , ATX ,47B
         M11, UJ  ,
c
 CALL:M14,VTM,MONCARD*+1
C  ПPOГPAMMЫ, BЫЗЫBAEMЫE ПO *CALL:
C  MOЖHO OФOPMЛЯTЬ KAK FUNCTION ... (KAP)
C  ГДE KAP - TEKCT KAPTЫ BЫЗOBA
C  (ДЛЯ TEX, KTO HE ЛЮБИT PARAMT*)
c
            , ITA ,M14
         M13, VJM ,IDENT6
         M14, V1M ,ошвкарт
            , ATX ,MAIN*
            , UJ  ,CHECKMORE
c
 EDIT  :  , XTA ,MONCARD*+1
            , AEX ,TOLD*
            , UZA ,READ
         M14, VTM ,-4
 readold:M14,XTA,тold
            , WTC ,43B
         M14, ATX ,4
         M14, VLM ,readold
 READ  :  , XTS ,treadvolk
            , XTS ,
         M13, VJM ,LOADCALL
            , UZA ,CHECKMORE
 ошвкарт:M14,VTM,twrong.=6НWRONG
            , UJ  ,втерм
c
 /EDIT:M13,VTM,32001B
         M11, VJM ,edi1t
         M11, VJM ,SAVBLIS1
            , ITS ,M13
            , ITS ,M14
            , XTS ,TREDACT
 TAPCOP  :  , XTS ,
         M13, VJM ,MONREAD*
            , XTA ,
         M13, VJM ,LOADCALL
         M11, VTM ,CHECKMORE+1
            , UJ  ,RETBLIS1
c
 GIV76:M11,VJM,SAVBLIS1
         M13, VJM ,GIVCALL*
         M14, V1M ,ошвкарт
         M11, VTM ,CHECKMORE+1
            , UJ  ,RETBLIS1
 GLIB:M11,VJM,SAVBLIST
         M12, XTS ,
         M13, VJM ,LOADANGO
         M11, VTM ,CHECKMORE
            , UJ  ,RETBLIST
c
 edi1t  :  , XTA ,MONCARD*+2
            , AEX ,т6пробел*
            , UZA ,edi3t
            , APX ,масрзб
            , XTS ,MONCARD*+1
            , AEX ,TDRUM*
            , UZA ,edi2t
            , STX ,
            , ASN ,64+33
            , ATI ,M14
         M11, UJ  ,
c
 edi2t  :  , STX ,
         M14, VTM ,5000B
            , AEX ,е47
         M11, UZA ,
 OLDEDIT:M14,VTM,3000B
         M11, UJ  ,
c
 edi3t:M14,VTM,31001B
            , XTA ,MONCARD*+1
            , AEX ,т6пробел*
            , U1A ,edi4t
 edi3at  :  , XTS ,47B
            , STX ,пусто
            , XTS ,TEDIT
            , UJ  ,TAPCOP
c
 edi4t  :  , XTA ,MONCARD*+1
            , AEX ,TDRUM*
            , UZA ,OLDEDIT
         M11, UJ  ,
 EXECUTE:M13,VJM,EXECUT
C
C     C COXPAHEHИEM OБM.ЛИCTA
 TAPCOPT  :  , XTA ,п1
            , ATX ,KCOUNT*+2
            , XTA ,43B .адрес обм. листа
            , ASN ,64-20
            , AOX ,tapconst
            , ATX ,60B
            , ATX ,47B
            , UJ  ,CHECKMORE
c
 TEMPO  :  , XTA ,
c ******НEOПИCAННЫЙ ИДEНTИФИКATOP           *77770
   ,ATX,вариант-10B
            , XTA ,RM*+4
            , ATX ,60B
            , ATX ,47B
            , XTA ,RRR1
            , ATX ,TSTATE*
         M13, VTM ,MONITOR*+1
            , UJ  ,MONREAD*
c
 SWITCH  :  ,bss,
            ,ISO,6H*NAME
           , UJ  ,непр*исп
         ,ISO,6H*FULL
            , XTA ,п4 .*FULL LIST
            , UJ  ,SETLIST
         ,ISO,6H*NO LI
            , XTA ,п1 .*NO LIST
            , UJ  ,SETLIST
          ,ISO,6H*STAND
            , XTA ,п2  .*STANDARD
            , UJ  ,станд*лист
          ,ISO,6H*NO LO
            , XTA ,п1
            , UJ  ,NOLODL
          ,ISO,6H*SYSTE
            , UJ  ,SYSTLODL
          ,ISO,6H*ADRES
            , XTA ,е37
            , UJ  ,зп*REGIM
          ,ISO,6H*NO ST
            , XTA ,е38
            , UJ  ,зп*REGIM
          ,ISO,6H*NO BI
            , XTA ,е39
            , UJ  ,зп*REGIM
          ,ISO,6H*OLD P
            , XTA ,е40
            , UJ  ,зп*REGIM
          ,ISO,6H*LHEAP
            , XTA ,е9
            , UJ  ,LHEAP
          ,ISO,6H*SUPER
            , XTA ,е48е43
            , UJ  ,зп*REGIM
          ,ISO,6H*NO SU
            , XTA ,е48е43
            , UJ  ,зп*REGI1M
          ,ISO,6H*DEBUG
            , XTA ,е42
            , UJ  ,зп*REGIM
          ,ISO,6H*NO DE
            , XTA ,е42
            , UJ  ,зп*REGI1M
          ,ISO,6H*PUNCH
            , XTA ,п1
            , UJ  ,есть*punch
          ,ISO,6H*NO PU
 есть*punch  :  , ATX ,PUNCНFL*
            , UJ  ,CHECKMORE
          ,ISO,6H*EXECU
         M13, VTM ,EXECUTE
            , UJ  ,MONREAD*
          ,ISO,6H*MAIN
            , UJ  ,CALL
          ,ISO,6H*READ
            , UJ  ,EDIT
          ,ISO,6H*READ:
            , UJ  ,EDIT
          ,ISO,6H*EDIT
            , UJ  ,/EDIT
          ,ISO,6H*EDIT:
            , UJ  ,edi3at
          ,ISO,6H*CALL
            , UJ  ,GIV76
          ,ISO,6H*EXCLU
         M12, VTM ,tlibdelet
            , UJ  ,GLIB
          ,ISO,6H*LIBPU
         M12, VTM ,tlibrpn
            , UJ  ,GLIB
          ,ISO,6H*LIBLI
         M12, VTM ,tliblis
            , UJ  ,GLIB
          ,ISO,6H*PERMA
            , UJ  ,TAPCOPT
          ,ISO,6H*TEMPO
            , UJ  ,TEMPO
          ,ISO,6H*
            , UJ  ,CHECKMORE
          ,ISO,6H*1
            , UJ  ,NEWLIST
          ,ISO,6H*OPTIM
            , XTA ,
            , UJ  ,OPT
          ,ISO,6H*NO OP
            , XTA ,е7
            , UJ  ,OPT
          ,ISO,6H*NO CH
         M11, VTM ,DOS
            , UJ  ,SAVBLIS1
            ,ISO,6H*CHECK
         M11, VTM ,CHECK
            , UJ  ,SAVBLIS1
           ,ISO,6H*MACRO
            , XTA ,е48
            , UJ  ,MACRO
          ,ISO,6H*NO MA
            , XTA ,MACRO*
            , UJ  ,NO*MACRO
          ,ISO,6H*NO WR
            , XTA ,е5
            , UJ  ,NO*WR
       ,ISO,6H*END F
         M13, VJM ,STOP*
            , BSS ,1
 MACRO  :  , AOX ,MACRO*
            , ATX ,MACRO*
            , UJ  ,CHECKMORE
 NO*MACRO  :  , ASN ,64-1
            , ASN ,64+1
            , ATX ,MACRO*
            , UJ  ,CHECKMORE
c
 NO*WR  :  , AOX ,FLAGS
            , ATX ,FLAGS
            , UJ  ,CHECKMORE
c
 CHECK  :  , XTA ,е13п1
 DOS  :  , XTS ,TSETFTN
         M13, VJM ,LOADANGO
         M11, VTM ,CHECKMORE
            , UJ  ,RETBLIS1
 NEWLIST:M13,VJM,NEWLIS
            , UJ  ,CHECKMORE
 tillegal  :  , ISO ,24НILLEGAL SУSTEM CARD
 twrong  :  , ISO ,24НWRONG USE OF SУSTEM CARD
с              , OCT ,1250 2510 2125 204
               , ISO ,6Н*’205’НET
              , ISO ,6НЗAПИCИ
c              , LOG ,6060 5040 1002 0012
                , TEXT,8НPPHЗ'10'Б'00'*
              , ISO ,6Н*READ
   told  :  ,bss,
c              , LOG ,2364 6104 6240 5012
              , ISO,6НOLD'312''012''012'
   STAR  :  , bss ,
c , OCT ,124
            , TEXT,8Н*З
   treadvolk  :  ,bss,
c            , LOG ,6245 4144 6657 5453
            , TEXT ,8НREADVOLK
   tstwrit  : ,bss,
c            , OCT ,6364 6762 5164 12
             ,TEXT,8HSTWRIT*
   tlibdelet  : ,bss,
c           , LOG ,5451 4244 4554 4564
             ,TEXT,8HLIBDELET
   tlibrpn  :  ,bss,
c , OCT ,5451 4262 6056 12
             ,TEXT,8HLIBRPN*
   tliblis  :  ,bss,
c            , OCT ,6254 5142 5451 63
             ,TEXT,8HRLIBLIS
   MSMB  :  , OCT ,776
   е47п1  :  , LOG ,3777 7777 7777 7777
   всеед  :  , LOG ,7777 7777 7777 7777
   TPARAMT  :  ,bss,
c , OCT ,6041 6241 5564 12
             ,TEXT,8HPARAMT*
   пусто  :  , LOG ,
   TSETFTN  :  ,bss,
c , OCT ,6345 6446 6456
             ,TEXT,6HSETFTN
   TREDACT  :  , bss ,
c , LOG ,6245 4441 4364 1212
             ,TEXT,8HREDACT**
   TLDITM  :  , bss ,
c    , OCT ,5444 5164 5512
             ,TEXT,8HLDITM*    .c этим разбираться отдельно
   TEDIT  :  , bss ,
c , OCT ,4544 5164 1212 12
             ,TEXT,8HEDIT***
   е5  :  , LOG ,20
   е38  :  , OCT ,0002
   е39  :  , OCT ,0004
   е40  :  , OCT ,001
   е7  :  , LOG ,100
   е9  :  , LOG ,400
   е42  :  , OCT ,004
   масрзб  :  , OCT ,0160 3407 0160 34
   п1  :  , LOG ,1
   п2  :  , LOG ,2
   л1002  :  , OCT ,1002
   tapconst  :  , OCT ,0014 0000 0021
   е13п1  :  , LOG ,1 7777
   п3  :  , LOG ,3
   п4  :  , LOG ,4
   е47  :  , OCT ,2
   т6пробел*  :  , ISO ,6Н
   TDRUM*  :  , ISO ,6НDRUM
   о40п37  :  , LOG ,7760 7777 7777 7777
   п7  :  , LOG ,7
   е48  :  , OCT ,4
   е37  :  , OCT ,0001
   е48е43  :  , OCT ,41
   е15е13  :  , LOG ,7 0000
   TOLD*  :  , ISO ,6НOLD
   исэ70  :  , BSS ,2
   RRR1  :  , BSS ,1
   RRR2  :  , BSS ,1
               , END ,
