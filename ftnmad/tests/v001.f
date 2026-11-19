      PROGRAM V001
      DIMENSION F(2)
      DATA F /6H(F5.1), 1H /
      PRINT F, 1.0
      STOP
      END
      SUBROUTINE F1(V, N, KF)
      DIMENSION V(5), F(4), KF(3), G(2,3)
      DATA F /6H(F5.1,, 6H I3)  , 2*1H /
      X = 1.5
      PRINT F, X, N
      PRINT F
      READ F, X
      WRITE (6, F) X, (V(I), I = 1, 3)
      READ (N, F) V
      PUNCH KF, N
      WRITE (N, KF) X
      PRINT G, X
      ENCODE (20, F, V) X
      DECODE (N, KF, V) X
      PRINT F(2), X
      RETURN
      END
      SUBROUTINE F2(PF, N, KF)
      DIMENSION PF(N), KF(3), F(4)
      COMMON /CF/ CF(5), K
      DOUBLE PRECISION D
      PRINT PF, N
      READ (5, CF) D, K
      WRITE (K, CF(2)) N, (F(I), I = 1, N)
      READ KF(2), K
      PRINT F(N), N
      WRITE (6, PF(N+1)) K
      ENCODE (K, PF, F(2)) K
      RETURN
      END
      SUBROUTINE F3(N)
      X = 1.0
      PRINT X, N
      RETURN
      END
      SUBROUTINE F4(N)
      DIMENSION KF(3), KB(4)
      COMMON KC
      WRITE (N, KF(2)) N
      PRINT KX, N
      READ (N, KX) N
      PRINT KC, N
      ENCODE (N, KF(3), KB(2)) N
      ENCODE (N, KF(3), KB) N
      ENCODE (N, KX, B) N
      RETURN
      END
      SUBROUTINE C1
      PRINT 9, 1.0, 2, 1.5D0
    9 FORMAT (F5.1)
      RETURN
      END
