          G04022:,NAME,DTRAN  /01.06.84/
          LOADGO:,SUBP,
          WORINF*:,SUBP,
          KCOUNT*:,SUBP,
          MONCARD*:,SUBP,
          ERROFLG*:,SUBP,
          MONREAD*:,SUBP,
          PRINT8:,SUBP,
          LUN*MON:,SUBP,
          *D03520*:,LC,1
          GAL/7:,EQU,KCOUNT*+2
          GAM/1:,EQU,KCOUNT*+1
          *0000B:11,BASE,*
          ,ATX,*0023B
          ,ITA,13
          ,ITS,
          14,VTM,*D03520*
          ,ITS,14
          ,XTS,*0023B
          14,VTM,*0021B.=6HDUREAD
          ,ITS,14
          13,VJM,LOADGO
          11,VTM,*0000B
          ,WTC,*0023B
          ,XTA,1
          ,AEX,*0022B.=6H*NAME
          ,UZA,*0014B.=41 0000 0041 0015
          14,VTM,-2
          *0010B:,UTC,*0016B.=0
          14,XTA,2
          14,ATX,GAL/7
          14,VLM,*0010B
          ,XTA,GAM/1
          ,ATX,WORINF*
          13,VJM,MONREAD*
          *0014B:,LOG,41 0000 0041 0015
          ,OCT,6700 0000 022
          *0016B:,LOG,
          ,LOG,10 0000 0000 7777
          ,LOG,1
          *0021B:,ISO,6HDUREAD
          *0022B:,ISO,6H*NAME
          *0023B:,BSS,1
          ,END,
