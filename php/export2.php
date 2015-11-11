<?php

require_once('../../../../../../config/config.inc.php');
require_once('lib/BaseXClient.php');

function getQuery($session, $file) {
  $query = $session->query(file_get_contents('../xquery/' . $file));

  if (isset($_GET['limit'])) {
    $query->bind('limit', $_GET['limit'], 'xs:integer');
  }
  return $query;
}

$detailed='';
if (isset($_GET['details'])) {
  $detailed='detailed-';
}

$json='';
if (isset($_GET['json'])) {
  $json='-json';
}

try {

  $query=null;
  $session = new Session($BASEX_HOST, $BASEX_PORT, $BASEX_USERNAME, $BASEX_PASSWORD);

  // parse gkid
  if (isset($_GET['gkid'])) {
    $query = getQuery($session, 'select-'.$detailed.'by-gkid.xq');
    $query->bind('gkid', $_GET['gkid'], 'xs:string');
  // parse waypoints or lat/lon
  } else if (isset($_GET['wpt']) && isset($_GET['lat']) && isset($_GET['lon'])) {
    $query = getQuery($session, 'select-'.$detailed.'by-wpt-or-coord-center.xq');
    $query->bind('wpt', $_GET['wpt'], 'xs:string');
    $query->bind('lat', round($_GET['lat'], 5), 'xs:float');
    $query->bind('lon', round($_GET['lon'], 5), 'xs:float');
  // parse waypoints
  } else if (isset($_GET['wpt'])) {
    $query = getQuery($session, 'select-'.$detailed.'by-wpt.xq');
    $query->bind('wpt', $_GET['wpt'], 'xs:string');
  // parse multiple waypoints
  } else if (isset($_GET['wpts'])) {
    $query = getQuery($session, 'select-by-wpts.xq');
    $query->bind('wpts', $_GET['wpts'], 'xs:string');
  // parse map space
  } else if (isset($_GET['latTL']) and isset($_GET['lonTL']) and isset($_GET['latBR']) and isset($_GET['lonBR'])) {
    $query = getQuery($session, 'select-by-coord-range'.$json.'.xq');
    if (isset($_GET['ghosts'])) {
      $query->bind('ghosts', 1, 'xs:integer');
    }
    if (isset($_GET['older'])) {
      $query->bind('older', 1, 'xs:integer');
    }
    if (isset($_GET['newer'])) {
      $query->bind('newer', 1, 'xs:integer');
    }
    if (isset($_GET['details'])) {
      $query->bind('details', 1, 'xs:integer');
    }
    if (isset($_GET['missing'])) {
      $query->bind('missing', 1, 'xs:integer');
    }
    $query->bind('latTL', round($_GET['latTL'], 5), 'xs:float');
    $query->bind('lonTL', round($_GET['lonTL'], 5), 'xs:float');
    $query->bind('latBR', round($_GET['latBR'], 5), 'xs:float');
    $query->bind('lonBR', round($_GET['lonBR'], 5), 'xs:float');
  // parse position
  } else if (isset($_GET['lat']) and isset($_GET['lon'])) {
    $query = getQuery($session, 'select-'.$detailed.'by-coord-center.xq');
    $query->bind('lat', round($_GET['lat'], 5), 'xs:float');
    $query->bind('lon', round($_GET['lon'], 5), 'xs:float');
  }

  if ($query !== null) {
    // return the datas
    //print $query->execute();

    $xml_string = '';
    if ($json) {
      header('Content-Type: application/json');
      $xml_string .= $query->execute();
    } else {
      header('Content-Type: application/xml; charset=utf-8');
      $xml_string .= '<?xml version="1.0" encoding="UTF-8" standalone="yes" ?>';
      $xml_string .= '<gkxml version="1.0" date="'.date('Y-m-d H:i:s').'">';
      $xml_string .= $query->execute();
      $xml_string .= '</gkxml>';
    }

    echo $xml_string;

    // close query instance
    $query->close();
  }

  // close session
  $session->close();

} catch (Exception $e) {
  echo $e->getMessage();
}
?>
