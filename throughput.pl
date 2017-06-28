#!/bin/perl
# type: perl throughput.pl <trace file> <flow type> <required node> <granlarity> > output file

$infile=$ARGV[0];
$ftype=$ARGV[1];
$tonode=$ARGV[2];
$granularity=$ARGV[3];

#we compute how many bytes were transmitted during time interval specified
#by granularity parameter in seconds
$sum=0;
$clock=0;

# Now, make sure one and only one filename was specified
if ($#ARGV < 3) {
  	warn "Need to specify one and only one filename and some parameters\n";
  	&Usage;
}

open (DATA,"<$infile") || die "Can't open $infile $!";
  
while (<DATA>) {
	@x = split(' ');

	#column 1 is time 
	if ($x[1]-$clock <= $granularity) {
		#checking if the event corresponds to a reception 
		if ($x[0] eq 'r') { 
			#checking if the destination corresponds to arg 1
			if ($x[3] eq $tonode) { 
				#checking if the packet type is TCP/UDP/CBR
				if ($x[4] eq $ftype) {
		    			$sum=$sum+$x[5];
				}
			}
		}
	}
	else {   
		$throughput=$sum/$granularity;
    		print STDOUT "$x[1] $throughput\n";
    		$clock=$clock+$granularity;
    		$sum=0;
	}   
}

# throughput in bps
$throughput=8*$sum/$granularity;
print STDOUT "$x[1] $throughput\n";
#$clock=$clock+$granularity;
#$sum=0;

close DATA;

exit(0);
 
# print usage and quit
sub Usage {
  	printf STDERR "usage: throughput.pl <trace file> <flow type> <required node> <granlarity>\n";
  	exit(1);
}
