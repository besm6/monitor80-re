      SUBROUTINE C5(N)
      INTEGER K1
      DIMENSION KA(3)
      COMMON L
      DATA K2 /1/
      EQUIVALENCE (K3, KA(2))
      INTEGER K4
      DATA K4 /1/
      K1 = 1
      K5 = 2
      CALL S(K1, K2, K3, K5, L, N, K4)
      RETURN
      END
