#!/bin/perl

# F.Qian, Spring 2005.
# simple perl script to print Congestion Window based on the node
# 

# Process command line args.
while ($_ = $ARGV[0], /^-/)
{
  shift;
  if (/^-h/)      { $Usage; }
  elsif (/^-n/)  { if ( $ARGV[0] ne '' ) {
                      $node = $ARGV[0];  
                      shift; }}
  else            { warn "$_ bad option\n"; &Usage; }
}

# Now, make sure one and only one filename was specified
if (($ARGV[0] eq '') || ($ARGV[1] ne '')) {
  	warn "Need to specify one and only one filename\n";
  	&Usage;
}
$infile = $ARGV[0];

open (DATA,"<$infile") || die "Can't open $infile $!";

while (<DATA>) {
	@x = split(' ');
	
	if($x[0]==$node) {
		printf("%f\t%f\n", $x[1], $x[2]);
		}
}
close DATA;
exit 0;

# print usage and quit
sub Usage {
  	printf STDERR "usage: mkCwnd.pl [flags] <trace filename>, where:\n";
  	printf STDERR "\t-n #         node number for monitoring\n";
  	printf STDERR "\t-h           this help message\n";

  	exit(1);
}
