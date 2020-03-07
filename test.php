<?php

$img = imagecreatefromjpeg("artist1.jpg");

$file = fopen("test.txt", "a+");

fwrite($file, print_r($_SERVER, true) . "\n");
print imagejpeg($img);

?>