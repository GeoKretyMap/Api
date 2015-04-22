xquery version "1.0";

(:  Add missing GK to details from downloaded exports :)
(: need open "geokrety-details"; :)

let $input := doc('/home/kumy/export2-full.xml')/gkxml/geokrety/geokret

for $gk in $input
  let $gkid := $gk/@id/string()
  let $gknew := doc("geokrety")/gkxml/geokrety/geokret[@id=$gkid]
  
  return if (not(exists($gknew))) then insert node $gk as last into doc("geokrety")/gkxml/geokrety
         else ()

