*FTN
C     The argument is MONCARD*
      subroutine g02407(M)
      dimension M(14)
      integer k542, k543, k544, k545,k546,k547,k550
      integer k552(69)
      data DFLT/'*DEFINDIRECT:16;CR;CP;LP',10*' ',
     c'*DEFINDIRECT',':     ','LUN   ',
     c     '/R,RW MODE  /(0.. 777   )',5*' ','*DEFINE:TT',12*' '/
      data NUZ2/' 35000',' 40000','    20',' '/,NUZ7/' 36000'/
      data k542/377 7777 7777B/
      common/LINENO/LINENO
      common/CARD/CARD(14)
      common/DFLT/DFLT(42)
      common/FLAGS/D03611,D03612,D03613,PRIOFL,ERROR
      common/d03616/d03616(11)
      common/NUZZZZ/NUZ1,NUZ2,NUZ3,NUZ4,NUZ5,NUZ6,NUZ7
C     CLARG is an argument to CLOPEN and CLDECO
      common/CLARG/CLARG(4)
      integer CARD
      integer DFLT,LINENO,d03611,d03612,PRIOFL,ERROR
      integer d03616,CLARG,dummy
      data k552/6H*NAME ,
     *0120 2102 2000 0000B,
     *6H*PASS ,
     *2260 0000 0000 0000B,
     *6H*GRIF ,
     *2220 0000 0000 0000B,
     *6H*REPEA,
     *2220 0000 0000 0000B,
     *6H*RESPO,
     *1330 1000 0000 0000B,
     *6H*WAIT ,
     *0120 2102 1000 0000B,
     *6H*TIME ,
     *0710 2100 0000 0000B,
     *6H*LINE ,
     *0110 0000 0000 0000B,
     *6H*PAGE ,
     *0110 0000 0000 0000B,
     *6H*/////,
     *0200 0000 0000 0000B,
     *6H*LIBRA,
     *0130 2302 3023 0230B,
     *6H*ATAPE,
     *0131 1220 2140 0000B,
     *6H*FTAPE,
     *0431 1220 2140 0000B,
     *6H*LTAPE,
     *0631 1220 2140 0000B,
     *6H*DISC ,
     *0112 1621 6000 0000B,
     *6H*FILE ,
     *01220 1317 2150 0000B,
     *6H*CHECK,
     *0120 1221 6226 0000B,
     *6H*TAPE ,
     *0112 1601 2022 0200B,
     *6H*NEW  ,
     *0110 1401 4112 0000B,
     *6H*DRUM ,
     *0110 0000 0000 0000B,
     *6H*MEMO ,
     *0100 1002 2000 0000B,
     *6H*PRIO ,
     *0100 0000 0000 0000B,
     *6H*TELE ,
     *0100 0000 0000 0000B,
     *6H*PRINT,
     *0200 0000 0000 0000B,
     *6H*ASSIG,
     *0B,
     *6H*BLERR,
     *0200 0000 0000 0000B,
     *6H*JSPC ,
     *0130 2002 2022 0000B,
     *6H*JLIB ,
     *0120 2202 3020 0000B,
     *6H*JFILE,
     *0120 2202 2023 0200B,
     *6H*DUMON,
     *0120 2202 2022 0220B,
     *6H*BUGJE,
     *0112 2622 6000 0000B,
     *6H*BESM ,
     *0110 2100 0000 0000B,
     *6H*MS   ,
     *0110 2100 0000 0000B/
      LINENO=0
      call MONRED
      call START(k543)
      if(k543.eq.0b)goto 145
      if(M(10).eq.' ')goto 145
      k544 = 'CARD'.shift.16
      k545 = M(10).shift.16
      if(k544.eq.k545)goto 145
      k546=0
      if(M(7).ne.' ')goto100
      k546=1
      k544=M(9).shift.-16
      k544=k544.shift.16
      NUZ6=k544.or.' '
      CARD(4)=' '
      k544=M(9).shift.32
      k544=k544.and.7b
      k544=k544.shift.-8
      call g04005(k544,CARD(5))
      CARD(7)='R     '
      CARD(8)=' '
      NUZ5=' '
 45   continue
      NUZ1=M(10)
      CARD(1)='*DUMON'
      CARD(2)='*NAME '
      CARD(3)=NUZ6
      CARD(6)=' '
      CARD(9)=NUZ5
      CARD(10)=CARD(3)
      CARD(11)=CARD(5)
      CARD(12)=NUZ4
      CARD(13)=' '
      CARD(14)=M(14)
      call DUMON(CARD)
      if(NUZ4.eq.' ') goto 145
      if(k546.eq.0) call G04046
      call G04052
      CARD(1)='*respo'
      CARD(2)=NUZ2
      CARD(3)=NUZ4
      call G04175(CARD)
      call PRCARD
      goto 145
 100  continue
      if (M(4).ne.'*jfile')goto 125
      NUZ5=M(5)
      CARD(7)=M(6)
      CARD(8)=M(7)
      M(7)='******'
      if(CARD(8).eq.'******') CARD(8)=' '
      NUZ6=M(8)
      CARD(4)=' '
      CARD(5)=M(9)
      NUZ4=M(11)
      goto 45
 125  continue
      M(4)=NUZ7
      NUZ6=M(4)
      CARD(4)=M(5)
      CARD(5)=M(6)
      CARD(7)=M(7)
      CARD(8)=M(8)
      M(8)='******'
      NUZ5=M(9)
      NUZ4=M(11)
      goto 45
 145  continue
      call clopen(k552,M,CARD,CLARG)
C     A dummy call, does nothing
      call EMPTY(DFLT)
 153  call MONRED
      LINENO=LINENO+1
      if(M(1).eq.'*     ')goto 244
      if(M(1).ne.'*check')goto 166
      k544=M(2).shift.40
      if(k544.ne.50b)goto 467
 166  call cldeco(CLARG)
      if(CARD(1).ne.'=ERROR')goto 175
      ERROR=1
      call PRERR
      goto 244
 175  k547=CLARG(4)
      if(k547.eq.0)goto 467
 200  goto(242,242,242,242,253,242,242,242,242,242,
     c     255,242,242,242,260,262,242,303,311,242,
     c     313,242,317,320,242,242,322,335,352,413,
     c     242,242,242),k547
C     26: *BLERR, 33: *MS
 242  goto 244
      entry G02652
 244  continue
      if(PRIOFL.ne.0b) call printa(CARD(1),CARD(14),1)
      call PRCARD
      goto 153
C *RESPO
 253  continue
      call G04175(CARD)
      goto 244
C *LIBRA
 255  continue
      call CHECK(CARD,ERROR)
      goto 244
C *DISC - immediate termination here
 260  continue
      call HANDLE(CARD)
      goto  244
C *FILE
 262  continue
      if (M(2).eq.'scratc') goto 244
      if(d03612.ne.0b) goto 271
      call G04720(CARD, k550)
      goto 274
 271  continue
      call HANDLE(CARD, k550)
 274  continue
      if(CARD(2).eq.'scratc')goto 244
      if(d03611.eq.0b) call G04052
      call G04066(k550)
      goto 244
C     *TAPE
 303  continue
      if(CARD(3).eq.'scratc')goto 244
      if(CARD(3).eq.' ')goto 244
      call G05011(CARD)
      goto 244
C     *NEW
 311  continue
      call G05050(CARD)
      goto 244
 313  continue
      if(CARD(4).ne.'F     ')goto 244
      call G02034
      stop
C     23: *TELE
 317  goto 244
C     *PRIO
 320  continue
      PRIOFL=1
      goto 244
C     *ASSIG
 322  continue
      d03616(1)=CARD(2)
      d03616(3)=CARD(3)
      d03616(2)=' '
      d03616(4)=' '
      if(CARD(4).eq.' ')goto 244
      d03616(5)=CARD(4)
      d03616(6)=CARD(5)
      goto 244
C     *JLIB
 335  continue
      do 337 k542=1,2
         d03616(k542+4)=CARD(k542+1)
 337  continue
      if (CARD(4).eq.' ')goto 244
      d03616(1)=CARD(4)
      d03616(3)=CARD(5)
      d03616(2)=' '
      d03616(4)=' '
      goto 244
C     *JSPC
 352  continue
      d03616(7) = CARD(2)
      if(CARD(3).eq.' ')goto 372
      do 360 k542=1,2
         d03616(k542+4)=CARD(k542+2)
 360  continue
      if(CARD(5).eq.' ')goto 372
      d03616(1)=CARD(5)
      d03616(3)=CARD(6)
      d03616(2)=' '
      d03616(4)=' '
 372  continue
      CARD(1)='*DUMON'
      CARD(2)='*WRITE'
      do 376 k542=1,7
         CARD(k542+2)=d03616(k542)
 376  continue
      CARD(10)=CARD(3)
      CARD(11)=CARD(5)
      CARD(12)=' '
      NUZ6=CARD(10)
      call PRCARD
      call DUMON(CARD)
      goto 153
C     30: *DUMON
 413  continue
      if(CARD(2).ne.'*RUN  ')goto 446
      call PRCARD
      M(1)=CARD(1)
      M(2)='*EXEC '
      if(CARD(6).eq.' ') CARD(6)=' 36000'
      M(3)=CARD(6)
      M(10)=CARD(6)
      M(4)=' '
      M(5)=' '
      M(6)=' '
      M(11)=' '
      M(7)=CARD(4)
      M(8)=CARD(5)
      M(9)=CARD(3)
      call PRCARD
      LINENO=0
      goto 456
 446  continue
      M(10)=NUZ7
      if(NUZ5.ne.' ')goto 453
      call PRCARD
      goto 456
 453  continue
      LINENO=-LINENO
 456  continue
      NUZ6=M(10)
      call DUMON(M)
      if(ERROR.ne.0b) stop
      goto 503
C perhaps unused
 465  call G05065(CARD)
      goto 244
 467  if(ERROR.ne.0b) stop
      if(NUZ5.eq.' ')goto 503
      LINENO=-LINENO
      CARD(1)='*DUMON'
      CARD(2)='*NAME '
      call DUMON(CARD)
 503  call G04116
      return
      end
*ASSEM
