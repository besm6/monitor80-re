 NEWPLACE:,NAME,DTRAN  /01.06.84/
 *MONCRD*:,LC,12
 MIST10*:,LC,3
 GAK/3:,EQU,MIST10*+1
 GAK/4:,EQU,MIST10*+2
 PAGE:,PC,2048
 *1:,BLOCK,B,I,MAGIC,R,M5,POS,LOC,M8,APAR,MODE,M11,M12,M13,M14
 *0000B:B,BASE,*
 ,ITA,M13
 ,XTS,
 R,VTM,RET
 POS,VTM,-24
 LOC,VTM,4
 M14,VTM,-11
 *0004B:,UTC,*0143B.=6H
 M14,ATX,
 M14,VLM,*0004B
 MODE,VTM,
 ,CALL,PARAMT*
 MODE,VTM,1
 APAR,VTM,ARG1
 ,CALL,PARAMT*
 M14,V1M,RET
 R,VJM,WORK
 ,XTA,*MONCRD*
 ,ATX,*0123B
 ,XTA,ARG1
 ,ATX,VOLUME
 MAGIC,VTM,71717B
 ,*50,1206B
 M5,VTM,*0121B.=6HHE YCT
 M8,VTM,2
 ,UZA,MSG
 MODE,VTM,5
 APAR,VTM,ARG2
 ,CALL,PARAMT*
 M14,V1M,RET
 ,ASN,64-24
 ,AOX,RESULT
 ,AOX,*0156B.=:6201 0006
 M14,VTM,PAGE
 ,ITS,M14
 ,ASN,64-8
 15,AOX,
 ,ATX,INFWORD
 ,*72,INFWORD
 LOOP:MODE,VTM,5
 APAR,VTM,ARG3
 ,CALL,PARAMT*
 ,XTA,*MONCRD*
 ,ASN,64+32
 ,ATX,*0201B
 M11,VZM,WRITE
 M14,V1M,RET
 MODE,VTM,1
 APAR,VTM,ARG1
 ,CALL,PARAMT*
 M11,VZM,WRITE
 M14,V1M,WRITE
 R,VJM,WORK
 APAR,VTM,ARGN
 MODE,VTM,5
 ,CALL,PARAMT*
 M11,VZM,WRITE
 M14,V1M,WRITE
 ,XTA,ARGN
 ,ASN,64-30
 ,XTS,ARG1
 ,ASN,64-12
 15,AOX,
 ,AOX,RESULT
 ,WTC,ARG3
 ,UTC,PAGE
 ,ATX,1750B
 ,XTA,*0201B
 R,VJM,PUT3SYM
 MODE,VTM,1
 ,CALL,PARAMT*
 M14,V1M,WRITE
 M11,V1M,LOOP
 WRITE:,XTA,INFWORD
 ,AEX,E37
 ,ATX,INFWORD
 ,XTA,VOLUME
 ,*50,115B
 ,*72,INFWORD
 ,XTA,VOLUME
 ,*50,116B
 ,XTA,INFWORD
 ,AEX,E37
 ,ARX,E19
 ,ATX,INFWORD
 ,*72,INFWORD
 M14,VTM,76001B
 VERIFY:,UTC,PAGE
 M14,XTA,1777B
 ,UTC,PAGE
 M14,AEX,3777B
 ,U1A,NOMONSYS
 M14,VLM,VERIFY
 M5,VTM,*0124B.=6HOПPEДE
 M8,VTM,16B
 R,VJM,MSG
 RET:15,WTC,
 ,UJ,
 WORK:,XTA,GAK/4
 ,ASN,64-2
 ,AEX,*0167B.=7 7777
 ,ATI,M12
 ,XTA,*MONCRD*
 ,APX,MASK
 M12,ASN,64+49
 ,ATX,ARG1
 ,ASN,64-24
 ,ATX,VALUE
 I,VTM,-5
 ,XTA,
 *0075B:,A*X,TEN
 ,ATX,RESULT
 ,XTA,VALUE
 ,ASN,64-4
 ,ATX,VALUE
 ,YTA,
 ,AOX,INT0
 ,A+X,RESULT
 ,ATX,RESULT
 I,VLM,*0075B
 ,NTR,3
 ,A+X,INT0
 ,NTR,6
 ,AAX,E12TO1
 ,ATX,RESULT
 R,UJ,
 NOMONSYS:M8,VTM,11B
 M5,VTM,*0144B.=6HПOBTOP
 R,VTM,RET
 ,UJ,MSG
 MSG:,ITS,M5
 M5,J+M,M8
 ,ITS,M8
 ,XTS,E1
 ,CALL,PRINT8
 R,UJ,
 PUT3SYM:,AOX,COMMA
 POS,ASN,64
 ,UTC,*0124B.=6HOПPEДE
 LOC,AOX,
 ,UTC,*0124B.=6HOПPEДE
 LOC,ATX,
 POS,UTM,30B
 R,UTC,
 POS,VZM,
 LOC,UTM,1
 POS,VTM,-24
 R,UJ,
 *0121B:,ISO,12HHE YCT. БOБ
 *0123B:,ISO,6H
 *0124B:,ISO,90HOПPEДEЛEHO ПOЛ. LIBRARY:
 *0143B:,ISO,6H
 *0144B:,ISO,24HПOBTOPИ CHOBA, ЛYЧШE C Д
 ,ISO,24HP. N БOБИHЫ, ГДE ЗAПИCAH
 ,ISO,12HA MOH. CИCT.
 *0156B:,OCT,6201 0006
 E19:,LOG,100 0000
 COMMA:,ISO,6H′′′′′′,′′′′
 E12TO1:,LOG,7777
 E1:,LOG,1
 MASK:,GOST,6H
 E37:,OCT,0001
 TEN:,REAL,1.E01
 INT0:,INT,0
 *0167B:,LOG,7 7777
 ARG3:,BSS,1
 ARG1:,BSS,1
 RESULT:,BSS,2
 INFWORD:,BSS,1
 ARGN:,BSS,1
 VALUE:,BSS,1
 ARG2:,BSS,1
 VOLUME:,BSS,1
 *0201B:,BSS,1
 ,END,
