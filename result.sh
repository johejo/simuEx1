#!/bin/sh

rm -rf cwnd*.dat thp*.dat *.tr *.nam win parameters queue-mon

for i in `seq 1 20`
do
    #statements
    ns exp1.tcl $i >> thpave$i.txt
    cat thpave.txt | python sum.py >> thpsum$i.txt
    # seq 1 $i | paste - thpave$i.dat >> thpave_p$i.dat
done
