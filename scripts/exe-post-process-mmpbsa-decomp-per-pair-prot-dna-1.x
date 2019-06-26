#!/bin/bash
#
let count=1
let last=64
let n=256
#
in=FINAL_DECOMP_MMPBSA_per_pair.dat
#
start=1161
lines=5192
#
# Revised last time: 24.06.2019
# Version 1.0
# Authors: spigae (Enrico Spiga)
#
echo ' '
echo ' Post-processing MMPBSA Decomposition per pair '
echo ' '
echo ' Start '
echo " $(date)"
echo ' '
#
gfortran create-selected-pairs.f -o create-selected-pairs.x
gfortran select-pairs.f -o select-pairs.x
#
while [ $count -le  $last ]
do
    #
    cd dir-$count
    #    echo $count
    b=$(echo "scale=3; $count*$n" | bc)
    a=$(echo "scale=3; $b-$n+1" | bc)
    #    echo $a $b
    echo ' '
    echo ' Analysing step #:' $count
    echo ' Extremes :' $a $b
    echo ' '
    #
    # to count properly
    let count1=$a
    while [ $count1 -le  $b ]
    do
	#
	cd sequence-$count1
	#
	# total contribution
	#
	val=`expr $lines - $start + 1`
	sed -n '9,5192 p' $in > prov1
	tail -$val prov1 > prov2
	#
	awk '{print $1,$2}' prov2 > list-prov-1
	awk '{print $4,$5}' prov2 > list-prov-2
	paste list-prov-1 list-prov-2 > list-pairs.dat
	rm prov1 list-prov-1 list-prov-2
	#
	awk '{print $27}' prov2 > ene.dat
	#
	paste list-pairs.dat ene.dat > all-pairs-prot-dna.dat
	rm prov2
	# Creating the selected pairs
	awk '$3=="N1" {print $4,$5}' C.pdb > list-dna.dat
	awk '$3=="CA" {print $4,$5}' C.pdb > list-prot.dat
	#
	../.././create-selected-pairs.x
	# Selecting only the pairs we want
	../.././select-pairs.x
	# cleaning
	rm list-pairs.dat ene.dat list-dna.dat all-pairs-prot-dna.dat
	rm selected-pairs.dat list-prot.dat 
	#
	cd ..
	#
	count1=`expr $count1 + 1`
    done
    #
    cd ..
    #
    # end loop on the sequences of the step
    count=`expr $count + 1`
done
#
echo ' '
echo ' End '
echo " $(date)"
echo ' '
echo ' Volli, e volli sempre, e fortissimamente volli.'
echo ' Vittorio Alfieri '
echo ' '
