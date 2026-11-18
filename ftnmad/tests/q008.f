      PROGRAM E2
      DIMENSION B(8), C(3,2)
      INTEGER KB(4)
      DATA B/1.0, 2*2.0, 3., 4*0.5/, C(2,1), C(1,2) /2*7./
      DATA KB(2), KB(3)/1, 2/
      X = B(1) + C(1,1) + KB(1)
      STOP
      END
