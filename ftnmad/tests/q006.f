      PROGRAM G101
      DIMENSION H(8), B(5), F(6), C(4), A(10)
      INTEGER KG(4)
      INTEGER S, LL, MM
      EQUIVALENCE (Q, R), (A(10), NX, B(4)), (MM, KG(2))
      EQUIVALENCE (W, F, KG(1))
      DATA P, S /42.0, 3HX1Y/
      DATA B, LL /6*-5.1/, H, MM /6*80.8, 2*40.4, 30.6/
      LOGICAL LG
      DATA LG /.TRUE./
      DATA I /2/
      J = 1
      K = 1
      L = 1
      T = 1.5
      U = 1.5
      V = 1.5
   10 U = R * H(4)
   20 R = 1.5 - I
   30 DO 50 L = 1, 2
   40 A(5) = LL + L + A(8)
   50 Q = H(4) * MM
   60 DO 70 K = 1, 2
   70 KG(J+1) = B(J+0)
   80 T = KG(L+0) * H(I)
   90 Q = S - A(I)
  100 B(4) = NX + V + H(7)
  110 R = C(2) - C(K+0)
  120 T = H(5) - C(3)
  130 R = W - I
  140 F(6) = H(L+0)
  150 B(2) = I + J
  160 A(L+1) = 2 + KG(4)
  170 B(L) = L + 1.5
  180 DO 210 K = 1, 2
  190 R = A(K) - C(2)
  200 LL = KG(I+0) - L
  210 F(J+0) = MM + Q + NX
  220 S = KG(2) - A(3)
  230 U = P * J
  240 P = T * KG(4)
  250 B(K) = B(L)
  260 NX = H(J) - S
  270 S = B(J+1) - B(K)
  280 A(J) = F(L) + J + NX
  290 T = KG(J) * C(J)
  300 H(L) = KG(4)
      STOP
      END
