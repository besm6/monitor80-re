  EXECUT  :  , NAME,
c
c Cтандартная программ MC Дубна.
с Cокращено для Mонитора-80
с
c OTКAЗ OT НEНУЖНЫX TPAКTOB MБ
C CAXAPOB Б.Б.
C
C********************
C   KAK ПOKAЗAЛ OПЫT,
C   ДOБABЛEHИE HOBЫX
C   OБ'EKTOB K PEЗИДEHTY
C   MOHИTOPA  Ч P E B A T O .
C********************
  ERROFLG*:  , LC  ,1
  MONCARD/:  , LC  ,14
  MONITOR*:  , SUBP,
  RM*     :  , LC  ,1
  INFLOAD*:  , LC  ,1
  LOADLIS*:  , LC  ,1
  STOP*   :  , SUBP,
  BLEXPRIN:  , SUBP,
  TAPELIST:  , LC  ,25
  MAIN*   :  , LC  ,1
  LOADANGO:  , SUBP,
  *1      :  ,BLOCК,M1,M2,M3,M4,M5,M6,M7,M8,M9
             , CONT,M10,M11,M12,M13,M14,M15
c
             , XTA ,ERROFLG*
             , UZA ,взу
          M13, VTM ,STOP*
             , UJ  ,BLEXPRIN
  взу  :  , XTA ,INFLOAD*
             , U1A ,EX1
             , XTA ,TAPELIST+24
             , AAX ,п2
             , UZA ,EX1
             , XTA ,TEXECU
             , ATX ,MONCARD/
             , XTS ,TIODCALL
          M13, VJM ,LOADANGO
  EX1  :  , XTA ,
             , ATX ,770B .ДЛЯ M-80
             , XTA ,771B .ДЛЯ M-80
             , ATX ,16B
             , XTA ,772B
             , ATX ,17B
             , XTA ,RM*+2
             , ATI ,M15
             , NTR ,2
             , XTA ,RM*+3
             , ATX ,44B
             , XTA ,RM*+4
             , ATX ,47B
             , XTA ,LOADLIS*
             , U1A ,BLP .ЗAГPУЗКУ
             , XTA ,44B .НE ПEЧATATЬ
             , ASN ,64-1
             , ASN ,64+1
             , ATX ,44B
  BLP  :  , XTS ,
             , XTS ,MAIN*
             , XTS ,
             , UJ  ,MONITOR*+3 .ПOШЛИ
с                   НA ЗAГPУЗКУ
  TIODCALL  :  , TEXT,8НIODCALL*
  п2  :  , LOG ,2
  TEXECU  :  , ISO ,6Н*EXECU
             , END ,
