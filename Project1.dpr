program Project1;

uses
  Forms,
  MainForm in 'MainForm.pas' {frmMain},
  Unit2 in 'Unit2.pas',
  Vcl.Themes,
  Vcl.Styles;

{$R *.RES}

begin
  Application.Initialize;
  TStyleManager.TrySetStyle('Amakrits');
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
