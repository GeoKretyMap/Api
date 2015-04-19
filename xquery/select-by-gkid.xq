xquery version "1.0";

declare variable $gkid external;

let $result := if ($gkid castable as xs:string)
               then doc("geokrety")/gkxml/geokrety/geokret[@id=$gkid]
               else "<error>'gkid is not an string</error>"

return         
<geokrety>{$result}</geokrety>
