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
    INTEGER Reason, insub, numsubval, isubnum, nhru, j
    REAL r, scale
    REAL,SAVE,DIMENSION(:),POINTER :: param,subbasin
    in2 = 8
    inscale = 9
    in = 10
    out2 = 12
    iout = 11
    insub = 13
    Iostat = 1
    open(inscale,file='scale.txt')
    open(insub,file='subbasin.txt')
    open(in,file='carmel_main.param')
    open(out2,file='carmel_scaled.param')
    open(in2,file='rain_adj')
    open(iout,file='scale.out')
!
! read subbasin ID for each HRU
    read(insub,*)numsubval
    allocate (subbasin(numsubval))
    do i =1, numsubval
    read(insub,*)subbasin(i)
    end do
    close(insub)
!
! read scale factor
    read(inscale,*)scale,isubnum,nhru
    i=0
! find parameter(s) of interest for scaling
     DO
        i = i + 1  !save i for below
        read(in,*,IOSTAT=Iostat) line
        LLOC=1
        CALL URWORD(LINE,LLOC,ISTART,ISTOP,1,I,R,IOUT,IN)
        select case (LINE(ISTART:ISTOP))
        case('RAIN_ADJ')
            read(in,*) line
            read(in,*) line
            read(in,*) line  ! this line needed for 2D parameters (e.g., nmonths, nhru)
            read(in,*) numvals
            read(in,*) line         !next value to read will be first parameter value
            write(iout,*)'found RAIN_ADJ'
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
        
! Read current parameter values and scale them according to subbasin ID
! Advance file pointer
        do i=1,7
          read(in2, *)  
        end do
        j = 0
        do i = 1, numvals
          j = j + 1
          if ( j > nhru ) j = 1
          read(in2, *)param(i)
          if ( isubnum == subbasin(j) ) then
            param(i) = scale*param(i)
          end if
        end do
! 
!  start back at top of file
        close(in)
        
        
        open(in,file='carmel.param')
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

