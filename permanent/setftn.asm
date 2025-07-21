 SETFTN  :  , NAME,
 FLAGS   :  , LС  ,1
 MONСARD*:  , LС  ,25
 PRINT8  :  , SUBP,
 *1      :  ,BLOСК,M1,M2,M3,M4,M5,M6,M7,M8,M9
            , СONT,M10,M11,M12,M13,M14,M15
c
 *0000B  :  , NTR ,3
         M14, VTM ,-9
 *0001B:M14,ITS,M13
         M14, VLM ,*0001B
          M4, VTM ,*0000B
          M4, XTS ,165B
         M15, MTJ ,M7
         M15, UTM ,23B
          M7, ATX ,
            , XTA ,
          M7, ATX ,1
          M7, ATX ,2
         M10, VTM ,
         M11, VTM ,50B
          M7, MTJ ,M13
         M13, UTM ,4
          M4, XTA ,163B
         M14, VTM ,-13
 *0011B:M13,ATX,
         M13, UTM ,1
         M14, VLM ,*0011B
         M14, VTM ,-29
          M4, XTA ,151B
         M14, ASN ,64+1
          M4, ATX ,150B
 *0015B:M13,VJM,*0061B
            , UZA ,*0124B
 *0017B:M13,VJM,*0101B
            , UZA ,*0015B
         M15, ATX ,
         M14, VTM ,-30
 *0022B  :M4, UTС ,224B
         M14, XTA ,
         M15, AEX ,-1
            , UZA ,*0050B
         M14, VLM ,*0022B
          M8, VZM ,*0124B
          M9, UTM ,1
            , ITA ,M9
         M15, ATX ,-1
         M13, VJM ,*0061B
            , ITA ,M9
         M15, X-A ,-1
            , STI ,M14
         M14, UTM ,1
         M13, VTM ,4
            , ITS ,M13
            , ITS ,M7
         M15, ARX ,
          M4, A*X ,156B
            , УTA ,100B
         M15, ARX ,
          M7, ATX ,3
 *0035B  :M4, A*X ,160B
            , ATI ,M5
            , УTA ,100B
          M4, A*X ,157B
            , ATI ,M6
          M4, XTA ,161B
          M6, ASN ,64
          M5, AEX ,
          M5, ATX ,
          M7, XTA ,3
          M4, ARX ,151B
          M7, ATX ,3
         M14, VLM ,*0035B
          M4, XTA ,147B
          M7, ATX ,2
          M7, XTA ,
          M4, AEX ,165B
            , UZA ,*0047B
          M4, AEX ,165B
 *0047B  :M7, ATX ,
            , UJ  ,*0015B
 *0050B:M15,UTM,-1
         M14, UTM ,36B
            , ITA ,M14
          M4, A-X ,146B
            , UZA ,*0017B
          M7, XTA ,1
            , U1A ,*0056B
          M4, XTA ,147B
          M7, ATX ,1
            , XTA ,
          M7, ATX ,
 *0056B  :M4, XTA ,150B
         M14, ASN ,64
          M7, AOX ,
          M7, ATX ,
         M13, VTM ,*0017B
 *0061B:M10,XTA,MONСARD*
         M11, ASN ,64
          M4, AAX ,155B
            , ATI ,M12
          M4, AEX ,162B
            , UZA ,*0072B
            , ITA ,M10
          M4, A*X ,156B
            , УTA ,100B
            , ITS ,M11
            , ASN ,64+3
          M4, X-A ,152B
         M15, ARX ,
            , ATI ,M9
          M4, XTA ,147B
         M12, ASN ,64-32
          M4, AAX ,164B
         M13, U1A ,
 *0072B  :M8, VJM ,*0074B
         M13, UZA ,
            , UJ  ,*0061B
 *0074B:M11,V1M,*0077B
            , ITA ,M10
          M4, A-X ,153B
          M8, UZA ,
         M11, VTM ,60B
         M10, UTM ,1
 *0077B:M11,UTM,-8
          M4, XTA ,147B
          M8, UJ  ,
 *0101B  :  , XTA ,
          M7, ATX ,22B
         M14, VTM ,-4
 *0103B  :M8, VJM ,*0074B
            , UZA ,*0122B
         M10, XTA ,MONСARD*
         M11, ASN ,64
          M4, AAX ,155B
          M4, AEX ,162B
            , UZA ,*0103B
          M4, AEX ,162B
          M7, XTS ,22B
            , ASN ,64-8
         M15, AOX ,-1
          M7, STX ,22B
            , ATI ,M12
         M12, UTM ,-10
         M12, VZM ,*0117B
          M4, XTA ,147B
         M12, ASN ,64-22
          M4, AAX ,164B
            , U1A ,*0120B
         M14, VLM ,*0103B
          M7, XTA ,22B
         M13, UJ  ,
 *0117B  :M8, VTM ,
 *0120B  :M7, XTA ,22B
            , ASN ,64+8
         M13, UJ  ,
 *0122B  :M8, VTM ,
          M7, XTA ,22B
         M13, UJ  ,
 *0124B  :M7, XTA ,1
          M4, AEX ,147B
          M7, AAX ,2
            , U1A ,*0136B
            , XTA ,FLAGS
          M7, AOX ,
          M7, XTS ,-11
            , U1A ,*0134B
         M15, XTA ,-1
          M7, AEX ,
         M15, ATX ,-1
          M7, XTA ,1
            , U1A ,*0134B
          M4, XTA ,154B
         M15, AOX ,-1
         M15, ATX ,-1
 *0134B  :  , STX ,
            , ATX ,FLAGS
          M7, XTA ,2
            , UZA ,*0142B
 *0136B:M14,VTM,4
          M7, J+M ,M14
            , ITS ,M14
         M14, UTM ,15B
            , ITS ,M14
            , XTS ,
         M13, VJM ,PRINT8
 *0142B  :  , NTR ,6
          M7, MTJ ,M15
         M15, XTA ,
         M14, VTM ,12B
 *0144B:M14,UTM,-1
         M14, STI ,M4
         M14, V1M ,*0144B
         M13, UJ  ,
C***   PAЗPЯДЫ  *REGIM//   ***
            , ATX ,
            , ATX ,35B
            , OСT ,4
            , LOG ,
            , LOG ,1
            , LOG ,5
            , LOG ,13
            , LOG ,120
            , LOG ,377
            , LOG ,4000 0000 0000 0006
            , OСT ,4000 0000 0000 006
            , LOG ,4002 5252 5252 5253
            , OСT ,024
            , LOG ,40
            , ISO ,6Н
            , OСT ,1135 7400 174
            , LOG ,5 7720
            , ISO ,6Н’’’’’’ONE
            , ISO ,6Н’’’’’’OLD
            , ISO ,6Н’’DEBUG
            , ISO ,6Н’’ADRES
            , ISO ,6Н’’STRUС
            , LOG ,
            , LOG ,
            , LOG ,
            , LOG ,
            , LOG ,
            , LOG ,
            , LOG ,
           , LOG ,
           , LOG ,
C***      PAЗPЯДЫ  FLAGS    ***
            , ISO ,6Н’’DLIST  .15р.
            , ISO ,6Н’’EIGНT
            , ISO ,6Н’’REPLA
            , ISO ,6Н’’’’СALL
            , ISO ,6Н’’LABEL
            , ISO ,6Н’’СOMPU
            , ISO ,6Н’’INDEX
            , ISO ,6Н’’СONDI
            , ISO ,6Н’’OPTIM
            , ISO ,6Н’’PUNСН
            , ISO ,6Н’’BINAR
            , ISO ,6Н’’ASSEM
            , ISO ,6Н’’FULLL
            , ISO ,6Н’’STAND
            , ISO ,6Н’’NOLIS  .1р. - в МС. У нас видимо по другому
            , ISO ,6Н’’PRINT
            , ISO ,6Н’’TRAСE  .1р.?
            , END ,
