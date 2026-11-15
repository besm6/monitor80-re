#!/usr/bin/env perl
use utf8;
use feature 'unicode_strings';
use open ':encoding(UTF-8)';
use open ':std', ':encoding(UTF-8)';

$verbose = 0;
$standard = 0;
@over = ();
while (1) {
if ($#ARGV >= 0 && $ARGV[0] eq '-v') { $verbose = 1; shift @ARGV; }
elsif ($#ARGV >= 0 && $ARGV[0] eq '-s') { $standard = 1; shift @ARGV; }
elsif ($#ARGV > 0 && $ARGV[0] eq '-p') { $perso = $ARGV[1]; shift @ARGV; shift @ARGV; }
elsif ($#ARGV > 0 && $ARGV[0] eq '-o') { push @over, $ARGV[1]; shift @ARGV; shift @ARGV; }
else { last; }
}
$vol = 0;
# -p vol: modules are also taken from the personal library on volume vol
# (made by tolib.pl), for a link too large for the temporary library
die "Usage: overlay.pl [-v] [-p libvol] [-o overlay-spec]... volume# rootmod files\n" if $#ARGV < 2;

$vol = $ARGV[0];
shift @ARGV;
$b6 = "temp.b6";

$root = $ARGV[0];
shift @ARGV;

$lun67 = $perso ? "67($perso)" : '';
$persocard = $perso ? "*PERSO:670000\n" : '';
open(B, ">$b6") || die "Cannot open $b6 for writing\n";
print B qq/шифр 419999ЗС5^
ЛЕН 60($vol-WR)$lun67^
ЕЕВ1А3
*NAME
*call yesmemory
$persocard*MADLEN
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
*libra:2,22
/;
if ($standard) {  print B "*call overlay\n"; } else {
print B qq/
*call overlay*
 anything($root)
/;
}
print B join '\n', @over if @over;
print B qq/
*end record
*call ocatalog
/;
print B qq/
*END FILE
``````
ЕКОНЕЦ
/;
close(B);
system("dispak -l $b6");

