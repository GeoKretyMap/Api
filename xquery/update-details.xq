xquery version "1.0";

(: Insert or update long desc :)

let $input := doc("/home/gkmap-dev/XML/synchro-24hour.xml")//geokret

for $gk in $input
let $gkid := $gk/@id/string()
return
 (
 delete node doc("geokrety-details")/gkxml/geokret[@id = $gkid],
 insert node $gk as last into doc("geokrety-details")/gkxml
 )

