      SUBROUTINE SS(N, X)
      DIMENSION A(10), B(5,4)
      J = 2
      A(N) = B(J,N) + X
      Y = F(X)
      CALL G(J)
      RETURN
      END
