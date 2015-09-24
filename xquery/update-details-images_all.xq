xquery version "1.0";
declare variable $xml external;
declare variable $gkid external;

(: Update geokrety-details/image from known geokrety/image  :)

let $input := doc("geokrety")//geokret/@id/string()

for $gkid in $input
let $image := doc("geokrety")//geokret[@id=$gkid]/@image/string()
let $gk := doc("geokrety-details")/gkxml/geokrety/geokret[@id=$gkid]
return
 if (exists($gk) and count($gk) = 1 and count($gk/image) = 1) then
   replace value of node $gk/image with $image
 else if (exists($gk) and count($gk) = 1 and count($gk/image) = 0) then
   insert node <image>{ $image }</image> into $gk
 else
   ()
