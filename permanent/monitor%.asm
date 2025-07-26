C
C MOНИTOP-117A
C
C  БЛOК OБЩEГO ПOЛЯ AДPEСOB
С  B MС ДУБНA НAXOД B ПPOГP. REDUOL
C  (B MOНИTOPE-80 - OTСУTСTBУET)
С
C 'DECLARATION'
C AC:,EQU,8.10B .сумматор
C AS:,EQU,9.11B
C AU:,EQU,10.12B
C MODE:,EQU,11.13B
C REGIM:,EQU,12.14B
C SECENTRY:,EQU,13.15B .ENTRY IN SECTION.
C ALF1:,EQU,14.16B .рабочая яч. для зп. инф, прин. с терм N1?
C ALF2:,EQU,15.17B. рабочая яч. для зп. инф, прин. с терм N2?
C OVFLJUMP:,EQU,16.20B
C IR1:,EQU,17.21B
с
c aдр. 22B-33B исп. в прог. ввода-вывода
с Mонитора-80
с
C IR12:,EQU,28.34B
C IR13:,EQU,29.35B
C NDEF:,EQU,30.36B
C NSET:,EQU,31.37B
C NDATA:,EQU,32.40B
C R:,EQU,33.41B
C DEFADR:,EQU,34.42B
C LEX:,EQU,35.43B .AДP OБM. ЛИСTA
C ALFA:,EQU,36.44B
C RLEX:,EQU,37.45B
C WLEX:,EQU,38.46B
C RCAT:,EQU,39.47B ЧTEНИE КATAЛOГA TEMPORARY LIB
C WCAT:,EQU,40.50B ЗAПИСЬ КATAЛOГA TEMPORARY LIB
C LI14:,EQU,41.51B
C LR:,EQU,42.52B
C AEX:,EQU,43.53B
с LRDM:,EQU,54B СBOБ. MEСTO B TEMPORARY LIB
C CARWORD:,EQU,46.56B
C ARray:,EQU,47.57B    .Длина массива
C RLOAD:,EQU,49.61B
C QNAME:,EQU,50.60B    .Имя искомой ппрограмы/упр. карты?
c 62B
C RELADR:,EQU,51.63B
C ERROFLAG:,EQU,52.64B
C LOCSUBP:,EQU,53.65B
C INFSUB:,EQU,2.2B
C TYPE:,EQU,3.3B
C STR:,EQU,4.4B
C STR1:,EQU,5.5B
C STR2:,EQU,6.6B
C NBODY:,EQU,7.7B
C WORDADR:,EQU,54.66B
C PR:,EQU,55.67B
C ASUBP:,EQU,57.71B
C SHIFR:,EQU,58.72B
C AP:,EQU,ALF2.
C ADATA:,EQU,56.70B
C LOADLIBR:,EQU,60
C LTAPES:,EQU,59
c
c <<< БЛOК MONITOR* >>>
c
 MONITOR*:  , NAME,
c
c Cтандартная программа MC Дубна.
с Cильно изменена в версии для Mонитора-80
с
 LНEAP*  :  ,LC ,1
 A/I0    :  ,LC ,1
 A/MINUS :  ,LC ,1
 CНECКFL*:  ,LC ,1
 FLAGS   :  ,LC ,1
 MAIN*   :  ,LC ,1
 INFLOAD*:  ,LC ,4
c INFLOAD*:LC,BLOCK,ALOAD,INFLOA,INFMD,INFDM
 LOADLIS*:  ,LC ,1
 AMONIT/ :  ,LC ,1
 RM*     :  ,LC ,5
 STCAT*  :  ,LC ,1
 ACC*    :  ,LC ,1
 LOADANGO:  , SUBP,
 LOADCALL:  , SUBP,
 SETIODCB:  , SUBP,
 IODCB*  :  ,LC ,31
 TAPELIST:  ,LC ,25
 WORINF* :  ,LC ,1
 DATA*   :  ,LC ,2
 TRNAME* :  ,LC ,1
 КCOUNT* :  ,LC ,4
 *REGIM//:  ,LC ,1
 ARREAD* :  ,LC ,2
 MONCARD*:  ,LC ,25
 STLOAD* :  , SUBP,
 RFMRTFLG:  ,LC ,1
 IOLIST* :  ,LC ,5
 *IOXLCB*:  ,LC ,1
 RESTOP* :  ,LC ,1
 POINT/PT:  ,LC ,1
 ASTL*   :  ,LC ,1
 NEWOLD* :  ,LC ,1
 RRR     :  ,LP ,0
 RRR1    :  ,LP  ,-RRR+30001B
 SYS P   :  ,WEQ,43B
 *1      :  ,BLOCК,M1,M2,M3,M4,M5,M6,M7,M8,M9
            , CONT,M10,M11,M12,M13,M14,M15
            ,XTS,TMONITOR
         M13,VJM,LOADANGO
            ,UJ ,reset1
C !КAК ПPOXOДИM ДAЛЬШE?
         :  ,WTC,AMONIT/
            ,UJ ,2
         M13,VTM,stop1
            ,UJ ,LOADCALL
C! ФУНКЦИOНИPУET ЛИ УЧACTOК BЫШE?
C======================================
 RESET*  :  ,ENTRУ,
C======================================
            ,XTA,RM*
            ,ATX,16B
            ,XTA,RM*+1
            ,ATX,17B
            ,XTA,RM*+2
            ,ATI,M15
            ,NTR,2
         M13,UJ ,
 reset1  :  ,WTC,AMONIT/
            ,UJ ,1
C======================================
 STOP**  :  ,ENTRУ,
C======================================
 stop1  :  ,SJ ,
 TMONITOR:,TEXT,8HMONITOR/
 пам1  :  ,BSS,1
           , DATA,
 LНEAP0  :  ,LOG,400
 A/I00  :  ,INT,0
 A/MINUS0  :  ,OCT,002
 КC0  :     ,BSS,
          ,LOG,
          ,LOG,10 0000 0000 7777
           ,LOG,1
           ,LOG,6 4000
 MAIN  :  ,TEXT,8HPROGRAM
 I/O :      ,BSS,
           ,INT,50
           ,INT,51
           ,INT,52
           ,INT,53
           ,INT,54
 NEWOLD  :  ,OCT,0000 01
 FLAGS0  :  ,LOG,122
 IOXLB  :  ,LOG,6400 0005 0000 0067
 TAPELIS  :  ,OCT,1777 7777 76
          1,SET,TAPELIS
          1,,TAPELIST+24
          1,SET,IOXLB
          1,,*IOXLCB*
          1,SET,FLAGS0
          1,,FLAGS
          1,SET,MAIN
          1,,MAIN*
          4,SET,КC0
          1,,КCOUNT*
          1,SET,43B
          1,,KCOUNT*+3
          1,SET,60B
          1,,INFLOAD*+3
          1,SET,КC0+1
          1,,WORINF*
          1,SET,NEWOLD
          1,,NEWOLD*
          1,SET,LНEAP0
          1,,LНEAP*
          1,SET,A/I00
          1,,A/I0
          1,SET,A/MINUS0
          1,,A/MINUS
           ,END,
