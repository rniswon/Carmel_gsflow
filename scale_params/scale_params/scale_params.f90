!  scale_params.f90 
!
!  FUNCTIONS:
!  scale_params - Entry point of console application.
!

!****************************************************************************
!
!  PROGRAM: scale_params
!
!  PURPOSE:  Entry point for the console application.
!
!****************************************************************************

    program scale_params

    implicit none

    ! Variables
    CHARACTER(LEN=200) line 
    CHARACTER(LEN=20) paramname
    INTEGER LLOC,ISTART,ISTOP,I,IOUT,IN,numvals,inscale,iloc,intchk,Iostat,in2
    REAL r, scale
    REAL,SAVE,DIMENSION(:),POINTER :: param
    in2 = 8
    inscale = 9
    in = 10
    iout = 11
    Iostat = 1
    open(inscale,file='scale_ssr2gw_rate.dat')
    open(in,file='carmel_main.param')
    open(in2,file='ssr2gw_rate_static.dat')
    open(iout,file='scale.out')
    read(inscale,*)scale
    i=0
! find parameter of interest for scaling
     DO
        i = i + 1  !save i for below
        read(in,*,IOSTAT=Iostat)line
        LLOC=1
        CALL URWORD(LINE,LLOC,ISTART,ISTOP,1,I,R,IOUT,IN)
        select case (LINE(ISTART:ISTOP))
        case('SSR2GW_RATE')
            read(in,*)
            read(in,*)
            read(in,*)numvals
            read(in,*)              !next value to read will be first parameter value
            write(iout,*)'found ssr2gw_rate'
            exit
        case default
            if( Iostat < 0 ) then
              write(11,*)'end of file reached without finding parameter to scale'
              exit
            end if
        end select
      end do
! allocate array to hold parameter
        allocate (param(numvals))
        
!       read current parameter values
        do i = 1, numvals
          read(in2, *)param(i)
          param(i) = scale*param(i)
        end do
! 
!  skip back to line in parameter file to write scaled value
        rewind(in)
!  set location where parameter starts in paramter file
        iloc = i + 4
        do i = 1, iloc
            read(in,*)
        end do
!
        do i = 1, numvals
          write(in,*)param(i)
        end do
    end program scale_params

