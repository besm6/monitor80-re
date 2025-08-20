*ftn
        subroutine newsxx(nuzzzz)
        integer i,j,lines,lim,icard(25),k265(2),k267(5)
        call rbegin(nuzzzz)
        call recard(icard)
        i=icard(2)
        if(icard(1).ne.'*news$') return
        if(i.ne.'      ')goto 27
   13   call recard(icard)
        if(icard(1).eq.'*read '.and.icard(2).eq.'old   ')goto 143
        print 8,(icard(i),i=1,11)
    8   format (' *NEWS',4X,11A6,' NEWS*')
        goto 13
   27   k265(1)=icard(3)
        k265(2)=icard(4)
        do 32 i=1,5
   32   k267(i)=icard(i+4)
        call datapr
        lines=1
        print 7
    7   format (62(1H-))
        lines=2
   43   call recard(icard)
        if(icard(1).eq.'*read '.and.icard(2).eq.'old   ')goto 64
        print 6,(icard(i),i=1,10)
    6   format (1HI,10A6,1HI)
        if(lines.eq.61)goto 107
        lines=lines+1
        goto 43
   64   lines=lines+1
        lim=60
        if(lines.lt.28)lim=28
        if (lines.lt.15)lim=15
        do 106 j=lines,lim   
        print 5
    5   format (1HI,60X,1HI)
  106   continue
  107   print 4
    4   format ('I--------+-----------+',39(1H-),1HI)
        print 3
    3   format ('I  HOMEP I ДATA HOB. I',39X,1HI)
        print 2,k267
    2   format ('I--------+-----------+',4X,5A6,5X,1HI)
        print 1,i,k265
    1   format ('I ',A6,' I ',A6,A4,'I ',39X,1HI)
        print 7
        call newlis
  143   return
        end
*assem
