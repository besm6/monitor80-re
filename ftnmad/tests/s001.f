      PROGRAM S001
      F(Y) = Y*Y + 1.0
      G(Y, Z) = F(Y) - Z
      X = 2.0
      A = F(X)
      B = G(X, A) + F(2.5)
      STOP
      END
      SUBROUTINE S2(P, N)
      DIMENSION A(5)
      COMMON /B/ Q
      INTEGER K
      DATA A(1) /1.0/
      K(I, J) = I*J + N
      F(Y) = A(2) + Y + P + Q
      A(N) = F(P) + K(N, 2)
      RETURN
      END
      SUBROUTINE S3
      LOGICAL LF, L1, L2
      DOUBLE PRECISION DF, D1
      COMPLEX CF, C1
      INTEGER IR
      F1(X) = X + 1.0
      IR(I, J) = I + J
      LF(L1, L2) = L1 .AND. L2
      DF(D1, X) = D1 * X
      CF(C1) = C1 * C1
      F2(X, Y, Z) = X + Y * Z
      K = IR(1, 2)
      A = F1(2.0) + F2(A, A, A)
      RETURN
      END
      SUBROUTINE S4
      DIMENSION A(10), B(3,3)
      DOUBLE PRECISION D, DD, DG
      COMPLEX CC, CG
      LOGICAL LL, LG
      DG(DD, X) = DD + X
      CG(CC, I, X) = CC * I + X
      H(I) = I * 2 + Y
      P(X, Y) = H(2) * X + DG(D, Y) + SQRT(X)
      LG(X, LL) = X .GT. 1.0 .OR. LL
      Q(X) = X ** 2 - FN(X .GT. Y)
      X = 3.0
      Y = 1.0
      I = 2
      D = 1.5D0
      A(I) = H(I) + P(X, Y) + Q(Y)
      LL = LG(A(I), .TRUE.)
      CC = CG((1.0, 2.0), I, X)
      RETURN
      END
      SUBROUTINE S7
      F(K) = K + 1.0
      I = 1
      J = 1
      M = 1
   10 CALL SB(F(I), G(J), M)
   20 CALL SB(F(I))
   30 CALL SB(F(I), I)
      RETURN
      END
      SUBROUTINE S5(N)
      DOUBLE PRECISION D, DF, E
      INTEGER M(3)
      COMMON /C/ W
      DF(X) = D * X + E
      G(X, Y) = (X + Y) * (X - Y) / (X * Y + W)
      H(X) = G(X, X + 1.0) + G(X + 2.0, X * 3.0)
      IF (H(W) .GT. 0.0) GO TO 10
      M(N) = G(1.0, 2.0)
   10 E = DF(G(W, 1.5)) + DF(2.0)
      RETURN
      END
