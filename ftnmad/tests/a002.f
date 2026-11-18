      PROGRAM QQ
      DIMENSION A(10), B(5,4), C(2,3,4)
      I = 2
      J = 3
      K = 1
      X = A(I)
      X = A(I+1)
      X = A(I-1)
      X = A(2*I)
      X = A(2*I-3)
      X = A(1)
      X = A(10)
      X = B(1,1)
      X = B(I,1)
      X = B(1,I)
      X = B(I,J)
      X = B(J,I)
      X = B(2*I+1,3*J-2)
      X = C(I,J,K)
      X = C(K,J,I)
      X = B(I,I)
      X = A(J)
      X = A(I*2)
      X = A(-I)
      X = A(I+J)
      X = A(3+I)
      STOP
      END
