  GIVTRAN*:  , NAME,
c
с программа "Mонитор-80" ИAЭ
с
   TTABLE* :  , SUBP,
   MONCARD*:  , LC  ,1
   INFLOAD*:LC,BLOCK,ALOAD,INFLOA,INFMD,INFDM
   STACOMP*:  , SUBP,
   *1      :  ,BLOCК,M1,M2,M3,M4,M5,M6,M7,M8,M9
              , CONT,M10,M11,M12,M13,M14,M15
            , XTA ,MONCARD*
            , UJ  ,чт*тбл*трн
C======================================
 SETTRAN*:  ,ENTRУ,
C======================================
            , XTA ,tfortran
 чт*тбл*трн  :  , ATX ,для*тип*трн
            , XTA ,INFMD
            , ATX ,77B
         M14, VTM ,TTABLE*
 что*дальше:M14,XTA,
            , UZA ,взв*STAR*
            , AEX ,для*тип*трн
            , UZA ,в*STACOMP
         M14, UTM ,2
            , UJ  ,что*дальше
 в*STACOMP:M14,XTA,1
            , UJ  ,STACOMP*
 взв*STAR*:M14,VTM,2
         M13, UJ  ,
 tfortran  :  , ISO ,6Н*FORTR
 для*тип*трн  :  , BSS ,1
            , END ,
