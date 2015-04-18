xquery version "1.0";

declare variable $gkid external;

let $result := if ($gkid castable as xs:integer)
               then doc("geokrety")/gkxml/geokret[@id=$gkid]
               else "<error/>"

return         
<geokrety>{$result}</geokrety>
