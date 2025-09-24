#!/usr/bin/env perl
use utf8;
use feature 'unicode_strings';
use open ':encoding(UTF-8)';
use open ':std', ':encoding(UTF-8)';

$keep = 0;
while ($#ARGV >= 0) {
        if($ARGV[0] eq '-keep') { $keep = 1; shift @ARGV; }
        else { last; }
}

die "Usage: genmask.pl [-keep] modnames\n" if $#ARGV != 0;

open(F, "$ARGV[0]") || die "Cannot open $ARGV[0]\n";

sub task {
open(B, ">$b6") || die "Cannot open $b6 for writing\n";
print B qq/шифр 419999ЗС5^
dis 60(2048)^
ЕЕВ1А3
*NAME
      subroutine pr(a, n)
      dimension a(n)
      print 1,(a(i),i=1,n)
   1  format(1x,o16)
      stop
      end
*assem
 program:,name,
 dummy:,lc,$_[0]
 $mod:,subp,
 end:,lc,
 ,ntr,3
 14,vtm,$mod
 ,ita,14
 14,vtm,end
 ,its,14
 15,a-x,
 ,aox,=I0
 ,atx,n
 14,vtm,$mod
 ,its,14
 14,vtm,n
 ,its,14
 ,ntr,2
 ,call,pr
 ,sj,
 n:,bss,1
 ,end,
*tapes:601100
*libra:60
*execute
*end file
``````
еконец
/;

close(B);
system("dispak -l $b6 > $_[1]");
}

while (<F>) {
chop;

$mod = $file = lc $_;

$b6 = "genmask$$.b6";

$file =~ s-/-_-g;
$file =~ s-\*-%-g;

# printf "Running tasks for $mod\n";
task(0, "base$$");
task(1024, "shifted$$");
unlink($b6) unless $keep;

$comp = $0;
$comp =~ s/genmask.pl$/compare_octals.py/;

print "Comparing $mod ...";
$out = `$comp base$$ shifted$$`;
print "done\n";

if ($out eq '') {
        print STDERR "Mask generation failed for $mod\n";
} elsif ($out !~ /[0-7]/) {
        print "$mod is trivial\n";
} else {
        open(OUT, ">$file.mask") || die "Cannot open $file.mask\n";
        print OUT $out;
        close(OUT);
}
}

