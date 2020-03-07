#!/usr/local/bin/perl

use CGI;
$query = new CGI;
require("subs.pl");
$uploaddir = "/home/users/web/b1464/hy.anniebee/etcetera/forsale";
$FILENAME = "forsale.pl";
$DIR = "../";

$MAINACT = $query->param("mainact");
$ACTION = $query->param("action");
$CANCEL = $query->param("cancel");
$CONFIRM = $query->param("confirm");
$ITEM = $query->param("item");
$SOLD = $query->param("sold");
if($SOLD eq "") {$SOLD = 0}
$STYLE = $query->param("style");
$ORIGTITLE = $query->param("origtitle");
$TITLE = $query->param("title");
$TEXT = $query->param("text");
$TEXT =~ s/(\r\n)|\r|\n/<br>/g;
@IMAGES = &ReadImages();
@SHORTIMAGES = &ShortList(@IMAGES);
@FORSALE = &ReadForsale;

print $query->header();


if($MAINACT eq "" || $CANCEL eq "Cancel" || $MAINACT eq "Return") {
  unlink @SHORTIMAGES;
  print &PrintItemList();
  exit;
}



if($MAINACT eq "Add" || $MAINACT eq "Edit") {

  if($ACTION eq "Add") {
    $UPLOAD = $query->param("upload");
    $short = $UPLOAD;
    $short =~ s/.*[\/\\](.*)/$1/;
    
    if(-e $short) {
      print &PrintItemInfo("Add", $SOLD, $STYLE, $ORIGTITLE, $TITLE, $TEXT, "Image with that name already exists. Change the filename or choose a different image.");
      exit;
    }
    if(substr($UPLOAD,-3,3) ne "jpg" && substr($UPLOAD,-3,3) ne "gif" && substr($UPLOAD,-3,3) ne "bmp") {
      print &PrintItemInfo("Add", $SOLD, $STYLE, $ORIGTITLE, $TITLE, $TEXT, "Invalid file format. Files should be GIFs, JPGs, or BMPs only.");
      exit;
    }

    open TEMPIMAGES, ">tempimages.txt";
    push(@IMAGES, $UPLOAD);
    print TEMPIMAGES join("\n", @IMAGES);
    close TEMPIMAGES;
    
    open NEWFILE, ">$uploaddir/$short";
    while (<$UPLOAD>) {
      print NEWFILE $_;
    }
    close $UPLOAD;

    print &PrintItemInfo($MAINACT, $SOLD, $STYLE, $ORIGTITLE, $TITLE, $TEXT, "");
    
    

  } elsif($ACTION eq "Delete") {
    @DELIMGS = $query->param("imagelist");
    
    for ($i = $#IMAGES; $i >= 0; $i--) {
      foreach $img (@DELIMGS) {
        if($img eq $SHORTIMAGES[$i]) {
          splice(@IMAGES, $i, 1);
        }
      }
    }
    
    open TEMPIMAGES, ">tempimages.txt";
    print TEMPIMAGES join("\n", @IMAGES);
    close TEMPIMAGES;
    
    unlink @DELIMGS;
    
    print &PrintItemInfo($MAINACT, $SOLD, $STYLE, $ORIGTITLE, $TITLE, $TEXT, "");


  } elsif($ACTION eq "Finish") {
    if($MAINACT eq "Add") {
      @TestItem = &FindItemByTitle($TITLE);
      if($TestItem[0] ne "") {
        print &PrintItemInfo($MAINACT, $SOLD, $STYLE, $ORIGTITLE, $TITLE, $TEXT, "Another item with the same title already exists.<br>Enter a unique title and click \"Finish\"");
        exit;
      }
    }
    
    print &PrintConfirm($MAINACT, "", $SOLD, $STYLE, $ORIGTITLE, $TITLE, $TEXT);


  } elsif($ACTION eq "Confirm") {
    if($CONFIRM eq "Yes") {
      if($MAINACT eq "Add") {
        $newitem = $SOLD . "\t" . $STYLE . "\t" . $TITLE . "\t" . $TEXT . "\t" . join("\t", @SHORTIMAGES);
        unshift(@FORSALE, $newitem);

      } elsif($MAINACT eq "Edit") {
        if($TITLE ne $ORIGTITLE) {
          @TestItem = &FindItemByTitle($TITLE);
          $i = 1;
          $newtitle = $TITLE;
          while(@TestItem[0] ne "") {
            $newtitle = $TITLE . "\_$i";
            @TestItem = &FindItemByTitle($newtitle);
            $i++;
          }
          $TITLE = $newtitle;
        }
      
        for($i = 0; $i <= $#FORSALE; $i++) {
          @ItemArgs = split("\t", $FORSALE[$i]);
          if($ORIGTITLE eq $ItemArgs[2]) {
            $newitem = $SOLD . "\t" . $STYLE . "\t" . $TITLE . "\t" . $TEXT . "\t" . join("\t", @SHORTIMAGES);
            splice(@FORSALE, $i, 1, $newitem);
          }
        }
      }
      
      &WriteForsale(@FORSALE);
      
      open TEMPIMAGES, ">tempimages.txt";
      print TEMPIMAGES "";
      close TEMPIMAGES;

      &UpdateHTML(@FORSALE);

      print &PrintSuccess($TITLE, "$msg<p>\nUpload Successful");

    } elsif($CONFIRM eq "No") {
      print &PrintItemInfo($MAINACT, $SOLD, $STYLE, $ORIGTITLE, $TITLE, $TEXT, "Upload Aborted");
    }


  } else {
    if($MAINACT eq "Add") {
      open IMAGES, ">tempimages.txt";
      print IMAGES "";
      close IMAGES;
      print &PrintItemInfo("Add", 0, 1, "", "", "", "");

    } elsif($MAINACT eq "Edit") {
      @EditItem = &FindItemByTitle($ITEM);
      if(@EditItem[0] eq "") {
        print &PrintItemList();
      } else {
        $SOLD = shift(@EditItem);
        $STYLE = shift(@EditItem);
        $TITLE = shift(@EditItem);
        $TEXT = shift(@EditItem);
        open TEMPIMAGES, ">tempimages.txt";
        print TEMPIMAGES join("\n", @EditItem);
        close TEMPIMAGES;
        print &PrintItemInfo("Edit", $SOLD, $STYLE, $TITLE, $TITLE, $TEXT, "");
      }
    }
  }
}


if($MAINACT eq "Delete") {
  if($CONFIRM eq "Yes") {
    for($i = $#FORSALE; $i >= 0; $i--) {
      @lineargs = split("\t", $FORSALE[$i]);
      if($lineargs[2] eq $ITEM) {
        splice(@FORSALE, $i, 1);
      }
    }
    &WriteForsale(@FORSALE);
    
    unlink @SHORTIMAGES;
    
    print &PrintItemList();
    
  } elsif($CONFIRM eq "No") {
    print &PrintItemList();
    
  } else {
    print &PrintConfirm("Delete", $ITEM);
  }
}
