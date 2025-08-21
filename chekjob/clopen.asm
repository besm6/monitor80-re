          CLOPEN:,NAME,DTRAN  /01.06.84/
C Отличается в нескольких байтах от варианта в permanent library
          *ADCB:,LC,1
          *0000B:,UTC,*ADCB
          ,ATX,
          ,STI,12
          12,STX,2
          12,STX,1
          12,STX,
          13,UJ,
          CLDECO:,ENTRY,
          ,STI,12
          ,ITA,8
          8,BASE,*0000B
          ,ATX,*0367B
          12,WTC,1
          9,VTM,
          12,WTC,2
          10,VTM,
          11,VTM,-6
          *0011B:11,ITA,7
          ,UTC,*0376B
          11,ATX,
          11,VLM,*0011B
          ,NTR,3
          11,VTM,-35
          ,XTA,*0337B.=6H
          10,ATX,
          10,ATX,1
          10,ATX,2
          10,ATX,3
          10,ATX,4
          10,ATX,5
          9,XTA,
          ,AEX,*0341B.=6H*
          ,U1A,*0022B
          11,UTM,6
          *0022B:12,WTC,
          14,VTM,1
          ,XTA,*0346B.=12
          ,ATX,*0363B
          7,VJM,*0071B
          *0025B:14,UTM,2
          14,UTC,-3
          ,XTA,
          ,UZA,*0067B
          10,AEX,
          ,U1A,*0025B
          14,UTC,-2
          ,XTA,
          ,U1A,*0033B
          ,XTA,*0321B.=6H     *
          10,ATX,
          ,UJ,*0022B
          *0033B:10,UTM,1
          ,ASN,64-9
          ,ATX,*0362B
          ,YTA,
          ,ATX,*0363B
          7,VJM,*0071B
          ,XTA,*0363B
          ,AAX,*0332B.=3
          ,AEX,*0332B.=3
          ,U1A,*0054B
          ,XTA,*0363B
          ,ASN,64+26
          ,ATI,4
          10,XTA,
          ,AEX,*0337B.=6H
          ,ASN,64+8
          ,UZA,*0054B
          ,ASN,64+16
          ,U1A,*0046B
          10,XTA,
          ,ASN,64-24
          10,ATX,
          *0046B:10,XTA,
          4,VZM,*0052B
          ,AAX,*0320B.=:0000 04
          ,ASN,64+7
          10,ARX,
          ,ARX,*0327B.=:0000 231
          ,AAX,*0325B.=1770 7777 7777
          *0052B:,AOX,*0322B.=6H 00000
          10,ATX,
          ,AAX,*0315B.=:4770 4210 4210 421
          ,U1A,*0142B
          *0054B:,XTA,*0362B
          ,U1A,*0033B
          *0055B:,ITA,14
          12,A-X,
          ,ASN,64+1
          ,AOX,*0353B.=I0
          12,ATX,3
          ,ASN,64-42
          ,AUX,*0323B.=160 3400
          ,AOX,*0340B.=6H T=00
          12,WTC,2
          ,ATX,14B
          ,NTR,6
          11,VTM,-6
          *0063B:,UTC,*0376B
          11,XTA,
          11,ATI,7
          11,VLM,*0063B
          ,XTA,*0367B
          ,ATI,8
          13,UJ,
          *0067B:12,WTC,
          14,VTM,
          ,UJ,*0055B
          *0071B:,XTA,*0363B
          7,UZA,
          6,VTM,
          1,VTM,2
          5,VTM,
          ,UJ,*0107B
          *0074B:,XTA,*0361B
          ,ATX,*0364B
          ,XTA,*0317B.=40
          ,ATX,*0361B
          *0076B:5,VZM,*0077B
          6,VZM,*0145B
          *0077B:10,XTA,
          ,AEX,*0337B.=6H
          ,AAX,*0360B.=:776
          ,U1A,*0145B
          10,XTA,
          ,ASN,64-8
          ,AOX,*0361B
          10,ATX,
          1,VZM,*0104B
          1,UTM,-1
          *0104B:,XTA,*0363B
          ,AAX,*0334B.=4
          ,UZA,*0107B
          5,V1M,*0107B
          4,VJM,*0157B
          *0107B:5,V1M,*0074B
          11,VZM,*0136B
          4,VJM,*0146B
          ,AEX,*0317B.=40
          ,U1A,*0114B
          1,VZM,*0136B
          1,VTM,2
          ,UJ,*0107B
          *0114B:,XTA,*0165B.=14 0017 1401
          ,WTC,*0361B
          ,ASN,64-32
          ,AAX,*0324B.=1
          ,U1A,*0136B
          :,XTA,*0363B
          ,ASN,64+1
          ,AOX,*0363B
          ,AAX,*0324B.=1
          ,ATI,4
          ,UTC,*0163B
          4,XTA,
          ,WTC,*0361B
          4,VTM,
          4,ASN,64-32
          ,AAX,*0324B.=1
          ,U1A,*0076B
          ,XTA,*0363B
          ,AAX,*0326B.=2
          ,UZA,*0136B
          ,XTA,*0363B
          ,AAX,*0324B.=1
          ,U1A,*0131B
          6,VTM,1
          ,UJ,*0076B
          *0131B:4,UTM,-70
          4,V1M,*0136B
          ,XTA,
          ,ATX,*0361B
          ,XTA,*0363B
          ,AOX,*0360B.=:776
          ,ATX,*0363B
          5,VTM,
          ,UJ,*0076B
          *0136B:,XTA,*0363B
          ,ASN,64+3
          ,ATI,5
          ,WTC,*0361B
          4,VTM,
          10,XTA,
          ,AEX,*0337B.=6H
          5,UJ,*0170B
          *0142B:,XTA,*0352B.=6H=ERROR
          9,ATX,4
          12,WTC,2
          ,ATX,
          ,UJ,*0055B
          *0145B:5,VZM,*0107B
          7,UJ,
          *0146B:11,UTM,43B
          ,ITA,11
          11,UTM,-34
          ,A*X,*0166B.=4002 5252 5252 5253
          ,ATI,2
          ,YTA,100B
          ,A*X,*0167B
          ,ATX,*0365B
          ,X-A,
          ,ATI,3
          9,J+M,2
          2,XTA,
          3,ASN,64+40
          ,AAX,*0356B.=377
          ,ATX,*0361B
          ,ATX,*0366B
          4,UJ,
          *0157B:,XTA,*0347B.=52
          ,WTC,*0365B
          3,VTM,
          ,AEX,*0366B
          3,ASN,64-40
          2,AEX,
          2,ATX,
          4,UJ,
          *0163B:,LOG,7760 0001
          ,LOG,3 7760 0001
          *0165B:,LOG,14 0017 1401
          *0166B:,LOG,4002 5252 5252 5253
          *0167B:,LOG,4000 0000 0000 0060
          *0170B:,BSS,1
          ,U1A,*0074B
          ,UJ,*0142B
          ,UJ,*0074B
          :,UZA,*0221B
          ,UJ,*0074B
          ,U1A,*0307B
          ,UJ,*0142B
          ,UJ,*0267B
          :,UZA,*0222B
          ,UJ,*0074B
          ,UJ,*0224B
          :,UZA,*0244B
          ,UJ,*0237B
          ,UZA,*0245B
          ,UJ,*0237B
          ,U1A,*0251B
          ,UJ,*0142B
          ,U1A,*0274B
          ,UJ,*0303B
          ,U1A,*0304B
          ,UJ,*0074B
          ,U1A,*0264B
          ,UJ,*0263B
          ,U1A,*0272B
          ,UJ,*0142B
          ,U1A,*0260B
          ,UJ,*0245B
          ,UJ,*0074B
          :,U1A,*0255B
          ,UJ,*0074B
          ,UJ,*0313B
          :,UZA,*0142B
          ,WTC,*0364B
          4,VTM,-45
          4,VZM,*0074B
          ,XTA,*0330B.=6H - ПИШ
          9,ATX,3
          ,XTA,*0342B.=6HИTE MИ
          9,ATX,4
          ,XTA,*0331B.=2205 4503 1002 0441
          9,ATX,5
          ,UJ,*0074B
          *0221B:11,VZM,*0142B
          ,UJ,*0071B
          *0222B:,XTA,*0357B.=6H 67000
          10,ATX,
          11,UTM,-2
          7,UJ,
          *0224B:,WTC,*0364B
          4,VTM,-46
          4,VZM,*0074B
          4,UTM,1
          4,VZM,*0074B
          10,110,7777B
          ,AEX,*0337B.=6H
          ,UZA,*0142B
          10,MTJ,4
          10,XTA,
          ,AEX,*0337B.=6H
          ,UZA,*0234B
          10,XTA,
          10,ATX,1
          4,UTM,1
          *0234B:10,110,7777B
          10,ATX,
          ,XTA,*0337B.=6H
          10,100,7777B
          4,MTJ,10
          ,UJ,*0074B
          *0237B:10,XTA,
          ,AAX,*0356B.=377
          ,ATI,4
          6,VTM,
          4,UTM,-82
          4,VZM,*0074B
          4,UTM,-5
          4,VZM,*0074B
          ,UJ,*0142B
          *0244B:,XTA,*0344B.=6H READ
          ,UJ,*0246B
          *0245B:,XTA,*0335B.=6H WRITE
          *0246B:9,ATX,4
          ,ASN,64+32
          ,AOX,*0336B.=:1002 0040 1002 01
          10,ATX,
          7,UJ,
          *0251B:10,XTA,
          ,AEX,*0355B.=6HSCRATC
          ,UZA,*0074B
          ,XTA,*0333B.=:2135 0322 4
          ,ATX,*0362B
          ,XTA,*0350B.=212
          ,ATX,*0363B
          *0255B:4,UTM,-32
          4,V1M,*0074B
          11,VZM,*0074B
          5,VTM,
          ,UJ,*0074B
          *0260B:10,XTA,
          ,AAX,*0316B.=:4771 7637 4210 421
          ,U1A,*0237B
          10,XTA,
          10,ATX,1
          ,UJ,*0245B
          *0263B:,XTA,*0345B.=6H   040
          10,ATX,
          *0264B:10,110,7776B
          ,ASN,64+24
          ,AOX,*0354B.=6H/S/
          10,100,7775B
          ,UJ,*0074B
          *0267B:10,XTA,
          10,115,7777B
          ,AEX,*0337B.=6H
          ,UZA,*0074B
          ,UJ,*0224B
          *0272B:,ITA,11
          ,ATX,*0377B
          ,UJ,*0074B
          *0274B:,XTA,*0165B.=14 0017 1401
          4,ASN,64-32
          ,AAX,*0324B.=1
          ,U1A,*0074B
          *0276B:,XTA,*0351B.=:2160 1311 2
          ,ATX,*0363B
          ,ATX,*0362B
          ,WTC,*0377B
          11,VTM,
          ,XTA,*0337B.=6H
          10,ATX,
          10,UTM,-2
          7,UJ,
          *0303B:11,VZM,*0142B
          ,UJ,*0276B
          *0304B:10,XTA,
          10,115,7775B
          10,100,7775B
          ,XTA,*0337B.=6H
          10,ATX,
          7,UJ,
          *0307B:,XTA,*0360B.=:776
          ,AOX,*0363B
          ,ATX,*0363B
          ,XTA,*0343B.=6H    00
          10,AOX,
          10,ATX,
          ,UJ,*0074B
          *0313B:11,VZM,*0074B
          5,VTM,
          ,UJ,*0077B
          *0315B:,OCT,6774 4310 6214 4310
          *0316B:,OCT,6775 7737 6214 4310
          *0317B:,LOG,40
          *0320B:,OCT,0000 04
          *0321B:,ISO,6H     *
          *0322B:,ISO,6H 00000
          *0323B:,LOG,160 3400
          *0324B:,LOG,1
          *0325B:,LOG,2407 7777 7777
          *0326B:,LOG,2
          *0327B:,OCT,0000 231
          *0330B:,ISO,6H - ПИШ
          *0331B:,ISO,6HHYC !!
          *0332B:,LOG,3
          *0333B:,OCT,0131 0222 6
          *0334B:,LOG,4
          *0335B:,ISO,6H WRITE
          *0336B:,OCT,1002 0040 1002
          *0337B:,ISO,6H
          *0340B:,ISO,6H T=00
          *0341B:,ISO,6H*
          *0342B:,ISO,6HИTE MИ
          *0343B:,ISO,6H    00
          *0344B:,ISO,6H READ
          *0345B:,ISO,6H   040
          *0346B:,LOG,12
          *0347B:,LOG,52
          *0350B:,LOG,212
          *0351B:,OCT,2160 1311 2
          *0352B:,ISO,6H=ERROR
          *0353B:,INT,0
          *0354B:,ISO,6H/S/
          *0355B:,ISO,6HSCRATC
          *0356B:,LOG,377
          *0357B:,ISO,6H 67000
          *0360B:,OCT,776
          *0361B:,BSS,1
          *0362B:,BSS,1
          *0363B:,BSS,1
          *0364B:,BSS,1
          *0365B:,BSS,1
          *0366B:,BSS,1
          *0367B:,BSS,7
          *0376B:,BSS,1
          *0377B:,BSS,1
          ,END,
