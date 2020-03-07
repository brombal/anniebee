#!/usr/local/bin/perl

print "Content-type: text/html\n\n";


read(STDIN, $buffer, $ENV{'CONTENT_LENGTH'});
@pairs = split(/&/, $buffer);
foreach $pair (@pairs) {
    ($name, $value) = split(/=/, $pair);
    $value =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
    $FORM{$name} = $value;
}

if($FORM{'action'} eq "") {

print <<"EOF";
<html><head><title>Website Setup</title></head>
<body background="../../bg.jpg" link="#6666CC" vlink="#BBBBFF" alink="#FFFFFF">

<img src="../../px.gif" height="30">

<table cellpadding="20" border=0 background="../../ltbgcolor.jpg" width="700" align="center">
<tr><td width="*" valign="top"><font face="verdana, arial, helvetica" size="2">




<img src="../../line.jpg">

</td></tr>
</table>

</td></tr>
</table>

<center><img src="../../px.gif" height="20"><br clear="all"><a href="../../home.html"><img src="../../home.gif" border="0"></center>

</body></html>

EOF


}