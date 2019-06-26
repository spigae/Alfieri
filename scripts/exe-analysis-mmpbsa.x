#!/bin/bash
#
let count=1
# 256
let last=256
let n=256
#
# output directory
dir=mmpbsa-results
#
# Revised last time: 24.06.2019
# Version 1.0
# Authors: spigae (Enrico Spiga)
#
echo ' '
echo ' Analysis of MMPBSA results '
echo ' '
echo ' Start '
echo " $(date)"
echo ' '
#
gfortran convert-in-line.f -o convert-in-line.x
#
rm -rf $dir
mkdir $dir
#
while [ $count -le  $last ]
do
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
	# total value
	awk -v count=$count -v count1=$count1 '$1=="DELTA"  && $2=="TOTAL" {print count,count1,$3}' dir-$count/sequence-$count1/MMPBSA.out >> mmpbsa-total.dat
	# end loop on the sequences of the step
	count1=`expr $count1 + 1`
    done
    #
    # end loop on the sequences of the step
    count=`expr $count + 1`
done
#
echo ' '
echo ' Identifying the sequences for each MMPBSA value'
echo " $(date)"
echo ' '
#
while read a b c 
do
    # entering directory
    cd dir-$a/sequence-$b
    awk '{print $3}' mutation-$b.dat | tail -8 > list
    seq=$(../.././convert-in-line.x | awk '{print $1}')
    echo $a $b $c $seq >> ../../mmpbsa-seq.dat
    #
    cd ../..
done < mmpbsa-total.dat
#
echo ' '
echo ' Ranking '
echo " $(date)"
echo ' '
#
sort -n -k3 mmpbsa-seq.dat > rank-mmpbsa.dat
awk '{print $3}' rank-mmpbsa.dat > data.dat
python calculate-statistics-1.py > statistics-mmpbsa.dat
mv histo.dat histo-mmpbsa.dat
#
rm convert-in-line.x
rm data.dat mmpbsa-total.dat
mv rank-mmpbsa.dat histo-mmpbsa.dat statistics-mmpbsa.dat mmpbsa-seq.dat $dir
#
echo ' '
echo ' End '
echo " $(date)"
echo ' '
echo ' Volli, e volli sempre, e fortissimamente volli.'
echo ' Vittorio Alfieri '
echo ' '
