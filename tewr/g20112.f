*ftn
      subroutine g20112(arg)
c     This subroutine processes a buffer to decode and print lines of text,
c     handling special codes for formatting, repetition, and control sequences.
c     It loops until the buffer is empty or a termination condition is met.
      common/buffer/BUF(1024)
c     External functions for retrieving character codes and positions
c     from the buffer.
      external g20510,getchr
      integer g20510,getchr
c     Variables for tracking position, width, codes, flags, and buffer sections.
      integer codpos, column, linwid, chrcod, unuspt, endlin
      integer inresp, seccnt, bufsta, sector
      integer secbeg, secend
      integer curidx, repidx
      integer linbuf(22), tmpidx(1)
c     Initialize constants: starting column, line width, default char code,
c     unused pattern, response flag, section count, end line marker,
c      and line buffer.
      data column/-1/, linwid/128/, chrcod/146B/
      data unuspt/1002 0012 1002 0012B/
      data inresp/0/, seccnt/0/, endlin/7760 0000 0000 0012B/
      data linbuf/21*' '/
      data linbuf(14)/1002 0012 1002 0012B/
      data linbuf(22)/1002 0012 1002 0012B/
c     Main loop: Check if buffer has content; exit if empty.
 3    call g20461(bufsta)
      if(bufsta.eq.0)goto 157
c     Process buffer in sectors (chunks of 256), from 1 to 1024.
 4    do 156 sector=1,1024,256
c        Compute start and end indices for the current sector.
         secbeg=6*sector+7
         secend=6*sector+1530
c        Iterate over each index in the sector to decode codes.
         do 155 curidx=secbeg,secend
c           Prepare temp index for function call.
            tmpidx(1)=curidx-1
c           Retrieve and adjust code position from buffer.
            codpos=getchr(tmpidx,BUF)-1
            if (repidx.ne.-1)goto 45
c           Handle invalid position by setting repeat index and skipping
c            to insertion logic.
            repidx=codpos+1
 42         repidx=repidx-1
            goto 67
 45         if(codpos.lt.96) goto 64
            if(codpos.eq.124)goto 157
            if(codpos.eq.96)goto 156
            if(codpos.lt.120)goto 101
            if(codpos.lt.127)goto 104
c           Decode column adjustment codes (128+), wrapping if exceeds width.
            column=codpos-128
            if(column.le.linwid)goto 63
            column=column-linwid
 63         goto 107
 64         chrcod=g20510(codpos)
 67         column=column+1
            if(column.gt.linwid) column=linwid
c           Insert character into line buffer at current position.
            inspos=column
            call g20505(inspos,linbuf,chrcod)
            goto 107
 101        codpos=codpos-96
            goto 112
 104        if(codpos.ne.126)goto 107
            repidx=-1
 107        codpos=1
            if(column.lt.linwid)goto 152
c           Check if line is full; process special prefixes like '*NAME'
c           for response handling.
 112        prefix=linbuf(1).shift.8
            prefix=prefix.or.1000 0000 0000 0000B
            if (prefix.eq.' *NAME')isname=1
            if(isname.ne.1)goto 146
            if(linbuf(1).ne.'/////R')goto 130
            if(linbuf(2).ne.'ESPON')goto 130
            if(inresp.eq.1)goto 157
c           Detect start of response section and reset counter.
            inresp=1
            seccnt=0
            goto 146
 130        seccnt=seccnt+1
            if(inresp.ne.1)goto 142
            if(seccnt.gt.4)goto 142
            if(seccnt.le.2)goto 146
c           Clear initial parts of line buffer for specific response lines.
            linbuf(1)=40b
            linbuf(2)=0b
            linbuf(3)=0b
c     Print the constructed line.
 142        call printa(linbuf(1),linbuf(22),0)
c     Reset line buffer and column for next line.
 146        do 147 I=1,22
 147           linbuf(I)=' '
            column=-1
c     Handle repeat logic if applicable.
 152        if(repidx.gt.0)goto 42
 155     continue
 156  continue
      goto 3
c     Upon completion or termination, print final messages and end markers.
 157  linbuf(1)='*read '
      linbuf(2)='old   '
      call printa(linbuf,linbuf(2),0)
      linbuf(1)='*end f'
      linbuf(2)='ile   '
      call printa(linbuf,linbuf(2),0)
c     Print end line and call cleanup routines.
      call printa(endlin, endlin, 0)
      call g20560
      call g20677
      return
      end
*assem
