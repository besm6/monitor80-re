      PROGRAM QQ
      DIMENSION A(10), B(5,4), C(2,3,4)
      I = 2
      J = 3
      K = 1
      X = A(I*2)
      X = B(I-J,K*2)
      Y = B(J*K, J+1)
      Y = C(I,J*K,K)
      Y = C(I+J,2,3)
      Y = C(2*I-1,J,1)
      Z = C(1,1,J+K)
      STOP
      END
