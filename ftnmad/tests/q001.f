      PROGRAM Q001
      DIMENSION A(5)
      DATA A /2H$A, 4*1.0/
   10 X = 1.0 $ Y = 2.0 $ GO TO 20
   20 Z = X + Y $ IF (Z .GT. 1.0) Z = 0.0 $ K = 1
      PRINT 30, X, Y $ X = 1.0
   30 FORMAT (1H$, 'A$B', F5.1 $ F5.1)
      DO 40 I = 1, 5 $ A(I) = A(I) + 1.0
   40 CONTINUE $ X = 3.0
      W = 1.0 $ V = W +
     1 2.0 $ U = V
      X = 1.0 $$ Y = 2.0
      STOP $ END
      SUBROUTINE DC
   30 FORMAT (F5.1 $ I5)
      PRINT 30, X $ X = 1.0
      STOP
      END
      SUBROUTINE DE
      X = 1.0 $$ Y = 2.0
      STOP
      END
      SUBROUTINE O1(N)
      DIMENSION A(5)
      LOGICAL L
      K = 77B
      J = K + 17B
      X = 7B
      Y = X + 10B
      A(3B) = 1.0
      L = 1B
      CALL S(77777B, 0B)
      M = 7777777777777777B
      K = -5B
      IF (K .GT. 12B) K = 0
      DO 10 I = 1B, 7B
   10 A(I) = 4B * A(I)
      RETURN
      END
      SUBROUTINE O2(N)
      DIMENSION A(5), B(3,3)
      I = 2
      A(2B*I) = A(I+1B) + A(1B)
      B(2B, I) = 1.0
      PRINT 9, (A(K), K = 1B, 5B)
    9 FORMAT (5F5.1)
      DO 10 J = I, 4B, 2B
   10 A(J) = 0B
      X = 4000000000000000B
      Y = -X + 17B * 2B
      RETURN
      END
      SUBROUTINE P1(F, G, X, N)
      Y = F(X)
      Z = F(X) + G(X, Y) * 2.0
      CALL G(Y)
      K = N + G(1)
      CALL S(F, X)
      W = SIN(F(Y))
      RETURN
      END
      FUNCTION P2(F, KF, LF, S, DF, CF, A, N)
      INTEGER KF
      LOGICAL LF
      DOUBLE PRECISION DF, D
      COMPLEX CF, C
      DIMENSION A(N)
      CALL S
      IF (LF(A(1))) CALL S(1)
      IF (F(A(2)) .GT. 0.0) GO TO 10
      K = KF(N) + KF(KF(N))
      D = DF(1.0D0) * 2.0D0
      C = CF(A(1), F(A(N)))
   10 DO 20 I = 1, N
   20 A(I) = F(A(I)) + KF(I)
      P2 = F(F(1.0))
      CALL S(F, KF, A(K), F(2.0))
      RETURN
      END
      SUBROUTINE P3(G, X, L)
      LOGICAL L, Q
      H(Y) = G(Y) + G(Y * 2.0)
      Z = H(X) + G(X)
      Q = L(X .GT. 1.0, Z)
      CALL G(X .GT. Z, X)
      RETURN
      END
