#!/usr/bin/env perl
# Assemble Madlen sources into a personal library on a scratch volume:
#     tolib.pl volume# files... > listing
# The library starts at zone 0 of the volume (LUN 67); overlay.pl -p volume#
# then links with it. Needed when the modules of one link do not fit into
# the temporary library on the drum (HET MECTA HA MБ).
use utf8;
use open ':encoding(UTF-8)';
use open ':std', ':encoding(UTF-8)';

die "Usage: tolib.pl volume# files\n" if $#ARGV < 1;
$vol = shift @ARGV;
$b6 = "tolib.b6";
open(B, ">$b6") || die "Cannot open $b6 for writing\n";
print B qq/шифр 419999ЗС5^
ЛЕН 67($vol-WR)^
ЕЕВ1А3
*NAME
*call yesmemory
*MADLEN
*NO LIST
/;
for (@ARGV) {
    open(F, $_) || die "Where did $_ go?\n";
    print B $_ while <F>;
    close(F);
}
print B qq/
*TO PERSO
*CALL PLCATALOG
*END FILE
``````
ЕКОНЕЦ
/;
close(B);
system("dispak -l $b6");
unlink($b6);
