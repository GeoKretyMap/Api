xquery version "1.0";

declare variable $wpt external;
declare variable $lat external;
declare variable $lon external;
declare variable $limit external := 500;

let $result := if ($wpt castable as xs:string and $lat castable as xs:float and $lon castable as xs:float)
               then doc("geokrety")/gkxml/geokrety/geokret[(@state=0 or @state=3) and (@waypoint=$wpt or (xs:float(@lat) eq $lat and xs:float(@lon) eq $lon))]
               else "<error>'wpt' and/or 'lat' and/or 'lon' has an invalid type</error>"

return         
<geokrety>{for $a in subsequence($result, 1, $limit) return $a}</geokrety>
