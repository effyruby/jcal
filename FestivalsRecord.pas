unit FestivalsRecord;

interface

type
  TFestivals=record
    HebYear: Integer;
    IsLeapYear: Boolean;
    DaysInMonths: TArray<Cardinal>;
    DaysInYear: Integer;

    RoshHashonoh: TDate;
    TzomGedaliah: TDate;
    YomKippur: TDate;
    Sukkos: TDate;
    SheminiAzeret: TDate;
    Chanukah: TDate;
    Teves10: TDate;
    TuBiShvat: TDate;
    Purim: TDate;
    Pessach: TDate;
    Shavuos: TDate;
    Tammuz17: TDate;
    Ov9: TDate;
    Ov15: TDate;

    RC: TDate;
    function AddMonths(AMonths: Integer): Integer;
    Procedure AddDays(ADays: Integer);
    procedure LoadFestivalDates;

  end;


implementation

{ THebFesrivals }

procedure TFestivals.AddDays(ADays: Integer);
begin

end;

function TFestivals.AddMonths(AMonths: Integer): Integer;
var
  k: Integer;
begin
  result:=0;
  for k:=0 to AMonths-1 do
    result:=result+DaysInMonths[k];
end;

procedure TFestivals.LoadFestivalDates;
var
  x: TDate;
begin
  TzomGedaliah:=RoshHashonoh+2;
  YomKippur:=RoshHashonoh+9;
  Sukkos:=RoshHashonoh+14;
  SheminiAzeret:=RoshHashonoh+21;

  Chanukah:=RoshHashonoh+AddMonths(2);
  Chanukah:=Chanukah+24;

  Teves10:=RoshHashonoh+AddMonths(3);
  Teves10:=Teves10+9;

  TuBiShvat:=RoshHashonoh+AddMonths(4);
  TuBiShvat:=TuBiShvat+14;

  if IsLeapYear then
    Purim:=RoshHashonoh+AddMonths(6)
  else
    Purim:=RoshHashonoh+AddMonths(5);;
  Purim:=Purim+13;  //14th Adat/Adar 2

  if IsLeapYear then
    Pessach:=RoshHashonoh+AddMonths(7)
  else
    Pessach:=RoshHashonoh+AddMonths(6);;
  Pessach:=Pessach+14;  //15th Nissan

  if IsLeapYear then
    Shavuos:=RoshHashonoh+AddMonths(9)
  else
    Shavuos:=RoshHashonoh+AddMonths(8);;
  Shavuos:=Shavuos+5;  //6th Sivam

  if IsLeapYear then
    Tammuz17:=RoshHashonoh+AddMonths(10)
  else
    Tammuz17:=RoshHashonoh+AddMonths(9);;
  Tammuz17:=Tammuz17+16;  //17yh Tammuz

  if IsLeapYear then
    OV9:=RoshHashonoh+AddMonths(11)
  else
    Ov9:=RoshHashonoh+AddMonths(10);;
  Ov9:=Ov9+8;  //9th Ov

  if IsLeapYear then
    OV15:=RoshHashonoh+AddMonths(11)
  else
    Ov15:=RoshHashonoh+AddMonths(10);;
  Ov15:=Ov15+14;  //9th Ov
end;

end.
