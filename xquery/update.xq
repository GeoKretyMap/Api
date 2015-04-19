xquery version "1.0";

let $input := doc("/home/gkmap-dev/XML/synchro-15min.xml")//geokret

for $b in $input
let $gk := $b/@id/string()
return
 (
 delete node doc("geokrety")//geokret[@id = $gk],
 insert node $b as last into doc("geokrety")//geokrety
 )
