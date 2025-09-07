#!/usr/bin/env -S perl -CA
use utf8;
use feature 'unicode_strings';
use open ':encoding(UTF-8)';
use open ':std', ':encoding(UTF-8)';

$keep = 0;
if ($ARGV[0] eq '-keep') { $keep = 1; shift @ARGV; }

die "Usage: asm.pl [-keep] file.[m]asm\n" if $#ARGV != 0;

$vol = $ENV{'WORKVOL'};
die "Need env var WORKVOL\n" unless $vol;

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
ЛЕН 60($vol-WR)^
ЕЕВ1А3
*NAME
*NO LIST
*$asm
/;

open(F, $file) || die "Where did $file go?\n";
while (<F>) {
        print B;
}
close (F);
print B qq/
*LIBRA:2
*COPY:1,270000,600000
*STAND
*CALL DTRAN($mod)
/;
if (open(D, "$basename.dtra") || open(D, "$basename.dtr")) {
        undef $/;
        print B <D>;
        close(D);
}
print B qq/
*EDIT
*R:1
*W:600000
*EE
*END FILE
``````
ЕКОНЕЦ
/;
close(B);

$listing=`dispak -l $b6`;
if ($listing =~ /\n \*\*\*\*\*\*/) {
        print STDERR $listing;
        die "Compilation failed\n";
}
$degak = $cosy2txt = $0;
$cosy2txt =~ s/asm.pl$/cosy2txt/;
$degak =~ s/asm.pl$/degak.py/;
system(qq@
besmtool dump $vol --length=10 --to-file=/dev/stdout | $cosy2txt | $degak > $basename.dis
@);
unlink($b6) unless $keep;
