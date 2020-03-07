
sub PrintItemList() {
  my(@FORSALE) = &ReadForsale;
  my($item) = "";

  my($itemlist) = &PrintHeader("Items for Sale List", "Items For Sale");
  $itemlist = "$itemlist<form action=\"$FILENAME\" method=\"post\">\n<font size=3><b>Choose an item, or click \"Add\" to create a new one.</b></font><p>\n<select name=\"item\" size=6>";

  if($FORSALE[0] eq "") {
    $itemlist = "$itemlist\n<option>(No Items)";
  } else {
    foreach $item (@FORSALE) {
      my(@itemargs) = split("\t", $item);
      $itemlist = "$itemlist\n<option>@itemargs[2]";
    }
  }

  $itemlist = "$itemlist\n</select><p>\n\n<input type=\"submit\" name=\"mainact\" value=\"Edit\">\n<input type=\"submit\" name=\"mainact\" value=\"Delete\">\n<input type=\"submit\" name=\"mainact\" value=\"Add\"><p>\n\n<center><img src=\"$DIR" . "line.jpg\"></center><p>";
  $itemlist = $itemlist . &PrintFooter();

  return $itemlist;
}

sub PrintItemInfo {
  my($mainact) = shift(@_);
  my($sold) = shift(@_);
  my($style) = shift(@_);
  my($origtitle) = shift(@_);
  my($title) = shift(@_);
  my($text) = shift(@_);
  $text =~ s/<br>/\n/g;
  my(@err) = @_;
  my(@images);
  my(@shortimages);
  my($iteminfo);
  
  $iteminfo = &PrintHeader($mainact . " Item for Sale", $mainact . " Item for Sale");
  
  if($err[0] ne "") {
    $iteminfo = "$iteminfo\n\n<font size=3 color=\"red\"><b>" . join("<br>\n", @err) . "</b></font>";
  }
  
  $iteminfo = "$iteminfo\n\n<form action=\"$FILENAME\" method=\"post\" enctype=\"multipart/form-data\">\n\n <font size=3><b>Title:</font></b><br>\n <input type=\"text\" name=\"title\" value=\"$title\"><p>\n\n <font size=3><b>Other Information:</font></b> (HTML is okay)<br>\n <textarea rows=6 cols=50 name=\"text\">$text</textarea><br>\n\n <input type=\"checkbox\" name=\"sold\" value=\"1\"";

  if($sold eq 1) {
    $iteminfo = "$iteminfo checked";
  }
  
  $iteminfo = "$iteminfo>Mark Item as Sold<br>\n\n <center><img src=\"$DIR" . "line.jpg\"></center><br>\n\n <font size=3><b>Image to upload:</b></font><br>\n <input type=\"file\" name=\"upload\"><br>\n <input type=\"submit\" name=\"action\" value=\"Add\"><p>\n\n <font size=3><b>Upload List:</b></font><br>\n <select name=\"imagelist\" size=5 width=100 multiple>";

  @images = &ReadImages;
  @shortimages = &ShortList(@images);
  
  if ($images[0] eq "") {
    $iteminfo = "$iteminfo\n  <option>(No Image Uploaded)";
  } else {
    foreach $img (@shortimages) {
      $iteminfo = "$iteminfo\n  <option>$img";
    }
  }
  
  $iteminfo = "$iteminfo\n </select><br>\n <input type=\"submit\" name=\"action\" value=\"Delete\"><p>\n\n <center>\n <table border=0 cellpadding=30><tr>";

  if ($style eq 1) {
    $ch1 = " checked";
  } elsif ($style eq 2) {
    $ch2 = " checked";
  }

  $iteminfo = "$iteminfo\n  <td><center><font face=\"verdana\" size=2>Text Below Images</font><p><img src=\"style1.gif\"><br><input type=\"radio\" name=\"style\" value=\"1\"$ch1></center></td>\n  <td><center><font face=\"verdana\" size=2>Text Above Images</font><p><img src=\"style2.gif\"><br><input type=\"radio\" name=\"style\" value=\"2\"$ch2></center></td>\n </tr></table>\n <input type=\"hidden\" name=\"mainact\" value=\"$mainact\">\n";

  if ($origtitle ne "") {
    $iteminfo = "$iteminfo \n<input type=\"hidden\" name=\"origtitle\" value=\"$origtitle\">";
  }

  $iteminfo = "$iteminfo\n\n <center><img src=\"$DIR" . "line.jpg\"></center>\n\n <input type=\"submit\" name=\"action\" value=\"Finish\"><img src=\"$DIR" . "px.gif\" width=20 height=1><input type=\"submit\" name=\"cancel\" value=\"Cancel\">\n</form>";

  $iteminfo = $iteminfo . &PrintFooter;
  return $iteminfo;
}

sub PrintConfirm {
  my($action) = shift(@_);
  my($item) = shift(@_);
  my($sold);
  my($style);
  my($origtitle);
  my($title);
  my($text);
  my(@images);
  my(@finditem);
  if($item eq "") {
    $sold = shift(@_);
    $style = shift(@_);
    $origtitle = shift(@_);
    $title = shift(@_);
    $text = shift(@_);
    @images = &ReadImages;
  } else {
    @finditem = &FindItemByTitle($item);
  }
  my($footer);
  my($header);
  my($main);
  my($confirm);



  if(@finditem[0] eq "" && $title eq "") {
    return &PrintItemList();

  } elsif($action eq "Add" || $action eq "Edit") {
    $header = &PrintHeader("$action Item Confirmation", "$action Item Confirmation", "The new item will appear as it does below.<br>Do you want to continue?");
    $main = &PrintItemHTML("", $sold, $style, $title, $text, @images);
    $confirm = "\n\n<form action=\"$FILENAME\" method=\"post\">\n<input type=\"hidden\" name=\"action\" value=\"Confirm\">\n<input type=\"hidden\" name=\"sold\" value=\"$sold\">\n<input type=\"hidden\" name=\"style\" value=\"$style\">\n<input type=\"hidden\" name=\"title\" value=\"$title\">\n<input type=\"hidden\" name=\"text\" value=\"$text\">\n<input type=\"hidden\" name=\"origtitle\" value=\"$origtitle\">\n<input type=\"hidden\" name=\"mainact\" value=\"$action\">\n<center><input type=\"submit\" name=\"confirm\" value=\"Yes\"><img src=\"$DIR" . "px.gif\" width=20 height=1><input type=\"submit\" name=\"confirm\" value=\"No\"></center>";
    $footer = &PrintFooter;
    
  } elsif($action eq "Delete") {
    $header = &PrintHeader("Delete Item Confirmation", "Delete Item", "The following item will be deleted. Do you want to continue?");
    $main = &PrintItemHTML($item);
    $confirm = "\n\n<form action=\"$FILENAME\" method=\"post\">\n<input type=\"hidden\" name=\"item\" value=\"$item\">\n<input type=\"hidden\" name=\"mainact\" value=\"Delete\">\n<center><input type=\"submit\" name=\"confirm\" value=\"Yes\"><img src=\"$DIR" . "px.gif\" width=\"20\" height=\"1\"><input type=\"submit\" name=\"confirm\" value=\"No\"></center>";
    $footer = &PrintFooter;

  }

  $wholestring = $header . $main . $confirm . $footer;
  return $wholestring;
}

sub PrintSuccess {
  my($item) = shift(@_);
  my($msg) = @_;
  my($success);
  
  $success = &PrintHeader("Upload Successful", "\"$item\" Uploaded Successfully", "$msg");
  $success = "$success\n\n<form action=\"$FILENAME\" method=\"post\"><input type=\"submit\" name=\"mainact\" value=\"Return\"></form><p>\n\n<center><img src=\"$DIR" . "line.jpg\"></center>";
  $success = "$success" . &PrintFooter;
  return $success;
}

sub PrintHeader {
  my($wintitle) = shift(@_);
  my($title) = shift(@_);
  my($subtitle) = @_;

  my($header) = "<html><head><title>$wintitle</title></head>\n<body background=\"$DIR" . "bg.jpg\" link=\"#6666CC\" vlink=\"#BBBBFF\" alink=\"#FFFFFF\">\n\n<img src=\"$DIR" . "px.gif\" height=\"30\">\n\n<table cellpadding=\"20\" border=0 background=\"$DIR" . "ltbgcolor.jpg\" width=\"700\" align=\"center\">\n<tr><td width=\"*\" valign=\"top\"><font face=\"verdana, arial, helvetica\" size=\"2\">\n\n<center><h2>$title</h2></center><br>";

  if($subtitle ne "") {
    $header = "$header\n\n<font size=3 color=\"blue\">$subtitle</font><p>";
  }

  return $header;
}


sub PrintItemHTML {
  my($item) = shift(@_);
  my(@itemargs);
  my($sold);
  my($style);
  my($title);
  my($text);
  my(@images);
  my(@shortimages);
  if($item eq "") {
    @itemargs = @_;
    $sold = shift(@itemargs);
    $style = shift(@itemargs);
    $title = shift(@itemargs);
    $text = shift(@itemargs);
    @images = @itemargs;
    @shortimages = &ShortList(@images);
  } else {
    @itemargs = FindItemByTitle($item);
    $sold = shift(@itemargs);
    $style = shift(@itemargs);
    $title = shift(@itemargs);
    $text = shift(@itemargs);
    @images = @itemargs;
    @shortimages = &ShortList(@images);
  }
  
  my($html) = "\n\n<center>\n<h3>$title</h3>";

  if($sold eq 1) {
    $html = "$html\n<font size=3 color=\"red\">This item has been sold</font><p>";
  }
  
  if($style eq 1) {
    foreach $img (@shortimages) {
      $html = "$html\n<img src=\"$img\"><p>";
    }
    $html = "$html\n$text<br>\n<img src=\"$DIR" . "line.jpg\">\n</center><p>";
  } else {
    $html = "$html\n$text";
    foreach $img (@shortimages) {
      $html = "$html<p>\n<img src=\"$img\">";
    }
    $html = "$html<br>\n<img src=\"$DIR" . "line.jpg\"><p>";
  }
  $html = "$html\n</center>";
  return $html;
}


sub PrintFooter {
  my($footer) = "\n\n</td></tr>\n</table>\n\n<center><img src=\"$DIR" . "px.gif\" height=\"20\"><br clear=\"all\"><a href=\"$DIR" . "home.html\"><img src=\"$DIR" . "home.gif\" border=\"0\"></center>\n\n</body></html>";
  return $footer;
}
  
  
  
  

sub FindItemByTitle {
  my($item) = @_;
  my(@FORSALE) = &ReadForsale;
  my($x);
  my(@itemargs);
  my(@temp);
  
  foreach $x (@FORSALE) {
    my(@temp) = split("\t", $x);
    if (@temp[2] eq $item) {
      @itemargs = @temp;
    }
  }
  return @itemargs;
}


sub ReadForsale {
  my($item) = "";
  my(@forsale);
  open FORSALE, "<forsale.txt";                                            # Put items for sale into list @forsale
  while ($item = <FORSALE>) {
   chomp($item);
   push(@forsale, $item);
  }
  close FORSALE;
  return @forsale;
}

sub WriteForsale {
  my(@forsale) = @_;
  open FORSALE, ">forsale.txt";                                            # Add new list to text file
  print FORSALE join("\n", @forsale);
  close FORSALE;
}

sub ReadImages {
  my($item) = "";
  my(@images);
  open IMAGES, "<tempimages.txt";                                            # Put items for sale into list @forsale
  while ($item = <IMAGES>) {
   chomp($item);
   push(@images, $item);
  }
  close IMAGES;
  return @images;
}

sub ShortList {
 my(@SHORTIMAGES) = @_;
 foreach $img (@SHORTIMAGES) {
  $img =~ s/.*[\/\\](.*)/$1/;
 }
 return @SHORTIMAGES;
}





sub UpdateHTML {
  my(@forsale) = @_;
  my($html);
  my($sold);
  my($style);
  my($title);
  my($text);
  my(@images);
  
  $html = "<html><head><title>Anniebee Artworks...Items for Sale</title></head>\n<body background=\"$DIR" . "bg.jpg\" link=\"#6666CC\" vlink=\"#BBBBFF\" alink=\"#FFFFFF\">\n\n<img src=\"$DIR" . "px.gif\" height=\"30\">";
  $html = "$html\n\n<table cellpadding=\"20\" border=0 background=\"$DIR" . "ltbgcolor.jpg\" width=\"700\" align=\"center\">\n<tr><td width=\"*\" valign=\"top\"><font face=\"verdana, arial, helvetica\" size=\"2\">\n\n<img src=\"title.jpg\"><p>";

  foreach $item (@forsale) {
   chomp $item;
   @items = split("\t", $item);
   $sold = shift(@items);
   $style = shift(@items);
   $title = shift(@items);
   $text = shift(@items);
   @images = @items;

   $html = "$html" . &PrintItemHTML("", $sold, $style, $title, $text, @images);
  }

  $html = "$html" . &PrintFooter();
  open FORSALEHTML, ">forsale.html";
  print FORSALEHTML $html;
  close FORSALEHTML;
}


1;
