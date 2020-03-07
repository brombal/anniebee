#!/usr/local/bin/perl

print "Content-type:text/html\n\n";



$DollName=$ENV{"QUERY_STRING"};
$i=0;
$foundit="no";

open(Dolls, "Dolls.txt");
foreach $line(<Dolls>) {
	$line=substr($line,0,length($line)-1);

	if(index($line,$DollName)!=-1 && $foundit eq "no") {
		$foundit="yes";
	} elsif($foundit eq "yes") {
		if($line ne "//") {
			@RawData[$i]=$line;
			$foundit="yes";
			$i++;
		} else {
			$foundit="no";
		}
	}
}
close Dolls;
$foundit="no";

$i=0;
foreach $Data(@RawData) {
	if(index($Data,"=") != -1) {
		@hold = split(/=/, $Data);
		$Name[$i] = @hold[0];
		$Value[$i] = @hold[1];
	} else {
		$Name[$i] = $Data;
		$Value[$i] = "";
	}
	$i++;
}

$i=0;
$j=0;
foreach $Current(@Name) {
	if($Current eq "name") {
		$DollName = $Value[$i];
		$i++;
	} elsif($Current eq "images") {
		@ImageList = split(/,/,$Value[$i]);
	} else {
		$Layout[$j] = $Current;
		$j++;
	}
}


print <<"EOF1";
<html><head><title>$DollName</title></head>
<body background="bgcolor.jpg">
<font face="verdana,arial,helvetica" size=2>

<center><h1><font color="lightgreen">"$DollName"</font></h1></center>

EOF1

$i=0;
foreach $item(@Layout) {
	if(index($item,"~") != -1) {
		@hold = split(/~/, $item);
		if($hold[0] eq "r") {
			print <<"EndImageR";
<img src="$ImageList[$i]" align="right">$hold[1]<br clear="all"><br>
EndImageR
		} elsif($hold[0] eq "l") {
			print <<"EndImageL";
<img src="$ImageList[$i]" align="left">$hold[1]<br clear="all"><br>
EndImageL
		} else {
			print <<"EndImageL";
<img src="$ImageList[$i]" align="center">$hold[1]<br clear="all"><br>
EndImageL
		}
		$i++;
	} elsif($item eq "bar") {
		print "<center><img src\=\"bar.jpg\"></center><br clear=\"all\"><br>\n";
	} else {
		print "<img src\=\"$item\.jpg\"><br clear=\"all\"><br>\n";
	}

}

print <<"EOF2";

</body></html>
EOF2
