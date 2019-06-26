#!/bin/bash
#
let count=1
let nmut=65536
#
pdb=x-ray-to-be-used.pdb
cpu=2
#
# Revised last time: 24.06.2019
# Version 1.0
# Authors: spigae (Enrico Spiga)
#
echo ' '
echo ' Automatic Mutation+Tleap+Min(Namd) of DNA sequences '
echo ' starting from a curated X-Ray structure             '
echo ' '
echo " started: $(date)"
echo ' '
echo ' '
#
# main loop on sequences
#
while [ $count -le  $nmut ] 
do
    echo ' Processing Sequence #: ' $count
    #
    # entering in the directory of the sequence
    cd sequence-$count
    # copying the structure to be mutated
    cp ../$pdb .
    # removing hydrogens
    .././write-noh-pdb $pdb >& log-noh
    #
    # mutating with 3DNA
    #
    mutate_bases -l mutation-$count.dat noh.pdb mutated-$count.pdb >& log-mutate
    # removing rubbish from the file
    awk '$1 !="REMARK" {print}' mutated-$count.pdb > structure-$count.pdb
    # removing rubbish files
    rm noh.pdb mutated-$count.pdb
    # adding TER for tleap (bloody TER of AMBER, sorry Kollman...)
    n1=$(awk '$5=="A" {print}' structure-$count.pdb | tail -1 | awk '{print $2}')
    n2=$(awk '$5=="B" {print}' structure-$count.pdb | tail -1 | awk '{print $2}')
    n3=$(awk '$5=="C" {print}' structure-$count.pdb | tail -1 | awk '{print $2}')
    #
    echo 'TER' > to-add
    n6=`expr $n1 - 3`
    head -$n1 structure-$count.pdb | tail -$n6 > header
    n4=`expr $n2 - $n1 - 3`
    head -$n2 structure-$count.pdb | tail -$n4 > corpus
    n5=`expr $n3 - $n2 + 1`
    tail -$n5 structure-$count.pdb > tailer
    # Complex: creating structure 
    cat header to-add corpus to-add tailer > complex-$count.pdb
    # Complex: Changing the NAME to the bases to be compatible with Tleap/Amber99SB+Barcelona correction 0
    sed -i 's/ A A/DA A/g' complex-$count.pdb
    sed -i 's/ T A/DT A/g' complex-$count.pdb
    sed -i 's/ G A/DG A/g' complex-$count.pdb
    sed -i 's/ C A/DC A/g' complex-$count.pdb
    sed -i 's/ A B/DA B/g' complex-$count.pdb
    sed -i 's/ T B/DT B/g' complex-$count.pdb
    sed -i 's/ G B/DG B/g' complex-$count.pdb
    sed -i 's/ C B/DC B/g' complex-$count.pdb
    #
    # running TLEAP
    #
    # Complex: tleap
    cp complex-$count.pdb for-tleap.pdb
    tleap -f ../tleap.in > tleap.err
    mv tleap.top C.top
    mv tleap.rst C.rst
    ambpdb -p C.top < C.rst > C.pdb
    # Ligand (DNA): creating structure
    cat header to-add corpus > ligand-$count.pdb
    # Ligand: Changing the NAME to the bases to be compatible with Tleap/Amber99SB+Barcelona correction 0
    sed -i 's/ A A/DA A/g' ligand-$count.pdb
    sed -i 's/ T A/DT A/g' ligand-$count.pdb
    sed -i 's/ G A/DG A/g' ligand-$count.pdb
    sed -i 's/ C A/DC A/g' ligand-$count.pdb
    sed -i 's/ A B/DA B/g' ligand-$count.pdb
    sed -i 's/ T B/DT B/g' ligand-$count.pdb
    sed -i 's/ G B/DG B/g' ligand-$count.pdb
    sed -i 's/ C B/DC B/g' ligand-$count.pdb
    # Ligand: tleap
    cp ligand-$count.pdb for-tleap.pdb
    tleap -f ../tleap.in > tleap.err
    mv tleap.top L.top
    mv tleap.rst L.rst
    ambpdb -p L.top < L.rst > L.pdb
    # Receptor (Protein): creating structure
    cp tailer receptor-$count.pdb
    # Receptor: tleap
    cp receptor-$count.pdb for-tleap.pdb
    tleap -f ../tleap.in > tleap.err
    mv tleap.top R.top
    mv tleap.rst R.rst
    ambpdb -p R.top < R.rst > R.pdb
    # removing rubbish
    rm to-add header corpus tailer for-tleap.pdb tleap.err leap.log
    # NAMD minimization
    cp ../min.conf .
    mpirun -n $cpu namd2 min.conf > min.log
    # converting last file
    catdcd -otype pdb -o min.pdb -stype pdb -s C.pdb -namdbin min.coor >& log-catdcd
    # cleaning
    rm FFTW_NAMD_2.9_Linux-x86_64-MPI.txt min.rst.xsc min.rst.coor min.rst.vel log-noh
    rm min.xsc min.xst min.coor min.coor.dcd min.vel min.vel.dcd log-catdcd log-constraints 
    # exiting from the directory of the sequence
    cd ..
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
#
