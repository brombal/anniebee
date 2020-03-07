#!/usr/local/bin/perl

use CGI;
$query = new CGI;

$NAME = $query->param("name");
$EMAIL = $query->param("email");
$DATE = $query->param("date");
$LOCATION = $query->param("location");
$COMMENT = $query->param("comment");


open GUESTBOOK, "<guestbook.txt";
while($item = <GUESTBOOK>) {
  chomp($item);
  push(@GBENTRIES, $item);
}
close GUESTBOOK;

unshift(@GBENTRIES, "$NAME\t$EMAIL\t$DATE\t$LOCATION\t$COMMENT");

open GUESTBOOK, ">guestbook.txt";
print GUESTBOOK join("\n", @GBENTRIES);
close GUESTBOOK;

print "Content-type: text/html\n\n<html><head><title>Entry Added</title></head><body>\n\nThe following entry has been added:<p>\n\nName: $NAME<br>\nEmail: $EMAIL<br>\nDate: $DATE<br>\nLocation: $LOCATION<br>\nComment: $COMMENT\n\n</body></html>";



