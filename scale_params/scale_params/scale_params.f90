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
    INTEGER LLOC,ISTART,ISTOP,I,out,IN,numvals,inscale,iloc,intchk,Iostat,in2,out2,L,isave
    integer out3
    INTEGER Reason,subbasin_id,jsave,j,mc,mcc
    REAL r
    REAL,SAVE,DIMENSION(:),POINTER :: param
    INTEGER,SAVE,DIMENSION(:),POINTER :: subbasin, month
    REAL,SAVE,DIMENSION(:),POINTER :: scale
    in2 = 8
    inscale = 9
    in = 10
    out2 = 12
    out3 = 13
    out = 11
    Iostat = 1
    subbasin_id = 1  !default
    allocate(scale(12),month(12))  ! one for each month
    scale = 0.0
    month = 1
    open(inscale,file='scale_param.dat')
    open(in,file='carmel_main.param')
    open(out2,file='carmel_scaled.param')
    open(in2,file='param_start.dat')
    open(out3,file='param_save.dat')
    open(out,file='scale.out')
! Read user input for scaling factor and subbains ID
    read(inscale,*)subbasin_id
    do i=1,12
    read(inscale,*)month(i),scale(i)   !rain_adj scale for each month
    end do
    !i=1
    !read(inscale,*)month(i),scale(i)   !for nru parameters
! find parameter(s) of interest for scaling
     i = 0
     DO
        i = i + 1  !save i for below
        read(in,*,IOSTAT=Iostat) line
        LLOC=1
        CALL URWORD(LINE,LLOC,ISTART,ISTOP,1,I,R,out,IN)
        select case (LINE(ISTART:ISTOP))
        case('HRU_SUBBASIN')
            read(in,*) line
            read(in,*) line
            read(in,*) numvals
            read(in,*) line         !next value to read will be first parameter value
            write(out,*)'found HRU_SUBBASIN'
            exit
        case default
            if( Iostat < 0 ) then
              write(11,*)'end of file reached without finding parameter to scale'
              exit
            end if
        end select
     end do
     jsave = numvals
! allocate array to hold subbasin id
        allocate (subbasin(numvals))
        
!  read subbasin_id
        do i = 1, numvals
          read(in, *)subbasin(i)
        end do
    rewind(in)
! find parameter(s) of interest for scaling
     i=0
     DO
        i = i + 1  !save i for below
        read(in,*,IOSTAT=Iostat) line
        LLOC=1
        CALL URWORD(LINE,LLOC,ISTART,ISTOP,1,I,R,out,IN)
        select case (LINE(ISTART:ISTOP))
        case('RAIN_ADJ')
            read(in,*) line
            read(in,*) line
            read(in,*) line  ! One less line for nhru params DPRST_FRAC_HRU
            read(in,*) numvals
            read(in,*) line         !next value to read will be first parameter value         
            write(out,*)'found RAIN_ADJ'
            exit
        case default
            if( Iostat < 0 ) then
              write(out,*)'end of file reached without finding parameter to scale'
              exit
            end if
        end select
     end do
     isave = i - 1  !reset to before parameter name
!
! allocate array to hold parameter
        allocate (param(numvals))
! read past header info
        do j=1,6      !6 for rain adj
        read(in2,*)line
        end do     
!
!       read current parameter values
        j=0
        mc=1
        do i = 1, numvals
          j = j + 1
! increment month in rain_adj; make inactive if nhru param
          if ( j>jsave ) then
              j = 1
              mc = mc + 1
          end if
          mcc = month(mc)
          read(in2, *)param(i)
          if( subbasin(j)==subbasin_id ) then
              param(i) = scale(mcc)*param(i)
          end if
        end do
! 
!  start back at top of file
        rewind(in)
!  set location in parameter file before header
        iloc = isave
        do i = 1, iloc
            READ(IN,'(A)') LINE
            WRITE(out2,'(A)') TRIM(adjustl(line))
        end do
        do i = 1, 6   !6 for rain_adj !write header lines
            READ(IN,'(A)') LINE
            WRITE(out2,'(A)') TRIM(adjustl(line))
            WRITE(out3,'(A)') TRIM(adjustl(line))
        end do
! update new scaled values in parameter file
        do i = 1, numvals
          ! Advance file pointer
          !READ(IN,'(A)') LINE          
          ! Insert new lines
          write(line2,*)param(i)
          write(out2,*)TRIM(adjustl(line2))
          write(out3,*)TRIM(adjustl(line2))
        end do
        
! finish transfering lines     
        !do
        !  READ(IN,'(A)',IOSTAT=Reason)  line
        !  IF (Reason > 0)  THEN
        !     exit
        !  ELSE IF (Reason < 0) THEN
        !     exit
        !  ELSE
        !    write(out2,*) TRIM(adjustl(line))
        !  END IF
        !END DO
        
        close(IN)
        close(IN2)
        close(out)
        close(out2)
        close(out3)
   
    end program scale_params

