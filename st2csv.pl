#!/usr/bin/perl 
# made by vikings
# may it corrupt all yer data arrr
#
# usage ./st2csv.pl (filename)-out.st2 (residuename)

use strict;
use warnings;
use POSIX;

open(FD, "<$ARGV[0]");
my @names = ();
my @storearray;

my $newblock = 0;
my $bracknum = 0;
my $row = 0;

my $file_out = $ARGV[1].'.csv';
open(my $fh, '>', $file_out) or die "Could not open file '$file_out' $!";

while(<FD>) {
#	print($_);
	my($tmpl) = $_;
	chomp($tmpl);

#	print "$tmpl \n";
	if ($tmpl =~ /Distance/) { 
#		print "found a new block\n";
		if($newblock == 0) {
			$newblock++;
		}else {
			print "data inconsistent, exiting\n";
			exit(2);
		}
	}
	
	if (($newblock == 1) && ($tmpl =~ /Name/)) {
#		print "start of new block found\n";
		$tmpl =~ s/Name = "//;
		$tmpl =~ s/"//;
		$tmpl =~ s/^\s+//;
		#print("Entry Name: $tmpl\n");
		push(@names, $tmpl);
	}
	
	if($tmpl =~ /Result/) {
#		my $char=chop($tmpl);
#		print("chopped char: $char\n");
		$tmpl =~ s/Result = \[//;
		$tmpl =~ s/^\s+//;
		$tmpl =~ s/\s+$//;
		$tmpl =~ s/]//;
#		print "template:$tmpl \n";
		my @result = split(/ /,$tmpl);
		foreach my $column (@result) {
			push(@{$storearray[$row]}, $column);
		}
		$row++;
	}

	if( ($tmpl =~ /}/) && ($bracknum == 0)) {
		$bracknum++;
	}elsif(($tmpl =~ /}/) && ($bracknum == 1)) {
		$newblock = 0;
		$bracknum = 0;
#		print("end of block\n\n");
	}elsif ($bracknum >1) {
		print "wtf? exiting...\n";
		exit(2);
	} 
}

print $fh '#Simulation Analysis Results CSV File '.strftime("%F %T", localtime $^T)."\n";
print $fh '#Generated on structure: "frame000000"'."\n";

my $line = "TimeStep";
foreach my $name (@names) {
	$line = "$line,Distance_$name";
}
print $fh "$line\n";

my $floatnum=0.0;
$line = "0.0";
my $runs = 0;
my $t = 0;

for (my $i=0;$i<$row;$i++) {
	$t = @{$storearray[$i]};
	$runs = $runs +	$t;
	my $num = (@storearray-1);
#	print "$i e loop $t , totaal: $runs \n";
}
$runs /= @storearray;

for (my $i=0; $i<$runs; $i++) {
	print $fh $line;

    foreach $row (0..@storearray-1) {
		print $fh ",$storearray[$row][$i]";
	}
	$floatnum += 4.8;
	my $rounded = sprintf("%.1f", $floatnum);
	$line = "$rounded";
	print $fh "\n";
}
close $fh;
print "Finished converting $ARGV[0] to $file_out \n";
