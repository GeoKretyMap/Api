xquery version "1.0";
declare variable $xml external;
declare variable $gkid external;

(:  Add images to details from 30min imports :)
(: need open "geokrety-details"; :)

let $input := doc($xml)//geokret/@id/string()

for $gkid in $input
let $image := doc($xml)//geokret[@id=$gkid]/image/string()
let $gk := doc("geokrety-details")/gkxml/geokrety/geokret[@id=$gkid]
return
 if (exists($gk) and count($gk/image) = 1) then
   replace value of node $gk/image with $image
 else if (exists($gk) and count($gk/image) = 0) then
   insert node <image>{ $image }</image> into $gk
 else
   ()
