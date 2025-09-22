*ftn
      subroutine g12327(ia,ib,ic,id)
      external g17010
      integer g17010
      dimension ic(10)
      id=11
      call g13434(ia,ib,ic,id)
      if(id.ne.1)goto 31
      call g17001(ib,2)
      k=ic(10).and.7b
      if(k.eq.0b) call g17001(ib,0)
      m = g17010(ib,'NZON')
      call g17060(m,0,m)
      call g16676(ib,m,0)
 31   return
      end
*assem
