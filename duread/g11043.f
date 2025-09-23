*ftn
      subroutine g11043(ia1, ia2, ia3)
      integer i0063, i0064, i0065, i0066, i0067
      dimension ia2(13)
      call RCATAL(ia1)
      call g15506(ia1)
      call g15654(ia1, ia2(2), i0063, ia2(13), i0064,
     *                 ia2(8), i0065, ia2(9), i0066)
      if(i0066.eq.0B) goto 34
      call g15700(ia1, i0067)
      if(ia2(1).ne.'*LIB') goto 30
      ia2(3) = i0067
 30   if (i0067.ne.ia2(3)) goto 41
      ia3 = 1
      return
 34   ia2(1) = ' HET :'
      ia3 = 2
      ia2(3) = 0B
      return
 41   ia2(1) = 'ОШИБ.П'
      ia2(2) = 'АРОЛЬ:'
      ia2(4) = 0B
      ia3 = 3
      end
*assem
