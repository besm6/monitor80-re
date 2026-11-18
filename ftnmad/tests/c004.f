      PROGRAM C4
      COMMON M, L
      DIMENSION U(4), V(2), XA(3), XB(2)
      EQUIVALENCE (U(3),V(2)), (U(1),L), (XA(2),XB(1))
      X = U(1) + V(1) + XA(1) + XB(1)
      STOP
      END
