#!/usr/local/bin/perl

$rand = int(rand(4)) + 1;

if($rand eq 1) {
  $splash = "hyd";
} elsif($rand eq 2) {
  $splash = "icl";
} elsif($rand eq 3) {
  $splash = "apr";
} elsif($rand eq 4) {
  $splash = "etn";
}




print "Content-type: text/html\n\n";
print "<html><head>\n<title>Anniebee Artworks...Original Dolls and Other Artwork of Anne-Marie Brombal</title>\n<meta name=\"keywords\" content=\"anniebee artworks, anniebee, sculpted dolls, cloth dolls, sculpted, cloth, patterns, dolls, doll\"></head>\n<body background=\"splash_$splash" . "_bg.gif\">\n\n<center>\n<table border=0 cellspacing=0 cellpadding=0>\n<tr>\n<td rowspan=2 valign=\"top\"><img src=\"splash_$splash" . "_left.jpg\"></td>\n<td colspan=2 valign=\"top\" height=40><img src=\"splash_$splash" . "_title.jpg\"></td>\n</tr>\n<tr>\n<td valign=\"top\"><a href=\"home.html\" target=\"_top\"><img src=\"splash_$splash" . "_enter.jpg\" border=0></a></td>\n<td></td>\n</tr>\n</table>\n</center>\n\n</body></html>";




