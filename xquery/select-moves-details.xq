xquery version "1.0";

declare variable $lat external;
declare variable $lon external;
declare variable $latTL external;
declare variable $lonTL external;
declare variable $latBR external;
declare variable $lonBR external;
declare variable $wpt external;
declare variable $gkid external;
declare variable $limit external;

let $input := doc("geokrety-moves")/gkxml/moves

let $result := if ($gkid castable as xs:integer) then $input/geokret[@id=$gkid]/..
               else ()

let $local_limit := if ($limit castable as xs:integer) then $limit
                    else 500

return 
<history>
{
if (count($result) > 0) then for $a in subsequence($result, 1, $local_limit) return $a
else ()
}
</history>
