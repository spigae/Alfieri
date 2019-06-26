      program mutpos
      implicit none
c
      integer i,j,k,l,m,n,o,p
      integer n1,np
      parameter(np=4)
      character*1 b(np)
      character*1 b1(np)
c
      b(1)="A"
      b(2)="T"
      b(3)="G"
      b(4)="C"
c     
      n1=0
c 1
      do i=1,np
c 2
         do j=1,np
c 3
            do k=1,np
c 4 
               do l=1,np
c 5 
                  do m=1,np
c 6
                     do n=1,np
c 7
                        do o=1,np
c 8
                           do p=1,np
                              n1=n1+1
                              write(*,*)b(i),' ',b(j),' ',b(k),' ',
     & b(l),' ',b(m),' ',b(n),' ',b(o),' ',b(p)
                           enddo
                        enddo
                     enddo
                  enddo
               enddo
            enddo
         enddo
      enddo
c
c
      stop
      end
