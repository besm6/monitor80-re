#!/usr/bin/env perl
use utf8;
use feature 'unicode_strings';
use open ':encoding(UTF-8)';
use open ':std', ':encoding(UTF-8)';

$keep = 0;
if ($ARGV[0] eq '-keep') { $keep = 1; shift @ARGV; }

die "Usage: asm.pl [-keep] file.[m]asm\n" if $#ARGV != 0;

$basename = $file = $ARGV[0];
if ($file =~ /masm$/) {
        $asm = 'MADLEN';
        $basename =~ s/.masm$//;
} else {
        $asm = 'ASSEM';
        $basename =~ s/.asm$//;
}
$b6 = "asm$$.b6";

$mod = $basename;
$mod =~ s-_-/-g;
$mod =~ s-%-*-g;


open(B, ">$b6") || die "Cannot open $b6 for writing\n";
print B qq/шифр 419999ЗС5^
ЕЕВ1А3
*NAME
*PUNCH
*NO LIST
*$asm
/;

open(F, $file) || die "Where did $file go?\n";
while (<F>) {
        print B;
}
close (F);
print B qq/
*END FILE
``````
ЕКОНЕЦ
/;
close(B);

$listing=`dispak -l -c $basename.obj --punch-unicode $b6`;
if ($listing =~ /\n \*\*\*\*\*\*/) {
        print STDERR $listing;
        unlink("$basename.obj");
        die "Compilation failed\n";
}
unlink($b6) unless $keep;
