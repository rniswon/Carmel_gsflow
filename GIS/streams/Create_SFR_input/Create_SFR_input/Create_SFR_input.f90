
    
    
    module sfr_input
    implicit none
!
    ! Variables  
    type :: SfrType
      integer,pointer,dimension(:) :: iseg
      integer,pointer,dimension(:) :: OutSeg
      integer,pointer,dimension(:) :: Iupseg
      integer,pointer,dimension(:) :: iReach
      integer,pointer,dimension(:) :: jRch
      integer,pointer,dimension(:) :: kRch
      integer,pointer,dimension(:) :: iRch
      real,pointer,dimension(:) ::  RchLen
      real,pointer,dimension(:) ::  StrTop
      real,pointer,dimension(:) ::  Slope
      real,pointer,dimension(:) ::  Slopeseg,numreachperseg
      real,pointer,dimension(:) ::  Width
      real,pointer,dimension(:,:) ::  x,z
      real,pointer,dimension(:) ::  sid,xseg,xreach,xsecnum,xx,zz
      integer, pointer,dimension(:) :: xseg2
      real,pointer,dimension(:,:) :: area,topwidth,tabflow,depth,avwidth,avdepth,avflow
      integer,pointer,dimension(:) :: mainflg,numpoints,numsecperseg
      real, pointer :: eps, thts, thti, uhc, strhc1, strthick
      real, pointer ::  flow, runoff, etsw, pptsw, roughch
      integer, pointer ::  icalc, numseg, idum, nstrpts
      integer, pointer ::  ITMP, IRDFLG, IPTFLG, i, j
      integer, pointer ::  nsfrpar,nparseg,istcb1,istcb2,isfropt,nstrail,isuzn,nsfrsets
      real, pointer ::  const, dleak
    contains
      procedure :: sfr_al
      procedure :: sfr_init
      procedure :: sfr_rd
      procedure :: sfr_write
      procedure :: section_area
      procedure :: sfr_cross
    end type SfrType
    
    contains
    
    subroutine sfr_al(this,numreach,numseg,numpoints,numsections)
    class(SfrType) :: this
    integer, intent(in) :: numreach,numseg,numpoints,numsections
    allocate(this%iseg(numreach),this%OutSeg(numreach),this%iReach(numreach),this%jRch(numreach))
    allocate(this%kRch(numreach),this%iRch(numreach),this%RchLen(numreach),this%StrTop(numreach))
    allocate(this%Iupseg(numreach),this%width(numreach),this%Slope(numreach),this%mainflg(numreach))
    allocate(this%x(numpoints,numsections),this%z(numpoints,numsections),this%area(numpoints,numsections))
    allocate(this%topwidth(numpoints,numsections),this%tabflow(numpoints,numsections),this%depth(numpoints,numsections))
    allocate(this%sid(numsections*numpoints),this%xseg(numsections*numpoints),this%xreach(numsections*numpoints),this%xsecnum(numsections*numpoints))
    allocate(this%xx(numsections*numpoints),this%zz(numsections*numpoints))
    allocate(this%numpoints(numsections),this%numsecperseg(numseg))
    allocate(this%avwidth(numseg,numseg),this%avdepth(numseg,numseg),this%avflow(numseg,numseg))
    allocate(this%slopeseg(numreach),this%xseg2(numseg),this%numreachperseg(numreach))
    allocate(this%eps)
    allocate(this%thts)
    allocate(this%thti)
    allocate(this%uhc)
    allocate(this%strhc1)
    allocate(this%strthick)
    allocate(this%icalc)
    allocate(this%flow)
    allocate(this%runoff)
    allocate(this%etsw)
    allocate(this%pptsw)
    allocate(this%roughch)
    allocate(this%nstrpts)
    allocate(this%ITMP)
    allocate(this%IRDFLG)
    allocate(this%IPTFLG)
    allocate(this%nsfrpar)
    allocate(this%nparseg)
    allocate(this%const)
    allocate(this%dleak)
    allocate(this%istcb1)
    allocate(this%istcb2)
    allocate(this%isfropt)
    allocate(this%nstrail)
    allocate(this%isuzn)
    allocate(this%nsfrsets)
    end subroutine sfr_al
    
    subroutine sfr_init(this,numreach,numseg)
    class(SfrType) :: this
    integer, intent(in) :: numreach,numseg
    this%eps = 4.0
    this%thts = 0.3
    this%thti = 0.2
    this%uhc = 0.5
    this%strhc1 = 0.3
    this%strthick = 1.0
    this%icalc = 1
    this%flow = 0.0
    this%runoff = 0.0
    this%etsw= 0.0
    this%pptsw = 0.0
    this%roughch = 0.04
    this%nstrpts = 18
    this%ITMP = numseg
    this%IRDFLG = 0
    this%IPTFLG = 0
    this%nsfrpar = 0
    this%nparseg = 0
    this%const = 86400.0
    this%dleak = 1.0e-4
    this%istcb1 = 0
    this%istcb2 = 0
    this%isfropt = 3
    this%nstrail = 7
    this%isuzn = 1
    this%nsfrsets = 30
    this%x = 0.0
    this%z = 0.0
    this%sid = 0.0
    this%area = 0.0
    this%topwidth = 0.0
    this%tabflow = 0.0
    this%depth = 0.0
    this%xseg2 = 0
    this%avdepth = 0.0
    this%avwidth = 0.0
    this%avflow = 0.0
    this%numsecperseg = 0
    this%numreachperseg = 0
    this%topwidth = 0.0
    this%tabflow = 0.0
    this%depth = 0.0
    this%slopeseg = 0.0
    end subroutine sfr_init
    
    subroutine sfr_rd(this,numreach,numseg,funit)
    class(SfrType) :: this
    integer, intent(in) :: numreach,numseg,funit
    integer i
    real dum
!
    read(10,*)
    do i=1,numreach
    read(funit,*)this%iseg(i),this%iReach(i),this%OutSeg(i),this%iupseg(i),this%RchLen(i),this%iRch(i),    &
                 this%jRch(i),this%kRch(i),this%StrTop(i),this%Slope(i),this%Width(i),dum,dum,dum,         &
                 this%mainflg(i)
    end do
    do i=1,numreach
      this%slopeseg(this%iseg(i)) = this%slopeseg(this%iseg(i)) + this%Slope(i)
      this%numreachperseg(this%iseg(i)) = this%numreachperseg(this%iseg(i)) + 1
    end do
    
    do i=1,numseg
      this%slopeseg(i) = this%slopeseg(i)/this%numreachperseg(i)
    end do
    
    end subroutine sfr_rd
    
    subroutine sfr_cross(this,numcross,funit,numseg)
    class(SfrType) :: this
    integer, intent(in) :: numcross,funit,numseg
    integer i, j, jj,trap,flag,jjj
    real fold,xhold,yhold,ylochold,xlochold,junk
    integer icheck
    fold = 1.0e9
!        open(99,file='test')
    
    do i=1,93663
        read(funit,*)this%sid(i),this%xx(i),this%zz(i),this%xseg(i),this%xreach(i),this%xsecnum(i)
    end do
    jj=2
    j=2
    i=1
    this%x(1,1) = this%xx(1)
    this%z(1,1) = this%zz(1)
    do while (i<=260)
        trap=1
            this%x(j,i) = this%xx(jj)
            this%z(j,i) = this%zz(jj)
            j = j + 1
            jj = jj + 1
        do while (this%xsecnum(jj-1)<=this%xsecnum(jj).and.trap==1)
            this%x(j,i) = this%xx(jj)
            this%z(j,i) = this%zz(jj)
          trap=1
          if(this%xsecnum(jj-1)+this%xsecnum(jj)==0.and.this%sid(jj-1)/=this%sid(jj))trap=0
          jj = jj + 1
          j = j + 1
        end do
        this%numpoints(i) = j-1
        j=1
        this%xseg2(i) = this%xseg(jj)
        i = i + 1
 !       jj = jj + 1
    end do
    
    jj=1
    jjj=0
    do i=1,325
        flag=0
        do j=1,this%numpoints(i)
          jjj = jjj + 1
          if(j>1)then
            if(this%x(j,i)<this%x(j-1,i))then
            if (this%xsecnum(jjj)/=this%xsecnum(jjj-1))flag = 0
            if (flag==0)then
                this%x(j,i)=this%x(j-1,i)+this%x(j,i)+1.0e-3
                jj=j-1
            else             
                this%x(j,i)=this%x(jj,i)+this%x(j,i)
            end if
            flag=1
            end if
          end if
!          write(99,1)i,j,jjj,this%x(j,i),this%z(j,i),this%xsecnum(jjj)
        end do
    end do
!1   format(3i6,3e15.5) 
    do i=1,260
      call this%section_area(i,this%numpoints(i))
    end do
    
    do i =1,260
      do j =1,40
          icheck = this%xseg2(i)
          junk = this%slopeseg(this%xseg2(i))**0.5
        this%avdepth(j,this%xseg2(i)) = this%avdepth(j,this%xseg2(i)) + this%depth(j,i)
        this%avwidth(j,this%xseg2(i)) = this%avwidth(j,this%xseg2(i)) + this%Topwidth(j,i)
        this%avflow(j,this%xseg2(i)) =  this%avflow(j,this%xseg2(i)) +  this%tabflow(j,i)*this%slopeseg(this%xseg2(i))**0.5
      end do
      this%numsecperseg(this%xseg2(i)) = this%numsecperseg(this%xseg2(i)) + 1
    end do
    
    do i =1,numseg
      do j =1,40
        this%avdepth(j,i) = this%avdepth(j,i)/this%numsecperseg(i)
        this%avwidth(j,i) = this%avwidth(j,i)/this%numsecperseg(i)
        this%avflow(j,i) =  this%avflow(j,i)/this%numsecperseg(i)
      end do
    end do
    
    !do i =1,numseg
    !  do j =1,40
    !    if ( this%numsecperseg(i) > 0 ) then
    !      write(99,*)j,i,this%avdepth(j,i),this%avwidth(j,i),this%avflow(j,i)
    !    end if
    !  end do
    !end do

    end subroutine
    
    
    subroutine sfr_write(this,numreach,numseg,funit)
    class(SfrType) :: this
    integer, intent(in) :: numreach,numseg,funit
    integer i,j
    write(funit,*)'REACHINPUT'
    write(funit,300)numreach,numseg,this%nsfrpar,this%nparseg,this%const,this%dleak,this%istcb1,   &
                    this%istcb2,this%isfropt,this%nstrail,this%isuzn,this%nsfrsets
300 format(4i6,2(1x,e12.6),6(1x,i5))
    
    do i=1,numreach
    write(funit,100)this%kRch(i),this%iRch(i),this%jRch(i),this%iseg(i),this%iReach(i),this%rchLen(i),       &
                    this%StrTop(i),this%Slope(i),this%strthick,this%strhc1,this%thts,this%thti,this%eps,this%uhc
    end do
100 format(5i6,9(1x,e12.6))
    write(funit,*) this%ITMP, this%IRDFLG, this%IPTFLG
    do i =1,numreach
! check for 
    if (i==1)then
      if ( this%numsecperseg(this%iseg(i)) == 0 ) then
        this%icalc = 1
        write(funit,200)this%iseg(i),this%icalc,this%OutSeg(i),this%iupseg(i), this%flow, this%runoff,       &
                        this%etsw, this%pptsw, this%roughch
        write(funit,*)this%width(i)
        write(funit,*)this%width(i)
      else
        this%icalc = 4
        write(funit,500)this%iseg(i),this%icalc,this%OutSeg(i),this%iupseg(i),this%nstrpts, this%flow, this%runoff,       &
                        this%etsw, this%pptsw
        write(funit,400)(this%avflow(j,this%iseg(i)),j=1,this%nstrpts)
        write(funit,400)(this%avdepth(j,this%iseg(i)),j=1,this%nstrpts)
        write(funit,400)(this%avwidth(j,this%iseg(i)),j=1,this%nstrpts)
      end if
    elseif (this%iseg(i).ne.this%iseg(i-1))then
      if ( this%numsecperseg(this%iseg(i)) == 0 ) then
          this%icalc = 1
        write(funit,200)this%iseg(i),this%icalc,this%OutSeg(i),this%iupseg(i),this%flow,this%runoff,         &
                      this%etsw,this%pptsw,this%roughch
        write(funit,*)this%width(i)
        write(funit,*)this%width(i)
      else
          this%icalc = 4
        write(funit,500)this%iseg(i),this%icalc,this%OutSeg(i),this%iupseg(i),this%nstrpts,this%flow,this%runoff,         &
                      this%etsw,this%pptsw
        write(funit,400)(this%avflow(j,this%iseg(i)),j=1,this%nstrpts)
        write(funit,400)(this%avdepth(j,this%iseg(i)),j=1,this%nstrpts)
        write(funit,400)(this%avwidth(j,this%iseg(i)),j=1,this%nstrpts)
      end if
    end if
    end do
200 format(4i6,5(1x,e12.6))
400 format(500e20.10)
500 format(5i6,4(1x,e12.6))
    end subroutine sfr_write
    
    subroutine section_area(this,kk,numpnts)
    class(SfrType) :: this
    integer, intent(in) :: kk,numpnts
    real, dimension(:),allocatable :: botelev,fmanns
	real, dimension(:,:),allocatable :: flow,depth
    integer numnode,numbranch,i,j,l,k,ii,imin,ixmax,ixmin
	real theta,time,endtime,deltat,numtimesteps,checks,slope
    real area1,areaf,B,chap,dum,ffmax,ffmin,fmax,fmaxx,ftop,xmax
    real fcheck,fmin,fminxx,shift
	integer, dimension(:),allocatable :: mark
    real wetted,stage,stepy,width,xinc,xmid,xmin,xx,y1,y2,yy,test
    
    allocate(mark(numpnts))

!	SET ADDITATIVE VARIABLES TO ZERO
	areaf=0.0
    area1=0.0
	wetted=0.0
	xmid=0.0
    mark=0
    slope=0.0
    imin = 1   
    shift = 0.0  
    do i=1,numpnts-1
      if ( this%z(i,kk) < this%z(imin,kk) ) imin = i
    end do
    shift = this%z(imin,kk)
    do i=1,numpnts-1
      this%z(i,kk) = this%z(i,kk) - shift
    end do
    
    !do i=1,numpnts-1
    !  write(99,*)i,this%x(i,kk),this%z(i,kk),numpnts-1
    !end do 

	
! restrict to 50 meters both sides of thalweg   
    ixmax = imin
    ixmin = imin
    do i=imin,numpnts-1
      if ( this%x(i,kk) < this%x(imin,kk) + 50.0 ) ixmax = i
    end do
    xmax = this%x(ixmax,kk)
    
    do i=imin,1,-1
      if ( this%x(i,kk) > this%x(imin,kk) - 50.0 ) ixmin = i
    end do
    
    xmin = this%x(ixmin,kk)
    
    
    !     FIND THE MAX AND MIN CHANNEL ELEVATIONS  
    fmax = -1e6
    do i = ixmin,ixmax
      if ( this%z(i,kk) > fmax ) fmax = this%z(i,kk)
    end do
    fmin = fmax
	do i=2,numpnts-1
	  if(this%z(i,kk) .lt. fmin)then
        fmin=this%z(i,kk)
        imin = i
      end if
    end do
    
    this%z(ixmax,kk) = fmax
    this%z(ixmin,kk) = fmax
    
	stepy=(fmax-fmin)/21
	stage=fmin
    
!     ITERATE OVER A RANGE OF STAGES
	do i=1,20
	mark=0


!	WHAT POINTS ARE BELOW THE WATER STAGE
	k=0
	do j=ixmin+1,ixmax
    !dum = this%z(j,kk)
    !dum = this%z(j-1,kk)
	if(this%z(j,kk) .lt. stage+0.001 .or.this%z(j-1,kk) .lt. stage+0.001)then
	k=k+1
	mark(k)=j
	end if 
	end do


!	BREAK CHANNEL UP INTO A SERIES OF LINES BETWEEN POINTS
!	CALCULATE THE EQUATION OF EACH LINE TO CALCULATE AREA

	do l=1,k
	chap=(this%z(mark(l)-1,kk)-this%z(mark(l),kk))
	slope=(this%z(mark(l),kk)-this%z(mark(l)-1,kk))/         &
      	  (this%x(mark(l),kk)-this%x(mark(l)-1,kk))
	 
    ffmin=this%z(mark(l),kk)
	ffmax=this%z(mark(l)-1,kk)
	if(ffmin .gt. ffmax)then
	ffmin=this%z(mark(l)-1,kk)
	ffmax=this%z(mark(l),kk)
	end if

	xmin=this%x(mark(l)-1,kk)
	b=this%z(mark(l)-1,kk)-slope*this%x(mark(l)-1,kk)

!	HOLD MIN AND MAX X LOCATIONS TO CALC TOPWIDTH	
	if(l .eq. 1)fminxx=(stage-b)/slope
	if(l .eq. k)fmaxx=(stage-b)/slope

!	CONSIDER A FLAT CHANNEL BOTTOM
	if(chap .eq. 0.0)then
	area1=(this%x(mark(l),kk)-this%x(mark(l)-1,kk))*(stage-ffmin)
	else

!	DOES STAGE LAND BETWEEN POINTS OR ABOVE
	if(stage .gt. ffmax)then
	xinc=(this%x(mark(l),kk)-this%x(mark(l)-1,kk))/20
	xmid=this%x(mark(l)-1,kk)
	else
	ffmax=stage
	xmid=(stage-b)/slope
	
!	MOVING DOWN THE CHANNEL BANK OR UP THE OTHER SIDE
	if(this%z(mark(l)-1,kk) .lt. this%z(mark(l),kk))then
	xinc=(abs(this%x(mark(l)-1,kk)-xmid))/20
	xmid=this%x(mark(l)-1,kk)
	else
	xinc=(abs(this%x(mark(l),kk)-xmid))/20
	end if
	end if

!	CALCULATE WETTED PARIMETER	
	xx=abs(xmid-this%x(mark(l),kk))
	yy=abs(ffmax-ffmin)
    if ( sqrt((xx**2)+(yy**2)) < 0.5 ) then
    wetted=wetted+0.5
    else
	wetted=wetted+sqrt((xx**2)+(yy**2))
    end if


!	BREAKING AREA UP INTO TRAPAZOIDS
	
	do ii=1,20
	y1=slope*xmid+b

	y2=slope*(xmid+xinc)+b

	checks=(((stage-y1)+(stage-y2))/2)

	areaf=areaf+(((stage-y1)+(stage-y2))/2)*xinc
	xmid=xmid+xinc

	end do
	end if
	end do
	fcheck=abs(stage-fmin)
	if(fcheck .gt. .01)then
	this%Area(i,kk)=areaf+area1
	this%Topwidth(i,kk)= fmaxx-fminxx
	this%tabflow(i,kk)=(this%Area(i,kk)*this%const*(this%Area(i,kk)/wetted)**(2.0/3.0))/this%roughch
    this%depth(i,kk) = stage
	end if

	stage=stage+stepy
    end do
    !do i=1,40
    !write(99,*)this%depth(i,kk),this%area(i,kk),this%tabflow(i,kk)
    !end do
    deallocate(mark)
	return
    end subroutine section_area
    
    end module sfr_input

