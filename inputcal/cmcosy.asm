 CM/COSY:,NAME,.
C
C******   OБPAБOTKA KAPT
C         CTAHДAPTHOГO MACCИBA И COSY
C
 *CARDS:LC,BLOCK,INC(24),REVC(20)
 ,CONT,OUTC(25)
 ,CONT,(25)
 ,CONT,RESC(15)
 *CODES:LC,BLOCK,
 ,CONT,(2)
 ,CONT,FL COSY
 ,CONT,(1)
 *SPCCMN:LC,BLOCK,FL MID
 ,CONT,ДAЙ KA,HET PEЗ
 *ERRORS:LC,BLOCK,
 ,CONT,(1)
 ,CONT,FL ERR,(2)
 ,CONT,ER/KS,(1)
 ,CONT,*ER/CM,*ER/COS
 CHECKSUM:,SUBP,.
 TEXISO:,SUBP,.
 OUTC:I,BLOCK,ECOD,ENUM,ENAM(2)
 ,CONT,TИПOШ(4)
C---------
 C:,BSS,.
 ,ITS,13. ФЛAГИ :
 ,ATX,ДAЙ KA.'ДAЙ KAPTY'
C......   PACПAKOBKA 1 CЛOBA
 9,VTM,1-4.
 ,XTS,REVC.
 UN1:,ASN,64-12.
 ,ATX,HET PEЗ.'ECTЬ PEЗ-T'
 ,YTA,.
 9,UTC,MEND.
 ,ATX,.
 ,XTA,HET PEЗ.
 9,VLM,UN1.
C......
 9,VTM,REVC.
 ,ITA,9.
 ,CALL,CHECKSUM.
 8,BASE,C.
 13,VTM,TER1.TEKCT OШИБKИ
 ,UIA,ERR1.*OШ.K.CYM*
 ,XTA,FL MID. HAЧ.KAPTA
 ,UIA,NO BEG. - HET
 9,XTA,19.
 ,ATX,NAME.ИMЯ CM/COSY
 ,ATX,FL MID.
 ,XTA,T*.
 ,AEX,T/CM.
 ,ATX,FL COSY.
 12,VJM,PUT ER1.
 ,XTA,NC*.
 ,ATX,NC.
 ,UIA,ERR2.*HET П/K 0*
 ,XTA,FULWOR. ФЛAГ :
 ,ATX,HET PEЗ.'HET PEЗ-TA'
 ,UJ,COR NC.
 NO BEG:9,XTA,19.ИMЯ CM/COSY
 ,AEX,NAME.COBПAДAET
 ,UZA,CHEK NC. - ДA
 ,XTA,NC*. - HET
 ,UIA,ERR3.*ЧYЖAЯ ПK*
 ,UJ,ERR4.*HET KOHЦA*
 CHEK NC:,XTA,NC*.
 ,AEX,NC.
 ,UIA,ERR5.*OШ.HOMEP*
C......   ИCKЛЮЧEHИE ЛИШHИX KOЛOHOK
 10,VTM,1-16.PEЗ.-16 CЛOB
 11,VTM,1-4.ЦИKЛ 4 W-БAЙTA
 12,VTM,REVC.AДP.R - 1
 13,VTM,.ЦИKЛ 9 R-БAЙTOB
 14,VTM,.ЦИKЛ R-CЛOBO
 NEXT R:,XTA,R WOR. R-CЛOBO
 14,VLM,CH 9. - HE KOHEЦ
 14,VTM,1-4.
 12,UTM,1.AДP.R + 1
 12,XTA,.
 CH 9:13,VLM,RE 12.
 13,VTM,1-9.ЦИKЛ 9 R-БAЙTOB
 RE 12:,ASN,64-12.
 ,ATX,R WOR.OCTATOK R-CЛOBA
 ,YTA,.OЧEP.БAЙT
 13,VZM,NEXT R. - ИCKЛЮЧEHИE
 10,XTS,OUTC+16.
 ,ASN,64-12.ЗAПИCЬ БAЙTA
 15,AOX,.
 10,ATX,OUTC+16....
 11,VLM,NEXT R.HE KOHEЦ CЛ.
 11,VTM,1-4.
 10,VLM,NEXT R.
C......
 ,XTA,COD W1.
 ,ATX,OUTC.
 ,XTA,NC.
 COR NC:,ARX,B1.
 ,ATX,NC.
 ,XTA,NC*.OБXOД ПPOBEPKИ
 ,UZA,RET0.COSY ДЛЯ 0 ПK
 ,XTA,FL COSY.
 ,UIA,COSY*.
 ,XTA,M END.
 ,UIA,LAST CRD.
 RET0:,STX,
 ,UJ,RET1.
 COSY*:,BSS,.
C......   ИCXOДHAЯ KAPTA - COSY
 9,VTM,1-16.CПACEHИE
 SAV C:9,XTA,OUTC+16.COSY-KAPTЫ
 9,ATX,INC+15.
 9,VLM,SAV C....
 ,XTA,. ПPИЗHAK :
 ,ATX,ДAЙ KA.'HE HAДO BBOДA'
 ,XTA,CNTIN0.
 ,STX,CNTIN.
 ,STI,13.
 COSY*:,ENTRY,.
C******   BXOД : ДAЙ OЧEP.CTPOKY COSY
 8,BASE,C.
 ,ITS,13.
 ,XTS,CNTIN.CЧETЧИKИ ПO
 ,ATI,9.BBEД.KAPTE
 ,XTA,CNTRES.
 ,ATI,10.CTPOKE PEЗ-TA
 WORD:,BSS,.
C......   ПEPEПИCЬ COSY-CTPOKИ
C         BO BHYTPEHHИЙ БYФEP
 9,XTA,INC+15.KOHEЦ ИHФOP.
 10,ATX,RESC+13.HA KAPTE
 ,UZA,W/ZERO. - ДA
 9,XTA,INC+15.
 ,AAX,C377.COSY-CTPOKA
 ,AEX,S/NL.KOHЧИЛACЬ
 ,UZA,END LINE. - ДA
 10,VLM,STEP.
 STEP:9,VLM,WORD.KOHEЦ KAPTЫ
 ,UJ,CRD END. - ДA
 W/ZERO:,XTA,B1.
 ,UJ,CRD END.
 END LINE:,BSS,.
C......   BЫДAЧA COSY-CTPOKИ PEЗYЛЬTATA
 10,VTM,1-14.
 11,VTM,1-14.
 EL 1:11,XTA,RESC+13.
 11,ATX,OUTC+13.
 ,XTA,.
 11,ATX,RESC+13.
 11,VLM,EL 1.
 9,VLM,C RET.
 CRD END:,BSS,.
C......   KOHEЦ BXOДHOЙ KAPTЫ
 ,ATX,HET PEЗ.
 ,XTA,B1. ФЛAГ :
 ,ATX,ДAЙKA.'ДAЙ KAPTY'
 ,XTA,M END.KAPTA ПOCЛEД.
 ,UIA,LAST CRD. - ДA
 C RET:,BSS,.
 ,ITA,9.CПACEHИE
 ,ATX,CNTIN.CЧETЧИKOB
 ,ITA,10.
 ,STX,CNTRES....
 RET 1:,STI,13.
 13,UJ,.
 LAST CRD:,BSS,.
C......   HOPMAЛЬHЫЙ KOHEЦ CM/COSY
 ,XTA,.
 ,ATX,FL MID. ФЛAГ KOHЦA
 ,UJ,CLE RES.
 ERR STA*:,ENTRY,.
C
C******   BXOД ПO OШИБKE :
C         ПOШЛA HE CПEЦ-KAPTA
C         A CM/COSY HE KOHЧИЛCЯ
C
 8,BASE,C.
 ,ITS,13.
 ,XTS,ER/KS.
 ,UZA,ERR4.
 ,ATX,*ER/CM.
 ,XTA,.
 ,ATX,ER/KS.
 ,UJ,ERR4.
C
C------   PAЗHOOБPAЗHЫE OШИБKИ CM/COSY
C
 ERR1:,BSS,.
C......   HECOBПAДEHИE KC
 11,VTM,ERR OUT.
 ,XTA,FL MID.
 ,UIA,ERR GEN.HECOBП.KC
 ,XTA,B1.Y 0 KAPTЫ
 ,ATX,ER/KS.(ЗAПOMHИM)
 ,UJ,GEN1.
 ERR2:,BSS,.
C......   OTCYTCTBYET П/K 0
 13,VTM,TER2.TEKCT OШИБKИ
 ,UJ,TO BLMI.ГEHEP.TEKCTA
 ERR3:,BSS,.
C......   ЧYЖAЯ П/K
 14,VTM,REVC+19.ГEHEPAЦИЯ
 ,ITS,14.ЧYЖOГO
 14,VTM,TER3+2.ИMEHИ
 ,ITS,14.
 ,CALL,TEXISO....
 ,XTA,TER3+3.ДOФOPMИP.
 ,AEX,C52.CИMBOЛA 'NL'
 ,ATX,TER3+3.
 13,VTM,TER3.TEKCT OШИБKИ
 11,VTM,ERR OUT. BOЗBPAT
 ,UJ,ERR GEN.ГEHEPAЦИЯ TEKCTA
 ERR4:,BSS,.
C......   HET KOHЦA CM/COSY
 13,VTM,TER4.TEKCT OШИБKИ
 ,ATX,FL MID.ФЛAГ KOHЦA
 TO BLMI:11,VTM,BL MISS.BOЗBPAT
 ,UJ,ERR GEN.ГEHEPAЦИЯ TEKCTA
 ERR5:,BSS,.
C......   HEПPABИЛЬHЫЙ N П/K
 13,VTM,TER5.TEKCT OШИБKИ
 11,VJM,ERR GEN.ГEHEPAЦИЯ
 ,NTR,3.ПPИHИMAEM
 ,XTA,NC*. PEШEHИE :
 ,A-X,NC.
 ,UIA,ERR OUT.- BЫБPOC KAPTЫ
 ,XTA,NC*.
 ,ATX,NC.
 ,UJ,BL MISS.- OCTABИTЬ
C
C------   PAЗHЫE П/П ДИAГHOCTИK
C
 ERR GEN:,BSS,.
C......   ГEHEPAЦИЯ COOБЩ. OБ OШИБKE
 12,VTM,GEN1.
 ,UJ,PUT ER.
 PUT ER1:,BSS,.
C......   YCTAHOBKA ЗAПOMHEHHOЙ OШИБKИ 1
 ,XTA,ER/KS.
 12,UZA,.
 ,XTA,.
 ,ATX,ER/KS.
 PUT ER:14,VTM,*ER/CM.YCTAHOBKA
 ,XTA,FL COSY. OШИБKИ B
 ,UZA,PUT1. CTAHД.MAC.
 14,VTM,*ER/COS. ИЛИ COSY
 PUT1:,XTA,B1.
 14,ATX,.
 12,UJ,....
 GEN1:14,VTM,1-4.
 M TEX:14,UTC,3. ПEPEПИCЬ
 13,XTA,.TEKCTA OШИБKИ
 14,ATX,TИПOШ+3.
 14,VLM,M TEX....
 ,ATX,FL ERR.
 ,XTA,NC.ФOPMИPOB.
 ,ASN,64-36. N П/K
 ,UIA,NO NC0.- OH .NE. 0
 ,XTA,NUM X.N = XXXX
 ,UJ,WR NC.
 NO NC0:,AUX,S1*4/7.
 ,AOX,S1*4/60.
 WR NC:,ATX,E NUM....
 ,XTA,NAME.ФOPMИP.ИMEHИ
 ,UIA,FORM NA.- OHO .NE. 0
 ,XTA,NAME*.NAME=********
 FORM NA:,ATX,NAM1.
 14,VTM,NAM1.OTKYДA
 ,ITS,14.
 14,VTM,ENAM.KYДA
 ,ITS,14.
 ,CALL,TEXISO.
 ,XTA,CODE ER.
 ,ATX,E COD.
 ,XTA,. ФЛAГ :
 ,ATX,HET PEЗ.ECTЬ PEЗ-T
 11,UJ,.
C.......
 BL MISS:,XTA,.БЛOKИP.BBOДA
 ,ATX,ДAЙ KA.CЛEД.KAPTЫ
 ERR OUT:,BSS,.
 CLE RES:,BSS,.
C......   OБHYЛEHИE HAKOПЛ. COSY-CTPOKИ
 14,VTM,1-14.
 ,XTA,.
 Z RES:14,ATX,RESC+13.
 14,VLM,Z RES.
 ,XTA,CNTRES0.
 ,ATX,CNTRES.
 ,STX,
 ,UJ,RET1.
C......   PAЗHЫE KOHCTAHTOЧKИ
 T/CM:,LOG,1200.
 FULWOR:,LOG,7777 7777 7777 7777.
 B1:,LOG,1.
 C377:,LOG,377.
 C52:,LOG,52.
 S/NL:,LOG,12.
C......   KOДЫ XAPAKTEPHOГO CЛOBA
 COD W1:,LOG,77760.
 CODE ER:,LOG,1 77771.
C......   HAЧ.YKAЗATEЛИ COSY-KAPTЫ
 CNTIN0:,LOG,77761.
 CNTRES0:,LOG,77763.
 CNTIN:,LOG,77761.
 CNTRES:,LOG,77763.
C......   PAЗHЫE ДИAГHOCTИЧECKИE TEKCTЫ
 TER1:,ISO,23HHECOBПAДEHИE KC CM/COSY
 ,CONT,1H'12'
 TER2:,ISO,23HOTCYTCTBYET П/K 0
 ,CONT,1H'12'
 TER3:,ISO,24HЧYЖAЯ ПK ИЗ
 TER4:,ISO,23HHET KOHЦA CM/COSY
 ,CONT,1H'12'
 TER5:,ISO,23HOШ.HOMEP П/K CM/COSY
 ,CONT,1H'12'
 NUM X:,ISO,6HXXXX
 S1*4/7:,GOST,6H777700
 S1*4/60:,ISO,6H0000
 NAME*:,TEXT,8H********
 R WOR:,BSS,1.
 T*:,BSS,1.
 NC*:,BSS,2.
 M END:,BSS,1.
 NAM1:,BSS,1.
 NAME:,BSS,1.
 NC:,BSS,1.
 ,END,.
