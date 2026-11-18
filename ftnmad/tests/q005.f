      FUNCTION FN(X, N)
      DIMENSION A(5), B(3)
      EQUIVALENCE (A(2), B), (S, A(5))
      DATA B /1., 2., 3./, K /2/, T /0.5/
      FN = A(1) + B(K) + S + T + X
      DO 10 I = 1, N
   10 FN = FN + A(I)
      RETURN
      END
