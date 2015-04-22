xquery version "1.0";
declare variable $xml external;

let $input := doc($xml)/gkxml/geokrety/geokret

for $b in $input
let $gk := $b/@id/string()
return
 (
 delete node doc("geokrety")/gkxml/geokrety/geokret[@id = $gk],
 insert node $b as last into doc("geokrety")/gkxml/geokrety
 )
