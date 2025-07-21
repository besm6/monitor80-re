 DRUMTAP*:  , NAME,
c
с cтандартная программ MС Дубна
с Pазличия в сдвигах по адресам
с при работе с BЗУ
c
 CHKWORD*:  , LC  ,1
 PRINT8  :  , SUBP,
 STOP*   :  , SUBP,
 *1      :  ,BLOCK,M1,M2,M3,M4,M5,M6,M7,M8,M9
            , CONT,M10,M11,M12,M13,M14,M15
c
        M14,base,*
c drmtp:M14,VTM,drmtp
         M14, ARX ,22B
         M15, ATX ,
            , ASN ,64-30
         M14, ARX ,24B
            , U1A ,NOML
 RET:M15,XTA,
         M13, UJ  ,
 NOML:M15,XTA,-1
         M14, AAX ,23B
            , UZA ,RET
         M15, XTA ,-1
         M14, ARX ,23B
         M15, ATX ,-1
         M14, AAX ,21B
            , U1A ,RET
         M15, XTA ,-1
            , UTC ,CHKWORD*
            , AEX ,
         M14, AAX ,25B
            , U1A ,RET
         M14, VTM ,TНETMEСTA  .=6H HET M
            , ITS ,M14
            , XTS ,
            , XTS ,
         M13, VTM ,STOP*
            , UJ  ,PRINT8
 TНETMEСTA  :  , ISO ,12H HET MECTA H
            , ISO ,6HA MБ’12’
            , OCT ,001
            , LOG ,100 0001
            , LOG ,7740
            , OCT ,1
            , LOG ,77 7777
            , END ,
