<?php

header('Content-Type: text/plain; charset=utf-8');

/**
 *  Backup databases
**/

require_once("../../../../../../config/config.inc.php");
require_once("lib/BaseXClient.php");

$xml_path = "$HOME/XML/";

function logEnd($message) {
  echo "======================================\n";
  echo "$message\n";
  echo "======================================\n";
  die();
}

echo "======================================\n";
echo "Backup databases\n";
echo "======================================\n";

echo "== Download latest 'export2' (Full)\n";
$lastxml = bzdecompress(file_get_contents('http://geokrety.org/rzeczy/xml/export2-full.xml.bz2'));
if ($lastxml === false) {
  logEnd('Error: failed to retrieve upstream file');
}
echo "== Save 'export2'\n";
file_put_contents($xml_path.'synchro-export2-full.xml', $lastxml);

echo "== Database connect\n";
$session = new Session($BASEX_HOST, $BASEX_PORT, $BASEX_WRITE_USERNAME, $BASEX_WRITE_PASSWORD);

echo "=== Insert into 'geokrety'\n";
$query = $session->query(file_get_contents("../xquery/insert-export2.xq"));
$query->bind('xml', $xml_path.'synchro-export2-full.xml', "xs:string");
$query->execute();

echo "=== Insert into 'geokrety-details'\n";
$query = $session->query(file_get_contents("../xquery/insert-export2-to-details.xq"));
$query->bind('xml', $xml_path.'synchro-export2-full.xml', "xs:string");
$query->execute();

echo "== Database close\n";
$session->close();

logEnd('End :)');

