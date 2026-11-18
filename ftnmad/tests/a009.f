      PROGRAM QQ
      DIMENSION A(10), B(5,4)
      INTEGER KA(8)
      I = 2
      J = 1
      KA(I) = 3
      X = A(KA(I))
      Y = B(KA(I)+1, J*2)
      Z = A(KA(J*I))
      IF (A(I) .GT. B(I,J)) A(I+1) = SQRT(A(J))
      KA(KA(I)) = KA(I) + 1
      STOP
      END
