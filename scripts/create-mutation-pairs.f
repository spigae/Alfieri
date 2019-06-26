      program mutpos
      implicit none
c
      integer i,j,k,l,m,n,o,p
      integer nmut
      integer n1,np
      parameter(np=8)
      character*1 b(np)
      character*1 b1(np)
c
      open(10,file='mutations.dat',status='unknown')
      open(11,file='nmut.dat',status='unknown')
c
      read(11,*)nmut
c
      do i=1,nmut
         read(10,*)(b(j),j=1,8)
c         write(*,*)(b(j),j=1,8)
c
         do j=1,8
            if (b(j).eq."A")then
               b1(j)="T"
            elseif (b(j).eq."T")then
               b1(j)="A"
            elseif (b(j).eq."G")then
               b1(j)="C"
            elseif (b(j).eq."C")then
               b1(j)="G"
            endif
         enddo
c
         do j=1,8
            write(*,100)'c=A',' ','s=',j,' ','m=',b(j)
c            write(*,*)8-j+1
         enddo
c
         do j=1,8
            if(j+8.lt.10)then
               write(*,100)'c=B',' ','s=',j+8,' ','m=',b1(8-j+1)
            else
               write(*,101)'c=B',' ','s=',j+8,' ','m=',b1(8-j+1)
            endif
         enddo
c
      enddo
c
c
 100  format(a3,a1,a2,i1,a1,a2,a1)
 101  format(a3,a1,a2,i2,a1,a2,a1)
c
      stop
      end
