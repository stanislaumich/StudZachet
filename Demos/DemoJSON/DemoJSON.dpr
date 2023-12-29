program DemoJSON;

uses
  Vcl.Forms,
  UnitJSON in 'UnitJSON.pas' {FormJSON};

{$R *.res}

begin
{$IfDef Delphi10}
  ReportMemoryLeaksOnShutdown := True;
{$EndIf}
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormJSON, FormJSON);
  Application.Run;
end.
