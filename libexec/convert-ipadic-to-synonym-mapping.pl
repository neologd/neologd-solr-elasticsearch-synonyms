#!/usr/bin/env perl

# Copyright (C) 2015 Toshinori Sato (@overlast)
#
#     https://github.com/neologd/neologd-solr-elasticsearch-synonyms
#
# Licensed under the Apache License, Version 2.0 (the &quot;License&quot;);
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an &quot;AS IS&quot; BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

use strict;
use warnings;
use utf8;
use autodie;

my %mapping = ();
my $in_file = $ARGV[0];
my $out_file = $ARGV[1];

open my $in, '<:utf8', $in_file;
while (my $line = <$in>) {
    my @cols = split /,/, $line;
    my ($surface, $yomi, $baseform, $pos) = ($cols[0], $cols[11], $cols[10], "$cols[4],$cols[5],$cols[6],$cols[7],$cols[8],$cols[9]");
    if (exists $mapping{$baseform}) {
        push @{$mapping{$baseform}}, $surface;
    } else {
        my @surfaces = ($surface);
        $mapping{$baseform} = \@surfaces;
    }
}
close $in;

open my $out, '>:utf8', $out_file;
foreach my $baseform (sort {$a cmp $b} keys %mapping) {
    my @surfaces = @{$mapping{$baseform}};
    #my $key = join '", "', @surfaces;
    my $key = join ', ', @surfaces;
    #print $out '"'.$key.'" => "'.$baseform.'"'."\n";
    #print $out '"'.$key.' => '.$baseform.'"'."\n";
    #print $out $key.' => '.$baseform."\n";
    print $out $baseform.', '.$key."\n";
}
close $out;
