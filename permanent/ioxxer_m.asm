 IOXXER/M:,NAME,DTRAN  /01.06.84/
 LUN*MON:,SUBP,
 11,VTM,26B
 ,UJ,*0002B
C===========================================
 IOXXER/O:,ENTRY,
C===========================================
 11,VTM,27B
 *0002B:12,BASE,*
 ,ITS,11
 1,ATX,3
 15,XTA,-6
 ,ANX,
 ,ATI,14
 12,UTC,7
 14,XTA,
 ,ATX,*0021B
 15,UTM,-3
 14,VTM,*0021B
 ,ITA,14
 15,ATX,
 ,XTS,
 ,UJ,LUN*MON
 ,ISO,24H      END F REWIND R T
 ,ISO,18H R B   W T   W B
 *0021B:,BSS,1
 ,END,
