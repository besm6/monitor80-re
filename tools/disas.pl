#!/usr/bin/env perl
use utf8;
use feature 'unicode_strings';
use open ':encoding(UTF-8)';
use open ':std', ':encoding(UTF-8)';

$keep = 0;
$lib = 0;
while ($#ARGV >= 0) {
        if($ARGV[0] eq '-keep') { $keep = 1; shift @ARGV; }
        elsif ("$ARGV[0] $ARGV[1]" =~ m/-zone ([0-7]+)/) { $lib = ":67$1"; shift @ARGV; shift @ARGV; }
        else { last; }
}

die "Usage: disas.pl [-zone NNNN] [-keep] modname\n" if $#ARGV != 0;

$vol = $ENV{'WORKVOL'};
die "Need env var WORKVOL\n" unless $vol;

$file = $mod = $ARGV[0];
$b6 = "disas$$.b6";

$mod =~ s-_-/-g;
$mod =~ s-%-*-g;

open(B, ">$b6") || die "Cannot open $b6 for writing\n";
print B qq/шифр 419999ЗС5^
ЛЕН 60($vol-WR)67(2048)^
ЕЕВ1А3
*NAME
*LIBRA:2
*COPY:1,270000,600000
*CALL DTRAN$lib($mod)
/;
if (open(D, "$file.dtr")) {
        undef $/;
        print B <D>;
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
system(qq@
dispak -l $b6
besmtool dump $vol --length=3 --to-file=/dev/stdout | ../tools/cosy2txt | sed '/^ :,EQU,/d' > $file.orig
@);
unlink($b6) unless $keep;
