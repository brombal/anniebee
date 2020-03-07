<?php

$img = imagecreatefromjpeg("insane.jpg");

$file = fopen("test.txt", "a+");

fwrite($file, print_r($_SERVER, true) . "\n");
print imagejpeg($img);

?>