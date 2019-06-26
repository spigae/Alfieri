      program ba
      implicit none
c
      integer i,j,ninf
      parameter(ninf=10000)
      character*3 res1(ninf)
      integer nres1(ninf),n1
c
      character*3 res2(ninf)
      integer nres2(ninf),n2
c
      open(10,file='list-prot.dat',status='unknown')
      open(11,file='list-dna.dat',status='unknown')
      open(12,file='selected-pairs.dat',status='unknown')
c
      do i=1,ninf
         read(10,*,END=500)res1(i),nres1(i)
c         write(*,*)res1(i),nres1(i)
      enddo
 500  n1=i-1
c
      do i=1,ninf
         read(11,*,END=501)res2(i),nres2(i)
c         write(*,*)res2(i),nres2(i)
      enddo
 501  n2=i-1
c
      do i=1,n1
         do j=1,n2
            write(12,*)res1(i),nres1(i),res2(j),nres2(j)
         enddo
      enddo
c
      stop
      end
