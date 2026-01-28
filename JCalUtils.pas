unit JCalUtils;

interface

uses  DHPRecord,
      CodeSiteLogging;

function AddHebDates(HDate1, HDate2: TDHP; RoundToWeek: Boolean): TDHP;
function MultHebDate(HDate1: TDHP; Factor: Integer; RoundToWeek: Boolean): TDHP;
//function MoladToStr(HYear, HMonth: Integer): string;
function CDoW(DayOfWeek: Integer): string;
//function SubBaseTekufa(HDate: TDHP; RoundToWeek: Boolean): TDHP;

implementation

function AddHebDates(HDate1, HDate2: TDHP; RoundToWeek: Boolean): TDHP;
var
  hc,dc:Integer;
begin
  {$IFDEF CS2}CodeSite.EnterMethod( 'AddHebDates' );{$ENDIF}
  CodeSite.Send('Day1:', HDate1.Day);
  CodeSite.Send('Hour1:', HDate1.Hour);
  CodeSite.Send('Part1:', HDate1.Part);

  CodeSite.Send('Day2:', HDate2.Day);
  CodeSite.Send('Hour2:', HDate2.Hour);
  CodeSite.Send('Part2:', HDate2.Part);

  result.Part:=HDate1.Part+HDate2.Part;
  result.Hour:=HDate1.Hour+HDate2.Hour;
  result.Day:=HDate1.Day+HDate2.Day;
  hc:=result.Part div 1080;
  result.Part:=result.Part mod 1080;

  dc:=(result.Hour+hc) div 24;
  result.Hour:=(result.Hour+hc) mod 24;

  result.Day:=result.Day+dc;

  CodeSite.Send('result:', result.Day);
  CodeSite.Send('result:', result.Hour);
  CodeSite.Send('result:', result.Part);

  if RoundToWeek then
     result.Day:=result.Day Mod 7;
  {$IFDEF CS2}CodeSite.ExitMethod( 'AddHebDates' );{$ENDIF}
end;

function MultHebDate(HDate1: TDHP; Factor: Integer; RoundToWeek: Boolean): TDHP;
var
  temp, hc: Integer;
begin
  {$IFDEF CS2}CodeSite.EnterMethod( 'MultHebDate' );{$ENDIF}
  temp:=HDate1.Part*Factor;
  result.Part:=temp mod 1080;
  hc:=temp div 1080;
  temp:=(HDate1.Hour*Factor)+hc;
  result.Hour:=temp mod 24;
  result.Day:=Factor*HDate1.Day+(temp div 24);
  if RoundToWeek then
    result.Day:=result.Day mod 7;
  {$IFDEF CS2}CodeSite.ExitMethod( 'MultHebDate' );{$ENDIF}
end;

//function MoladToStr(HYear, HMonth: Integer): string;
//var
//  Molad: TDHP;
//  tempStr: string;
//  HebYear: THebYear;
//begin
//  {$IFDEF CS2}CodeSite.EnterMethod( 'MoladToStr' );{$ENDIF}
//  HebYear:=THebYear.Create;
//  HebYear.HYear:=HYear;
//  HebYear.HMonth:=HMonth;
//  HebYear.Molad:=HebYear.CalcMolad;
//
//  case HebYear.Molad.Hour+6 of
//  6..11:tempStr:=IntToStr(HebYear.Molad.Hour+6)+' pm';
//  12:tempStr:='12 am';
//  13..23:tempStr:=IntToStr(HebYear.Molad.Hour-6)+' am';
////  24:tempStr:='12 pm';
//  else
//    tempStr:=IntToStr(HebYear.Molad.Hour-18)+' pm';
//  end;
//
////  result:=CDoW(HebYear.Molad)+' '+
////    tempStr+' '+
////    IntToStr(HebYear.Molad.Part div  18)+' minutes '+
////    IntToStr(HebYear.Molad.Part Mod 18)+' part(s)';
//  {$IFDEF CS2}CodeSite.ExitMethod( 'MoladToStr' );{$ENDIF}
//end;

function CDoW(DayOfWeek: Integer): string;
begin
  {$IFDEF CS2}CodeSite.EnterMethod( 'CDoW' );{$ENDIF}
 case DayOfWeek of
   0:result:='Saturday';
   1:result:='Sunday';
   2:result:='Monday';
   3:result:='Tuesday';
   4:result:='Wednesday';
   5:result:='Thursday';
   6:result:='Friday';
  end;
  {$IFDEF CS2}CodeSite.ExitMethod( 'CDoW' );{$ENDIF}
end;

end.
