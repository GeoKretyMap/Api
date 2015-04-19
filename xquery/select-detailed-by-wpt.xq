xquery version "1.0";

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:cdata-section-elements "name description owner";

declare variable $wpt external;

let $result := if ($wpt castable as xs:string)
               then doc("geokrety-details")/gkxml/geokrety/geokret[(state="0" or state="3") and waypoints/waypoint=$wpt]
               else "<error>'wpt' has an invalid type</error>"

return         
<geokrety>{$result}</geokrety>
