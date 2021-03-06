      SUBROUTINE CTCOMELA(DMATX, NTYPE, RPROPS)
      IMPLICIT NONE
      INTEGER I, J, NTYPE, MSTRE
      PARAMETER(MSTRE=4)
      DOUBLE PRECISION
     1    DMATX, RPROPS, c, TEMP1, celm, celf, sesh, adilu, amori
      DIMENSION 
     1    DMATX(MSTRE,MSTRE), RPROPS(19), c(6,6), celm(6,6), celf(6,6), 
     2    sesh(6,6), adilu(6,6), amori(6,6)
      DOUBLE PRECISION 
     &    VOLFR,A1,A2,A3,L1,M1,N1,L2,M2,N2,L3,M3,N3,DENSEF,YOUNGF,
     &    POISSF,DENSEM,YOUNGM,POISSM
C------------------
C Computation of the elasticity matrix for the linear elastic composite
C material reinforced with elliptical fibers alligned in one direction.
C
C (M. Estrada 2010)
C
C Reference: T. Zienkkiewicz 2000 (Cap. 4, Cap. 5)
C
C Output:
C DMATX = Elasticity matrix (3,3) or (4,4) if axisymmetric
C
C Input:
C NTYPE = Type of problem (plane stress, plane strain, axisymmetric)
C RPROPS = Properties of phases from the input file of the problem
C------------------
C
C Calculation of equivalent constitutive composite matrix
C
C Assign properties to variables
      VOLFR=RPROPS(1)
      A1=RPROPS(2)
      A2=RPROPS(3)
      A3=RPROPS(4)
      L1=RPROPS(5)
      M1=RPROPS(6)
      N1=RPROPS(7)
      L2=RPROPS(8)
      M2=RPROPS(9)
      N2=RPROPS(10)
      L3=RPROPS(11)
      M3=RPROPS(12)
      N3=RPROPS(13)
      DENSEF=RPROPS(14)
      YOUNGF=RPROPS(15)
      POISSF=RPROPS(16)
      DENSEM=RPROPS(17)
      YOUNGM=RPROPS(18)
      POISSM=RPROPS(19)
c fibers moduli
      call celast(celf, youngf, poissf)
c matrix moduli
      call celast(celm, youngm, poissm)
c compute eshelby tensor s
      call seshmat(sesh, poissm, a1, a2, a3)
c dilute strain concentration tensor
      call tenad(adilu, celm, celf, sesh)
c mori-tanaka strain concentration tensor
      call tenam(amori, adilu, volfr)
c compute macro-moduli (tangent)      
      call homog(c, celm, celf, volfr, amori)
c Coordinate system transformation for orientation of fibers
c      CALL transf(c, L1, L2, L3, M1, M2, M3, N1, N2, N3)
c
C------------------
C Compute elasticity matrix in local coordinates
C
      IF(NTYPE.EQ.1)THEN
C Plane stress
      DMATX(1,1) = 
     &     c(1,1) - c(1,3) * (c(3,5) * c(4,4) * c(5,1) + c(5,5) * c(3,4)
     & * c(4,1) - c(4,5) * c(3,4) * c(5,1) - c(3,5) * c(5,4) * c(4,1) + 
     &c(5,4) * c(4,5) * c(3,1) - c(4,4) * c(5,5) * c(3,1)) / (c(5,5) * c
     &(3,4) * c(4,3) - c(4,4) * c(5,5) * c(3,3) - c(3,5) * c(5,4) * c(4,
     &3) + c(3,5) * c(4,4) * c(5,3) + c(5,4) * c(4,5) * c(3,3) - c(4,5) 
     &* c(3,4) * c(5,3)) - c(1,4) * (-c(3,5) * c(5,1) * c(4,3) + c(3,5) 
     &* c(5,3) * c(4,1) - c(5,3) * c(4,5) * c(3,1) - c(5,5) * c(3,3) * c
     &(4,1) + c(5,1) * c(4,5) * c(3,3) + c(5,5) * c(3,1) * c(4,3)) / (c(
     &5,5) * c(3,4) * c(4,3) - c(4,4) * c(5,5) * c(3,3) - c(3,5) * c(5,4
     &) * c(4,3) + c(3,5) * c(4,4) * c(5,3) + c(5,4) * c(4,5) * c(3,3) -
     & c(4,5) * c(3,4) * c(5,3)) + c(1,5) * (c(3,3) * c(4,4) * c(5,1) + 
     &c(3,1) * c(5,4) * c(4,3) + c(3,4) * c(5,3) * c(4,1) - c(3,4) * c(5
     &,1) * c(4,3) - c(3,1) * c(4,4) * c(5,3) - c(3,3) * c(5,4) * c(4,1)
     &) / (c(5,5) * c(3,4) * c(4,3) - c(4,4) * c(5,5) * c(3,3) - c(3,5) 
     &* c(5,4) * c(4,3) + c(3,5) * c(4,4) * c(5,3) + c(5,4) * c(4,5) * c
     &(3,3) - c(4,5) * c(3,4) * c(5,3))
      DMATX(1,2) =
     &     c(1,2) - c(1,3) * (-c(4,4) * c(5,5) * c(3,2) + c(3,5) * c(4,4
     &) * c(5,2) + c(5,4) * c(4,5) * c(3,2) - c(4,5) * c(3,4) * c(5,2) +
     & c(5,5) * c(3,4) * c(4,2) - c(3,5) * c(5,4) * c(4,2)) / (c(5,5) * 
     &c(3,4) * c(4,3) - c(4,4) * c(5,5) * c(3,3) - c(3,5) * c(5,4) * c(4
     &,3) + c(3,5) * c(4,4) * c(5,3) + c(5,4) * c(4,5) * c(3,3) - c(4,5)
     & * c(3,4) * c(5,3)) - c(1,4) * (c(5,5) * c(3,2) * c(4,3) - c(5,5) 
     &* c(3,3) * c(4,2) + c(5,2) * c(4,5) * c(3,3) - c(5,3) * c(4,5) * c
     &(3,2) + c(3,5) * c(5,3) * c(4,2) - c(3,5) * c(5,2) * c(4,3)) / (c(
     &5,5) * c(3,4) * c(4,3) - c(4,4) * c(5,5) * c(3,3) - c(3,5) * c(5,4
     &) * c(4,3) + c(3,5) * c(4,4) * c(5,3) + c(5,4) * c(4,5) * c(3,3) -
     & c(4,5) * c(3,4) * c(5,3)) + c(1,5) * (c(3,4) * c(5,3) * c(4,2) + 
     &c(3,3) * c(4,4) * c(5,2) - c(3,3) * c(5,4) * c(4,2) - c(3,2) * c(4
     &,4) * c(5,3) + c(3,2) * c(5,4) * c(4,3) - c(3,4) * c(5,2) * c(4,3)
     &) / (c(5,5) * c(3,4) * c(4,3) - c(4,4) * c(5,5) * c(3,3) - c(3,5) 
     &* c(5,4) * c(4,3) + c(3,5) * c(4,4) * c(5,3) + c(5,4) * c(4,5) * c
     &(3,3) - c(4,5) * c(3,4) * c(5,3))
      DMATX(1,3) =
     &     c(1,6) - c(1,3) * (-c(4,5) * c(3,4) * c(5,6) - c(3,5) * c(5,4
     &) * c(4,6) + c(5,4) * c(4,5) * c(3,6) - c(4,4) * c(5,5) * c(3,6) +
     & c(3,5) * c(4,4) * c(5,6) + c(5,5) * c(3,4) * c(4,6)) / (c(5,5) * 
     &c(3,4) * c(4,3) - c(4,4) * c(5,5) * c(3,3) - c(3,5) * c(5,4) * c(4
     &,3) + c(3,5) * c(4,4) * c(5,3) + c(5,4) * c(4,5) * c(3,3) - c(4,5)
     & * c(3,4) * c(5,3)) - c(1,4) * (-c(5,3) * c(4,5) * c(3,6) - c(3,5)
     & * c(5,6) * c(4,3) + c(3,5) * c(5,3) * c(4,6) + c(5,6) * c(4,5) * 
     &c(3,3) + c(5,5) * c(3,6) * c(4,3) - c(5,5) * c(3,3) * c(4,6)) / (c
     &(5,5) * c(3,4) * c(4,3) - c(4,4) * c(5,5) * c(3,3) - c(3,5) * c(5,
     &4) * c(4,3) + c(3,5) * c(4,4) * c(5,3) + c(5,4) * c(4,5) * c(3,3) 
     &- c(4,5) * c(3,4) * c(5,3)) + c(1,4) * (-c(3,3) * c(5,4) * c(4,6) 
     &+ c(3,3) * c(4,4) * c(5,6) - c(3,6) * c(4,4) * c(5,3) + c(3,6) * c
     &(5,4) * c(4,3) + c(3,4) * c(5,3) * c(4,6) - c(3,4) * c(5,6) * c(4,
     &3)) / (c(5,5) * c(3,4) * c(4,3) - c(4,4) * c(5,5) * c(3,3) - c(3,5
     &) * c(5,4) * c(4,3) + c(3,5) * c(4,4) * c(5,3) + c(5,4) * c(4,5) *
     & c(3,3) - c(4,5) * c(3,4) * c(5,3))
      DMATX(2,1) = 
     &     c(2,1) - c(2,3) * (c(3,5) * c(4,4) * c(5,1) + c(5,5) * c(3,4)
     & * c(4,1) - c(4,5) * c(3,4) * c(5,1) - c(3,5) * c(5,4) * c(4,1) + 
     &c(5,4) * c(4,5) * c(3,1) - c(4,4) * c(5,5) * c(3,1)) / (c(5,5) * c
     &(3,4) * c(4,3) - c(4,4) * c(5,5) * c(3,3) - c(3,5) * c(5,4) * c(4,
     &3) + c(3,5) * c(4,4) * c(5,3) + c(5,4) * c(4,5) * c(3,3) - c(4,5) 
     &* c(3,4) * c(5,3)) - c(2,4) * (-c(3,5) * c(5,1) * c(4,3) + c(3,5) 
     &* c(5,3) * c(4,1) - c(5,3) * c(4,5) * c(3,1) - c(5,5) * c(3,3) * c
     &(4,1) + c(5,1) * c(4,5) * c(3,3) + c(5,5) * c(3,1) * c(4,3)) / (c(
     &5,5) * c(3,4) * c(4,3) - c(4,4) * c(5,5) * c(3,3) - c(3,5) * c(5,4
     &) * c(4,3) + c(3,5) * c(4,4) * c(5,3) + c(5,4) * c(4,5) * c(3,3) -
     & c(4,5) * c(3,4) * c(5,3)) + c(2,5) * (c(3,3) * c(4,4) * c(5,1) + 
     &c(3,1) * c(5,4) * c(4,3) + c(3,4) * c(5,3) * c(4,1) - c(3,4) * c(5
     &,1) * c(4,3) - c(3,1) * c(4,4) * c(5,3) - c(3,3) * c(5,4) * c(4,1)
     &) / (c(5,5) * c(3,4) * c(4,3) - c(4,4) * c(5,5) * c(3,3) - c(3,5) 
     &* c(5,4) * c(4,3) + c(3,5) * c(4,4) * c(5,3) + c(5,4) * c(4,5) * c
     &(3,3) - c(4,5) * c(3,4) * c(5,3))
      DMATX(2,2) = 
     &     c(2,2) - c(2,3) * (-c(4,4) * c(5,5) * c(3,2) + c(3,5) * c(4,4
     &) * c(5,2) + c(5,4) * c(4,5) * c(3,2) - c(4,5) * c(3,4) * c(5,2) +
     & c(5,5) * c(3,4) * c(4,2) - c(3,5) * c(5,4) * c(4,2)) / (c(5,5) * 
     &c(3,4) * c(4,3) - c(4,4) * c(5,5) * c(3,3) - c(3,5) * c(5,4) * c(4
     &,3) + c(3,5) * c(4,4) * c(5,3) + c(5,4) * c(4,5) * c(3,3) - c(4,5)
     & * c(3,4) * c(5,3)) - c(2,4) * (c(5,5) * c(3,2) * c(4,3) - c(5,5) 
     &* c(3,3) * c(4,2) + c(5,2) * c(4,5) * c(3,3) - c(5,3) * c(4,5) * c
     &(3,2) + c(3,5) * c(5,3) * c(4,2) - c(3,5) * c(5,2) * c(4,3)) / (c(
     &5,5) * c(3,4) * c(4,3) - c(4,4) * c(5,5) * c(3,3) - c(3,5) * c(5,4
     &) * c(4,3) + c(3,5) * c(4,4) * c(5,3) + c(5,4) * c(4,5) * c(3,3) -
     & c(4,5) * c(3,4) * c(5,3)) + c(2,5) * (c(3,4) * c(5,3) * c(4,2) + 
     &c(3,3) * c(4,4) * c(5,2) - c(3,3) * c(5,4) * c(4,2) - c(3,2) * c(4
     &,4) * c(5,3) + c(3,2) * c(5,4) * c(4,3) - c(3,4) * c(5,2) * c(4,3)
     &) / (c(5,5) * c(3,4) * c(4,3) - c(4,4) * c(5,5) * c(3,3) - c(3,5) 
     &* c(5,4) * c(4,3) + c(3,5) * c(4,4) * c(5,3) + c(5,4) * c(4,5) * c
     &(3,3) - c(4,5) * c(3,4) * c(5,3))
      DMATX(2,3) = 
     &     c(2,6) - c(2,3) * (-c(4,5) * c(3,4) * c(5,6) - c(3,5) * c(5,4
     &) * c(4,6) + c(5,4) * c(4,5) * c(3,6) - c(4,4) * c(5,5) * c(3,6) +
     & c(3,5) * c(4,4) * c(5,6) + c(5,5) * c(3,4) * c(4,6)) / (c(5,5) * 
     &c(3,4) * c(4,3) - c(4,4) * c(5,5) * c(3,3) - c(3,5) * c(5,4) * c(4
     &,3) + c(3,5) * c(4,4) * c(5,3) + c(5,4) * c(4,5) * c(3,3) - c(4,5)
     & * c(3,4) * c(5,3)) - c(2,4) * (-c(5,3) * c(4,5) * c(3,6) - c(3,5)
     & * c(5,6) * c(4,3) + c(3,5) * c(5,3) * c(4,6) + c(5,6) * c(4,5) * 
     &c(3,3) + c(5,5) * c(3,6) * c(4,3) - c(5,5) * c(3,3) * c(4,6)) / (c
     &(5,5) * c(3,4) * c(4,3) - c(4,4) * c(5,5) * c(3,3) - c(3,5) * c(5,
     &4) * c(4,3) + c(3,5) * c(4,4) * c(5,3) + c(5,4) * c(4,5) * c(3,3) 
     &- c(4,5) * c(3,4) * c(5,3)) + c(2,4) * (-c(3,3) * c(5,4) * c(4,6) 
     &+ c(3,3) * c(4,4) * c(5,6) - c(3,6) * c(4,4) * c(5,3) + c(3,6) * c
     &(5,4) * c(4,3) + c(3,4) * c(5,3) * c(4,6) - c(3,4) * c(5,6) * c(4,
     &3)) / (c(5,5) * c(3,4) * c(4,3) - c(4,4) * c(5,5) * c(3,3) - c(3,5
     &) * c(5,4) * c(4,3) + c(3,5) * c(4,4) * c(5,3) + c(5,4) * c(4,5) *
     & c(3,3) - c(4,5) * c(3,4) * c(5,3))
      DMATX(3,1) = 
     &     c(6,1) - c(6,3) * (c(3,5) * c(4,4) * c(5,1) + c(5,5) * c(3,4)
     & * c(4,1) - c(4,5) * c(3,4) * c(5,1) - c(3,5) * c(5,4) * c(4,1) + 
     &c(5,4) * c(4,5) * c(3,1) - c(4,4) * c(5,5) * c(3,1)) / (c(5,5) * c
     &(3,4) * c(4,3) - c(4,4) * c(5,5) * c(3,3) - c(3,5) * c(5,4) * c(4,
     &3) + c(3,5) * c(4,4) * c(5,3) + c(5,4) * c(4,5) * c(3,3) - c(4,5) 
     &* c(3,4) * c(5,3)) - c(6,4) * (-c(3,5) * c(5,1) * c(4,3) + c(3,5) 
     &* c(5,3) * c(4,1) - c(5,3) * c(4,5) * c(3,1) - c(5,5) * c(3,3) * c
     &(4,1) + c(5,1) * c(4,5) * c(3,3) + c(5,5) * c(3,1) * c(4,3)) / (c(
     &5,5) * c(3,4) * c(4,3) - c(4,4) * c(5,5) * c(3,3) - c(3,5) * c(5,4
     &) * c(4,3) + c(3,5) * c(4,4) * c(5,3) + c(5,4) * c(4,5) * c(3,3) -
     & c(4,5) * c(3,4) * c(5,3)) + c(6,5) * (c(3,3) * c(4,4) * c(5,1) + 
     &c(3,1) * c(5,4) * c(4,3) + c(3,4) * c(5,3) * c(4,1) - c(3,4) * c(5
     &,1) * c(4,3) - c(3,1) * c(4,4) * c(5,3) - c(3,3) * c(5,4) * c(4,1)
     &) / (c(5,5) * c(3,4) * c(4,3) - c(4,4) * c(5,5) * c(3,3) - c(3,5) 
     &* c(5,4) * c(4,3) + c(3,5) * c(4,4) * c(5,3) + c(5,4) * c(4,5) * c
     &(3,3) - c(4,5) * c(3,4) * c(5,3))
      DMATX(3,2) = 
     &     c(6,2) - c(6,3) * (-c(4,4) * c(5,5) * c(3,2) + c(3,5) * c(4,4
     &) * c(5,2) + c(5,4) * c(4,5) * c(3,2) - c(4,5) * c(3,4) * c(5,2) +
     & c(5,5) * c(3,4) * c(4,2) - c(3,5) * c(5,4) * c(4,2)) / (c(5,5) * 
     &c(3,4) * c(4,3) - c(4,4) * c(5,5) * c(3,3) - c(3,5) * c(5,4) * c(4
     &,3) + c(3,5) * c(4,4) * c(5,3) + c(5,4) * c(4,5) * c(3,3) - c(4,5)
     & * c(3,4) * c(5,3)) - c(6,4) * (c(5,5) * c(3,2) * c(4,3) - c(5,5) 
     &* c(3,3) * c(4,2) + c(5,2) * c(4,5) * c(3,3) - c(5,3) * c(4,5) * c
     &(3,2) + c(3,5) * c(5,3) * c(4,2) - c(3,5) * c(5,2) * c(4,3)) / (c(
     &5,5) * c(3,4) * c(4,3) - c(4,4) * c(5,5) * c(3,3) - c(3,5) * c(5,4
     &) * c(4,3) + c(3,5) * c(4,4) * c(5,3) + c(5,4) * c(4,5) * c(3,3) -
     & c(4,5) * c(3,4) * c(5,3)) + c(6,5) * (c(3,4) * c(5,3) * c(4,2) + 
     &c(3,3) * c(4,4) * c(5,2) - c(3,3) * c(5,4) * c(4,2) - c(3,2) * c(4
     &,4) * c(5,3) + c(3,2) * c(5,4) * c(4,3) - c(3,4) * c(5,2) * c(4,3)
     &) / (c(5,5) * c(3,4) * c(4,3) - c(4,4) * c(5,5) * c(3,3) - c(3,5) 
     &* c(5,4) * c(4,3) + c(3,5) * c(4,4) * c(5,3) + c(5,4) * c(4,5) * c
     &(3,3) - c(4,5) * c(3,4) * c(5,3))
      DMATX(3,3) = 
     &     c(6,6) - c(6,3) * (-c(4,5) * c(3,4) * c(5,6) - c(3,5) * c(5,4
     &) * c(4,6) + c(5,4) * c(4,5) * c(3,6) - c(4,4) * c(5,5) * c(3,6) +
     & c(3,5) * c(4,4) * c(5,6) + c(5,5) * c(3,4) * c(4,6)) / (c(5,5) * 
     &c(3,4) * c(4,3) - c(4,4) * c(5,5) * c(3,3) - c(3,5) * c(5,4) * c(4
     &,3) + c(3,5) * c(4,4) * c(5,3) + c(5,4) * c(4,5) * c(3,3) - c(4,5)
     & * c(3,4) * c(5,3)) - c(6,4) * (-c(5,3) * c(4,5) * c(3,6) - c(3,5)
     & * c(5,6) * c(4,3) + c(3,5) * c(5,3) * c(4,6) + c(5,6) * c(4,5) * 
     &c(3,3) + c(5,5) * c(3,6) * c(4,3) - c(5,5) * c(3,3) * c(4,6)) / (c
     &(5,5) * c(3,4) * c(4,3) - c(4,4) * c(5,5) * c(3,3) - c(3,5) * c(5,
     &4) * c(4,3) + c(3,5) * c(4,4) * c(5,3) + c(5,4) * c(4,5) * c(3,3) 
     &- c(4,5) * c(3,4) * c(5,3)) + c(6,4) * (-c(3,3) * c(5,4) * c(4,6) 
     &+ c(3,3) * c(4,4) * c(5,6) - c(3,6) * c(4,4) * c(5,3) + c(3,6) * c
     &(5,4) * c(4,3) + c(3,4) * c(5,3) * c(4,6) - c(3,4) * c(5,6) * c(4,
     &3)) / (c(5,5) * c(3,4) * c(4,3) - c(4,4) * c(5,5) * c(3,3) - c(3,5
     &) * c(5,4) * c(4,3) + c(3,5) * c(4,4) * c(5,3) + c(5,4) * c(4,5) *
     & c(3,3) - c(4,5) * c(3,4) * c(5,3))
      ELSEIF (NTYPE.EQ.2) THEN
C Plane strain
      DMATX(1,1) = c(1,1)
      DMATX(1,2) = c(1,2)
      DMATX(1,3) = c(1,6)
      DMATX(2,1) = c(2,1)
      DMATX(2,2) = c(2,2)
      DMATX(2,3) = c(2,6)
      DMATX(3,1) = c(6,1)
      DMATX(3,2) = c(6,2)
      DMATX(3,3) = c(6,6)
      ELSEIF (NTYPE.EQ.3) THEN
C Axisymetric
      DMATX(1,1) = c(1,1)
      DMATX(1,2) = c(1,2)
      DMATX(1,3) = c(1,6)
      DMATX(1,4) = c(1,3)
      DMATX(2,1) = c(2,1)
      DMATX(2,2) = c(2,2)
      DMATX(2,3) = c(2,6)
      DMATX(2,4) = c(2,3)
      DMATX(3,1) = c(6,1)
      DMATX(3,2) = c(6,2)
      DMATX(3,3) = c(6,6)
      DMATX(3,4) = c(6,3)
      DMATX(4,1) = c(4,1)
      DMATX(4,2) = c(4,2)
      DMATX(4,3) = c(4,6)
      DMATX(4,4) = c(4,3)
      ELSE
        CALL ERRPRT('EI0019')
      ENDIF
      RETURN
      END
C
