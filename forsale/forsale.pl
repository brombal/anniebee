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


print "Login Successful!<br>";
print "$FORM{'username'}<br>";
print "$FORM{'password'}";


} elsif($FORM{'username'} eq "" && $FORM{'password'} eq "") {

print "Nothing...";

}