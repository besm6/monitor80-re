      PROGRAM D2
      DIMENSION B(4), C(2,3)
      LOGICAL P
      DATA B, X /5*1.0/, C(2,2), Y /-2.5E-1, +7/, Z/2HAB/, P/.TRUE./
      DATA W, V /2*1.0/, U/4HABCD/, K/-0/, KK/77777B/
      X = B(1) + C(1,1) + X + Y + Z + W + V + U + K + KK
      IF (P) X = 1.
      STOP
      END
