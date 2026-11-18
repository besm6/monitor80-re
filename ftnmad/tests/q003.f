      PROGRAM D1
      DIMENSION B(4), C(2,3), E(3)
      INTEGER K, L
      EQUIVALENCE (E(2), W)
      DATA K/3/, X, Y/2*1.5/, B, V /4*2.0, -3.0/, L/-4/
      DATA W/8./, E(1)/1E2/
      DATA S, T/0.5, 'AB'/
      X = B(1) + C(1,1) + K + L + V + W + E(3) + S + T
      STOP
      END
