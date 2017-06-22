#!/bin/sh

rm -rf *.dat *.tr *.nam win parameters queue-mon

for i in `seq 1 20`
do
    #statements
    ns exp1.tcl $i
    perl mkCwnd.pl -n $i win >> cwnd$i.dat
    perl throughput.pl out.tr tcp 1 1 | awk 'NR < 60 {print}' >> thp$i.dat
done

# gnuplot -e "
#     plot 'cwnd1.dat' w lp lc rgb 'black';
#     set title 'Throughput vs. Times for Sink';
#     set xlabel 'Time [secs]';
#     set ylabel 'Throughput [pkts]';
#     set grid;
#     pause -1;
# "
