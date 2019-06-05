!  raise_river.f90 
!
!  FUNCTIONS:
!  raise_river - Entry point of console application.
!

!****************************************************************************
!
!  PROGRAM: raise_river
!
!  PURPOSE:  Entry point for the console application.
!
!****************************************************************************

    
    program raise_river

    implicit none

    ! Variables
    real, allocatable, dimension(:) :: strm_top
    integer, allocatable, dimension(:) :: ISEG,KRCH,IRCH,JRCH,OUTSEG,IREACH
    integer :: ns,i,j,ns2
    real :: delta,delta2    
    character*100 header

    ! Body of raise_river
    delta = 2.134
    delta2 = 3.048
    ns = 2436
    allocate(strm_top(ns))
    allocate(ISEG(ns),KRCH(ns),IRCH(ns),JRCH(ns),OUTSEG(ns),IREACH(ns))
!    open(3,file="segs_rise.out")
    open(2,file="streams.out")
    open(1,file="streams.txt")
    read(1,*)header
    do i=1,ns
      read(1,*)ISEG(i),IRCH(i),JRCH(i),OUTSEG(i)
    end do
! Raise upper part of river (SC dam to narrows)
    strm_top = 0.0
    j = 1053
    i=0
    do while ( j/=279 )
      i = i + 1
      if( iseg(i)==j ) then
        strm_top(i) = delta
        j = OUTSEG(i)
        i=0
      end if
    end do
    strm_top(279) = delta
! Raise lower part of river (narrows to lagoon)    
    j = 278
    i=0
    do while ( j/=141 )
      i = i + 1
      if( iseg(i)==j ) then
        strm_top(i) = delta2
        j = OUTSEG(i)
        i=0
      end if
    end do
    strm_top(141) = delta2
    write(2,*)'IRCH JRCH ISEG OUTSEG DELTA'
    do i = 1, ns
    write(2,10)IRCH(i),JRCH(i),ISEG(i),OUTSEG(i),strm_top(i)
    end do
10  format(4i5,f10.5)
    end program raise_river

