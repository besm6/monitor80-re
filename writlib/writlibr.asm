 WRITLIBR:,NAME,
 CATALOG:,PC,2048
 PRINT8:,SUBP,
 LDRM:,EQU,54B.CBOБ.B TEMPO
 LEX:,EQU,43B .AДPEC OБM.ЛИCTA
 ARD:,EQU,47B .ЧTEHИE CAT.TL
 AWRT:,EQU,50B.ЗAПИCЬ CAT.TL
 L       :12,VTM,1                        .ENTRY FOR COMPACT STRUCTURE
            ,UJ ,*+2                      .
         :12,VTM,                         .ENTRY FOR NONCOMPACT STRUCTUR
         :   ,ATI, 11                     .
             ,ITA, 1                      .
           14,VTM, -12                    .
         :14,ITS,14                       .
          14,VLM,*                        .
           7,VTM,L                        .
          11,MTJ,6                        .ADDRESS OF READ-SUBPR.
             ,ITA, 12                     .
            7,ATX, STR3-L                 .
             ,XTA, AWRT
            7,AAX, NLIS-L
             5,VTM, CATALOG
             ,ITS, 5
             ,ASN, 64-20
            15,AOX,
            7,ATX, WCAT-L
            7,AOX, CRED-L
             7,ATX, RCAT-L
C.....   ЧИCTKA 7-И ЛИCTOB CATALOG(БEЗ 1-ГO)
 7,*70,RCAT-L
 5,VTM,1776B
 *0015B:,UTC,CATALOG
 5,xta,1
 7,aex,cal7-L
 ,u1a,*0022B
 14,vtm,-1023
 ,xta,
 :,UTC,CATALOG
 14,ATX,3777B
 14,VLM,*-1
 ,Uj,CHKENTRY
 *0022B:5,utm,-2
 5,v1m,*0015B
 7,xta,RCAT-L
 7,arx,CEX-L
 7,atx,WL-L
 7,*70,WL-L
 CHKENTRY: 6,UTC,                         .
          13,VJM,                         .READ WORD OF STANDART ARRAY
         : 7,STX,STR-L                    .
           6,UTC,                         .
          13,VJM,                         .
         : 7,STX,STR1-L                   .
            7,XTA, STR1-L                 .
           7,AAX,MSTR-L                   .
            ,UZA,CHEKSTR                  .IF NOT ENTRY
            7,XTA, STR1-L                 .
           7,AAX,MA3L-L                   .CLEAN ENTRY MARK OF ENTRY ADR
           7,ATX,STR1-L                   .
          12,VJM,WRTENTRY                 .WRITE ENTRY TO CATALOG
         :  ,UJ ,CHKENTRY                 .
 CHEKSTR :  6,UTC,                        .                  AFTER 5WL37
          13,VJM,                         .READ 3D WORD OF STRUCTURE
         : 7,STX,STR2-L                   .
            7,XTA, STR3-L                 .
             ,U1A, SHORTSTR               .
           5,VTM,-6                       .READ LONG STRUCTURE AND
         : 6,UTC,                         .CONVERT TO COMPACT MODE
          13,VJM,                         .
         : 5,UTC,6                        .
           7,STX,STR3-L                   .
           5,VLM,*-2                      .
           7,XTS,STR3-L                   .CALLS
            ,ASN,64-12                    .
           7,AOX,STR2-L                   .PAREXPS
            ,ASN,64-12                    .
           7,AOX,STR1-L                   .DECLARATIONS
            ,ASN,64-12                    .
           7,AOX,STR-L                    .HEAD
           7,XTS,STR4-L                   .LONG IDENTIFIERS
            ,ASN,64-15                    .
           7,AOX,STR10-L                  .DATA
            ,ASN,64-15                    .
           7,AOX,STR11-L                  .SET DATA
           7,XTS,STR7-L                   .ABS CONSTANTS
            ,ASN,64-15                    .
          7,AOX,STR6-L                    PAR.CONSTS
            ,ASN,64-15                    .
           7,AOX,STR5-L                   .INSTRUCTIONS
           7,STX,STR2-L                   .
           7,STX,STR1-L                   .
           7,STX,STR-L                    .
 SHORTSTR: 7,XTA,STR-L                    .
           7,AAX,MA4S-L                   .HEAD
           7,XTS,STR-L                    .
            ,ASN,64+12                    .
           7,AAX,MA4S-L                   .DECLARATIONS
          15,ARX,                         .
           7,XTS,STR-L                    .
            ,ASN,64+24                    .
           7,AAX,MA4S-L                   .PAR.EXPRETIONS
          15,ARX,                         .
           7,XTS,STR-L                    .
            ,ASN,64+36                    .
           7,AAX,MA4S-L                   .CALLS
          15,ARX,                         .
           7,XTS,STR1-L                   .
            ,ASN,64+30                    .
           7,AAX,MA3L-L                   .LONG IDENTIFIERS
          15,ARX,                         .
           7,ATX,N3-L                     .LENGTH OF DEF.TABLE
           7,AAX,MDEFOVL-L                .
            ,U1A,LER1                     .INCORRECT LENGTH OF DEFTABLE
           7,XTA,STR1-L                   .
           7,AAX, MA3L-L
           7,XTS,STR1-L                   .
            ,ASN,64+15                    .
           7,AAX,MA3L-L                   .DATA
          15,ARX,                         .
           7,ATX,N2-L                     .SET DATA + DATA
           7,XTA,STR2-L                   .
           7,AAX,MA3L-L                   .INSTRUCTIONS
           7,XTS,STR2-L                   .
            ,ASN,64+15                    .
           7,AAX,MA3L-L                   .PAR.CONSTS
           7,STX,LBSS-L                   .
           7,XTS,STR2-L                   .
            ,ASN,64+30                    .
           7,AAX,MA3L-L                   .ABS.CONSTS
          15,ARX,                         .
           7,ATX,LBOD-L                   .LENGTH OF PROGRAM BODY
           7,ARX,C2-L                     .+2(1 WORD OF BODY,AT LEAST,
           7,ATX,R-L                      .MUST BE ON SAME PAGE,THAT
           7,AAX,MSEG-L                   .DEF.TABLE
           7,ATX,K-L                      .NUMBER OF SEGMENTS IN BODY
           7,XTA,R-L                      .
           7,AAX,MRES-L                   .LENGTH OF NOT FULL SEGMENT
           7,ARX,N3-L                     .
           7,ARX,N2-L                     .
           7,AAX,MSEG-L                   .
           7,ATX,L1-L                     .NUMBER OF SEGM.IN DEF.TABLE-1
           7,ARX,K-L                      .
           7,ATX,K1-L                     .FULL NUMBER OF SEGM.-1
         :  ,XTA,LDRM                     .
           7,ARX,K1-L                     .
           7,ARX,C1S-L                    .
           7,ATX,DRLT-L                   .BEG.FOR ANOTHER SUBPROGRAM
           7,XTA,DRMX-L                   .
           7,AEX,CAL7-L                   .
           7,ARX,DRLT-L                   .
           7,AAX,MSGN-L                   .
            ,UZA,LER2                     .OVERFLOW OF LIBRERY
           7,XTA,LBOD-L                   .
           7,ARX,N2-L                     .
           7,ATX,N-L                      .
           7,ARX,N3-L                     .
           7,ATX,NPR-L                    .LENGTH OF INF.FOR LIBRERY
            ,ITA,                         .
           7,ATX,PRCT-L                   .CLEAN COUNTER OF WORDS
            ,XTA,LDRM                     .FREE PLACE ON DRUM
           7,ATX,DRMC-L                   .FOR WRITING ON DRUM
           7,AAX,MSGP-L                   .NUMER OF PAGE-SEGMENT
           7,ATX,NSEG-L                   .BEGINNING ON PAGE
             ,UZA, BGLP
           14,VJM, ACLC
            7,XTA, ADR-L
            7,AOX, CRED-L
            7,ATX, ADR-L
            7,*70, ADR-L
 BGLP    : 7,XTA,NSEG-L                   .
           7,ARX,C3-L                     .
           7,ATX,PGCT-L                   .SET COUNT FOR PAGE
         :  ,WTC,LEX                      .
           5,VTM,                         .
          14,VTM,-2                       .
 STOSTR  :14,UTC,2                        .
           7,XTA,STR-L                    .WRITE STRUCTURE ON EXCHANGE
           7,WTC,PGCT-L                   .PAGE
          14,UTC,                         .
           5,ATX,-1                       .
          14,VLM,STOSTR                   .
 BGL1    : 6,UTC,                         .
          13,VJM,                         .READ WORD
           7,WTC,PGCT-L                   .
           5,STX,                         .STORE WORD
           7,XTA,PRCT-L                   .
            7,AEX, N-L
              ,U1A, *+2
             ,WTC, PGCT
             5,XTA,
             7,ATX, STR-L
         :  7,XTA, PRCT-L
           7,ARX,C1-L                     .
           7,ATX,PRCT-L                   .
           7,AEX,NPR-L                    .
            ,UZA,ENPR                     .IF END OF STAND. ARRAY
           7,XTA,PGCT-L                   .
           7,ARX,C1-L                     .
           7,ATX,PGCT-L                   .
           7,AAX,MOVL-L                   .
            ,UZA,BGL1                     .IF PAGE NOT FULL
 WRPG    :  ,XTA,                         .
           7,ATX,PGCT-L                   .
          14,VJM,ACLC                     .
          : 7,*70, ADR-L
         : 7,XTA,DRMC-L                   .
           7,ARX,C1P-L                    .PREPARE WRITING OF NEXT PAGE
           7,ATX,DRMC-L                   .
            ,UJ ,BGL1                     .CONTINUATION
 ACLC    : 7,XTA,DRMC-L                   .PREPARES INF.WORD FOR DRUM
            ,ASN,64-27                    .
           7,AUX,MUNP-L                   .
              ,XTS, LEX
            ,ASN,64-20                    .
          15,AOX,                         .
            7,ATX, ADR-L
          14,UJ ,                         .
 ENPR    :14,VJM,ACLC                     .
         :  7,*70, ADR-L
            ,XTA,LDRM                     .
           7,AAX,MSGP-L                   .NUMER OF SEGMENT
             ,ASN, 64-16
            ,AOX,LDRM                     .
           7,AAX,MOVL-L                   .
            ,ASN,64-20                    .
            7,AOX, CCAT-L
             7,XTS, LBOD-L
           7,ARX,LBSS-L                   .
             ,ASN, 64-15
          15,AOX,                         .48-46 45-42  41-31 30-16 15-1
           7,ATX,STR1-L                   .  6   NSEGM NDR,TR LBODY ENTR
           7,XTA,DRLT-L                   .
            ,ATX,LDRM                     .FREE PLACE ON DRUM
          12,VJM,WRTENTRY                 .WRITE MANE ENTRY TO CATALOG
         :  ,ITA,                         .
           7,ATX,ERRFL-L                  .
 EXIT:,BSS,
 7,*70,WCAT-L
 5,vtm,1776B
 next:,utc,CATALOG
 5,xta,1
 7,aex,CAL7-L
 ,uza,RESI
 5,utm,-2
 5,v1m,next
 7,xta,WCAT-L
 7,arx,CEX-L
 7,atx,WL-L
 7,*70,WL-L
 RESI    :   ,STI,
          14,VTM,13                       .RESET INDEXIS
         :14,UTM,-1                       .
          14,STI,1                        .
          14,V1M,*-1                      .
            ,UTC,ERRFL                    .
            ,XTS,                         .ERROR FLAG TO MAGAZINE
          13,UJ ,                         .EXIT
 WRTENTRY:  5,VTM, CATALOG+2
 5,XTA,2045
           7,AEX,CAL7-L                   .
            ,UZA,LER3                     .OVERFLOW OF CATALOG
 14,VTM,3 774B
         : 5,UTC,                         .SHIFT CATALOG
          14,XTA,-1                       .
           5,UTC,                         .
          14,ATX,1                        .
          14,UTM,-1                       .
          14,V1M,*-2                      .
           7,XTA,STR-L                    .
           5,ATX,                         .WRITE NAME OF ENTRY
           7,XTA,STR1-L                   .
           5,ATX,1                        .WRITE INF.WORD OF ENTRY
             ,ITS, 1                      .
             ,XTS,                        .
            5,MTJ, 1                      .
            1,UTM, 2                      .
 CHKCYCL :  5,XTA,                        .
            1,AEX,                        .
             ,UZA, ENTRYCH                .
            1,XTA, 1                      .
            7,AEX, CAL7-L                 .
             ,UZA, CHKEXIT                .
            1,UTM, 2                      .
             ,UJ,  CHKCYCL                .
 CHKEXIT :   ,STX,                        .
             ,STI, 1                      .
             ,UJ , WRTENT1                .
 ENTRYCH :  1,XTA, 1                      .
            7,AAX, LIBMASK-L              .
             ,UZA, REWRCAT                .
            1,XTA, 3                      .
            7,AAX, LIBMASK-L              .
             ,U1A, REWRCAT                .
            1,XTA, 1                      .
            7,AAX, MA3LC-L                .
            1,AOX, 3                      .
            1,ATX, 3                      .
 REWRCAT :  1,XTA, 2                      .
            1,ATX,                        .
            1,XTA, 3                      .
            1,ATX, 1                      .
            7,AEX, CAL7-L                 .
             ,UZA, CHKEXIT1               .
            1,UTM, 2                      .
             ,UJ,  REWRCAT                .
 CHKEXIT1:  1,ATX, 3                      .
             ,UJ,  CHKEXIT                .
 WRTENT1 :   ,XTA, LDRM                   .               AFTER 35WL253
           5,ATX, -2
         :12,UJ ,                         .
 LER1    :14,VTM,TER1                     .
            ,UJ ,PLER                     .
 LER2    :14,VTM,TER2                     .
            ,UJ ,PLER                     .
 LER3    :14,VTM,TER3                     .
            ,UJ ,PLER                     .
 PLER    : 7,XTA,C1-L                     .
           7,ATX,ERRFL-L                  .
            ,ITS,14                       .
          14,UTM,4                        .
            ,ITS,14                       .
            ,ITS,                         .
          13,VTM,EXIT                     .
            ,UJ ,PRINT8                   .
cRDWRCTL:,BSS,
C.....   П/П ЧTEHИЯ-ЗAПИCИ KATAЛOГA TL
C     C KOHTPOЛEM HA KOHEЦ KATAЛOГA (BCE 7)
C     HA CYMM.= HAЧ.CЛOBO ЧTEHИЯ(ЗAПИCИ) Э70
C         ИP5 = CATALOG
c7,ATX,WL-L
c8,VTM,1-8.ЗOH KATAЛOГA
cNEXT:,BSS,
c10,VTM,-511
c7,*70,WL-L
cECTL:5,XTA,1
c7,AEX,CAL7-L
c13,UZA,.HAШЛИ KOHEЦ
c5,UTM,2
c10,VLM,ECTL
C.....   HA ЭTOM ЛИCTE KOHЦA HET,БEPEM CЛEД.
c7,XTA,WL-L
c7,ARX,CEX-L
c7,ATX,WL-L
c8,VLM,NEXT
C.....   HET KOHЦA BO BCEX 8 ЛИCTAX KATAЛOГA
c13,UJ,.HE 0 HA CYMM.
 TER1:,ISO,30HПEPEПOЛHEHA TAБЛИЦA OПИCAHИЙ
 TER2:,ISO,30HПEPEПOЛHEHИE БИБЛИOTEKИ
 TER3:,ISO,30HПEPEПOЛHEHИE KATAЛOГA
cTER4:,ISO,30HИCПOPЧEH KATAЛOГ TEMPORARY LIB
 MA4S    :  ,OCT,0000 0000 0000 7777      .
 MA3L    :  ,OCT,0000 0000 0007 7777      .
 C2      :  ,OCT,0000 0000 0000 0002      .
 MSGP    :   ,OCT, 0000 0000 0000 1740
 MSEG    :   ,OCT, 0000 0000 7777 7740
 MRES    :   ,OCT, 0000 0000 0000 0037
 MOVL    :  ,OCT,7777 7777 7777 6000      .
 CAL7    :  ,OCT,7777 7777 7777 7777      .
 C1S     :   ,OCT, 0000 0000 0000 0040
 MSGN    :  ,OCT,4000 0000 0000 0000      .
 C3      :  ,OCT,0000 0000 0000 0003      .
 CRED    :  ,OCT,0010 0000 0000 0000      .
 C1      :  ,OCT,0000 0000 0000 0001      .
 C1P     :  ,OCT,0000 0000 0000 2000      .
 MUNP    :   ,OCT, 0000 0000 0077 0037
 MNPG    :  ,OCT,0000 0000 0000 1777      .
 CCAT    :   ,OCT, 2000 0000 0000 0000
 DRMX    :  ,OCT,0000 0000 0300 0000      .
 MSTR    :  ,OCT,7000 0000 0000 0000      .
 MA3LC   :   ,OCT, 7777 7777 7770 0000    .
 LIBMASK :   ,OCT, 5777 7700 0000 0000    .
 MDEFOVL :  ,OCT, 7777 7777 7777 4000     .
 N3      :   ,OCT,                        .              AFTER 5WL306
 N2      :  ,OCT,                         .
 LBOD    :  ,OCT,                         .
 LBSS    :  ,OCT,                         .
 R       :  ,OCT,                         .
 K       :  ,OCT,                         .
 L1      :  ,OCT,                         .
 K1      :  ,OCT,                         .
 DRLT    :  ,OCT,                         .
 N       :  ,OCT,                         .
 NPR     :  ,OCT,                         .
 PRCT    :  ,OCT,                         .
 DRMC    :  ,OCT,                         .
 NSEG    :  ,OCT,                         .
 ADR     :  ,OCT,                         .
 PGCT    :  ,OCT,                         .
 ERRFL   :  ,OCT,                         .
 STR     :  ,OCT,                         .
 STR1    :  ,OCT,                         .
 STR2    :  ,OCT,                         .
 STR3    :  ,OCT,                         .
 STR4    :  ,OCT,                         .
 STR5    :  ,OCT,                         .
 STR6    :  ,OCT,                         .
 STR7    :  ,OCT,                         .
 STR10   :  ,OCT,                         .
 STR11   :  ,OCT,                         .
 CEX     :   ,OCT, 0000 0100 0000 0001
 WL      :   ,OCT,
 NLIS    :   ,OCT, 7777 4077 7777 7777
 WCAT    :   ,OCT,
 RCAT    :   ,OCT,
    ,END,
