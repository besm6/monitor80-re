#!/usr/bin/env perl
use utf8;
use feature 'unicode_strings';
use open ':encoding(UTF-8)';
use open ':std', ':encoding(UTF-8)';

$verbose = 0;
if ($#ARGV >= 0 && $ARGV[0] eq '-v') { $verbose = 1; shift @ARGV; }

$vol = 0;
die "Usage: asm.pl [-v] volume# files\n" if $#ARGV < 0;

$vol = $ARGV[0];
shift @ARGV;
$b6 = "temp.b6";

open(B, ">$b6") || die "Cannot open $b6 for writing\n";
print B qq/шифр 419999ЗС5^
ЛЕН 60($vol-WR)^
ЕЕВ1А3
*NAME
*MADLEN
/;
print B "*NO LIST\n" unless $verbose;

map {
open(F, $_) || die "Where did $_ go?\n";
while (<F>) {
	print B;
}
close (F);
} (@ARGV);

print B qq/
*libra:2
*call overlay*
 anything(inputcal)
*end record
*call ocatalog
/ unless $verbose;
print B qq/
*END FILE
``````
ЕКОНЕЦ
/;
close(B);
system("dispak -l $b6");

