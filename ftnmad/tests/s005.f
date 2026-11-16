      PROGRAM QQ
      LOGICAL F, G
      A = 1.5
      B = 2.5
      I = 1
      J = 2
      IF (A .GT. B) I = 2
      IF (A .LT. B .AND. I .EQ. J .OR. A .NE. B) GO TO 10
      IF (I - J) 10, 20, 30
   10 IF (A + B) 20, 20, 30
   20 IF (I) 30, 10, 10
   30 F = A .GE. B
      G = F .AND. .NOT. (I .LE. J)
      IF (F) J = 3
      IF (.NOT. F .OR. G) STOP
      STOP
      END
