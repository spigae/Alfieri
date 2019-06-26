#!/bin/bash
#
pdb=x-ray-to-be-used.pdb
#
let count=1
let natm=16
#
# Revised last time: 24.06.2019
# Version 1.0
# Authors: spigae (Enrico Spiga)
#
echo ' '
echo ' '
echo ' Creating the Mutation files                      '
echo ' '
echo " started: $(date)"
echo ' '
echo ' '
#
echo ' '
echo ' Creating all the possible mutations'
echo ' '
# creating all the possible mutations
gfortran create-mutations.f -o create-mutations.x
./create-mutations.x > mutations.dat
# creating all the possible base pairs mutations
nmut=$(wc mutations.dat| awk '{print $1}')
echo $nmut > nmut.dat
gfortran create-mutation-pairs.f -o create-mutation-pairs.x
./create-mutation-pairs.x > all-mutation-pairs.dat
#let nmut=2
#
# main loop on sequences
#
while [ $count -le  $nmut ] 
do
    # separating the mutations
    echo ' Mutations for the sequence #: '$count
    awk -v count=$count -v natm=$natm 'BEGIN{n1=1+(count-1)*natm;n2=n1+natm-1}
   {i++; if ( i>=n1 && i<=n2 ) print $0 }' all-mutation-pairs.dat  > mutation-$count.dat
    #
    rm -rf sequence-$count
    mkdir sequence-$count
    # mutation file
    mv mutation-$count.dat sequence-$count
    # pdb file
    cp $pdb sequence-$count
    #
    # end main loop on sequences
    count=`expr $count + 1`
done
#
echo ' '
echo ' '
echo " finished: $(date)"
#
echo ' '
echo ' Volli, e volli sempre, e fortissimamente volli.'
echo ' Vittorio Alfieri '
echo ' '
