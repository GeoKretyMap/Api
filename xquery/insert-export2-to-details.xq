xquery version "1.0";

(:  Add missing GK to details from geokrety list :)

let $input := doc('geokrety')/gkxml/geokrety/geokret

for $gk in $input
let $gkid := $gk/@id/string()
let $gkdetail := doc("geokrety-details")/gkxml/geokrety/geokret[@id=$gkid]

return
 if (not(exists($gkdetail))) then
   insert node $gk into doc("geokrety-details")/gkxml/geokrety
 else
   ()

