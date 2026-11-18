      PROGRAM K001
      LOGICAL L, M, N, LF, LA(3)
      X = 1.0
      Y = 2.0
      I = 2
      L = .TRUE.
      M = .FALSE.
      L = M .OR. .TRUE.
      M = .NOT. .FALSE. .AND. L
      IF (.TRUE.) GOTO 10
      L = .FALSE. .OR. M
   10 IF (L .AND. .FALSE.) STOP
      M = .TRUE. .AND. .TRUE.
      N = X .GT. Y
      LA(1) = L
      LA(I) = .FALSE.
      L = LA(2)
      L = (.TRUE.)
      L = .NOT. .TRUE.
      IF (.NOT. .FALSE.) X = 1.0
      IF (.TRUE.) 20, 20, 20
   20 X = FN(.TRUE., 2.0)
      L = LF(.TRUE.)
      L = FN(.TRUE.)
      L = LF(X)
      X = FN(LF(Y), .FALSE.) + 1.0
      CALL S(.FALSE., .TRUE.)
      L = LF(.TRUE.) .OR. M
      STOP
      END
