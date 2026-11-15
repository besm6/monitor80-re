      SUBROUTINE SUBA(X,I)
      COMMON /BLK/ A(10)
      A(I) = X*2.0 + SQRT(X)
      RETURN
      END
