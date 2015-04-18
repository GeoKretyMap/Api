xquery version "1.0";

declare variable $lat external;
declare variable $lon external;
declare variable $limit external := 500;

let $result := if ($lat castable as xs:float and $lon castable as xs:float)
               then doc("geokrety")/gkxml/geokrety/geokret[(@state=0 or @state=3) and (xs:float(@lat) eq $lat and xs:float(@lon) eq $lon)]
               else "<error>'lat' and/or 'lon' has an invalid type</error>"

return         
<geokrety>{for $a in subsequence($result, 1, $limit) return $a}</geokrety>
