<?php

$gkid=0;

if (isset($_GET['gk'])) {
   $gk = $_GET['gk'];
   $gkid = hexdec($gk);
   echo '<h1>GK'.strtoupper($gk).'</h1>';
} else if (isset($_GET['gkid'])) {
   $gkid = $_GET['gkid'];
}

if ($gkid > 0) {
   $link='https://geokrety.org/konkret.php?id='.$gkid;
   echo '<h2>'.$gkid.'</h2>';
   echo '<p><a href="'.$link.'">View on GeoKrety.org</a></p>';
   header("Location: $link");
} else {
   echo "Sorry, no such id.";
}

?>
