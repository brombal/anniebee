#!/usr/local/bin/perl

use CGI;
$query = new CGI;

print $query->header();

$username = $query->param("username");
$password = $query->param("password");

if($username eq "anniebee" && $password eq "annieb140") {
print <<"EOF";
<html><head><title>Website Setup</title></head>
<body background="../../bg.jpg" link="#6666CC" vlink="#BBBBFF" alink="#FFFFFF">

<img src="../../px.gif" height="30">

<table cellpadding="20" border=0 background="../../ltbgcolor.jpg" width="700" align="center">
<tr><td width="*" valign="top"><font face="verdana, arial, helvetica" size="2">

<center><h2>Welcome Annie</h2></center>

<h3>What do you want to do?</h4><br>
<ul>
<li><a href="forsale.pl">Edit Items For Sale</a>
</ul>

<img src="../../line.jpg">

</td></tr>
</table>

</td></tr>
</table>

<center><img src="../../px.gif" height="20"><br clear="all"><a href="../../home.html"><img src="../../home.gif" border="0"></center>

</body></html>

EOF




} else {
  if($username ne "" && $password ne "") {
    $err = "Incorrect username/password<br>Please try again";
  }
  print <<"EOF";
<html><head><title>Login</title></head>
<body background="../../bg.jpg" link="#6666CC" vlink="#BBBBFF" alink="#FFFFFF">

<img src="../../px.gif" height="30">

<table cellpadding="20" border=0 background="../../ltbgcolor.jpg" width="700" align="center">
<tr><td width="*" valign="top"><font face="verdana, arial, helvetica" size="2">

<center>
<h2>Please Log In...</h2>
<h4><font color="red">$err</font></h4>
<form action="main.pl" method="POST">
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
