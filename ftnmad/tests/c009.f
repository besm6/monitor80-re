      PROGRAM C009
      DIMENSION X(10)
      A = 1.5
      B = 2.5
      IF (A=B) GOTO 10
      A = B
   10 IF (B=A+1.0) GOTO 20
      I = 3
   20 IF (I=J*2) GOTO 30
      X(I) = A
   30 IF (X(I)=B) GOTO 40
   40 IF (A=B) 50, 60, 70
   50 J = I
   60 IF (L=J-I) GOTO 10
   70 STOP
      END
