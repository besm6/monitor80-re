#!/usr/bin/env perl
use utf8;
use feature 'unicode_strings';
use open ':encoding(UTF-8)';
use open ':std', ':encoding(UTF-8)';

$keep = 0;
if ($ARGV[0] eq '-keep') { $keep = 1; shift @ARGV; }

die "Usage: ftn.pl [-keep] file.f\n" if $#ARGV != 0;

$vol = $ENV{'WORKVOL'};
die "Need env var WORKVOL\n" unless $vol;

$basename = $file = $ARGV[0];
$comp = 'TRANS:INITFTN,,401350';
#$comp = 'FTN';
$basename =~ s/\.f$//;
$b6 = "asm$$.b6";

$mod = $basename;
$mod =~ s-_-/-g;
$mod =~ s-%-*-g;


open(B, ">$b6") || die "Cannot open $b6 for writing\n";
print B qq/шифр 419999ЗС5^
ЛЕН 40(2148)60($vol-WR)^
ЕЕВ1А3
*NAME
*     NO LIST
*SUPER
*OPTIM
*$comp
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
if ($listing =~ /IS АВSЕNТ/) {
        print STDERR $listing;
        die "Compilation failed\n";
}
system(qq@
besmtool dump $vol --length=10 --to-file=/dev/stdout | ../tools/cosy2txt > $basename.dis
@);
unlink($b6) unless $keep;
system("mv $b6 ftncomp.b6") if $keep;
