 PT8READ :  , NAME,
с*
с*** Программа "Mонитор-80" ИAЭ
с*** Скорее всего для фортрана
с*
 SAVE*HID:  , SUBP,
 PLCLO   :  , SUBP,
 ASAVE*  :  , SUBP,
 EOF*59  :  , LC  ,1
 PLBEG   :  , SUBP,
 MONITOR*:  , SUBP,
 GAL/5   :  , EQU ,MONITOR*-1
 LUN*MON :  , SUBP,
 STOP*   :  , SUBP,
 RFMRTFLG:  , LC  ,1
 A/I0    :  , LC  ,1
 IOSKIP* :  , LC  ,1
 CLEARLEX:  , SUBP,
 *1      :  ,BLOCK,M1,M2,M3,M4,M5,M6,M7,M8,M9
            , CONT,M10,M11,M12,M13,M14,M15
            , ITS ,
            , ITS ,
C======================================
 IOXXPTRT:  ,ENTRY,
C======================================
            , ITS ,M14
         M14, VJM ,SAVE*HID
            , ITA ,M3
            , UTC ,*0035B
            , XTS ,
            , STI ,M5
            , ATI ,M8
            , ATI ,M9
            , UTC ,*0034B
            , XTA ,
            , ATI ,M3
          M4, VTM ,77561B
 *0007B:M13,VJM,*0036B
            , ASN ,64-41
            , ASN ,64+41
            , ATI ,M6
            , WTC ,EOF*59
         M14, VTM ,
         M14, V1M ,*0021B
          M6, VZM ,*0007B
          M6, UTM ,-10
          M6, VZM ,*0021B
          M6, UTM ,-3
          M6, VZM ,*0007B
          M6, UTM ,-114
          M6, VZM ,*0007B
          M6, VZM ,*0021B
         M13, VJM ,PLCLO
          M4, VLM ,*0007B
          M4, UTM ,1
 *0021B  :  , ITA ,M5
            , ITS ,M3
            , UTC ,*0034B
            , STX ,
            , UTC ,*0035B
            , ATX ,
          M4, UTM ,-1
 *0025B  :M7, VTM ,40B
            , ITA ,M7
         M13, VTM ,*0025B
          M4, VLM ,PLCLO
         M15, WTC ,-18
         M14, VTM ,
         M14, VZM ,*0032B
            , UTC ,EOF*59
            , XTA ,
         M14, ATX ,3
 *0032B:M13,VTM,ASAVE*
          M7, VTM ,12B
            , ITA ,M7
            , UJ  ,PLCLO
 *0034B  :  , BSS ,1
 *0035B  :  , BSS ,1
C======================================
 B/SU/   :  ,ENTRY,
C======================================
 *0036B  :M7, VTM ,*0036B
            , XTA ,GAL/5
            , ASN ,64-8
            , ASN ,64+32
            , U1A ,*0044B
         M14, VTM ,*0102B  .=6H*END F
            , ITS ,M14
         M14, UTM ,1
            , ITS ,M14
            , XTS ,
         M13, VTM ,STOP*
            , UJ  ,LUN*MON
 *0044B  :  , XTA ,GAL/5
          M7, AAX ,52B
            , UZA ,*0062B
          M5, V1M ,*0061B
            , XTA ,GAL/5
            , ASN ,64-32
            , ASN ,64+32
            , XTS ,GAL/5
            , ASN ,64-8
            , ASN ,64+32
         M15, AEX ,
            , U1A ,*0056B
            , ATX ,GAL/5
          M7, XTA ,50B
            , UTC ,EOF*59
            , ATX ,
            , UTC ,IOSKIP*
            , ATX ,
          M3, VTM ,1
         M13, UJ  ,
 *0056B  :  , XTA ,GAL/5
          M7, ARX ,51B
            , ATX ,GAL/5
            , ASN ,64-14
            , ASN ,64+38
            , UZA ,*0062B
 *0061B:M12,VTM,*0076B
            , UJ  ,*0063B
 *0062B:M12,VTM,*0067B
 *0063B  :  , XTA ,RFMRTFLG
          M7, AEX ,46B
         M12, UZA ,
         M13, MTJ ,M12
         M13, VJM ,CLEARLEX
         M12, MTJ ,M13
 *0067B  :  , XTA ,GAL/5
          M7, AOX ,52B
            , ATX ,GAL/5
            , ASN ,64-8
          M7, AUX ,46B
          M7, ARX ,47B
            , XTS ,43B
            , ASN ,64-20
         M15, AOX ,
         M15, ATX ,
         M15, UTM ,-1
         M15, *70 ,
          M7, XTA ,46B
            , ATX ,RFMRTFLG
 *0076B  :M5, V1M ,PLBEG
            , XTA ,GAL/5
            , ASN ,64-14
            , ASN ,64+38
            , ARX ,43B
            , ATI ,M3
            , UJ  ,PLBEG
 *0102B  :  , ISO ,12H*END FILE 59
            , LOG ,1 0037
            , OCT ,0010 0000 0001
            , LOG ,3
            , OCT ,0000 0001
            , OCT ,4
            , END ,
