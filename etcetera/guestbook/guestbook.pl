#!/usr/local/bin/perl

use CGI;
$query = new CGI;

$ACTION = $query->param("action");
$NAME = $query->param("name");
$EMAIL = $query->param("email");
$DATE = &GetDate();
$LOCATION = $query->param("location");
$COMMENT = $query->param("comment");
$sendmail = "/usr/sbin/sendmail -t";

print $query->header();


open GUESTBOOK, "<guestbook.txt";
while($item = <GUESTBOOK>) {
  chomp($item);
  push(@GBENTRIES, $item);
}
close GUESTBOOK;


if($ACTION eq "submit") {
  $NAME =~ s/([\W])/"%" . uc(sprintf("%2.2x",ord($1)))/eg;
  $EMAIL =~ s/([\W])/"%" . uc(sprintf("%2.2x",ord($1)))/eg;
  $LOCATION =~ s/([\W])/"%" . uc(sprintf("%2.2x",ord($1)))/eg;
  $DATE =~ s/([\W])/"%" . uc(sprintf("%2.2x",ord($1)))/eg;
  $COMMENT =~ s/([\W])/"%" . uc(sprintf("%2.2x",ord($1)))/eg;

  if(index($COMMENT, "http")!=-1) { die("Sorry, URL Cannot contain a hyperlink. Please click \"back\" and try again."); }

  $args = "name=" . $NAME . "\&email=" . $EMAIL . "\&date=" . $DATE . "\&location=" . $LOCATION . "\&comment=" . $COMMENT;
  $content = "Name:" . $query->param("name") . "\nEmail: " . $query->param("email") . "\nDate: " . &GetDate() . "\nLocation: " . $query->param("location") . "\nComment: " . $query->param("comment") . "\n\n\nTo upload this entry, click here:\nwww.anniebee.net/etcetera/guestbook/addentry.pl?$args";

  if($NAME && $COMMENT) {
  open(SENDMAIL, "|$sendmail") or die "Cannot open Sendmail, Click Back in your browser and try again.";
  print SENDMAIL "To: DragonShadow9\@hotmail.com\n";
  print SENDMAIL "From: webmaster\@anniebee.net\n";
  print SENDMAIL "Subject: New Guestbook Submission\n";
  print SENDMAIL "Content-type: text/plain\n\n";
  print SENDMAIL $content;
  close(SENDMAIL);  
  }

  $GBHTML = "<font color=\"blue\" size=\"3\">Your entry has been submitted. Thank you!<br>Note: Due to potential spamming, your entry must be approved before it will be posted.</font><p>\n\n$GBHTML";
}


foreach $entry (@GBENTRIES) {
  @gbargs = split("\t", $entry);
  $GBHTML = "$GBHTML<b>Name:</b> $gbargs[0]<p>\n<b>Date:</b> $gbargs[2]<p>\n<b>Location:</b> $gbargs[3]<p>\n<b>Comments:</b><br>\n$gbargs[4]<p>\n\n<img src=\"../../line.jpg\">\n\n";
}

print &PrintHTML("Anniebee Artworks...The Guestbook", "<center><a href=\"#sign\"><img src=\"sign1.jpg\" border=\"0\"></a></center><br>\n<img src=\"../../px.gif\" height=\"20\"><br>\n\n<img src=\"../../line.jpg\">\n$GBHTML<img src=\"../../px.gif\" height=\"20\"><br>\n\n<center><a name=\"sign\"><img src=\"sign1.jpg\" border=\"0\"></a></center><br>\n\n<img src=\"../../px.gif\" height=\"20\"><br>\n\nPlease fill out this form and click \"Submit\" to add your entry to the guestbook.<br>All information is optional, and email addresses will not be shared with anyone.\n<form method=\"post\" action=\"guestbook.pl\" name=\"guestbook\">\nName:<br>\n<input type=\"text\" name=\"name\" maxlength=\"30\"><p>\n\nEmail address:<br>\n<input type=\"text\" name=\"email\"><p>\n\nLocation:<br>\n<input type=\"text\" name=\"location\" maxlength=\"30\"><p>\n\nComments:<br>\n<textarea rows=\"6\" cols=\"40\" name=\"comment\"></textarea><p>\n\n<input type=\"submit\" name=\"submit\" value=\"Submit\" onClick=\"if(document.guestbook.comment.value.indexOf('http')==-1) { return true; } else { alert('Sorry, comment cannot contain a url.'); return false; }\">\n<input type=\"hidden\" name=\"action\" value=\"submit\">\n</form><p>\n\n");



sub PrintHTML {
  my($TITLE) = shift(@_);
  my($HTML) = @_;
  my($text);
  $text = "<html><head><title>Anniebee Artworks...$TITLE</title></head>\n<body background=\"../../bg.jpg\" link=\"#6666CC\" vlink=\"#BBBBFF\" alink=\"#FFFFFF\">\n\n<img src=\"../../px.gif\" height=\"30\">\n\n<table cellpadding=\"20\" border=0 background=\"../../ltbgcolor.jpg\" width=\"700\" align=\"center\">\n<tr><td width=\"*\" valign=\"top\"><font face=\"verdana, arial, helvetica\" size=\"2\">\n\n<img src=\"title.jpg\"><br clear=\"all\">\n<img src=\"../../px.gif\" height=\"40\"><br clear=\"all\">\n\n<table width=\"90%\" align=\"center\" border=\"0\"><tr><td><font face=\"verdana, arial, helvetica\" size=\"2\">\n\n$HTML<img src=\"../../line.jpg\">\n\n</td></tr>\n</table>\n\n</td></tr>\n</table>\n\n<center><img src=\"../../px.gif\" height=\"20\"><br clear=\"all\"><a href=\"../../home.html\"><img src=\"../../home.gif\" border=\"0\"></center>\n\n<!-- Start of StatCounter Code -->\n<script type=\"text/javascript\" language=\"javascript\">\nvar sc_project=474428; \nvar sc_partition=2; \n</script>\n\n<script type=\"text/javascript\" language=\"javascript\" src=\"http://www.statcounter.com/counter/counter.js\"></script><noscript><a href=\"http://www.statcounter.com/\" target=\"_blank\"><img  src=\"http://c3.statcounter.com/counter.php?sc_project=474428&amp;java=0\" alt=\"free web page hit counter\" border=\"0\"></a> </noscript>\n<!-- End of StatCounter Code -->\n\n</body></html>";
  return $text;
}

sub GetDate {
  my($Second);
  my($Minute);
  my($Hour);
  my($Day);
  my($Month);
  my($Year);
  my($WeekDay);
  my($DayOfYear);
  my($IsDST);
  
  ($Second, $Minute, $Hour, $Day, $Month, $Year, $WeekDay, $DayOfYear, $IsDST) = localtime(time);
  
  $RealMonth = $Month + 1;
  if($RealMonth < 10) { 
    $RealMonth = "0" . $RealMonth;
  }

  if($Day < 10) { 
    $Day = "0" . $Day;
  } 

  $RealYear = $Year + 1900;

  return "$RealMonth/$Day/$RealYear";
}
