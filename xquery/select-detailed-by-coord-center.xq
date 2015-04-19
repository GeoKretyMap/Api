xquery version "1.0";

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:cdata-section-elements "name description owner";

declare variable $lat external;
declare variable $lon external;
declare variable $limit external := 500;

let $result := if ($lat castable as xs:float and $lon castable as xs:float)
               then doc("geokrety-details")/gkxml/geokrety/geokret[(state="0" or state="3")
                   and (xs:float(position/@latitude) eq $lat and xs:float(position/@longitude) eq $lon)]
               else "<error>'lat' and/or 'lon' has an invalid type</error>"

return         
<geokrety>{for $a in subsequence($result, 1, $limit) return $a}</geokrety>
