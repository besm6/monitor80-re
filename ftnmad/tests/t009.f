      SUBROUTINE T9(A, N, M)
      DIMENSION A(N, M), B(20)
      COMMON /CB/ P, Q(10), IX
      EQUIVALENCE (B(1), R), (S, T)
      DATA B /20*0.0/, K /5/
      DO 10 I = 1, N
      DO 10 J = 1, M
   10 A(I, J) = 0.0
      DO 20 I = 2, N, 2
      B(I) = Q(I) + P
      IF (B(I) .LT. 0.0) GO TO 30
   20 CONTINUE
   30 GO TO (40, 50, 60), IX
   40 ASSIGN 50 TO L
      GO TO L, (50, 60)
   50 CALL SUB(A, B(3), N + 1, 5.0)
   60 S = FUN(R, T) + K
      RETURN
      END
