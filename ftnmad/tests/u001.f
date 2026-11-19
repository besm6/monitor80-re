      SUBROUTINE U001(A, N)
      DIMENSION A(10), B(10)
      K = 1
      DO 10 I = 1, N
      A(I) = B(I)
      B(I) = 0.0
   10 CONTINUE
      X = A(K)
      RETURN
      END
      SUBROUTINE U002(A, N)
      DIMENSION A(10), B(10)
      K = 1
      DO 10 I = 1, N
      A(I) = B(I)
      IF (X .GT. 0.0) B(I) = 0.0
      A(K) = 1.0
   10 CONTINUE
      X = A(K)
      RETURN
      END
      SUBROUTINE U003(A, N, M)
      DIMENSION A(10), B(10), C(5,5)
      K = 1
      DO 10 I = 1, N
      DO 10 J = 1, M
      C(I,J) = B(I) + A(J)
   10 B(J) = C(J,I)
      X = C(K,K) + B(K)
      RETURN
      END
      SUBROUTINE U004(A, N, M)
      DIMENSION A(10), B(10), C(5,5)
      K = 1
      DO 10 I = 1, N
      CALL S(A(I), B(I))
      A(K) = B(I)
   10 CONTINUE
      X = B(I) + A(K)
      RETURN
      END
      SUBROUTINE U005(A, N, M)
      DIMENSION A(10), B(10), C(5,5)
      K = 1
      DO 10 I = 1, N
      PRINT 5, (C(I,J), J = 1, 5), B(I)
      A(I) = B(I)
   10 CONTINUE
    5 FORMAT (6F5.1)
      X = A(I)
      RETURN
      END
      SUBROUTINE U006(A, N, M)
      DIMENSION A(10), B(10), C(5,5)
      K = 1
      DO 10 I = 1, N
      IF (A(I) .GT. 0.0) GO TO 10
      A(I) = B(I)
   10 CONTINUE
      X = A(I) + B(I)
      RETURN
      END
      SUBROUTINE U007(A, N, M)
      DIMENSION A(10), B(10), C(5,5)
      K = 1
      DO 10 I = 1, N
   20 A(I) = B(I)
      B(I) = A(K)
      IF (B(I) .LT. 0.0) GO TO 20
   10 CONTINUE
      X = A(I)
      RETURN
      END
      SUBROUTINE U008(A, N, M)
      DIMENSION A(10), B(10), C(5,5)
      K = 1
      DO 10 I = 1, N
   10 A(I) = B(I)
      DO 20 J = 2, M, 2
      DO 30 I = 1, 5
   30 C(I,J) = A(I)
      B(J) = C(J,J)
   20 A(J) = B(J)
      X = A(J) + C(J,J)
      RETURN
      END
      SUBROUTINE U009(A, N, M)
      DIMENSION A(10), B(10), C(5,5)
      K = 1
      DO 10 I = 1, N
      GO TO (10, 20), I
   20 A(I) = B(I)
   10 CONTINUE
      X = A(I)
      RETURN
      END
