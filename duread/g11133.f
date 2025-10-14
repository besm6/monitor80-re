*ftn
*optim
      subroutine G11133(iarg1, iarg2, iarg3, iarg4)
      common/D10213/ D10213(8)
      common/D10223/D10223
      common/D10273/D10273(38)
      common/D10341/D10341(3)
      common/D10530/D10530(14)
      common/NUZZZZ/NUZ1,nuz2,nuz3,nuz4,nuz5,nuz6
      common/D15704/D15704
      common/D15705/D15705(257)
      common/D16306/D16306,D16307
      common/D16310/D16310(64)
      data D15704/256/
      integer d10213,d10223,d10273,d10341,d10530,d15704,d15705
      integer d16306,d16307,d16310
      external g16410,g16453
      integer g16410,g16453
      dimension iarg1(10),iarg3(10)
      if (IARG3(6) .ne. NUZ6) goto 11
      IARG3(1) = '!ЗAKP.'
      IARG3(2) = 'MAT.N:'
      goto 212
 11   call G13026(iarg1)
      I37 = IARG1(1)
      if (IARG3(6) .ne. ' ') goto 26
      if (NUZ3 .ne. 0B) goto 23
      IARG3(1) = 'ДYБЛЬ:'
      IARG3(2) = 'MAT.N:'
      goto 212
 23   continue
      IARG3(6) = nuz3
      nuz3 = 0B
 26   continue
      i40 = G16410( IARG3(6) )
      I41 = (0)
      if (IARG3(7) .ne. 'R') goto 35
      I41 = 1
 35   continue
      I42 = 110
      if (iarg3(3) .eq. ' ') goto 60
      i43 = iarg3(3) .shift. 40
      do 56 i44 = 1,8
         i42 = i44 + 99
         i45 = d10213(i44) .shift.32
         i45 = i45 .and. 377b
         if (I43 .eq. I45) goto 60
 56   continue
      IARG3(1) = '!!TИП:'
      goto 214
 60   continue
      call G13434(iarg1, iarg2, iarg3, i42)
      if (I42 .ne. (1)) goto 214
      if (IARG3(9) .le. D15704) goto 73
      IARG3(1) = '!ДЛ.Ф.'
      IARG3(2) = '>400Z:'
      goto 212
 73   continue
      d16307 = d15704 + 1
      do 106 i44 = 1,d16307
         d15705(i44) = 0b
 106  continue
      call g16417(iarg1,iarg3(8),d15705)
      d16307 = 0
      i46 = 0
 114  continue
      I47 = -48
      I50 = 0B
 116  continue
      i51 = d15705(i46+1)
      if (I51 .eq. 0B) goto 136
      i47 = i47 + 12
      I51 = I51 .and. 7777B
      i51 = i51 .shift. i47
      I50 = I50 .or. I51
      i46 = i46 + 1
      if (I47 .ne. 0) goto 116
 136  continue
      if (I47 .eq. -48) goto 147
      d16307 = d16307 + 1
      d16310(d16307) = i50
      if (I47 .eq. (0)) goto 114
 147  continue
      d16307 = d16307 .and. 7777b
      d16307 = d16307 .or. 7000 0000b
      i52 = G16453( IARG1 )
      if (i52 .ne. 7777b) goto 157
      IARG3(1) = '*HET*'
      goto 214
 157  continue
      I53 = I52 .and. 77 0000b
      if (i53 .eq. 0b) goto 163
      I37 = I53
 163  continue
      i43 = i37 .shift. -18
      d16307 = d16307 .or. I43
      I54 = I52 .and. 7777B
      d16306 = i54 .shift. -24
      d16306 = d16306 .or. 7000 0000b
      d16306 = d16306 .or. i40
      i46 = 1024 - i46
      i46 = i46 .and. 7777b
      i46 = i46 .shift. -36
      d16306 = i46 .or. d16306
      i46 = i41 .shift. -47
      d16306 = d16306 .or. i46
      call G04052
      call G16512(d16306)
      call G12512(iarg2)
      IARG4 = (1)
      return
 212  IARG3(4) = 0B
 214  IARG4 = (2)
      return
C===========================================
      entry G11351
C===========================================
      NUZ1 = IARG3(2)
      I55 = IARG3(3)
 223  call G13130(iarg1, iarg3, i42)
      I43 = I42
      call IFPRIO
 230   goto (235,241,260,266),i42
 235   continue
      IARG3(2) = NUZ1
      IARG3(3) = I55
      goto 11
 241  call PRINTA(iarg3(1),iarg3(6),1)
      IARG3(1) = '*DFILE'
      call G13342(iarg1, iarg3, i42)
      if (I42 .ne. (1)) goto 214
      IARG3(1) = '*CFILE'
      IARG3(2) = NUZ1
      IARG3(3) = I55
      goto 223
 260  continue
      IARG3(2) = 'ЗOH :'
 262  continue
      IARG3(1) = '**HET'
      IARG3(3) = NUZ1
      goto 212
 266  continue
      IARG3(2) = '*DCB*:'
      goto 212
      end
*assem
