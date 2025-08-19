#!/usr/bin/env perl
use utf8;
use feature 'unicode_strings';
use open ':encoding(UTF-8)';
use open ':std', ':encoding(UTF-8)';

while (<>) {
        $line = $_;
        while ($line =~ /(........)   \d\d \d\d \d\d  \d\d\d\d\d/) {
                $mod = $1;
                $mod =~ s/ //g;
                print "$mod\n";
                $line =~ s/........   \d\d \d\d \d\d  \d\d\d\d\d//;
        }
}
