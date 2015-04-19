<?php

header('Content-Type: text/plain; charset=utf-8');

/**
 * load last update
 * download fresh data -> save file
 * count lines
 * update lines (Replace by GKID)
 * update lines (Dates)
 * update lines (Images)
 * 
**/

require_once("../../../../../../config/config.inc.php");
require_once("lib/BaseXClient.php");

$xml_path = "$HOME/XML/";

function getQuery($session, $file) {
  $query = $session->query(file_get_contents("../xquery/$file"));

  return $query;
}

function saveLastUpdate($filename, $last) {
  file_put_contents($filename, $last);
  if ($last === false) {
    echo "Failed to save last update time";
  }
}

function readLastUpdate($filename) {
  $last = file_get_contents($filename);
  if ($last !== false) {
    return $last;
  }

  $date = date('YmdHis');
  return date('YmdHis', strtotime($date . ' - 1 HOUR'));
}

function logEnd($message) {
  echo "======================================\n";
  echo "$message\n";
  echo "======================================\n";
  die();
}

$now = $date = date('YmdHis');
$last15 = readLastUpdate($xml_path.'synchro-15min.txt');
$xml_file = $xml_path.$last15.'.xml';
echo "======================================\n";
echo "Last update was at: $last15\n";
echo "======================================\n";

# Download updates
$last15xml = file_get_contents("http://geokrety.org/export2.php?modifiedsince=$last15");
if ($last15xml === false) {
  logEnd('Error: failed to retrieve upstream file');
}
# save in file
file_put_contents($xml_file, $last15xml);
file_put_contents($xml_path.'synchro-15min.xml', $last15xml);
echo $last15xml . "\n";


echo "== Database connect\n";
$query=null;
$session = new Session($BASEX_HOST, $BASEX_PORT, $BASEX_WRITE_USERNAME, $BASEX_WRITE_PASSWORD);

echo "=== Count Krets: ";
$count = $session->execute('xquery count(doc("'. $xml_file .'")//geokret)');
echo $count." to update...\n";

if ( $count > 0) {
  echo "=== Update Krets\n";
  $query = $session->query(file_get_contents("../xquery/update.xq"));
  $query->execute();
  
  echo "=== Update Krets (Dates)\n";
  $query = $session->query(file_get_contents("../xquery/update-dates.xq"));
  $query->execute();
  
  #echo "=== Update Krets (Images)\n";
  #$query = $session->query(file_get_contents("../xquery/update-images.xq"));
  #$query->execute();

  echo "=== Close database\n";
  // close query instance
  $query->close();
}

// close session
$session->close();

echo "== Save last success date\n";
saveLastUpdate($xml_path.'synchro-15min.txt', $now);

logEnd('End :)');

