 SAVELIST:,NAME,.CПACEHИE ЛИCTOB
  ,AAX,=76 000 .ДBИГAЯCЬ
  ,ASN,64-20   .OT TPAKTA 37
  ,ATX, LST    .HAЗAД
  ,XTA,E70.
  ,U1A,C1.
 ,XTA,=20 0037. в Дубне 02 0037
  ,ATX,E70.
 C1:,STX,.
  ,ITS,1.
  1,VTM,LISTS.
  ,XTS,.
 C2:1,XTA,.
  ,UZA,C3.
  ,AEX,LST.
  ,AAX,=:0000 37.
  ,UZA,RET.
  1,VLM,C2.
 C3:,XTA,LST.ЗAПИCЬ ЛИCTA
  ,AOX,E70.
 1,ATX,
  1,*70,.
  1,UTM,1.
  ,XTA,.
  1,ATX,.
 ,XTA,E70.
 ,ARX,=37 .-1
 ,AAX,=77 0037.
 ,ATX,E70.
 1,XTA,-1.
 ,AOX,=:001.CЛOBO ЗAПИCИ
 1,ATX,-1.
 RET:,STX,.
 ,STI,1.
 13,UJ,.
 TSILEVAS:,ENTRY,.
 ,ITS,1.
 ,XTS,.
 1,VTM,LISTS.
 C4:1,XTA,.
 ,UZA,C5.
 1,*70,.
 1,VLM,C4.
 C5:,XTA,.
 ,ATX,E70.
 ,ATX,LISTS.
 ,UJ,RET.
 LISTS:,OCT,.
 ,BSS,20.
 E70:,OCT,.
 LST:,BSS,1.
 ,END,
