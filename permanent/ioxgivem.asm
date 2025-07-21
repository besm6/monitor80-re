 IOXGIVEM:  , NAME,
c
c Программа "Mонитор-80" ИAЭ
c
 *IOXLSW*:  , LC  ,1
 *1      :  ,BLOCK,M1,M2,M3,M4,M5,M6,M7,M8,M9
            , CONT,M10,M11,M12,M13,M14,M15
c
            , ATI ,M14
         M14, XTA ,
C======================================
 GIVEMASK:  ,ENTRY,
C======================================
            , ATI ,M14
         M14, UTM ,-10
            , ITA ,M14
            , ASN ,64+6
            , AEX ,
            , U1A ,gvmask
         M14, VTM ,
 gvmask  :  , UTC ,gvmas1k
         M14, XTA ,
         M13, UJ  ,
         :  , ATX ,
            , Z00 ,мас4
            , ATX ,1
            , Z00 ,мас1
            , ATX ,1
            , Z00 ,мас1
            , ATX ,2
            , Z00 ,мас2
            , ATX ,
            , Z00 ,мас3
            , ATX ,
            , Z00 ,мас4
            , ATX ,
            , Z00 ,мас4
            , ATX ,
            , Z00 ,мас4
            , ATX ,
            , Z00 ,мас4
            , ATX ,1
            , Z00 ,мас1
 gvmas1k  :  , ATX ,3
            , Z00 ,мас1
 мас1  :  , LOG ,3670 5231 1463 1756
            , OCT ,7256 676
 мас2  :  , LOG ,3670 5236 6722 0456
            , OCT ,74
 мас3  :  , OCT ,3670 5236 74
 мас4  :  , OCT ,3670 5237
            , DATA,
 д9  :  , INT ,9
           1, SET ,д9
           1,     ,*IOXLSW*
            , END ,
