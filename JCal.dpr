program JCal;

uses
  Forms,
  MainForm in 'MainForm.pas' {frmMain},
  HebDateClass in 'HebDateClass.pas',
  Vcl.Themes,
  Vcl.Styles,
  AlephBet in 'AlephBet.pas',
  Milon in 'Milon.pas',
  JCalTypes in 'JCalTypes.pas',
  JCalUtils in 'JCalUtils.pas',
  JCalConstants in 'JCalConstants.pas',
  FestivalsRecord in 'FestivalsRecord.pas';

{$R *.RES}

begin
  Application.Initialize;
  TStyleManager.TrySetStyle('Amakrits');
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
