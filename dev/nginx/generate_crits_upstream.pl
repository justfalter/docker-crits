#!/usr/bin/perl
use strict;
use warnings;

print("upstream critsupstream {\n");


foreach my $key ( keys(%ENV) ) {
  next if ($key !~ /^CRITS_\d+_PORT_8001_TCP$/);
  my @parts = split('://', $ENV{$key});
  printf("server %s;\n", $parts[1]);
}

print("keepalive 32;");
print("}\n");
