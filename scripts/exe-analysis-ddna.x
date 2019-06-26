#!/bin/bash
#
let count=1
# 256
let last=256
let n=256
#
# output directory
dir=ddna-results
#
# Revised last time: 24.06.2019
# Version 1.0
# Authors: spigae (Enrico Spiga)
#
echo ' '
echo ' Analysis of DDNA results '
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
	awk -v count=$count -v count1=$count1 '{print count,count1,$2}' dir-$count/sequence-$count1/ddna.dat >> ddna-total.dat
	# end loop on the sequences of the step
	count1=`expr $count1 + 1`
    done
    #
    # end loop on the sequences of the step
    count=`expr $count + 1`
done
#
echo ' '
echo ' Identifying the sequences for each DDNA value'
echo " $(date)"
echo ' '
#
while read a b c 
do
    # entering directory
    cd dir-$a/sequence-$b
    awk '{print $3}' mutation-$b.dat | tail -8 > list
    seq=$(../.././convert-in-line.x | awk '{print $1}')
    echo $a $b $c $seq >> ../../ddna-seq.dat
    #
    cd ../..
done < ddna-total.dat
#
echo ' '
echo ' Ranking '
echo " $(date)"
echo ' '
#
sort -n -k3 ddna-seq.dat > rank-ddna.dat
awk '{print $3}' rank-ddna.dat > data.dat
python calculate-statistics-2.py > statistics-ddna.dat
mv histo.dat histo-ddna.dat
#
rm convert-in-line.x
rm data.dat ddna-total.dat
mv rank-ddna.dat histo-ddna.dat statistics-ddna.dat ddna-seq.dat $dir
#
echo ' '
echo ' End '
echo " $(date)"
echo ' '
echo ' Volli, e volli sempre, e fortissimamente volli.'
echo ' Vittorio Alfieri '
echo ' '
