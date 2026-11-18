      SUBROUTINE SS(D, M, N)
      DIMENSION D(M,N)
      I = 2
      J = 1
      X = D(I,J)
      Y = D(1,2)
      Z = D(I,1)
      W = D(2*I+1,J-1)
      RETURN
      END
