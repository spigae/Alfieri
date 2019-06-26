#!/bin/bash
#
let count=65
let last=128
let n=256
#
cpu=2
#
# Revised last time: 24.06.2019
# Version 1.0
# Authors: spigae (Enrico Spiga)
#
echo ' '
echo ' Automatic MMGBSA calculation of mutated sequences   '
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
	# MMGBSA
	# creating the input file for MMGBSA
	rm file.in
	echo "Input file for running mmgbsa" > file.in
	echo "&general" >> file.in
	echo "   endframe=1, verbose=1" >> file.in
	echo "/" >> file.in
	echo "&gb"  >> file.in
	echo "  igb=2, saltcon=0.150" >> file.in
	echo "/" >> file.in
	#
	# running MMPBSA
	mpirun -np $cpu MMPBSA.py -O -i file.in -o MMGBSA.out -cp C.top -rp R.top -lp L.top -y min.pdb >& mmgbsa.err
	rm _*
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
