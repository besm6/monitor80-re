      PROGRAM MAIN
      DIMENSION B(5,4), K(3)
      INTEGER P, Q
      REAL L
      LOGICAL F, G
      I = 1
      J = I + 2
      P = I*J - Q/3
      X = 1.5
      Y = X + I
      L = -X
      F = .TRUE.
      G = F .AND. X .GT. Y .OR. .NOT. F
      B(I,J) = B(2,3) + K(I)
      K(2) = I**2
      Y = X**I
      Y = X**Y
      IF (I) 10, 20, 30
   10 IF (X .LT. Y) GO TO 30
   20 GO TO 10
   30 CONTINUE
      DO 40 I = 1, 10
   40 K(1) = K(1) + I
      STOP
      END
