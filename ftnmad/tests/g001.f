      PROGRAM G001
      COMMON /C/ KC, LC
      DIMENSION KA(3)
      EQUIVALENCE (KA(2), KE)
      KE = 1
      GO TO (10, 20, 30, 10, 20, 30, 10), KC
      X = 2.0
   10 ASSIGN 20 TO LC
      GO TO LC
   20 GO TO (10, 30), KE
   30 ASSIGN 10 TO M
      GO TO M, (10, 20)
      END
      SUBROUTINE G1(N)
      K = 2
      GO TO (10, 20, 30), K
   10 X = 1.0
      GO TO (20, 10), N
   20 ASSIGN 30 TO L
      GO TO L, (10, 30)
   30 GO TO L
      END
      SUBROUTINE G2(N)
      DIMENSION A(5)
      DO 10 I = 1, 5
      GO TO (10, 20), I
   20 A(I) = 1.0
   10 CONTINUE
      GOTO (30, 40, 30) N
   30 ASSIGN 40 TO K
      IF (N .GT. 1) GO TO K
      ASSIGN 30 TO K
   40 GO TO (30, 40), N
      END
