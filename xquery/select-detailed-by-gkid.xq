xquery version "1.0";

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:cdata-section-elements "name description owner";

declare variable $gkid external;

let $result := if ($gkid castable as xs:string)
               then doc("geokrety-details")/gkxml/geokrety/geokret[@id=$gkid]
               else "<error/>"

return         
<geokrety>{$result}</geokrety>
