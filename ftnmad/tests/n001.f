      PROGRAM X5
      EXTERNAL H
      CALL S(H, 1.0)
      STOP
      END
      FUNCTION X4(P, F)
      REAL KR
      LOGICAL LG
      EXTERNAL LG, SQRT, F, V
      COMMON C(3)
      X = KR(1.0) + EXP(2.0) + SQRT(3.0)
      IF (LG(X)) CALL R(V, SQRT, F, P)
      DO 10 I = 1, 3
   10 C(I) = V(C(I)) + W(1.0)
      X4 = SIN(X) + F(V(1.0))
      RETURN
      END
      SUBROUTINE X1(F, N)
      EXTERNAL SIN, G, F, H
      REAL H
      CALL S(SIN, G, F, H, N)
      Y = G(1.0) + H(2.0)
      CALL T(G)
      Z = SIN(Y)
      RETURN
      END
      SUBROUTINE X2(F, N)
      INTEGER G
      EXTERNAL G, Q, COS, U
      DOUBLE PRECISION U
      DIMENSION A(3)
      CALL S(Q, A, COS)
      K = G(N) + 1
      CALL Q
      X = U(1.0D0)
      RETURN
      END
      SUBROUTINE X3(F)
      EXTERNAL Z, W, F
      CALL S(W)
      Y = F(1.0)
      RETURN
      END
      SUBROUTINE N1(X, N)
      Y = X
      ENTRY N1A
      Z = 1.0
      IF (N .GT. 0) GO TO 10
      ENTRY N1B
   10 W = Y + Z
      RETURN
      END
      FUNCTION N2(X)
      ENTRY N2A
      N2 = SIN(X) + G(1.0)
      CALL S(7HABCDEFG)
      ENTRY N2B
      DO 10 I = 1, 3
   10 N2 = N2 + 1
      RETURN
      END
      SUBROUTINE N3
      DIMENSION A(3)
      COMMON /C/ B(2)
      DATA A /3*1.0/
      ENTRY N3A
      A(1) = B(2)
      GO TO 30
      ENTRY N3B
   30 RETURN
      ENTRY N3C
      END
      SUBROUTINE R1(N)
      DIMENSION KU(3)
      COMMON KC
      REWIND 5
      BACKSPACE 6
      END FILE 7
      ENDFILE N
      REWIND N
      BACKSPACE KU(2)
      REWIND KC
      ENDFILE 8
      REWIND 5
      RETURN
      END
      SUBROUTINE R2(N)
      DIMENSION A(5), KU(3)
      DO 10 I = 1, 5
      A(I) = 1.0
      REWIND KU(3)
      A(I+1) = A(I)
   10 BACKSPACE N
      X = 2.0
      A(N) = 1.0
      END FILE 3
      A(N) = 2.0
      RETURN
      END
