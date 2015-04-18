
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:cdata-section-elements "name description owner";

declare variable $lat external;
declare variable $lon external;
declare variable $latTL external;
declare variable $lonTL external;
declare variable $latBR external;
declare variable $lonBR external;
declare variable $wpt external;
declare variable $gkid external;
declare variable $limit external;

let $input := doc("geokrety-details")/gkxml/geokret

let $result := if ($gkid castable as xs:integer) then $input[@id=$gkid]
               else if ($wpt castable as xs:string) then $input[starts-with(/waypoint, $wpt)]
               else if ($latTL castable as xs:float and $lonTL castable as xs:float
                    and $latBR castable as xs:float and $lonBR castable as xs:float) then
                  $input[xs:float(/position/@latitude) <= $latTL and xs:float(/position/@longitude) <= $lonTL and xs:float(/position/@latitude) >= $latBR and xs:float(/position/@longitude) >= $lonBR]
               else if ($lat castable as xs:float and $lon castable as xs:float) then
                  $input[xs:float(@lat) eq $lat and xs:float(@lon) eq $lon]
               else ()

let $local_limit := if ($limit castable as xs:integer) then $limit
                    else 500

return 
<geokrety>
{
if (count($result) > 0) then for $a in subsequence($result, 1, $local_limit) return $a
else if ($gkid castable as xs:integer) then for $a in subsequence(doc("geokrety")//geokret[@id=$gkid], 1, $local_limit) return $a
else ()
}
</geokrety>
