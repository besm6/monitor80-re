#!/usr/bin/env perl
use utf8;
use feature 'unicode_strings';
use open ':encoding(UTF-8)';
use open ':std', ':encoding(UTF-8)';

$keep = 0;
if ($#ARGV >= 0 && $ARGV[0] eq '-keep') { $keep = 1; shift @ARGV; }

die "Usage: disas.pl [-keep] modname\n" if $#ARGV != 0;

$vol = $ENV{'WORKVOL'};
die "Need env var WORKVOL\n" unless $vol;

$file = $mod = $ARGV[0];
$b6 = "disas$$.b6";

$mod =~ s-_-/-g;
$mod =~ s-%-*-g;

open(B, ">$b6") || die "Cannot open $b6 for writing\n";
print B qq/шифр 419999ЗС5^
ЛЕН 60($vol-WR)^
ЕЕВ1А3
*NAME
*LIBRA:2
*CALL DTRAN($mod)
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
