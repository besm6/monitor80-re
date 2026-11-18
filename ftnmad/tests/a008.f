      SUBROUTINE SS(A, N, D, M)
      DIMENSION A(N), D(2,M), C(3)
      I = 2
      J = 1
      A(1) = 1.0
      A(I) = D(I,J)
      D(1,J) = A(I+1) + C(2)
      A(N) = D(2,M)
      X = A(I*J)
      CALL G(A, D(1,J), C)
      RETURN
      END
