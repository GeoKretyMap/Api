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
echo "Backup databases\n";
echo "======================================\n";

echo "== Database connect\n";
$session = new Session($BASEX_HOST, $BASEX_PORT, $BASEX_WRITE_USERNAME, $BASEX_WRITE_PASSWORD);

echo "=== Backup 'geokrety'\n";
echo $session->execute("create backup geokrety");

echo "=== Backup 'geokrety-details'\n";
echo $session->execute("create backup geokrety-details");

// close session
$session->close();

logEnd('End :)');

