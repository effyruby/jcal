unit YearCodeRecord;

interface

uses JCalTypes,
      AlephBet;

type
  TYearCode=record
    NewYearOn: TDayOfWeek;
    YearCompleteness: TYearCompleteness;
    PassoverOn: TDayOfWeek;
    function ToString: String;
  End;

implementation

function TYearCode.ToString: String;
begin
  case NewYearOn of
  wdMonday: result:=BAIS; //#1489;
  wdTuesday: result:=GIMEL; //#1490;
  wdThursday: result:=HEY; //#1492;
  wdShabbos: result:=ZAYIN; //#1494;
  end;

  case YearCompleteness of
  ycMissing: result:=result+CHES; //#1495;
  ycNormal:  result:=result+CHOF; //#1499;
  ycFull:    result:=result+SHIN; //#1513;
  end;

  case PassoverOn of
  wdSunday:  result:=result+ALEPH; //#1488;
  wdTuesday: result:=result+GIMEL; //#1490;
  wdThursday:result:=result+HEY; //#1492;
  wdShabbos: result:=result+ZAYIN; //#1494;
  end;
end;

end.
