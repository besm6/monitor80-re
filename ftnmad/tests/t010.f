      FUNCTION T10(X, K)
      DIMENSION V(5)
      F(Y) = Y*Y + 1.0
      G(Y, Z) = F(Y) - Z
      T10 = 0.0
      READ 100, V
      READ (5, 100) A, B, (V(I), I = 1, K)
      WRITE (6, 200) A, B, V(2)
      PRINT 200, X, G(A, B)
  100 FORMAT (5F10.3)
  200 FORMAT (1X, 3E15.6, 5HHELLO)
      IF (K .EQ. 0) RETURN
      T10 = F(X) + G(X, 2.0)
      PAUSE 1
      RETURN
      END
