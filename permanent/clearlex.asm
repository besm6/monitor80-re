 CLEARLEX:  , NAME,
c
с программа "Mонитор-80" ИAЭ
с
  RFMRTFLG:  , LC  ,1
  *1      :  ,BLOCК,M1,M2,M3,M4,M5,M6,M7,M8,M9
             , CONT,M10,M11,M12,M13,M14,M15
  clearlx:M14,VTM,clearlx
             , XTA ,RFMRTFLG
          M14, AAX ,7
             , U1A ,clearl1x
             , XTA ,43B
             , ASN ,64-20
             , AOX ,RFMRTFLG
          M14, ARX ,11B
             , LOG ,7400 0001 7470 0001
  clearl1x:M14,VTM,clearlx
          M14, XTA ,10B
             , ATX ,RFMRTFLG
          M13, UJ  ,
             , OCT ,001
             , OCT ,0010 0000 0071
             , LOG ,7 0000
             , END ,
