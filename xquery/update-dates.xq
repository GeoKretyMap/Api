xquery version "1.0";

declare namespace functx = "http://www.functx.com";

declare function functx:repeat-string
  ( $stringToRepeat as xs:string? ,
    $count as xs:integer )  as xs:string {

   string-join((for $i in 1 to $count return $stringToRepeat), '')
 };

declare function functx:pad-integer-to-length
  ( $integerToPad as xs:anyAtomicType? ,
    $length as xs:integer )  as xs:string {

   if ($length < string-length(string($integerToPad)))
   then error(xs:QName('functx:Integer_Longer_Than_Length'))
   else concat (functx:repeat-string( '0',$length - string-length(string($integerToPad))), string($integerToPad))
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

let $today := current-date()
let $year := year-from-date($today)
let $month := month-from-date($today)
let $day := day-from-date($today)

let $input := doc("/home/gkmap-dev/XML/synchro-15min.xml")//geokret/@id/string()
let $date := functx:date($year, $month, $day)


for $gkid in $input
return
 if (exists(doc("geokrety")/gkxml/geokrety/geokret[@id=$gkid]/@date)) then
   replace value of node doc("geokrety")/gkxml/geokrety/geokret[@id=$gkid]/@date with $date
 else
   insert node (attribute date { $date }) into doc("geokrety")/gkxml/geokrety/geokret[@id=$gkid]
