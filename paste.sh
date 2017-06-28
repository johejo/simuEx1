#!/bin/sh
for i in `seq 1 20`
do
    cat thp$i.dat | awk '{print $2}'  >> tmp$i.dat
done

rm -rf thp*.dat
seq 1 59 | paste - tmp* > thplist.dat
rm -rf tmp*
