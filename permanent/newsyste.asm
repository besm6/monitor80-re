 NEWSYSTE:,NAME,DTRAN  /01.06.84/
 CAT:,PC,2048
 PAGE:,P/P,(CAT)16
 lastsect:,EQU,CAT+1536
 PARAMT*:,SUBP,
 word1:,EQU,CAT+1
 KCOUNT*:,LC,4
 WORINF*:,LC,1
 PRINT8:,SUBP,
 INFLOAD*:,LC,0
 RESET*:,SUBP,
 RM*:,LC,0
 1,BASE,*
 ,ITA,13
 ,XTS,
 10,VTM,
 13,VJM,PARAMT*.INITIALIZATION
 ,XTA,DEFNUZZZ
 ,ATX,NUZZZZ
 9,VTM,NUZZZZ
 10,VTM,4
 13,VJM,PARAMT*.GET NUZZZZ
 ,XTA,NUZZZZ
 ,AOX,RD0MASK
 ,ATX,RDCAT
 ,AEX,E40
 ,ATX,WRCAT
 10,VTM,2
 ,XTA,T
 13,VJM,PARAMT*.CHECK FOR T
 ,ATX,TFLAG
 ,*70,RDCAT
 ,XTA,RDCAT
 ,ARX,*0277B.=100 0000 0001
 ,ATX,RDCAT
 ,*70,RDCAT
 9,VTM,word1
 *0016B:9,UTM,2
 9,XTA,
 ,AEX,BCEED
 ,UZA,*0027B
 9,XTA,
 ,AAX,E47
 ,UZA,*0016B
 ,XTA,TFLAG
 ,U1A,*0025B
 9,XTA,
 ,AOX,E48
 9,ATX,
 ,UJ,*0016B
 *0025B:9,XTA,
 ,AEX,E48
 9,ATX,
 ,UJ,*0016B
 *0027B:,*70,WRCAT
 12,VTM,lastsect+41
 11,VTM,FIRST
 10,VTM,FIRST-ENDFIRST
 loop1:11,XTA,
 12,CTX,
 11,UTM,1
 12,UTM,1
 10,VLM,loop1
 12,VTM,lastsect+128
 11,VTM,SECOND
 10,VTM,SECOND-FINISH
 loop2:11,XTA,
 12,CTX,
 11,UTM,1
 12,UTM,1
 10,VLM,loop2
 ,XTA,WRCAT
 ,ARX,*0277B.=100 0000 0001
 ,ATX,WRCAT
 8,VTM,CAT
 ,XTA,
 8,ATX,3370B
 ,XTA,TFLAG
 ,U1A,*0103B
 8,XTA,3776B
 8,XTS,3777B
 ,XTS,
 ,*70,rdsect
 ,STX,
 8,STX,3777B
 8,ATX,3776B
 ,XTA,RD10MASK
 ,ARX,NUZZZZ
 ,ATX,RDZONE10
 ,AEX,E40
 ,ATX,WRZONE10
 ,XTA,
 9,VTM,-2047
 loop3:8,UTC,2047
 9,ARX,
 9,VLM,loop3
 ,ATX,CSUM
 8,ATX,3370B
 ,*70,RDZONE10
 ,WTC,44B
 9,VTM,-1024+8
 ,CTX,
 loop4:9,XTA,1024-8
 8,UTC,
 9,ATX,1024-8
 9,VLM,loop4
 ,WTC,44B
 8,XTA,1
 ,ASN,64+24
 ,ASN,64-24
 ,WTC,44B
 8,ATX,1
 ,XTA,CSUM
 8,ATX,1024-8
 ,XTA,ainfload
 8,ATX,1024-7
 ,XTA,areset
 8,ATX,1024-6
 ,XTA,arm
 8,ATX,1024-5
 ,XTA,
 8,ATX,KCOUNT*
 ,XTA,*0276B.=10 0000 0000 7777
 8,ATX,KCOUNT*+1
 ,XTA,*0275B.=1
 8,ATX,KCOUNT*+2
 ,XTA,43B
 8,ATX,KCOUNT*+3
 ,XTA,*0276B.=10 0000 0000 7777
 8,ATX,WORINF*
 ,*70,WRZONE10
 14,VTM,twrtrp
 ,ITS,14
 14,UTM,2
 ,ITS,14
 ,XTS,
 13,VJM,PRINT8
 *0103B:,*70,WRCAT
 ,STI,
 ,ATI,13
 13,UJ,
 ainfload:,,
 ,Z00,INFLOAD*
 areset:,,
 ,Z00,RESET*
 arm:,,
 ,Z00,RM*
 rdsect:8,010,PAGE+67
 ,020,
 RD10MASK:,010,PAGE
 ,,10B
 RDZONE10:,BSS,1
 WRZONE10:,BSS,1
 TFLAG:,BSS,1
 CSUM:,BSS,1
 twrtrp:,ISO,18H * ЗAПИCAHA TPП *
 RD0MASK:,010,PAGE
 ,000,
 BCEED:,LOG,7777 7777 7777 7777
 RDCAT:,BSS,1
 WRCAT:,BSS,1
 NUZZZZ:,BSS,1
 FIRST:,*70,2055B
 ,XTA,2073B
 ,AEX,
 ,UZA,100B
 ,ATX,73B
 ,UJ,100B
 :,AVX,
 ,021,10B
 ,BSS,24
 ENDFIRST:,BSS,2
 SECOND:7,REL,*
 :,UJ,entry1
 :,UJ,entry2
 entry1:2,VTM,-7
 4,VTM,-48
 ,UTC,*0243B.=0
 6,VTM,
 5,XTA,
 ,ATX,FINISH
 loop5:,XTA,FINISH
 ,ASN,64-6
 ,ATX,FINISH
 ,YTA,
 ,ATI,14
 11,VTM,
 *0176B:14,MTJ,10
 14,UTM,-6
 ,ITA,14
 ,AAX,*0267B.=4 0000
 ,U1A,*0202B
 11,UTM,1
 ,UJ,*0176B
 *0202B:,UTC,txt2gost
 11,XTA,
 *0203B:,UTC,*0206B
 10,VZM,
 ,ASN,64-8
 10,UTM,-1
 ,UJ,*0203B
 *0206B:,AAX,*0272B.=:776
 4,ASN,64+48
 6,AEX,
 6,ATX,
 4,UTM,10B
 ,UTC,*0213B
 4,V1M,
 4,VTM,-48
 6,UTM,1
 *0213B:,UTC,loop5
 2,VLM,
 ,ITA,5
 ,ARX,*0270B.=10
 ,ASN,64-33
 ,AUX,*0237B.=:0160 3407 0160 34
 ,AEX,*0245B
 ,ATX,*0245B
 5,XTA,7
 ,ASN,64-33
 ,AUX,*0237B.=:0160 3407 0160 34
 ,AEX,*0250B
 ,ATX,*0250B
 ,ITA,5
 ,ARX,*0270B.=10
 5,AEX,7
 ,AAX,*0271B.=7 7777
 ,U1A,*0225B
 ,XTA,*0253B.=360 7417 0360 7631
 ,ATX,tentry
 *0225B:,*64,*0235B
 13,UJ,
 entry2:,XTA,netrazd
 ,ATX,*0240B
 ,XTA,netrazd+1
 ,ATX,*0240B+1
 ,ITA,5
 ,ARX,*0270B.=10
 5,ATX,7
 ,UTC,entry1
 13,VJM,
 ,SJ,
 *0235B:,ATX,*0240B
 ,ATX,*0240B
 ,STX,
 8,ATX,
 *0237B:,GOST,6H777770
 *0240B:,GOST,18H
 *0243B:,GOST,12H00000000
 *0245B:,GOST,6H00000
 tentry:,GOST,12H   ENTRY
 *0250B:,GOST,6H00000'231'
 netrazd:,GOST,12H HET PAЗДEЛA
 *0253B:,GOST,6H     '231'
 txt2gost:,GOST,24H  БЦДФГИ  *ЙЛЯЖ/01234567
 ,GOST,24H89Ь П  ЫЗABCDEFGHIJKLMNO
 ,GOST,18HPQRSTUVWXYZШЭЩЧЮ
 *0267B:,LOG,4 0000
 *0270B:,LOG,10
 *0271B:,LOG,7 7777
 *0272B:,OCT,776
 FINISH:,OCT,1
 E40:,OCT,001
 *0275B:,LOG,1
 *0276B:,LOG,10 0000 0000 7777
 *0277B:,LOG,100 0000 0001
 E47:,OCT,2
 E48:,OCT,4
 T:,ISO,6HT
 DEFNUZZZ:,LOG,67 0000
 ,END,
