 INPUTCAL:,NAME,.
C
C******   ГOЛOBHAЯ ПPOГPAMMA
C         MOHИTOPHOЙ ЗAДAЧИ BBOДA
C
C......   CBЯЗKИ C MOHИTOPOM
C......   OCHOBHЫE ИHФOPM.БЛOKИ
 *D02051*:,LC,1
 *CARDS:LC,BLOCK,
 ,CONT,(109)
 *CODES:LC,BLOCK,
 ,CONT,(5)
 *SPC CMN:LC,BLOCK,
 ,CONT,(3)
 *ADRPROC:LC,BLOCK,
 ,CONT,PROC R,PROC W
 *D02241*:,LC,3
 *ERRORS:LC,BLOCK,
 ,CONT,FL BLER
 ,CONT,(2)
 ,CONT,*ER/TEX,(1)
 ,CONT,*ER/BIN
 ,CONT,*ER/CM,*ER/COS
 T/NAM:,LC,5
C......   ЭKOHOMИЯ ПAMЯTИ
 TAKECRD*:,SUBP,.
 INITTAKE:,SUBP,
 //GOSISO:,SUBP,
 TABLE:,SUBP,
 INPUT*:,SUBP,
  ERROFLG*:LC,BLOCK,FLGEX*
C........
C......   YCTAHOBKA CTAHД.PEЖИMA
C         ДЛЯ INPUT* (ЧTEHИE,ЗAПИCЬ)
 ,ITA,13
 ,UTC,WS
 ,ATX,
 ,XTA,.ЧTEHИE KAPTЫ
 ,ATX,PROC R.ПO ЭKCTPAKOДY
  ,XTA,73B
 ,ASN,64+28
 ,UTC,=3
 ,AAX,
 ,UTC,*D02051*
 ,ATX,
 ,ASN,64-28
 ,AEX,73B
 ,ATX,73B
 ,UZA,INP
 14,VTM,IVSIAE
 *0010B:14,XTS,
 ,CALL,LOADANGO
 INP:,BSS,.
 14,VTM,TAKECRD*. AДPEC
 ,ITA,14.ПPOЦEДYPЫ
 ,ATX,PROC W.ЗAПИCИ KAPTЫ
 ,CALL,INITTAKE.EE HACTPOЙKA
 ,CALL,INPUT*.**  BBOД ЗAДAЧИ
 1,VTM,ФАТOШ.
 ,XTA,*ER/BIN.OШИБKИ BINARY
 ,AOX,*ER/CM.ИЛИ OШИБ.CM
 ,UIA,ER PRI. - ФAT.OШИБKИ
 ,XTA,*ER/COS.OШИБKИ COSY
 ,UZA,MON RET.
 ,XTA,FL BLER.ЗAБЛOKИPOBAHЫ
 ,UZA,ER PRI. - HET
  1,VTM,БЛОШ
 ,UTC,=1
 ,XTA,
 ,ATX,ERROFLG*
 ER PRI:,BSS,.
C......   ИTOГOBAЯ ДИAГHOCTИKA ПO BBOДY
 ,ITS,1.
 1,UTM,4.ИTOГOBAЯ
 ,ITS,1.ДИAГHOCTИKA
 14,VTM,5.
 ,ITS,14.
 ,CALL,LUN*MON....
 1,UTM,-ФATOШ-4.ФATAЛ.ДИAГHOCT.
 1,VIM,MON RET. - HET
 14,VTM,T/NAM.
 ,ITS,14.ПEЧATЬ NAME
 14,UTM,4.
 ,ITS,14.
 ,XTS,.
 ,CALL,LUN*MON....
 14,VTM,1
 ,XTA,73B
 ,U1A,*0040B
 ,SJ,
 MON RET:,BSS,.
 14,VTM,
 ,XTA,73B
 ,U1A,*0040B
 ,UTC,*D02051*
 ,XTA,
 ,ASN,64-28
 ,ATX,73B
 ,WTC,WS
 ,UJ,
C
 *0040B:,ITS,14
 ,WTC,*D02241*+2
 13,VJM,
 ,UJ,*0010B
 IVSIAE:,TEXT,8H*/IVSIAE
 ФATOШ:,BSS,.
 ,ISO,30HБЫЛИ OШИБKИ B CM/COSY MACCИBAX
 БЛ OШ:,BSS,.
 ,ISO,14HБЫЛИ OШИБKИ ,
 ,CONT,13HHO БЛOKИPOBKA
 WS:,BSS,1.
 ,DATA,.
 TNAMD:,ISO,5H
 ,CONT,20H( NAME OTCYTCTBYET )
 :5,SET,TNAMD.
 1,,T/NAM.
 ,END,.
