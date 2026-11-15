      PROGRAM T8
      DOUBLE PRECISION D, E
      COMPLEX C, Z
      LOGICAL L, M
      DIMENSION A(10), N(5,5), D2(3)
      DOUBLE PRECISION D2
      D = 1.5D0
      E = D*2.0 + D/E
      C = (1.0, 2.0)
      Z = C*C + Z
      I = 3
      J = I/2 + I*4 - 7
      X = FLOAT(I) + 2.5E3
      A(I) = X
      A(I+1) = A(I) * A(2*I-1)
      N(I,J) = N(J,I) + 1
      D2(I) = D
      L = X .GT. 1.0 .AND. I .LE. J
      M = .NOT. L .OR. X .EQ. A(1)
      IF (L) X = 2.0
      IF (I - J) 10, 20, 10
   10 X = -X
   20 CONTINUE
      K = I**2 + J**I
      X = ABS(X) + SQRT(A(2)) + AMAX1(X, A(3))
      I = IFIX(X) + MOD(I, J)
      STOP
      END
