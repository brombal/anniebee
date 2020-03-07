#!/usr/local/bin/perl

print "Content-type: text/html\n\n";


@values=split(/&/, $ENV{'QUERY_STRING'});
$DollName=$values[0];


print <<"EOF";
<html><head><title>$DollName</title></head>
<body background="bgcolor.jpg">
<font face="verdana,arial,helvetica" size=2>

<center><h1><font color="lightgreen">"$DollName"</font></h1></center>
</body></html>

EOF
