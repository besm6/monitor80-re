*ftn
*no opt
      integer function strlen(iarg)
      integer i,byte,ret,m(14)
      call g03757(iarg,m)
      do 6 i=1,14
         byte=m(i).and.377b
         ret=i
         if(byte.eq.12b)goto 17
 6    continue
 17   strlen=ret
      return
      end
*assem
