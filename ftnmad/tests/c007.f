      SUBROUTINE C6(N, A)
      DIMENSION A(10), B(10)
      I = 1
      J = 2
      A(I) = B(J) + A(I+1)
      X = 1.0
      B(J+1) = A(I)
      Y = SIN(X)
      B(J+1) = A(I)
      CALL G
      B(J+1) = A(I)
      RETURN
      END
