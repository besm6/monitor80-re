      PROGRAM C1
      DIMENSION A(10), B(3,2)
      COMMON X, A, I
      COMMON /BL/ B, Y, Z /BL2/ U
      EQUIVALENCE (Y, V(1))
      DIMENSION V(4)
      DATA Z /2.0/
      X = A(2) + Y + V(3) + U
      I = 3
      B(I,1) = Z
      STOP
      END
