unit DHPRecord;

interface

uses System.SysUtils;

type
  TDHP=record
  Day: Integer;
  Hour: Integer;
  Part: Integer;
  function BeforeMusaf: Boolean;
  function Before9204: Boolean;
  function Before15589: Boolean;
  function DHPToParts: Integer;
  function HPToParts: Integer;
  function DHPToString: String;
  function DHMPToString: String;
end;


implementation
function TDHP.BeforeMusaf: Boolean;
begin
  {$IFDEF CS2}CodeSite.EnterMethod( 'THebDate.BeforeMusaf' );{$ENDIF}
  result:=Hour<18;
  {$IFDEF CS2}CodeSite.ExitMethod( 'THebDate.BeforeMusaf' );{$ENDIF}
end;

function TDHP.DHPToParts: Integer;
begin
  result:=((24*Day+Hour)*1080)+Part;
end;

function TDHP.DHPToString: String;
begin
  result:=IntToStr(Day)+','+IntToStr(Hour)+','+IntToStr(Part);
end;

function TDHP.DHMPToString: String;
var
  _Minute, _Part: Integer;
begin
  _Part:=Part mod 18;
  _Minute:=Part div 18;
  result:=IntToStr(Day)+','+IntToStr(Hour)+','+IntToStr(_Minute)+','+IntToStr(_Part);
end;

function TDHP.HPToParts: Integer;
begin
  result:=Hour*1080+Part;
end;

function TDHP.Before15589: Boolean;
begin
  {$IFDEF CS2}CodeSite.EnterMethod( 'THebDate.Before16589' );{$ENDIF}
  result:=HPToParts<15*1080+589;
  {$IFDEF CS2}CodeSite.ExitMethod( 'THebDate.Before16589' );{$ENDIF}
end;

function TDHP.Before9204: Boolean;
begin
  {$IFDEF CS2}CodeSite.EnterMethod( 'THebDate.Before9204' );{$ENDIF}
  result:=Hour*1080+Part<9*1080+204;
  {$IFDEF CS2}CodeSite.ExitMethod( 'THebDate.Before9204' );{$ENDIF}
end;


end.
