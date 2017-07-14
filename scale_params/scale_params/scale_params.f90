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
    CHARACTER(LEN=80) line 
    CHARACTER(LEN=40) line2
    INTEGER LLOC,ISTART,ISTOP,I,IOUT,IN,numvals,inscale,iloc,intchk,Iostat,in2,out2,L,isave
    INTEGER Reason
    REAL r, scale
    REAL,SAVE,DIMENSION(:),POINTER :: param
    in2 = 8
    inscale = 9
    in = 10
    out2 = 12
    iout = 11
    Iostat = 1
    open(inscale,file='scale_ssr2gw_rate.dat')
    open(in,file='carmel_main.param')
    open(out2,file='carmel_main_scaled.param')
    open(in2,file='ssr2gw_rate_static.dat')
    open(iout,file='scale.out')
    read(inscale,*)scale
    i=0
! find parameter(s) of interest for scaling
     DO
        i = i + 1  !save i for below
        read(in,*,IOSTAT=Iostat) line
        LLOC=1
        CALL URWORD(LINE,LLOC,ISTART,ISTOP,1,I,R,IOUT,IN)
        select case (LINE(ISTART:ISTOP))
        case('SSR2GW_RATE')
            read(in,*) line
            read(in,*) line
            read(in,*) numvals
            read(in,*) line         !next value to read will be first parameter value
            write(iout,*)'found ssr2gw_rate'
            exit
        case default
            if( Iostat < 0 ) then
              write(11,*)'end of file reached without finding parameter to scale'
              exit
            end if
        end select
     end do
     isave = i
! allocate array to hold parameter
        allocate (param(numvals))
        
!       read current parameter values
        do i = 1, numvals
          read(in2, *)param(i)
          param(i) = scale*param(i)
        end do
! 
!  start back at top of file
        close(in)
        
        
        open(in,file='carmel_main.param')
!  set location in parameter file for start of values
        iloc = isave + 4
        do i = 1, iloc
            READ(IN,'(A)') LINE
            WRITE(out2,'(A)') TRIM(adjustl(line))
        end do
! update new scaled values in parameter file
        do i = 1, numvals
          ! Advance file pointer
          READ(IN,'(A)') LINE
          
          ! Insert new lines
          write(line2,*)param(i)
          write(out2,*)TRIM(adjustl(line2))
        end do
        
! finish transfering lines     
        do
          READ(IN,'(A)',IOSTAT=Reason)  line
          IF (Reason > 0)  THEN
             exit
          ELSE IF (Reason < 0) THEN
             exit
          ELSE
            write(out2,*) TRIM(adjustl(line))
          END IF
        END DO
        
        close(IN)
        close(out2)
   
    end program scale_params

