unit TekufahClass;

interface

uses SysUtils,
     ALEPHBET,
     MILON,
     DUnitX.TestFramework,
     CodeSiteLogging;

type
  TTekufah=Class
    TekDate: TDateTime;
//  Hebdate: THebDate;
    Days: cardinal;
    DayInWeek: Integer;
    Hours: Integer;
    Minutes: Integer;
    function ToString: String;
    function TekDateToString: String;
    function TekDOW: String;
    function TekTime: String;

    function Nissan(TekufaYear: Integer;
      Tekufah: TTekufah): Boolean;
    function Tammuz(TekufaYear: Integer;
      Tekufah: TTekufah): Boolean;
    function Teves(TekufaYear: Integer;
      Tekufah: TTekufah): Boolean;
    function Tishrei(TekufaYear: Integer;
      Tekufah: TTekufah): Boolean;

    function Update(Tekufah: TTekufah; ADays: Cardinal = 91;
      AHours: Cardinal = 7; AMins: Cardinal = 30): Boolean;

  private

  end;

implementation

{ TTekufah }

function TTekufah.Nissan(TekufaYear: Integer; Tekufah: TTekufah): Boolean;
begin
  Teves(TekufaYear, Tekufah);
  Update(Tekufah);
end;

function TTekufah.Tammuz(TekufaYear: Integer; Tekufah: TTekufah): Boolean;
begin
  Teves(TekufaYear, Tekufah);
  Update(Tekufah, 182, 15, 0);
end;


function TTekufah.TekDateToString: String;
begin
  result:=FormatDateTime('dd-MMM-yyyy', TekDate);
end;

function TTekufah.TekDOW: String;
begin
  result:=FormatDateTime('dddd', TekDate);
end;

function TTekufah.TekTime: String;
var
  _Hours: Integer;
  AMPM: String;
begin
  _Hours:=Hours;
  AMPM:='AM';
  if Hours>12 then
  begin
    _Hours:=Hours-12;
    AMPM:='PM';
  end;
  result:=Format('%.2d:%.2d %s', [_Hours, Minutes, AMPM]);
end;

function TTekufah.Teves(TekufaYear: Integer; Tekufah: TTekufah): Boolean;
var
  NoOfYears: Cardinal;
  NewHours, NDays, NHours: Cardinal;
  StartTekufah: TTekufah;
begin
  result:=False;

  StartTekufah:=TTekufah.Create;
  try
    with StartTekufah do
    begin
      TekDate := StrToDate('06/01/1905');
      Hours := 10;
      Minutes := 30;
    end;

    with Tekufah do
    begin
      Minutes := 30;
    end;

    NoOfYears := TekufaYear - 3760-1905;
    codeSite.Send('NoOfYears', NoOfYears);

    NDays := NoOfYears * 365;
    codeSite.Send('NDays', NDays);

    NHours := NoOfYears * 6;
    codeSite.Send('NHours', NHours);

    NewHours := NHours mod 24;
    NDays := NDays + (NHours div 24);
    Tekufah.Days := NDays;
    Tekufah.Hours := NewHours;

    Tekufah.TekDate := StartTekufah.TekDate + Tekufah.Days;
    Tekufah.Hours := Tekufah.Hours + StartTekufah.Hours;
    Tekufah.DayInWeek := DayOfWeek(Tekufah.TekDate);

    if Tekufah.Hours > 24 then
    begin
      Tekufah.Hours := Tekufah.Hours - 24;
      Tekufah.TekDate := Tekufah.TekDate + 1;
      Tekufah.DayInWeek := DayOfWeek(Tekufah.TekDate);
    end;
    codeSite.Send('data', Tekufah.TekTime);
  finally
    StartTekufah.Free;
  end;
  result:=True;
end;

function TTekufah.Tishrei(TekufaYear: Integer; Tekufah: TTekufah): Boolean;
begin
  Teves(TekufaYear, Tekufah);
  Update(Tekufah, 273, 22, 30);
end;

function TTekufah.ToString: String;
begin
  result:=FormatDateTime('dddd dd-MMM-yyyy', TekDate)+' '+TekTime;
end;

function TTekufah.Update(Tekufah: TTekufah;
  ADays, AHours, AMins: Cardinal): Boolean;
begin
  Tekufah.Days := ADays;
  Tekufah.Hours := Tekufah.Hours + AHours;
  Tekufah.Minutes := Tekufah.Minutes + AMins;
  if Tekufah.Minutes = 60 then
  begin
    Tekufah.Minutes := 0;
    Tekufah.Hours := Tekufah.Hours + 1;
  end;
  if Tekufah.Hours > 24 then
  begin
    Tekufah.Hours := Tekufah.Hours - 24;
    Tekufah.Days := Tekufah.Days + 1;
  end;
  Tekufah.TekDate:=Tekufah.TekDate+Tekufah.Days;
  Tekufah.DayInWeek := DayOfWeek(Tekufah.TekDate);
end;

end.
