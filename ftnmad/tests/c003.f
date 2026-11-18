      SUBROUTINE C3(N, A)
      DIMENSION A(10), B(10)
      COMMON /IX/ I, J
      DO 10 K = 1, N
      A(I) = B(J) + A(I+1)
      CALL F(A, K)
      B(J+1) = A(I)
   10 CONTINUE
      I = I + 1
      A(I) = 2.0
      RETURN
      END
