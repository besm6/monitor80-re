 MONITOR/:  , NAME,
C
C*****   ДOПOЛHEHИE PEЗИДEHTA MOHИTOPA
C*****   ПPИ PAБOTE ДO '*EXECUTE'
C*****   ( 2-OЙ PEЗИДEHT MOHИTOPA )
C B MС ДУБНA - MONTRAN/. BЫЗ. через MONITOR*
c
 *REGIM//:  , LC  ,1
 MAIN*   :  , LC  ,1
 MONCARD*:  , LC  ,14
 RFMRTFLG:  , LC  ,1
 RM*     :  , LC  ,5
 INFLOAD*:  , LC  ,4
 STCAT*  :  , LC  ,1
 ENTRY*  :  , LC  ,42
 FLGEX*  :  , LC  ,1
 NOLISFL*:  , LC  ,1
 FULISFL*:  , LC  ,1
 TRNAME* :  , LC  ,1
 TRCAT*  :  , LC  ,17
 PUNCHFL*:  , LC  ,1
 ERROFLG*:  , LC  ,1
 AMONIT/ :  , LC  ,1
 ASTL*   :  , LC  ,1
 LOADANGO:  , SUBP,
 STLOAD* :  , SUBP,
 MONREAD*:  , SUBP,
 RRR1    :  , LP  ,3
 READ*   :  , SUBP,
 PRINT8  :  , SUBP,
 STOP*   :  , SUBP,
 LUN*MON :  , SUBP,
 DRUMTAP*:  , SUBP,
 CLEARLEX:  , SUBP,
 COSYTISO:  , SUBP,
 RESET*  :  , SUBP,
 LOADCALL:  , SUBP,
 *1      :  ,BLOCK,M1,M2,M3,M4,M5,M6,M7,M8,M9
            , CONT,M10,M11,M12,M13,M14,M15
c
 MONIT  :  , XTA ,16B
            , UJ  ,MONI1T
            , UJ  ,CHSTAR
         :  , UJ  ,в*RESET
 MONI1T  :  , ATX ,RM*
            , XTA ,17B
            , ATX ,RM*+1
            , ITA ,M15
            , ATX ,RM*+2
            , XTA ,44B
            , ATX ,RM*+3
            , XTA ,47B
            , ATX ,RM*+4
            , XTA ,60B
            , ATX ,47B
            , XTA ,77B
            , AAX ,п19
            , U1A ,CHSTAR
            , XTA ,INFLOAD*+1
            , ATX ,INFLOAD*
            , XTA ,43B
            , ATX ,STCAT*
            , XTA ,73B
            , ASN ,64+45
            , ATI ,M13
C.....   ИHИЦИAЛИЗAЦИЯ MOHИTOPHOЙ CИCTEMЫ
 INITSYS :M13,V1M,INPUT
            , XTS ,TINPUTCALL
         M13, VJM ,LOADANGO
 INPUT  :  , XTS ,TCHECKJOB
         M13, VJM ,LOADANGO
C======================================
 NEWSTAR*:  ,ENTRY,
C======================================
C.....   ПOXOД HA 'STAR*' ИЛИ TPAHCЛЯTOP
 CHSTAR  :  , XTA ,
            , ATX ,INFLOAD*
            , XTA ,43B
            , ATX ,STCAT*
         M13, VJM ,RESET*
            , XTA ,MONCARD* .текстов. карта
            , AAX ,е48е41
            , UZA ,TOSTAR .нет?
            , AEX ,л124 .со звездочкой?
            , U1A ,TOSTA1R .да?
C.....   BЫЗOB KAKOГO-TO TPAHCЛЯTOPA
 TOSTAR  :  , XTS ,TSTAR
         M13, VJM ,LOADANGO
 TOSTA1R  :  , XTA ,TRCAT*
            , UZA ,TOSTAR
            , XTA ,ASTL*
            , ATX ,INFLOAD*
         M14, VTM ,TRCAT*
            , ITA ,M14
            , ATX ,STCAT*
            , XTS ,TRNAME*
            , XTS ,
         M13, VJM ,LOADCALL
 в*RESET:M13,VJM,RESET*
C.....   OTPAБOTAЛ TPAHCЛЯTOP
            , XTA ,FLGEX* .БЫЛИ OШИБКИ
            , UZA ,NOERROR .НET
            , ATX ,ERROFLG* . НAКOПЛEНИE
            , XTA , .OШИБOК
            , ATX ,FLGEX*
            , UJ  ,CHSTAR
C.....   OШИБOK TPAHCЛЯЦИИ HE БЫЛO
 NOERROR:M14,VTM,INFLOAD*+1
            , XTA ,72B
            , ARX ,
            , U1A ,DINAM
C.....   ЗAПИCЬ CM BO BPEM.БИБЛИOTEKY
        M14, VTM ,
 DINAM:M14,XTA,
            , ATX ,INFLOAD*
            , XTA ,77B
            , ATX ,ASTLOAD
            , XTA ,INFLOAD*+2
            , ATX ,77B
         M14, VTM ,ENTRY*
            , ITS ,M14
            , XTS ,TWRITLIB
         M13, VJM ,LOADANGO
            , XTA ,INFLOAD*+1 .BOССTAНOBИM
            , ATX ,INFLOAD* .ДИН. ЗAГPУЗКУ
C.....   ПEPФOPAЦИЯ CM
            , XTS ,PUNCHFL*
            , UZA ,NOPUNCH
         M14, VTM ,ENTRY*
            , ITS ,M14
            , XTS ,TSTPUNCH
         M13, VJM ,LOADANGO
 NOPUNCH  :  , XTA ,ASTLOAD
            , ATX ,77B
            , UJ  ,CHSTAR
 AMONIT  :  , ATX ,
            , Z00 ,MONIT
 ASTLOAD  :  , ATX ,
            , Z00 ,STLOAD*
 е48е41  :  , OCT ,776
 л124  :  , OCT ,124
C-----   ИMEHA PAЗДEЛOB
 TINPUTCALL  :  , TEXT,8HINPUTCAL
 TWRITLIB  :  , TEXT,8HWRITLIB*
 TSTPUNCH  :  , TEXT,8HSTPUNCH*
 TCHECKJOB  :  , TEXT,8HCHEKJOB*
 TSTAR  :  , TEXT,8HSTAR*
 п19  :  , LOG ,100 0000
            , DATA,
 п40  :  , OCT ,001
 TFORTRAN  :  , TEXT,8HFORTR*
           1, SET ,TFORTRAN
           1,     ,TRNAME*
           1, SET ,AMONIT
           1,     ,AMONIT/
           1, SET ,ASTLOAD
           1,     ,ASTL*
           1, SET ,77B
           1,     ,INFLOAD*+2
           1, SET ,ASTLOAD
           1,     ,INFLOAD*+1
            , END ,
