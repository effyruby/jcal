unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Classes, System.Generics.Collections,
  Controls, Forms, Vcl.Graphics, Dialogs, StdCtrls, CodeSiteLogging, ComCtrls,
  Vcl.Samples.Spin,
  TntComCtrls, ALEPHBET, MILON, Unit2, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error,
  FireDAC.UI.Intf,
  FireDAC.Phys.Intf,
  FireDAC.Stan.Def,
  FireDAC.Stan.Pool,
  FireDAC.Stan.Async,
  FireDAC.Phys,
  FireDAC.Phys.MSAcc,
  FireDAC.Phys.MSAccDef,
  Data.DB, FireDAC.Comp.Client,
  FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs,
  HebYearClass,
  JCalTypes,
  JCalConstants,
  DHPRecord,
  TekufahClass;

const
  MAXYEARS = 6000;
  Mon2Mon = 'Monday->Monday';
  Mon2Thu = 'Monday->Thursday';
  Mon2Sha = 'Monday->Shabbos';
  // Tuesday
  Tue2Sha = 'Tuesday->Shabbos';
  Tue2Mon = 'Tuesday->Monday';
  // Thusday
  Thu2Mon = 'Thursday->Monday';
  Thu2Tue = 'Thursday->Tuesday';
  Thu2Thu = 'Thursday->Thursday';
  // Shabbos
  Sha2Tue = 'Shabbos->Tuesday';
  Sha2Thu = 'Shabbos->Thursday';
  Sha2Sha = 'Shabbos->Shabbos';

type
  TfrmMain = class(TForm)
    edtHebYear: TEdit;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    edtYearCode: TEdit;
    Button5: TButton;
    Button6: TButton;
    seNoOfYears: TSpinEdit;
    ListView1: TListView;
    ListView2: TListView;
    ListView3: TListView;
    TntPageControl1: TTntPageControl;
    TntTabSheet1: TTntTabSheet;
    TntTabSheet2: TTntTabSheet;
    Button7: TButton;
    Button8: TButton;
    Label1: TLabel;
    lvGeneral: TListView;
    tsLogging: TTntTabSheet;
    Memo2: TMemo;
    pb: TProgressBar;
    FDConnection1: TFDConnection;
    cboYCFilter: TComboBox;
    Label2: TLabel;
    chkExcludeYC: TCheckBox;
    cboYearToYear: TComboBox;
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Memo1DblClick(Sender: TObject);
    procedure cboYCFilterChange(Sender: TObject);
    procedure cboYearToYearChange(Sender: TObject);
  private
    { Private declarations }
    YearCodeArray: TArray<String>;
    YC1Dict: TDictionary<String, Integer>;
    YC2Dict: TDictionary<String, Integer>;
    YC3Dict: TDictionary<String, Integer>;
    ErrorCount: Integer;
    procedure InitDict;
    procedure ScanNYears(ForwardDirection: Boolean);
    procedure Log(AText: String); overload;
    procedure Log(AText1, AText2: String); overload;
    procedure Log(AText1, AText2, AText3: String); overload;
    procedure Log(AText1, AText2, AText3, AText4: String); overload;
    function LogFilter(YearCode: String): String;

    procedure LoadUearToUear;
    function ConvertCodeToHeb(Code: String): String;
    function IsInYearCideArray(YearCode: String): Boolean;

  public
    { Public declarations }
//    function CalTevesTekufah(TekufaYear: Integer;
//      Tekufah: TTekufah): Boolean;
    // function CalNissanTekufah(TekufaYear: Integer): TTekufah;
//    function UpdateTekufah(Tekufah: TTekufah; ADays: Cardinal = 91;
  //    AHours: Cardinal = 7; AMins: Cardinal = 30): Boolean;
    procedure DisplayTekufah(HebMonrg: String; Tekufah: TTekufah);

  end;

var
  frmMain: TfrmMain;

implementation

{$R *.DFM}

procedure TfrmMain.Log(AText: String);
var
  li: TListItem;
begin
  li := lvGeneral.Items.Add;
  li.Caption := AText;
end;

procedure TfrmMain.Log(AText1, AText2: String);
var
  li: TListItem;
begin
  li := lvGeneral.Items.Add;
  li.Caption := AText1;
  li.SubItems.Add(AText2);
end;

procedure TfrmMain.Button2Click(Sender: TObject);
var
  k: Integer;
  Molad: TDHP;
  HebYear: THebYear;
begin
  lvGeneral.Clear;

  HebYear := THebYear.Create;
  try
    HebYear.HYear := StrToInt(edtHebYear.Text);
    HebYear.CalcNewYearsDay;
    for k := 1 to HebYear.MonthsInYear do
    begin
      HebYear.HMonth := k;
      Molad := HebYear.CalcMolad;
      Log(H_MOLAD + SPACE + HebYear.HebMonthName(k), Molad.DHMPToString);
    end;
    // ShowMessage(IntToStr(Molad.Hour));
    // ShowMessage(IntToStr(HebYear.GetMinute(Molad)));
    // ShowMessage(IntToStr(HebYear.GetPart(Molad)));
  finally
    HebYear.Free;
  end;
end;

procedure TfrmMain.Button3Click(Sender: TObject);
var
  Molad: TDHP;
  HebYear: THebYear;
  SaveYearCode: String;
begin
  lvGeneral.Clear;

  SaveYearCode := edtYearCode.Text;
  HebYear := THebYear.Create;
  try
    HebYear.HYear := StrToInt(edtHebYear.Text);
    HebYear.HMonth := 1;
    HebYear.CalcNextYearsNewYearsDay;
    edtYearCode.Text := HebYear.YearCode.ToString;
    if HebYear.YearISLeapYear then
      edtYearCode.Font.Style := [fsBold]
    else
      edtYearCode.Font.Style := [];
  finally
    HebYear.Free;
  end;
end;

procedure TfrmMain.Button4Click(Sender: TObject);
var
  Incidents, k: Integer;
  YC1, YC2, YC3, Key, YearCode: String;
  Percent: Single;
  HebYear1, HebYear2: THebYear;
  li: TListItem;
begin
  ErrorCount := 0;
  lvGeneral.Clear;
  InitDict;

  pb.Min := 0;
  pb.Max := MAXYEARS;
  pb.Position := 0;

  Button4.Enabled := False;
  try
    for k := 1 to MAXYEARS do
    begin
      pb.Position := k;
      codeSite.AddCheckPoint;
      codeSite.Send('k', k);
      Log('year', IntToStr(k));
      HebYear1 := THebYear.Create;
      HebYear2 := THebYear.Create;
      try
        HebYear1.HYear := k;
        HebYear1.HMonth := 1;
        HebYear1.CalcNextYearsNewYearsDay;

        HebYear2.HYear := k + 1;
        HebYear2.HMonth := 1;
        HebYear2.CalcNewYearsDay;

        if HebYear2.YearCode.NewYearOn <> HebYear1.NextYearsNewYearOn then
        begin
          Memo2.Lines.Add(HebYear1.Molad.DHPToString);
          Memo2.Lines.Add(HebYear2.Molad.DHPToString);
          Memo2.Lines.Add('');

          Memo2.Lines.Add('Error: year: ' + IntToStr(k) + 'mof 19: ' +
            IntToStr(k mod 19));
          Memo2.Lines.Add('HebYear1: NYD: ' + DaysOfWeek
            [Ord(HebYear1.YearCode.NewYearOn)]);
          Memo2.Lines.Add('HebYear1: NY-NYD: ' + DaysOfWeek
            [Ord(HebYear1.NextYearsNewYearOn)]);
          Memo2.Lines.Add('HebYear2: NYDL ' + DaysOfWeek
            [Ord(HebYear2.YearCode.NewYearOn)]);
          Memo2.Lines.Add('HebYear1: ' + IntToStr(HebYear1.DaysInYear));
          Memo2.Lines.Add('HebYear1: ' + IntToStr(HebYear1.DaysInYear mod 7));
          Memo2.Lines.Add('HebYear2: ' + DaysOfWeek
            [Ord(HebYear2.YearCode.NewYearOn)]);
          Inc(ErrorCount);
          Memo2.Lines.Add('HebYear2: ' + IntToStr(ErrorCount));
          Application.ProcessMessages;
        end;

        YC3 := HebYear1.YearCode.ToString;
        YC2 := LowerCase(Copy(YC3, 1, 2));
        YC1 := Copy(YC3, 1, 1);
        if YC3Dict.TryGetValue(YC3, Incidents) then
        begin
          Inc(Incidents);
          YC3Dict.AddOrSetValue(YC3, Incidents);
        end
        else
          Beep;

        if YC2Dict.TryGetValue(YC2, Incidents) then
        begin
          Inc(Incidents);
          YC2Dict.AddOrSetValue(YC2, Incidents);
        end
        else
          Beep;

        if YC1Dict.TryGetValue(YC1, Incidents) then
        begin
          Inc(Incidents);
          YC1Dict.AddOrSetValue(YC1, Incidents);
        end
        else
          Beep;
      finally
        HebYear1 := THebYear.Create;
        HebYear2 := THebYear.Create;
      end;
    end;

    codeSite.AddSeparator;
    Application.ProcessMessages;
    for k := 0 to Length(YC3Digits) - 1 do
    begin
      Key := ConvertCodeToHeb(YC3Digits[k]);
      Incidents := YC3Dict.Items[Key];
      Percent := 100 * Incidents / MAXYEARS;
      li := ListView1.Items.Add;
      li.Caption := Key;
      li.SubItems.Add(Incidents.ToString);
      li.SubItems.Add(Format('%.2f', [Percent]));
    end;

    Application.ProcessMessages;
    for k := 0 to Length(YC2Digits) - 1 do
    begin
      Key := ConvertCodeToHeb(YC2Digits[k]);
      Incidents := YC2Dict.Items[Key];
      Percent := 100 * Incidents / MAXYEARS;
      li := ListView2.Items.Add;
      li.Caption := Key;
      li.SubItems.Add(Incidents.ToString);
      li.SubItems.Add(Format('%.2f', [Percent]));
    end;

    Application.ProcessMessages;
    for k := 0 to Length(YC1Digits) - 1 do
    begin
      Key := YC1Digits[k];
      Incidents := YC1Dict.Items[Key];
      Percent := 100 * Incidents / MAXYEARS;
      li := ListView3.Items.Add;
      li.Caption := Key;
      li.SubItems.Add(Incidents.ToString);
      li.SubItems.Add(Format('%.2f', [Percent]));
    end;
  finally
    pb.Position := 0;
    Button4.Enabled := True;
  end;
end;

procedure TfrmMain.Button5Click(Sender: TObject);
begin
  ScanNYears(False);
end;

procedure TfrmMain.Button6Click(Sender: TObject);
begin
  ScanNYears(True);
end;

procedure TfrmMain.DisplayTekufah(HebMonrg: String; Tekufah: TTekufah);
var
  li: TListItem;
begin
  li := lvGeneral.Items.Add;
  li.Caption := HebMonrg;
  li.SubItems.Add(Tekufah.TekDow);
  li.SubItems.Add(Tekufah.TekDateToString);
  li.SubItems.Add(Tekufah.TekTime);
end;

procedure TfrmMain.cboYearToYearChange(Sender: TObject);
begin
  cboYCFilter.ItemIndex := 0;
  SetLength(YearCodeArray, 0);
  //Monfay
  if cboYearToYear.Text = Mon2Mon then
  begin
    SetLength(YearCodeArray, 1);
    YearCodeArray[0] := BAIS + SHIN + ZAYIN;
  end
  else if cboYearToYear.Text = Mon2Thu then
  begin
    SetLength(YearCodeArray, 1);
    YearCodeArray[0] := BAIS + CHES + GIMEL;
  end
  else if cboYearToYear.Text = Mon2Sha then
  begin
    SetLength(YearCodeArray, 2);
    YearCodeArray[0] := BAIS + CHES + HEY;
    YearCodeArray[1] := BAIS + SHIN + HEY;
  end

  //Tuesday
  else if cboYearToYear.Text = Tue2Sha then
  begin
    SetLength(YearCodeArray, 1);
    YearCodeArray[0] := GIMEL + CHOF + HEY;
  end
  else if cboYearToYear.Text = Tue2Mon then
  begin
    SetLength(YearCodeArray, 1);
    YearCodeArray[0] := GIMEL + CHOF + ZAYIN;
  end

  // Thursday
  else if cboYearToYear.Text = Thu2Mon then
  begin
    SetLength(YearCodeArray, 1);
    YearCodeArray[0] := HEY + CHOF + ZAYIN;
  end
  else if cboYearToYear.Text = Thu2Tue then
  begin
    SetLength(YearCodeArray, 1);
    YearCodeArray[0] := HEY + SHIN + ALEPH;
  end
  else if cboYearToYear.Text = Thu2Thu then
  begin
    SetLength(YearCodeArray, 1);
    YearCodeArray[0] := HEY + SHIN + GIMEL;
  end

  // Shabbos
  else if cboYearToYear.Text = Sha2Tue then
  begin
    SetLength(YearCodeArray, 1);
    YearCodeArray[0] := ZAYIN + CHES + ALEPH;
  end
  else if cboYearToYear.Text = Sha2Thu then
  begin
    SetLength(YearCodeArray, 2);
    YearCodeArray[0] := ZAYIN + CHES + GIMEL;
    YearCodeArray[1] := ZAYIN + SHIN + GIMEL;
  end
  else if cboYearToYear.Text = Sha2Sha then
  begin
    SetLength(YearCodeArray, 1);
    YearCodeArray[0] := ZAYIN + SHIN + HEY;
  end;

  Button8Click(Self);
end;

procedure TfrmMain.Button7Click(Sender: TObject);
var
  k, YearOfInterest: Integer;
  Tekufah: TTekufah;
begin
  lvGeneral.Clear;

  Tekufah:=TTekufah.Create;
  try
    for k := 0 to seNoOfYears.Value - 1 do
    begin
      YearOfInterest := k + StrToInt(edtHebYear.Text);
      Tekufah.Teves(YearOfInterest, Tekufah);
      DisplayTekufah(H_TEKUFAS + ' ' + TEVES, Tekufah);

      Tekufah.Update(Tekufah);
      DisplayTekufah(H_TEKUFAS + ' ' + NISSAN, Tekufah);

      Tekufah.Update(Tekufah);
      DisplayTekufah(H_TEKUFAS + ' ' + TAMMUZ, Tekufah);

      Tekufah.Update(Tekufah);
      DisplayTekufah(H_TEKUFAS + ' ' + TISHREI, Tekufah);

      Tekufah.Nissan(YearOfInterest, Tekufah);
      DisplayTekufah(H_TEKUFAS + ' ' + NISSAN, Tekufah);

      Tekufah.Tammuz(YearOfInterest, Tekufah);
      DisplayTekufah(H_TEKUFAS + ' ' + TAMMUZ, Tekufah);

      Tekufah.Tishrei(YearOfInterest, Tekufah);
      DisplayTekufah(H_TEKUFAS + ' ' + TISHREI, Tekufah);
    end;
  finally
    Tekufah.Free;
  end;
end;

//function TfrmMain.CalTevesTekufah(TekufaYear: Integer;
//  Tekufah: TTekufah): Boolean;
//var
//  NoOfYears: Cardinal;
//  NewHours, NDays, NHours: Cardinal;
//  StartTekufah: TTekufah;
//begin
//  result:=False;
//
//  StartTekufah:=TTekufah.Create;
//  try
//    with StartTekufah do
//    begin
//      TekDate := StrToDate('06/01/1905');
//      Hours := 10;
//      Minutes := 30;
//    end;
//
//    with Tekufah do
//    begin
//      Minutes := 30;
//    end;
//
//    NoOfYears := TekufaYear - 3760-1905;
//    codeSite.Send('NoOfYears', NoOfYears);
//    NDays := NoOfYears * 365;
//    codeSite.Send('NDays', NDays);
//    NHours := NoOfYears * 6;
//    codeSite.Send('NHours', NHours);
//    NewHours := NHours mod 24;
//    NDays := NDays + (NHours div 24);
//    Tekufah.Days := NDays;
//    Tekufah.Hours := NewHours;
//
//    Tekufah.TekDate := StartTekufah.TekDate + Tekufah.Days;
//    Tekufah.Hours := Tekufah.Hours + StartTekufah.Hours;
//    Tekufah.DayOfWeek := DayOfWeek(Tekufah.TekDate);
//
//    if Tekufah.Hours > 24 then
//    begin
//      Tekufah.Hours := Tekufah.Hours - 24;
//      Tekufah.TekDate := Tekufah.TekDate + 1;
//      Tekufah.DayOfWeek := DayOfWeek(Tekufah.TekDate);
//    end;
//    codeSite.Send('data', Tekufah.TekTime);
//  finally
//    StartTekufah.Free;
//  end;
//  result:=True;
//end;

procedure TfrmMain.cboYCFilterChange(Sender: TObject);
begin
  SetLength(YearCodeArray, 0);
  cboYearToYear.ItemIndex := 0;

  if cboYCFilter.Text = '' then
    SetLength(YearCodeArray, 0)
  else
  begin
    SetLength(YearCodeArray, 1);
    YearCodeArray[0] := cboYCFilter.Text;
  end;
  Button8Click(Self);
end;

function TfrmMain.ConvertCodeToHeb(Code: String): String;
begin
  if Code.Equals('2a5') then
    result := BAIS + SHIN + HEY
  else if Code.Equals('2A7') then
    result := BAIS + SHIN + ZAYIN
  else if Code.Equals('2d3') then
    result := BAIS + CHES + GIMEL
  else if Code.Equals('2D5') then
    result := BAIS + CHES + HEY
  else if Code.Equals('3r5') then
    result := GIMEL + CHOF + HEY
  else if Code.Equals('3R7') then
    result := GIMEL + CHOF + ZAYIN
  else if Code.Equals('5a1') then
    result := HEY + SHIN + ALEPH
  else if Code.Equals('5A3') then
    result := HEY + SHIN + GIMEL
  else if Code.Equals('5D1') then
    result := HEY + CHES + ALEPH
  else if Code.Equals('5r7') then
    result := HEY + CHOF + ZAYIN
  else if Code.Equals('7a3') then
    result := ZAYIN + SHIN + GIMEL
  else if Code.Equals('7A5') then
    result := ZAYIN + SHIN + HEY
  else if Code.Equals('7d1') then
    result := ZAYIN + CHES + ALEPH
  else if Code.Equals('7D3') then
    result := ZAYIN + CHES + GIMEL

    // ===========================================
  else if Code.Equals('2a') then
    result := BAIS + SHIN
  else if Code.Equals('2A') then
    result := BAIS + SHIN
  else if Code.Equals('2d') then
    result := BAIS + CHES
  else if Code.Equals('2D') then
    result := BAIS + CHES
  else if Code.Equals('3r') then
    result := GIMEL + CHOF
  else if Code.Equals('3R') then
    result := GIMEL + CHOF
  else if Code.Equals('5a') then
    result := HEY + SHIN
  else if Code.Equals('5A') then
    result := HEY + SHIN
  else if Code.Equals('5d') then
    result := HEY + CHES
  else if Code.Equals('5D') then
    result := HEY + CHES
  else if Code.Equals('5r') then
    result := HEY + CHOF
  else if Code.Equals('7a') then
    result := ZAYIN + SHIN
  else if Code.Equals('7A') then
    result := ZAYIN + SHIN
  else if Code.Equals('7d') then
    result := ZAYIN + CHES
  else if Code.Equals('7D') then
    result := ZAYIN + CHES

  else
    Beep;
end;

//function TfrmMain.UpdateTekufah(Tekufah: TTekufah;
//  ADays, AHours, AMins: Cardinal): Boolean;
//begin
//  Tekufah.Days := ADays;
//  Tekufah.Hours := Tekufah.Hours + AHours;
//  Tekufah.Minutes := Tekufah.Minutes + AMins;
//  if Tekufah.Minutes = 60 then
//  begin
//    Tekufah.Minutes := 0;
//    Tekufah.Hours := Tekufah.Hours + 1;
//  end;
//  if Tekufah.Hours > 24 then
//  begin
//    Tekufah.Hours := Tekufah.Hours - 24;
//    Tekufah.Days := Tekufah.Days + 1;
//  end;
//  Tekufah.TekDate:=Tekufah.TekDate+Tekufah.Days;
//end;
//

// function TfrmMain.CalNissanTekufah(TekufaYear: Integer): TTekufah;
// begin
// result:=CalTevesTekufah(TekufaYear);
// resut:=UpdateTekufah(91, 7,30);
// result.Days:=91;
// result.Hours:=result.Hours+7;
// result.Minutes:=result.Minutes+30;
// if result.Minutes=60 then
// begin
// result.Minutes:=0;
// result.Hours:=result.Hours+1;
// end;
// if result.Hours>24 then
// begin
// result.Hours:=result.Hours-24;
// result.Days:=result.Days+1;
// end;
// result.TekDate:=result.TekDate+result.Days;
// end;

function TfrmMain.IsInYearCideArray(YearCode: String): Boolean;
var
  k: Integer;
begin
  result := False;
  for k := 0 To Length(YearCodeArray) - 1 do
  begin
    if YearCode = YearCodeArray[k] then
    begin
      result := True;
      Break;
    end;
  end;
end;

procedure TfrmMain.Button8Click(Sender: TObject);
var
  k, Matches, StartYear: Integer;
  YearCode: String;
  HebYear: THebYear;
begin
  lvGeneral.Clear;

  StartYear := StrToInt(edtHebYear.Text);
  HebYear := THebYear.Create;
  try
    Matches := 0;
    for k := StartYear to StartYear + seNoOfYears.Value - 1 do
    begin
      HebYear.HYear := k;
      HebYear.HMonth := 1;
      HebYear.CalcNextYearsNewYearsDay;
      edtYearCode.Text := HebYear.YearCode.ToString;
      YearCode := edtYearCode.Text;

      if not chkExcludeYC.Checked then
      begin
        if (Length(YearCodeArray) = 0) or (YearCode.StartsWith(cboYCFilter.Text)
          ) or IsInYearCideArray(YearCode) then
        begin
          Inc(Matches);
          if HebYear.YearISLeapYear then
            Log(k.ToString, YearCode, 'L/' + HebYear.YearInCycle.ToString,
              LogFilter(YearCode))
          else
            Log(k.ToString, YearCode, HebYear.YearInCycle.ToString,
              LogFilter(YearCode));
        end
      end
      else
      begin
        if (Length(YearCodeArray) = 0) or
          not YearCode.StartsWith(cboYCFilter.Text) or
          not IsInYearCideArray(YearCode) then
        begin
          Inc(Matches);
          if HebYear.YearISLeapYear then
            Log(k.ToString, YearCode, 'L/' + HebYear.YearInCycle.ToString,
              LogFilter(YearCode))
          else
            Log(k.ToString, YearCode, HebYear.YearInCycle.ToString,
              LogFilter(YearCode));
        end
      end;
      Caption := Matches.ToString + ' year(s) found';
      Application.ProcessMessages;
    end;
  finally
    HebYear.Free;
  end;
end;

procedure TfrmMain.ScanNYears(ForwardDirection: Boolean);
var
  k: Integer;
  Molad: TDHP;
  HebYear: THebYear;
  SaveYearCode: String;
begin
  lvGeneral.Clear;

  SaveYearCode := Trim(edtYearCode.Text);
  HebYear := THebYear.Create;
  try
    for k := 1 to seNoOfYears.Value do
    begin
      if ForwardDirection then
        HebYear.HYear := StrToInt(edtHebYear.Text) + 1
      else
        HebYear.HYear := StrToInt(edtHebYear.Text) - 1;
      edtHebYear.Text := IntToStr(HebYear.HYear);
      HebYear.HMonth := 1;
      HebYear.CalcNextYearsNewYearsDay;
      if SaveYearCode.Trim.Length = 2 then
      begin
        // if copy(SaveYearCode,1,2)=Copy(HebYear.YearCode.ToString,1,2) then
        // Memo2.Lines.Add(HebYear.Hyear.ToString());
      end
      else
      begin
        // if SaveYearCode=HebYear.YearCode.ToString then
        // Memo2.Lines.Add(HebYear.Hyear.ToString());
      end
    end;
  finally
    HebYear.Free;
  end;
end;

procedure TfrmMain.LoadUearToUear;
begin
  with cboYearToYear do
  begin
    Clear;
    Items.Add('');
    // Monday
    Items.Add(Mon2Thu);
    Items.Add(Mon2Sha);
    Items.Add(Mon2Mon);
    // Tuesday
    Items.Add(Tue2Sha);
    Items.Add(Tue2Mon);
    // Thursday
    Items.Add(Thu2Mon);
    Items.Add(Thu2Tue);
    Items.Add(Thu2Thu);
    // Shabbos
    Items.Add(Sha2Tue);
    Items.Add(Sha2Thu);
    Items.Add(Sha2Sha);
  end;
end;

procedure TfrmMain.Log(AText1, AText2, AText3, AText4: String);
var
  li: TListItem;
begin
  li := lvGeneral.Items.Add;
  li.Caption := AText1;
  li.SubItems.Add(AText2);
  li.SubItems.Add(AText3);
  li.SubItems.Add(AText4);
end;

function TfrmMain.LogFilter(YearCode: String): String;
begin
  result := '';
  if cboYCFilter.Text <> '' then
    result := cboYCFilter.Text
  else if cboYearToYear.Text <> '' then
    result := cboYearToYear.Text
    // Monday
  else if YearCode.StartsWith(BAIS) and YearCode.EndsWith(GIMEL) then
    result := Mon2Thu
  else if YearCode.StartsWith(BAIS) and YearCode.EndsWith(HEY) then
    result := Mon2Sha
  else if YearCode.StartsWith(BAIS) and YearCode.EndsWith(ZAYIN) then
    result := Mon2Mon
    // Tuesday
  else if YearCode.StartsWith(GIMEL) and YearCode.EndsWith(HEY) then
    result := Tue2Sha
  else if YearCode.StartsWith(GIMEL) and YearCode.EndsWith(ZAYIN) then
    result := Tue2Mon
    // Thursday
    // else if YearCode.StartsWith(HEY) and YearCode.EndsWith(HEY) then
    // result:=Thu2Sha
  else if YearCode.StartsWith(HEY) and YearCode.EndsWith(ZAYIN) then
    result := Thu2Mon
  else if YearCode.StartsWith(HEY) and YearCode.EndsWith(ALEPH) then
    result := Thu2Tue
  else if YearCode.StartsWith(HEY) and YearCode.EndsWith(GIMEL) then
    result := Thu2Thu

    // Shabbos
  else if YearCode.StartsWith(ZAYIN) and YearCode.EndsWith(ALEPH) then
    result := Sha2Tue
  else if YearCode.StartsWith(ZAYIN) and YearCode.EndsWith(GIMEL) then
    result := Sha2Thu
  else if YearCode.StartsWith(ZAYIN) and YearCode.EndsWith(HEY) then
    result := Sha2Sha;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
  HebDate, NewHenDate: THebDate;
begin
  // Application.BiDiKeyboard:='0000040D';
  YC1Dict := TDictionary<String, Integer>.Create;
  YC2Dict := TDictionary<String, Integer>.Create;
  YC3Dict := TDictionary<String, Integer>.Create;
  edtHebYear.Text := IntToStr(3760 + StrToInt(FormatDateTime('yyyy', Date)));

  LoadUearToUear;
  Button2.Caption := H_MOLAD;
  Button3.Caption := H_ROSH_HASHONNOH;
  Button7.Caption := H_TEKUFAH;

  cboYCFilter.Items.Add('');
  // YC-1
  cboYCFilter.Items.Add(BAIS);
  cboYCFilter.Items.Add(GIMEL);
  cboYCFilter.Items.Add(HEY);
  cboYCFilter.Items.Add(ZAYIN);

  // TC-2
  cboYCFilter.Items.Add(BAIS + CHES);
  cboYCFilter.Items.Add(BAIS + SHIN);
  cboYCFilter.Items.Add(GIMEL + CHOF);
  cboYCFilter.Items.Add(HEY + CHES);
  cboYCFilter.Items.Add(HEY + CHOF);
  cboYCFilter.Items.Add(HEY + SHIN);
  cboYCFilter.Items.Add(ZAYIN + CHES);
  cboYCFilter.Items.Add(ZAYIN + SHIN);

  // TC-3
  cboYCFilter.Items.Add(BAIS + CHES + GIMEL);
  cboYCFilter.Items.Add(BAIS + CHES + HEY);
  cboYCFilter.Items.Add(BAIS + SHIN + HEY);
  cboYCFilter.Items.Add(BAIS + SHIN + ZAYIN);
  cboYCFilter.Items.Add(GIMEL + CHOF + HEY);
  cboYCFilter.Items.Add(GIMEL + CHOF + ZAYIN);
  cboYCFilter.Items.Add(HEY + CHES + ALEPH);
  cboYCFilter.Items.Add(HEY + CHOF + ZAYIN);
  cboYCFilter.Items.Add(HEY + SHIN + ALEPH);
  cboYCFilter.Items.Add(HEY + SHIN + GIMEL);
  cboYCFilter.Items.Add(ZAYIN + CHES + ALEPH);
  cboYCFilter.Items.Add(ZAYIN + CHES + GIMEL);
  cboYCFilter.Items.Add(ZAYIN + SHIN + GIMEL);
  cboYCFilter.Items.Add(ZAYIN + SHIN + HEY);
  cboYCFilter.ItemIndex := 0;

  HebDate := THebDate.Create(5785, 11, 29);
  NewHenDate := HebDate.AddMonths(1);
  if NewHenDate.IsValid then
    Beep;
  NewHenDate := HebDate.AddMonths(2);
  if NewHenDate.IsValid then
    Beep;
  NewHenDate := HebDate.AddMonths(3);
  if NewHenDate.IsValid then
    Beep;

  NewHenDate := HebDate.AddYears(2);
  NewHenDate := NewHenDate.AddMonths(3);
  if NewHenDate.IsValid then
    Beep;

  NewHenDate := HebDate.AddYears(3);
  NewHenDate := NewHenDate.AddMonths(3);
  if NewHenDate.IsValid then
    Beep;

end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  YC1Dict.Free;
  YC2Dict.Free;
  YC3Dict.Free;
end;

procedure TfrmMain.InitDict;
begin
  YC1Dict.Clear;
  YC1Dict.Add(BAIS, 0);
  YC1Dict.Add(GIMEL, 0);
  YC1Dict.Add(HEY, 0);
  YC1Dict.Add(ZAYIN, 0);

  YC2Dict.Clear;
  YC2Dict.Add(BAIS + CHES, 0);
  YC2Dict.Add(BAIS + SHIN, 0);
  YC2Dict.Add(GIMEL + CHOF, 0);
  YC2Dict.Add(HEY + CHOF, 0);
  YC2Dict.Add(HEY + SHIN, 0);
  YC2Dict.Add(HEY + CHES, 0);
  YC2Dict.Add(ZAYIN + CHES, 0);
  YC2Dict.Add(ZAYIN + SHIN, 0);

  YC3Dict.Clear;
  YC3Dict.Add(BAIS + CHES + GIMEL, 0);
  YC3Dict.Add(BAIS + CHES + HEY, 0);
  YC3Dict.Add(BAIS + SHIN + HEY, 0);
  YC3Dict.Add(BAIS + SHIN + ZAYIN, 0);

  YC3Dict.Add(GIMEL + CHOF + HEY, 0);
  YC3Dict.Add(GIMEL + CHOF + ZAYIN, 0);

  YC3Dict.Add(HEY + CHES + ALEPH, 0);
  YC3Dict.Add(HEY + CHOF + ZAYIN, 0);
  YC3Dict.Add(HEY + SHIN + ALEPH, 0);
  YC3Dict.Add(HEY + SHIN + GIMEL, 0);

  YC3Dict.Add(ZAYIN + CHES + ALEPH, 0);
  YC3Dict.Add(ZAYIN + CHES + GIMEL, 0);
  YC3Dict.Add(ZAYIN + SHIN + GIMEL, 0);
  YC3Dict.Add(ZAYIN + SHIN + HEY, 0);
end;

procedure TfrmMain.Log(AText1, AText2, AText3: String);
var
  li: TListItem;
begin
  li := lvGeneral.Items.Add;
  li.Caption := AText1;
  li.SubItems.Add(AText2);
  li.SubItems.Add(AText3);
end;

procedure TfrmMain.Memo1DblClick(Sender: TObject);
begin
  lvGeneral.Clear;
end;

end.
