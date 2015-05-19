xquery version "1.0";
(: declare variable $xml external; :)

(:  Add missing status to simple api from 24h imports :)
(: need open "geokrety-details"/"geokrety"; :)

(: let $input := doc($xml)//geokret/@id/string() :)
let $input := doc("geokrety-details")//geokret[missing=1]

for $geokret in $input
let $gkid := $geokret/@id/string()
let $gk := doc("geokrety")/gkxml/geokrety/geokret[@id=$gkid]
return
  if (exists($gk) and count($gk) = 1) then
    if (exists($gk/@missing)) then
      replace value of node $gk/@missing with "1"
    else
      insert node (attribute missing { "1" }) into $gk
  else
    ()

