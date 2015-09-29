xquery version "1.0";

declare namespace functx = "http://www.functx.com";
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:cdata-section-elements "name description owner";


declare function functx:add-months
  ( $date as xs:anyAtomicType? ,
    $months as xs:integer )  as xs:date? {

   xs:date($date) + functx:yearMonthDuration(0,$months)
 };
declare function functx:yearMonthDuration
  ( $years as xs:decimal? ,
    $months as xs:integer? )  as xs:yearMonthDuration {

    (xs:yearMonthDuration('P1M') * functx:if-empty($months,0)) +
    (xs:yearMonthDuration('P1Y') * functx:if-empty($years,0))
 };
declare function functx:if-empty
  ( $arg as item()? ,
    $value as item()* )  as item()* {

  if (string($arg) != '')
  then data($arg)
  else $value
 };
declare function functx:repeat-string
  ( $stringToRepeat as xs:string? ,
    $count as xs:integer )  as xs:string {

   string-join((for $i in 1 to $count return $stringToRepeat),
                        '')
 };
declare function functx:pad-integer-to-length
  ( $integerToPad as xs:anyAtomicType? ,
    $length as xs:integer )  as xs:string {

   if ($length < string-length(string($integerToPad)))
   then error(xs:QName('functx:Integer_Longer_Than_Length'))
   else concat
         (functx:repeat-string(
            '0',$length - string-length(string($integerToPad))),
          string($integerToPad))
 };
declare function functx:date
  ( $year as xs:anyAtomicType ,
    $month as xs:anyAtomicType ,
    $day as xs:anyAtomicType )  as xs:date {

   xs:date(
     concat(
       functx:pad-integer-to-length(xs:integer($year),4),'-',
       functx:pad-integer-to-length(xs:integer($month),2),'-',
       functx:pad-integer-to-length(xs:integer($day),2)))
 };

declare variable $latTL external;
declare variable $lonTL external;
declare variable $latBR external;
declare variable $lonBR external;
declare variable $limit external := 500;
declare variable $ghosts external := 0;
declare variable $older external := 0;
declare variable $newer external := 0;
declare variable $details external := 0;


let $today := current-date()
let $year := year-from-date($today)
let $month := month-from-date($today)
let $day := day-from-date($today)
let $date := functx:date($year, $month, $day)
let $basedate := functx:add-months($date, -3)

let $input   := if ($details> 0)
                then doc("geokrety-details")/gkxml/geokrety/geokret
                else doc("geokrety")/gkxml/geokrety/geokret

let $filter1 := if ($older  > 0 and $newer = 0) then $input[@date <  $basedate]
           else if ($newer  > 0 and $older = 0) then $input[@date >= $basedate]
           else $input

let $filter2 := if ($ghosts > 0) then $filter1[not(@state="0" or @state="3")]
           else                       $filter1[   (@state="0" or @state="3")]

let $result := if ($latTL castable as xs:float and $lonTL castable as xs:float
               and $latBR castable as xs:float and $lonBR castable as xs:float)
               then $filter2[xs:float(@lat) <= xs:float($latTL) and xs:float(@lon) <= xs:float($lonTL) and xs:float(@lat) >= xs:float($latBR) and xs:float(@lon) >= xs:float($lonBR)]
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
            "popupContent":"Trojan"
         }
      },
   ]
}
<![CDATA[<br /><img src=\"http://geokretymap.org/gkimage/]]>"{string($a/@image)}<![CDATA[" />]]>
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
'<h1><a href="http://geokretymap.org/' || $a/@id || '" target="_blank">' || $a/data() || '</a></h1>' ||
string(if ($a/@waypoint) then 'In <a href="http://geokrety.org/go2geo/index.php?wpt=' || $a/@waypoint || '" target="_blank">' || $a/@waypoint || '</a><br />' else '') ||
string(if ($a/@date) then 'Last move: ' || $a/@date || '<br />' else '') ||
'Travelled: ' || $a/@dist || ' km<br />' ||
string(if ($a/@image) then '<img src="http://geokretymap.org/gkimage/' || $a/@image || '" width="100" />' else '')
}</popupContent>
      </properties>
    </_>
}
  </features>
</json>
)
