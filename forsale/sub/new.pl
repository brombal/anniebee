#!/usr/local/bin/perl -w

use CGI;
use Fcntl;
$query = new CGI;
$uploaddir = "/home/users/web/b1464/hy.anniebee/forsale/sub";

$action = $query->param("action");
$TITLE = $query->param("title");
$TEXT = $query->param("text");
$STYLE = $query->param("style");

open IMAGELIST, "<tempimages.txt";
@IMAGES = <IMAGELIST>;
close IMAGELIST;
foreach $img (@IMAGES) {
 chomp $img;
}
$IMGCOUNT = $#IMAGES;

&ShortList;


print $query->header ( );


if ($action eq "Add") {
 $uploadfile = $query->param("uploadfile");

 foreach $img (@IMAGES) {
  chomp($img);
  if($img eq $uploadfile) {
   $err = "Item has already been uploaded"; 
  }
 }
 if(substr($uploadfile,-3,3) ne "jpg" && substr($uploadfile,-3,3) ne "gif" && substr($uploadfile,-3,3) ne "bmp") {
   $err = "Invalid file format (Should be JPG, GIF, or BMP)";
 }

 if ($err eq "") {
  push (@IMAGES, $uploadfile);
  &ShortList;
  open IMAGELIST, ">tempimages.txt";
  print IMAGELIST join("\n", @IMAGES);
  close IMAGELIST;
 }

 &PrintMain($err, "", @SHORTIMAGES);


#####


} elsif ($action eq "Delete") {

 @del = $query->param("imagelist");
 
  for ($i = $IMGCOUNT; $i >= 0; $i--) {
  $img = $SHORTIMAGES[$i];
  foreach $delimg (@del) {
   if ($delimg eq $img) {
    splice(@IMAGES, $i, 1);
    splice(@SHORTIMAGES, $i, 1);
   }
  }
 }
 
 open IMAGELIST, ">tempimages.txt";
 print IMAGELIST join("\n", @IMAGES);
 close IMAGELIST;

 &PrintMain("", "", @SHORTIMAGES);


#####


} elsif ($action eq "Upload") {
 foreach $img (@SHORTIMAGES) {                                                  # Check to see if any of the files exist
  if(-e "$img") {
   $err = "$err$img: File with that name already exists. Please rename the file or choose a different one.<br>\n";
  }
 }
 
 if ($err eq "") {                                                         # If there is no error
  for ($i = 0; $i <= $IMGCOUNT; $i++) {                                         # Upload the files
   $imagehandle[$i] = $query->upload($IMAGES[$i]);
   open UPLOADFILE, ">$uploaddir/$SHORTIMAGES[$i]";
   binmode UPLOADFILE;
   while ($readline = <$imagehandle[$i]>) {
    print UPLOADFILE $readline;
   }
   close UPLOADFILE;
  }

  open TEMPIMAGE, ">tempimages.txt";                                            # Clear the tempimages file
  print TEMPIMAGE "";
  close TEMPIMAGE;

  open FORSALE, "<forsaleitems.txt";                                            # Put items for sale into list @forsale
  while ($item = <FORSALE>) {
   chomp($item);
   push(@forsale, $item);
  }
  close FORSALE;

  $string = join("\t", @SHORTIMAGES);                                           # Make single string out of short images
  unshift(@forsale, "$STYLE\t$TITLE\t$TEXT\t$string");                          # Add it to @forsale
  
  open FORSALE, ">forsaleitems.txt";                                            # Add new list to text file
  print FORSALE join("\n", @forsale);
  close FORSALE;
 
  &UpdateHTML();                                                                # Write to html file
  
  foreach $img (@SHORTIMAGES) {                                                 # Write success messages
   $success = "$success$img: File Uploaded Successfully<br>\n";
  }

  $TITLE = "";
  $TEXT = "";
  &PrintMain("", $success, "");                                             # Print to screen
  
 } else {                                                                  # If there is an error
  &PrintMain($err, "", @SHORTIMAGES);
 }



} elsif ($action eq "") {
 &PrintMain("", "", "");

}





sub UpdateHTML {
  open FORSALEHTML, ">forsale.html";
  print FORSALEHTML "<html><head><title>Anniebee Artworks...Items for Sale</title></head>\n<body background=\"../../bg.jpg\" link=\"#6666CC\" vlink=\"#BBBBFF\" alink=\"#FFFFFF\">\n\n<img src=\"../../px.gif\" height=\"30\">\n\n";
  print FORSALEHTML "<table cellpadding=\"20\" border=0 background=\"../../ltbgcolor.jpg\" width=\"700\" align=\"center\">\n<tr><td width=\"*\" valign=\"top\"><font face=\"verdana, arial, helvetica\" size=\"2\">\n\n<img src=\"title.jpg\"><p>\n\n";

  foreach $item (@forsale) {
   chomp $item;
   @items = split("m", $item);
   $tmpstyle = shift(@items);
   $tmptitle = shift(@items);
   $tmptext = shift(@items);
   @tmpimages = @items;

   print FORSALEHTML "<h3>$tmptitle</h3>\n";
   
   if($style eq 1) {
    foreach $img (@tmpimages) {
     print FORSALE "<img src=\"$img\"><p>\n";
    }
    print FORSALE "$tmptext<p>\n<img src=\"../../line.jpg\"><p>\n\n";

   } else {
    print FORSALE "$tmptext<p>\n";
    foreach $img (@tmpimages) {
     print FORSALE "<img src=\"$img\"><p>\n";
    }
    print FORSALE "<img src=\"../../line.jpg\"><p>\n\n";
   }
  }
  
  print FORSALEHTML "</td></tr>\n</table>\n\n</td></tr>\n</table>\n\n<center><img src=\"../../px.gif\" height=\"20\"><br clear=\"all\"><a href=\"../../home.html\"><img src=\"../../home.gif\" border=\"0\"></center>\n\n</body></html>";
  close FORSALEHTML;

}




sub PrintMain {
 $err = shift(@_);
 $msg = shift(@_);
 @images = @_;


 print <<"EOF";
<html><head><title>Add Item For Sale</title></head>
<body background="../../bg.jpg" link="#6666CC" vlink="#BBBBFF" alink="#FFFFFF">

<img src="../../px.gif" height="30">

<table cellpadding="20" border=0 background="../../ltbgcolor.jpg" width="700" align="center">
<tr><td width="*" valign="top"><font face="verdana, arial, helvetica" size="2">


<center><h2>Add Item For Sale</h2></center><br>

EOF

if ($err ne "") {
 print "<font size=3 color=\"red\"><b>";
 print $err;
 print "</b></font>";
}
if ($msg ne "") {
 print "<font size=3 color=\"green\"><b>";
 print $msg;
 print "</b></font>";
}

print <<"EOF";
<form action="new.pl" method="post" enctype="multipart/form-data">
 <font size=3><b>Image to upload:</b></font><br>
 <input type="file" name="uploadfile"><br>
 <input type="submit" name="action" value="Add"><p>


 <font size=3><b>Upload List:</b></font><br>
 <select name="imagelist" size=5 width=100 multiple>
EOF

 if ($images[0] eq "") {
  print "  <option>(No Image Uploaded)";
 } else {
  foreach $img (@images) {
   print "  <option>$img";
  }
 } 

print <<"EOF";
 </select><br>
 <input type="submit" name="action" value="Delete"><p>

 <font size=3><b>Title:</font></b><br>
 <input type="text" name="title" value="$TITLE"><p>

 <font size=3><b>Other Information:</font></b> (HTML is okay)<br>
 <textarea rows=6 cols=50 name="text">$TEXT</textarea><br>

 <center>
 <table border=0 cellpadding=30><tr>
 <td><center><font face="verdana" size=2>Text Below Images</font><p><img src="../style1.gif"><br><input type="radio" name="style" value="1" checked></center></td>
 <td><center><font face="verdana" size=2>Text Above Images</font><p><img src="../style2.gif"><br><input type="radio" name="style" value="2"></center></td>
 </tr></table>

 <input type="submit" name="action" value="Upload">
</form>

<center><img src="../../line.jpg"></center>

</td></tr>
</table>

</td></tr>
</table>

<center><img src="../../px.gif" height="20"><br clear="all"><a href="../../home.html"><img src="../../home.gif" border="0"></center>

</body></html>

EOF

}


sub ShortList() {
 @SHORTIMAGES = @IMAGES;
 foreach $img (@SHORTIMAGES) {
  $img =~ s/.*[\/\\](.*)/$1/;
 }
}
