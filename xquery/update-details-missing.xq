xquery version "1.0";
declare variable $xml external;

(:  Add missing status to simple api from 24h imports :)
(: need open "geokrety-details"/"geokrety"; :)

let $input := doc($xml)//geokret/@id/string()

for $geokret in $input
let $gkid := $geokret/@id/string()
let $missing := $geokret/missing
let $gk := doc("geokrety")/gkxml/geokrety/geokret[@id=$gkid]
return
  if (exists($gk) and count($gk) = 1) then
    if (exists($missing)) then
      if (exists($gk/@missing)) then
        replace value of node $gk/@missing with $missing/string()
      else
        insert node (attribute missing { $missing/string() }) into $gk
    else
      if (exists($gk/@missing)) then
        delete nodes $gk/@missing
      else
        ()
  else
    ()

