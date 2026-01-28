unit Tes1;

interface
uses System.SysUtils,
      DUnitX.TestFramework,
      TekufahClass,
      Unit2;

type

  [TestFixture]
  TTestTekufahClass = class(TObject)
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    // Sample Methods
    // Simple single Test
    [Test]
    procedure Test1;
    // Test with TestCase Atribute to supply parameters.
    [Test]
    [TestCase('Tekufah Teves 5665','5665,06/01/1905,6,10,30')]
    [TestCase('Tekufah Teves 5666','5666,06/01/1906,7,16,30')]
    [TestCase('Tekufah Teves 5674','5674,06/01/1914,3,16,30')]
    procedure TestTekufasTeves(const AValue1 : Integer;const
      ADate: TDate; ADow: Integer; AHour : Integer; AMinute: Integer);
    [Test]
    [TestCase('Tekufah Nissan 5665','5665,07/04/1905,6,18,0')]
    [TestCase('Tekufah Nissan 5666','5666,07/04/1906,7,24,0')]
    [TestCase('Tekufah Nissan 5674','5674,07/04/1914,3,24,0')]
    procedure TestTekufasNissan(const AValue1 : Integer;const
      ADate: TDate; ADow: Integer; AHour : Integer; AMinute: Integer);
    [Test]
    [TestCase('Tekufah Tammuz 5665','5665,08/07/1905,7,1,30')]
    [TestCase('Tekufah Tammuz 5666','5666,08/07/1906,1,7,30')]
    [TestCase('Tekufah Tammuz 5674','5674,08/07/1914,4,7,30')]
    procedure TestTekufasTammuz(const AValue1 : Integer;const
      ADate: TDate; ADow: Integer; AHour : Integer; AMinute: Integer);
    [Test]
    [TestCase('Tekufah Tishrei 5665','5665,07/10/1905,7,9,0')]
    [TestCase('Tekufah Tishrei 5666','5666,07/10/1906,1,15,0')]
    [TestCase('Tekufah Tishrei 5674','5674,07/10/1914,4,15,0')]
    procedure TestTekufasTishrei(const AValue1 : Integer;const
      ADate: TDate; ADow: Integer; AHour : Integer; AMinute: Integer);

  end;

var
  Tekufah: TTekufah;

implementation

procedure TTestTekufahClass.Setup;
begin
  Tekufah:=TTekufah.Create;
end;

procedure TTestTekufahClass.TearDown;
begin
  Tekufah.Free;
end;

procedure TTestTekufahClass.Test1;
begin
end;

procedure TTestTekufahClass.TestTekufasNissan(const AValue1: Integer;
  const ADate: TDate; ADow, AHour, AMinute: Integer);
//var
//  Tekufah: TTekufah;
begin
//  Tekufah:=TTekufah.Create;
  try
    Tekufah.Nissan(AValue1, Tekufah);
    assert.AreEqual(Tekufah.TekDate, ADate);;
    assert.AreEqual(Tekufah.DayInWeek, ADOW);
    assert.AreEqual(Tekufah.Hours, AHour);
    assert.AreEqual(Tekufah.Minutes, AMinute);
  finally
//    Tekufah.Free;
  end;
end;

procedure TTestTekufahClass.TestTekufasTammuz(const AValue1: Integer;
  const ADate: TDate; ADow, AHour, AMinute: Integer);
//var
//  Tekufah: TTekufah;
begin
//  Tekufah:=TTekufah.Create;
  try
    Tekufah.Tammuz(AValue1, Tekufah);
    assert.AreEqual(Tekufah.TekDate, ADate);;
    assert.AreEqual(Tekufah.DayInWeek, ADOW);
    assert.AreEqual(Tekufah.Hours, AHour);
    assert.AreEqual(Tekufah.Minutes, AMinute);
  finally
//    Tekufah.Free;
  end;
end;

procedure TTestTekufahClass.TestTekufasTeves(const AValue1 : Integer;const
  ADate: TDate; ADow: Integer; AHour : Integer; AMinute: Integer);
//var
//  Tekufah: TTekufah;
begin
//  Tekufah:=TTekufah.Create;
  try
    Tekufah.Teves(AValue1, Tekufah);
    assert.AreEqual(Tekufah.TekDate, ADate);;
    assert.AreEqual(Tekufah.DayInWeek, ADOW);
    assert.AreEqual(Tekufah.Hours, AHour);
    assert.AreEqual(Tekufah.Minutes, AMinute);
  finally
//    Tekufah.Free;
  end;
end;

procedure TTestTekufahClass.TestTekufasTishrei(const AValue1: Integer;
  const ADate: TDate; ADow, AHour, AMinute: Integer);
//var
//  Tekufah: TTekufah;
begin
//  Tekufah:=TTekufah.Create;
  try
    Tekufah.Tishrei(AValue1, Tekufah);
    assert.AreEqual(Tekufah.TekDate, ADate);;
    assert.AreEqual(Tekufah.DayInWeek, ADOW);
    assert.AreEqual(Tekufah.Hours, AHour);
    assert.AreEqual(Tekufah.Minutes, AMinute);
  finally
//    Tekufah.Free;
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(TTestTekufahClass);
end.
