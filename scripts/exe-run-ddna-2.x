#!/bin/bash
#
let count=65
let last=128
let n=256
#
# Revised last time: 24.06.2019
# Version 1.0
# Authors: spigae (Enrico Spiga)
#
echo ' '
echo ' Automatic DDNA/DFIRE calculation of mutated sequences   '
echo ' starting from a curated X-Ray structure             '
echo ' '
echo " started: $(date)"
echo ' '
echo ' '
#
while [ $count -le  $last ]
do
    #
    cd dir-$count
    #
    b=$(echo "scale=3; $count*$n" | bc)
    a=$(echo "scale=3; $b-$n+1" | bc)
    #    echo $a $b
    echo ' Sequences :' $a ' to ' $b
    echo ' '
    let count1=$a
    while [ $count1 -le  $b ]
    do
	# entering in the directory of the sequence
	cd sequence-$count1
	#
	cp ../../dfire_DNA179 .
	cp ../../aminodna.dat .
	#
	.././write-noh-pdb min.pdb >& log
	# modifications of the PDB
	sed -i 's/DA5/DA /g' noh.pdb
	sed -i 's/DT5/DT /g' noh.pdb
	sed -i 's/DG5/DG /g' noh.pdb
	sed -i 's/DC5/DC /g' noh.pdb
	sed -i 's/DA3/DA /g' noh.pdb
	sed -i 's/DT3/DT /g' noh.pdb
	sed -i 's/DG3/DG /g' noh.pdb
	sed -i 's/DC3/DC /g' noh.pdb
	# DDNA!
	ddna31 noh.pdb > ddna-$count
	#
	# exiting from the directory of the sequence
	cd ..
	# end main loop on sequences
	count1=`expr $count1 + 1`
    done
    #
    cd ..
    #
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
