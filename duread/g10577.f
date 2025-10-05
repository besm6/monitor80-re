*ftn
*optim
      subroutine G10577(iarg1, LOC, LINE, ires)
      external g15474
      integer g15474
      dimension LINE(7)
      common /D15336/ id1, id2, id3
      common /D15341/ id4
      integer ja, jb, jc, jd, je, jf, jg
      CALL G03765(LINE(4), JF)
      id4 = LINE(7)
      if (jf  .ne. -1) goto 17
 12   LINE(1) = 'OШИБK:'
      LINE(5) = 0b
      ires = 2
      return
 17   jg = 0
      if (LINE(1) .ne. '*CRCAT') goto 32
      if (LINE(2) .eq. '*DSPC') goto 26
      call G12512(LOC)
      goto 45
 26   ja = 1
      call g12432(LOC, ja)
      goto 157
 32   if (LINE(1) .eq. '*JSPC' .or. LINE(1) .eq. '*ESPC') goto 45
      if (LINE(5) .eq. ' ') goto 12
      CALL G03765(LINE(5), JG)
      if (JG .eq. -1) goto 12
 45   jb = LINE(2).shift.32
      jc = jb .and. 377b
      jd = jb .shift. 8
      if (jd .ne. 40b .or. jc. eq. 40b) goto 65
      CALL G15437(je, LINE(3), jb)
      ires = 'space'
 62   goto (107,116),jb
 65   if (JB .ne. 20040b) goto 107
      jb = LINE(3).shift.32
      if (jb .ne. 20040b) goto 101
      CALL G03765(LINE(3), id3)
      if (id3 .eq. -1) goto 12
      id2 = id3
      id1 = id3
      goto 107
 101  jb = LINE(2) .or. 1242 5000 0000 0000b
      LINE(2) = LINE(3)
      LINE(3) = jb
 107   CALL G15122(IARG1, LOC, LINE(2), jf, ires)
       if (IRES. eq. 0b) goto 133
 116   LINE = ' HET:'
       LINE(4) = 0b
       if (ires .ne. 'space') goto 125
       ires = 3
       return
 125   LINE(2) = ires
       LINE(3) = ' '
       ires = 4
       return
 133   if (LINE(1) .eq. '*SFILE' .or .LINE(1) .eq. '*WFILE') goto 157
       ja = 1
       if (LINE(1) .eq. '*JSPC' .or. LINE(1) .eq. '*CRCAT') goto 145
       ja = 2
 145   CALL G12432(LOC, JA)
       if (LOC .ne. 1) goto 161
       if (LINE(1) .eq. '*CRCAT') goto 157
       CALL RCATAL(LOC)
       ires = G15474(LOC)
       if (ires .ne. 0b) goto 173
 157   ires = 1
       return
 161   if (ires .eq. 4) goto 171
       LINE(1) = 'HET.P.'
 165   LINE(4) = 0b
       ires = 5
       return
 171   LINE(1) = 'OCB.Л:'
       goto 165
 173   LINE(1) = 'HE KT:'
       call g12512(LOC)
       goto 165
       end
*assem
