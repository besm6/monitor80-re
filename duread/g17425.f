*ftn
*optim
      integer function g17425(i)
      common /d10213/ line(8)
      k = i .shift. 8
      k = k .and. 17740000000000b
      do 1 n = 1,8
         m = line(n)
         if (m .eq. '( )') goto 1
         m = m .and. 17740000000000b
         if(k .eq. m) goto 2
  1   continue
      g17425 = -1
      return
  2   g17425 = n-1
      end
*assem
