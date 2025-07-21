 IOXXSFW*:  , NAME,
с*
с*** Программа "Mонитор-80" ИAЭ
с*** Скорее всего для фортрана
с*
 *ICHECK*:  , LC  ,6
 A/I0    :  , LC  ,1
 SAVELEXX:  , SUBP,
 GIVELEXX:  , SUBP,
 SETWLEXX:  , SUBP,
 GAL/3   :  , EQU ,*ICHECK*+1
 *1      :  ,BLOCK,M1,M2,M3,M4,M5,M6,M7,M8,M9
            , CONT,M10,M11,M12,M13,M14,M15
c
            , UTC ,1
C======================================
 IOXXSFR*:  ,ENTRY,
C======================================
 *0001B:M12,VTM,
 :M13,MTJ,M8
         M14, VTM ,-8
 *0003B:M14,ITS,M9
         M14, VLM ,*0003B
         M15, WTC ,-12
          M1, VTM ,
         M15, WTC ,-11
          M4, VTM ,
         M15, WTC ,-10
          M5, VTM ,
         M12, MTJ ,M7
         M15, WTC ,-9
         M12, VTM ,
          M2, VTM ,*0001B
          M1, WTC ,6
          M3, VTM ,
          M8, VTM ,GAL/3
          M1, WTC ,10B
          M6, VTM ,
            , NTR ,3
         M14, VTM ,-5
 *0015B:M12,XTA,
          M2, UTC ,136B
         M14, AEX ,
         M14, UZA ,*0035B
         M14, VLM ,*0015B
         M14, VTM ,26B
 *0020B  :  , ITA ,M14
          M1, ATX ,3
 *0021B  :M1, XTA ,10B
            , AOX ,A/I0
          M8, STX ,
         M14, VTM ,-7
         M12, VTM ,10B
 *0024B:M12,STI,
         M12, UTM ,-1
         M14, VLM ,*0024B
            , NTR ,6
         M15, UTM ,-3
            , STX ,
          M8, UJ  ,
         :  , UJ  ,*0036B
         :  , UJ  ,*0044B
         :  , UJ  ,*0113B
         :  , UJ  ,*0060B
         :  , UJ  ,*0062B
 *0035B  :  , UJ  ,*0101B
 *0036B  :M3, VTM ,
          M6, VTM ,
            , XTA ,A/I0
          M8, ATX ,4
 *0040B:M13,VJM,*0124B
 *0041B:M14,VTM,
 *0042B  :  , ITA ,M3
          M1, ATX ,6
            , UJ  ,*0020B
 *0044B  :M1, XTA ,16B
            , UZA ,*0050B
          M6, VZM ,*0036B
          M3, UTM ,76000B
          M3, VZM ,*0041B
          M3, UTM ,2000B
          M6, UTM ,-1
            , UJ  ,*0040B
 *0050B  :  , ITA ,M3
            , ITS ,M6
            , ASN ,64-10
         M15, ARX ,
            , AOX ,A/I0
          M8, XTS ,4
            , AOX ,A/I0
         M15, X-A ,
            , U1A ,*0036B
            , ASN ,64+10
            , ATI ,M6
            , YTA ,
            , ASN ,64+38
            , ATI ,M3
            , UJ  ,*0040B
 *0060B  :  , XTA ,A/I0
          M8, ATX ,4
            , UJ  ,*0041B
 *0062B  :M3, UTM ,76000B
          M3, V1M ,*0064B
 *0063B  :M3, VTM ,76000B
          M6, UTM ,1
 *0064B:M13,VJM,*0116B
            , WTC ,43B
          M3, UTC ,2000B
         M14, VTM ,
 *0067B  :M7, V1M ,*0071B
         M14, XTA ,
          M4, ATX ,
            , UJ  ,*0072B
 *0071B  :M4, XTA ,
         M14, ATX ,
 *0072B  :M3, UTM ,2001B
          M8, XTA ,4
          M2, ARX ,137B
          M8, ATX ,4
         M14, UTM ,1
            , ITA ,M4
            , ITS ,M5
         M15, AEX ,
            , UZA ,*0041B
          M4, UTM ,1
          M3, UTM ,76000B
          M3, VZM ,*0063B
            , UJ  ,*0067B
 *0101B  :M1, XTA ,16B
            , U1A ,*0111B
            , ITA ,M3
          M8, ARX ,4
            , ATI ,M14
         M14, VZM ,*0041B
         M14, UTM ,-1
            , ITA ,M14
            , ASN ,64+10
 *0106B  :M1, ARX ,10B
          M1, ARX ,7
          M1, X-A ,11B
            , UZA ,*0041B
         M14, VTM ,3
            , UJ  ,*0042B
 *0111B  :M3, VTM ,2000B
          M2, XTA ,137B
            , UJ  ,*0106B
 *0113B:M13,VJM,*0124B
            , ITS ,M1
         M13, VJM ,SAVELEXX
            , UJ  ,*0021B
 *0116B  :M1, XTA ,16B
            , UZA ,*0124B
          M8, XTA ,4
            , AEX ,A/I0
            , UZA ,*0124B
            , ITA ,M6
          M1, AEX ,10B
            , UZA ,*0124B
         M14, VTM ,32B
          M7, V1M ,*0042B
         M14, VTM ,22B
            , UJ  ,*0020B
 *0124B  :  , ITA ,M13
            , ITS ,M6
         M15, MTJ ,M14
            , ITS ,M14
            , ITS ,M1
         M13, VJM ,GIVELEXX
            , STX ,
            , ATI ,M13
         M13, UTC ,
          M7, VZM ,
            , ITS ,M1
            , Z31 ,SETWLEXX
            , ISO ,24HRWN   BSP   EOF   REC
            , ISO ,12HADD   END
            , LOG ,1
            , END ,
