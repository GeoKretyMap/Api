xquery version "1.0";
declare variable $xml external;

(:  Add missing GK to details from downloaded exports :)
(: need open "geokrety-details"; :)

let $input := doc($xml)//geokret

for $gk in $input
  let $gkid := $gk/@id/string()
  let $gknew := doc("geokrety")/gkxml/geokrety/geokret[@id=$gkid]
  
  return if (not(exists($gknew))) then insert node $gk into doc("geokrety")/gkxml/geokrety
         else ()

