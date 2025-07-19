 INPUT*:,NAME,.
C--------
 '
C******   YПPABЛЯЮЩAЯ ПPOГPAMMA
C         MOHИTOPHOЙ ЗAДAЧИ BBOДA
 '
C......   OCYЩECTBЛЯET :
C         BBOД , KOДИPOBKY , ЗAПИCЬ PEЗ-TA
 '
C......   AДPEЦA ПPOЦEДYP ЧTEHИЯ , ЗAПИCИ
 *ADRPROC:LC,BLOCK,PROC R,PROC W
C......   PAЗHЫE MACCИBЫ - KAPTЫ
 *CARDS:LC,BLOCK,
  ,CONT,INC(44)
  ,CONT,OUTC(65)
C......   ИCПOЛЬЗYEMЫE ЯBHO П/П
 INITCODE:,SUBP,.
 DECODER:,SUBP,.
C......   ИCПOЛЬЗYEMЫE ИP :
 *1:,BLOCK,B
C--------
  BEG:,BSS,
 ,ITA,13.
 ,ATX,I13.HACTPOЙKA
 ,CALL,INITCODE.KOДИPOBЩИKA
 READ:,BSS,.
C......   ЧTEHИE KAPTЫ
 ,XTA,PROC R.
 ,UZA,MAC 60.- ПO ЭKCTPAKOДY
 ,WTC,PROC R.
 13,VJM,.- ЧEPEЗ ПPOЦEД.
 ,AEX,BL COD.OБPAЗ KAPTЫ
 ,UIA,CODE. - ДA
 13,VTM,READ.BOЗBP.ИЗ ЗAПИCИ
 WRITE:,BSS,.
C......   ЗAПИCЬ KAPTЫ , CБPOC
 ,WTC,PROC W.HA COOTB.
 ,UJ,.ПPOЦEДYPY
 MAC 60:,*60,INC.
 ,000,.
 CODE:,XTA,RET SW.HA KOДИPOBKY
 ,CALL,DECODER.BOЗBPAT-ПEPEKЛ.
C......   TИП 0
 :13,VTM,END DECK.ДОСБРОС
  ,UJ,WRITE
C......   TИП 1
 :13,VTM,CODE.ПK HE HAДO
 ,UJ,WRITE.PEЗ-T ECTЬ
C......   TИП 2
 :,,.HET PEЗ-TA
 ,UJ,READ.ПK HAДO
C......   TИП 3
 :13,VTM,READ.ПK HAДO
 ,UJ,WRITE.PEЗ-T ECTЬ
  13,VTM,*+1
  ,UJ,WRITE
 :14,VTM,
 ,UJ,CODE+1
 END DECK:,BSS,.
C......   BBEЛИ KOЛOДY - BOЗBPAT
 ,XTA,PROC R.CARD-READER
 ,UIA,RET. - NO
 :,*60,.CARD-READER
 ,000,. REFUSE
 RET:,BSS,.
 ,WTC,I13.
 ,UJ,.
C-------------
 BL COD:,ISO,6HISCODE
 RET SW:,ISO,6HRETSWI
 I13:,BSS,1.
 ,END,
