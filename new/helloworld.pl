#!/usr/local/bin/perl


# use lib '/cgi';
use CGI;

$query = new CGI;
$myvalue = '';

foreach $thingy ($query->param) {
    foreach $whatsit ($query->param($thingy)) {
	$myvalue .= "$thingy: $whatsit<br>\n";
    }
}


print "Content-type: text/html\n\n";

print $myvalue;
print "hello";
