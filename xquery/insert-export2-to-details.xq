xquery version "1.0";
declare variable $xml external;

(:  Add missing GK to details from downloaded exports :)
(: need open "geokrety-details"; :)

let $input := doc($xml)//geokret

for $gk in $input
let $gkid := $gk/@id/string()
let $gkdetail := doc("geokrety-details")/gkxml/geokret[@id=$gkid]

return
 if (not(exists($gkdetail))) then
   insert node $gk into doc("geokrety-details")/gkxml
 else
   ()

