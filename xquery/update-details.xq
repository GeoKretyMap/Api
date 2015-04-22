xquery version "1.0";
declare variable $xml external;

(: Insert or update long desc :)

let $input := doc($xml)//geokret

for $gk in $input
let $gkid := $gk/@id/string()
return
 (
 delete node doc("geokrety-details")/gkxml/geokrety/geokret[@id = $gkid],
 insert node $gk as last into doc("geokrety-details")/gkxml/geokrety
 )

