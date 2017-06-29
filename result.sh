#!/bin/sh

for j in `seq 1 10`
do
    for i in `seq 1 20`
    do
        #statements
        ns exp1.tcl $i > thpave$i.txt
        cat thpave.txt | python sum.py >> thpsum$i.txt
        cat thpave.txt | python ave.py >> thpaveave$i.txt
        # seq 1 $i | paste - thpave$i.dat >> thpave_p$i.dat
    done
done
