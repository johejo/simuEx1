#!/bin/sh
for i in `seq 1 20`
do
    seq 1 $i | paste - thpave$i.dat >> thpave_p$i.dat
done
#
# rm -rf thplist.dat
# seq 1 59 | paste - tmp* > thplist.dat
# rm -rf tmp*
