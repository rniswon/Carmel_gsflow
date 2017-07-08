
!main code here
!    program create_sfr_input
    use sfr_input, only: SfrType  !UZF2
    integer :: numreach
    integer :: numseg
    type(SfrType), pointer :: sfrobj !uzf2
    allocate(sfrobj)
! set dimension variables
    !numreach = 10790
    !numseg = 2437
    !numsections = 466
    !numpoints = 10000
    
    open(10,file='sfr_data.dat')
    open(12,file='input.sfr')
    open(14,file='sections.txt')
! TWO HEADER LINES
    READ(10,*)
    READ(10,*)
    read(10,*)numreach,numseg,numsections,numpoints
    
    call sfrobj%sfr_al(numreach,numseg,numpoints,numsections)
    call sfrobj%sfr_init(numreach,numseg)
    call sfrobj%sfr_rd(numreach,numseg,10)
    
    
    if (numsections>0 ) call sfrobj%sfr_cross(numsections,14,numseg)    
    call sfrobj%sfr_write(numreach,numseg,12)
    
    end