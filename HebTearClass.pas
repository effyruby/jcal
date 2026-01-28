unit HebTearClass;

interface

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

end.
