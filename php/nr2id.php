<?php

$gk_nr_url = 'https://geokrety.org/m/qr.php?nr=';

// Check if NR is set and alphanumeric
if (!isset($_GET['nr']) || !ctype_alnum($_GET['nr'])) {
  print 0;
  die();
}

// retrieve page from GK
$page = file_get_contents($gk_nr_url . urlencode($_GET['nr']));

// Search GK id
$matches = array();
if (preg_match('@<a href="\.\./konkret\.php\?id=(\d+)">View the GK details</a><br/>@', $page, $matches) === FALSE) {
  print 0;
  die();
}

// Did we found something?
if (!sizeof($matches)) {
  print 0;
  die();
}

// print the id
print ($matches[1]);
