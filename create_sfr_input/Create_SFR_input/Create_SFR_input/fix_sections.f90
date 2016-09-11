!  Console1.f90 
!
!  FUNCTIONS:
!  Console1 - Entry point of console application.
!

!****************************************************************************
!
!  PROGRAM: Console1
!
!  PURPOSE:  Entry point for the console application.
!
!****************************************************************************

    program Console1

!    implicit none

    ! Variables
    real fid(140000,466),xdist(140000,466),xreal(140000,466),yreal(140000,466),z(140000,466),seg(140000,466),rch(140000,466),secnum(140000,466)
    integer jnum(466)

    ! Body of Console1
    open(2,file='sections.txt')
    open(3,file='sections.out')
    fidhold = 0
    savesecnum = 0
    numsec = 466
    do i=1,466
      j=1
      do while(fidhold==fid(j,i).or.j==1)
        read(2,*)fid(j,i),xdist(j,i),xreal(j,i),yreal(j,i),z(j,i),seg(j,i),rch(j,i),secnum(j,i)
        fidhold = fid(j,i)
        savesecnum = secnum(j,i)
        j=j+1
      end do
      jnum(i) = j - 1
      if ( savesecnum>1 )then
        numsec = numsec - 1
        ihold = i - (savesecnum-1)
        kk=1
        do k=jnum(ihold),jnum(ihold)+jnum(i)-1
            fid(k,ihold)=fid(kk,i)
            xdist(k,ihold)=xdist(kk,i)
            xreal(k,ihold)=xreal(kk,i)
            yreal(k,ihold)=yreal(kk,i)
            z(k,ihold)=z(kk,i)
            seg(k,ihold)=seg(kk,i)
            rch(k,ihold)=rch(kk,i)
            kk=kk+1
        end do
        jnum(ihold) = jnum(ihold) + kk - 1
      end if
    end do
    do i=1,numsec
        do j=1,jnum(i)
          write(3,*)fid(j,i),xdist(j,i),xreal(j,i),yreal(j,i),z(j,i),seg(j,i),rch(j,i),secnum(j,i)    
        end do
    end do
    end program Console1

