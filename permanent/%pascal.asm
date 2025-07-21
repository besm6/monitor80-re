 *PASCAL :  , NAME,
 MONCARD*:  , LC  ,1
 GIVTRAN*:  , SUBP,
 PRINT8  :  , SUBP,
 *1      :  ,BLOCK,M1,M2,M3,M4,M5,M6,M7,M8,M9
            , CONT,M10,M11,M12,M13,M14,M15
c
            , XTA ,MONCARD*
            , ATX ,карт*pascal
            , XTA ,TPASCA
            , ATX ,MONCARD*
            , ITA ,M13
         M15, ATX ,
         M13, VJM ,GIVTRAN*
         M14, VTM ,TУСTAН  .=6HYCTAHO
            , ITS ,M14
         M14, UTM ,4
            , ITS ,M14
         M14, VTM ,2
            , ITS ,M14
         M13, VJM ,PRINT8
            , XTA ,карт*pascal
            , ATX ,MONCARD*
         M15, WTC ,
            , UJ  ,
 TPASCA  :  , ISO ,6H*PASCA
 TУСTAН  :  , ISO ,12HYCTAHOBЛEH P
            , ISO ,6HEЖИM ’42’
            , ISO ,6H*PASCA
            , ISO ,6HL’42’
 карт*pascal  :  , BSS ,1
            , END ,
