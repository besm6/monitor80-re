      PROGRAM K003
      LOGICAL L, M, LF
      X = 1.0
      Y = 2.0
      M = X .GT. Y
      L = M
      X = FN(X .GT. Y, Y + X, L .OR. M)
      CALL S(M .OR. .TRUE., 1.0)
      X = GN(FN(L .AND. M), Y .LT. X)
      IF (LF(X .GT. Y)) GOTO 10
      IF (FN(L .OR. M)) 10, 10, 10
   10 L = LF(X .EQ. Y) .AND. M
      IF (L) X = FN(X .LE. Y)
      STOP
      END
