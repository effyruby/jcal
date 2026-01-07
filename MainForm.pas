unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Classes, System.Generics.Collections,
  Controls, Forms, Vcl.Graphics, Dialogs, StdCtrls, CodeSiteLogging, ComCtrls, Vcl.Samples.Spin,
  TntComCtrls, ALEPHBET, MILON, Unit2;

const
  MAXYEARS=100;

type
  TfrmMain = class(TForm)
    edtHebYear: TEdit;
    Button1: TButton;
    Edit2: TEdit;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    ComboBoxEx1: TComboBoxEx;
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
    lvFiltered: TListView;
    tsLogging: TTntTabSheet;
    Memo2: TMemo;
    procedure Button1Click(Sender: TObject);
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
  private
    { Private declarations }
    YC1Dict: TDictionary<String, Integer>;
    YC2Dict: TDictionary<String, Integer>;
    YC3Dict: TDictionary<String, Integer>;
    ErrorCount: Integer;
    procedure InitDict;
    procedure ScanNYears(ForwardDirection: Boolean);
    procedure Log(AText: String); overload;
    procedure Log(AText1, AText2: String); overload;
    procedure Log(AText1, AText2, AText3: String); overload;
  public
    { Public declarations }
    function CalTevesTekufah(TekufaYear: Integer): TTekufah;
//    function CalNissanTekufah(TekufaYear: Integer): TTekufah;
    function UpdateTekufah(Tekufah: TTekufah; ADays: Cardinal=91;
       AHours: Cardinal=7; AMins: Cardinal=30): TTekufah;
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
  li:=lvGeneral.Items.Add;
  li.Caption:=AText;
end;

procedure TfrmMain.Log(AText1, AText2: String);
var
  li: TListItem;
begin
  li:=lvGeneral.Items.Add;
  li.Caption:=AText1;
  li.SubItems.Add(AText2);
end;


procedure TfrmMain.Button1Click(Sender: TObject);
var
  k: Integer;
  HebYear: THebYear;
begin
  lvGeneral.Clear;
  lvFiltered.Clear;

  HebYear:=THebYear.Create;
  try
    HebYear.HYear:=StrToInt(edtHebYear.Text);
    HebYear.CalcNewYearsDay;
    for k:=1 to HebYear.MonthsInYear do
    begin
      Log(HebYear.HebMonthName(k));
    end;
  finally
   HebYear.Free;
  end;
end;

procedure TfrmMain.Button2Click(Sender: TObject);
var
  k: Integer;
  Molad: TDHP;
  HebYear: THebYear;
begin
  lvGeneral.Clear;
  lvFiltered.Clear;

  HebYear:=THebYear.Create;
  try
    HebYear.HYear:=StrToInt(edtHebYear.Text);
    HebYear.CalcNewYearsDay;
    for k:=1 to HebYear.MonthsInYear do
    begin
      HebYear.HMonth:=k;
      Molad:=HebYear.CalcMolad;
      Log(H_MOLAD+SPACE+HebYear.HebMonthName(k), Molad.DHMPToString);
    end;
//    ShowMessage(IntToStr(Molad.Hour));
//    ShowMessage(IntToStr(HebYear.GetMinute(Molad)));
//    ShowMessage(IntToStr(HebYear.GetPart(Molad)));
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
  lvFiltered.Clear;

  SaveYearCode:=edtYearCode.Text;
  HebYear:=THebYear.Create;
  try
    HebYear.HYear:=StrToInt(edtHebYear.Text);
    HebYear.HMonth:=1;
    HebYear.CalcNextYearsNewYearsDay;
    edtYearCode.Text:=HebYear.YearCode.ToString;
    if HebYear.YearISLeapYear then
      edtYearCode.Font.Style:=[fsBold]
    else
      edtYearCode.Font.Style:=[];
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
  ErrorCount:=0;
  lvGeneral.Clear;
  InitDict;

  Button4.Enabled:=False;
  try
    for k:= 1 to MAXYEARS do
    begin
      codeSite.AddCheckPoint;
      codeSite.Send('k', k);
      Log('year: '+IntToStr(k));
      HebYear1:=THebYear.Create;
      HebYear1.HYear:=k;
      HebYear1.HMonth:=1;
      HebYear1.CalcNextYearsNewYearsDay;

      HebYear2:=THebYear.Create;
      HebYear2.HYear:=k+1;
      HebYear2.HMonth:=1;
      HebYear2.CalcNewYearsDay;

      if HebYear2.YearCode.NewYearOn<>HebYear1.NextYearsNewYearOn then
      begin
        Memo2.Lines.Add(HebYear1.Molad.DHPToString);
        Memo2.Lines.Add(HebYear2.Molad.DHPToString);
        Memo2.Lines.Add('');

        Memo2.Lines.Add('Error: year: '+IntToStr(k)+'mof 19: '+IntToStr(k mod 19));
        Memo2.Lines.Add('HebYear1: NYD: '+DaysOfWeek[Ord(HebYear1.YearCode.NewYearOn)]);
        Memo2.Lines.Add('HebYear1: NY-NYD: '+DaysOfWeek[Ord(HebYear1.NextYearsNewYearOn)]);
        Memo2.Lines.Add('HebYear2: NYDL '+DaysOfWeek[Ord(HebYear2.YearCode.NewYearOn)]);
        Memo2.Lines.Add('HebYear1: '+IntToStr(HebYear1.DaysInYear));
        Memo2.Lines.Add('HebYear1: '+IntToStr(HebYear1.DaysInYear mod 7));
        Memo2.Lines.Add('HebYear2: '+DaysOfWeek[Ord(HebYear2.YearCode.NewYearOn)]);
        Inc(ErrorCount);
        Memo2.Lines.Add('HebYear2: '+IntToStr(ErrorCount));
        Application.ProcessMessages;
      end;

      YC3:=HebYear1.YearCode.ToString;
      YC2:=LowerCase(Copy(YC3,1,2));
      YC1:=Copy(YC3,1,1);
      if YC3Dict.TryGetValue(YC3, Incidents) then
      begin
        inc(Incidents);
        YC3Dict.AddOrSetValue(YC3, Incidents);
      end
      else
        Beep;

      if YC2Dict.TryGetValue(YC2, Incidents) then
      begin
        inc(Incidents);
        YC2Dict.AddOrSetValue(YC2, Incidents);
      end
      else
        Beep;

      if YC1Dict.TryGetValue(YC1, Incidents) then
      begin
        inc(Incidents);
        YC1Dict.AddOrSetValue(YC1, Incidents);
      end
      else
        Beep;

    end;

    CodeSite.AddSeparator;
    Application.ProcessMessages;
    for k:=0 to Length(YC3Digits)-1 do
    begin
      Key:=YC3Digits[k];
      Incidents:=YC3Dict.Items[Key];
      Percent:=100*Incidents/MAXYEARS;
      li:=ListView1.Items.Add;
      li.Caption:=Key;
      li.subItems.Add(Incidents.ToString);
      li.subItems.Add(Format ('%.2f', [Percent]));
    end;

    Application.ProcessMessages;
    for k:=0 to Length(YC2Digits)-1 do
    begin
      Key:=YC2Digits[k];
      Incidents:=YC2Dict.Items[Key];
      Percent:=100*Incidents/6000;
      li:=ListView2.Items.Add;
      li.Caption:=Key;
      li.subItems.Add(Incidents.ToString);
      li.subItems.Add(Format ('%.2f', [Percent]));
    end;

    Application.ProcessMessages;
    for k:=0 to Length(YC1Digits)-1 do
    begin
      Key:=YC1Digits[k];
      Incidents:=YC1Dict.Items[Key];
      Percent:=100*Incidents/6000;
      li:=ListView3.Items.Add;
      li.Caption:=Key;
      li.subItems.Add(Incidents.ToString);
      li.subItems.Add(Format ('%.2f', [Percent]));
    end;
  finally
    Button4.Enabled:=True;
  end;
end;

procedure TfrmMain.Button5Click(Sender: TObject);
begin
  ScanNYears(False);
end;

procedure TfrmMain.Button6Click(Sender: TObject);
begin
  ScanNYears(true);
end;

procedure TfrmMain.DisplayTekufah(HebMonrg: String; Tekufah: TTekufah);
var
  li: TListItem;
begin
  li:=lvGeneral.Items.Add;
  li.Caption:=HebMonrg;
  li.SubItems.Add(Tekufah.TekDow);
  li.SubItems.Add(Tekufah.TekDateToString);
  li.SubItems.Add(Tekufah.TekTime);
end;

procedure TfrmMain.Button7Click(Sender: TObject);
var
  k, YearOfInterest: Integer;
  Tekufah: TTekufah;
begin
  lvGeneral.Clear;
  lvFiltered.Clear;

  for k:=0 to seNoOfYears.Value-1 do
  begin
    YearOfInterest:=k+StrToInt(edtHebYear.Text);
    Tekufah:=CalTevesTekufah(YearOfInterest);
    DisplayTekufah(H_TEKUFAS+' '+TEVES, Tekufah);

    Tekufah:=UpdateTekufah(Tekufah);
    DisplayTekufah(H_TEKUFAS+' '+NISSAN, Tekufah);

    Tekufah:=UpdateTekufah(Tekufah);
    DisplayTekufah(H_TEKUFAS+' '+TAMMUZ, Tekufah);

    Tekufah:=UpdateTekufah(Tekufah);
    DisplayTekufah(H_TEKUFAS+' '+TISHREI, Tekufah);
  end;
end;

function TfrmMain.CalTevesTekufah(TekufaYear: Integer): TTekufah;
var
  NoOfYears: Cardinal;
  NewHours, NDays, NHours: Cardinal;
 StartTekufah: TTekufah;
begin
  with StartTekufah do
  begin
    TekDate:=StrToDate('06/01/1905');
    Hours:=10;
    Minutes:=30;
  end;

  with result do
  begin
    Minutes:=30;
  end;

  NoOfYears:=TekufaYear-1905;
  CodeSite.Send( 'NoOfYears', NoOfYears );
  NDays:=NoOfYears*365;
  CodeSite.Send( 'NDays', NDays );
  NHours:=NoOfYears*6;
  CodeSite.Send( 'NHours', NHours );
  NewHours:=NHours mod 24;
  NDays:=NDays+(NHours div 24);
  result.Days:=NDays;
  result.Hours:=NewHours;

  result.TekDate:=StartTekufah.TekDate+result.Days;
  result.Hours:=result.Hours+StartTekufah.Hours;
  result.DayOfWeek:=DayOfWeek(result.TekDate);

  if result.Hours >24 then
  begin
    result.Hours:=result.Hours-24;
    result.TekDate:=result.TekDate+1;
    result.DayOfWeek:=DayOfWeek(result.TekDate);
  end;
  CodeSite.Send( 'data', result.TekTime);
end;

function TfrmMain.UpdateTekufah(Tekufah: TTekufah; ADays, AHours, AMins: Cardinal): TTekufah;
begin
  result:=Tekufah;
  result.Days:=ADays;
  result.Hours:=result.Hours+AHours;
  result.Minutes:=result.Minutes+AMins;
  if result.Minutes=60 then
  begin
    result.Minutes:=0;
    result.Hours:=result.Hours+1;
  end;
  if result.Hours>24 then
  begin
    result.Hours:=result.Hours-24;
    result.Days:=result.Days+1;
  end;
  result.TekDate:=result.TekDate+result.Days;
end;


//function TfrmMain.CalNissanTekufah(TekufaYear: Integer): TTekufah;
//begin
//  result:=CalTevesTekufah(TekufaYear);
//  resut:=UpdateTekufah(91, 7,30);
//  result.Days:=91;
//  result.Hours:=result.Hours+7;
//  result.Minutes:=result.Minutes+30;
//  if result.Minutes=60 then
//  begin
//    result.Minutes:=0;
//    result.Hours:=result.Hours+1;
//  end;
//  if result.Hours>24 then
//  begin
//    result.Hours:=result.Hours-24;
//    result.Days:=result.Days+1;
//  end;
//  result.TekDate:=result.TekDate+result.Days;
//end;


procedure TfrmMain.Button8Click(Sender: TObject);
var
  k, StartYear: Integer;
  HebYear: THebYear;
begin
  lvGeneral.Clear;
  lvFiltered.Clear;

  StartYear:=StrToInt(edtHebYear.Text);
  HebYear:=THebYear.Create;
  try
    for k:=StartYear to StartYear+seNoOfYears.Value-1 do
    begin
      HebYear.HYear:=k;
      HebYear.HMonth:=1;
      HebYear.CalcNextYearsNewYearsDay;
      edtYearCode.Text:=HebYear.YearCode.ToString;
      if HebYear.YearISLeapYear then
        Log(k.ToString,edtYearCode.Text,'L/'+HebYear.YearInCycle.ToString)
      else
        Log(k.ToString,edtYearCode.Text, HebYear.YearInCycle.ToString);
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
  lvFiltered.Clear;

  SaveYearCode:=Trim(edtYearCode.Text);
  HebYear:=THebYear.Create;
  try
  for k:=1 to seNoOfYears.Value do
  begin
    if ForwardDirection then
      HebYear.HYear:=StrToInt(edtHebYear.Text)+1
    else
      HebYear.HYear:=StrToInt(edtHebYear.Text)-1;
    edtHebYear.Text:=IntToStr(HebYear.HYear);
    HebYear.HMonth:=1;
    HebYear.CalcNextYearsNewYearsDay;
    if SaveYearCode.Trim.Length=2 then
    begin
//      if copy(SaveYearCode,1,2)=Copy(HebYear.YearCode.ToString,1,2) then
//        Memo2.Lines.Add(HebYear.Hyear.ToString());
    end
    else
    begin
//      if SaveYearCode=HebYear.YearCode.ToString then
//        Memo2.Lines.Add(HebYear.Hyear.ToString());
    end
  end;
  finally
    HebYear.Free;
  end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
//Application.BiDiKeyboard:='0000040D';
  YC1Dict:=TDictionary<String, Integer>.Create;
  YC2Dict:=TDictionary<String, Integer>.Create;
  YC3Dict:=TDictionary<String, Integer>.Create;
  edtHebYear.Text:= IntToStr(3760+StrToInt(FormatDateTime('yyyy', Date)));

  Button2.Caption:=H_MOLAD;
  Button3.Caption:=H_ROSH_HASHONNOH;
  Button7.Caption:=H_TEKUFAH;
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
  YC1Dict.Add('2', 0);
  YC1Dict.Add('3', 0);
  YC1Dict.Add('5', 0);
  YC1Dict.Add('7', 0);

  YC2Dict.Clear;
  YC2Dict.Add('2d', 0);
  YC2Dict.Add('2a', 0);
  YC2Dict.Add('3r', 0);
  YC2Dict.Add('5r', 0);
  YC2Dict.Add('5a', 0);
  YC2Dict.Add('5d', 0);
  YC2Dict.Add('7d', 0);
  YC2Dict.Add('7a', 0);

  YC3Dict.Clear;
  YC3Dict.Add('2d3', 0);
  YC3Dict.Add('2a5', 0);
  YC3Dict.Add('3r5', 0);
  YC3Dict.Add('5r7', 0);
  YC3Dict.Add('5a1', 0);
  YC3Dict.Add('7d1', 0);
  YC3Dict.Add('7a3', 0);

  YC3Dict.Add('2D5', 0);
  YC3Dict.Add('2A7', 0);
  YC3Dict.Add('3R7', 0);
  YC3Dict.Add('5D1', 0);
  YC3Dict.Add('5A3', 0);
  YC3Dict.Add('7D3', 0);
  YC3Dict.Add('7A5', 0);
end;

procedure TfrmMain.Log(AText1, AText2, AText3: String);
var
  li: TListItem;
begin
  li:=lvGeneral.Items.Add;
  li.Caption:=AText1;
  li.SubItems.Add(AText2);
  li.SubItems.Add(AText3);
end;

procedure TfrmMain.Memo1DblClick(Sender: TObject);
begin
  lvGeneral.Clear;
end;

end.

