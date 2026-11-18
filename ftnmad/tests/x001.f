      PROGRAM X001
      COMPLEX C, Z, W(3)
      C = (1.0, 2.0)
      Z = C*C + Z
      W(2) = (-1.5, 0.25E1) - C / Z
      X = C
      Z = X + (0.5, -3.0)
      STOP
      END
      SUBROUTINE C2
      COMPLEX C, Z, W(3,2), V
      DOUBLE PRECISION D
      EQUIVALENCE (W(2), V)
      I = 1
      J = 2
      X = 1.5
      D = 2.0D0
      CALL S(1.0, 2.0)
      CALL S((1.0, 2.0))
      C = F((1.0, 2.0)) + (-0.5, -0.25)
      Z = (+1.0, 2.0) * (X + 1.0)
      W(I,J) = CMPLX(X, 2.0) + W(J,I) * I
      X = CABS(C) + REAL(Z)
      V = CEXP(C) + CONJG(Z)
      Z = C ** 2
      CALL S(C, W, W(I+1,J))
      RETURN
      END
      COMPLEX FUNCTION CF(A)
      CF = (1.0, 0.0) * A
      RETURN
      END
      SUBROUTINE C5
      COMPLEX C, W(3), U
      COMMON /B/ U
      DATA C /1.0, -2.0/, W /2*0.5, 1.5, 3*2.0/, U /2*1.0/
      DATA W(2) /7.0, 8.0/
      X = REAL(C) + REAL(W(2)) + REAL(U)
      RETURN
      END
      SUBROUTINE C4
      COMPLEX C
      DATA C /1.0, -2.0/
      X = REAL(C)
      RETURN
      END
