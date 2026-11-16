      SUBROUTINE SS(K, X)
      INTEGER Q
      Q = 1
      CALL FOO(K, Q, X, M)
      CALL FOO(Q, Q, 3)
      RETURN
      END
