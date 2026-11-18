      PROGRAM D001
      DOUBLE PRECISION D, E, F(5), G(3,4)
      DIMENSION A(4)
      LOGICAL L
      D = 2.5D0
      E = 0.5D1
      X = 1.5
      I = 2
      J = 3
      A(1) = X
      F(I) = D * E - F(I+1) / D
      G(I,J) = F(J) + X * I
      E = -D + 2.0D0 ** 2
      D = E ** I
      X = D + X
      I = D
      E = I + J
      L = D .GT. E .OR. X .LT. D
      IF (D - E) 10, 20, 10
   10 D = DSQRT(E) + DABS(D)
   20 CALL SB(D, F(J), E + D)
      E = DFN(D, F) * A(I)
      X = SNGL(D) + 1.0
      D = DBLE(X) * 2.0D0
      STOP
      END
      SUBROUTINE D3
      DOUBLE PRECISION F(5), G(3,4), D, E, H(4)
      COMMON /B/ D, F
      EQUIVALENCE (F(2), X), (H(3), Y), (E, Z)
      DATA H /1.0D0, 2*0.5D0, 4.0D0/, E /0.5D0/
      I = 2
      J = 3
      F(I*J) = G(I*J, J-I) + H(I)
      D = F(4) + X + Y + Z
      RETURN
      END
      SUBROUTINE S3(A, B, N, C)
      DOUBLE PRECISION A, B(N), C(3)
      A = B(N) + C(2)
      B(1) = A
      RETURN
      END
      DOUBLE PRECISION FUNCTION DF(X)
      DF = X * 2.0D0
      RETURN
      END
      SUBROUTINE N
      DOUBLE PRECISION A(4)
      DATA A /-1.5D0, -0.5D0, -2.0D0, -1.0D0/
      A(1) = -1.5D0
      RETURN
      END
