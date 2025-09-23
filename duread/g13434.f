*ftn
      subroutine G13434(LA164, LA165, LA166, LA167)
      dimension LA166(14)
      L170 = 1
      goto 7
      ENTRY G13441
      L170 = 0
 7    L171 = LA167
      call RCATAL(LA164)
      call G15511(LA164,LA166(2),La166(12),LA166(13),LA166(10),
     *     LA166(11),LA166(14),LA166(8),L172)
      L173 = LA166(10)
      if (L172.ne.0B) goto 40
      LA166 = '  HET:'
 34   LA166(3) = 0B
      LA167 = 2
      return
 40   if (L170.eq.0) goto 140
      call G20042(LA164,LA166(2),LA166(9))
      if(LA167.ge.110)goto 130
      if(LA167.lt.100)goto 57
      L171 = LA167-100
      if (L171.ne.L173) goto 62
      goto 130
 57   if (L171.ge.10) goto 64
      if (L171.eq.L173) goto 64
 62   LA166 = '!!ТИП:'
      goto 34
 64   if (LA166(11).ne.511) goto 70
      LA166(11) = 0
 70   LA166(11) = LA166(11) + 1
      call G17777(LA164)
      call SWCAT(LA164,LA166(2),LA166(12),LA166(13),LA166(10),
     *     LA166(11),LA166(14),LA166(8),L172)
      call WCATAL(LA164)
      call G20103(LA164,LA165,LA166(2))
      L172 = 0
      call G12432(LA165,L172)
      L172 = LA165
 123  goto (130,132,134,136),L172
 130  LA167 = 1 $ return
 132  LA166 = 'НЕТ Л:' $ goto 34
 134  LA166 = 'НЕТ Р:' $ goto 34
 136  LA166 = 'ОСВ.Л.' $ goto 34
 140  LA167 = 4
      call G14747(LA165)
      call G12512(LA165)
      goto 130
      end
*assem
