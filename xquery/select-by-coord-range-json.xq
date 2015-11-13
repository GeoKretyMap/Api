xquery version "1.0";

import module namespace functx = 'http://www.functx.com';
declare namespace geokretymap = 'http://geokretymap.org';
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:cdata-section-elements "name description owner";


declare function geokretymap:age
  ( $date1 as xs:anyAtomicType ,
    $date2 as xs:anyAtomicType )  as xs:integer {

   days-from-duration($date1 - xs:date(string-join((substring($date2, 1, 4), substring($date2, 6, 2), substring($date2, 9, 2)), '-')))
 };

declare variable $latTL external;
declare variable $lonTL external;
declare variable $latBR external;
declare variable $lonBR external;
declare variable $limit external := 500;

declare variable $newer external := 0;
declare variable $older external := 0;
declare variable $nodate external := 0;
declare variable $ghosts external := 0;
declare variable $missing external := 0;
declare variable $details external := 0;
declare variable $daysFrom external := 0;
declare variable $daysTo external := 2;


let $year := year-from-date(current-date())
let $month := month-from-date(current-date())
let $day := day-from-date(current-date())
let $today := functx:date($year, $month, $day)

let $basedate := functx:add-months($today, -3)

let $dateFrom := $today - functx:dayTimeDuration($daysFrom, 0, 0, 0)
let $dateTo   := $today - functx:dayTimeDuration($daysTo  , 0, 0, 0)

let $input   := if ($details> 0)
                then doc("geokrety-details")/gkxml/geokrety/geokret
                else doc("geokrety")/gkxml/geokrety/geokret

let $filter1 := if ($nodate = 0 and $older = 0) then $input[              ($dateFrom >= @date and @date >= $dateTo)]
           else if ($nodate = 0 and $older > 0) then $input[               $dateFrom >= @date]
           else if ($nodate > 0 and $older = 0) then $input[not(@date) or ($dateFrom >= @date and @date >= $dateTo)]
           else if ($nodate > 0 and $older > 0) then $input[not(@date) or  $dateFrom >= @date]
           else $input

let $filter2 := if ($ghosts > 0)
                then $filter1[not(@state="0" or @state="3")]
                else $filter1[    @state="0" or @state="3" ]

let $filter3 := if ($missing > 0)
                then $filter2[@missing="1"]
                else $filter2

let $result := if ($latTL castable as xs:float and $lonTL castable as xs:float
               and $latBR castable as xs:float and $lonBR castable as xs:float)
               then $filter3[xs:float(@lat) <= xs:float($latTL) and xs:float(@lon) <= xs:float($lonTL) and xs:float(@lat) >= xs:float($latBR) and xs:float(@lon) >= xs:float($lonBR)]
               else "<error>'latTL/lonTL/latBR/lonBR' has an invalid type</error>"
(:
{
   "type":"FeatureCollection",
   "features":[
      {
         "geometry":{
            "type":"Point",
            "coordinates":[
               6.57052,
               43.73088
            ]
         },
         "type":"Feature",
         "properties":{
            "popupContent":"Trojan",
            "age":"newer"
         }
      },
   ]
}
<![CDATA[<br /><img src=\"http://geokretymap.org/gkimage/]]>"{string($a/@image)}<![CDATA[" />]]>

days-from-duration($today - xs:dateTime($a/@date))
:)

return         
json:serialize(
<json type="object">
  <type>FeatureCollection</type>
  <features type="array">
{for $a in subsequence($result, 1, $limit)
  return
    <_ type="object">
      <geometry type="object">
        <type>Point</type>
        <coordinates type="array">
          <_ type="number">{$a/@lon/number()}</_>
          <_ type="number">{$a/@lat/number()}</_>
        </coordinates>
      </geometry>
      <type>Feature</type>
      <properties type="object">
        <popupContent>{
'<h1' || (if ($a/@missing = '1') then ' class="missing"' else '') || '><a href="http://geokretymap.org/' || $a/@id || '" target="_blank">' || $a/data() || '</a></h1>' ||
string(if ($a/@waypoint) then (if ($a/not(@state="0" or @state="3")) then 'Last seen in' else 'In') || ' <a href="http://geokrety.org/go2geo/index.php?wpt=' || $a/@waypoint || '" target="_blank">' || $a/@waypoint || '</a><br />' else '') ||
string(if ($a/@date) then 'Last move: ' || $a/@date || '<br />' else '') ||
'Travelled: ' || $a/@dist || ' km<br />' ||
string(if ($a/@image) then '<img src="https://geokretymap.org/gkimage/' || $a/@image || '" width="100" />' else '')
}</popupContent>
        <age>{
string(if ($a/@date) then geokretymap:age($today, $a/@date) else '99999')
}</age>
      </properties>
    </_>
}
  </features>
</json>
)
