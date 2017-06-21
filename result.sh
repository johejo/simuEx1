#!/bin/sh

rm -rf *.dat *.tr *.nam win parameters queue-mon

ns Many_Connections_with_RF-ShowQueue.tcl
ns Many_Connections_with_RF.tcl

for i in `seq 1 5`
do
    #statements
    perl mkCwnd.pl -n $i win >> cwnd$i.dat
done

perl throughput.pl out.tr tcp 1 0.1 | awk 'NR < 100 {print}' >> thp.dat

# gnuplot -e "
#     plot 'cwnd1.dat' w lp lc rgb 'black';
#     set title 'Throughput vs. Times for Sink';
#     set xlabel 'Time [secs]';
#     set ylabel 'Throughput [pkts]';
#     set grid;
#     pause -1;
# "
