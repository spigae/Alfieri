#!/bin/bash
#
let count=1
# 256
let last=256
let n=256
#
# output directory
dir=mmgbsa-results
#
# Revised last time: 24.06.2019
# Version 1.0
# Authors: spigae (Enrico Spiga)
#
echo ' '
echo ' Analysis of MMGBSA results '
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
	awk -v count=$count -v count1=$count1 '$1=="DELTA"  && $2=="TOTAL" {print count,count1,$3}' dir-$count/sequence-$count1/MMGBSA.out >> mmgbsa-total.dat
	# end loop on the sequences of the step
	count1=`expr $count1 + 1`
    done
    #
    # end loop on the sequences of the step
    count=`expr $count + 1`
done
#
echo ' '
echo ' Identifying the sequences for each MMGBSA value'
echo " $(date)"
echo ' '
#
while read a b c 
do
    # entering directory
    cd dir-$a/sequence-$b
    awk '{print $3}' mutation-$b.dat | tail -8 > list
    seq=$(../.././convert-in-line.x | awk '{print $1}')
    echo $a $b $c $seq >> ../../mmgbsa-seq.dat
    #
    cd ../..
done < mmgbsa-total.dat
#
echo ' '
echo ' Ranking '
echo " $(date)"
echo ' '
#
sort -n -k3 mmgbsa-seq.dat > rank-mmgbsa.dat
awk '{print $3}' rank-mmgbsa.dat > data.dat
python calculate-statistics-1.py > statistics-mmgbsa.dat
mv histo.dat histo-mmgbsa.dat
#
rm convert-in-line.x
rm data.dat mmgbsa-total.dat
mv rank-mmgbsa.dat histo-mmgbsa.dat statistics-mmgbsa.dat mmgbsa-seq.dat $dir
#
echo ' '
echo ' End '
echo " $(date)"
echo ' '
echo ' Volli, e volli sempre, e fortissimamente volli.'
echo ' Vittorio Alfieri '
echo ' '
