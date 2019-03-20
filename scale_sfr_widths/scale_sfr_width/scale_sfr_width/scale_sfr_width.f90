!  scale_sfr_width.f90 
!
!  FUNCTIONS:
!  scale_sfr_width - Entry point of console application.
!

!****************************************************************************
!
!  PROGRAM: scale_sfr_width
!
!  PURPOSE:  Entry point for the console application.
!
!****************************************************************************

    program scale_sfr_width

    implicit none

    ! Variables
        character(len=200) :: line
        character(len=600) :: line2
        integer :: LLOC,ISTART,ISTOP, iseg, icalc, numseg
        integer :: in, iout, iout2,subunit,i,j,nreach,nseg
        INTEGER,SAVE,DIMENSION(:),POINTER :: seg
        real, save, dimension(:), pointer :: uhc
        real :: width1, width2, scale, r, scaleuhc
        integer :: item1,item2,item3,item4,item5,Iostat
        real :: fitem6,fitem7,fitem8,fitem9,fitem11,fitem12,fitem13,fitem14,drop
    ! Body of scale_sfr_width
        in = 1
        iout = 2
        subunit = 3
        iout2 = 4
        scale = 2.3
        scaleuhc = 5.0
        drop = 0.95
        i = 0
        r = 0.0
        open(in,file='sfrinput.txt')
        open(iout,file='Carmel.sfr')
        open(iout2,file='debug.txt')
        open(subunit,file='seglist.txt')
 !   
    ! read list of segments to change width
        read(subunit,*)numseg
        allocate(seg(numseg))
        do i=1,numseg
            read(subunit,*)seg(i)
        end do
! Read header and options
        do
        CALL URDCOM(In, IOUT, line)
        write(iout,100)line   
        lloc=1
        CALL URWORD(LINE,LLOC,ISTART,ISTOP,1,I,R,IOUT2,IN)
        select case(line(istart:istop))
        case ('END')
          exit
        end select
        end do  
    !
    ! read nreach, nseg, etc.
        CALL URDCOM(In, IOUT2, line)
        write(iout,100)line
        lloc=1
        CALL URWORD(LINE,LLOC,ISTART,ISTOP,2,nreach,R,IOUT2,IN)
        CALL URWORD(LINE,LLOC,ISTART,ISTOP,2,nseg,R,IOUT2,IN)
        allocate(uhc(nreach))      
!
    ! read reach information
        do i = 1, nreach
            read(in,*)item1,item2,item3,iseg,item5,fitem6,fitem7,fitem8,fitem9,uhc(i),fitem11,fitem12,fitem13,fitem14
    !
    ! scale streambed K if in selected subbasin
            do j=1,numseg
              if(iseg==seg(j)) then
                uhc(i) = scaleuhc*uhc(i)
                fitem7 = fitem7 - drop
              end if
            end do
            write(iout,666)item1,item2,item3,iseg,item5,fitem6,fitem7,fitem8,fitem9,uhc(i),fitem11,fitem12,fitem13,fitem14
        end do
666   format(5i8,9e20.10) 
    ! read line 6A
        CALL URDCOM(In, IOUT2, line)
        write(iout,100)line
    ! read original sfr segment data
        DO j=1,2440
          CALL URDCOM(In, IOUT2, line)
!          write(iout,100)line
          LLOC=1
          CALL URWORD(LINE,LLOC,ISTART,ISTOP,2,iseg,R,IOUT2,IN)
          CALL URWORD(LINE,LLOC,ISTART,ISTOP,2,icalc,R,IOUT2,IN)
          backspace(in)
          if (icalc==4)then
            do i=1,4
              read(in,200) line2
              write(iout,200)line2
            end do
          else
            CALL URDCOM(In, IOUT2, line)
            read(in,*)width1
            read(in,*)width2
            do i=1,numseg
                if(iseg==seg(i)) then
                  width1 = width1 * scale
                  width2 = width2 * scale
                end if
            end do
            write(iout,100)line
            write(iout,*)width1
            write(iout,*)width2
          end if
        end do
    ! finish copying any other lines over
        do
        read(in,100,IOSTAT=Iostat) line
        if( Iostat < 0 ) exit
        write(iout,100)line
        end do
100           format(A200) 
200           format(A600) 

    end program scale_sfr_width

