      SUBROUTINE C2(N, F)
      COMMON /B/ X, Y, Z(2)
      COMMON KA(3), L
      DIMENSION W(3), P(2), Q(3), U(4), V(2)
      EQUIVALENCE (Y, W(2)), (Z(2), P(1)), (Z(2), Q(1))
      EQUIVALENCE (U(3), V(2)), (V(1), L)
      DATA Z(1) /1.5/, KA /3*7/
      DO 10 L = 1, N
      X = W(1) + P(2) + Q(3) + U(1) + V(2) + F
      KA(L) = L + KA(L+1)
   10 CONTINUE
      Z(2) = Y * X
      CALL S(X, L, KA)
      RETURN
      END
