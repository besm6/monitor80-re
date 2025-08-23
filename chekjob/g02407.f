      subroutine g02407(M)
      dimension M(100)
      integer k542, k543, k544, k545,k546,k547,k550
      integer k552(69)
      data d03537/'*DEFIN','DIRECT',':16;CR;CP;LP',10*' ',
     c'*DEFINDIRECT',':     ','LUN   ',
     c     '/R,RW MODE  /(0.. 777   )',5*' ','*DEFINE:TT',12*' '/
      data d03631/0B,' 35000',' 40000','    20',' ',0B,' 36000'/
      data k542/377 7777 7777B/
      common/d03520/d03520
      common/d03521/D03521(3),D03524,filler(10)
      common/d03537/d03537(42)
      common/d03611/D03611,D03612,D03613,D03614,D03615
      common/d03616/d03616(11)
      common/d03631/D03631(7)
      common/d03640/d03640(3),D03643
      integer d03521
      integer d03537,d03520,d03524,d03531,d03611,d03612,D03614,D03615
      integer d03616,d03631,d03640,d03643
      data k552/6H*NAME ,
     *120 2102 2000 0000B,
     *6H*PASS ,
     *2260 0000 0000 0000B,
     *6H*GRIF ,
     *2220 0000 0000 0000B,
     *6H*REPEA,
     *2220 0000 0000 0000B,
     *6H*RESPO,
     *1330 1000 0000 0000B,
     *6H*WAIT ,
     *120 2102 1000 0000B,
     *6H*TIME ,
     *710 2100 0000 0000B,
     *6H*LINE ,
     *110 0000 0000 0000B,
     *6H*PAGE ,
     *110 0000 0000 0000B,
     *6H*/////,
     *200 0000 0000 0000B,
     *6H*LIBRA,
     *130 2302 3023 0230B,
     *6H*ATAPE,
     *131 1220 2140 0000B,
     *6H*FTAPE,
     *431 1220 2140 0000B,
     *6H*LTAPE,
     *631 1220 2140 0000B,
     *6H*DISC ,
     *112 1621 6000 0000B,
     *6H*FILE ,
     *1220 1317 2150 0000B,
     *6H*CHECK,
     *120 1221 6226 0000B,
     *6H*TAPE ,
     *112 1601 2022 0200B,
     *6H*NEW  ,
     *110 1401 4112 0000B,
     *6H*DRUM ,
     *110 0000 0000 0000B,
     *6H*MEMO ,
     *100 1002 2000 0000B,
     *6H*PRIO ,
     *100 0000 0000 0000B,
     *6H*TELE ,
     *100 0000 0000 0000B,
     *6H*PRINT,
     *200 0000 0000 0000B,
     *6H*ASSIG,
     *0B,
     *6H*BLERR,
     *200 0000 0000 0000B,
     *6H*JSPC ,
     *130 2002 2022 0000B,
     *6H*JLIB ,
     *120 2202 3020 0000B,
     *6H*JFILE,
     *120 2202 2023 0200B,
     *6H*DUMON,
     *120 2202 2022 0220B,
     *6H*BUGJE,
     *112 2622 6000 0000B,
     *6H*BESM ,
     *110 2100 0000 0000B,
     *6H*MS   ,
     *110 2100 0000 0000B/
      d03520=0
      call G02016
      call G03702(k543)
      if(k543.eq.0b)goto 145
      if(M(10).eq.' ')goto 145
      k544 = 'card'.shift.16
      k545 = M(10).shift.16
      if(k544.eq.k545)goto 145
      k546=0
      if(M(7).ne.' ')goto100
      k546=1
      k544=M(9).shift.-16
      k544=k544.shift.16
      d03631(6)=k544.or.' '
      d03524=' '
      k544=M(9).shift.32
      k544=k544.and.7b
      k544=k544.shift.-8
      call g04005(k544,d03521(5))
      d03521(7)='R     '
      d03521(8)=' '
      d03631(5)=' '
C     aligning
c     call foo
 45   continue
      d03631(1)=M(10)
      d03521(1)='*DUMON'
      d03521(2)='*NAME '
      d03521(3)=d03631(6)
      d03521(6)=' '
      d03521(9)=d03631(5)
      d03521(10)=d03521(3)
      d03521(11)=d03521(5)
      d03521(12)=d03631(4)
      d03521(13)=' '
      d03521(14)=M(14)
      call G04022(D03521)
      if(d03631(4).eq.' ')goto 145
      if(k546.ne.0) goto 70
      call G04046
 70   call G04052
      d03521(1)='*respo'
      d03521(2)=d03631(2)
      d03521(3)=d03631(4)
      call G04175(d03521)
      call G02022
      goto 145
 100  continue
      if (M(4).ne.'*jfile')goto 125
      d03631(5)=M(5)
      d03521(7)=M(6)
      d03521(8)=M(7)
      M(7)='******'
      if(d03521(8).ne.'******')goto 115
      d03521(8)=' '
 115  continue
      d03631(6)=M(8)
      d03521(4)=' '
      d03521(5)=M(9)
      d03631(4)=M(11)
      goto 45
 125  continue
      M(4)=d03631(7)
      d03631(6)=M(4)
      d03521(4)=M(5)
      d03521(5)=M(6)
      d03521(7)=M(7)
      d03521(8)=M(8)
      M(8)='******'
      d03631(5)=M(9)
      d03631(4)=M(11)
      goto 45
 145  continue
      call clopen(k552,M,d03521,d03640)
      call G04635(d03537)
 153  call G02016
      d03520=d03520+1
      if(M(1).eq.'*     ')goto 244
      if(M(1).ne.'*check')goto 166
      k544=M(2).shift.40
      if(k544.ne.50b)goto 467
 166  call cldeco(d03640)
      if(d03521(1).ne.'=ERROR')goto 175
      d03615=1
      call G02017
      goto 244
 175  k547=d03643
      if(k547.eq.0)goto 467
 200  goto (242,242,242,242,253,242,242,242,242,242,255,242,242,242,260,
     c262,242,303,311,242,313,242,317,320,242,242,322,335,352,413,242,
     c242,242),k547
 242  goto 244
      entry G02652
 244  continue
      if(d03614.ne.0b) call printa(d03521(1),d03521(14),1)
      call G02022
      goto 153
 253  continue
      call G04175(d03521)
      goto 244
 255  continue
      call CHECK(d03521,d03615)
      goto 244
 260  continue
      call HANDLE(d03521)
      goto  244
 262  continue
      if (M(2).eq.'scratc') goto 244
      if(d03612.ne.0b) goto 271
      call G04720(d03521, k550)
      goto 274
 271  continue
      call HANDLE(d03521, k550)
 274  continue
      if(d03521(2).eq.'scratc')goto 244
      if(d03611.ne.0b)goto 301
      call G04052
 301  continue
      call G04066(k550)
      goto 244
 303  continue
      if(d03521(3).eq.'scratc')goto 244
      if(d03521(3).eq.' ')goto 244
      call G05011(d03521)
      goto 244
 311  continue
      call G05050(d03521)
      goto 244
 313  continue
      if(d03521(4).ne.'F     ')goto 244
      call G02034
      stop
 317  goto 244
 320  continue
      d03614=1
      goto 244
 322  continue
      d03616(1)=d03521(2)
      d03616(3)=d03521(3)
      d03616(2)=' '
      d03616(4)=' '
      if(d03521(4).eq.' ')goto 244
      d03616(5)=d03521(4)
      d03616(6)=d03521(5)
      goto 244
 335  continue
      do 337 k542=1,2
         d03616(k542+4)=d03521(k542+1)
 337  continue
      if (d03521(4).eq.' ')goto 244
      d03616(1)=d03521(4)
      d03616(3)=d03521(5)
      d03616(2)=' '
      d03616(4)=' '
      goto 244
 352  continue
      d03616(7) = d03521(2)
      if(d03521(3).eq.' ')goto 372
      do 360 k542=1,2
         d03616(k542+4)=d03521(k542+2)
 360  continue
      if(d03521(5).eq.' ')goto 372
      d03616(1)=d03521(5)
      d03616(3)=d03521(6)
      d03616(2)=' '
      d03616(4)=' '
 372  continue
      d03521(1)='*DUMON'
      d03521(2)='*WRITE'
      do 376 k542=1,7
         d03521(k542+2)=d03616(k542)
 376  continue
      d03521(10)=d03521(3)
      d03521(11)=d03521(5)
      d03521(12)=' '
      d03631(6)=d03521(10)
      call G02022
      call G04022(d03521)
      goto 153
 413  continue
      if(d03521(2).ne.'*RUN  ')goto 446
      call G02022
      M(1)=d03521(1)
      M(2)='*EXEC '
      if(d03521(6).ne.' ')goto 424
      d03521(6)=' 36000'
 424  continue
      M(3)=d03521(6)
      M(10)=d03521(6)
      M(4)=' '
      M(5)=' '
      M(6)=' '
      M(11)=' '
      M(7)=d03521(4)
      M(8)=d03521(5)
      M(9)=d03521(3)
      call G02022
      d03520=0
      goto 456
 446  continue
      M(10)=d03631(7)
      if(d03631(5).ne.' ')goto 453
      call g02022
      goto 456
 453  continue
      d03520=-d03520
 456  continue
      d03631(6)=M(10)
      call G04022(M)
      if(d03615.eq.0b)goto 464
      stop
 464  goto 503
C perhaps unused
 465  call G05065(d03521)
      goto 244
 467  if(d03615.eq.0b)goto 472
      stop
 472  continue
      if(d03631(5).eq.' ')goto 503
      d03520=-d03520
      d03521(1)='*DUMON'
      d03521(2)='*NAME '
      call G04022(d03521)
 503  call G04116
      return
      end
