      SUBROUTINE SUB(X, I, Y)
      INTEGER Q
      Y = X + I
      Q = I
      IF (Q) 10, 20, 10
   10 CALL FOO(X, Q + 1, 2.0)
      CALL BAR
   20 RETURN
      END
      FUNCTION F(X, Y)
      F = X*Y + G(X)
      RETURN
      END
      INTEGER FUNCTION IFN(K)
      IFN = K + 1
      END
      PROGRAM MAIN
      X = F(1.0, 2.0)
      CALL SUB(X, IFN(3), Y)
      END
