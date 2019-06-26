      program be
      implicit none
c
      integer i,j,k,ninf,n1
      parameter(ninf=10000)
      character*3 res1,res2
      integer nres1,nres2
      character*3 res3,res4
      integer nres3,nres4
      real*8 ene

c
      open(10,file='selected-pairs.dat',status='unknown')
      open(11,file='all-pairs-prot-dna.dat',status='unknown')
      open(12,file='selected-energies.dat',status='unknown')
c      open(13,file='grid',status='unknown')
      open(14,file='ene-ordered.dat',status='unknown')
c
      do i=1,ninf
         read(10,*,END=500)res1,nres1,res2,nres2
         do j=1,ninf
            read(11,*,END=501)res3,nres3,res4,nres4,ene
            if(res1.eq.res3 .and. nres1.eq.nres3 .and. res2.eq.res4 
     & .and. nres2.eq.nres4) then
               write(12,100)res3,nres3-14,res4,nres4,ene
c               write(13,101)nres3-14,nres4
               write(14,102)ene
            else
            endif
         enddo
 501     rewind(11)
      enddo
 500  n1=i-1
c
 100  format(a3,i3,2x,a3,i3,f8.3)
 101  format(i3,i3,f8.3)
 102  format(f8.3)
c
      stop
      end
