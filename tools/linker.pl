#!/usr/bin/env perl
use utf8;
use feature 'unicode_strings';
use open ':encoding(UTF-8)';
use open ':std', ':encoding(UTF-8)';

$keep = 0;
$z = -1;

while ($#ARGV >= 0) {
        if($ARGV[0] eq '-keep') { $keep = 1; shift @ARGV; }
        elsif ("$ARGV[0] $ARGV[1]" =~ m/-zone ([0-7]{4})/) { $z = $1; shift @ARGV; shift @ARGV; }
        elsif ("$ARGV[0] $ARGV[1]" =~ m/-top (.{1,8})/) { $top = $1; shift @ARGV; shift @ARGV; }
        else { last; }
}

# print STDERR "Remaining args: ", join(' ', @ARGV), "\n";

die "Usage: linker.pl -zone NNNN -top <topmod> [-keep] file.obj...\n" if $z == -1 || $#ARGV < 0;

$vol = $ENV{'WORKVOL'};
die "Need env var WORKVOL\n" unless $vol;

$b6 = "link$$.b6";

open(B, ">$b6") || die "Cannot open $b6 for writing\n";
print B qq/шифр 419999ЗС5^
ЛЕН 67($vol-WR)^
ЕЕВ1А3
*NAME
*NO LIST
/;

map {
die "Files must have the .obj suffix\n" unless /\.obj$/;
open(F, $_) || die "Where did $_ go?\n";
while (<F>) {
        print B;
}
close (F);
} (@ARGV);
print B qq/
*assem
 DUMPER:,NAME,
 END:,LP,0
 SPACER:,LP,2000B-END
 $top:,SUBP,
 ,*70, WRITE
 ,SJ,
 WRITE:,LOG,0000 0100 0067 $z
 ,END,
*main dumper
*execute
*end file
``````
еконец
/;
close(B);

$listing=`dispak -l $b6`;
#if ($listing =~ /\n \*\*\*\*\*\*/) {
#        print STDERR $listing;
#        die "Compilation failed\n";
#}
system("besmtool dump $vol --start=0$z --length=1 > $top.dis");
unlink($b6) unless $keep;
