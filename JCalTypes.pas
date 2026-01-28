unit JCalTypes;

interface

type
  TYearCompleteness=(ycMissing, ycNormal, ycFull);
  TDayOfWeek=(wdShabbos, wdSunday, wdMonday, wdTuesday, wdWednesday, wdThursday, wdFriday);
  TNewYearDays=TDayOfWeek;

type
  TMolad=record
  Day: Cardinal;
  Hour: Integer;
  Minute: Integer;
  Part: Integer;  //[0..17]
end;

type
  TMonth=record
    Month: String;
    Days: Integer; //0..31;
  end;


implementation

end.
