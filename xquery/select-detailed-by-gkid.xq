xquery version "1.0";

declare variable $lat external;
declare variable $lon external;
declare variable $latTL external;
declare variable $lonTL external;
declare variable $latBR external;
declare variable $lonBR external;
declare variable $wpt external;
declare variable $wpts external;
declare variable $gkid external;
declare variable $limit external;

let $input := doc("geokrety")//geokret

let $result :=      if ($gkid castable as xs:integer) then $input[@id=$gkid]
               else if ($wpt castable as xs:string and $lat castable as xs:float and $lon castable as xs:float) then $input[(@state=0 or @state=3) and (starts-with(@waypoint, $wpt) or (xs:float(@lat) eq $lat and xs:float(@lon) eq $lon))]
               else if ($wpt castable as xs:string) then $input[(@state=0 or @state=3) and starts-with(@waypoint, $wpt)]
               else if ($wpts castable as xs:string) then for $x in subsequence(tokenize($wpts, ','),1, 20) return $input[(@state=0 or @state=3) and (@waypoint=$x)]
               else if ($latTL castable as xs:float and $lonTL castable as xs:float
                    and $latBR castable as xs:float and $lonBR castable as xs:float) then
                  $input[(@state=0 or @state=3) and xs:float(@lat) <= $latTL and xs:float(@lon) <= $lonTL and xs:float(@lat) >= $latBR and xs:float(@lon) >= $lonBR]
               else if ($lat castable as xs:float and $lon castable as xs:float) then
                  $input[(@state=0 or @state=3) and xs:float(@lat) eq $lat and xs:float(@lon) eq $lon]
               else "<error/>"

let $local_limit := if ($limit castable as xs:integer) then $limit
                    else 500

return 
<geokrety>
{for $a in subsequence($result, 1, $local_limit)
return $a}
</geokrety>
