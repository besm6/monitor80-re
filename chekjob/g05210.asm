          G05210:,NAME,DTRAN  /01.06.84/
          KCOUNT*:,SUBP,
          PRINT8:,SUBP,
          /IP*:,SUBP,
          TSTATE*:,SUBP,
          *50/100:,SUBP,
          *BTBUF*:,LC,144
          PREPDAT:,SUBP,
          BIGTITLE:,SUBP,
          GAN/1:,EQU,/IP*+7
          GAO/4:,EQU,KCOUNT*+2
          ,ATI,14
          ,ITA,13
          ,ATX,*0106B
          12,VTM,
          14,XTA,1
          ,AEX,*0104B
          ,AAX,*0105B
          ,U1A,*0006B
          14,XTA,
          ,ATX,TSTATE*
          ,ATX,GAN/1
          *0006B:13,VJM,*50/100
          15,ATX,
          ,AUX,*0103B
          ,AOX,*0101B
          ,STX,*0073B
          ,ASN,64-24
          ,AUX,*0103B
          ,AOX,*0101B
          ,ATX,*0074B
          ,ITA,12
          13,VJM,PREPDAT
          ,XTA,43B
          ,ASN,64-20
          ,AOX,*0102B
          ,ATX,*0110B
          ,*70,*0110B
          ,XTA,43B
          ,ATI,12
          12,XTA,1776B
          ,ATX,*0060B
          12,XTA,1777B
          ,ATX,*0061B
          ,XTA,*0100B
          ,ATX,GAO/4
          *0023B:14,VTM,*0053B.=6H0  M O
          ,ITS,14
          14,VTM,*0074B
          ,ITS,14
          ,XTS,
          13,VJM,PRINT8
          ,STI,
          ,WTC,*0106B
          ,UJ,
          :,ITS,13
          ,STX,*0106B
          13,VJM,PREPDAT
          ,UJ,*0023B
        G05243:,ENTRY,
          :,ATI,12
          ,*64,*0075B
          ,ITA,13
          ,ATX,*0106B
          ,ITA,1
          ,ATX,*0107B
          12,XTS,1
          12,XTS,2
          12,XTS,3
          14,VTM,*BTBUF*
          ,ITS,14
          14,VTM,166B
          ,ITS,14
          13,VJM,BIGTITLE
          12,VTM,-7
          1,VTM,*BTBUF*
          *0043B:,ITS,1
          1,UTM,21B
          ,ITS,1
          13,VTM,24B
          ,ITS,13
          13,VJM,PRINT8
          1,UTM,1
          12,VLM,*0043B
          ,*64,*0075B
          ,WTC,*0107B
          1,VTM,
          ,STI,
          ,WTC,*0106B
          ,UJ,
          *0053B:,ISO,24H0  M O H И T O P-8 0  (3
          ,ISO,6H.7)
          *0060B:,ISO,6HИHTEP
          *0061B:,ISO,18H ИAЭ         (  MC
          ,ISO,6H ′42′ Д Y
          ,ISO,6H Б H A
          ,ISO,6H ′42′ ИAЭ
          ,ISO,24H  )             ШИФP
          *0073B:,ISO,6H
          *0074B:,ISO,6H
          *0075B:,Z00,*0077B
          ,Z00,*0077B
          ,LOG,7400 0000
          *0077B:,LOG,4620 7417 0360 7417
          *0100B:,LOG,1
          *0101B:,ISO,6H000000
          *0102B:,LOG,14 0000 0021 0001
          *0103B:,LOG,360 7417 0360 7417
          *0104B:,ISO,6H-
          *0105B:,OCT,776
          *0106B:,BSS,1
          *0107B:,BSS,1
          *0110B:,BSS,1
          ,END,
