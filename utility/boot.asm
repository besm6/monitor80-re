 BOOT:,NAME,DTRAN  /01.06.84/
 STKBASE:,EQU,53400B
 AIO:,EQU,64000B
 IOPG:,P/P,(AIO)16
 C:,BSS,14
 ,LOG,3 7700 1005 3377          . stack base-1 in bits 15-1, rest unclear
 ,LOG,400                       . monitor base ?
 *0020B:,SJ,                    . exit
 ,BSS,18
 *0043B:,,
 ,Z00,AIO
 *0044B:,LOG,4001 0053 4000 0400. flags, stack base, monitor base
 *0045B:,XTA,IOPG
 ,APX,4                         . read MB20TR04 to exchange page
 *0046B:,ATX,IOPG
 ,APX,4                         . write MB20TR04 from exchange page
 *0047B:,XTA,IOPG
 ,AUX,                          . read perm cat copy
 *0050B:,ATX,IOPG
 ,AUX,                          . write perm cat copy
 *0051B:14,*70,*0061B-C         . ???
 *0052B:,LOG,0230 0053 0300 0000. ???
 *0053B:,,
 ,Z00,AIO
 ,LOG,210 4000                  . ???
 ,LOG,
 ,LOG,
 ,LOG,
 *0060B:,LOG,0014 3200 0021 0000. read perm cat
 *0061B:,LOG,0014 3200 0021 0007. read loader to exchange page
 ,LOG,0010 3200 0020 0004       . read MB20TR04 to exchange page
 ,LOG,0014 0100 0021 0006       . read librarian to page 01
 ,LOG,
 ,LOG,
 ,LOG,
 ,LOG,6640 2000 0066 0200       . ??? 67B
 ,LOG,
 ,LOG,
 ,LOG,2000 3002 2430 0000       . ??? 72B
 ,OCT,3000 0020                 . LTAPES 73B
 ,LOG,0014 0100 0021 0006       . read librarian to page 1
 ,BSS,1
 *0076B:,*67,*0106B-C
 *0077B:,LOG,0010 0000 0030 0050. read overlay catalog
 ,*70,*0060B-C
 ,*70,*0050B-C
 ,*70,*0111B-C
 ,*70,*0112B-C
 ,UJ,*0076B-C
 *0105B:,TEXT,8HMONITOR*
 *0106B:,Z00,*0115B-C
 9,Z00,STKBASE
 *0107B:15,VTM,STKBASE+1
 ,*70,*0061B-C
 ,XTS,*0105B-C
 ,UJ,AIO
 *0111B:,LOG,0014 0100 0021 0001. read zone 2 of perm cat
 *0112B:,LOG,0000 0100 0021 0001. write zone 2 of perm cat copy
 *0113B:,LOG,4000 0103 0020 0000. write sector p01s3 to MB20TR00
 *0114B:,LOG,7777 7777 7777 7777
 *0115B:,*71,*0114B-C           . establish new TT I/O mode
 ,XTA,3370B
 ,UZA,*0107B-C
 ,AEX,1770B
 ,U1A,*0107B-C
 ,XTA,
 ,ATX,3370B
 1,VTM,1-1024
 *0122B:,UTC,2047
 1,ARX,
 1,VLM,*0122B-C
 1,VTM,1-1024
 *0124B:,UTC,AIO+1023
 1,ARX,
 1,VLM,*0124B-C
 ,AEX,1770B
 ,U1A,*0107B-C
 ,*70,*0113B-C
 ,WTC,1772B
 13,VJM,
 ,WTC,1773B
 ,XTA,3
 ,ASN,64-2
 ,ASN,64+2
 ,XTS,*0044B-C
 ,ASN,64+46
 ,ASN,64-46
 15,AOX,
 ,ATX,*0044B-C
 ,XTA,*0077B-C
 ,WTC,1771B
 ,ATX,2
 ,XTA,*0060B-C
 ,WTC,1771B
 ,ATX,3
 13,VJM,1000B
 ,END,
