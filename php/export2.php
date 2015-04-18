<?php

require_once("config/config.inc.php");
require_once("lib/BaseXClient.php");

header('Content-Type: application/xml; charset=utf-8');
echo '<?xml version="1.0" encoding="UTF-8" standalone="yes" ?>
<gkxml version="1.0" date="'.date("Y-m-d H:i:s").'">';

try {
  // create session
  $session = new Session($BASEX_SERVER, $BASEX_PORT, $BASEX_USERNAME, $BASEX_PASSWORD);

  $file = "xquery/select-moves.xq";
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
  // parse waypoints or lat/lon
  } else if (isset($_GET['wpt']) && isset($_GET['lat']) && isset($_GET['lon'])) {
    $query->bind('wpt', $_GET['wpt'], "xs:string");
    $query->bind('lat', round($_GET['lat'], 5), "xs:float");
    $query->bind('lon', round($_GET['lon'], 5), "xs:float");
    $result = $query->execute();
    print $result;
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
  // parse position
  } else if (isset($_GET['lat']) and isset($_GET['lon'])) {
    $query->bind('lat', round($_GET['lat'], 5), "xs:float");
    $query->bind('lon', round($_GET['lon'], 5), "xs:float");
    print $query->execute();
  } else if (isset($_GET['wpts'])) {
    $query->bind('wpts', $_GET['wpts'], "xs:string");
    $result = $query->execute();
    print $result;
  }

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
