#!/bin/bash
#
let count=1
let last=256
let n=256
#
name=antp
conf=A
#
in1=MMPBSA
dir1=$name-MMPBSA-tot-$conf
#
in2=MMGBSA
dir2=$name-MMGBSA-tot-$conf
#
in3=FINAL_DECOMP_MMPBSA_per_pair
dir3=$name-MMPBSA-per-pair-$conf
#
in4=FINAL_DECOMP_MMGBSA_per_pair
dir4=$name-MMGBSA-per-pair-$conf
#
# version script: 0.1
# Revised last time: 20.05.2019
# Authors: Enrico Spiga
# Institutions: The Francis Crick Institute
#
echo ' '
echo ' Copying files '
echo ' '
echo ' Start '
echo " $(date)"
echo ' '
#
rm -rf $dir1 $dir2 $dir3 $dir4 
mkdir $dir1 $dir2 $dir3 $dir4 
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
    echo ' Copying from dir #:' $count
    echo ' Extremes of the sequences:' $a $b
    echo " $(date)"
    echo ' '
    #
    # to count properly
    let count1=$a
    while [ $count1 -le  $b ]
    do
	#
	cd sequence-$count1
	#
	cp $in1.out $in1-$count1.dat
	cp $in2.out $in2-$count1.dat
	#
	cp $in3.dat $in3-$count1.dat
	cp $in4.dat $in4-$count1.dat
	#
	mv $in1-$count1.dat ../../$dir1
	mv $in2-$count1.dat ../../$dir2
	mv $in3-$count1.dat ../../$dir3
	mv $in4-$count1.dat ../../$dir4
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
