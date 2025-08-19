          G03702:,NAME,DTRAN  /01.06.84/
          MONCARD*:,SUBP,
          ERROFLG*:,SUBP,
          LUN*MON:,SUBP,
          *D02060*:,LC,1
          *D05205*:,LC,3
          G05210:,SUBP,
          G05243:,SUBP,
          PUTIBM*:,SUBP,
          GAM/3:,EQU,MONCARD*+3
          GAM/5:,EQU,*D05205*+2
          ,ATX,*0054B
          ,ITA,13
          ,ATX,*0053B
          ,XTA,MONCARD*
          ,ASN,64+8
          ,AEX,*0052B
          ,UZA,*0010B
          14,VTM,*0042B.=6HOTCYTC
          ,ITS,14
          14,UTM,3
          ,ITS,14
          ,XTS,*0050B
          13,VJM,LUN*MON
          ,SJ,
          *0010B:14,VTM,-2
          *0011B:14,XTA,GAM/3.MONCARD*+3
          14,ATX,GAM/5.*D05205*+2
          14,VLM,*0011B
          14,VTM,MONCARD*
          ,ITS,14
          13,VJM,G05210
          14,VTM,MONCARD*
          14,XTA,1
          ,AEX,*0051B
          ,UZA,*0017B
          ,ITS,14
          13,VJM,G05243
          *0017B:14,VTM,MONCARD*
          ,ITS,14
          14,UTM,15B
          ,ITS,14
          ,XTS,
          13,VJM,LUN*MON
          ,XTA,ERROFLG*
          ,UZA,*0026B
          14,VTM,*0037B.=6HБЫЛИ O
          ,ITS,14
          14,UTM,2
          ,ITS,14
          ,XTS,*0047B
          13,VJM,LUN*MON
          *0026B:,XTA,*D02060*
          ,AAX,*0046B
          ,U1A,*0030B
          13,VJM,PUTIBM*
          *0030B:,XTA,
          ,WTC,*0054B
          ,ATX,
          ,XTA,*D02060*
          ,ASN,64+45
          ,UZA,*0035B
          ,XTA,*0047B
          ,WTC,*0054B
          ,ATX,
          *0035B:,STI,
          ,WTC,*0053B
          ,OCT,0300 0000 022
          *0037B:,ISO,18HБЫЛИ OШИБKИ BBOДA
          *0042B:,ISO,24HOTCYTCTBYET П/K *NAME
          *0046B:,OCT,0000 002
          *0047B:,LOG,1
          *0050B:,LOG,4
          *0051B:,ISO,6H
          *0052B:,LOG,2 5116 2024 6505
          *0053B:,BSS,1
          *0054B:,BSS,1
          ,END,
