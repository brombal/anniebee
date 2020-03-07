#!/usr/local/bin/perl

$text = "blablabla\@blablabla===";

$text =~ s/(\W)/"%" . uc(sprintf("%2.2x",ord($1)))/eg;  ###s/(\W)/hex($1)/eg;

print "Content-type: text/html\n\n";

print $text;