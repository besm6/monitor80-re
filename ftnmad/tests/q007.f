      SUBROUTINE G102(X, N, Z)
      DIMENSION F(6), C(4)
      INTEGER KG(4)
      INTEGER KK
      EQUIVALENCE (L, KK)
      EQUIVALENCE (V, MM), (KK, MM), (R, F(5), V)
      EQUIVALENCE (MM, C(2), LL), (LL, KG(4))
      DATA C /-3.6, -2.0, 'OK', 4.5E2/
      DATA K /2/
      I = 3
      J = 1
      L = 3
   10 V = KG(L+1) * F(2)
   20 F(J+0) = R
   30 KG(2) = KG(J) + C(L) + KK
   40 LL = R - L
   50 R = LL * LL
   60 MM = L - J
   70 DO 100 K = 1, 3
   80 C(J) = KG(J+1) + KK
   90 KK = C(J) - MM
  100 R = F(3) - LL
  110 F(4) = KG(3) + C(I) + R
  120 KK = I - K
  130 R = F(L+0) * F(J+1)
  140 F(J+0) = C(3) + C(J+0) + KG(J)
  150 V = 2 * KG(L+1)
  160 R = MM * R
  170 KK = I - F(J)
  180 KG(I+1) = F(1) + 2 + KG(L)
  190 R = MM * KG(K+0)
  200 R = LL * 2
  210 KK = L - KG(I+1)
  220 C(K+1) = KK + J
  230 KG(3) = KG(K)
  240 KG(K) = C(L+1)
  250 KG(I) = V + KG(J+0)
  260 KK = F(J+0) - V
  270 F(L+0) = MM + J + L
  280 MM = MM - F(5)
  290 KG(1) = I + F(L) + C(J)
  300 C(K) = F(J)
      RETURN
      END
