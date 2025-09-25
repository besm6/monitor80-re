*ftn
*optim
      subroutine g15342(iarg1,iarg2,iarg3)
      dimension iarg1(17),iarg2(2)
      common /D06757/ id1, id2, id3
      common /D21123/ i123(17)
      integer i,l,j
      iarg3 = 1
      call g03270(iarg2,i)
      if (i .le. 0) iarg3 = 2
      do 14 l=1,17
         i123(l) = 0b
 14      iarg1(l) = 0b
      return
      entry g15362
      i = iarg2(1)
      j = iarg2(2)
      iarg3 = 1
      if (id2 .ne. 0b) goto 41
      if (j .eq. id1 .or. j .eq. id3) return
 34   iarg2(1) = 0b
      iarg2(2) = iarg2(1)
      iarg3 = 2
      return
 41   if (i123.ne.0b) goto 53
      call g21144(i123,iarg1)
      call g21154(i123)
      if (i123.ne.0b) goto 53
      iarg3 = 2
      return
 53   if (j.eq.id1 .or. j .eq. id3) return
 60   call g21211(i123,iarg1,i,j)
      if (j .eq. 0b) goto 34
      call g21277(iarg1,'t',i)
      if (i .ne. 0b) return
      iarg3 = 3
      return
      entry g15437
      iarg3 = 1
      if (iarg2(1).eq.id1) return
      iarg3 = 2
      return
      entry g15447
      iarg3 = 1
      if (iarg2(1) .eq.'  1001') return
      iarg3 = 2
      return
      end
*assem
