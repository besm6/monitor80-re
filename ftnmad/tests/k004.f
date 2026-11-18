      BLOCK DATA BD1
      COMMON /B1/ X, Y(3), I
      DIMENSION V(5), Q(3)
      EQUIVALENCE (Y(1), V(1))
      COMMON /B2/ Z, K(2)
      LOGICAL L
      COMMON /B3/ L, W, U(2)
      EQUIVALENCE (W, T(1))
      DIMENSION T(4)
      DATA X /1.5/, Y /2*2.0, 3.0/, I /7/
      DATA K /1, 2/, L /.TRUE./, V(5) /1HA/, T(4) /-1.0/
      END
      PROGRAM K004
      COMMON /B1/ X, Y(3), I
      DIMENSION A(10), H(8), F(6), C(4), B(5)
      INTEGER KG(4)
      COMMON A, S
      EQUIVALENCE (S, H(7)), (H(6), P)
      COMMON /B2/ E(3), C, B, NX, J
      EQUIVALENCE (C(2), F(3)), (E(3), G(3)), (F, Q, U), (Q, KG, MM)
      EQUIVALENCE (Q, W)
      DIMENSION G(10)
      INTEGER M(3)
      X = P + Q
      CALL SB(M, KG, NX)
      M(1) = 2
      STOP
      END
