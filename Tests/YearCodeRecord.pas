unit YearCodeRecord;

interface

type
  TYearCode=record
    NewYearOn: TDayOfWeek;
    YearCompleteness: TYearCompleteness;
    PassoverOn: TDayOfWeek;
    function ToString: String;
  End;

implementation

end.
