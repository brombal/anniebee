#!/usr/local/bin/perl -w

use CGI;
$query = new CGI;
$uploaddir = "/home/users/web/b1464/hy.anniebee/forsale/sub";

$action = $query->param("action");
$uploadfile = $query->param("filename");

$imgcount = 0;

print $query->header ( );

if($action eq "addimage") {
 
 open IMAGELIST, "<tempimagelist.txt";
  while($readline = <IMAGELIST>) {
   $readline =~ s/\n//;
   if($readline eq "$uploadfile") {
    $errmsg = "File has already been uploaded!";
    $err = 1;
   }
  }
 close IMAGELIST;

 if(substr($uploadfile,-3,3) ne "jpg" && substr($uploadfile,-3,3) ne "gif" && substr($uploadfile,-3,3) ne "bmp") {
  $errmsg = "Invalid file format";
  $err = 1;
 }

 
 if($err ne 1) {
  open IMAGELIST, ">>tempimagelist.txt";
  print IMAGELIST "$uploadfile\n";
  close IMAGELIST;
 }




} elsif($action eq "delimage") {
 @del = $query->param("images");
 $i = 0;
 $delete = 0;

 open IMAGELIST, "<tempimagelist.txt";
 while($readline = <IMAGELIST>) {
  foreach $item (@del) {
   if(index($readline,$item) ne -1) {
    $delete++;
   }
  }
  if($delete eq 0) {
   $newlist[$i] = $readline;
   $i++;
  }
  $delete = 0;
 }
 close IMAGELIST;

 open IMAGELIST, ">tempimagelist.txt";
 foreach $file (@newlist) {
  print IMAGELIST $file;
 }
 close IMAGELIST;
}




if($action eq "" || $action eq "addimage" || $action eq "delimage") {

print <<"EOF";
<html><head><title>Add Item For Sale</title></head>
<body background="../../bg.jpg" link="#6666CC" vlink="#BBBBFF" alink="#FFFFFF">

<img src="../../px.gif" height="30">

<table cellpadding="20" border=0 background="../../ltbgcolor.jpg" width="700" align="center">
<tr><td width="*" valign="top"><font face="verdana, arial, helvetica" size="2">


<center><h2>Add Item For Sale</h2></center><br>
EOF

 if($err eq 1) {
  print "\n<font size=3 color=\"red\"><b>$errmsg</b></font><p>\n";
 }

print <<"EOF";
<form action="upload.cgi" method="post">
 <input type="hidden" name="action" value="addimage">
 <font size=3><b>Image to upload:</b></font><br>
 <input type="file" name="filename"><br>
 <input type="submit" name="add" value="Upload">
</form>

<form action="upload.cgi" method="post">
 <font size=3><b>Current Images:</b></font><br>
 <select name="images" size=5 width=100 multiple>
EOF

 open IMAGELIST, "<tempimagelist.txt";

 while($readline = <IMAGELIST>) {
  $readline =~ s/.*[\/\\](.*)/$1/;
  print "  <option>$readline";
  $imgcount = 1;
 }

 close IMAGELIST;

 if($imgcount eq 0) {
  print "  <option>(No Images Uploaded)";
 }

print <<"EOF";
 </select><br>
 <input type="hidden" name="action" value="delimage">
 <input type="submit" name="delete" value="Delete">
</form>

<form action="upload.cgi" method="post" enctype="multipart/form-data">
 <font size=3><b>Title:</font></b><br>
 <input type="text" name="title"><p>

 <font size=3><b>Other Information:</font></b> (HTML is okay)<br>
 <textarea rows=6 cols=50 name="text"></textarea><br>

 <center>
 <table border=0 cellpadding=30><tr>
 <td><center><font face="verdana" size=2>Text Above Images</font><p><img src="style1.gif"><br><input type="radio" name="style" value="1" checked></center></td>
 <td><center><font face="verdana" size=2>Text Below Images</font><p><img src="style2.gif"><br><input type="radio" name="style" value="2"></center></td>
 </tr></table>
 </center>

EOF

 open IMAGELIST, "<tempimagelist.txt";

 $i = 1;
 while($readline = <IMAGELIST>) {
  $readline =~ s/\n//;
  print " <input type=\"hidden\" name=\"image$i\" value=\"$readline\">\n";
  $i++;
 }
 $i--;
 print " <input type=\"hidden\" name=\"imgcount\" value=\"$i\">\n";

print <<"EOF";
 <input type="hidden" name="action" value="upload">
 <center><input type="submit" name="submit" value="Submit"></center>
</form>

<center><img src="../../line.jpg"></center>

</td></tr>
</table>

</td></tr>
</table>

<center><img src="../../px.gif" height="20"><br clear="all"><a href="../../home.html"><img src="../../home.gif" border="0"></center>

</body></html>

EOF





} elsif($action eq "upload") {
 $err = 0;
 $title = $query->param("title");
 $text = $query->param("text");
 $style = $query->param("style"); 

 $imgcount = $query->param("imgcount");

 for ($i = 1; $i <= $imgcount; $i++) {
  $imagename[$i] = $query->param("image$i");
  $imagename[$i] =~ s/.*[\/\\](.*)/$1/;
  open IMAGELIST, "<usedimagelist.txt";
   while ($readline = <IMAGELIST>) {
    $readline =~ s/\n//;
    if ($readline eq $imagename[$i]) {
     $errmsg[$i] = "$errmsg\n$readline: File with that name already exists. Please change the name or choose a different file and try again.<br>";
     $err = 1;
    }
   }
  close IMAGELIST;
 }  

 for ($i = 1; $i <= $imgcount; $i++) {
  if ($err eq 0) {
   $imagehandle[$i] = $query->upload("image$i");
   open UPLOADFILE, ">$uploaddir/$imagename[$i]";
    binmode UPLOADFILE;
    while($readline = <$imagehandle[$i]>) {
     print UPLOADFILE $readline;
    }
   close UPLOADFILE;
   open IMAGELIST, ">>usedimagelist.txt";
    print IMAGELIST "$imagename[$i]\n";
   close IMAGELIST;
   print "$imagename[$i]: Upload successful<br>";
  } else {
   print $errmsg[$i];
   print "Upload Aborted";
  }
 }
} 
 
