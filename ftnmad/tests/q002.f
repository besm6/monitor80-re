      PROGRAM E3
      DIMENSION A(10), B(5), C(4), D(3), F(6)
      INTEGER G(2)
      EQUIVALENCE (P, Q), (A(1), B(3)), (R, C(2)), (Q, D(3))
      EQUIVALENCE (C(4), A(2)), (S, T), (F(2), G(1)), (U, G(2))
      X = A(1)+B(1)+C(1)+D(1)+F(1)+G(1)+P+Q+R+S+T+U
      STOP
      END
