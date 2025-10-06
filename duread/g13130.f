*ftn
      subroutine G13130(iarg1, iarg2, iarg3)
      external G17425,G17010,G17542
      integer G17425,G17010,G17542
      integer i263,i264,i265,i266,i267,i270,i271,i272,i273,i274,i275
      integer i276,i277,i300,i301,i302,i303
      dimension iarg2(4)
      I263 = 1
      call G03765(iarg2(4), i264)
      if (I264.eq.-1) goto 23
      i300 = G17425(IARG2(3))
      if (i300.ge.0) goto 25
 15   IARG2(1) = '!TИП!:'
 17   IARG2(5) = 0B
      IARG3 = 4
      return
 23   IARG2(1) = '!OШИБ:'
      goto 17
 25   I301 = -1
      i265 = iarg2(3).shift.32
      i265 = i265.and.177b
      if (i265.ne.52b) goto 40
      i265 = iarg2(3).shift.-16
      i301 = G17425( I265 )
      if (i301.eq.-1)goto 15
 40   I266 = I264
 41   call gdisc(iarg1)
      call rcatal(iarg1)
      I267 = IARG2(2)
      if (IARG2(1) .ne. '*GFILE') goto 50
      I267 = '******'
 50   call G15511(iarg1,i267,i270,i271,i300,i272,i273,i274,i275)
      if (IARG2(1) .eq. '*DFILE') goto 214
      if (I275 .ne. 0b) goto 157
      if (I301 .ge. 0) goto 164
      call GIVENZ(iarg1, i274)
      if (I274 .eq. 0b) goto 201
      i273 = G17010( IARG1, 'NAC' )
      I270 = 0b
      I271 = 0b
      I272 = 0
      if (IARG2(4) .eq. '     0') goto 104
      i271 = G17542( 2 )
 104  if (IARG2(1) .ne. '*GFILE') goto 114
      I272 = 0
      I271 = IARG2(13)
      call SETIND(iarg1, i274, iarg2(12))
 114  call WCATWO(iarg1,iarg2(2),i270,i271,i300,i272,i273,i274,i276)
      if (I276 .eq. 0b) goto 206
 130  i266 = i266 - 1
      if (i266 .le. 0) goto 146
      call GIVENZ(iarg1, i277)
      if (I277 .eq. 0b) goto 201
      call SETREF(iarg1,i274,i277)
      if (I277 .eq. 0b) goto 201
      I274 = I277
      goto 130
 146  IARG2(1) = 'HOBЫЙ:'
 150  IARG3 = 1
      call WCATAL(iarg1)
 153  IARG2(3) = 0b
 9    call FDISC(iarg1)
      return
 157  if (I301 .ge. 0) goto 166
      IARG2(1) = '!ECTЬ:'
 162  IARG3 = 2
      goto 153
 164  IARG2(1) = '!HET!:'
      goto 162
 166  call G17777(iarg1)
      call SWCAT(iarg1,i267,i270,i271,i301,i272,i273,i274,i275)
      goto 146
 201  IARG2(1) = 'HET ЗO'
      IARG2(2) = 'H'
      IARG3 = 3
      goto 153
 206  IARG2(1) = '!БPEД:'
      IARG3 = 4
      goto 153
C===========================================
      entry G13342
C===========================================
      goto 41
 214  if (I275 .eq. 0b) goto 164
      call G20003(iarg1,i275)
      iarg2(1) = 'YHИЧT:'
      goto 150
      iarg2(1) = 'ЗAHЯT:'
      IARG3 = 3
      goto 153
      end
*assem
