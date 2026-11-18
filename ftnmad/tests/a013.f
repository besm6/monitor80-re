      SUBROUTINE SS(D, M, N)
      DIMENSION D(M,N)
      I = 2
      J = 1
      M = 3
      X = D(I,J)
      M = M + 1
      D(J,I) = X
      CALL Q(M)
      RETURN
      END
