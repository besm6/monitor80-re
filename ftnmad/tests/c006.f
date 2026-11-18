      SUBROUTINE C6(N, A)
      DIMENSION A(10), B(10)
      COMMON /IX/ I, J
      A(I) = B(J) + A(I+1)
      X = 1.0
      B(J+1) = A(I)
      Y = SIN(X)
      B(J+1) = A(I)
      CALL G
      B(J+1) = A(I)
      RETURN
      END
