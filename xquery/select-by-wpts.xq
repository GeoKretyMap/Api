xquery version "1.0";

declare variable $wpts external;

let $result := if ($wpts castable as xs:string)
               then for $x in subsequence(tokenize($wpts, ','),1, 20) return doc("geokrety")/gkxml/geokrety/geokret[(@state="0" or @state="3") and @waypoint=$x]
               else "<error>'wpts' has an invalid type</error>"

return         
<geokrety>{$result}</geokrety>
