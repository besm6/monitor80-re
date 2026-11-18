      SUBROUTINE SS(D, M, N, E, G)
      DIMENSION D(M,N), E(M,N,3), G(M,2,N)
      I = 2
      J = 1
      K = 1
      X = D(I*J,K)
      Y = E(I,J+K,2)
      Z = G(I,J,K*K)
      RETURN
      END
