<?php

require_once("config/config.inc.php");
require_once("lib/BaseXClient.php");

header('Content-Type: application/xml; charset=utf-8');
echo '<?xml version="1.0" encoding="UTF-8" standalone="yes" ?>
<gkxml version="1.0" date="'.date("Y-m-d H:i:s").'">';

try {
  // create session
  $session = new Session($BASEX_SERVER, $BASEX_PORT, $BASEX_USERNAME, $BASEX_PASSWORD);

  $file = "xquery/select-geokrety-details.xq";
  if (isset($_GET['older'])) {
    $file = "xquery/select-moves-older.xq";
  } else if (isset($_GET['newer'])) {
    $file = "xquery/select-moves-newer.xq";
  }

  $query = $session->query(file_get_contents($file));
  if (isset($_GET['limit'])) {
    $query->bind('limit', $_GET['limit'], "xs:integer");
  }

  // parse gkid
  if (isset($_GET['gkid'])) {
    $query->bind('gkid', $_GET['gkid'], "xs:integer");
    $result = $query->execute();
    print $result;
    //$queryHist = $session->query(file_get_contents('xquery/select-moves-details.xq'));
    //$queryHist->bind('gkid', $_GET['gkid'], "xs:integer");
    //$result = $queryHist->execute();
    //print $result;
  // parse waypoints
  } else if (isset($_GET['wpt'])) {
    $query->bind('wpt', $_GET['wpt'], "xs:string");
    $result = $query->execute();
    print $result;
  // parse map space
  } else if (isset($_GET['latTL']) and isset($_GET['lonTL']) and isset($_GET['latBR']) and isset($_GET['lonBR'])) {
    $query->bind('latTL', $_GET['latTL'], "xs:float");
    $query->bind('lonTL', $_GET['lonTL'], "xs:float");
    $query->bind('latBR', $_GET['latBR'], "xs:float");
    $query->bind('lonBR', $_GET['lonBR'], "xs:float");
    print $query->execute();
  }

  // close query instance
  $query->close();

  // close session
  $session->close();

} catch (Exception $e) {}
echo '</gkxml>';
?>
