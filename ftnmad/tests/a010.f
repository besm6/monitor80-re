      SUBROUTINE SS(D, M, N, E, G, H)
      DIMENSION D(M,N), E(M,N,3), G(M,2,N), H(2,M,3)
      I = 2
      J = 1
      K = 1
      X = H(I,J,K) + G(I,J,K) + E(I,J,K)
      Y = H(1,J+1,2) + G(2,1,K) + E(1,1,K) + D(2,J)
      Z = E(2*I-1,3*J+2,K-1) + G(I,3*J,2) + H(3*I,2*J-1,K+1)
      D(I,J) = E(1,J,1) + G(I,J,1) + E(I,2,3)
      DO 10 L = 1, N
   10 D(L,J) = D(L,J+1) * H(L,L,L)
      J = J + 1
      CALL Q(D(I,K), E, J)
      RETURN
      END
