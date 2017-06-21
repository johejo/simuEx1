#Create a simulator object
set ns [new Simulator]

#Open the Trace file
set tf [open out.tr w]
set windowVsTime2 [open WindowVsTimeNReno w]
$ns trace-all $tf

#Define a 'finish' procedure
proc finish {} {
        global ns tf

        $ns flush-trace
        close $tf
	#exec xgraph WindowVsTimeNReno -geometry 800x400 \
             -t "Windowsize of TCP with 20% random losses" -y "Packets" -x "Times number" &

        exit 0
}

#Create four nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]

#Create links between the nodes
$ns duplex-link $n0 $n2 2Mb 10ms DropTail
$ns duplex-link $n1 $n2 2Mb 10ms DropTail
$ns simplex-link $n2 $n3 0.07Mb 20ms DropTail
$ns simplex-link $n3 $n2 0.07Mb 20ms DropTail

#Set Queue Size of link (n2-n3) to 10
$ns queue-limit $n2 $n3 10

#Set error model on link n2 to n3.
set loss_module [new ErrorModel]
set err_rate [lindex $argv 0]
$loss_module set rate_ $err_rate
$loss_module unit pkt
$loss_module ranvar [new RandomVariable/Uniform]
$loss_module drop-target [new Agent/Null]
$ns lossmodel $loss_module $n2 $n3

#Setup a TCP connection
set tcp [new Agent/TCP/Newreno]
$ns attach-agent $n0 $tcp
set sink [new Agent/TCPSink/DelAck]
$ns attach-agent $n3 $sink
$ns connect $tcp $sink

#Setup a FTP over TCP connection
set ftp [new Application/FTP]
$ftp attach-agent $tcp
$ftp set type_ FTP

#Setup a UDP connection
set udp [new Agent/UDP]
$ns attach-agent $n1 $udp
set null [new Agent/Null]
$ns attach-agent $n3 $null
$ns connect $udp $null

#Setup a CBR over UDP connection
set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp
$cbr set type_ CBR
$cbr set packet_size_ 1000
$cbr set rate_ 0.01mb
$cbr set random_ false

#Schedule events for the CBR and FTP agents
$ns at 0.1 "$cbr start"
$ns at 1.0 "$ftp start"
$ns at 624.0 "$ftp stop"
$ns at 624.5 "$cbr stop"

# Printing the window size
proc plotWindow {tcpSource file} {
	global ns

	set time 0.01
	set now [$ns now]
	set cwnd [$tcpSource set cwnd_]
	puts $file "$now $cwnd"
	$ns at [expr $now+$time] "plotWindow $tcpSource $file"
}

$ns at 1.1 "plotWindow $tcp $windowVsTime2"

$ns at 625.0 "finish"
$ns run
