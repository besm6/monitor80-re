      PROGRAM QQ
      DIMENSION A(10), B(5,4)
      N = 4
      J = 2
      DO 10 I = 1, N
      A(I) = B(I,J)
   10 A(2*I) = B(J,I)
      DO 20 K = 1, 3, 2
   20 A(3*K) = 1.0
      STOP
      END
