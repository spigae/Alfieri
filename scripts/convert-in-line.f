      program ba
      implicit none
c
c version script: 0.1
c Revised last time: 20.10.2016
c Authors: Enrico Spiga
c Institutions: The Francis Crick Institute
c
      integer i,n
      parameter(n=8)
      character*1 r(n)
c
      open(10,file='list',status='unknown')
c
      do i=1,n
         read(10,100)r(i)
      enddo
      write(*,FMT='(8a1)')(r(i),i=1,n)
c
 100  format(2x,a1)
c
      stop
      end
