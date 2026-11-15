      SUBROUTINE Q
      COMMON /CC/ U, V(3)
      COMMON W
      DATA Z /1.5/, K /3/
      CALL R(U, V(2), 3, Z+1.0)
      PRINT 5, K
    5 FORMAT (I5)
      END
