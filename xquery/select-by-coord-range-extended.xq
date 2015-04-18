xquery version "1.0";

declare namespace functx = "http://www.functx.com";
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
declare variable $gosts external := 0;
declare variable $older external := 0;
declare variable $newer external := 0;


let $today := current-date()                 
let $year := year-from-date($today)          
let $month := month-from-date($today)        
let $day := day-from-date($today)            
let $date := functx:date($year, $month, $day)
let $basedate := functx:add-months($date, -3)

let $input := doc("geokrety")/geokrety/geokret[(@state=0 or @state=3)];
let $input :=   if ($gosts > 0) then [not(@state=0 or @state=3)];
                                else [   (@state=0 or @state=3)];
let $input :=      if ($older > 0) then $input[@date <  $basedate]
              else if ($newer > 0) then $input[@date >= $basedate]

let $result := if ($latTL castable as xs:float and $lonTL castable as xs:float
               and $latBR castable as xs:float and $lonBR castable as xs:float)
               then $input[number(@lat) <= $latTL and number(@lon) <= $lonTL and number(@lat) >= $latBR and number(@lon) >= $lonBR]
               else "<error>'latTL/lonTL/latBR/lonBR' has an invalid type</error>"

return         
<geokrety>{for $a in subsequence($result, 1, $limit) return $a}</geokrety>
