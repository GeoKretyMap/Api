xquery version "1.0";

declare variable $wpt external;

let $result := if ($wpt castable as xs:string)
               then doc("geokrety")/gkxml/geokret[(@state=0 or @state=3) and @waypoint=$wpt]
               else "<error>'wpt' has an invalid type</error>"

return         
<geokrety>{$result}</geokrety>
