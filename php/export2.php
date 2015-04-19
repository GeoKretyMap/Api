<?php

require_once("../../../../../../config/config.inc.php");
require_once("lib/BaseXClient.php");

header('Content-Type: application/xml; charset=utf-8');
echo '<?xml version="1.0" encoding="UTF-8" standalone="yes" ?>
<gkxml version="1.0" date="'.date("Y-m-d H:i:s").'">';

function getQuery($session, $file) {
  $query = $session->query(file_get_contents("../xquery/$file"));

  if (isset($_GET['limit'])) {
    $query->bind('limit', $_GET['limit'], "xs:integer");
  }
  return $query;
}

$detailed="";
if (isset($_GET['details'])) {
  $detailed="detailed-";
}

try {

  $query=null;
  $session = new Session($BASEX_HOST, $BASEX_PORT, $BASEX_USERNAME, $BASEX_PASSWORD);

  // parse gkid
  if (isset($_GET['gkid'])) {
    $query = getQuery($session, 'select-'.$detailed.'by-gkid.xq');
    $query->bind('gkid', $_GET['gkid'], "xs:integer");
  // parse waypoints or lat/lon
  } else if (isset($_GET['wpt']) && isset($_GET['lat']) && isset($_GET['lon'])) {
    $query = getQuery($session, 'select-'.$detailed.'by-wpt-or-coord-center.xq');
    $query->bind('wpt', $_GET['wpt'], "xs:string");
    $query->bind('lat', round($_GET['lat'], 5), "xs:float");
    $query->bind('lon', round($_GET['lon'], 5), "xs:float");
  // parse waypoints
  } else if (isset($_GET['wpt'])) {
    $query = getQuery($session, 'select-'.$detailed.'by-wpt.xq');
    $query->bind('wpt', $_GET['wpt'], "xs:string");
  // parse multiple waypoints
  } else if (isset($_GET['wpts'])) {
    $query = getQuery($session, 'select-by-wpts.xq');
    $query->bind('wpts', $_GET['wpts'], "xs:string");
  // parse map space
  } else if (isset($_GET['latTL']) and isset($_GET['lonTL']) and isset($_GET['latBR']) and isset($_GET['lonBR'])) {
    $query = null;
    if (isset($_GET['ghosts'])) {
      $query = getQuery($session, "select-by-coord-range-extended.xq");
      $query->bind('ghosts', 1, "xs:integer");
    } else if (isset($_GET['older'])) {
      $query = getQuery($session, "select-by-coord-range-extended.xq");
      $query->bind('older', 1, "xs:integer");
    } else if (isset($_GET['newer'])) {
      $query = getQuery($session, "select-by-coord-range-extended.xq");
      $query->bind('newer', 1, "xs:integer");
    } else {
      $query = getQuery($session, "select-'.$detailed.'by-coord-range.xq");
    }
    $query->bind('latTL', $_GET['latTL'], "xs:float");
    $query->bind('lonTL', $_GET['lonTL'], "xs:float");
    $query->bind('latBR', $_GET['latBR'], "xs:float");
    $query->bind('lonBR', $_GET['lonBR'], "xs:float");
  // parse position
  } else if (isset($_GET['lat']) and isset($_GET['lon'])) {
    $query = getQuery($session, 'select-'.$detailed.'by-coord-center.xq');
    $query->bind('lat', round($_GET['lat'], 5), "xs:float");
    $query->bind('lon', round($_GET['lon'], 5), "xs:float");
  }

  // return the datas
  print $query->execute();

  // close query instance
  $query->close();

  // close session
  $session->close();

  echo '</gkxml>';
} catch (Exception $e) {
  echo '<error>',  $e->getMessage(), "</error>";
  echo '</gkxml>';
}
?>
