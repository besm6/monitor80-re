      PROGRAM E001
      STOP
      END
      SUBROUTINE E1(V, N)
      DIMENSION V(5), B(10), KB(3)
      DOUBLE PRECISION D
      X = 1.5
      K = 2
      PUNCH 100, X, K, (V(I), I = 1, 3)
      PUNCH 100
      ENCODE (20, 100, B) X, K, D
      DECODE (20, 100, B) X, K, V
      ENCODE (N, 100, B(2)) X
      DECODE (K, 100, KB) Y, (V(I), I = 1, N)
      ENCODE (10, 100, B)
  100 FORMAT (F5.1, I3)
      RETURN
      END
      SUBROUTINE E2(V, N, C)
      DIMENSION V(N), B(10), C(3,4)
      COMMON /CB/ KC, W(5)
      K = 2
      ENCODE (KC, 100, B(K)) W
      DECODE (N, 100, V) (W(I), I = 1, K)
      ENCODE (10, 100, C(K, 2)) KC, B(K+1)
      DECODE (20, 100, V(N)) C
      ENCODE (KC, 100, W(3)) N
  100 FORMAT (5F5.1)
      PUNCH 100, W, KC, (C(I,K), I = 1, 3)
      RETURN
      END
      SUBROUTINE E3(N)
      COMMON KC, KD(3)
      DIMENSION A(5)
      READ (KC, 100) KC, KD(2), A(KC)
      PRINT 100, KD, KC
      CALL S(KC, KD(KC))
      A(KC) = 1.0
  100 FORMAT (3I5)
      RETURN
      END
