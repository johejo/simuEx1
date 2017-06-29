#!/bin/sh

for j in `seq 1 10`
do
    for i in `seq 1 20`
    do
        #statements
        ns exp1.tcl $i > thpave$i.txt
        cat thpave$i.txt | python sum.py >> thpsum$i.txt
        cat thpave$i.txt | python ave.py >> thpaveave$i.txt
    done
done
