      PROGRAM R001
      DOUBLE PRECISION D
      COMPLEX C
      INTEGER KA(3)
      K = 1
      READ (5) K, D, C, KA(2), KA
      WRITE (6) K, D, C, KA(2)
      READ (K) X
      WRITE (K) X
      STOP
      END
      SUBROUTINE R1(P, N, V)
      DIMENSION A(5), V(N)
      INTEGER M
      DOUBLE PRECISION D
      READ 100, X
      READ 100, K, A(K), (A(I), I = 1, 3), V, D
      READ (5, 100) X, M
      READ (N, 100) A
      READ (5) X, A
      WRITE (6, 100) X, K, A(2)
      WRITE (N, 100) V
      WRITE (6) X, A
      WRITE (6, 100)
      READ (5, 100)
  100 FORMAT (5F10.3)
      RETURN
      END
      SUBROUTINE PS
      PAUSE
      PAUSE 7
   10 PAUSE 12
      STOP
      END
      SUBROUTINE ST
      K = 1
      IF (K .EQ. 1) STOP 3
      PAUSE
      IF (K .EQ. 2) STOP
      STOP K
      END
      SUBROUTINE P1
      DIMENSION A(5)
    5 FORMAT (1X, I5, F10.3, E12.4/ 3HABC, 'XY')
      K = 3
      X = 1.5
      PRINT 5, K, X
      PRINT 5, K, A(K), (A(I), I = 1, 5)
      PRINT 5
      PRINT 6, A
    6 FORMAT (5F8.2)
      STOP
      END
      SUBROUTINE P2
      DIMENSION A(5), B(2,3)
      INTEGER M(4)
      K = 3
      X = 1.5
      PRINT 7, X, A(K+1)
      PRINT 7, ((B(I,J), I = 1, 2), J = 1, 3, 2), M, B
      PRINT 7, (K, A(K), K = 1, 5)
    7 FORMAT (1H1, 10X, 'RESULT' /
     1   (6F10.3))
      STOP
      END
      SUBROUTINE P4
    5 FORMAT (I5)
      DIMENSION A(5)
      EQUIVALENCE (A(2), X)
      DATA Y /2.0/
    6 FORMAT (F5.1)
      K = 1
      PRINT 5, K
      PRINT 6, A(K), X, Y
      STOP
      END
      SUBROUTINE Q5
      DOUBLE PRECISION D, DA(3)
      COMPLEX C, CA(2)
      LOGICAL G, GA(2)
      DATA D, C, G /1.0D0, 1.0, 2.0, .TRUE./
      K = 1
      PRINT 900, D, DA(K), C, CA(2), G, GA(K), K
      PRINT 900, DA, CA, GA, (DA(I), CA(I), I = 1, 2)
  900 FORMAT (I5)
      STOP
      END
      SUBROUTINE P3(P, N, V)
      DIMENSION A(5), V(N), C(3,4)
      COMMON /Q/ Z, W(3)
      K = 3
      PRINT 7, A(K+1), A(2), P, N, V(N), Z, W(2), (W(I), I = K, N)
      PRINT 7, V, W, (A(I), I = 1, 5, 2), C(K, 2)
      PRINT 7, ((C(I,J), J = 1, 4), I = 1, 3), (A(J), J = K, 4), 
     1 (N, (C(I,J), I = 1, 3), J = 1, N)
    7 FORMAT (6F10.3)
      RETURN
      END
      SUBROUTINE P5(N, L)
      DIMENSION A(5)
      M = 1
      PRINT 7, M, N, L
      DO 10 J = 1, 5
   10 A(J) = 1.0
      PRINT 7, J, A(N)
    7 FORMAT (3I5)
      RETURN
      END
