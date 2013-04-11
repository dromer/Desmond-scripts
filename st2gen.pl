#!/usr/bin/perl
# made by vikings
# may it corrupt all yer data arrr
#
# usage ./st2gen.pl (filename)

use strict;
use warnings;
use POSIX;
use List::MoreUtils qw(natatime);

open(FD, "<$ARGV[0]") or die "No data-file submitted!";

my @file_ar;

while (my $line = <FD>) {
    chomp $line;
    my @line_ar = split(/\s+/, $line);
    push(@file_ar, \@line_ar);
}

my @ligand = @{ shift(@file_ar) };
my $sim = shift(@ligand);
my $data = 0;

while ( $data <= $#file_ar ) {
    
    my $iter = natatime(2, @ligand);
    my $res = shift($file_ar[$data]);
    my $file_out = $sim.'-'.$res.'.st2';
    
    open(my $fh, '>', $file_out) or die "Could not open file '$file_out' $!";

    print $fh '#Simulation Analysis Keyword File '.strftime("%F %T", localtime $^T)."\n";
    print $fh '#Generated on structure: "frame000000"'."\n";
    print $fh '#To execute:'."\n";
    print $fh '# $SCHRODINGER/run analyze_trajectories.py /<path to>/'.$sim.'-out.cms '.$sim.'-'.$res.'.st2 '.$sim.'-'.$res.'-out.st2'."\n";
    print $fh 'Keywords = [';

    while (my @eval = $iter->()) {

        for (my $i=0; $i<=1; $i++){
            for (my $j=0; $j<=1; $j++){
#                print $fh $i.' and '.$j."\n";

                print $fh "\n".'   {Distance = {'."\n";
                print $fh '       Name = "'.$res.'-'.$eval[0].':'.$eval[1].'"'."\n";
                print $fh '       Unit = "Angstrom"'."\n";
                print $fh '       a1 = '.$eval[$i]."\n";
                print $fh '       a2 = '.$file_ar[$data][$j]."\n".'    }'."\n".'   }'."\n";
            }
        }
    }

    print $fh ']'."\n";

    close $fh;
    print "Done with printing $file_out\n";
    $data++;
}
print "Done with everything.\n
Please follow the instructions at the top of the generated files.\n"
