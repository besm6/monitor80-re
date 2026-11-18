      PROGRAM E1
      DIMENSION A(10), B(5)
      EQUIVALENCE (A(3), B(1)), (X, Y, I)
      DATA Z/2.5/, K/7/
      DATA B/1.0, 2.0, 3*0.5/
      X = A(4) + B(2) + Z
      Y = K
      STOP
      END
