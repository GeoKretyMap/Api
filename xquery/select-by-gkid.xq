xquery version "1.0";

declare variable $gkid external;

let $result := if ($gkid castable as xs:integer)
               then doc("geokrety")/gkxml/geokrety/geokret[@id=$gkid]
               else "<error>'gkid is not an integer</error>"

return         
<geokrety>{$result}</geokrety>
