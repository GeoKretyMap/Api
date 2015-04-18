xquery version "1.0";

declare variable $latTL external;
declare variable $lonTL external;
declare variable $latBR external;
declare variable $lonBR external;
declare variable $limit external := 500;

let $result := if ($latTL castable as xs:float and $lonTL castable as xs:float
               and $latBR castable as xs:float and $lonBR castable as xs:float)
               then doc("geokrety")/gkxml/geokrety/geokret[(@state=0 or @state=3) and (xs:float(@lat) <= $latTL and xs:float(@lon) <= $lonTL and xs:float(@lat) >= $latBR and xs:float(@lon) >= $lonBR)]
               else "<error>'latTL/lonTL/latBR/lonBR' has an invalid type</error>"

return         
<geokrety>{for $a in subsequence($result, 1, $limit) return $a}</geokrety>
