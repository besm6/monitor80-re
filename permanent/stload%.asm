 STLOAD* :  , NAME,
c
с программа "Mонитор-80" ИAЭ
с
   STCAT*  :  , LC  ,1
   INFLOAD*:  , LC  ,4
   *1      :  ,BLOCК,M1,M2,M3,M4,M5,M6,M7,M8,M9
              , CONT,M10,M11,M12,M13,M14,M15
c
           M14, VTM ,-12
   stlod:M14,ITA,M13
           M14, ATX ,135B
           M14, VLM ,stlod
              , RTE ,177B
              , ATX ,114B
              , NTR ,3
            M2, VTM ,1
              , CTX ,
              , WTC ,17B
            M5, VTM ,-8
              , XTA ,43B
              , ASN ,64-20
              , AOX ,77B
              , ATX ,146B
              , XTA ,STCAT*
              , ASN ,64+10
              , UZA ,stloa1d
              , *70 ,146B
   stloa1d  :  , WTC ,STCAT*
           M14, VTM ,
   stlo1ad:M14,XTA,
              , UZA ,s3tload
            M5, AEX ,
              , UZA ,st1load
   stl1oad:M14,UTM,2
              , UJ  ,stlo1ad
   st1load  :  , ITA ,M5
           M14, AEX ,1
              , AAX ,е15п1
              , U1A ,stl1oad
           M14, XTA ,1
              , ASN ,64+15
              , ATI ,M3
              , ASN ,64+15
           M15, ATX ,
              , AAX ,е5п1
              , ASN ,64-5
           M15, ATX ,
              , ARX ,43B
              , STX ,153B
              , ASN ,64-37
              , ARX ,153B
              , STX ,153B
              , ASN ,64+5
              , AAX ,е9п1
              , ARX ,146B
              , ATX ,145B
              , *70 ,145B
            M5, XTA ,3
              , ATX ,151B
            M5, XTA ,4
              , ATX ,152B
            M5, MTJ ,M6
   s1tload  :M3, VZM ,stl2oad
           M13, VJM ,st3load
           M15, ATX ,
              , ATI ,M9
              , ASN ,64+15
              , STI ,M10
              , AAX ,п4
              , UZA ,s2tload-1
           M13, VJM ,st3load
     :  , XTS ,
   s2tload  :M9, VZM ,st2load-1
           M13, VJM ,st3load
            M6, ATX ,
            M3, UTM ,-1
            M9, UTM ,-1
            M6, UTM ,1
              , UJ  ,s2tload
     :  , STX ,
   st2load:M10,VZM,s1tload
            M6, ATX ,
            M3, UTM ,-1
           M10, UTM ,-1
            M6, UTM ,1
              , UJ  ,st2load
   stl2oad  :  , XTA ,
            M6, ATX ,
              , ITA ,M5
              , ATX ,13B
              , ASN ,64-30
            M6, ATX ,7
              , XTA ,151B
            M5, ATX ,3
              , XTA ,152B
            M5, ATX ,4
            M5, XTA ,5
              , ATX ,16B
            M5, XTA ,6
              , ATX ,17B
            M5, XTA ,7
              , ATX ,15B
              , XTA ,44B
              , AAX ,п4
              , U1A ,stlo2ad
           M13, VJM ,s3tload-1
   stlo2ad  :  , XTR ,114B
              , CTX ,1
              , *70 ,45B
           M14, VTM ,-12
   stloa2d:M14,XTA,135B
           M14, ATI ,M13
           M14, VLM ,stloa2d
           M13, UJ  ,
            M2, VTM ,
   s3tload  :  , XTA ,INFLOAD*+3
              , ARX ,п1
              , ATX ,146B
              , *70 ,146B
              , WTC ,43B
            M7, VTM ,1200B
            M7, UTC ,
            M2, UJ  ,
   st3load  :  , WTC ,153B
              , XTA ,
              , XTS ,153B
              , ARX ,е47е1
              , ATX ,153B
              , UZA ,stl3oad
              , STX ,
           M13, UJ  ,
   stl3oad  :  , XTA ,145B
              , ARX ,п1
              , ATX ,145B
              , *70 ,145B
              , XTA ,43B
              , STX ,153B
           M13, UJ  ,
   е47е1  :  , LOG ,2 0000 0000 0001
   п1  :  , LOG ,1
   п4  :  , OCT ,4
   е15п1  :  , LOG ,7 7777
   е5п1  :  , LOG ,37
   е9п1  :  , LOG ,777
              , END ,
