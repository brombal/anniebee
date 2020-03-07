#!/usr/local/bin/perl

use CGI qw(header);

my $xml= <<EOF;
<?xml version="1.0" encoding="UTF-8"?>
<main>
 <sub>hello</sub>
</main>
EOF

print header(-type=>'text/xml', charset=>'UTF-8');
  print $xml;
