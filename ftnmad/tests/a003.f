      PROGRAM QQ
      DIMENSION A(10), B(5,4), C(3,3,3)
      K = 1
      J = 3
      I = 2
      X = B(I,J) + A(3*I) + B(J,K) + C(I,K,J) + A(2*J) + B(1,I)
      Y = A(4*K) + C(1,J,1) + A(3*J)
      STOP
      END
