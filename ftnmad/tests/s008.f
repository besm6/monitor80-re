      PROGRAM QQ
      N = 5
      M = 2
      S = 0.0
      DO 10 I = 1, 10
   10 S = S + 1.0
      DO 20 J = 1, N
      DO 20 K = M, N, 2
      S = S + 2.0
   20 CONTINUE
      DO 30 L = N, 20, M
      IF (S .GT. 3.0) GO TO 40
   30 S = S * 2.0
   40 STOP
      END
