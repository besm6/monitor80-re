  FICMEM* :  , NAME,
c
с программа "Mонитор-80" ИAЭ
с
  INFLOAD*:  ,LC ,4
  MONITOR*:  , SUBP,
  STCAT*  :  ,LC ,1
  RM*     :  ,LC ,0
  КCOUNT* :  ,LC ,0
  LUN*MON :  , SUBP,
  *1      :  ,BLOCК,M1,M2,M3,M4,M5,M6,M7,M8,M9
             , CONT,M10,M11,M12,M13,M14,M15
         M15,V1M,УESMEMO2
         M15,VTM,73400B
            ,UJ ,УESMEMO2
C======================================
 FULLMEMO:  ,ENTRУ,
C======================================
         M15,VTM,57400B
            ,UJ ,УESMEMO2
C======================================
 УESMEMOR:  ,ENTRУ,
C======================================
            ,XTA,MONITOR*+1
            ,UTC,E15P1  .=7 7777
            ,AAX,
            ,UZA,УESMEMO1
            ,ITS,M13
         M14,VTM,тлисзан  .=6НЛИCT 3
            ,ITS,M14
            ,ITS,
            ,ITS,
         M13,VJM,LUN*MON
            ,STI,M13
         M15,VTM,73400B
            ,UJ ,УESMEMO2
 УESMEMO1:M15,VTM,75400B .отриц?
 УESMEMO2  :M9,VTM,УESMEMO2 .уиа
            ,ITA,M15
          M9,AOX,45B
          M9,ATX,45B
            ,ITA,M15
            ,ASN,64-15
          M9,ATX,61B
         M15,UTM,-1
            ,ITA,M15
          M9,ATX,60B
         M15,UTM,2
            ,ITA,M15
            ,ATX,RM*+2
            ,XTA,44B
          M9,AAX,62B
          M9,AOX,61B
            ,ATX,44B
            ,XTA,RM*+3
          M9,AAX,62B
          M9,AOX,61B
            ,ATX,RM*+3
          M9,XTA,56B
            ,ATX,КCOUNT*+2
          M9,XTA,57B
            ,ASN,64+20
            ,ATX,43B
            ,ATX,КCOUNT*+3
            ,XTA,STCAT*
            ,ASN,64+10
            ,UZA,УESMEMO3
            ,XTA,43B
            ,ATX,STCAT*
 УESMEMO3:M14,VTM,-3
 УESMEMO4:M14,XTA,50B
          M9,AOX,57B
         M14,ATX,50B
         M14,VLM,УESMEMO4
            ,XTA,60B
          M9,AOX,57B
            ,ATX,60B
            ,XTA,61B
          M9,AOX,57B
            ,ATX,61B
            ,XTA,INFLOAD*+3
          M9,AOX,57B
            ,ATX,INFLOAD*+3
            ,XTA,RM*+4
          M9,AOX,57B
            ,ATX,RM*+4
            ,XTA,RM*
          M9,AAX,64B
          M9,AOX,60B
            ,ATX,RM*
         M14,VTM,770B
 DISP:M14,XTA,1
          M9,AAX,64B
          M9,AOX,60B
         M14,ATX,1
         M14,XTA,5
          M9,AAX,64B
          M9,AOX,60B
         M14,ATX,5
         M14,XTA,6
            ,AEX,17B
            ,UZA,M67
         M14,XTA,6
            ,ATI,M14
            ,UJ ,DISP
 M67  :M9,*67,45B
 EXIT:M13,UJ,
         :  ,Z00,EXIT
          M9,ATX,
 тлисзан  :  ,ISO,24НЛИCT 36 ЗAНЯT Ф-CИCTEMOЙ
            ,ISO,24Н, УCTAНOBЛEН FICMEMORY'012'
C           ,OCT,2324 7522 2620 504
            ,LOG,1
            ,OCT,0000 37
            ,LOG,7 3377
            ,OCT,0000 0073 4
            ,LOG,7777 7700 0007 7777
 E15P1  :  ,LOG,7 7777
            ,OCT,7777 7777 777
            ,END,
