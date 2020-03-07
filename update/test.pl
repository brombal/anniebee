#!/usr/local/bin/perl -w 


#use strict 'refs';
#use lib '..';
use CGI qw(:standard);
use CGI::Carp qw/fatalsToBrowser/;
$query = new CGI;
$uploaddir = "/home/users/web/b1464/hy.anniebee/update";






print $query->header();


my @types = ('count lines','count words','count characters');


$file = $query->param("filename");
$short = $file;
$short =~ s/.*[\/\\](.*)/$1/;
print "$file<br>\n$short<br>";


    open NEWFILE, ">$uploaddir/$short";

    while (<$file>) {
	print NEWFILE $_;
    }
    close $file;

	

    end_html;

