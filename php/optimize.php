<?php

header('Content-Type: text/plain; charset=utf-8');

/**
 *  Backup databases
**/

require_once("../../../../../../config/config.inc.php");
require_once("lib/BaseXClient.php");

function logEnd($message) {
  echo "======================================\n";
  echo "$message\n";
  echo "======================================\n";
  die();
}

echo "======================================\n";
echo "Optimizing database\n";
echo "======================================\n";

echo "== Database connect\n";
$session = new Session($BASEX_HOST, $BASEX_PORT, $BASEX_WRITE_USERNAME, $BASEX_WRITE_PASSWORD);

echo "=== Optimize 'geokrety'\n";
echo "==== open\n";
echo $session->execute("open geokrety");
echo "==== optimize\n";
echo $session->execute("optimize all");

echo "=== Optimize 'geokrety-details'\n";
echo "==== open\n";
echo $session->execute("open geokrety-details");
echo "==== optimize\n";
echo $session->execute("optimize all");

// close session
$session->close();

logEnd('End :)');

