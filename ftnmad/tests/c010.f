      PROGRAM C010
      DIMENSION E(3), F(6)
      INTEGER W, U
      COMMON C(4), S /B1/ LL, J
      EQUIVALENCE (S, F(3), W), (S, E(3), KK)
      EQUIVALENCE (E, U, P)
      LL = 1
      J = 2
      X = S + P
      STOP
      END
