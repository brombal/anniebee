#!/usr/local/bin/perl

print "Content-type: text/html\n\n";


read(STDIN, $buffer, $ENV{'CONTENT_LENGTH'});
@pairs = split(/&/, $buffer);
foreach $pair (@pairs) {
    ($name, $value) = split(/=/, $pair);
    $value =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
    $FORM{$name} = $value;
}

if($FORM{'username'} eq "anniebee" && $FORM{'password'} eq "annieb140") {

print <<"EOF";
<html><head><title>Website Setup</title></head>
<body background="../../bg.jpg" link="#6666CC" vlink="#BBBBFF" alink="#FFFFFF">

<img src="../../px.gif" height="30">

<table cellpadding="20" border=0 background="../../ltbgcolor.jpg" width="700" align="center">
<tr><td width="*" valign="top"><font face="verdana, arial, helvetica" size="2">

<center><h2>Welcome Annie</h2></center>

<h3>What do you want to do?</h4><br>
<ul>
<li><h4>Items For Sale</h4>
	<ul>
	<li><h4><a href="additem.pl">Add Item</a></h4>
	<li><h4><a href="edititem.pl">Edit Item</a></h4>
	<li><h4><a href="markitem.pl">Mark As Sold</a></h4>
	<li><h4><a href="delitem.pl">Delete Item</a></h4>
	</ul>
</ul>


<img src="../../line.jpg">

</td></tr>
</table>

</td></tr>
</table>

<center><img src="../../px.gif" height="20"><br clear="all"><a href="../../home.html"><img src="../../home.gif" border="0"></center>

</body></html>

EOF






} elsif($FORM{'username'} eq "" && $FORM{'password'} eq "") {

print <<"EOF";
<html><head><title>Login</title></head>
<body background="../../bg.jpg" link="#6666CC" vlink="#BBBBFF" alink="#FFFFFF">

<img src="../../px.gif" height="30">

<table cellpadding="20" border=0 background="../../ltbgcolor.jpg" width="700" align="center">
<tr><td width="*" valign="top"><font face="verdana, arial, helvetica" size="2">

<center>
<h2>Please Log In...</h2>

<form action="forsale.pl" method="POST">
<h4>Username: <input type="text" name="username"><br></h4>
<h4>Password: <input type="password" name="password"><br></h4>
<input type="submit" value="Login">
</form>

<img src="../../line.jpg">

</td></tr>
</table>

</td></tr>
</table>

<center><img src="../../px.gif" height="20"><br clear="all"><a href="../../home.html"><img src="../../home.gif" border="0"></center>

</body></html>

EOF





} else {

print <<"EOF";
<html><head><title>Login</title></head>
<body background="../../bg.jpg" link="#6666CC" vlink="#BBBBFF" alink="#FFFFFF">

<img src="../../px.gif" height="30">

<table cellpadding="20" border=0 background="../../ltbgcolor.jpg" width="700" align="center">
<tr><td width="*" valign="top"><font face="verdana, arial, helvetica" size="2">

<center>
<h2>Please Log In...</h2>
<h4><font color="red">Incorrect Username/Password<br>Please try again</font></h4>
<form action="forsale.pl" method="POST">
<h4>Username: <input type="text" name="username"><br></h4>
<h4>Password: <input type="password" name="password"><br></h4>
<input type="submit" value="Login">
</form>

<img src="../../line.jpg">

</td></tr>
</table>

</td></tr>
</table>

<center><img src="../../px.gif" height="20"><br clear="all"><a href="../../home.html"><img src="../../home.gif" border="0"></center>

</body></html>

EOF

}