#!/bin/bash
#
let count=1
let last=64
let n=256
#
# Revised last time: 24.06.2019
# Version 1.0
# Authors: spigae (Enrico Spiga)
#
echo ' '
echo ' Archiving directories'
echo ' '
echo " started: $(date)"
echo ' '
echo ' '
#
while [ $count -le  $last ]
do
    rm -rf dir-$count
    mkdir dir-$count
    #    echo $count
    b=$(echo "scale=3; $count*$n" | bc)
    a=$(echo "scale=3; $b-$n+1" | bc)
    #    echo $a $b
    echo ' Archiving step #:' $count
    echo ' Sequences :' $a ' to ' $b
    echo ' '
    let count1=$a
    while [ $count1 -le  $b ]
    do
	# moving the directory of the sequence
	mv sequence-$count1 dir-$count
	#
	# end loop on the sequences of the step
	count1=`expr $count1 + 1`
    done
    #
    # end loop on the sequences of the step
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
