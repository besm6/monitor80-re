*ftn
      subroutine g20112(arg)
      common/buffer/BUF(1024)
      external g20510,getchr
      integer g20510,getchr
      integer POS,k241,WIDTH,k243,unused,ENDL,RESPON,k247,WORK,SECTOR
      integer CBEGIN,CEND
      integer CURC
      integer LINE(22),k310(1)
      data k241/-1/,WIDTH/128/,k243/146B/,unused/1002 0012 1002 0012B/
      data RESPON/0/,k247/0/,ENDL/7760 0000 0000 0012B/,LINE/21*' '/
      data LINE(14)/1002 0012 1002 0012B/
      data LINE(22)/1002 0012 1002 0012B/
 3    call g20461(WORK)
      if(WORK.eq.0)goto 157
 4    do 156 SECTOR=1,1024,256
         CBEGIN=6*SECTOR+7
         CEND=6*SECTOR+1530
         do 155 CURC=CBEGIN,CEND
            k310(1)=CURC-1
            POS=getchr(k310,BUF)-1
            if (IPOS.ne.-1)goto 45
            IPOS=POS+1
 42         IPOS=IPOS-1
            goto 67
 45         if(POS.lt.96) goto 64
            if(POS.eq.124)goto 157
            if(POS.eq.96)goto 156
            if(POS.lt.120)goto 101
            if(POS.lt.127)goto 104
            k241=POS-128
            if(k241.gt.WIDTH)k241=k241-WIDTH
            goto 107
 64         k243=g20510(POS)
 67         k241=k241+1
            if(k241.gt.WIDTH) k241=WIDTH
            LIM=k241
            call g20505(LIM,LINE,k243)
            goto 107
 101        POS=POS-96
            goto 112
 104        if(POS.ne.126)goto 107
            IPOS=-1
 107        POS=1
            if(k241.lt.WIDTH)goto 152
 112        ALFA=LINE(1).shift.8
            ALFA=ALFA.or.1000 0000 0000 0000B
            if (ALFA.eq.' *NAME')NM=1
            if(NM.ne.1)goto 146
            if(LINE(1).ne.'/////R')goto 130
            if(LINE(2).ne.'ESPON')goto 130
            if(RESPON.eq.1)goto 157
            RESPON=1
            k247=0
            goto 146
 130        k247=k247+1
            if(RESPON.ne.1)goto 142
            if(k247.gt.4)goto 142
            if(k247.le.2)goto 146
            LINE(1)=40b
            LINE(2)=0b
            LINE(3)=0b
 142        call printa(LINE(1),LINE(22),0)
 146        do 147 I=1,22
 147           LINE(I)=' '
            k241=-1
 152        if(IPOS.gt.0)goto 42
 155     continue
 156  continue
      goto 3
 157  LINE(1)='*read '
      LINE(2)='old   '
      call printa(LINE,LINE(2),0)
      LINE(1)='*end f'
      LINE(2)='ile   '
      call printa(LINE,LINE(2),0)
      call printa(ENDL, ENDL, 0)
      call g20560
      call g20677
      return
      end
*assem
