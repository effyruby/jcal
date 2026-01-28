unit HebYearClass;

interface

uses DHPRecord,
     YearCodeRecord,
     JCalTypes,
     JCalUtils,
     JCalConstants,
     CodeSiteLogging;

type
  THebYear=Class
  private
    FMonth:Integer;
    FYear: Integer;
    NoOfCycles: Integer;
  //YearCompleteness: TYearCompleteness;
    function CalCCycle: Boolean;
    procedure NewYearsDay;
    function IsLeapYear: boolean;
    function InCycle(HDate: TDHP; RegularYears, LeapYears: Integer): TDHP;
    procedure CurrentYearIsAfterLeapYear;
    procedure CurrentYearIsBeforeLeapYear;
    procedure CurrentYearIsBetweenLeapYears;
    procedure CurrentYearIsLeapYear;

    function SubBaseTekufa(HDate: TDHP; RoundToWeek: Boolean): TDHP;

    public
    DaysInMonth: TArray<Cardinal>;
    YearISLeapYear: Boolean;
    MonthsInYear: Integer;
    YearCode: TYearCode;
    Molad: TDHP;
    YearInCycle: Integer;
    NextYearsNewYearOn: TNewYearDays;
    property HYear: Integer read FYear write FYear;
    property HMonth: Integer read FMonth write FMonth;
    function CalcMolad: TDHP;
    function CalcTekufa: TDHP;
    procedure CalcNewYearsDay;
    procedure CalcNextYearsNewYearsDay;
    function HebMonthName(Index: Integer): String;

    function DaysInYear: Integer;
    function AddDaysToDayOfWeek(DayOfWeek: TDayOfWeek; NoOfDays: Integer): TDayOfWeek;

    class function GetMinute(HebDate: TDHP): Integer;
    class function GetPart(HebDate: TDHP): Integer;

    function CalcDaysInMonth: TArray<Cardinal>;
    procedure BasicMonthLengths(var Months: TArray<Cardinal>);
    procedure ModifyForLeapYear(var Months: TArray<Cardinal>);
  End;


implementation


function THebYear.IsLeapYear: boolean;
begin
  {$IFDEF CS2}CodeSite.EnterMethod( Self, 'IsLeapYear' );{$ENDIF}
  result:=CalCCycle;
  {$IFDEF CS2}CodeSite.ExitMethod( Self, 'IsLeapYear' );{$ENDIF}
end;

procedure THebYear.NewYearsDay;
begin
  {$IFDEF CS2}CodeSite.EnterMethod( Self, 'NewYearsDay' );{$ENDIF}
  MonthsInYear:=12;
  case YearInCycle of
   1:CurrentYearIsAfterLeapYear;
   2:CurrentYearIsBeforeLeapYear;
   3:CurrentYearIsLeapYear;
//
   4:CurrentYearIsAfterLeapYear;
   5:CurrentYearIsBeforeLeapYear;
   6:CurrentYearIsLeapYear;
//
   7:CurrentYearIsBetweenLeapYears;
//
   8:CurrentYearIsLeapYear;
   9:CurrentYearIsAfterLeapYear;
   10:CurrentYearIsBeforeLeapYear;
//
   11:CurrentYearIsLeapYear;
   12:CurrentYearIsAfterLeapYear;
   13:CurrentYearIsBeforeLeapYear;
//
   14:CurrentYearIsLeapYear;
   15:CurrentYearIsAfterLeapYear;
   16:CurrentYearIsBeforeLeapYear;
//
   17:CurrentYearIsLeapYear;
   18:CurrentYearIsBetweenLeapYears;
//
   19:CurrentYearIsLeapYear;
  end;
  DaysInMonth:=CalcDaysInMonth;
  {$IFDEF CS2}CodeSite.ExitMethod( Self, 'NewYearsDay' );{$ENDIF}
end;

function THebYear.AddDaysToDAyOfWeek(DayOfWeek: TDayOfWeek;
  NoOfDays: Integer): TDayOfWeek;
var
  a,b,c: ShortInt;
begin
  {$IFDEF CS2}CodeSite.EnterMethod( Self, 'AddDaysToDAyOfWeek' );{$ENDIF}
  a:=Integer(DayOfWeek);
  b:=NoOfDays mod 7;
  c:=(a+b) mod 7;
  result:=TDayOfWeek(c);
  {$IFDEF CS2}CodeSite.ExitMethod( Self, 'AddDaysToDAyOfWeek' );{$ENDIF}
end;

function THebYear.CalcCycle: Boolean;
begin
  {$IFDEF CS2}CodeSite.EnterMethod( Self, 'CalcCycle' );{$ENDIF}
  NoOfCycles:=Hyear div 19;
  YearInCycle:=Hyear mod 19;
  if YearInCycle=0 then
  begin
    if NoOfCycles>1 then
    begin
      dec(NoOfCycles);
      YearInCyCle:=19;
    end
  end;
  YearISLeapYear:=(YearInCycle in [3,6,8,11,14,17,19]);
  result:=YearISLeapYear;
  {$IFDEF CS2}CodeSite.ExitMethod( Self, 'CalcCycle' );{$ENDIF}
end;

function THebYear.CalcTekufa: TDHP;
var
  tempHD: TDHP;
begin
  {$IFDEF CS2}CodeSite.EnterMethod( Self, 'CalcTekufa' );{$ENDIF}
  CalcCycle;
  tempHD:=MultHebDate(OneTekufaCycle, NoOfCycles, False);
//Subract Base
  tempHD:=SubBaseTekufa(tempHD, True);
//Completed YearInCycle-1 years
  case YearInCycle-1 of
    1:tempHD:=InCycle(tempHD, 1,0);
    2:tempHD:=InCycle(tempHD, 2,0);
    3:tempHD:=InCycle(tempHD, 2,1);
    4:tempHD:=InCycle(tempHD, 3,1);
    5:tempHD:=InCycle(tempHD, 4,1);
    6:tempHD:=InCycle(tempHD, 4,2);
    7:tempHD:=InCycle(tempHD, 5,2);
   8 :tempHD:=InCycle(tempHD, 5,3);
    9:tempHD:=InCycle(tempHD, 6,3);
   10:tempHD:=InCycle(tempHD, 7,3);
   11:tempHD:=InCycle(tempHD, 7,4);
   12:tempHD:=InCycle(tempHD, 8,4);
   13:tempHD:=InCycle(tempHD, 9,4);
   14:tempHD:=InCycle(tempHD, 9,5);
   15:tempHD:=InCycle(tempHD,10,5);
   16:tempHD:=InCycle(tempHD,11,5);
   17:tempHD:=InCycle(tempHD,11,6);
   18:tempHD:=InCycle(tempHD,12,6);
  end;
  result:=AddHebDates(tempHD, MultHebDate(OneMonth, HMonth-1, True), True);
  {$IFDEF CS2}CodeSite.ExitMethod( Self, 'CalcTekufa' );{$ENDIF}
end;

//Cycle Year 1,4,9,12,15
procedure THebYear.CurrentYearIsAfterLeapYear;
begin
  {$IFDEF CS2}CodeSite.EnterMethod( Self, 'CurrentYearIsAfterLeapYear' );{$ENDIF}
  case TDayOfWeek(Molad.Day) of
  wdSunday:
  begin
    YearCode.NewYearOn:=wdMonday;
    if Molad.Before9204 then
      YearCode.YearCompleteness:=ycMissing
    else
      YearCode.YearCompleteness:=ycFull;
  end;
  wdMonday:
  begin
    if Molad.Before15589 then
    begin
      YearCode.NewYearOn:=wdMonday;
      YearCode.YearCompleteness:=ycFull;
    end
    else
    begin
      YearCode.NewYearOn:=wdTuesday;
      YearCode.YearCompleteness:=ycNormal;
    end;
  end;
  wdTuesday:
  begin
    if Molad.Before9204 then
    begin
      YearCode.NewYearOn:=wdTuesday;
      YearCode.YearCompleteness:=ycNormal;
    end
    else
    begin
      YearCode.NewYearOn:=wdThursday;
      YearCode.YearCompleteness:=ycNormal;
    end
  end;
  wdWednesday:
  begin
    YearCode.NewYearOn:=wdThursday;
    YearCode.YearCompleteness:=ycNormal;
  end;
  wdThursday:
  begin
    if Molad.Before9204 then
    begin
      YearCode.NewYearOn:=wdThursday;
      YearCode.YearCompleteness:=ycNormal;
    end
    else
    begin
      if not Molad.Before9204 and Molad.BeforeMusaf then
      begin
        YearCode.NewYearOn:=wdThursday;
        YearCode.YearCompleteness:=ycFull;
      end
      else
      begin
        YearCode.NewYearOn:=wdShabbos;
        YearCode.YearCompleteness:=ycMissing;
       end;
    end;
   end;
   wdFriday:
   begin
     YearCode.NewYearOn:=wdShabbos;
     if Molad.Hour*1080+Molad.Part<408 then
        YearCode.YearCompleteness:=ycMissing
     else
        YearCode.YearCompleteness:=ycFull;
   end;
   wdShabbos:
   begin
     if  Molad.BeforeMusaf then
     begin
       YearCode.NewYearOn:=wdShabbos;
       YearCode.YearCompleteness:=ycFull;
    end
    else
    begin
      YearCode.NewYearOn:=wdMonday;
      YearCode.YearCompleteness:=ycMissing;
    end;
  end;
  end;
  CodeSite.SendEnum('NewYearOn', TypeInfo(TNewYearDays), Ord(YearCode.NewYearOn));
  CodeSite.SendEnum('YearCompleteness', TypeInfo(TYearCompleteness), Ord(YearCode.YearCompleteness));
  {$IFDEF CS2}CodeSite.ExitMethod( Self, 'CurrentYearIsAfterLeapYear' );{$ENDIF}
end;

//Cycle Year is 2,5,10,13,16
procedure THebYear.CurrentYearIsBeforeLeapYear;
begin
  {$IFDEF CS2}CodeSite.EnterMethod( Self, 'CurrentYearIsBeforeLeapYear' );{$ENDIF}
  case TDayOfWeek(Molad.Day) of
  wdSunday:
  begin
    YearCode.NewYearOn:=wdMonday;
    if Molad.Before9204 then
      YearCode.YearCompleteness:=ycMissing
    else
      YearCode.YearCompleteness:=ycFull;
  end;
  wdMonday:
  begin
    if Molad.BeforeMusaf then
    begin
      YearCode.NewYearOn:=wdMonday;
      YearCode.YearCompleteness:=ycFull;
    end
    else
    begin
      YearCode.NewYearOn:=wdTuesday;
      YearCode.YearCompleteness:=ycNormal;
     end;
  end;
  wdTuesday:
  begin
    if Molad.Before9204 then
    begin
      YearCode.NewYearOn:=wdTuesday;
      YearCode.YearCompleteness:=ycNormal;
    end
    else
    begin
      YearCode.NewYearOn:=wdThursday;
      YearCode.YearCompleteness:=ycNormal;
    end;
  end;
  wdWednesday:
  begin
    YearCode.NewYearOn:=wdThursday;
    YearCode.YearCompleteness:=ycNormal;
  end;
  wdThursday:
  begin
    if Molad.Before9204 then
    begin
      YearCode.NewYearOn:=wdThursday;
      YearCode.YearCompleteness:=ycNormal;
    end
    else
    begin
      if not Molad.Before9204 and Molad.BeforeMusaf then
      begin
        YearCode.NewYearOn:=wdThursday;
        YearCode.YearCompleteness:=ycFull;
      end
      else
      begin
        YearCode.NewYearOn:=wdShabbos;
        YearCode.YearCompleteness:=ycMissing;
      end;
    end;
  end;
  wdFriday:
  begin
    YearCode.NewYearOn:=wdShabbos;
    if Molad.Before9204 then
      YearCode.YearCompleteness:=ycMissing
    else
      YearCode.YearCompleteness:=ycFull;
  end;
  wdShabbos:
  begin
    if Molad.BeforeMusaf then
    begin
      YearCode.NewYearOn:=wdShabbos;
      YearCode.YearCompleteness:=ycFull;
    end
    else
    begin
      YearCode.NewYearOn:=wdMonday;
      YearCode.YearCompleteness:=ycMissing;
    end
  end;
  end;
  CodeSite.SendEnum('NewYearOn', TypeInfo(TNewYearDays), Ord(YearCode.NewYearOn));
  CodeSite.SendEnum('YearCompleteness', TypeInfo(TYearCompleteness), Ord(YearCode.YearCompleteness));
  {$IFDEF CS2}CodeSite.ExitMethod( Self, 'CurrentYearIsBeforeLeapYear' );{$ENDIF}
end;

//Cycle Year is 7,18
procedure THebYear.CurrentYearIsBetweenLeapYears;
begin
  {$IFDEF CS2}CodeSite.EnterMethod( Self, 'CurrentYearIsBetweenLeapYears' );{$ENDIF}
  case TDayOfWeek(Molad.Day) of
  wdSunday:
  begin
    YearCode.NewYearOn:=wdMonday;
    if Molad.Before9204 then
      YearCode.YearCompleteness:=ycMissing
    else
      YearCode.YearCompleteness:=ycFull;
  end;
  wdMonday:
  begin
    if Molad.Before15589 then
    begin
      YearCode.NewYearOn:=wdMonday;
      YearCode.YearCompleteness:=ycFull;
    end
    else
    begin
      YearCode.NewYearOn:=wdTuesday;
      YearCode.YearCompleteness:=ycNormal;
    end;
  end;
  wdTuesday:
  begin
    IF Molad.Before9204 then
    begin
      YearCode.NewYearOn:=wdTuesday;
      YearCode.YearCompleteness:=ycNormal;
    end
    else
    begin
      YearCode.NewYearOn:=wdThursday;
      YearCode.YearCompleteness:=ycNormal;
    end;
  end;
  wdWednesday:
  begin
    YearCode.NewYearOn:=wdThursday;
    YearCode.YearCompleteness:=ycNormal;
  end;
  wdThursday:
  begin
    if Molad.Before9204 then
    begin
      YearCode.NewYearOn:=wdThursday;
      YearCode.YearCompleteness:=ycNormal;
    end
    else
    begin
      if not Molad.Before9204 and Molad.BeforeMusaf then
      begin
        YearCode.NewYearOn:=wdThursday;
        YearCode.YearCompleteness:=ycFull;
      end
      else
      begin
        YearCode.NewYearOn:=wdShabbos;
        YearCode.YearCompleteness:=ycMissing;
      end;
    end;
  end;
  wdFriday:
  begin
    YearCode.NewYearOn:=wdShabbos;
    IF Molad.Before9204 then
      YearCode.YearCompleteness:=ycMissing
    else
      YearCode.YearCompleteness:=ycFull;
  end;
  wdShabbos:
  begin
    if  Molad.BeforeMusaf then
    begin
      YearCode.NewYearOn:=wdShabbos;
      YearCode.YearCompleteness:=ycFull;
    end
    else
    begin
      YearCode.NewYearOn:=wdMonday;
      YearCode.YearCompleteness:=ycMissing;
    end;
  end;
  end;
  CodeSite.SendEnum('NewYearOn', TypeInfo(TNewYearDays), Ord(YearCode.NewYearOn));
  CodeSite.SendEnum('YearCompleteness', TypeInfo(TYearCompleteness), Ord(YearCode.YearCompleteness));
  {$IFDEF CS2}CodeSite.ExitMethod( Self, 'CurrentYearIsBetweenLeapYears' );{$ENDIF}
end;

//Cycle Years 3,6,8,11,14,17,19
procedure THebYear.CurrentYearIsLeapYear;
begin
try
  CodeSite.EnterMethod( Self, 'CurrentYearIsLeapYear' );
  MonthsInYear:=13;
  case TDayOfWeek(Molad.Day )of
  wdSunday:
  begin
    YearCode.NewYearOn:=wdMonday;
    if Molad.Hour*1080+Molad.Part<20*1080+491 then
      YearCode.YearCompleteness:=ycMissing
    else
      YearCode.YearCompleteness:=ycFull;
  end;
  wdMonday:
  begin
    if Molad.BeforeMusaf then
    begin
      YearCode.NewYearOn:=wdMonday;
      YearCode.YearCompleteness:=ycFull;
    end
    else
    begin
      YearCode.NewYearOn:=wdTuesday;
      YearCode.YearCompleteness:=ycNormal;
    end;
  end;
  wdTuesday:
  begin
    if Molad.BeforeMusaf then
    begin
      YearCode.NewYearOn:=wdTuesday;
      YearCode.YearCompleteness:=ycNormal;
    end
    else
    begin
      YearCode.NewYearOn:=wdThursday;
      YearCode.YearCompleteness:=ycMissing;
    end
  end;
  wdWednesday:
  begin
   YearCode.NewYearOn:=wdThursday;
   if Molad.Hour*1080+Molad.Part<11*1080+695 then
      YearCode.YearCompleteness:=ycMissing
   else
     YearCode.YearCompleteness:=ycFull;
  end ;
  wdThursday:
  begin
    if Molad.BeforeMusaf then
    begin
      YearCode.NewYearOn:=wdThursday;
      YearCode.YearCompleteness:=ycFull;
    end
    else
    begin
      YearCode.NewYearOn:=wdShabbos;
      YearCode.YearCompleteness:=ycMissing;
    end;
   end;
   wdFriday:
   begin
     YearCode.NewYearOn:=wdShabbos;
     IF Molad.Hour*1080+Molad.Part<20*1080+491 then
        YearCode.YearCompleteness:=ycMissing
     else
        YearCode.YearCompleteness:=ycFull;
   end;
  wdShabbos:
  begin
    if Molad.BeforeMusaf then
    begin
      YearCode.NewYearOn:=wdShabbos;
      YearCode.YearCompleteness:=ycFull;
    end
    else
    begin
      YearCode.NewYearOn:=wdMonday;
      YearCode.YearCompleteness:=ycMissing;
    end;
  end;
  end;
finally
  CodeSite.SendEnum('NewYearOn', TypeInfo(TNewYearDays), Ord(YearCode.NewYearOn));
  CodeSite.SendEnum('YearCompleteness', TypeInfo(TYearCompleteness), Ord(YearCode.YearCompleteness));
  CodeSite.ExitMethod( Self, 'CurrentYearIsLeapYear' );
end;
end;

class function THebYear.GetMinute(HebDate: TDHP): Integer;
begin
  {$IFDEF CS2}CodeSite.EnterMethod( 'THebYear.GetMinute' );{$ENDIF}
  result:=HebDate.Part div 18;
  {$IFDEF CS2}CodeSite.ExitMethod( 'THebYear.GetMinute' );{$ENDIF}
end;

class function THebYear.GetPart(HebDate: TDHP): Integer;
begin
  {$IFDEF CS2}CodeSite.EnterMethod( 'THebYear.GetPart' );{$ENDIF}
  result:=HebDate.Part mod 18;
  {$IFDEF CS2}CodeSite.ExitMethod( 'THebYear.GetPart' );{$ENDIF}
end;

function THebYear.CalcMolad: TDHP;
begin
try
  {$IFDEF CS2}CodeSite.EnterMethod( Self, 'CalcMolad' );{$ENDIF}
  CalcCycle;
  Molad:=MultHebDate(OneCycle, NoOfCycles, True);
  Molad:=AddHebDates(Molad, BaseYear, True);
//Completed YearInCucle-1 Years
  case YearInCycle-1 of
    1:Molad:=InCycle(Molad, 1,0);
    2:Molad:=InCycle(Molad, 2,0);
    3:Molad:=InCycle(Molad, 2,1);
    4:Molad:=InCycle(Molad, 3,1);
    5:Molad:=InCycle(Molad, 4,1);
    6:Molad:=InCycle(Molad, 4,2);
    7:Molad:=InCycle(Molad, 5,2);
    8:Molad:=InCycle(Molad, 5,3);
    9:Molad:=InCycle(Molad, 6,3);
   10:Molad:=InCycle(Molad, 7,3);
   11:Molad:=InCycle(Molad, 7,4);
   12:Molad:=InCycle(Molad, 8,4);
   13:Molad:=InCycle(Molad, 9,4);
   14:Molad:=InCycle(Molad, 9,5);
   15:Molad:=InCycle(Molad,10,5);
   16:Molad:=InCycle(Molad,11,5);
   17:Molad:=InCycle(Molad,11,6);
   18:Molad:=InCycle(Molad,12,6);
  end;
  Molad:=AddHebDates(Molad, MultHebDate(OneMonth, HMonth-1, True), True);
  result:=Molad;
  CodeSite.AddSeparator;
  CodeSite.Send('Molad.Day:', result.Day);
  CodeSite.Send('Molad.Hour:', result.Hour);
  CodeSite.Send('Molad.Part:', result.Part);

finally
  CodeSite.ExitMethod( Self, 'CalcMolad' );
end;
end;

procedure THebYear.CalcNewYearsDay;
begin
  {$IFDEF CS2}CodeSite.EnterMethod( Self, 'CalcNewYearsDay' );{$ENDIF}
  CalcMolad;
  NewYearsDay;
  {$IFDEF CS2}CodeSite.ExitMethod( Self, 'CalcNewYearsDay' );{$ENDIF}
end;

procedure THebYear.CalcNextYearsNewYearsDay;
begin
  {$IFDEF CS2}CodeSite.EnterMethod( Self, 'CalcNextYearsNewYearsDay' );{$ENDIF}
  CalcNewYearsDay;
//  CalcMolad;
//  NewYearsDay;
  NextYearsNewYearOn:=AddDaysToDayOfWeek(YearCode.NewYearOn, DaysInYear);
  YearCode.PassoverOn:=AddDaysToDayOfWeek(YearCode.NewYearOn, DaysInYear-2);
  {$IFDEF CS2}CodeSite.ExitMethod( Self, 'CalcNextYearsNewYearsDay' );{$ENDIF}
end;

function THebYear.HebMonthName(Index: Integer): String;
begin
  if YearIsLeapYear then
    result:=TLeapHebMonths[Index-1]
  else
    result:=TRegularHebMonths[Index-1];
end;

function THebYear.SubBaseTekufa(HDate: TDHP; RoundToWeek: Boolean): TDHP;
begin
  {$IFDEF CS2}CodeSite.EnterMethod( 'SubBaseTekufa' );{$ENDIF}
  HDate.Part:=HDate.Part-204;
  if HDate.Part<0 then
  begin
    HDate.Part:=HDate.Part+1080;
    HDate.Hour:=HDate.Hour-1;
  end;

  HDate.Hour:=HDate.Hour-20;
  if HDate.Hour<0 then
  begin
    HDate.Hour:=HDate.Hour+24;
    HDate.Day:=HDate.Day-1;
  end;

  HDate.Day:=HDate.Day-12;

  if RoundToWeek then
    HDate.Day:=HDate.Day mod 7;
  result:=HDate;
  {$IFDEF CS2}CodeSite.ExitMethod( 'SubBaseTekufa' );{$ENDIF}
end;

function THebYear.InCycle(HDate: TDHP; RegularYears, LeapYears: Integer): TDHP;
begin
  {$IFDEF CS2}CodeSite.EnterMethod( Self, 'InCycle' );{$ENDIF}
  result:=AddHebDates(HDate, MultHebDate(RegularYear,RegularYears, True), True);
  result:=AddHebDates(result, MultHebDate(LeapYear,LeapYears, True), True);
  {$IFDEF CS2}CodeSite.ExitMethod( Self, 'InCycle' );{$ENDIF}
end;

function THebYear.DaysInYear: Integer;
const
  LengthofRegularYear=354;
  LengthofLeapYear=384;
var
  DaystoAdd: Integer;
begin
  {$IFDEF CS2}CodeSite.EnterMethod( Self, 'DaysInYear' );{$ENDIF}
  case YearCode.YearCompleteness of
  ycMissing:DaystoAdd:=-1;
  ycNormal:DaystoAdd:=0;
  ycFull:DaystoAdd:=1;
  end;

  case YearInCycle of
  1,2,4,5,7,9,10,12,13,15,16,18:
    result:=LengthofRegularYear+DaystoAdd;
  else
    result:=LengthofLeapYear+DaystoAdd;
  end;
  {$IFDEF CS2}CodeSite.ExitMethod( Self, 'DaysInYear' );{$ENDIF}
end;

function THebYear.CalcDaysInMonth: TArray<Cardinal>;
begin
   BasicMonthLengths(result);
   case DaysInYear of
   353:  //Kislev Missing
     result[2]:=29; //Kislev Missing
   354:; //All Good
   355:
     result[1]:=30; //Cheshvan Extra
   383:  //Kislev Missing Lrap Uear
   begin
     result[2]:=29; //Kislev Missinf Leap Year
     ModifyForLeapYear(result);
   end;
   384:  //Leap Year
     ModifyForLeapYear(result);
   385:  //Cheshvan Extra Leap Year
   begin
     result[1]:=30;
     ModifyForLeapYear(result);
   end;

   end;
end;

procedure THebYear.BasicMonthLengths(var Months: TArray<Cardinal>);
begin
  MonthsInYear:=12;
  SetLength(Months, MonthsInYear);
  Months[0]:=30; //Tishrei
  Months[1]:=29;//Cheshvan
  Months[2]:=30; //Kisleb
  Months[3]:=29; //Teves
  Months[4]:=30; //SHevat
  Months[5]:=29; //Adar
  Months[6]:=30; //Nissan
  Months[7]:=29; //Iyar
  Months[8]:=30; //Sivan
  Months[9]:=29; //Tammuz
  Months[10]:=30;//Ov
  Months[11]:=29;//Elil
end;

procedure THebYear.ModifyForLeapYear(var Months: TArray<Cardinal>);
begin
  MonthsInYear:=13;
  SetLength(Months, MonthsInYear);
  Months[5]:=30; //Adar Aleph
  Months[6]:=29; //Adar Bais
  Months[7]:=30; //Nissan
  Months[8]:=29; //Iyar
  Months[9]:=30; //Sivan
  Months[10]:=29; //Tammuz
  Months[11]:=30;//Ov
  Months[12]:=29;//Elil
end;

end.
