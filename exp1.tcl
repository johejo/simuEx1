set ns [new Simulator]

set nf [open out.nam w]
$ns namtrace-all $nf

set tf [open out.tr w]
set NumbSrc [lindex $argv 0]
set windowVsTime [open win w]
set param [open parameters w]
$ns trace-all $tf

#Define a 'finish' procedure
proc finish {} {
        global ns nf tf

        $ns flush-trace
        close $nf; close $tf
        #exec nam out.nam &

        exit 0
}

#Create bottleneck and dest nodes
set n2 [$ns node]
set n3 [$ns node]



#Create links between these nodes
$ns duplex-link $n2 $n3 10Mb 10ms DropTail

#Set error model on link n2 to n3.
set loss_module [new ErrorModel]
set err_rate 0.0001
$loss_module set rate_ $err_rate
$loss_module unit pkt
$loss_module ranvar [new RandomVariable/Uniform]
$loss_module drop-target [new Agent/Null]
$ns lossmodel $loss_module $n2 $n3


set Duration 60

#Source nodes
for {set j 1} {$j<=$NumbSrc} { incr j } {
	set S($j) [$ns node]
}

# Create a random generator for starting the ftp and for bottleneck link delays
set rng [new RNG]
$rng seed 0


# parameters for random variables for begenning of ftp connections
set RVstart [new RandomVariable/Uniform]
$RVstart set min_ 0
$RVstart set max_ 0.1
$RVstart use-rng $rng

#We define two random parameters for each connections
for {set i 1} {$i<=$NumbSrc} { incr i } {
	set startT($i)  [expr [$RVstart value]]
	puts $param "startT($i)  $startT($i) sec"
}

#Links between source and bottleneck
for {set j 1} {$j<=$NumbSrc} { incr j } {
	$ns duplex-link $S($j) $n2 100Mb 10ms DropTail
	$ns queue-limit $S($j) $n2 37.5
}

#Monitor the queue for link (n2-n3). (for NAM)
$ns duplex-link-op $n2 $n3 queuePos 0.5

#Set Queue Size of link (n2-n3) to 10
$ns queue-limit $n2 $n3 37.5

#TCP Sources
for {set j 1} {$j<=$NumbSrc} { incr j } {
	set tcp_src($j) [new Agent/TCP/Sack1]
}

#TCP Destinations
	for {set j 1} {$j<=$NumbSrc} { incr j } {
	set tcp_snk($j) [new Agent/TCPSink/Sack1]
}

#Connections
for {set j 1} {$j<=$NumbSrc} { incr j } {
	$ns attach-agent $S($j) $tcp_src($j)
	$ns attach-agent $n3 $tcp_snk($j)
	$ns connect $tcp_src($j) $tcp_snk($j)
}

#FTP sources
for {set j 1} {$j<=$NumbSrc} { incr j } {
	set ftp($j) [$tcp_src($j) attach-source FTP]
}

#Parametrisation of TCP sources
for {set j 1} {$j<=$NumbSrc} { incr j } {
	$tcp_src($j) set packetSize_ 1000
}

#Schedule events for the FTP agents:
for {set i 1} {$i<=$NumbSrc} { incr i } {
	$ns at $startT($i) "$ftp($i) start"
	$ns at $Duration "$ftp($i) stop"
}

proc plotWindow {tcpSource file k} {
	global ns
	set time 0.03
	set now [$ns now]
	set cwnd [$tcpSource set cwnd_]
	puts $file "$k $now $cwnd"
	$ns at [expr $now+$time] "plotWindow $tcpSource $file $k"
}

# The procedure will now be called for all tcp sources
for {set j 1} {$j<=$NumbSrc} { incr j } {
	$ns at 0.1 "plotWindow $tcp_src($j) $windowVsTime $j"
}

$ns at [expr $Duration] "finish"
$ns run
