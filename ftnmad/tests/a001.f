      PROGRAM QQ
      DIMENSION A(10), B(5,4)
      I = 2
      J = 3
      A(1) = 1.0
      A(I) = 2.0
      B(I,J) = A(I+1)
      X = A(I) + B(2,J)
      A(2*I+1) = X
      STOP
      END
