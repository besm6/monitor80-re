      PROGRAM H001
      CALL S(3HABC, 'ABCDEFGHI')
      STOP
      END
      SUBROUTINE H2(N)
      INTEGER K
      CALL S(3HABC, 'XY', 7HABCDEFG, N, 'ABCDEFGHIJ')
      K = 2HAB
      X = 4HTEST
      IF (K .EQ. 2HAB) K = 0
      K = 1HA + 1
      Y = F(2HZZ, 8HABCDEFGH)
      CALL S(7HABCDEFG)
      RETURN
      END
      SUBROUTINE H3(N)
      DIMENSION A(3), KA(4)
      DATA KA /4HAB C, 3*1H /
      CALL S(4HA B , 'A  B', 1H , 9HA B C D E)
      A(2) = 3H , 
      KA(N) = 6H*+-/=$
      IF (KA(1) - 3HA B) 10, 20, 10
   10 CALL S(KA, 7H1234567, 7H1234567, 'Q', 'ABCDEFGHIJKLMNOPQRSTU')
   20 X = G(A(1), 10HQWERTYUIOP) + G(1.0, 'X')
      DO 30 I = 1, N
   30 CALL S(I, 2HDO, 8H12345678)
      ASSIGN 10 TO K $ CALL S('$', 2H$$)
      RETURN
      END
      SUBROUTINE H4(N)
      LOGICAL L
      F(X) = X + 2HAB
      Y = F(8HABCDEFGH)
      L = N .EQ. 1HA .OR. N .NE. 'B'
      PRINT 9, N, 3HABC
      WRITE (6, 9) 7HABCDEFG
    9 FORMAT (2A6)
      RETURN
      END
